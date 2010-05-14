Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0ENN4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 09:56:23 -0400
Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe responses
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1273698460-18061-4-git-send-email-benoit.papillault@free.fr>
References: <1273698460-18061-1-git-send-email-benoit.papillault@free.fr>
	 <1273698460-18061-2-git-send-email-benoit.papillault@free.fr>
	 <1273698460-18061-3-git-send-email-benoit.papillault@free.fr>
	 <1273698460-18061-4-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 15:56:22 +0200
Message-ID: <1273845382.4950.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> @@ -103,7 +104,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
>  
>  	local->oper_channel = chan;
> -	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
> +	WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
>  	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);

This is incorrect .. you need to fall back to HT20 when HT40 fails, like
mlme.c does.

>  	/* fix ourselves to that channel now already */
>  	if (params->channel_fixed) {
>  		sdata->local->oper_channel = params->channel;
>  		WARN_ON(!ieee80211_set_channel_type(sdata->local, sdata,
> -						    NL80211_CHAN_NO_HT));
> +						    params->channel_type));
>  	}

Same here.

>  			 u16 transaction, u16 auth_alg,
>  			 u8 *extra, size_t extra_len, const u8 *bssid,
>  			 const u8 *key, u8 key_len, u8 key_idx);
> +
> +u8 *ieee80211_add_ht_cap(u8 *pos,
> +			 struct ieee80211_supported_band *sband);
> +
> +u8 *ieee80211_add_ht_info(u8 *pos,
> +			  struct ieee80211_supported_band *sband,
> +			  struct ieee80211_channel *channel,
> +			  enum nl80211_channel_type channel_type);
> +
> +enum nl80211_channel_type ieee80211_channel_type_from_ht_info(
> +	struct ieee80211_local *local,
> +	struct ieee80211_ht_info *hti, u16 ap_ht_cap_flags);
> +
>  int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
>  			     const u8 *ie, size_t ie_len,
>  			     enum ieee80211_band band);

Didn't you just do this in the first patch??

johannes

