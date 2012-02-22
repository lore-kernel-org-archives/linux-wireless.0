Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2BVR5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 12:57:43 -0500
Subject: Re: [RFC] cfg80211: 80Mhz Bandwidth channel flags in 5Gig band
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh <maheshp@posedge.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <f17c700977012ada368da4f339b9c639@posedge.com> (sfid-20120222_185112_125868_ED7DF18C)
References: <f17c700977012ada368da4f339b9c639@posedge.com>
	 (sfid-20120222_185112_125868_ED7DF18C)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Feb 2012 18:57:38 +0100
Message-ID: <1329933458.4657.2.camel@jlt3.sipsolutions.net> (sfid-20120222_185746_860409_0CF57D5F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-22 at 23:21 +0530, Mahesh wrote:
> This change is for marking 80Mhz bandwidth supported channel flags in 
> 5Gig band.

This patch is not only completely mangled, it also neglects to actually
support this in the regdb etc. What's the point?

johannes


> Signed-off-by: Mahesh Palivela (maheshp@posedge.com)
> ---
> 
>   include/net/cfg80211.h |   20 +++++++++----
>   net/wireless/reg.c     |   72 
> ++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 86 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index e0c9ff3..7fb77d5 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -93,18 +93,26 @@ enum ieee80211_band {
>    * 	is not permitted.
>    * @IEEE80211_CHAN_NO_HT40MINUS: extension channel below this channel
>    * 	is not permitted.
> + * @IEEE80211_CHAN_NO_VHT80PLUS: extension channel above this channel
> + * 	is not permitted.
> + * @IEEE80211_CHAN_NO_VHT80MINUS: extension channel below this channel
> + * 	is not permitted.
>    */
>   enum ieee80211_channel_flags {
> -	IEEE80211_CHAN_DISABLED		= 1<<0,
> -	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
> -	IEEE80211_CHAN_NO_IBSS		= 1<<2,
> -	IEEE80211_CHAN_RADAR		= 1<<3,
> -	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
> -	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
> +	IEEE80211_CHAN_DISABLED		    = 1<<0,
> +	IEEE80211_CHAN_PASSIVE_SCAN	    = 1<<1,
> +	IEEE80211_CHAN_NO_IBSS		    = 1<<2,
> +	IEEE80211_CHAN_RADAR		    = 1<<3,
> +	IEEE80211_CHAN_NO_HT40PLUS	    = 1<<4,
> +	IEEE80211_CHAN_NO_HT40MINUS	    = 1<<5,
> +    IEEE80211_CHAN_NO_VHT80PLUS     = 1<<6,
> +    IEEE80211_CHAN_NO_VHT80MINUS    = 1<<7,
>   };
> 
>   #define IEEE80211_CHAN_NO_HT40 \
>   	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
> +#define IEEE80211_CHAN_NO_VHT80 \
> +    (IEEE80211_CHAN_NO_VHT80PLUS | IEEE80211_CHAN_NO_VHT80MINUS)
> 
>   /**
>    * struct ieee80211_channel - channel definition
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index e9a0ac8..dfa8f5d 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1048,6 +1048,77 @@ static void reg_process_beacons(struct wiphy 
> *wiphy)
>   	wiphy_update_beacon_reg(wiphy);
>   }
> 
> +static bool is_vht80_not_allowed(struct ieee80211_channel *chan)
> +{
> +	if (!chan)
> +		return true;
> +	if (chan->flags & IEEE80211_CHAN_DISABLED)
> +		return true;
> +	/* This would happen when regulatory rules disallow VHT80 completely 
> */
> +	if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & 
> (IEEE80211_CHAN_NO_VHT80)))
> +		return true;
> +	return false;
> +}
> +
> +static void reg_process_vht_flags_channel(struct wiphy *wiphy,
> +					 unsigned int chan_idx)
> +{
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *channel;
> +	struct ieee80211_channel *channel_before = NULL, *channel_after = 
> NULL;
> +	unsigned int i;
> +
> +	assert_cfg80211_lock();
> +
> +	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
> +	BUG_ON(chan_idx >= sband->n_channels);
> +	channel = &sband->channels[chan_idx];
> +
> +	if (is_vht80_not_allowed(channel)) {
> +		channel->flags |= IEEE80211_CHAN_NO_VHT80;
> +		return;
> +	}
> +
> +	/*
> +	 * We need to ensure the extension channels exist to
> +	 * be able to use VHT80- or VHT80+, this finds them (or not)
> +	 */
> +	for (i = 0; i < sband->n_channels; i++) {
> +		struct ieee80211_channel *c = &sband->channels[i];
> +		if (c->center_freq == (channel->center_freq - 40))
> +			channel_before = c;
> +		if (c->center_freq == (channel->center_freq + 40))
> +			channel_after = c;
> +	}
> +
> +	/*
> +	 * Please note that this assumes target bandwidth is 40 MHz,
> +	 * if that ever changes we also need to change the below logic
> +	 * to include that as well.
> +	 */
> +	if (is_vht80_not_allowed(channel_before))
> +		channel->flags |= IEEE80211_CHAN_NO_VHT80MINUS;
> +	else
> +		channel->flags &= ~IEEE80211_CHAN_NO_VHT80MINUS;
> +
> +	if (is_vht80_not_allowed(channel_after))
> +		channel->flags |= IEEE80211_CHAN_NO_VHT80PLUS;
> +	else
> +		channel->flags &= ~IEEE80211_CHAN_NO_VHT80PLUS;
> +}
> +
> +static void reg_process_vht_flags(struct wiphy *wiphy)
> +{
> +	unsigned int i;
> +	struct ieee80211_supported_band *sband;
> +
> +	BUG_ON(!wiphy->bands[IEEE80211_BAND_5GHZ]);
> +	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
> +
> +	for (i = 0; i < sband->n_channels; i++)
> +		reg_process_vht_flags_channel(wiphy, i);
> +}
> +
>   static bool is_ht40_not_allowed(struct ieee80211_channel *chan)
>   {
>   	if (!chan)
> @@ -1154,6 +1225,7 @@ static void wiphy_update_regulatory(struct wiphy 
> *wiphy,
> 
>   	reg_process_beacons(wiphy);
>   	reg_process_ht_flags(wiphy);
> +	reg_process_vht_flags(wiphy);
>   	if (wiphy->reg_notifier)
>   		wiphy->reg_notifier(wiphy, last_request);
>   }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


