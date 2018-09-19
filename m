Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43277 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731233AbeISWHj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 18:07:39 -0400
Subject: Re: [PATCH 5/7] netlink: prepare validate extack setting for
 recursion
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20180919120900.28708-1-johannes@sipsolutions.net>
 <20180919120900.28708-6-johannes@sipsolutions.net>
From: David Ahern <dsahern@gmail.com>
Message-ID: <18ea5293-5a12-7aca-7373-12d1ab3a0821@gmail.com> (sfid-20180919_182904_555101_0A54DA1D)
Date: Wed, 19 Sep 2018 09:28:57 -0700
MIME-Version: 1.0
In-Reply-To: <20180919120900.28708-6-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/19/18 5:08 AM, Johannes Berg wrote:
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index 966cd3dcf31b..2b015e43b725 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -69,7 +69,7 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
>  
>  static int validate_nla(const struct nlattr *nla, int maxtype,
>  			const struct nla_policy *policy,
> -			const char **error_msg)
> +			struct netlink_ext_ack *extack, bool *extack_set)

extack_set arg is not needed if you handle the "Attribute failed policy
validation" message and NL_SET_BAD_ATTR here as well.
