Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40014 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540AbZCCEut (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 23:50:49 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 20:50:48 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18860.46651.894877.71139@gargle.gargle.HOWL> (sfid-20090303_055111_696137_CA0A883B)
Date: Tue, 3 Mar 2009 10:16:51 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/7] ath9k: Scrub beacon.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove useless comments, fix indentation.
Also, remove all occurrences of ASSERT(vif) which are not needed.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |    2 +-
 drivers/net/wireless/ath9k/beacon.c |  177 +++++++++++------------------------
 drivers/net/wireless/ath9k/main.c   |    2 +-
 3 files changed, 55 insertions(+), 126 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index b60ad8d..7b1fbf3 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -453,7 +453,7 @@ struct ath_beacon {
 	struct list_head bbuf;
 };
 
-void ath9k_beacon_tasklet(unsigned long data);
+void ath_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, int if_id);
 int ath_beaconq_setup(struct ath_hw *ah);
 int ath_beacon_alloc(struct ath_softc *sc, int if_id);
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 18bda36..c304489 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -44,15 +44,14 @@ static int ath_beaconq_config(struct ath_softc *sc)
 			"unable to update h/w beacon queue parameters\n");
 		return 0;
 	} else {
-		ath9k_hw_resettxqueue(ah, sc->beacon.beaconq); /* push to h/w */
+		ath9k_hw_resettxqueue(ah, sc->beacon.beaconq);
 		return 1;
 	}
 }
 
 static void ath_bstuck_process(struct ath_softc *sc)
 {
-	DPRINTF(sc, ATH_DBG_BEACON,
-		"stuck beacon; resetting (bmiss count %u)\n",
+	DPRINTF(sc, ATH_DBG_BEACON, "stuck beacon; resetting (bmiss count %u)\n",
 		sc->beacon.bmisscnt);
 	ath_reset(sc, false);
 }
@@ -62,24 +61,18 @@ static void ath_bstuck_process(struct ath_softc *sc)
  *  up all required antenna switch parameters, rate codes, and channel flags.
  *  Beacons are always sent out at the lowest rate, and are not retried.
 */
-static void ath_beacon_setup(struct ath_softc *sc,
-			     struct ath_vif *avp, struct ath_buf *bf)
+static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
+			     struct ath_buf *bf)
 {
 	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_desc *ds;
 	struct ath9k_11n_rate_series series[4];
 	struct ath_rate_table *rt;
-	int flags, antenna;
-	u8 rix, rate;
-	int ctsrate = 0;
-	int ctsduration = 0;
-
-	DPRINTF(sc, ATH_DBG_BEACON, "m %p len %u\n", skb, skb->len);
+	int flags, antenna, ctsrate = 0, ctsduration = 0;
+	u8 rate;
 
-	/* setup descriptors */
 	ds = bf->bf_desc;
-
 	flags = ATH9K_TXDESC_NOACK;
 
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC &&
@@ -92,53 +85,39 @@ static void ath_beacon_setup(struct ath_softc *sc,
 		ds->ds_link = 0;
 		/*
 		 * Switch antenna every beacon.
-		 * Should only switch every beacon period, not for every
-		 * SWBA's
-		 * XXX assumes two antenna
+		 * Should only switch every beacon period, not for every SWBA
+		 * XXX assumes two antennae
 		 */
 		antenna = ((sc->beacon.ast_be_xmit / sc->nbcnvifs) & 1 ? 2 : 1);
 	}
 
 	ds->ds_data = bf->bf_buf_addr;
 
-	/*
-	 * Calculate rate code.
-	 * XXX everything at min xmit rate
-	 */
-	rix = 0;
 	rt = sc->cur_rate_table;
-	rate = rt->info[rix].ratecode;
+	rate = rt->info[0].ratecode;
 	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
-		rate |= rt->info[rix].short_preamble;
-
-	ath9k_hw_set11n_txdesc(ah, ds,
-			       skb->len + FCS_LEN,     /* frame length */
-			       ATH9K_PKT_TYPE_BEACON,  /* Atheros packet type */
-			       MAX_RATE_POWER,         /* FIXME */
-			       ATH9K_TXKEYIX_INVALID,  /* no encryption */
-			       ATH9K_KEY_TYPE_CLEAR,   /* no encryption */
-			       flags                   /* no ack,
-							  veol for beacons */
-		);
+		rate |= rt->info[0].short_preamble;
+
+	ath9k_hw_set11n_txdesc(ah, ds, skb->len + FCS_LEN,
+			       ATH9K_PKT_TYPE_BEACON,
+			       MAX_RATE_POWER,
+			       ATH9K_TXKEYIX_INVALID,
+			       ATH9K_KEY_TYPE_CLEAR,
+			       flags);
 
 	/* NB: beacon's BufLen must be a multiple of 4 bytes */
-	ath9k_hw_filltxdesc(ah, ds,
-			    roundup(skb->len, 4), /* buffer length */
-			    true,                 /* first segment */
-			    true,                 /* last segment */
-			    ds                    /* first descriptor */
-		);
+	ath9k_hw_filltxdesc(ah, ds, roundup(skb->len, 4),
+			    true, true, ds);
 
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 	series[0].Tries = 1;
 	series[0].Rate = rate;
 	series[0].ChSel = sc->tx_chainmask;
 	series[0].RateFlags = (ctsrate) ? ATH9K_RATESERIES_RTS_CTS : 0;
-	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0,
-		ctsrate, ctsduration, series, 4, 0);
+	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0, ctsrate, ctsduration,
+				     series, 4, 0);
 }
 
-/* Generate beacon frame and queue cab data for a VIF */
 static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 {
 	struct ath_buf *bf;
@@ -150,8 +129,6 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	int cabq_depth;
 
 	vif = sc->vifs[if_id];
-	ASSERT(vif);
-
 	avp = (void *)vif->drv_priv;
 	cabq = sc->beacon.cabq;
 
@@ -161,15 +138,18 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 		return NULL;
 	}
 
+	/* Release the old beacon first */
+
 	bf = avp->av_bcbuf;
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	if (skb) {
 		dma_unmap_single(sc->dev, bf->bf_dmacontext,
-				 skb->len,
-				 DMA_TO_DEVICE);
+				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 	}
 
+	/* Get a new beacon from mac80211 */
+
 	skb = ieee80211_beacon_get(sc->hw, vif);
 	bf->bf_mpdu = skb;
 	if (skb == NULL)
@@ -189,13 +169,11 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 
 	bf->bf_buf_addr = bf->bf_dmacontext =
 		dma_map_single(sc->dev, skb->data,
-			       skb->len,
-			       DMA_TO_DEVICE);
+			       skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"dma_mapping_error() on beaconing\n");
+		DPRINTF(sc, ATH_DBG_FATAL, "dma_mapping_error on beaconing\n");
 		return NULL;
 	}
 
@@ -214,25 +192,15 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	spin_unlock_bh(&cabq->axq_lock);
 
 	if (skb && cabq_depth) {
-		/*
-		 * Unlock the cabq lock as ath_tx_draintxq acquires
-		 * the lock again which is a common function and that
-		 * acquires txq lock inside.
-		 */
 		if (sc->nvifs > 1) {
-			ath_draintxq(sc, cabq, false);
 			DPRINTF(sc, ATH_DBG_BEACON,
-				"flush previous cabq traffic\n");
+				"Flushing previous cabq traffic\n");
+			ath_draintxq(sc, cabq, false);
 		}
 	}
 
-	/* Construct tx descriptor. */
 	ath_beacon_setup(sc, avp, bf);
 
-	/*
-	 * Enable the CAB queue before the beacon queue to
-	 * insure cab frames are triggered by this beacon.
-	 */
 	while (skb) {
 		ath_tx_cabq(sc, skb);
 		skb = ieee80211_get_buffered_bc(sc->hw, vif);
@@ -254,19 +222,14 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 	struct sk_buff *skb;
 
 	vif = sc->vifs[if_id];
-	ASSERT(vif);
-
 	avp = (void *)vif->drv_priv;
 
-	if (avp->av_bcbuf == NULL) {
-		DPRINTF(sc, ATH_DBG_BEACON, "avp=%p av_bcbuf=%p\n",
-			avp, avp != NULL ? avp->av_bcbuf : NULL);
+	if (avp->av_bcbuf == NULL)
 		return;
-	}
+
 	bf = avp->av_bcbuf;
 	skb = (struct sk_buff *) bf->bf_mpdu;
 
-	/* Construct tx descriptor. */
 	ath_beacon_setup(sc, avp, bf);
 
 	/* NB: caller is known to have already stopped tx dma */
@@ -298,8 +261,6 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	__le64 tstamp;
 
 	vif = sc->vifs[if_id];
-	ASSERT(vif);
-
 	avp = (void *)vif->drv_priv;
 
 	/* Allocate a beacon descriptor if we haven't done so. */
@@ -339,22 +300,17 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 		}
 	}
 
-	/* release the previous beacon frame , if it already exists. */
+	/* release the previous beacon frame, if it already exists. */
 	bf = avp->av_bcbuf;
 	if (bf->bf_mpdu != NULL) {
 		skb = (struct sk_buff *)bf->bf_mpdu;
 		dma_unmap_single(sc->dev, bf->bf_dmacontext,
-				 skb->len,
-				 DMA_TO_DEVICE);
+				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 	}
 
-	/*
-	 * NB: the beacon data buffer must be 32-bit aligned.
-	 * FIXME: Fill avp->av_btxctl.txpower and
-	 * avp->av_btxctl.shortPreamble
-	 */
+	/* NB: the beacon data buffer must be 32-bit aligned. */
 	skb = ieee80211_beacon_get(sc->hw, vif);
 	if (skb == NULL) {
 		DPRINTF(sc, ATH_DBG_BEACON, "cannot get skb\n");
@@ -403,13 +359,12 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	bf->bf_mpdu = skb;
 	bf->bf_buf_addr = bf->bf_dmacontext =
 		dma_map_single(sc->dev, skb->data,
-			       skb->len,
-			       DMA_TO_DEVICE);
+			       skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"dma_mapping_error() on beacon alloc\n");
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"dma_mapping_error on beacon alloc\n");
 		return -ENOMEM;
 	}
 
@@ -430,8 +385,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 		if (bf->bf_mpdu != NULL) {
 			struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
 			dma_unmap_single(sc->dev, bf->bf_dmacontext,
-					 skb->len,
-					 DMA_TO_DEVICE);
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
 		}
@@ -441,18 +395,15 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 	}
 }
 
-void ath9k_beacon_tasklet(unsigned long data)
+void ath_beacon_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf = NULL;
 	int slot, if_id;
-	u32 bfaddr;
+	u32 bfaddr, show_cycles = 0, bc = 0, tsftu;
 	u32 rx_clear = 0, rx_frame = 0, tx_frame = 0;
-	u32 show_cycles = 0;
-	u32 bc = 0; /* beacon count */
 	u64 tsf;
-	u32 tsftu;
 	u16 intval;
 
 	if (sc->sc_flags & SC_OP_NO_RESET) {
@@ -627,7 +578,6 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 
 	if (if_id != ATH_IF_ID_ANY) {
 		vif = sc->vifs[if_id];
-		ASSERT(vif);
 		avp = (void *)vif->drv_priv;
 		opmode = avp->av_opmode;
 	} else {
@@ -757,30 +707,11 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
 
 		DPRINTF(sc, ATH_DBG_BEACON,
-			"tsf %llu "
-			"tsf:tu %u "
-			"intval %u "
-			"nexttbtt %u "
-			"dtim %u "
-			"nextdtim %u "
-			"bmiss %u "
-			"sleep %u "
-			"cfp:period %u "
-			"maxdur %u "
-			"next %u "
-			"timoffset %u\n",
-			(unsigned long long)tsf, tsftu,
-			bs.bs_intval,
-			bs.bs_nexttbtt,
-			bs.bs_dtimperiod,
-			bs.bs_nextdtim,
-			bs.bs_bmissthreshold,
-			bs.bs_sleepduration,
-			bs.bs_cfpperiod,
-			bs.bs_cfpmaxduration,
-			bs.bs_cfpnext,
-			bs.bs_timoffset
-			);
+			"tsf: %llu tsftu: %u\n", tsf, tsftu);
+		DPRINTF(sc, ATH_DBG_BEACON,
+			"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
+			bs.bs_bmissthreshold, bs.bs_sleepduration,
+			bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
 
 		ath9k_hw_set_interrupts(ah, 0);
 		ath9k_hw_set_sta_beacon_timers(ah, &bs);
@@ -789,17 +720,15 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	} else {
 		u64 tsf;
 		u32 tsftu;
+
 		ath9k_hw_set_interrupts(ah, 0);
 		if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) {
-			/*
-			 * Pull nexttbtt forward to reflect the current
-			 * TSF
-			 */
+			/* Pull nexttbtt forward to reflect the current TSF */
 #define FUDGE 2
 			if (!(intval & ATH9K_BEACON_RESET_TSF)) {
 				tsf = ath9k_hw_gettsf64(ah);
 				tsftu = TSF_TO_TU((u32)(tsf>>32),
-					(u32)tsf) + FUDGE;
+						  (u32)tsf) + FUDGE;
 				do {
 					nexttbtt += intval;
 				} while (nexttbtt < tsftu);
@@ -807,8 +736,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 #undef FUDGE
 			DPRINTF(sc, ATH_DBG_BEACON,
 				"IBSS nexttbtt %u intval %u (%u)\n",
-				nexttbtt,
-				intval & ~ATH9K_BEACON_RESET_TSF,
+				nexttbtt, intval & ~ATH9K_BEACON_RESET_TSF,
 				conf.beacon_interval);
 
 			/*
@@ -825,18 +753,19 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		} else if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
 			if (nexttbtt == intval)
 				intval |= ATH9K_BEACON_RESET_TSF;
-
 			/*
 			 * In AP mode we enable the beacon timers and
 			 * SWBA interrupts to prepare beacon frames.
 			 */
 			intval |= ATH9K_BEACON_ENA;
-			sc->imask |= ATH9K_INT_SWBA;   /* beacon prepare */
+			sc->imask |= ATH9K_INT_SWBA;
 			ath_beaconq_config(sc);
 		}
+
 		ath9k_hw_beaconinit(ah, nexttbtt, intval);
 		sc->beacon.bmisscnt = 0;
 		ath9k_hw_set_interrupts(ah, sc->imask);
+
 		/*
 		 * When using a self-linked beacon descriptor in
 		 * ibss mode load it once here.
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 5f409b1..52d4f67 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1372,7 +1372,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	spin_lock_init(&sc->sc_resetlock);
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
-	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
+	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
 		     (unsigned long)sc);
 
 	/*
-- 
1.6.1

