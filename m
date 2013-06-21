Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423539Ab3FUU76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 16:59:58 -0400
Message-ID: <1371848393.8936.13.camel@jlt4.sipsolutions.net> (sfid-20130621_230008_104557_9F0ACB08)
Subject: Re: [PATCH] nl80211/drivers: change bss channel to chandef
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 21 Jun 2013 22:59:53 +0200
In-Reply-To: <1371737435-5694-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1371737435-5694-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-20 at 16:10 +0200, Simon Wunderlich wrote:

> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1402,7 +1402,7 @@ struct cfg80211_bss_ies {
>   * This structure describes a BSS (which may also be a mesh network)
>   * for use in scan results and similar.
>   *
> - * @channel: channel this BSS is on
> + * @chandef: chandef of the channel this BSS is on

I don't think this makes a lot of sense. The chandefs were defined to be
able to capture things like 80+80 MHz, and there's no way that will be
used here. I think it would make more sense to define a separate "scan
width" or so that can only represent the values 5/10/20.

> +++ b/net/mac80211/ibss.c
> @@ -246,7 +246,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  	mod_timer(&ifibss->timer,
>  		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
>  
> -	bss = cfg80211_inform_bss_frame(local->hw.wiphy, chan,
> +	bss = cfg80211_inform_bss_frame(local->hw.wiphy, &chandef,

In fact I think this might even create a 40 MHz BSS which would be
strange.

> +++ b/net/wireless/nl80211.c
> @@ -5608,7 +5608,8 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
>  	    nla_put_u16(msg, NL80211_BSS_BEACON_INTERVAL, res->beacon_interval))
>  		goto nla_put_failure;
>  	if (nla_put_u16(msg, NL80211_BSS_CAPABILITY, res->capability) ||
> -	    nla_put_u32(msg, NL80211_BSS_FREQUENCY, res->channel->center_freq) ||
> +	    nla_put_u32(msg, NL80211_BSS_FREQUENCY,
> +			res->chandef.chan->center_freq) ||
>  	    nla_put_u32(msg, NL80211_BSS_SEEN_MS_AGO,
>  			jiffies_to_msecs(jiffies - intbss->ts)))
>  		goto nla_put_failure;

You should also advertise the width to userspace.

> @@ -5887,10 +5888,9 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
>  		return -EOPNOTSUPP;
>  
>  	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
> -	chan = ieee80211_get_channel(&rdev->wiphy,
> -		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
> -	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
> -		return -EINVAL;
> +	err = nl80211_parse_chandef(rdev, info, &chandef);
> +	if (!err)
> +		return err;

This also doesn't make sense, you'd allow asking for a 40 MHz channel.
That doesn't mean anything though.

Anyway, this is a bit pointless since __cfg80211_mlme_auth() will look
up the BSS entry for the given parameters and pass _it_, so unless you
need to support two APs using the same BSSID on the same channel but
with different channel widths (which seems really unlikely) then nothing
is needed here.

It might also be worthwhile to rename the inform_bss() functions and
provide static inline wrappers for the current behaviour, since the 5/10
MHz support is really something of a special case and not all drivers
really need that.

johannes

