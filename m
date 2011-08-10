Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1HJNub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:50:31 -0400
Subject: Re: [PATCH 1/4] nl80211: Parse channel type attribute in an IBSS
 join request
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1888623.Vt5VZUN2cU@alex-1> (sfid-20110808_140308_710112_10A3AC18)
References: <1888623.Vt5VZUN2cU@alex-1>
	 (sfid-20110808_140308_710112_10A3AC18)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:50:28 +0200
Message-ID: <1312984228.4325.7.camel@jlt3.sipsolutions.net> (sfid-20110810_155034_131491_B0EA910E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 14:02 +0200, Alexander Simon wrote:
> Check if the requested HT mode can be used.
> Extend cfg80211 IBSS struct for HT mode.
> 
> Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
> ---
> 
> As there were no replies for my RFC post, i am resending this as PATCH.

I was on vacation ;-)

> +	ibss.channel = rdev_freq_to_chan(rdev,
> +		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
> +		ibss.channel_type);
>  	if (!ibss.channel ||
> +	    ibss.channel->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
>  	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
> -	    ibss.channel->flags & IEEE80211_CHAN_DISABLED)
> +	    ibss.channel->flags & IEEE80211_CHAN_RADAR)
> +		return -EINVAL;
> +
> +	/* Both channels should be able to initiate communication */
> +	if ((ibss.channel_type == NL80211_CHAN_HT40PLUS ||
> +	     ibss.channel_type == NL80211_CHAN_HT40MINUS) &&
> +	    !can_beacon_sec_chan(&rdev->wiphy, ibss.channel,
> +				 ibss.channel_type)) {
> +		printk(KERN_DEBUG
> +		       "cfg80211: Secondary channel not "
> +		       "allowed to initiate communication\n");


remove the printk please

johannes

