Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab0EDI0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 04:26:53 -0400
Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe
 responses.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1272955622-6987-3-git-send-email-benoit.papillault@free.fr>
References: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>
	 <1272955622-6987-2-git-send-email-benoit.papillault@free.fr>
	 <1272955622-6987-3-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 10:26:48 +0200
Message-ID: <1272961608.3673.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> @@ -118,7 +119,10 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  		*pos++ = basic | (u8) (rate / 5);
>  	}
>  
> -	/* Build IBSS probe response */
> +	/* 
> +	 * Build IBSS probe response template (also used for beacon template
> +	 * in ieee80211_beacon_get_tim())
> +	 */

That change is wrong -- no way beacon code can call into IBSS code.

I think you meant to say "I need to create a common helper function that
I call here and in the beacon code."

> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -967,7 +967,7 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
>  
>  	if (sband->ht_cap.ht_supported) {
>  		u16 cap = sband->ht_cap.cap;
> -		__le16 tmp;
> +		struct ieee80211_ht_cap ht_cap;
>  
>  		if (ieee80211_disable_40mhz_24ghz &&
>  		    sband->band == IEEE80211_BAND_2GHZ) {
> @@ -975,18 +975,19 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
>  			cap &= ~IEEE80211_HT_CAP_SGI_40;
>  		}
>  
> +		ht_cap.cap_info = cpu_to_le16(cap);
> +		ht_cap.ampdu_params_info = sband->ht_cap.ampdu_factor |
> +			(sband->ht_cap.ampdu_density <<
> +			 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
> +		ht_cap.mcs = sband->ht_cap.mcs;
> +		ht_cap.extended_ht_cap_info = cpu_to_le16(0);
> +		ht_cap.tx_BF_cap_info = cpu_to_le32(0);
> +		ht_cap.antenna_selection_info = 0;
> +
>  		*pos++ = WLAN_EID_HT_CAPABILITY;
>  		*pos++ = sizeof(struct ieee80211_ht_cap);
> -		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
> -		tmp = cpu_to_le16(cap);
> -		memcpy(pos, &tmp, sizeof(u16));
> -		pos += sizeof(u16);
> -		*pos++ = sband->ht_cap.ampdu_factor |
> -			 (sband->ht_cap.ampdu_density <<
> -				IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
> -		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
> -		pos += sizeof(sband->ht_cap.mcs);
> -		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
> +		memcpy(pos, &ht_cap, sizeof(struct ieee80211_ht_cap));
> +		pos += sizeof(struct ieee80211_ht_cap);

And this is an unrelated change that doesn't belong into this patch at
all.

johannes

