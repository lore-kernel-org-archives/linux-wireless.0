Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57714 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab0KHVMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 16:12:07 -0500
Message-ID: <4CD8679B.90808@openwrt.org>
Date: Mon, 08 Nov 2010 22:11:55 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: fix beacon race conditions
References: <alpine.DEB.2.00.1011031743550.21873@bigbill>
In-Reply-To: <alpine.DEB.2.00.1011031743550.21873@bigbill>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-03 6:36 PM, Björn Smedman wrote:
> Hi all,
> 
> The beacon processing in ath9k is done in a tasklet. This tasklet may race 
> against beacon allocation/deallocation in process context. The patch below 
> is an attempt to point out / avoid these race conditions. My hope is that 
> this will stabilize ath9k in a use-case I'm interested in where ap vif 
> interfaces are added and removed quite often.
> 
> This is purely an RFC, and it's probably synchronizing a bit too much. I'm 
> currently testing this patch with no obvious problems so far (except for 
> the part in xmit.c which I've commented out). More testing is necessary 
> but so is a rewrite of the patch anyway.
> 
> Any thoughts?
> 
> Best regards,
> 
> Björn
> ---
> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> index 19891e7..f91e0b5 100644
> --- a/drivers/net/wireless/ath/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -192,6 +192,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
>  		if (sc->nvifs > 1) {
>  			ath_print(common, ATH_DBG_BEACON,
>  				  "Flushing previous cabq traffic\n");
> +			ath9k_hw_stoptxdma(sc->sc_ah, cabq->axq_qnum);
>  			ath_draintxq(sc, cabq, false);
>  		}
>  	}
Makes sense

> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index b52f1cf..c3d2a36 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -290,9 +290,11 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
>  	ath9k_hw_set_interrupts(ah, ah->imask);
>  
>  	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
> +		tasklet_disable(&sc->bcon_tasklet);
>  		ath_beacon_config(sc, NULL);
>  		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
>  		ath_start_ani(common);
> +		tasklet_enable(&sc->bcon_tasklet);
>  	}
>  
>   ps_restore:
Why?

> @@ -838,6 +840,8 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
>  	struct ath_common *common = ath9k_hw_common(ah);
>  
>  	if (bss_conf->assoc) {
> +		tasklet_disable(&sc->bcon_tasklet);
> +
>  		ath_print(common, ATH_DBG_CONFIG,
>  			  "Bss Info ASSOC %d, bssid: %pM\n",
>  			   bss_conf->aid, common->curbssid);
> @@ -861,6 +865,8 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
>  
>  		sc->sc_flags |= SC_OP_ANI_RUN;
>  		ath_start_ani(common);
> +
> +		tasklet_enable(&sc->bcon_tasklet);
>  	} else {
>  		ath_print(common, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
>  		common->curaid = 0;
Unnecessary, does not have anything to do with *sending* beacons.

> @@ -903,8 +909,11 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
>  	}
>  	spin_unlock_bh(&sc->rx.pcu_lock);
>  
> -	if (sc->sc_flags & SC_OP_BEACONS)
> +	if (sc->sc_flags & SC_OP_BEACONS) {
> +		tasklet_disable(&sc->bcon_tasklet);
>  		ath_beacon_config(sc, NULL);	/* restart beacons */
> +		tasklet_enable(&sc->bcon_tasklet);
> +	}
>  
>  	/* Re-Enable  interrupts */
>  	ath9k_hw_set_interrupts(ah, ah->imask);
> @@ -1008,8 +1017,11 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
>  	 */
>  	ath_update_txpow(sc);
>  
> -	if ((sc->sc_flags & SC_OP_BEACONS) || !(sc->sc_flags & (SC_OP_OFFCHANNEL)))
> +	if ((sc->sc_flags & SC_OP_BEACONS) || !(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
> +		tasklet_disable(&sc->bcon_tasklet);
>  		ath_beacon_config(sc, NULL);	/* restart beacons */
> +		tasklet_enable(&sc->bcon_tasklet);
> +	}
>  
>  	ath9k_hw_set_interrupts(ah, ah->imask);
>  
Why?

> @@ -1517,6 +1529,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
>  
>  	mutex_lock(&sc->mutex);
>  
> +	tasklet_disable(&sc->bcon_tasklet);
> +
>  	/* Stop ANI */
>  	sc->sc_flags &= ~SC_OP_ANI_RUN;
>  	del_timer_sync(&common->ani.timer);
> @@ -1544,6 +1558,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
>  
>  	sc->nvifs--;
>  
> +	tasklet_enable(&sc->bcon_tasklet);
> +
>  	mutex_unlock(&sc->mutex);
>  }
>  
Makes sense.

> @@ -1817,6 +1833,8 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
>  
>  	mutex_lock(&sc->mutex);
>  
> +	tasklet_disable(&sc->bcon_tasklet);
> +
>  	memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
>  
>  	qi.tqi_aifs = params->aifs;
> @@ -1839,6 +1857,8 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
>  		if ((qnum == sc->tx.hwq_map[WME_AC_BE]) && !ret)
>  			ath_beaconq_config(sc);
>  
> +	tasklet_enable(&sc->bcon_tasklet);
> +
>  	mutex_unlock(&sc->mutex);
>  
>  	return ret;
I don't think that one's necessary.

> @@ -1930,13 +1950,16 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
>  	/* Enable transmission of beacons (AP, IBSS, MESH) */
>  	if ((changed & BSS_CHANGED_BEACON) ||
>  	    ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon)) {
> +		tasklet_disable(&sc->bcon_tasklet);
>  		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
>  		error = ath_beacon_alloc(aphy, vif);
>  		if (!error)
>  			ath_beacon_config(sc, vif);
> +		tasklet_enable(&sc->bcon_tasklet);
>  	}
Makes sense.

>  	if (changed & BSS_CHANGED_ERP_SLOT) {
> +		tasklet_disable(&sc->bcon_tasklet);
>  		if (bss_conf->use_short_slot)
>  			slottime = 9;
>  		else
> @@ -1953,6 +1976,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
>  			ah->slottime = slottime;
>  			ath9k_hw_init_global_settings(ah);
>  		}
> +		tasklet_enable(&sc->bcon_tasklet);
>  	}
>  
>  	/* Disable transmission of beacons */
A memory barrier between setting beacon.slottime and beacon.updateslot
should be enough here.

> @@ -1960,6 +1984,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
>  		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
>  
>  	if (changed & BSS_CHANGED_BEACON_INT) {
> +		tasklet_disable(&sc->bcon_tasklet);
>  		sc->beacon_interval = bss_conf->beacon_int;
>  		/*
>  		 * In case of AP mode, the HW TSF has to be reset
> @@ -1974,6 +1999,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
>  		} else {
>  			ath_beacon_config(sc, vif);
>  		}
> +		tasklet_enable(&sc->bcon_tasklet);
>  	}
>  
>  	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
Makes sense.

> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index f2ade24..174a8ae 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1133,6 +1133,10 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>  	/* Stop beacon queue */
>  	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
>  
> +	/* Stop cab queue */
> +	if (sc->beacon.cabq != NULL)
> +		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.cabq->axq_qnum);
> +
>  	/* Stop data queues */
>  	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
>  		if (ATH_TXQ_SETUP(sc, i)) {
Makes sense.

> @@ -1157,6 +1161,11 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>  		spin_unlock_bh(&sc->sc_resetlock);
>  	}
>  
> +	/* Drain cab queue 
> +	 * BUG: for some reason this causes a dump in ath_draintxq(). Why?
> +	if (sc->beacon.cabq != NULL)
> +		ath_draintxq(sc->sc_ah, sc->beacon.cabq, false); */
> +
>  	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
>  		if (ATH_TXQ_SETUP(sc, i))
>  			ath_draintxq(sc, &sc->tx.txq[i], retry_tx);
What kind of dump?

- Felix
