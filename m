Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab1ISMwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 08:52:43 -0400
Subject: Re: [PATCH v3 1/3] nl80211: Parse channel type attribute in an
 ibss join request
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com> (sfid-20110918_001516_388499_D9227DC9)
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
	 (sfid-20110918_001516_388499_D9227DC9)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 14:52:41 +0200
Message-ID: <1316436761.5995.22.camel@jlt3.sipsolutions.net> (sfid-20110919_145247_594038_1497A5E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-18 at 00:14 +0200, Alexander Simon wrote:

> +/**
> + * cfg80211_can_use_ext_chan - test if ht40 on extension channel can be used
> + * @wiphy: the wiphy
> + * @chan: main channel
> + * @channel_type: HT mode
> + */
> +bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,

That doesn't match the documentation now ...

> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -4537,13 +4537,34 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
>  		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
>  	}
>  
> -	ibss.channel = ieee80211_get_channel(wiphy,
> -		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
> +	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
> +		enum nl80211_channel_type channel_type;
> +
> +		channel_type = nla_get_u32(
> +				info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
> +		if (channel_type > NL80211_CHAN_HT40PLUS)
> +			return -EINVAL;
> +		ibss.channel_type = channel_type;
> +	} else {
> +		ibss.channel_type = NL80211_CHAN_NO_HT;
> +	}
> +
> +	ibss.channel = rdev_freq_to_chan(rdev,
> +		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
> +		ibss.channel_type);
>  	if (!ibss.channel ||
> +	    ibss.channel->flags & IEEE80211_CHAN_RADAR ||
>  	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
>  	    ibss.channel->flags & IEEE80211_CHAN_DISABLED)
>  		return -EINVAL;
>  
> +	/* Both channels should be able to initiate communication */
> +	if ((ibss.channel_type == NL80211_CHAN_HT40PLUS ||
> +	     ibss.channel_type == NL80211_CHAN_HT40MINUS) &&
> +	    !cfg80211_can_beacon_sec_chan(&rdev->wiphy, ibss.channel,
> +					  ibss.channel_type))
> +		return -EINVAL;
> +
>  	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
>  	ibss.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
>  

With just this patch, you can set HT IBSS but mac80211 won't be able to
do it so there probably should be some form of feature check for this so
other (non-mac80211) drivers would be able to do this correctly -- I
don't expect all of them to implement HT IBSS.

johannes


