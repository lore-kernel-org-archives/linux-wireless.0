Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30110 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab2FVKvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 06:51:00 -0400
Date: Fri, 22 Jun 2012 16:22:16 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sven Eckelmann <sven@narfation.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC] ath9k: raise aggregation limit to 64k for HT IBSS
Message-ID: <20120622105214.GC7934@vmraj-lnx.users.atheros.com> (sfid-20120622_125104_806087_85B63A5B)
References: <1340355904-861-1-git-send-email-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1340355904-861-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 11:05:04AM +0200, Sven Eckelmann wrote:
> mac80211 adds stations in HT IBSS as soon as a frame comes by,
> even if the HT capabilities are not known yet (they are often
> received later, e.g. in beacons). So far, ampdu factor/density
> are only calculated when the station is initially added.
> 
> This patch changes this to update ampdu factor/density settings
> when starting a blockack session.
> 
> Using this patch, we had performance boosts from 60 to 150 MBit/s
> between two 2x2 Atheros devices in 5 GHz HT IBSS mode.
>
Nice.

> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> @@ -320,6 +320,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
>  			    struct ieee80211_vif *vif)
>  {
>  	struct ath_node *an;
> +	u8 density;
>  	an = (struct ath_node *)sta->drv_priv;
>  
>  #ifdef CONFIG_ATH9K_DEBUGFS
> @@ -334,7 +335,8 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
>  		ath_tx_node_init(sc, an);
>  		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
>  				     sta->ht_cap.ampdu_factor);
> -		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
> +		density = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
> +		an->mpdudensity = density;
>  	}
>  }
>  
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 8d83060..cafb4a0 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1165,6 +1165,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
>  {
>  	struct ath_atx_tid *txtid;
>  	struct ath_node *an;
> +	u8 density;
>  
>  	an = (struct ath_node *)sta->drv_priv;
>  	txtid = ATH_AN_2_TID(an, tid);
> @@ -1172,6 +1173,17 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
>  	if (txtid->state & (AGGR_CLEANUP | AGGR_ADDBA_COMPLETE))
>  		return -EAGAIN;
>  
> +	/* update ampdu factor/density, they may have changed. This may happen
> +	 * in HT IBSS when a beacon with HT-info is received after the station
> +	 * has already been added.
> +	 */
> +	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
> +		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
> +				     sta->ht_cap.ampdu_factor);
> +		density = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
> +		an->mpdudensity = density;
> +	}
> +
No need to declare local variable. ins't it?

-Rajkumar
