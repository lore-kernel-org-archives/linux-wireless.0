Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43112 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbeINAlD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 20:41:03 -0400
Date: Thu, 13 Sep 2018 16:30:04 -0300
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
Message-ID: <20180913193004.GF4590@localhost.localdomain> (sfid-20180913_213016_518986_77F90FD8)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180913084603.7979-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2018 at 10:46:02AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In some situations some netlink attributes may be used for output
> only (kernel->userspace) or may be reserved for future use. It's
> then helpful to be able to prevent userspace from using them in
> messages sent to the kernel, since they'd otherwise be ignored and
> any future will become impossible if this happens.

I don't follow, what's the issue with simply ignoring such attributes?

> 
> Add NLA_REJECT to the policy which does nothing but reject (with
> EINVAL) validation of any messages containing this attribute.
> Allow for returning a specific extended ACK error message in the
> validation_data pointer.

This has potential to create confusion because we can't use it on
{output,reserved} attributes that are already there (as we must always
ignore them now) and we will end up with a mix of it.

> 
> While at it fix the indentation of NLA_BITFIELD32 and describe the
> validation_data pointer for it.
> 
> The specific case I have in mind now is a shared nested attribute
> containing request/response data, and it would be pointless and
> potentially confusing to have userspace include response data in
> the messages that actually contain a request.

Would be nice to see some patches for it too. Maybe it helps.

> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/netlink.h |  6 +++++-
>  lib/nlattr.c          | 22 +++++++++++++++-------
>  2 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 0c154f98e987..04e40fcc70d6 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -180,6 +180,7 @@ enum {
>  	NLA_S32,
>  	NLA_S64,
>  	NLA_BITFIELD32,
> +	NLA_REJECT,
>  	__NLA_TYPE_MAX,
>  };
>  
> @@ -208,7 +209,10 @@ enum {
>   *    NLA_MSECS            Leaving the length field zero will verify the
>   *                         given type fits, using it verifies minimum length
>   *                         just like "All other"
> - *    NLA_BITFIELD32      A 32-bit bitmap/bitselector attribute
> + *    NLA_BITFIELD32       A 32-bit bitmap/bitselector attribute, validation
> + *                         data must point to a u32 value of valid flags
> + *    NLA_REJECT           Reject this attribute, validation data may point
> + *                         to a string to report as the error in extended ACK.
>   *    All other            Minimum length of attribute payload
>   *
>   * Example:
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index e335bcafa9e4..56e0aae5cf23 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -69,7 +69,8 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
>  }
>  
>  static int validate_nla(const struct nlattr *nla, int maxtype,
> -			const struct nla_policy *policy)
> +			const struct nla_policy *policy,
> +			struct netlink_ext_ack *extack)
>  {
>  	const struct nla_policy *pt;
>  	int minlen = 0, attrlen = nla_len(nla), type = nla_type(nla);
> @@ -87,6 +88,11 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
>  	}
>  
>  	switch (pt->type) {
> +	case NLA_REJECT:
> +		if (pt->validation_data && extack)
> +			extack->_msg = pt->validation_data;
> +		return -EINVAL;
> +
>  	case NLA_FLAG:
>  		if (attrlen > 0)
>  			return -ERANGE;
> @@ -180,11 +186,10 @@ int nla_validate(const struct nlattr *head, int len, int maxtype,
>  	int rem;
>  
>  	nla_for_each_attr(nla, head, len, rem) {
> -		int err = validate_nla(nla, maxtype, policy);
> +		int err = validate_nla(nla, maxtype, policy, extack);
>  
>  		if (err < 0) {
> -			if (extack)
> -				extack->bad_attr = nla;
> +			NL_SET_BAD_ATTR(extack, nla);
>  			return err;
>  		}
>  	}
> @@ -251,10 +256,13 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
>  
>  		if (type > 0 && type <= maxtype) {
>  			if (policy) {
> -				err = validate_nla(nla, maxtype, policy);
> +				err = validate_nla(nla, maxtype, policy,
> +						   extack);
>  				if (err < 0) {
> -					NL_SET_ERR_MSG_ATTR(extack, nla,
> -							    "Attribute failed policy validation");
> +					NL_SET_BAD_ATTR(extack, nla);
> +					if (extack && !extack->_msg)
> +						NL_SET_ERR_MSG(extack,
> +							       "Attribute failed policy validation");
>  					goto errout;
>  				}
>  			}
> -- 
> 2.14.4
> 
