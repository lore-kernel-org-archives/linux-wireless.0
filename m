Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33090 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753248AbdDHSgm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 14:36:42 -0400
Received: by mail-pf0-f176.google.com with SMTP id s16so17163579pfs.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Apr 2017 11:36:42 -0700 (PDT)
Subject: Re: [PATCH 1/5] netlink: extended ACK reporting
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20170408174900.12820-1-johannes@sipsolutions.net>
 <20170408174900.12820-2-johannes@sipsolutions.net>
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us,
        Johannes Berg <johannes.berg@intel.com>
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <14c58480-cd03-4d61-fffa-fab6e437a7ea@cumulusnetworks.com> (sfid-20170408_203746_782324_2B2DC8C1)
Date: Sat, 8 Apr 2017 14:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <20170408174900.12820-2-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/8/17 1:48 PM, Johannes Berg wrote:
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index da14ab61f363..47562e940e9c 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -62,11 +62,41 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
>  	return __netlink_kernel_create(net, unit, THIS_MODULE, cfg);
>  }
>  
> +/**
> + * struct netlink_ext_ack - netlink extended ACK report struct
> + * @_msg: message string to report - don't access directly, use
> + *	%NL_SET_ERR_MSG
> + * @bad_attr: attribute with error
> + * @missing_attr: number of missing attr (or 0)
> + * @cookie: cookie data to return to userspace (for success)
> + * @cookie_len: actual cookie data length
> + */
> +struct netlink_ext_ack {
> +	const char *_msg;
> +	const struct nlattr *bad_attr;
> +	u16 missing_attr;
> +	u8 cookie[NETLINK_MAX_COOKIE_LEN];
> +	u8 cookie_len;
> +};
> +

I think v3 is in your future ...

/home/dsa/kernel-4.git/include/linux/netlink.h:78:12: error:
‘NETLINK_MAX_COOKIE_LEN’ undeclared here (not in a function)
  u8 cookie[NETLINK_MAX_COOKIE_LEN];
            ^

it's defined in patch 3; needed in patch 1
