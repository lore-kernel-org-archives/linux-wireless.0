Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40249 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbcGFMaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 08:30:55 -0400
Message-ID: <1467808252.5460.1.camel@sipsolutions.net> (sfid-20160706_143110_099163_E4AE86A7)
Subject: Re: [RFC] nl80211: Allow GET_INTERFACE dumps to be filtered
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 06 Jul 2016 14:30:52 +0200
In-Reply-To: <1467334294-6384-1-git-send-email-denkenz@gmail.com> (sfid-20160630_185128_850366_B817D4E2)
References: <1467334294-6384-1-git-send-email-denkenz@gmail.com>
	 (sfid-20160630_185128_850366_B817D4E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-06-30 at 19:51 -0500, Denis Kenzior wrote:
> This patch allows GET_INTERFACE dumps to be filtered based on
> NL80211_ATTR_WIPHY or NL80211_ATTR_WDEV.  The documentation for
> GET_INTERFACE mentions that this is possible:
> "Request an interface's configuration; either a dump request on
> a %NL80211_ATTR_WIPHY or ..."
> 
> However, this behavior has not been implemented until now.
> ---
>  net/wireless/nl80211.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 244d552..24cb4d9 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2515,15 +2515,47 @@ static int nl80211_send_iface(struct sk_buff
> *msg, u32 portid, u32 seq, int flag
>  	return -EMSGSIZE;
>  }
>  
> +static int nl80211_dump_interface_parse(struct sk_buff *skb,
> +				    struct netlink_callback *cb,
> +				    int *filter_wiphy)
> +{
> +	struct nlattr **tb = nl80211_fam.attrbuf;
> +	int ret = nlmsg_parse(cb->nlh, GENL_HDRLEN +
> nl80211_fam.hdrsize,
> +			      tb, nl80211_fam.maxattr,
> nl80211_policy);
> +	/* ignore parse errors for backward compatibility */
> +	if (ret)
> +		return 0;
> +
> +	if (tb[NL80211_ATTR_WIPHY])
> +		*filter_wiphy = nla_get_u32(tb[NL80211_ATTR_WIPHY]);
> +	if (tb[NL80211_ATTR_WDEV])
> +		*filter_wiphy = nla_get_u64(tb[NL80211_ATTR_WDEV])
> >> 32;

The whole ret thing seems a bit pointless since you check the tb[], but
I guess it's better to be explicit.

Looks fine.

johannes
