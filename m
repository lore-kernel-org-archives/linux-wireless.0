Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-1.exch022.serverdata.net ([206.225.164.184]:35145
	"EHLO HUB022-nj-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab2KTI1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 03:27:20 -0500
Message-ID: <50AB3EE1.8060101@posedge.com> (sfid-20121120_092723_138464_29CC8935)
Date: Tue, 20 Nov 2012 13:57:13 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net> <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2012 01:47 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>

> diff --git a/net/wireless/chan.c b/net/wireless/chan.c

> +static bool cfg80211_check_beacon_chans(struct wiphy *wiphy,
> +					u32 center_freq, u32 bw)
> +{
> +	struct ieee80211_channel *c;
> +	u32 freq;
> +
> +	for (freq = center_freq - bw/2 + 10;
> +	     freq <= center_freq + bw/2 - 10;
> +	     freq += 20) {
> +		c = ieee80211_get_channel(wiphy, freq);
> +		if (!c || c->flags & (IEEE80211_CHAN_DISABLED |
> +				      IEEE80211_CHAN_PASSIVE_SCAN |
> +				      IEEE80211_CHAN_NO_IBSS |
> +				      IEEE80211_CHAN_RADAR))
> +			return false;
>   	}
>
> -	sec_chan = ieee80211_get_channel(wiphy,
> -					 chandef->chan->center_freq + diff);
> -	if (!sec_chan) {
> +	return true;
> +}

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c

> +static int nl80211_check_sec_chans(struct cfg80211_registered_device *rdev,
> +				   u32 center_freq, u32 bw)
>   {
> -	enum nl80211_channel_type tmp;
> -
> -	if (!info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE])
> -		return false;
> +	struct ieee80211_channel *c;
> +	u32 freq;
>
> -	tmp = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
> -	if (tmp != NL80211_CHAN_NO_HT &&
> -	    tmp != NL80211_CHAN_HT20 &&
> -	    tmp != NL80211_CHAN_HT40PLUS &&
> -	    tmp != NL80211_CHAN_HT40MINUS)
> -		return false;
> -
> -	if (channel_type)
> -		*channel_type = tmp;
> +	for (freq = center_freq - bw/2 + 10;
> +	     freq <= center_freq + bw/2 - 10;
> +	     freq += 20) {
> +		c = ieee80211_get_channel(&rdev->wiphy, freq);
> +		if (!c || c->flags & IEEE80211_CHAN_DISABLED)
> +			return -EINVAL;
> +	}
>
> -	return true;
> +	return 0;
>   }

For loops in both functions seems to be similar. One return false, other 
return -EINVAL. Can we remove duplication?
