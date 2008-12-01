Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:19238 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYLAVmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 16:42:40 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1049993yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 13:42:39 -0800 (PST)
From: Colin McCabe <colin@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Luis Rodriguez <lrodriguez@atheros.com>,
	Colin McCabe <colin@cozybit.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] ath9k: Replace ath9k_opmode with nl80211_iftype
Date: Mon,  1 Dec 2008 13:38:55 -0800
Message-Id: <1228167535-6501-1-git-send-email-colin@cozybit.com> (sfid-20081201_224246_127221_A7544843)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch kills ath9k's ath9k_opmode enum by replacing it with nl80211_iftype.

Signed-off-by: Colin McCabe <colin@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/ath9k/ani.c    |   12 ++++----
 drivers/net/wireless/ath9k/ath9k.h  |   10 +-----
 drivers/net/wireless/ath9k/beacon.c |   22 ++++++++--------
 drivers/net/wireless/ath9k/core.h   |    2 +-
 drivers/net/wireless/ath9k/hw.c     |   29 +++++++++++++--------
 drivers/net/wireless/ath9k/main.c   |   49 +++++++++++++++++++---------------
 drivers/net/wireless/ath9k/recv.c   |   16 +++++-----
 drivers/net/wireless/ath9k/regd.c   |    2 +-
 drivers/net/wireless/ath9k/xmit.c   |    3 +-
 9 files changed, 76 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index ada12e9..7ccf50c 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -303,7 +303,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 		}
 	}
 
-	if (ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX) {
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
@@ -368,7 +368,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 			return;
 		}
 	}
-	if (ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX) {
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
@@ -398,7 +398,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 
 	aniState = ahp->ah_curani;
 
-	if (ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (ah->ah_opmode == NL80211_IFTYPE_AP) {
 		if (aniState->firstepLevel > 0) {
 			if (ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 						 aniState->firstepLevel - 1))
@@ -487,8 +487,8 @@ void ath9k_ani_reset(struct ath_hal *ah)
 	aniState = &ahp->ah_ani[index];
 	ahp->ah_curani = aniState;
 
-	if (DO_ANI(ah) && ah->ah_opmode != ATH9K_M_STA
-	    && ah->ah_opmode != ATH9K_M_IBSS) {
+	if (DO_ANI(ah) && ah->ah_opmode != NL80211_IFTYPE_STATION
+	    && ah->ah_opmode != NL80211_IFTYPE_ADHOC) {
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			"%s: Reset ANI state opmode %u\n", __func__,
 			ah->ah_opmode);
@@ -505,7 +505,7 @@ void ath9k_ani_reset(struct ath_hal *ah)
 		ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) |
 				     ATH9K_RX_FILTER_PHYERR);
 
-		if (ah->ah_opmode == ATH9K_M_HOSTAP) {
+		if (ah->ah_opmode == NL80211_IFTYPE_AP) {
 			ahp->ah_curani->ofdmTrigHigh =
 				ah->ah_config.ofdm_trig_high;
 			ahp->ah_curani->ofdmTrigLow =
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 5b9bc54..f98a100 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -647,13 +647,6 @@ enum ath9k_ant_setting {
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
@@ -780,7 +773,8 @@ struct ath_hal {
 
 	void __iomem *ah_sh;
 	struct ath_softc *ah_sc;
-	enum ath9k_opmode ah_opmode;
+
+	enum nl80211_iftype ah_opmode;
 	struct ath9k_ops_config ah_config;
 	struct ath9k_hw_capabilities ah_caps;
 
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index e80d9b9..3ff3b16 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -27,7 +27,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	struct ath9k_tx_queue_info qi;
 
 	ath9k_hw_get_txq_props(ah, sc->sc_bhalq, &qi);
-	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
 		/* Always burst out beacon and CAB traffic. */
 		qi.tqi_aifs = 1;
 		qi.tqi_cwmin = 0;
@@ -84,7 +84,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 
 	flags = ATH9K_TXDESC_NOACK;
 
-	if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS &&
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC &&
 	    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 		ds->ds_link = bf->bf_daddr; /* self-linked */
 		flags |= ATH9K_TXDESC_VEOL;
@@ -304,7 +304,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 						 struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
 
-		if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP ||
+		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP ||
 		    !(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 			int slot;
 			/*
@@ -614,16 +614,16 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_beacon_config conf;
 	struct ath_vap *avp;
-	enum ath9k_opmode av_opmode;
+	enum nl80211_iftype opmode;
 	u32 nexttbtt, intval;
 
 	if (if_id != ATH_IF_ID_ANY) {
 		vif = sc->sc_vaps[if_id];
 		ASSERT(vif);
 		avp = (void *)vif->drv_priv;
-		av_opmode = avp->av_opmode;
+		opmode = avp->av_opmode;
 	} else {
-		av_opmode = sc->sc_ah->ah_opmode;
+		opmode = sc->sc_ah->ah_opmode;
 	}
 
 	memset(&conf, 0, sizeof(struct ath_beacon_config));
@@ -639,7 +639,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	nexttbtt = TSF_TO_TU(sc->bc_tstamp >> 32, sc->bc_tstamp);
 
 	/* XXX conditionalize multi-bss support? */
-	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
 		/*
 		 * For multi-bss ap support beacons are either staggered
 		 * evenly over N slots or burst together.  For the former
@@ -662,7 +662,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		__func__, nexttbtt, intval, conf.beacon_interval);
 
 	/* Check for ATH9K_M_HOSTAP and sc_nostabeacons for WDS client */
-	if (sc->sc_ah->ah_opmode == ATH9K_M_STA) {
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) {
 		struct ath9k_beacon_state bs;
 		u64 tsf;
 		u32 tsftu;
@@ -782,7 +782,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		ath9k_hw_set_interrupts(ah, 0);
 		if (nexttbtt == intval)
 			intval |= ATH9K_BEACON_RESET_TSF;
-		if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
+		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC) {
 			/*
 			 * Pull nexttbtt forward to reflect the current
 			 * TSF
@@ -814,7 +814,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			if (!(ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
 				sc->sc_imask |= ATH9K_INT_SWBA;
 			ath_beaconq_config(sc);
-		} else if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
+		} else if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
 			/*
 			 * In AP mode we enable the beacon timers and
 			 * SWBA interrupts to prepare beacon frames.
@@ -830,7 +830,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * When using a self-linked beacon descriptor in
 		 * ibss mode load it once here.
 		 */
-		if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS &&
+		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC &&
 		    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
 			ath_beacon_start_adhoc(sc, 0);
 	}
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index f0c5437..f4f3592 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -503,7 +503,7 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 /* driver-specific vap state */
 struct ath_vap {
 	int av_bslot;			/* beacon slot index */
-	enum ath9k_opmode av_opmode;	/* VAP operational mode */
+	enum nl80211_iftype av_opmode;	/* VAP operational mode */
 	struct ath_buf *av_bcbuf;	/* beacon buffer */
 	struct ath_tx_control av_btxctl;  /* txctl information for beacon */
 };
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index ae7b1d6..46ce2f8 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1046,7 +1046,8 @@ static void ath9k_hw_init_chain_masks(struct ath_hal *ah)
 			  REG_READ(ah, AR_PHY_ANALOG_SWAP) | 0x00000001);
 }
 
-static void ath9k_hw_init_interrupt_masks(struct ath_hal *ah, enum ath9k_opmode opmode)
+static void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
+					  enum nl80211_iftype opmode)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -1063,7 +1064,7 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hal *ah, enum ath9k_opmode
 
 	ahp->ah_maskReg |= AR_IMR_TXOK;
 
-	if (opmode == ATH9K_M_HOSTAP)
+	if (opmode == NL80211_IFTYPE_AP)
 		ahp->ah_maskReg |= AR_IMR_MIB;
 
 	REG_WRITE(ah, AR_IMR, ahp->ah_maskReg);
@@ -1431,18 +1432,18 @@ static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
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
@@ -3083,14 +3084,14 @@ void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period)
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
@@ -3098,7 +3099,7 @@ void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period)
 				     (ahp->ah_atimWindow ? ahp->
 				      ah_atimWindow : 1)));
 		flags |= AR_NDP_TIMER_EN;
-	case ATH9K_M_HOSTAP:
+	case NL80211_IFTYPE_AP:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
 		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT,
 			  TU_TO_USEC(next_beacon -
@@ -3111,6 +3112,12 @@ void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period)
 		flags |=
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
 		break;
+	default:
+		DPRINTF(ah->ah_sc, ATH_DBG_BEACON,
+			"%s: unsupported opmode: %d\n",
+			__func__, ah->ah_opmode);
+		return;
+		break;
 	}
 
 	REG_WRITE(ah, AR_BEACON_PERIOD, TU_TO_USEC(beacon_period));
@@ -3210,7 +3217,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 
 	capField = ath9k_hw_get_eeprom(ah, EEP_OP_CAP);
 
-	if (ah->ah_opmode != ATH9K_M_HOSTAP &&
+	if (ah->ah_opmode != NL80211_IFTYPE_AP &&
 	    ah->ah_subvendorid == AR_SUBVENDOR_ID_NEW_A) {
 		if (ah->ah_currentRD == 0x64 || ah->ah_currentRD == 0x65)
 			ah->ah_currentRD += 5;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 6e103d5..f6b6577 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -758,13 +758,17 @@ static int ath_key_config(struct ath_softc *sc,
 
 	/*
 	 *  Strategy:
-	 *   For _M_STA mc tx, we will not setup a key at all since we never
-	 *   tx mc.
-	 *   _M_STA mc rx, we will use the keyID.
-	 *   for _M_IBSS mc tx, we will use the keyID, and no macaddr.
-	 *   for _M_IBSS mc rx, we will alloc a slot and plumb the mac of the
-	 *   peer node. BUT we will plumb a cleartext key so that we can do
-	 *   perSta default key table lookup in software.
+	 *   For STA mc tx, we will not setup a key at
+	 *   all since we never tx mc.
+	 *
+	 *   For STA mc rx, we will use the keyID.
+	 *
+	 *   For ADHOC mc tx, we will use the keyID, and no macaddr.
+	 *
+	 *   For ADHOC mc rx, we will alloc a slot and plumb the mac of
+	 *   the peer node.
+	 *   BUT we will plumb a cleartext key so that we can do
+	 *   per-Sta default key table lookup in software.
 	 */
 	if (is_broadcast_ether_addr(addr)) {
 		switch (opmode) {
@@ -857,7 +861,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			bss_conf->aid);
 
 		/* New association, store aid */
-		if (avp->av_opmode == ATH9K_M_STA) {
+		if (avp->av_opmode == NL80211_IFTYPE_STATION) {
 			sc->sc_curaid = bss_conf->aid;
 			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
 					       sc->sc_curaid);
@@ -1370,7 +1374,8 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 		goto bad;
 
 	/* default to MONITOR mode */
-	sc->sc_ah->ah_opmode = ATH9K_M_MONITOR;
+	sc->sc_ah->ah_opmode = NL80211_IFTYPE_MONITOR;
+
 
 	/* Setup rate tables */
 
@@ -1943,8 +1948,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * Note we only do this (at the moment) for station mode.
 	 */
 	if (ath9k_hw_phycounters(sc->sc_ah) &&
-	    ((sc->sc_ah->ah_opmode == ATH9K_M_STA) ||
-	     (sc->sc_ah->ah_opmode == ATH9K_M_IBSS)))
+	    ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) ||
+	     (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)))
 		sc->sc_imask |= ATH9K_INT_MIB;
 	/*
 	 * Some hardware processes the TIM IE and fires an
@@ -1953,7 +1958,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * enable the TIM interrupt when operating as station.
 	 */
 	if ((sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
-	    (sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
+	    (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) &&
 	    !sc->sc_config.swBeaconProcess)
 		sc->sc_imask |= ATH9K_INT_TIM;
 
@@ -2071,7 +2076,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_vap *avp = (void *)conf->vif->drv_priv;
-	int ic_opmode = 0;
+	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
 
 	/* Support only vap for now */
 
@@ -2080,13 +2085,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
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
@@ -2103,7 +2108,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	avp->av_opmode = ic_opmode;
 	avp->av_bslot = -1;
 
-	if (ic_opmode == ATH9K_M_HOSTAP)
+	if (ic_opmode == NL80211_IFTYPE_AP)
 		ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
 
 	sc->sc_vaps[0] = conf->vif;
@@ -2137,8 +2142,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	del_timer_sync(&sc->sc_ani.timer);
 
 	/* Reclaim beacon resources */
-	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP ||
-	    sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP ||
+	    sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC) {
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
 		ath_beacon_return(sc, avp);
 	}
@@ -2200,8 +2205,8 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	/* TODO: Need to decide which hw opmode to use for multi-interface
 	 * cases */
 	if (vif->type == NL80211_IFTYPE_AP &&
-	    ah->ah_opmode != ATH9K_M_HOSTAP) {
-		ah->ah_opmode = ATH9K_M_HOSTAP;
+	    ah->ah_opmode != NL80211_IFTYPE_AP) {
+		ah->ah_opmode = NL80211_IFTYPE_STATION;
 		ath9k_hw_setopmode(ah);
 		ath9k_hw_write_associd(ah, sc->sc_myaddr, 0);
 		/* Request full reset to get hw opmode changed properly */
@@ -2257,7 +2262,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	}
 
 	/* Check for WLAN_CAPABILITY_PRIVACY ? */
-	if ((avp->av_opmode != ATH9K_M_STA)) {
+	if ((avp->av_opmode != NL80211_IFTYPE_STATION)) {
 		for (i = 0; i < IEEE80211_WEP_NKID; i++)
 			if (ath9k_hw_keyisvalid(sc->sc_ah, (u16)i))
 				ath9k_hw_keysetmac(sc->sc_ah,
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index ba6194a..5eed0f6 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -165,7 +165,7 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 		 * discard the frame. Enable this if you want to see
 		 * error frames in Monitor mode.
 		 */
-		if (sc->sc_ah->ah_opmode != ATH9K_M_MONITOR)
+		if (sc->sc_ah->ah_opmode != NL80211_IFTYPE_MONITOR)
 			goto rx_next;
 	} else if (ds->ds_rxstat.rs_status != 0) {
 		if (ds->ds_rxstat.rs_status & ATH9K_RXERR_CRC)
@@ -191,7 +191,7 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 		 * decryption and MIC failures. For monitor mode,
 		 * we also ignore the CRC error.
 		 */
-		if (sc->sc_ah->ah_opmode == ATH9K_M_MONITOR) {
+		if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_MONITOR) {
 			if (ds->ds_rxstat.rs_status &
 			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 			      ATH9K_RXERR_CRC))
@@ -366,25 +366,25 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
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
 
-	if (sc->sc_ah->ah_opmode == ATH9K_M_STA ||
-	    sc->sc_ah->ah_opmode == ATH9K_M_IBSS)
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION ||
+	    sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
 	   & beacon frames */
-	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP)
+	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP)
 		rfilt |= (ATH9K_RX_FILTER_BEACON | ATH9K_RX_FILTER_PSPOLL);
 
 	return rfilt;
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
index 413fbdd..2cd288c 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -763,7 +763,8 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 				 * when perform internal reset in this routine.
 				 * Only enable reset in STA mode for now.
 				 */
-				if (sc->sc_ah->ah_opmode == ATH9K_M_STA)
+				if (sc->sc_ah->ah_opmode ==
+					    NL80211_IFTYPE_STATION)
 					needreset = 1;
 			}
 		} else {
-- 
1.5.6.3

