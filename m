Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51643 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYHKIqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:46:22 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:46:22 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63916.119545.939288@localhost.localdomain> (sfid-20080811_104625_503837_4A7E87A8)
Date: Mon, 11 Aug 2008 14:04:52 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 07/10] ath9k: Use a single opmode variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ah_opmode and sc_opmode are redundant.
This patch removes sc_opmode.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |    2 +-
 drivers/net/wireless/ath9k/beacon.c |   18 +++++++++---------
 drivers/net/wireless/ath9k/core.c   |   21 ++++++++++++---------
 drivers/net/wireless/ath9k/core.h   |    6 +++---
 drivers/net/wireless/ath9k/hw.c     |    8 +++-----
 drivers/net/wireless/ath9k/main.c   |    3 ++-
 drivers/net/wireless/ath9k/recv.c   |   18 +++++++++---------
 drivers/net/wireless/ath9k/xmit.c   |    4 ++--
 8 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 3e7072d..682d3bb 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -855,7 +855,7 @@ bool ath9k_regd_init_channels(struct ath_hal *ah,
 u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags);
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah,
 				     enum ath9k_int ints);
-bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
+bool ath9k_hw_reset(struct ath_hal *ah,
 		    struct ath9k_channel *chan,
 		    enum ath9k_ht_macmode macmode,
 		    u8 txchainmask, u8 rxchainmask,
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 67a8046..2736a4b 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -33,7 +33,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	struct ath9k_tx_queue_info qi;
 
 	ath9k_hw_get_txq_props(ah, sc->sc_bhalq, &qi);
-	if (sc->sc_opmode == ATH9K_M_HOSTAP) {
+	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
 		/* Always burst out beacon and CAB traffic. */
 		qi.tqi_aifs = 1;
 		qi.tqi_cwmin = 0;
@@ -85,7 +85,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 
 	flags = ATH9K_TXDESC_NOACK;
 
-	if (sc->sc_opmode == ATH9K_M_IBSS &&
+	if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS &&
 	    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 		ds->ds_link = bf->bf_daddr; /* self-linked */
 		flags |= ATH9K_TXDESC_VEOL;
@@ -375,7 +375,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 				struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
 
-		if (sc->sc_opmode == ATH9K_M_HOSTAP ||
+		if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP ||
 		    !(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 			int slot;
 			/*
@@ -750,7 +750,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	if (if_id != ATH_IF_ID_ANY)
 		av_opmode = sc->sc_vaps[if_id]->av_opmode;
 	else
-		av_opmode = sc->sc_opmode;
+		av_opmode = sc->sc_ah->ah_opmode;
 
 	memzero(&conf, sizeof(struct ath_beacon_config));
 
@@ -770,7 +770,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	nexttbtt = TSF_TO_TU(get_unaligned_le32(conf.u.last_tstamp + 4),
 			     get_unaligned_le32(conf.u.last_tstamp));
 	/* XXX conditionalize multi-bss support? */
-	if (sc->sc_opmode == ATH9K_M_HOSTAP) {
+	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
 		/*
 		 * For multi-bss ap support beacons are either staggered
 		 * evenly over N slots or burst together.  For the former
@@ -791,7 +791,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	DPRINTF(sc, ATH_DBG_BEACON, "%s: nexttbtt %u intval %u (%u)\n",
 		__func__, nexttbtt, intval, conf.beacon_interval);
 	/* Check for ATH9K_M_HOSTAP and sc_nostabeacons for WDS client */
-	if (sc->sc_opmode == ATH9K_M_STA) {
+	if (sc->sc_ah->ah_opmode == ATH9K_M_STA) {
 		struct ath9k_beacon_state bs;
 		u64 tsf;
 		u32 tsftu;
@@ -911,7 +911,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		ath9k_hw_set_interrupts(ah, 0);
 		if (nexttbtt == intval)
 			intval |= ATH9K_BEACON_RESET_TSF;
-		if (sc->sc_opmode == ATH9K_M_IBSS) {
+		if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
 			/*
 			 * Pull nexttbtt forward to reflect the current
 			 * TSF .
@@ -943,7 +943,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			if (!(ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
 				sc->sc_imask |= ATH9K_INT_SWBA;
 			ath_beaconq_config(sc);
-		} else if (sc->sc_opmode == ATH9K_M_HOSTAP) {
+		} else if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
 			/*
 			 * In AP mode we enable the beacon timers and
 			 * SWBA interrupts to prepare beacon frames.
@@ -959,7 +959,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * When using a self-linked beacon descriptor in
 		 * ibss mode load it once here.
 		 */
-		if (sc->sc_opmode == ATH9K_M_IBSS &&
+		if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS &&
 		    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
 			ath_beacon_start_adhoc(sc, 0);
 	}
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 7f92d46..8359356 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -355,7 +355,7 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 			fastcc = false;
 
 		spin_lock_bh(&sc->sc_resetlock);
-		if (!ath9k_hw_reset(ah, sc->sc_opmode, hchan,
+		if (!ath9k_hw_reset(ah, hchan,
 					ht_macmode, sc->sc_tx_chainmask,
 					sc->sc_rx_chainmask,
 					sc->sc_ht_extprotspacing,
@@ -533,7 +533,8 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(ah, rfilt);
 
-	if (sc->sc_opmode == ATH9K_M_STA || sc->sc_opmode == ATH9K_M_IBSS) {
+	if (sc->sc_ah->ah_opmode == ATH9K_M_STA ||
+	    sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
 		memcpy(sc->sc_curbssid, ath_bcast_mac, ETH_ALEN);
 		ath9k_hw_write_associd(ah, sc->sc_curbssid, sc->sc_curaid);
 	} else
@@ -603,7 +604,7 @@ int ath_vap_attach(struct ath_softc *sc,
 	sc->sc_vaps[if_id] = avp;
 	sc->sc_nvaps++;
 	/* Set the device opmode */
-	sc->sc_opmode = opmode;
+	sc->sc_ah->ah_opmode = opmode;
 
 	/* default VAP configuration */
 	avp->av_config.av_fixed_rateset = IEEE80211_FIXED_RATE_NONE;
@@ -677,7 +678,8 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	int error = 0;
 	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: mode %d\n", __func__, sc->sc_opmode);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: mode %d\n",
+		__func__, sc->sc_ah->ah_opmode);
 
 	/*
 	 * Stop anything previously setup.  This is safe
@@ -702,7 +704,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	sc->sc_curchan = *initial_chan;
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, sc->sc_opmode, &sc->sc_curchan, ht_macmode,
+	if (!ath9k_hw_reset(ah, &sc->sc_curchan, ht_macmode,
 			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			   sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -749,7 +751,8 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 * Note we only do this (at the moment) for station mode.
 	 */
 	if (ath9k_hw_phycounters(ah) &&
-	    ((sc->sc_opmode == ATH9K_M_STA) || (sc->sc_opmode == ATH9K_M_IBSS)))
+	    ((sc->sc_ah->ah_opmode == ATH9K_M_STA) ||
+	     (sc->sc_ah->ah_opmode == ATH9K_M_IBSS)))
 		sc->sc_imask |= ATH9K_INT_MIB;
 	/*
 	 * Some hardware processes the TIM IE and fires an
@@ -758,7 +761,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 * enable the TIM interrupt when operating as station.
 	 */
 	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
-	    (sc->sc_opmode == ATH9K_M_STA) &&
+	    (sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
 	    !sc->sc_config.swBeaconProcess)
 		sc->sc_imask |= ATH9K_INT_TIM;
 	/*
@@ -789,7 +792,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	/* Reset chip */
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, sc->sc_opmode, &sc->sc_curchan,
+	if (!ath9k_hw_reset(ah, &sc->sc_curchan,
 			   ht_macmode,
 			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			   sc->sc_ht_extprotspacing, false, &status)) {
@@ -1096,7 +1099,7 @@ int ath_init(u16 devid, struct ath_softc *sc)
 		goto bad;
 
 	/* default to STA mode */
-	sc->sc_opmode = ATH9K_M_MONITOR;
+	sc->sc_ah->ah_opmode = ATH9K_M_MONITOR;
 
 	/* Setup rate tables */
 
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 19399da..bfe1623 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -895,15 +895,15 @@ struct ath_ht_info {
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct pci_dev *pdev;
-	void __iomem *mem;
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
 	struct ath_config sc_config;	/* load-time parameters */
-	int sc_debug;
 	struct ath_hal *sc_ah;
 	struct ath_rate_softc *sc_rc;	/* tx rate control support */
+	void __iomem *mem;
+
+	int sc_debug;
 	u32 sc_intrstatus;
-	enum ath9k_opmode sc_opmode;	/* current operating mode */
 	unsigned int rx_filter;
 	u8 sc_invalid;			/* being detached */
 	u8 sc_beacons;			/* beacons running */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index b294485..72ad3f3 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -5835,7 +5835,7 @@ static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
 }
 
 
-bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
+bool ath9k_hw_reset(struct ath_hal *ah,
 		    struct ath9k_channel *chan,
 		    enum ath9k_ht_macmode macmode,
 		    u8 txchainmask, u8 rxchainmask,
@@ -5949,7 +5949,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		  | (ah->ah_config.
 		     ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
 		  | ahp->ah_staId1Defaults);
-	ath9k_hw_set_operating_mode(ah, opmode);
+	ath9k_hw_set_operating_mode(ah, ah->ah_opmode);
 
 	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(ahp->ah_bssidmask));
 	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(ahp->ah_bssidmask + 4));
@@ -5979,13 +5979,11 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 	for (i = 0; i < ah->ah_caps.total_queues; i++)
 		ath9k_hw_resettxqueue(ah, i);
 
-	ath9k_hw_init_interrupt_masks(ah, opmode);
+	ath9k_hw_init_interrupt_masks(ah, ah->ah_opmode);
 	ath9k_hw_init_qos(ah);
 
 	ath9k_hw_init_user_settings(ah);
 
-	ah->ah_opmode = opmode;
-
 	REG_WRITE(ah, AR_STA_ID1,
 		  REG_READ(ah, AR_STA_ID1) | AR_STA_ID1_PRESERVE_SEQNUM);
 
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 262fd7a..7504b64 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -472,7 +472,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath_rate_newstate(sc, avp);
 
 	/* Reclaim beacon resources */
-	if (sc->sc_opmode == ATH9K_M_HOSTAP || sc->sc_opmode == ATH9K_M_IBSS) {
+	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP ||
+	    sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
 		ath_beacon_return(sc, avp);
 	}
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index a125849..6d1d503 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -184,7 +184,7 @@ static int ath_ampdu_input(struct ath_softc *sc,
 		tid = qc[0] & 0xf;
 	}
 
-	if (sc->sc_opmode == ATH9K_M_STA) {
+	if (sc->sc_ah->ah_opmode == ATH9K_M_STA) {
 		/* Drop the frame not belonging to me. */
 		if (memcmp(hdr->addr1, sc->sc_myaddr, ETH_ALEN)) {
 			dev_kfree_skb(skb);
@@ -605,26 +605,26 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		| ATH9K_RX_FILTER_MCAST;
 
 	/* If not a STA, enable processing of Probe Requests */
-	if (sc->sc_opmode != ATH9K_M_STA)
+	if (sc->sc_ah->ah_opmode != ATH9K_M_STA)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
 	/* Can't set HOSTAP into promiscous mode */
-	if (((sc->sc_opmode != ATH9K_M_HOSTAP) &&
+	if (((sc->sc_ah->ah_opmode != ATH9K_M_HOSTAP) &&
 	     (sc->rx_filter & FIF_PROMISC_IN_BSS)) ||
-	    (sc->sc_opmode == ATH9K_M_MONITOR)) {
+	    (sc->sc_ah->ah_opmode == ATH9K_M_MONITOR)) {
 		rfilt |= ATH9K_RX_FILTER_PROM;
 		/* ??? To prevent from sending ACK */
 		rfilt &= ~ATH9K_RX_FILTER_UCAST;
 	}
 
-	if (((sc->sc_opmode == ATH9K_M_STA) &&
+	if (((sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
 	     (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)) ||
-	    (sc->sc_opmode == ATH9K_M_IBSS))
+	    (sc->sc_ah->ah_opmode == ATH9K_M_IBSS))
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
 	   & beacon frames */
-	if (sc->sc_opmode == ATH9K_M_HOSTAP)
+	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP)
 		rfilt |= (ATH9K_RX_FILTER_BEACON | ATH9K_RX_FILTER_PSPOLL);
 	return rfilt;
 
@@ -905,7 +905,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			 * Enable this if you want to see
 			 * error frames in Monitor mode.
 			 */
-			if (sc->sc_opmode != ATH9K_M_MONITOR)
+			if (sc->sc_ah->ah_opmode != ATH9K_M_MONITOR)
 				goto rx_next;
 #endif
 			/* fall thru for monitor mode handling... */
@@ -950,7 +950,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			 * decryption and MIC failures. For monitor mode,
 			 * we also ignore the CRC error.
 			 */
-			if (sc->sc_opmode == ATH9K_M_MONITOR) {
+			if (sc->sc_ah->ah_opmode == ATH9K_M_MONITOR) {
 				if (ds->ds_rxstat.rs_status &
 				    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 					ATH9K_RXERR_CRC))
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index a24a3a5..0b5b2dd 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1047,7 +1047,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 				 * when perform internal reset in this routine.
 				 * Only enable reset in STA mode for now.
 				 */
-				if (sc->sc_opmode == ATH9K_M_STA)
+				if (sc->sc_ah->ah_opmode == ATH9K_M_STA)
 					needreset = 1;
 			}
 		} else {
@@ -1454,7 +1454,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 			"%s: Unable to stop TxDMA. Reset HAL!\n", __func__);
 
 		spin_lock_bh(&sc->sc_resetlock);
-		if (!ath9k_hw_reset(ah, sc->sc_opmode,
+		if (!ath9k_hw_reset(ah,
 			&sc->sc_curchan, ht_macmode,
 			sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			sc->sc_ht_extprotspacing, true, &status)) {
-- 
1.5.6.5

