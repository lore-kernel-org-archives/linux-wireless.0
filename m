Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50098 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726919AbeIMRIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 13:08:00 -0400
Date: Thu, 13 Sep 2018 13:58:49 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/2] netlink: add ethernet address policy types
Message-ID: <20180913115849.GF29691@unicorn.suse.cz> (sfid-20180913_135858_079175_5ED11459)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
 <20180913084603.7979-2-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180913084603.7979-2-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2018 at 10:46:03AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Commonly, ethernet addresses are just using a policy of
> 	{ .len = ETH_ALEN }
> which leaves userspace free to send more data than it should,
> which may hide bugs.
> 
> Introduce NLA_ETH_ADDR which checks for exact size, and rejects
> the attribute if the length isn't ETH_ALEN.
> 
> Also add NLA_ETH_ADDR_COMPAT which can be used in place of the
> pure length policy, but will, in addition, trigger a netlink
> attribute warning if the passed value is too long.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

The code looks correct to me but I have some doubts. Having a special
policy for MAC addresses may lead to adding one for IPv4 address (maybe
not, we can use NLA_U32 for them), IPv6 addresses and other data types
with fixed length. Wouldn't it be more helpful to add a variant of
NLA_BINARY (NLA_BINARY_EXACT?) which would fail/warn if attribute length
isn't equal to .len?

Michal Kubecek


>  include/net/netlink.h | 4 ++++
>  lib/nlattr.c          | 8 ++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 04e40fcc70d6..1139163c0db0 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -181,6 +181,8 @@ enum {
>  	NLA_S64,
>  	NLA_BITFIELD32,
>  	NLA_REJECT,
> +	NLA_ETH_ADDR,
> +	NLA_ETH_ADDR_COMPAT,
>  	__NLA_TYPE_MAX,
>  };
>  
> @@ -213,6 +215,8 @@ enum {
>   *                         data must point to a u32 value of valid flags
>   *    NLA_REJECT           Reject this attribute, validation data may point
>   *                         to a string to report as the error in extended ACK.
> + *    NLA_ETH_ADDR         Ethernet address, rejected if not exactly 6 octets.
> + *    NLA_ETH_ADDR_COMPAT  Ethernet address, only warns if not exactly 6 octets.
>   *    All other            Minimum length of attribute payload
>   *
>   * Example:
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index 56e0aae5cf23..b7c519f6e12a 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -29,6 +29,8 @@ static const u8 nla_attr_len[NLA_TYPE_MAX+1] = {
>  	[NLA_S16]	= sizeof(s16),
>  	[NLA_S32]	= sizeof(s32),
>  	[NLA_S64]	= sizeof(s64),
> +	[NLA_ETH_ADDR]	= ETH_ALEN,
> +	[NLA_ETH_ADDR_COMPAT] = ETH_ALEN,
>  };
>  
>  static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
> @@ -42,6 +44,7 @@ static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
>  	[NLA_S16]	= sizeof(s16),
>  	[NLA_S32]	= sizeof(s32),
>  	[NLA_S64]	= sizeof(s64),
> +	[NLA_ETH_ADDR_COMPAT] = ETH_ALEN,
>  };
>  
>  static int validate_nla_bitfield32(const struct nlattr *nla,
> @@ -93,6 +96,11 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
>  			extack->_msg = pt->validation_data;
>  		return -EINVAL;
>  
> +	case NLA_ETH_ADDR:
> +		if (attrlen != ETH_ALEN)
> +			return -ERANGE;
> +		break;
> +
>  	case NLA_FLAG:
>  		if (attrlen > 0)
>  			return -ERANGE;
> -- 
> 2.14.4
> 
