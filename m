Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17147 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbYG2Fro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:44 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:44 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 12/16] ath9k: Dont maintain some of h/w caps in ath_softc, access them directly from ah_caps instead.
Date: Mon, 28 Jul 2008 22:47:21 -0700
Message-ID: <44eaa0d616d7d1e378d5725812fbbccbe751ee70.1217309552.git.lrodriguez@atheros.com> (sfid-20080729_081546_520513_4C8411C2)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 0507940..596591e 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -84,7 +84,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 
 	flags = HAL_TXDESC_NOACK;
 
-	if (sc->sc_opmode == HAL_M_IBSS && sc->sc_hasveol) {
+	if (sc->sc_opmode == HAL_M_IBSS && ah->ah_caps.halVEOLSupport) {
 		ds->ds_link = bf->bf_daddr; /* self-linked */
 		flags |= HAL_TXDESC_VEOL;
 		/* Let hardware handle antenna switching. */
@@ -97,11 +97,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 		 * SWBA's
 		 * XXX assumes two antenna
 		 */
-		if (sc->sc_stagbeacons)
-			antenna = ((sc->ast_be_xmit /
-					sc->sc_nbcnvaps) & 1 ? 2 : 1);
-		else
-			antenna = (sc->ast_be_xmit & 1 ? 2 : 1);
+		antenna = ((sc->ast_be_xmit / sc->sc_nbcnvaps) & 1 ? 2 : 1);
 	}
 
 	ds->ds_data = bf->bf_buf_addr;
@@ -272,7 +268,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 		 * the lock again which is a common function and that
 		 * acquires txq lock inside.
 		 */
-		if (sc->sc_nvaps > 1 && sc->sc_stagbeacons) {
+		if (sc->sc_nvaps > 1) {
 			ath_tx_draintxq(sc, cabq, false);
 			DPRINTF(sc, ATH_DBG_BEACON,
 				"%s: flush previous cabq traffic\n", __func__);
@@ -377,7 +373,8 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 				struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
 
-		if (sc->sc_opmode == HAL_M_HOSTAP || !sc->sc_hasveol) {
+		if (sc->sc_opmode == HAL_M_HOSTAP ||
+			!sc->sc_ah->ah_caps.halVEOLSupport) {
 			int slot;
 			/*
 			 * Assign the vap to a beacon xmit slot. As
@@ -435,7 +432,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	 * of the beacon frame leaves the tstamp field immediately
 	 * following the header.
 	 */
-	if (sc->sc_stagbeacons && avp->av_bslot > 0) {
+	if (avp->av_bslot > 0) {
 		u_int64_t tsfadjust;
 		__le64 val;
 		int intval;
@@ -460,7 +457,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 
 		DPRINTF(sc, ATH_DBG_BEACON,
 			"%s: %s beacons, bslot %d intval %u tsfadjust %llu\n",
-			__func__, sc->sc_stagbeacons ? "stagger" : "burst",
+			__func__, "stagger",
 			avp->av_bslot, intval, (unsigned long long)tsfadjust);
 
 		wh = (struct ieee80211_hdr *)skb->data;
@@ -552,6 +549,9 @@ void ath9k_beacon_tasklet(unsigned long data)
 	u_int32_t rx_clear = 0, rx_frame = 0, tx_frame = 0;
 	u_int32_t show_cycles = 0;
 	u_int32_t bc = 0; /* beacon count */
+	u_int64_t tsf;
+	u_int32_t tsftu;
+	u_int16_t intval;
 
 	if (sc->sc_noreset) {
 		show_cycles = ath9k_hw_GetMibCycleCountsPct(ah,
@@ -636,55 +636,29 @@ void ath9k_beacon_tasklet(unsigned long data)
 	}
 
 	/*
-	 * Generate beacon frames.  If we are sending frames
-	 * staggered then calculate the slot for this frame based
+	 * Generate beacon frames. we are sending frames
+	 * staggered so calculate the slot for this frame based
 	 * on the tsf to safeguard against missing an swba.
-	 * Otherwise we are bursting all frames together and need
-	 * to generate a frame for each vap that is up and running.
 	 */
-	if (sc->sc_stagbeacons) {
-		/* staggered beacons */
-		u_int64_t tsf;
-		u_int32_t tsftu;
-		u_int16_t intval;
 
-		/* FIXME: Use default value for now - Sujith */
-		intval = ATH_DEFAULT_BINTVAL;
+	/* FIXME: Use default value for now - Sujith */
+	intval = ATH_DEFAULT_BINTVAL;
 
-		tsf = ath9k_hw_gettsf64(ah);
-		tsftu = TSF_TO_TU(tsf>>32, tsf);
-		slot = ((tsftu % intval) * ATH_BCBUF) / intval;
-		if_id = sc->sc_bslot[(slot + 1) % ATH_BCBUF];
-		DPRINTF(sc, ATH_DBG_BEACON,
+	tsf = ath9k_hw_gettsf64(ah);
+	tsftu = TSF_TO_TU(tsf>>32, tsf);
+	slot = ((tsftu % intval) * ATH_BCBUF) / intval;
+	if_id = sc->sc_bslot[(slot + 1) % ATH_BCBUF];
+	DPRINTF(sc, ATH_DBG_BEACON,
 			"%s: slot %d [tsf %llu tsftu %u intval %u] if_id %d\n",
 			__func__, slot, (unsigned long long) tsf, tsftu,
 			intval, if_id);
-		bfaddr = 0;
-		if (if_id != ATH_IF_ID_ANY) {
-			bf = ath_beacon_generate(sc, if_id);
-			if (bf != NULL) {
-				bfaddr = bf->bf_daddr;
-				bc = 1;
-			}
+	bfaddr = 0;
+	if (if_id != ATH_IF_ID_ANY) {
+		bf = ath_beacon_generate(sc, if_id);
+		if (bf != NULL) {
+			bfaddr = bf->bf_daddr;
+			bc = 1;
 		}
-	} else {
-		/* XXX: Clean this up, move work to a helper */
-		/* burst'd beacons */
-		u_int32_t *bflink;
-		bflink = &bfaddr;
-		/* XXX rotate/randomize order? */
-		for (slot = 0; slot < ATH_BCBUF; slot++) {
-			if_id = sc->sc_bslot[slot];
-			if (if_id != ATH_IF_ID_ANY) {
-				bf = ath_beacon_generate(sc, if_id);
-				if (bf != NULL) {
-					*bflink = bf->bf_daddr;
-					bflink = &bf->bf_desc->ds_link;
-					bc++;
-				}
-			}
-		}
-		*bflink = 0;    /* link of last frame */
 	}
 	/*
 	 * Handle slot time change when a non-ERP station joins/leaves
@@ -803,11 +777,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 */
 		/* NB: the beacon interval is kept internally in TU's */
 		intval = conf.beacon_interval & HAL_BEACON_PERIOD;
-		if (sc->sc_stagbeacons)
-			intval /= ATH_BCBUF;    /* for staggered beacons */
-		if ((sc->sc_nostabeacons) &&
-		    (av_opmode == HAL_M_HOSTAP))
-			nexttbtt = 0;
+		intval /= ATH_BCBUF;    /* for staggered beacons */
 	} else {
 		intval = conf.beacon_interval & HAL_BEACON_PERIOD;
 	}
@@ -819,10 +789,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	DPRINTF(sc, ATH_DBG_BEACON, "%s: nexttbtt %u intval %u (%u)\n",
 		__func__, nexttbtt, intval, conf.beacon_interval);
 	/* Check for HAL_M_HOSTAP and sc_nostabeacons for WDS client */
-	if ((sc->sc_opmode == HAL_M_STA) ||
-	     ((sc->sc_opmode == HAL_M_HOSTAP) &&
-	      (av_opmode == HAL_M_STA) &&
-	      (sc->sc_nostabeacons))) {
+	if (sc->sc_opmode == HAL_M_STA) {
 		struct hal_beacon_state bs;
 		u_int64_t tsf;
 		u_int32_t tsftu;
@@ -932,12 +899,10 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			, bs.bs_timoffset
 			);
 
-		if (!(sc->sc_nostabeacons)) {
-			ath9k_hw_set_interrupts(ah, 0);
-			ath9k_hw_set_sta_beacon_timers(ah, &bs);
-			sc->sc_imask |= HAL_INT_BMISS;
-			ath9k_hw_set_interrupts(ah, sc->sc_imask);
-		}
+		ath9k_hw_set_interrupts(ah, 0);
+		ath9k_hw_set_sta_beacon_timers(ah, &bs);
+		sc->sc_imask |= HAL_INT_BMISS;
+		ath9k_hw_set_interrupts(ah, sc->sc_imask);
 	} else {
 		u_int64_t tsf;
 		u_int32_t tsftu;
@@ -973,7 +938,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			 * deal with things.
 			 */
 			intval |= HAL_BEACON_ENA;
-			if (!sc->sc_hasveol)
+			if (!ah->ah_caps.halVEOLSupport)
 				sc->sc_imask |= HAL_INT_SWBA;
 			ath_beaconq_config(sc);
 		} else if (sc->sc_opmode == HAL_M_HOSTAP) {
@@ -992,7 +957,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * When using a self-linked beacon descriptor in
 		 * ibss mode load it once here.
 		 */
-		if (sc->sc_opmode == HAL_M_IBSS && sc->sc_hasveol)
+		if (sc->sc_opmode == HAL_M_IBSS && ah->ah_caps.halVEOLSupport)
 			ath_beacon_start_adhoc(sc, 0);
 	}
 #undef TSF_TO_TU
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 25ae517..587f307 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -361,6 +361,8 @@ void ath_scan_end(struct ath_softc *sc)
 	u_int32_t now = (u_int32_t) jiffies_to_msecs(get_timestamp());
 
 	sc->sc_scanning = 0;
+	/* Request for a full reset due to rx packet filter changes */
+	sc->sc_full_reset = 1;
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(ah, rfilt);
 	ath9k_hw_write_associd(ah, sc->sc_curbssid, sc->sc_curaid);
@@ -507,7 +509,7 @@ int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an)
 	 * sc_chainmask_auto_sel is used for internal global auto-switching
 	 * enabled/disabled setting
 	 */
-	if (!sc->sc_no_tx_3_chains || !sc->sc_config.chainmask_sel) {
+	if (sc->sc_ah->ah_caps.halTxChainMask != ATH_CHAINMASK_SEL_3X3) {
 		cm->cur_tx_mask = sc->sc_tx_chainmask;
 		return cm->cur_tx_mask;
 	}
@@ -589,8 +591,7 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 	}
 
 #ifdef CONFIG_SLOW_ANT_DIV
-	if (sc->sc_slowAntDiv)
-		ath_slow_ant_div_stop(&sc->sc_antdiv);
+	ath_slow_ant_div_stop(&sc->sc_antdiv);
 #endif
 
 	/* update ratectrl about the new state */
@@ -626,8 +627,7 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 int ath_vap_attach(struct ath_softc *sc,
 		   int if_id,
 		   struct ieee80211_vif *if_data,
-		   enum hal_opmode opmode,
-		   int nostabeacons)
+		   enum hal_opmode opmode)
 {
 	struct ath_vap *avp;
 
@@ -639,14 +639,10 @@ int ath_vap_attach(struct ath_softc *sc,
 
 	switch (opmode) {
 	case HAL_M_STA:
-		sc->sc_nostabeacons = nostabeacons;
-		break;
 	case HAL_M_IBSS:
 	case HAL_M_MONITOR:
 		break;
 	case HAL_M_HOSTAP:
-		/* copy nostabeacons - for WDS client */
-		sc->sc_nostabeacons = nostabeacons;
 		/* XXX not right, beacon buffer is allocated on RUN trans */
 		if (list_empty(&sc->sc_bbuf))
 			return -ENOMEM;
@@ -668,19 +664,8 @@ int ath_vap_attach(struct ath_softc *sc,
 	INIT_LIST_HEAD(&avp->av_mcastq.axq_q);
 	INIT_LIST_HEAD(&avp->av_mcastq.axq_acq);
 	spin_lock_init(&avp->av_mcastq.axq_lock);
-	if (opmode == HAL_M_HOSTAP || opmode == HAL_M_IBSS) {
-		if (sc->sc_hastsfadd) {
-			/*
-			 * Multiple vaps are to transmit beacons and we
-			 * have h/w support for TSF adjusting; enable use
-			 * of staggered beacons.
-			 */
-			/* XXX check for beacon interval too small */
-			sc->sc_stagbeacons = 1;
-		}
-	}
-	if (sc->sc_hastsfadd)
-		ath9k_hw_set_tsfadjust(sc->sc_ah, sc->sc_stagbeacons);
+
+	ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
 
 	sc->sc_vaps[if_id] = avp;
 	sc->sc_nvaps++;
@@ -721,9 +706,6 @@ int ath_vap_detach(struct ath_softc *sc, int if_id)
 	/* Reclaim any pending mcast bufs on the vap. */
 	ath_tx_draintxq(sc, &avp->av_mcastq, false);
 
-	if (sc->sc_opmode == HAL_M_HOSTAP && sc->sc_nostabeacons)
-		sc->sc_nostabeacons = 0;
-
 	kfree(avp);
 	sc->sc_vaps[if_id] = NULL;
 	sc->sc_nvaps--;
@@ -826,7 +808,7 @@ int ath_open(struct ath_softc *sc, struct hal_channel *initial_chan)
 	if (ah->ah_caps.halGTTSupport)
 		sc->sc_imask |= HAL_INT_GTT;
 
-	if (sc->sc_hashtsupport)
+	if (ah->ah_caps.halHTSupport)
 		sc->sc_imask |= HAL_INT_CST;
 
 	/*
@@ -1052,13 +1034,10 @@ irqreturn_t ath_isr(int irq, void *dev)
 				ath9k_hw_set_interrupts(ah, sc->sc_imask);
 			}
 			if (status & HAL_INT_TIM_TIMER) {
-				if (!sc->sc_hasautosleep) {
+				if (!ah->ah_caps.halAutoSleepSupport) {
 					/* Clear RxAbort bit so that we can
 					 * receive frames */
 					ath9k_hw_setrxabort(ah, 0);
-					/* Set flag indicating we're waiting
-					 * for a beacon */
-					sc->sc_waitbeacon = 1;
 					sched = true;
 				}
 			}
@@ -1274,9 +1253,6 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 		goto bad2;
 	}
 
-	if (ah->ah_caps.halHTSupport)
-		sc->sc_hashtsupport = 1;
-
 	sc->sc_rc = ath_rate_attach(ah);
 	if (sc->sc_rc == NULL) {
 		error = EIO;
@@ -1292,8 +1268,6 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 		 */
 		ath9k_hw_setcapability(sc->sc_ah, HAL_CAP_TKIP_MIC, 0, 1, NULL);
 	}
-	sc->sc_hasclrkey = ath9k_hw_getcapability(ah, HAL_CAP_CIPHER,
-						  HAL_CIPHER_CLR, NULL);
 
 	/*
 	 * Check whether the separate key cache entries
@@ -1316,26 +1290,11 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	sc->sc_config.txpowlimit_override = 0;
 
 	/* 11n Capabilities */
-	if (sc->sc_hashtsupport) {
+	if (ah->ah_caps.halHTSupport) {
 		sc->sc_txaggr = 1;
 		sc->sc_rxaggr = 1;
 	}
 
-	/* Check for misc other capabilities. */
-	sc->sc_hasbmask = ah->ah_caps.halBssIdMaskSupport ? 1 : 0;
-	sc->sc_hastsfadd =
-		ath9k_hw_getcapability(ah, HAL_CAP_TSF_ADJUST, 0, NULL);
-
-	/*
-	 * If we cannot transmit on three chains, prevent chain mask
-	 * selection logic from switching between 2x2 and 3x3 chain
-	 * masks based on RSSI.
-	 */
-	sc->sc_no_tx_3_chains =
-	    (ah->ah_caps.halTxChainMask == ATH_CHAINMASK_SEL_3X3) ?
-		true : false;
-	sc->sc_config.chainmask_sel = sc->sc_no_tx_3_chains;
-
 	sc->sc_tx_chainmask = ah->ah_caps.halTxChainMask;
 	sc->sc_rx_chainmask = ah->ah_caps.halRxChainMask;
 
@@ -1349,20 +1308,12 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	ath9k_hw_setcapability(ah, HAL_CAP_DIVERSITY, 1, true, NULL);
 	sc->sc_defant = ath9k_hw_getdefantenna(ah);
 
-	/*
-	 * Not all chips have the VEOL support we want to
-	 * use with IBSS beacons; check here for it.
-	 */
-	sc->sc_hasveol = ah->ah_caps.halVEOLSupport;
-
 	ath9k_hw_getmac(ah, sc->sc_myaddr);
-	if (sc->sc_hasbmask) {
+	if (ah->ah_caps.halBssIdMaskSupport) {
 		ath9k_hw_getbssidmask(ah, sc->sc_bssidmask);
 		ATH_SET_VAP_BSSID_MASK(sc->sc_bssidmask);
 		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
 	}
-	sc->sc_hasautosleep = ah->ah_caps.halAutoSleepSupport;
-	sc->sc_waitbeacon = 0;
 	sc->sc_slottime = HAL_SLOT_TIME_9;	/* default to short slot time */
 
 	/* initialize beacon slots */
@@ -1373,11 +1324,8 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	sc->sc_config.swBeaconProcess = 1;
 
 #ifdef CONFIG_SLOW_ANT_DIV
-	sc->sc_slowAntDiv = 1;
 	/* range is 40 - 255, we use something in the middle */
 	ath_slow_ant_div_init(&sc->sc_antdiv, sc, 0x127);
-#else
-	sc->sc_slowAntDiv = 0;
 #endif
 
 	return 0;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 10ec3ae..fdd0f87 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -136,7 +136,6 @@ enum ATH_DEBUG {
 /* Per-instance load-time (note: NOT run-time) configurations
  * for Atheros Device */
 struct ath_config {
-	u_int8_t    chainmask_sel; /* enable automatic tx chainmask selection */
 	u_int32_t   ath_aggr_prot;
 	u_int16_t   txpowlimit;
 	u_int16_t   txpowlimit_override;
@@ -798,8 +797,7 @@ struct ath_vap {
 int ath_vap_attach(struct ath_softc *sc,
 		   int if_id,
 		   struct ieee80211_vif *if_data,
-		   enum hal_opmode opmode,
-		   int nostabeacons);
+		   enum hal_opmode opmode);
 int ath_vap_detach(struct ath_softc *sc, int if_id);
 int ath_vap_config(struct ath_softc *sc,
 	int if_id, struct ath_vap_config *if_config);
@@ -942,30 +940,13 @@ struct ath_softc {
 	enum hal_opmode         sc_opmode;  /* current operating mode */
 
 	/* Properties, Config */
-	unsigned int
-		sc_invalid,	/* being detached */
-		sc_hasveol             : 1, /* tx VEOL support */
-		sc_beacons             : 1, /* beacons running */
-		sc_hasbmask            : 1, /* bssid mask support */
-		sc_hastsfadd           : 1, /* tsf adjust support */
-		sc_scanning            : 1, /* scanning active */
-		sc_nostabeacons        : 1, /* no beacons for station */
-		sc_hasclrkey           : 1, /* CLR key supported */
-		sc_stagbeacons         : 1, /* use staggered beacons */
-		sc_txaggr              : 1, /* enable 11n tx aggregation */
-		sc_rxaggr              : 1, /* enable 11n rx aggregation */
-		sc_hasautosleep        : 1, /* automatic sleep after TIM */
-		sc_waitbeacon          : 1, /* waiting for first beacon
-						after waking up */
-		sc_no_tx_3_chains      : 1, /* user, hardware, regulatory
-					or country may disallow transmit on
-					three chains. */
-		sc_update_chainmask    : 1, /* change chain mask */
-		sc_rx_chainmask_detect : 1, /* enable rx chain mask detection */
-		sc_rx_chainmask_start  : 1, /* start rx chain mask detection */
-		sc_hashtsupport        : 1, /* supports 11n */
-		sc_full_reset          : 1, /* force full reset */
-		sc_slowAntDiv          : 1; /* enable slow antenna diversity */
+	u_int8_t                sc_invalid;	/* being detached */
+	u_int8_t                sc_beacons;	/* beacons running */
+	u_int8_t                sc_scanning;	/* scanning active */
+	u_int8_t                sc_txaggr;	/* enable 11n tx aggregation */
+	u_int8_t                sc_rxaggr;	/* enable 11n rx aggregation */
+	u_int8_t                sc_update_chainmask;	/* change chain mask */
+	u_int8_t                sc_full_reset;		/* force full reset */
 	enum wireless_mode      sc_curmode;     /* current phy mode */
 	u_int16_t               sc_curtxpow;    /* current tx power limit */
 	u_int16_t               sc_curaid;      /* current association id */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 08b4bd4..a16dbfb 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -6719,14 +6719,8 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 		}
 		return false;
 	case HAL_CAP_TSF_ADJUST:
-		switch (capability) {
-		case 0:
-			return true;
-		case 1:
-			return (ahp->ah_miscMode & AR_PCU_TX_ADD_TSF) ?
-				true : false;
-		}
-		return false;
+		return (ahp->ah_miscMode & AR_PCU_TX_ADD_TSF) ?
+			true : false;
 	case HAL_CAP_RFSILENT:
 		if (capability == 3)
 			return false;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 59f1204..7ef0d58 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -415,7 +415,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		__func__,
 		ic_opmode);
 
-	error = ath_vap_attach(sc, 0, conf->vif, ic_opmode, 0);
+	error = ath_vap_attach(sc, 0, conf->vif, ic_opmode);
 	if (error) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to attach vap, error: %d\n",
@@ -443,8 +443,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	}
 
 #ifdef CONFIG_SLOW_ANT_DIV
-	if (sc->sc_slowAntDiv)
-		ath_slow_ant_div_stop(&sc->sc_antdiv);
+	ath_slow_ant_div_stop(&sc->sc_antdiv);
 #endif
 
 	/* Update ratectrl */
@@ -526,10 +525,6 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
 					       sc->sc_curaid);
 
-			/* Enable rx chain mask detection if configured
-			   to do so */
-			sc->sc_rx_chainmask_detect = 0;
-
 			/* Set aggregation protection mode parameters */
 			sc->sc_config.ath_aggr_prot = 0;
 
@@ -1369,7 +1364,7 @@ static int ath_attach(u_int16_t devid,
 		sc->rates[IEEE80211_BAND_2GHZ];
 	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
 
-	if (sc->sc_hashtsupport)
+	if (sc->sc_ah->ah_caps.halHTSupport)
 		/* Setup HT capabilities for 2.4Ghz*/
 		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_info);
 
@@ -1384,7 +1379,7 @@ static int ath_attach(u_int16_t devid,
 		sc->sbands[IEEE80211_BAND_5GHZ].band =
 			IEEE80211_BAND_5GHZ;
 
-		if (sc->sc_hashtsupport)
+		if (sc->sc_ah->ah_caps.halHTSupport)
 			/* Setup HT capabilities for 5Ghz*/
 			setup_ht_cap(&sc->sbands[IEEE80211_BAND_5GHZ].ht_info);
 
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 963bcd9..6aefe59 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -385,60 +385,6 @@ static void ath_rx_flush_tid(struct ath_softc *sc,
 	spin_unlock_bh(&rxtid->tidlock);
 }
 
-static u_int8_t ath_rx_detect_antenna(struct ath_softc *sc,
-	struct ath_rx_status *rxstat)
-{
-#define ATH_RX_CHAINMASK_CLR(_chainmask, _chain) \
-	((_chainmask) &= ~(1 << (_chain)))
-	u_int8_t rx_chainmask = sc->sc_rx_chainmask;
-	int rssiRef, detectThresh, detectDelta;
-
-	if (IS_CHAN_5GHZ(&sc->sc_curchan)) {
-		detectThresh = sc->sc_rxchaindetect_thresh5GHz;
-		detectDelta = sc->sc_rxchaindetect_delta5GHz;
-	} else {
-		detectThresh = sc->sc_rxchaindetect_thresh2GHz;
-		detectDelta = sc->sc_rxchaindetect_delta2GHz;
-	}
-
-	switch (sc->sc_rxchaindetect_ref) {
-	case 0:
-		rssiRef = rxstat->rs_rssi;
-		if (rssiRef < detectThresh)
-			return 0;
-
-		if (rssiRef - rxstat->rs_rssi_ctl1 > detectDelta)
-			ATH_RX_CHAINMASK_CLR(rx_chainmask, 1);
-
-		if (rssiRef - rxstat->rs_rssi_ctl2 > detectDelta)
-			ATH_RX_CHAINMASK_CLR(rx_chainmask, 2);
-
-		break;
-	case 1:
-		rssiRef = rxstat->rs_rssi_ctl1;
-		if (rssiRef < detectThresh)
-			return 0;
-
-		if (rssiRef - rxstat->rs_rssi_ctl2 > detectDelta)
-			ATH_RX_CHAINMASK_CLR(rx_chainmask, 2);
-
-		break;
-	case 2:
-		rssiRef = rxstat->rs_rssi_ctl2;
-		if (rssiRef < detectThresh)
-			return 0;
-
-		if (rssiRef - rxstat->rs_rssi_ctl1 > detectDelta)
-			ATH_RX_CHAINMASK_CLR(rx_chainmask, 1);
-
-		break;
-	}
-
-	return rx_chainmask;
-#undef IS_CHAN_5GHZ
-#undef ATH_RX_CHAINMASK_CLR
-}
-
 static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc,
 	u_int32_t len)
 {
@@ -532,7 +478,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 	ath9k_hw_setrxfilter(ah, rfilt);
 
 	/* configure bssid mask */
-	if (sc->sc_hasbmask)
+	if (ah->ah_caps.halBssIdMaskSupport)
 		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
 
 	/* configure operational mode */
@@ -669,7 +615,7 @@ u_int32_t ath_calcrxfilter(struct ath_softc *sc)
 	}
 
 	if (sc->sc_opmode == HAL_M_STA || sc->sc_opmode == HAL_M_IBSS ||
-	    sc->sc_nostabeacons || sc->sc_scanning)
+	    sc->sc_scanning)
 		rfilt |= HAL_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
@@ -798,7 +744,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	struct ath_hal *ah = sc->sc_ah;
 	int type, rx_processed = 0;
 	u_int phyerr;
-	u_int8_t rxchainmask, chainreset = 0;
+	u_int8_t chainreset = 0;
 	enum hal_status retval;
 	__le16 fc;
 
@@ -1072,7 +1018,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 				 PCI_DMA_FROMDEVICE);
 
 		/* XXX: Ah! make me more readable, use a helper */
-		if (sc->sc_hashtsupport) {
+		if (ah->ah_caps.halHTSupport) {
 			if (ds->ds_rxstat.rs_moreaggr == 0) {
 				rx_status.rssictl[0] =
 					ds->ds_rxstat.rs_rssi_ctl0;
@@ -1120,27 +1066,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			sc->sc_rxotherant = 0;
 		}
 
-		/*
-		 * redo antenna detection for Lenovo devices
-		 */
-		if (sc->sc_rx_chainmask_detect && sc->sc_rx_chainmask_start) {
-			rxchainmask = ath_rx_detect_antenna(sc, &ds->ds_rxstat);
-			if (rxchainmask) {
-				sc->sc_rx_chainmask_detect = 0;
-				sc->sc_rx_chainmask_start  = 0;
-				if (sc->sc_rx_chainmask != rxchainmask) {
-					sc->sc_rx_chainmask = rxchainmask;
-
-					/* we have to do an reset to
-					 * change chain mask */
-					chainreset = 1;
-				}
-			}
-		}
-
 #ifdef CONFIG_SLOW_ANT_DIV
-		if (sc->sc_slowAntDiv &&
-		    (rx_status.flags & ATH_RX_RSSI_VALID) &&
+		if ((rx_status.flags & ATH_RX_RSSI_VALID) &&
 		    ieee80211_is_beacon(fc)) {
 			ath_slow_ant_div(&sc->sc_antdiv, hdr, &ds->ds_rxstat);
 		}
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 152f9f4..2e3ae65 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -780,7 +780,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * let rate series flags determine which rates will actually
 	 * use RTS.
 	 */
-	if (sc->sc_hashtsupport && bf->bf_isdata) {
+	if (ah->ah_caps.halHTSupport && bf->bf_isdata) {
 		BUG_ON(!an);
 		/*
 		 * 802.11g protection not needed, use our default behavior
@@ -896,7 +896,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * For non-HT devices, calculate RTS/CTS duration in software
 	 * and disable multi-rate retry.
 	 */
-	if (flags && !sc->sc_hashtsupport) {
+	if (flags && !ah->ah_caps.halHTSupport) {
 		/*
 		 * Compute the transmit duration based on the frame
 		 * size and the size of an ACK frame.  We call into the
-- 
1.5.4.3

