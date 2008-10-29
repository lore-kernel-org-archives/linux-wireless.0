Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:22923 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYJ2Cfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 22:35:47 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1584755wah.21
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 19:35:46 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] ath9k: kill ath9k_opmode
Date: Tue, 28 Oct 2008 19:35:45 -0700 (PDT)
Message-ID: <4907cc01.19f8720a.500d.6636@mx.google.com> (sfid-20081029_033557_522474_D37A17E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch kills ath9k's ath9k_opmode enum by replacing it with nl80211_iftype.
Compile-tested only.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index a6063de..e00b946 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -664,13 +664,6 @@ enum ath9k_ant_setting {
 	ATH9K_ANT_FIXED_B
 };
 
-enum ath9k_opmode {
-	ATH9K_M_STA = 1,
-	ATH9K_M_IBSS = 0,
-	ATH9K_M_HOSTAP = 6,
-	ATH9K_M_MONITOR = 8
-};
-
 #define ATH9K_SLOT_TIME_6 6
 #define ATH9K_SLOT_TIME_9 9
 #define ATH9K_SLOT_TIME_20 20
@@ -791,7 +784,7 @@ struct ath_hal {
 
 	void __iomem *ah_sh;
 	struct ath_softc *ah_sc;
-	enum ath9k_opmode ah_opmode;
+	enum nl80211_iftype ah_opmode;
 	struct ath9k_ops_config ah_config;
 	struct ath9k_hw_capabilities ah_caps;
 
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 9e15c30..069a5ba 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -31,7 +31,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	struct ath9k_tx_queue_info qi;
 
 	ath9k_hw_get_txq_props(ah, sc->sc_bhalq, &qi);
-	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
 		/* Always burst out beacon and CAB traffic. */
 		qi.tqi_aifs = 1;
 		qi.tqi_cwmin = 0;
@@ -82,7 +82,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 
 	flags = ATH9K_TXDESC_NOACK;
 
-	if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS &&
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC &&
 	    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 		ds->ds_link = bf->bf_daddr; /* self-linked */
 		flags |= ATH9K_TXDESC_VEOL;
@@ -318,7 +318,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 						 struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
 
-		if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP ||
+		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP ||
 		    !(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 			int slot;
 			/*
@@ -654,7 +654,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_beacon_config conf;
-	enum ath9k_opmode av_opmode;
+	enum nl80211_iftype av_opmode;
 	u32 nexttbtt, intval;
 
 	if (if_id != ATH_IF_ID_ANY)
@@ -675,7 +675,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	nexttbtt = TSF_TO_TU(sc->bc_tstamp >> 32, sc->bc_tstamp);
 
 	/* XXX conditionalize multi-bss support? */
-	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
 		/*
 		 * For multi-bss ap support beacons are either staggered
 		 * evenly over N slots or burst together.  For the former
@@ -697,8 +697,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	DPRINTF(sc, ATH_DBG_BEACON, "%s: nexttbtt %u intval %u (%u)\n",
 		__func__, nexttbtt, intval, conf.beacon_interval);
 
-	/* Check for ATH9K_M_HOSTAP and sc_nostabeacons for WDS client */
-	if (sc->sc_ah->ah_opmode == ATH9K_M_STA) {
+	/* Check for NL80211_IFTYPE_AP and sc_nostabeacons for WDS client */
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) {
 		struct ath9k_beacon_state bs;
 		u64 tsf;
 		u32 tsftu;
@@ -818,7 +818,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		ath9k_hw_set_interrupts(ah, 0);
 		if (nexttbtt == intval)
 			intval |= ATH9K_BEACON_RESET_TSF;
-		if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
+		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC) {
 			/*
 			 * Pull nexttbtt forward to reflect the current
 			 * TSF
@@ -850,7 +850,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			if (!(ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
 				sc->sc_imask |= ATH9K_INT_SWBA;
 			ath_beaconq_config(sc);
-		} else if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
+		} else if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
 			/*
 			 * In AP mode we enable the beacon timers and
 			 * SWBA interrupts to prepare beacon frames.
@@ -866,7 +866,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * When using a self-linked beacon descriptor in
 		 * ibss mode load it once here.
 		 */
-		if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS &&
+		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC &&
 		    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
 			ath_beacon_start_adhoc(sc, 0);
 	}
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index c5033f6..147004d 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -613,7 +613,7 @@ static void ath_ani_calibrate(unsigned long data)
 int ath_vap_attach(struct ath_softc *sc,
 		   int if_id,
 		   struct ieee80211_vif *if_data,
-		   enum ath9k_opmode opmode)
+		   enum nl80211_iftype opmode)
 {
 	struct ath_vap *avp;
 
@@ -624,11 +624,11 @@ int ath_vap_attach(struct ath_softc *sc,
 	}
 
 	switch (opmode) {
-	case ATH9K_M_STA:
-	case ATH9K_M_IBSS:
-	case ATH9K_M_MONITOR:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MONITOR:
 		break;
-	case ATH9K_M_HOSTAP:
+	case NL80211_IFTYPE_AP:
 		/* XXX not right, beacon buffer is allocated on RUN trans */
 		if (list_empty(&sc->sc_bbuf))
 			return -ENOMEM;
@@ -648,7 +648,7 @@ int ath_vap_attach(struct ath_softc *sc,
 	avp->av_opmode = opmode;
 	avp->av_bslot = -1;
 
-	if (opmode == ATH9K_M_HOSTAP)
+	if (opmode == NL80211_IFTYPE_AP)
 		ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
 
 	sc->sc_vaps[if_id] = avp;
@@ -797,8 +797,8 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 * Note we only do this (at the moment) for station mode.
 	 */
 	if (ath9k_hw_phycounters(ah) &&
-	    ((sc->sc_ah->ah_opmode == ATH9K_M_STA) ||
-	     (sc->sc_ah->ah_opmode == ATH9K_M_IBSS)))
+	    ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) ||
+	     (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)))
 		sc->sc_imask |= ATH9K_INT_MIB;
 	/*
 	 * Some hardware processes the TIM IE and fires an
@@ -807,7 +807,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 * enable the TIM interrupt when operating as station.
 	 */
 	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
-	    (sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
+	    (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) &&
 	    !sc->sc_config.swBeaconProcess)
 		sc->sc_imask |= ATH9K_INT_TIM;
 	/*
@@ -1142,7 +1142,7 @@ int ath_init(u16 devid, struct ath_softc *sc)
 		goto bad;
 
 	/* default to STA mode */
-	sc->sc_ah->ah_opmode = ATH9K_M_MONITOR;
+	sc->sc_ah->ah_opmode = NL80211_IFTYPE_MONITOR;
 
 	/* Setup rate tables */
 
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index fbff9aa..6dd0d80 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -745,7 +745,7 @@ struct ath_vap_config {
 /* driver-specific vap state */
 struct ath_vap {
 	struct ieee80211_vif *av_if_data;
-	enum ath9k_opmode av_opmode;	/* VAP operational mode */
+	enum nl80211_iftype av_opmode;	/* VAP operational mode */
 	struct ath_buf *av_bcbuf;	/* beacon buffer */
 	struct ath_tx_control av_btxctl;  /* txctl information for beacon */
 	int av_bslot;			/* beacon slot index */
@@ -756,7 +756,7 @@ struct ath_vap {
 int ath_vap_attach(struct ath_softc *sc,
 		   int if_id,
 		   struct ieee80211_vif *if_data,
-		   enum ath9k_opmode opmode);
+		   enum nl80211_iftype opmode);
 int ath_vap_detach(struct ath_softc *sc, int if_id);
 int ath_vap_config(struct ath_softc *sc,
 		   int if_id, struct ath_vap_config *if_config);
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 45fd2ce..ab034ad 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -375,7 +375,7 @@ static void ath9k_hw_init_bb(struct ath_hal *ah,
 }
 
 static void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
-					  enum ath9k_opmode opmode)
+					  enum nl80211_iftype opmode)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -392,7 +392,7 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
 
 	ahp->ah_maskReg |= AR_IMR_TXOK;
 
-	if (opmode == ATH9K_M_HOSTAP)
+	if (opmode == NL80211_IFTYPE_AP)
 		ahp->ah_maskReg |= AR_IMR_MIB;
 
 	REG_WRITE(ah, AR_IMR, ahp->ah_maskReg);
@@ -1514,18 +1514,18 @@ static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
 	val = REG_READ(ah, AR_STA_ID1);
 	val &= ~(AR_STA_ID1_STA_AP | AR_STA_ID1_ADHOC);
 	switch (opmode) {
-	case ATH9K_M_HOSTAP:
+	case NL80211_IFTYPE_AP:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_STA_AP
 			  | AR_STA_ID1_KSRCH_MODE);
 		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
-	case ATH9K_M_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_ADHOC
 			  | AR_STA_ID1_KSRCH_MODE);
 		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
-	case ATH9K_M_STA:
-	case ATH9K_M_MONITOR:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_MONITOR:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_KSRCH_MODE);
 		break;
 	}
@@ -2359,7 +2359,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 		}
 	}
 
-	if (ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX) {
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
@@ -2426,7 +2426,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 			return;
 		}
 	}
-	if (ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX) {
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
@@ -2463,8 +2463,8 @@ static void ath9k_ani_reset(struct ath_hal *ah)
 	aniState = &ahp->ah_ani[index];
 	ahp->ah_curani = aniState;
 
-	if (DO_ANI(ah) && ah->ah_opmode != ATH9K_M_STA
-	    && ah->ah_opmode != ATH9K_M_IBSS) {
+	if (DO_ANI(ah) && ah->ah_opmode != NL80211_IFTYPE_STATION
+	    && ah->ah_opmode != NL80211_IFTYPE_ADHOC) {
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			 "%s: Reset ANI state opmode %u\n", __func__,
 			 ah->ah_opmode);
@@ -2480,7 +2480,7 @@ static void ath9k_ani_reset(struct ath_hal *ah)
 		ath9k_hw_setrxfilter(ah,
 				     ath9k_hw_getrxfilter(ah) |
 				     ATH9K_RX_FILTER_PHYERR);
-		if (ah->ah_opmode == ATH9K_M_HOSTAP) {
+		if (ah->ah_opmode == NL80211_IFTYPE_AP) {
 			ahp->ah_curani->ofdmTrigHigh =
 				ah->ah_config.ofdm_trig_high;
 			ahp->ah_curani->ofdmTrigLow =
@@ -2593,7 +2593,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 
 	aniState = ahp->ah_curani;
 
-	if (ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel > 0) {
 			if (ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 						 aniState->firstepLevel - 1)) {
@@ -2957,7 +2957,7 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 
 	capField = ath9k_hw_get_eeprom(ahp, EEP_OP_CAP);
 
-	if (ah->ah_opmode != ATH9K_M_HOSTAP &&
+	if (ah->ah_opmode != NL80211_IFTYPE_AP &&
 	    ah->ah_subvendorid == AR_SUBVENDOR_ID_NEW_A) {
 		if (ah->ah_currentRD == 0x64 || ah->ah_currentRD == 0x65)
 			ah->ah_currentRD += 5;
@@ -7045,14 +7045,14 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 	ahp->ah_beaconInterval = beacon_period;
 
 	switch (ah->ah_opmode) {
-	case ATH9K_M_STA:
-	case ATH9K_M_MONITOR:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_MONITOR:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
 		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, 0xffff);
 		REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
 		flags |= AR_TBTT_TIMER_EN;
 		break;
-	case ATH9K_M_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		REG_SET_BIT(ah, AR_TXCFG,
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
 		REG_WRITE(ah, AR_NEXT_NDP_TIMER,
@@ -7060,7 +7060,7 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 				     (ahp->ah_atimWindow ? ahp->
 				      ah_atimWindow : 1)));
 		flags |= AR_NDP_TIMER_EN;
-	case ATH9K_M_HOSTAP:
+	case NL80211_IFTYPE_AP:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
 		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT,
 			  TU_TO_USEC(next_beacon -
@@ -7073,6 +7073,11 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 		flags |=
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
 		break;
+
+	default:
+		DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "%s: invalid opmode %d\n",
+				__func__, ah->ah_opmode);
+		return;
 	}
 
 	REG_WRITE(ah, AR_BEACON_PERIOD, TU_TO_USEC(beacon_period));
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 58d86b2..45a87a7 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -371,7 +371,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		}
 
 		/* New association, store aid */
-		if (avp->av_opmode == ATH9K_M_STA) {
+		if (avp->av_opmode == NL80211_IFTYPE_STATION) {
 			sc->sc_curaid = bss_conf->aid;
 			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
 					       sc->sc_curaid);
@@ -1139,13 +1139,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
-		ic_opmode = ATH9K_M_STA;
+		ic_opmode = NL80211_IFTYPE_STATION;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		ic_opmode = ATH9K_M_IBSS;
+		ic_opmode = NL80211_IFTYPE_ADHOC;
 		break;
 	case NL80211_IFTYPE_AP:
-		ic_opmode = ATH9K_M_HOSTAP;
+		ic_opmode = NL80211_IFTYPE_AP;
 		break;
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -1202,8 +1202,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath_rate_newstate(sc, avp);
 
 	/* Reclaim beacon resources */
-	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP ||
-	    sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP ||
+	    sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC) {
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
 		ath_beacon_return(sc, avp);
 	}
@@ -1280,8 +1280,8 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	/* TODO: Need to decide which hw opmode to use for multi-interface
 	 * cases */
 	if (vif->type == NL80211_IFTYPE_AP &&
-	    ah->ah_opmode != ATH9K_M_HOSTAP) {
-		ah->ah_opmode = ATH9K_M_HOSTAP;
+	    ah->ah_opmode != NL80211_IFTYPE_AP) {
+		ah->ah_opmode = NL80211_IFTYPE_AP;
 		ath9k_hw_setopmode(ah);
 		ath9k_hw_write_associd(ah, sc->sc_myaddr, 0);
 		/* Request full reset to get hw opmode changed properly */
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 8283228..e66cf7f 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -184,7 +184,7 @@ static int ath_ampdu_input(struct ath_softc *sc,
 		tid = qc[0] & 0xf;
 	}
 
-	if (sc->sc_ah->ah_opmode == ATH9K_M_STA) {
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) {
 		/* Drop the frame not belonging to me. */
 		if (memcmp(hdr->addr1, sc->sc_myaddr, ETH_ALEN)) {
 			dev_kfree_skb(skb);
@@ -606,26 +606,26 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		| ATH9K_RX_FILTER_MCAST;
 
 	/* If not a STA, enable processing of Probe Requests */
-	if (sc->sc_ah->ah_opmode != ATH9K_M_STA)
+	if (sc->sc_ah->ah_opmode != NL80211_IFTYPE_STATION)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
 	/* Can't set HOSTAP into promiscous mode */
-	if (((sc->sc_ah->ah_opmode != ATH9K_M_HOSTAP) &&
+	if (((sc->sc_ah->ah_opmode != NL80211_IFTYPE_AP) &&
 	     (sc->rx_filter & FIF_PROMISC_IN_BSS)) ||
-	    (sc->sc_ah->ah_opmode == ATH9K_M_MONITOR)) {
+	    (sc->sc_ah->ah_opmode == NL80211_IFTYPE_MONITOR)) {
 		rfilt |= ATH9K_RX_FILTER_PROM;
 		/* ??? To prevent from sending ACK */
 		rfilt &= ~ATH9K_RX_FILTER_UCAST;
 	}
 
-	if (((sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
+	if (((sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) &&
 	     (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)) ||
-	    (sc->sc_ah->ah_opmode == ATH9K_M_IBSS))
+	    (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC))
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
 	   & beacon frames */
-	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP)
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP)
 		rfilt |= (ATH9K_RX_FILTER_BEACON | ATH9K_RX_FILTER_PSPOLL);
 	return rfilt;
 
@@ -905,7 +905,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			 * Enable this if you want to see
 			 * error frames in Monitor mode.
 			 */
-			if (sc->sc_ah->ah_opmode != ATH9K_M_MONITOR)
+			if (sc->sc_ah->ah_opmode != NL80211_IFTYPE_MONITOR)
 				goto rx_next;
 #endif
 			/* fall thru for monitor mode handling... */
@@ -950,7 +950,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			 * decryption and MIC failures. For monitor mode,
 			 * we also ignore the CRC error.
 			 */
-			if (sc->sc_ah->ah_opmode == ATH9K_M_MONITOR) {
+			if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_MONITOR) {
 				if (ds->ds_rxstat.rs_status &
 				    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 					ATH9K_RXERR_CRC))
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 62e2888..13fdc22 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -463,7 +463,7 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 		return false;
 	}
 
-	if ((rd->flags & NO_HOSTAP) && (ah->ah_opmode == ATH9K_M_HOSTAP)) {
+	if ((rd->flags & NO_HOSTAP) && (ah->ah_opmode == NL80211_IFTYPE_AP)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			"Skipping HOSTAP channel\n");
 		return false;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index b80315b..91b2da3 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -932,7 +932,8 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 				 * when perform internal reset in this routine.
 				 * Only enable reset in STA mode for now.
 				 */
-				if (sc->sc_ah->ah_opmode == ATH9K_M_STA)
+				if (sc->sc_ah->ah_opmode ==
+						NL80211_IFTYPE_STATION)
 					needreset = 1;
 			}
 		} else {


