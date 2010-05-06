Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0EFGky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 02:40:54 -0400
Subject: Re: [PATCH v2] mac80211: Add HT IE to IBSS beacons and probe
 responses.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1273098986-19330-2-git-send-email-benoit.papillault@free.fr>
References: <1273098986-19330-1-git-send-email-benoit.papillault@free.fr>
	 <1273098986-19330-2-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 08:40:51 +0200
Message-ID: <1273128051.3573.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-06 at 00:36 +0200, Benoit Papillault wrote:
> When an HT IBSS is configured, we add HT Information and HT Capabilities
> IE to beacons & probe responses. This is done according to channel_type
> transmitted by iw/cfg80211.
> 
> v2: Added helpers to build HT Capability & HT Information IE

This line belongs after the --- so it's not part of the commit log.

>  	local->oper_channel = chan;
> -	local->oper_channel_type = NL80211_CHAN_NO_HT;
> +	local->oper_channel_type = channel_type;

It would be helpful if you were to rebase over my patch that adds the
channel type tracking.

> @@ -165,6 +169,14 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  		memcpy(pos, &supp_rates[8], rates);
>  	}
>  
> +	if (channel_type != NL80211_CHAN_NO_HT &&
> +	    sband->ht_cap.ht_supported) {

You shouldn't be able to get here with an HT channel but !ht_supported,
no? Or is that to support the case where you have HT only on one band?

> +	}
> +	  

trailing whitespace

> @@ -202,6 +214,9 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  	u32 basic_rates;
>  	int i, j;
>  	u16 beacon_int = cbss->beacon_interval;
> +	const u8 * ht_info_ie;

CodingStyle.

> @@ -223,9 +238,28 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  		}
>  	}
>  
> +	/* parse HT Information IE, if present */
> +	ht_info_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_INFORMATION);
> +	if (ht_info_ie) {
> +		ht_info = (const struct ieee80211_ht_info *)(ht_info_ie + 2);
> +		switch (ht_info->ht_param
> +			& IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {

The parser in mlme.c looks different. Please see there and also make it
a helper function.

> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -404,6 +404,7 @@ struct ieee80211_if_ibss {
>  	u8 ssid_len, ie_len;
>  	u8 *ie;
>  	struct ieee80211_channel *channel;
> +	enum nl80211_channel_type channel_type;
>  
>  	unsigned long ibss_join_req;
>  	/* probe response/beacon for IBSS */
> @@ -1193,6 +1194,15 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
>  			 u16 transaction, u16 auth_alg,
>  			 u8 *extra, size_t extra_len, const u8 *bssid,
>  			 const u8 *key, u8 key_len, u8 key_idx);
> +
> +int ieee80211_add_ht_cap(u8 **ppos,
> +			 struct ieee80211_supported_band *sband);

The length is fixed anyway, so how about just passing in
	...(u8 *buffer, ... sband)

> +int ieee80211_add_ht_info(u8 **ppos,
> +			  struct ieee80211_supported_band *sband,
> +			  struct ieee80211_channel *channel,
> +			  enum nl80211_channel_type channel_type);

same here.

> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -898,6 +898,82 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
>  	ieee80211_tx_skb(sdata, skb);
>  }
>  
> +int ieee80211_add_ht_cap(u8 **ppos,
> +			 struct ieee80211_supported_band *sband)
> +{

Actually ... please split up the patches.

 1) pure code moving from the mlme code to helper functions
 2) helper function rewrite using the structures, like you did
 3) this patch

> +	u16 cap = sband->ht_cap.cap;
> +	struct ieee80211_ht_cap ht_cap;
> +	u8 *pos = *ppos;
> +
> +	if (ieee80211_disable_40mhz_24ghz &&
> +	    sband->band == IEEE80211_BAND_2GHZ) {
> +		cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> +		cap &= ~IEEE80211_HT_CAP_SGI_40;
> +	}
> +
> +	ht_cap.cap_info = cpu_to_le16(cap);
> +	ht_cap.ampdu_params_info = sband->ht_cap.ampdu_factor |
> +		(sband->ht_cap.ampdu_density <<
> +		 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
> +	ht_cap.mcs = sband->ht_cap.mcs;
> +	ht_cap.extended_ht_cap_info = cpu_to_le16(0);
> +	ht_cap.tx_BF_cap_info = cpu_to_le32(0);
> +	ht_cap.antenna_selection_info = 0;
> +
> +	/* HT Capabilities element */
> +	*pos++ = WLAN_EID_HT_CAPABILITY;
> +	*pos++ = sizeof(struct ieee80211_ht_cap);
> +	memcpy(pos, &ht_cap, sizeof(struct ieee80211_ht_cap));
> +	pos += sizeof(struct ieee80211_ht_cap);
> +
> +	*ppos = pos;
> +
> +	return 1;

oh and get rid of the entirely useless return value.

> +}
> +
> +int ieee80211_add_ht_info(u8 **ppos,
> +			  struct ieee80211_supported_band *sband,
> +			  struct ieee80211_channel *channel,
> +			  enum nl80211_channel_type channel_type)

what's wrong with ieee80211_add_ht_ie()

Some more effort please! Patches with such _basic_ errors are no fun to
review!

johannes

