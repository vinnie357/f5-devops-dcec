FROM vinnie357/f5-devops-base:latest

ENV USERNAME="f5-devops" \
    TERRAFORM_VERSION="1.0.5" \
    TERRAFORMDOCS_VERSION="0.15.0" \
    ANSIBLE_VERSION="2.10.5" \
    VESCTL_VERSION="0.2.15" \
    NODE_VERSION="lts/*" \
    NVM_DIR="/usr/local/share/nvm" \
    RUBY_VERSION="2.7.2" \
    GCLOUD_VERSION="" \
    AWSCLI_VERSION="" \
    AZCLI_VERSION="" 

USER root

COPY scripts-library/ubuntu/* /tmp/scripts/

# terraform, terraform-docs, pulumi, ansible, vesctl, nodejs
RUN set -ex \
    && apt-get update \
    && bash /tmp/scripts/terraform-debian.sh "${TERRAFORM_VERSION}" \
    && bash /tmp/scripts/terraform-docs-debian.sh "${TERRAFORMDOCS_VERSION}" \
    && bash /tmp/scripts/pulumi-debian.sh ${PULUMI_VERSION} \
    && bash /tmp/scripts/node-debian.sh ${NVM_DIR} ${NODE_VERSION} ${USERNAME} \
    && bash /tmp/scripts/ansible-debian.sh ${ANSIBLE_VERSION} \
    && bash /tmp/scripts/vesctl-debian.sh ${VESCTL_VERSION}
# add cloud clis
RUN set -ex \
    #https://github.com/vinnie357/scripts-library/tree/main/ubuntu
    && bash /tmp/scripts/gcloud-debian.sh ${GCLOUD_VERSION} \
    && bash /tmp/scripts/awscli2-debian.sh ${AWSCLI_VERSION}\
    && bash /tmp/scripts/awsiam-debian.sh "${USERNAME}" \
    && bash /tmp/scripts/azcli-debian.sh ${AZCLI_VERSION}
# Clean up
RUN set -ex \
&& apt-get autoremove -y && apt-get clean -y && rm -rf /tmp/scripts && rm -rf /var/lib/apt/lists/*

#change user
USER ${USERNAME}