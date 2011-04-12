Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52299 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1DLLIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:08:09 -0400
Subject: Re: [PATCH 2/4] nl80211: Add NL80211_ATTR_WIPHY_CHANNEL_TYPE for
 IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110412T130245-14@post.gmane.org>
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130245-14@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 13:08:07 +0200
Message-ID: <1302606487.3639.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-12 at 11:04 +0000, Alexander Simon wrote:
> Needed for IBSS IEEE802.11N operation
> 
> * Add a new attribute NL80211_ATTR_WIPHY_CHANNEL_TYPE to specify
>     a HT channel type for IBSS

> -	ibss.channel = ieee80211_get_channel(wiphy,
> -		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
> +	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
> +		enum nl80211_channel_type channel_type;
> +
> +		channel_type = nla_get_u32(
> +			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
> +		if (channel_type != NL80211_CHAN_NO_HT &&
> +				channel_type != NL80211_CHAN_HT20 &&
> +				channel_type != NL80211_CHAN_HT40PLUS &&
> +				channel_type != NL80211_CHAN_HT40MINUS)
> +			return -EINVAL;
> +		ibss.channel_type = channel_type;

Please use Linux coding style.

> +	ibss.channel = rdev_freq_to_chan(rdev,
> +		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
> +		ibss.channel_type);

I don't think that is sufficient. Need to check that IBSS is allowed on
both channels, maybe with a function like can_beacon_sec_chan.

johannes

