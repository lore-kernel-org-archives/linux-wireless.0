Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59748 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab1FXS4f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 14:56:35 -0400
Message-ID: <4E04DDE0.2020008@openwrt.org> (sfid-20110624_205639_699740_36817AC7)
Date: Fri, 24 Jun 2011 20:56:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Alexander Simon <alexander.simon@saxnet.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 2/3] nl80211: channel type attribute for IBSS
References: <1308671129.2656.4.camel@alex-2> <1308671544.2656.8.camel@alex-2>
In-Reply-To: <1308671544.2656.8.camel@alex-2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-06-21 5:52 PM, Alexander Simon wrote:
> Allow nl80211 to set a ht channel for ibss.
>
> Signed-off-by: Alexander Simon<alexander.simon@saxnet.de>
>
> diff -Nrup a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> --- a/net/wireless/nl80211.c	2011-06-01 21:04:33.000000000 +0200
> +++ b/net/wireless/nl80211.c	2011-06-21 13:21:38.000000000 +0200
> @@ -4266,12 +4266,37 @@ static int nl80211_join_ibss(struct sk_b
>   		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
>   	}
>
> -	ibss.channel = ieee80211_get_channel(wiphy,
> -		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
> -	if (!ibss.channel ||
> +	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
> +		enum nl80211_channel_type channel_type;
> +
> +		channel_type = nla_get_u32(
> +			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
> +		if (channel_type != NL80211_CHAN_NO_HT&&
> +		    channel_type != NL80211_CHAN_HT20&&
> +		    channel_type != NL80211_CHAN_HT40PLUS&&
> +		    channel_type != NL80211_CHAN_HT40MINUS)
> +			return -EINVAL;
> +		ibss.channel_type = channel_type;
> +	} else {
> +		ibss.channel_type = NL80211_CHAN_NO_HT;
> +	}
> +
> +	ibss.channel = rdev_freq_to_chan(rdev,
> +		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
> +		ibss.channel_type);
> +	/*if (!ibss.channel ||
> +	    ibss.channel->flags&  IEEE80211_CHAN_PASSIVE_SCAN ||
>   	    ibss.channel->flags&  IEEE80211_CHAN_NO_IBSS ||
> -	    ibss.channel->flags&  IEEE80211_CHAN_DISABLED)
> +	    ibss.channel->flags&  IEEE80211_CHAN_RADAR)
> +		return -EINVAL;
> +	if ((ibss.channel_type == NL80211_CHAN_HT40PLUS ||
> +	     ibss.channel_type == NL80211_CHAN_HT40MINUS)&&
> +	    !can_beacon_sec_chan(&rdev->wiphy, ibss.chan, ibss.channel_type)) {
> +		printk(KERN_DEBUG
> +		       "cfg80211: Secondary channel not "
> +		       "allowed to initiate communication\n");
>   		return -EINVAL;
> +	}*/
That last part looks like a debugging hack, you should remove it before 
re-submitting that patch.

- Felix
