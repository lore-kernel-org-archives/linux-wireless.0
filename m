Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41978 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbaJXLs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 07:48:57 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so885901wgg.25
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 04:48:56 -0700 (PDT)
Date: Fri, 24 Oct 2014 13:48:52 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v6] mac80211: minstrel_ht: add basic support for VHT
 rates <= 3SS@80MHz
Message-ID: <20141024114829.GA11675@magnum.frso.rivierawaves.com> (sfid-20141024_134900_866876_DC4EB55B)
References: <1413812762-6605-5-git-send-email-karl.beldan@gmail.com>
 <1413880718-31273-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1413880718-31273-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Oct 21, 2014 at 10:38:38AM +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> @@ -1026,13 +1184,47 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>  		    sta->bandwidth < IEEE80211_STA_RX_BW_40)
>  			continue;
>  
> +		nss = minstrel_mcs_groups[i].streams;
> +
>  		/* Mark MCS > 7 as unsupported if STA is in static SMPS mode */
> -		if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
> -		    minstrel_mcs_groups[i].streams > 1)
> +		if (sta->smps_mode == IEEE80211_SMPS_STATIC && nss > 1)
> +			continue;
> +
> +		/* HT rate */
> +		if (gflags & IEEE80211_TX_RC_MCS) {
> +#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
> +			if (minstrel_vht_only)
> +				continue;
> +#endif

When reformatting for 80chars I introduced a pb, the test should be 
'if (use_vht && minstrel_vht_only)' instead.
The consequence is VHT-unable devices with
CONFIG_MAC80211_RC_MINSTREL_VHT set won't have HT rates enabled.
Johannes can you squash it in or should I send you a patch ?

 
Karl
