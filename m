Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726450AbeIMP6w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 11:58:52 -0400
Date: Thu, 13 Sep 2018 12:49:55 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
Message-ID: <20180913104955.GE29691@unicorn.suse.cz> (sfid-20180913_125005_119422_3CC31502)
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
> 
> Add NLA_REJECT to the policy which does nothing but reject (with
> EINVAL) validation of any messages containing this attribute.
> Allow for returning a specific extended ACK error message in the
> validation_data pointer.
> 
> While at it fix the indentation of NLA_BITFIELD32 and describe the
> validation_data pointer for it.
> 
> The specific case I have in mind now is a shared nested attribute
> containing request/response data, and it would be pointless and
> potentially confusing to have userspace include response data in
> the messages that actually contain a request.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> ...
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

Technically, this would change the outcome when nla_parse() is called
with extack->_msg already set nad validate_nla() fails on something else
than NLA_REJECT; it will preserve the previous message in such case.
But I don't think this is a serious problem.

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
