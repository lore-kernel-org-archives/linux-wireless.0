Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23298 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbYLGQRP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:17:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 08:17:15 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18747.63051.962956.421870@gargle.gargle.HOWL> (sfid-20081207_171721_039245_78652B98)
Date: Sun, 7 Dec 2008 21:44:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 6/6] ath9k: Refactor struct ath_softc
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split ath_softc into smaller structures for rx, tx and beacon
handling.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |   94 ++++++++++++------------
 drivers/net/wireless/ath9k/core.h   |  134 ++++++++++++++++-------------------
 drivers/net/wireless/ath9k/main.c   |   60 ++++++++--------
 drivers/net/wireless/ath9k/recv.c   |   98 +++++++++++++-------------
 drivers/net/wireless/ath9k/xmit.c   |  126 ++++++++++++++++----------------
 5 files changed, 250 insertions(+), 262 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 9e5c0c0..3ab0b43 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -26,7 +26,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath9k_tx_queue_info qi;
 
-	ath9k_hw_get_txq_props(ah, sc->sc_bhalq, &qi);
+	ath9k_hw_get_txq_props(ah, sc->beacon.beaconq, &qi);
 	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
 		/* Always burst out beacon and CAB traffic. */
 		qi.tqi_aifs = 1;
@@ -34,17 +34,17 @@ static int ath_beaconq_config(struct ath_softc *sc)
 		qi.tqi_cwmax = 0;
 	} else {
 		/* Adhoc mode; important thing is to use 2x cwmin. */
-		qi.tqi_aifs = sc->sc_beacon_qi.tqi_aifs;
-		qi.tqi_cwmin = 2*sc->sc_beacon_qi.tqi_cwmin;
-		qi.tqi_cwmax = sc->sc_beacon_qi.tqi_cwmax;
+		qi.tqi_aifs = sc->beacon.beacon_qi.tqi_aifs;
+		qi.tqi_cwmin = 2*sc->beacon.beacon_qi.tqi_cwmin;
+		qi.tqi_cwmax = sc->beacon.beacon_qi.tqi_cwmax;
 	}
 
-	if (!ath9k_hw_set_txq_props(ah, sc->sc_bhalq, &qi)) {
+	if (!ath9k_hw_set_txq_props(ah, sc->beacon.beaconq, &qi)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"unable to update h/w beacon queue parameters\n");
 		return 0;
 	} else {
-		ath9k_hw_resettxqueue(ah, sc->sc_bhalq); /* push to h/w */
+		ath9k_hw_resettxqueue(ah, sc->beacon.beaconq); /* push to h/w */
 		return 1;
 	}
 }
@@ -53,7 +53,7 @@ static void ath_bstuck_process(struct ath_softc *sc)
 {
 	DPRINTF(sc, ATH_DBG_BEACON,
 		"stuck beacon; resetting (bmiss count %u)\n",
-		sc->sc_bmisscount);
+		sc->beacon.bmisscnt);
 	ath_reset(sc, false);
 }
 
@@ -96,7 +96,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 		 * SWBA's
 		 * XXX assumes two antenna
 		 */
-		antenna = ((sc->ast_be_xmit / sc->sc_nbcnvaps) & 1 ? 2 : 1);
+		antenna = ((sc->beacon.ast_be_xmit / sc->sc_nbcnvaps) & 1 ? 2 : 1);
 	}
 
 	ds->ds_data = bf->bf_buf_addr;
@@ -153,7 +153,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	ASSERT(vif);
 
 	avp = (void *)vif->drv_priv;
-	cabq = sc->sc_cabq;
+	cabq = sc->beacon.cabq;
 
 	if (avp->av_bcbuf == NULL) {
 		DPRINTF(sc, ATH_DBG_BEACON, "avp=%p av_bcbuf=%p\n",
@@ -182,9 +182,9 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 		 * TX frames)
 		 */
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-		sc->seq_no += 0x10;
+		sc->tx.seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(sc->seq_no);
+		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
 	}
 
 	bf->bf_buf_addr = bf->bf_dmacontext =
@@ -270,10 +270,10 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 	ath_beacon_setup(sc, avp, bf);
 
 	/* NB: caller is known to have already stopped tx dma */
-	ath9k_hw_puttxbuf(ah, sc->sc_bhalq, bf->bf_daddr);
-	ath9k_hw_txstart(ah, sc->sc_bhalq);
+	ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bf->bf_daddr);
+	ath9k_hw_txstart(ah, sc->beacon.beaconq);
 	DPRINTF(sc, ATH_DBG_BEACON, "TXDP%u = %llx (%p)\n",
-		sc->sc_bhalq, ito64(bf->bf_daddr), bf->bf_desc);
+		sc->beacon.beaconq, ito64(bf->bf_daddr), bf->bf_desc);
 }
 
 int ath_beaconq_setup(struct ath_hal *ah)
@@ -306,7 +306,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	if (!avp->av_bcbuf) {
 		/* Allocate beacon state for hostap/ibss.  We know
 		 * a buffer is available. */
-		avp->av_bcbuf = list_first_entry(&sc->sc_bbuf,
+		avp->av_bcbuf = list_first_entry(&sc->beacon.bbuf,
 						 struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
 
@@ -319,13 +319,13 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 			 */
 			avp->av_bslot = 0;
 			for (slot = 0; slot < ATH_BCBUF; slot++)
-				if (sc->sc_bslot[slot] == ATH_IF_ID_ANY) {
+				if (sc->beacon.bslot[slot] == ATH_IF_ID_ANY) {
 					/*
 					 * XXX hack, space out slots to better
 					 * deal with misses
 					 */
 					if (slot+1 < ATH_BCBUF &&
-					    sc->sc_bslot[slot+1] ==
+					    sc->beacon.bslot[slot+1] ==
 						ATH_IF_ID_ANY) {
 						avp->av_bslot = slot+1;
 						break;
@@ -333,8 +333,8 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 					avp->av_bslot = slot;
 					/* NB: keep looking for a double slot */
 				}
-			BUG_ON(sc->sc_bslot[avp->av_bslot] != ATH_IF_ID_ANY);
-			sc->sc_bslot[avp->av_bslot] = if_id;
+			BUG_ON(sc->beacon.bslot[avp->av_bslot] != ATH_IF_ID_ANY);
+			sc->beacon.bslot[avp->av_bslot] = if_id;
 			sc->sc_nbcnvaps++;
 		}
 	}
@@ -362,7 +362,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	}
 
 	tstamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-	sc->bc_tstamp = le64_to_cpu(tstamp);
+	sc->beacon.bc_tstamp = le64_to_cpu(tstamp);
 
 	/*
 	 * Calculate a TSF adjustment factor required for
@@ -422,7 +422,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 		struct ath_buf *bf;
 
 		if (avp->av_bslot != -1) {
-			sc->sc_bslot[avp->av_bslot] = ATH_IF_ID_ANY;
+			sc->beacon.bslot[avp->av_bslot] = ATH_IF_ID_ANY;
 			sc->sc_nbcnvaps--;
 		}
 
@@ -435,7 +435,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
 		}
-		list_add_tail(&bf->list, &sc->sc_bbuf);
+		list_add_tail(&bf->list, &sc->beacon.bbuf);
 
 		avp->av_bcbuf = NULL;
 	}
@@ -469,18 +469,18 @@ void ath9k_beacon_tasklet(unsigned long data)
 	 *
 	 * FIXME: Clean up this mess !!
 	 */
-	if (ath9k_hw_numtxpending(ah, sc->sc_bhalq) != 0) {
-		sc->sc_bmisscount++;
+	if (ath9k_hw_numtxpending(ah, sc->beacon.beaconq) != 0) {
+		sc->beacon.bmisscnt++;
 		/* XXX: doth needs the chanchange IE countdown decremented.
 		 *      We should consider adding a mac80211 call to indicate
 		 *      a beacon miss so appropriate action could be taken
 		 *      (in that layer).
 		 */
-		if (sc->sc_bmisscount < BSTUCK_THRESH) {
+		if (sc->beacon.bmisscnt < BSTUCK_THRESH) {
 			if (sc->sc_flags & SC_OP_NO_RESET) {
 				DPRINTF(sc, ATH_DBG_BEACON,
 					"missed %u consecutive beacons\n",
-					sc->sc_bmisscount);
+					sc->beacon.bmisscnt);
 				if (show_cycles) {
 					/*
 					 * Display cycle counter stats from HW
@@ -499,11 +499,11 @@ void ath9k_beacon_tasklet(unsigned long data)
 			} else {
 				DPRINTF(sc, ATH_DBG_BEACON,
 					"missed %u consecutive beacons\n",
-					sc->sc_bmisscount);
+					sc->beacon.bmisscnt);
 			}
-		} else if (sc->sc_bmisscount >= BSTUCK_THRESH) {
+		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
 			if (sc->sc_flags & SC_OP_NO_RESET) {
-				if (sc->sc_bmisscount == BSTUCK_THRESH) {
+				if (sc->beacon.bmisscnt == BSTUCK_THRESH) {
 					DPRINTF(sc, ATH_DBG_BEACON,
 						"beacon is officially "
 						"stuck\n");
@@ -517,17 +517,17 @@ void ath9k_beacon_tasklet(unsigned long data)
 		return;
 	}
 
-	if (sc->sc_bmisscount != 0) {
+	if (sc->beacon.bmisscnt != 0) {
 		if (sc->sc_flags & SC_OP_NO_RESET) {
 			DPRINTF(sc, ATH_DBG_BEACON,
 				"resume beacon xmit after %u misses\n",
-				sc->sc_bmisscount);
+				sc->beacon.bmisscnt);
 		} else {
 			DPRINTF(sc, ATH_DBG_BEACON,
 				"resume beacon xmit after %u misses\n",
-				sc->sc_bmisscount);
+				sc->beacon.bmisscnt);
 		}
-		sc->sc_bmisscount = 0;
+		sc->beacon.bmisscnt = 0;
 	}
 
 	/*
@@ -542,7 +542,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 	tsf = ath9k_hw_gettsf64(ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf);
 	slot = ((tsftu % intval) * ATH_BCBUF) / intval;
-	if_id = sc->sc_bslot[(slot + 1) % ATH_BCBUF];
+	if_id = sc->beacon.bslot[(slot + 1) % ATH_BCBUF];
 
 	DPRINTF(sc, ATH_DBG_BEACON,
 		"slot %d [tsf %llu tsftu %u intval %u] if_id %d\n",
@@ -574,12 +574,12 @@ void ath9k_beacon_tasklet(unsigned long data)
 	 *     set to ATH_BCBUF so this check is a noop.
 	 */
 	/* XXX locking */
-	if (sc->sc_updateslot == UPDATE) {
-		sc->sc_updateslot = COMMIT; /* commit next beacon */
-		sc->sc_slotupdate = slot;
-	} else if (sc->sc_updateslot == COMMIT && sc->sc_slotupdate == slot) {
-		ath9k_hw_setslottime(sc->sc_ah, sc->sc_slottime);
-		sc->sc_updateslot = OK;
+	if (sc->beacon.updateslot == UPDATE) {
+		sc->beacon.updateslot = COMMIT; /* commit next beacon */
+		sc->beacon.slotupdate = slot;
+	} else if (sc->beacon.updateslot == COMMIT && sc->beacon.slotupdate == slot) {
+		ath9k_hw_setslottime(sc->sc_ah, sc->beacon.slottime);
+		sc->beacon.updateslot = OK;
 	}
 	if (bfaddr != 0) {
 		/*
@@ -587,17 +587,17 @@ void ath9k_beacon_tasklet(unsigned long data)
 		 * This should never fail since we check above that no frames
 		 * are still pending on the queue.
 		 */
-		if (!ath9k_hw_stoptxdma(ah, sc->sc_bhalq)) {
+		if (!ath9k_hw_stoptxdma(ah, sc->beacon.beaconq)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"beacon queue %u did not stop?\n", sc->sc_bhalq);
+				"beacon queue %u did not stop?\n", sc->beacon.beaconq);
 			/* NB: the HAL still stops DMA, so proceed */
 		}
 
 		/* NB: cabq traffic should already be queued and primed */
-		ath9k_hw_puttxbuf(ah, sc->sc_bhalq, bfaddr);
-		ath9k_hw_txstart(ah, sc->sc_bhalq);
+		ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bfaddr);
+		ath9k_hw_txstart(ah, sc->beacon.beaconq);
 
-		sc->ast_be_xmit += bc;     /* XXX per-vap? */
+		sc->beacon.ast_be_xmit += bc;     /* XXX per-vap? */
 	}
 }
 
@@ -644,7 +644,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	conf.bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf.beacon_interval;
 
 	/* extract tstamp from last beacon and convert to TU */
-	nexttbtt = TSF_TO_TU(sc->bc_tstamp >> 32, sc->bc_tstamp);
+	nexttbtt = TSF_TO_TU(sc->beacon.bc_tstamp >> 32, sc->beacon.bc_tstamp);
 
 	/* XXX conditionalize multi-bss support? */
 	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
@@ -831,7 +831,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			ath_beaconq_config(sc);
 		}
 		ath9k_hw_beaconinit(ah, nexttbtt, intval);
-		sc->sc_bmisscount = 0;
+		sc->beacon.bmisscnt = 0;
 		ath9k_hw_set_interrupts(ah, sc->sc_imask);
 		/*
 		 * When using a self-linked beacon descriptor in
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 41a87b9..e38f033 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -61,7 +61,7 @@ struct ath_node;
 #define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
-#define	ATH_TXQ_SETUP(sc, i)        ((sc)->sc_txqsetup & (1<<i))
+#define	ATH_TXQ_SETUP(sc, i)        ((sc)->tx.txqsetup & (1<<i))
 
 static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
@@ -453,6 +453,28 @@ struct ath_node {
 	u8 mpdudensity;
 };
 
+struct ath_tx {
+	u16 seq_no;
+	u32 txqsetup;
+	int hwq_map[ATH9K_WME_AC_VO+1];
+	spinlock_t txbuflock;
+	struct list_head txbuf;
+	struct ath_txq txq[ATH9K_NUM_TX_QUEUES];
+	struct ath_descdma txdma;
+};
+
+struct ath_rx {
+	u8 defant;
+	u8 rxotherant;
+	u32 *rxlink;
+	int bufsize;
+	unsigned int rxfilter;
+	spinlock_t rxflushlock;
+	spinlock_t rxbuflock;
+	struct list_head rxbuf;
+	struct ath_descdma rxdma;
+};
+
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
 void ath_flushrecv(struct ath_softc *sc);
@@ -540,6 +562,26 @@ struct ath_beacon_config {
 	} u; /* last received beacon/probe response timestamp of this BSS. */
 };
 
+struct ath_beacon {
+	enum {
+		OK,		/* no change needed */
+		UPDATE,		/* update pending */
+		COMMIT		/* beacon sent, commit change */
+	} updateslot;		/* slot time update fsm */
+
+	u32 beaconq;
+	u32 bmisscnt;
+	u32 ast_be_xmit;
+	u64 bc_tstamp;
+	int bslot[ATH_BCBUF];
+	int slottime;
+	int slotupdate;
+	struct ath9k_tx_queue_info beacon_qi;
+	struct ath_descdma bdma;
+	struct ath_txq *cabq;
+	struct list_head bbuf;
+};
+
 void ath9k_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, int if_id);
 int ath_beaconq_setup(struct ath_hal *ah);
@@ -610,7 +652,7 @@ struct ath_rfkill {
 #define DEFAULT_CACHELINE       32
 #define	ATH_DEFAULT_NOISE_FLOOR -95
 #define ATH_REGCLASSIDS_MAX     10
-#define ATH_CABQ_READY_TIME     80  /* % of beacon interval */
+#define ATH_CABQ_READY_TIME     80      /* % of beacon interval */
 #define ATH_MAX_SW_RETRIES      10
 #define ATH_CHAN_MAX            255
 #define IEEE80211_WEP_NKID      4       /* number of key ids */
@@ -623,7 +665,7 @@ struct ath_rfkill {
  * Different parts have different size key caches.  We handle
  * up to ATH_KEYMAX entries (could dynamically allocate state).
  */
-#define	ATH_KEYMAX	        128        /* max key cache size we handle */
+#define	ATH_KEYMAX	        128     /* max key cache size we handle */
 
 #define ATH_IF_ID_ANY   	0xff
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
@@ -656,105 +698,51 @@ struct ath_softc {
 	struct pci_dev *pdev;
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
-	struct ath_config sc_config;
 	struct ath_hal *sc_ah;
 	void __iomem *mem;
+	spinlock_t sc_resetlock;
 
 	u8 sc_curbssid[ETH_ALEN];
 	u8 sc_myaddr[ETH_ALEN];
 	u8 sc_bssidmask[ETH_ALEN];
-
-#ifdef CONFIG_ATH9K_DEBUG
-	struct ath9k_debug sc_debug;
-#endif
 	u32 sc_intrstatus;
 	u32 sc_flags; /* SC_OP_* */
-	unsigned int rx_filter;
 	u16 sc_curtxpow;
 	u16 sc_curaid;
 	u16 sc_cachelsz;
-	int sc_slotupdate;		/* slot to next advance fsm */
-	int sc_slottime;
-	int sc_bslot[ATH_BCBUF];
+	u8 sc_nbcnvaps;
+	u16 sc_nvaps;
 	u8 sc_tx_chainmask;
 	u8 sc_rx_chainmask;
+	u32 sc_keymax;
+	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);
+	u8 sc_splitmic;
+	u8 sc_protrix;
 	enum ath9k_int sc_imask;
 	enum PROT_MODE sc_protmode;
-
-	u8 sc_nbcnvaps;
-	u16 sc_nvaps;
-	struct ieee80211_vif *sc_vaps[ATH_BCBUF];
-
-	u8 sc_mcastantenna;
-	u8 sc_defant;
-	u8 sc_rxotherant;
-
-	struct ath9k_node_stats sc_halstats;
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
 	enum ath9k_ht_macmode tx_chan_width;
 
-	enum {
-		OK,		/* no change needed */
-		UPDATE,		/* update pending */
-		COMMIT		/* beacon sent, commit change */
-	} sc_updateslot;	/* slot time update fsm */
-
-	/* Crypto */
-	u32 sc_keymax;
-	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);
-	u8 sc_splitmic;		/* split TKIP MIC keys */
-
-	/* RX */
-	struct list_head sc_rxbuf;
-	struct ath_descdma sc_rxdma;
-	int sc_rxbufsize;
-	u32 *sc_rxlink;
-
-	/* TX */
-	struct list_head sc_txbuf;
-	struct ath_txq sc_txq[ATH9K_NUM_TX_QUEUES];
-	struct ath_descdma sc_txdma;
-	u32 sc_txqsetup;
-	int sc_haltype2q[ATH9K_WME_AC_VO+1];
-	u16 seq_no; /* TX sequence number */
-
-	/* Beacon */
-	struct ath9k_tx_queue_info sc_beacon_qi;
-	struct ath_descdma sc_bdma;
-	struct ath_txq *sc_cabq;
-	struct list_head sc_bbuf;
-	u32 sc_bhalq;
-	u32 sc_bmisscount;
-	u32 ast_be_xmit;
-	u64 bc_tstamp;
-
-	/* Rate */
+	struct ath_config sc_config;
+	struct ath_rx rx;
+	struct ath_tx tx;
+	struct ath_beacon beacon;
+	struct ieee80211_vif *sc_vaps[ATH_BCBUF];
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
 	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
 	struct ath_rate_table *cur_rate_table;
-	u8 sc_protrix;
-
-	/* Channel, Band */
 	struct ieee80211_channel channels[IEEE80211_NUM_BANDS][ATH_CHAN_MAX];
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
-
-	/* Locks */
-	spinlock_t sc_rxflushlock;
-	spinlock_t sc_rxbuflock;
-	spinlock_t sc_txbuflock;
-	spinlock_t sc_resetlock;
-
-	/* LEDs */
 	struct ath_led radio_led;
 	struct ath_led assoc_led;
 	struct ath_led tx_led;
 	struct ath_led rx_led;
-
-	/* Rfkill */
 	struct ath_rfkill rf_kill;
-
-	/* ANI */
 	struct ath_ani sc_ani;
+	struct ath9k_node_stats sc_halstats;
+#ifdef CONFIG_ATH9K_DEBUG
+	struct ath9k_debug sc_debug;
+#endif
 };
 
 int ath_reset(struct ath_softc *sc, bool retry_tx);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index f1877da..9939749 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -347,7 +347,7 @@ static void ath_ani_calibrate(unsigned long data)
 	* don't calibrate when we're scanning.
 	* we are most likely not on our home channel.
 	*/
-	if (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)
+	if (sc->rx.rxfilter & FIF_BCN_PRBRESP_PROMISC)
 		return;
 
 	/* Long calibration runs independently of short calibration. */
@@ -486,9 +486,9 @@ static void ath9k_tasklet(unsigned long data)
 
 		if (status &
 		    (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN)) {
-			spin_lock_bh(&sc->sc_rxflushlock);
+			spin_lock_bh(&sc->rx.rxflushlock);
 			ath_rx_tasklet(sc, 0);
-			spin_unlock_bh(&sc->sc_rxflushlock);
+			spin_unlock_bh(&sc->rx.rxflushlock);
 		}
 		/* XXX: optimize this */
 		if (status & ATH9K_INT_TX)
@@ -1306,7 +1306,7 @@ static void ath_detach(struct ath_softc *sc)
 	/* cleanup tx queues */
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
-			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
+			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
 	ath9k_hw_detach(sc->sc_ah);
 	ath9k_exit_debug(sc);
@@ -1397,15 +1397,15 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	 * priority.  Note that the hal handles reseting
 	 * these queues at the needed time.
 	 */
-	sc->sc_bhalq = ath_beaconq_setup(ah);
-	if (sc->sc_bhalq == -1) {
+	sc->beacon.beaconq = ath_beaconq_setup(ah);
+	if (sc->beacon.beaconq == -1) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to setup a beacon xmit queue\n");
 		error = -EIO;
 		goto bad2;
 	}
-	sc->sc_cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
-	if (sc->sc_cabq == NULL) {
+	sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
+	if (sc->beacon.cabq == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to setup CAB xmit queue\n");
 		error = -EIO;
@@ -1415,8 +1415,8 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_config.cabqReadytime = ATH_CABQ_READY_TIME;
 	ath_cabq_update(sc);
 
-	for (i = 0; i < ARRAY_SIZE(sc->sc_haltype2q); i++)
-		sc->sc_haltype2q[i] = -1;
+	for (i = 0; i < ARRAY_SIZE(sc->tx.hwq_map); i++)
+		sc->tx.hwq_map[i] = -1;
 
 	/* Setup data queues */
 	/* NB: ensure BK queue is the lowest priority h/w queue */
@@ -1496,7 +1496,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_rx_chainmask = ah->ah_caps.rx_chainmask;
 
 	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
-	sc->sc_defant = ath9k_hw_getdefantenna(ah);
+	sc->rx.defant = ath9k_hw_getdefantenna(ah);
 
 	ath9k_hw_getmac(ah, sc->sc_myaddr);
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) {
@@ -1505,11 +1505,11 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
 	}
 
-	sc->sc_slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
+	sc->beacon.slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
 
 	/* initialize beacon slots */
-	for (i = 0; i < ARRAY_SIZE(sc->sc_bslot); i++)
-		sc->sc_bslot[i] = ATH_IF_ID_ANY;
+	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++)
+		sc->beacon.bslot[i] = ATH_IF_ID_ANY;
 
 	/* save MISC configurations */
 	sc->sc_config.swBeaconProcess = 1;
@@ -1535,7 +1535,7 @@ bad2:
 	/* cleanup tx queues */
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
-			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
+			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 bad:
 	if (ah)
 		ath9k_hw_detach(ah);
@@ -1673,9 +1673,9 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		int i;
 		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 			if (ATH_TXQ_SETUP(sc, i)) {
-				spin_lock_bh(&sc->sc_txq[i].axq_lock);
-				ath_txq_schedule(sc, &sc->sc_txq[i]);
-				spin_unlock_bh(&sc->sc_txq[i].axq_lock);
+				spin_lock_bh(&sc->tx.txq[i].axq_lock);
+				ath_txq_schedule(sc, &sc->tx.txq[i]);
+				spin_unlock_bh(&sc->tx.txq[i].axq_lock);
 			}
 		}
 	}
@@ -1810,19 +1810,19 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc *sc)
 
 	switch (queue) {
 	case 0:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_VO];
+		qnum = sc->tx.hwq_map[ATH9K_WME_AC_VO];
 		break;
 	case 1:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_VI];
+		qnum = sc->tx.hwq_map[ATH9K_WME_AC_VI];
 		break;
 	case 2:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BE];
+		qnum = sc->tx.hwq_map[ATH9K_WME_AC_BE];
 		break;
 	case 3:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BK];
+		qnum = sc->tx.hwq_map[ATH9K_WME_AC_BK];
 		break;
 	default:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BE];
+		qnum = sc->tx.hwq_map[ATH9K_WME_AC_BE];
 		break;
 	}
 
@@ -1993,9 +1993,9 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			sc->seq_no += 0x10;
+			sc->tx.seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(sc->seq_no);
+		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
 	}
 
 	/* Add the padding after the header if this is not already done */
@@ -2049,7 +2049,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(sc->sc_ah);
 	} else
-		sc->sc_rxlink = NULL;
+		sc->rx.rxlink = NULL;
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
@@ -2131,7 +2131,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	/* Reclaim beacon resources */
 	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP ||
 	    sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC) {
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
+		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		ath_beacon_return(sc, avp);
 	}
 
@@ -2252,7 +2252,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 		 * causes reconfiguration; we may be called
 		 * with beacon transmission active.
 		 */
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
+		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 
 		error = ath_beacon_alloc(sc, 0);
 		if (error != 0)
@@ -2298,7 +2298,7 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
-	sc->rx_filter = *total_flags;
+	sc->rx.rxfilter = *total_flags;
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
 
@@ -2307,7 +2307,7 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 			ath9k_hw_write_associd(sc->sc_ah, ath_bcast_mac, 0);
 	}
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx_filter);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx.rxfilter);
 }
 
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 8aa8614..cb449f0 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -41,19 +41,19 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	ASSERT(skb != NULL);
 	ds->ds_vdata = skb->data;
 
-	/* setup rx descriptors. The sc_rxbufsize here tells the harware
+	/* setup rx descriptors. The rx.bufsize here tells the harware
 	 * how much data it can DMA to us and that we are prepared
 	 * to process */
 	ath9k_hw_setuprxdesc(ah, ds,
-			     sc->sc_rxbufsize,
+			     sc->rx.bufsize,
 			     0);
 
-	if (sc->sc_rxlink == NULL)
+	if (sc->rx.rxlink == NULL)
 		ath9k_hw_putrxbuf(ah, bf->bf_daddr);
 	else
-		*sc->sc_rxlink = bf->bf_daddr;
+		*sc->rx.rxlink = bf->bf_daddr;
 
-	sc->sc_rxlink = &ds->ds_link;
+	sc->rx.rxlink = &ds->ds_link;
 	ath9k_hw_rxena(ah);
 }
 
@@ -61,8 +61,8 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
 {
 	/* XXX block beacon interrupts */
 	ath9k_hw_setantenna(sc->sc_ah, antenna);
-	sc->sc_defant = antenna;
-	sc->sc_rxotherant = 0;
+	sc->rx.defant = antenna;
+	sc->rx.rxotherant = 0;
 }
 
 /*
@@ -271,20 +271,20 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	int error = 0;
 
 	do {
-		spin_lock_init(&sc->sc_rxflushlock);
+		spin_lock_init(&sc->rx.rxflushlock);
 		sc->sc_flags &= ~SC_OP_RXFLUSH;
-		spin_lock_init(&sc->sc_rxbuflock);
+		spin_lock_init(&sc->rx.rxbuflock);
 
-		sc->sc_rxbufsize = roundup(IEEE80211_MAX_MPDU_LEN,
+		sc->rx.bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
 					   min(sc->sc_cachelsz,
 					       (u16)64));
 
 		DPRINTF(sc, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
-			sc->sc_cachelsz, sc->sc_rxbufsize);
+			sc->sc_cachelsz, sc->rx.bufsize);
 
 		/* Initialize rx descriptors */
 
-		error = ath_descdma_setup(sc, &sc->sc_rxdma, &sc->sc_rxbuf,
+		error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
 					  "rx", nbufs, 1);
 		if (error != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
@@ -292,8 +292,8 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 			break;
 		}
 
-		list_for_each_entry(bf, &sc->sc_rxbuf, list) {
-			skb = ath_rxbuf_alloc(sc, sc->sc_rxbufsize);
+		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
+			skb = ath_rxbuf_alloc(sc, sc->rx.bufsize);
 			if (skb == NULL) {
 				error = -ENOMEM;
 				break;
@@ -301,7 +301,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 
 			bf->bf_mpdu = skb;
 			bf->bf_buf_addr = pci_map_single(sc->pdev, skb->data,
-							 sc->sc_rxbufsize,
+							 sc->rx.bufsize,
 							 PCI_DMA_FROMDEVICE);
 			if (unlikely(pci_dma_mapping_error(sc->pdev,
 				  bf->bf_buf_addr))) {
@@ -314,7 +314,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 			}
 			bf->bf_dmacontext = bf->bf_buf_addr;
 		}
-		sc->sc_rxlink = NULL;
+		sc->rx.rxlink = NULL;
 
 	} while (0);
 
@@ -329,14 +329,14 @@ void ath_rx_cleanup(struct ath_softc *sc)
 	struct sk_buff *skb;
 	struct ath_buf *bf;
 
-	list_for_each_entry(bf, &sc->sc_rxbuf, list) {
+	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
 		skb = bf->bf_mpdu;
 		if (skb)
 			dev_kfree_skb(skb);
 	}
 
-	if (sc->sc_rxdma.dd_desc_len != 0)
-		ath_descdma_cleanup(sc, &sc->sc_rxdma, &sc->sc_rxbuf);
+	if (sc->rx.rxdma.dd_desc_len != 0)
+		ath_descdma_cleanup(sc, &sc->rx.rxdma, &sc->rx.rxbuf);
 }
 
 /*
@@ -374,7 +374,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 
 	/* Can't set HOSTAP into promiscous mode */
 	if (((sc->sc_ah->ah_opmode != NL80211_IFTYPE_AP) &&
-	     (sc->rx_filter & FIF_PROMISC_IN_BSS)) ||
+	     (sc->rx.rxfilter & FIF_PROMISC_IN_BSS)) ||
 	    (sc->sc_ah->ah_opmode == NL80211_IFTYPE_MONITOR)) {
 		rfilt |= ATH9K_RX_FILTER_PROM;
 		/* ??? To prevent from sending ACK */
@@ -400,25 +400,25 @@ int ath_startrecv(struct ath_softc *sc)
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_buf *bf, *tbf;
 
-	spin_lock_bh(&sc->sc_rxbuflock);
-	if (list_empty(&sc->sc_rxbuf))
+	spin_lock_bh(&sc->rx.rxbuflock);
+	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
-	sc->sc_rxlink = NULL;
-	list_for_each_entry_safe(bf, tbf, &sc->sc_rxbuf, list) {
+	sc->rx.rxlink = NULL;
+	list_for_each_entry_safe(bf, tbf, &sc->rx.rxbuf, list) {
 		ath_rx_buf_link(sc, bf);
 	}
 
 	/* We could have deleted elements so the list may be empty now */
-	if (list_empty(&sc->sc_rxbuf))
+	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
-	bf = list_first_entry(&sc->sc_rxbuf, struct ath_buf, list);
+	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
 	ath9k_hw_putrxbuf(ah, bf->bf_daddr);
 	ath9k_hw_rxena(ah);
 
 start_recv:
-	spin_unlock_bh(&sc->sc_rxbuflock);
+	spin_unlock_bh(&sc->rx.rxbuflock);
 	ath_opmode_init(sc);
 	ath9k_hw_startpcureceive(ah);
 
@@ -434,25 +434,25 @@ bool ath_stoprecv(struct ath_softc *sc)
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah);
 	mdelay(3); /* 3ms is long enough for 1 frame */
-	sc->sc_rxlink = NULL;
+	sc->rx.rxlink = NULL;
 
 	return stopped;
 }
 
 void ath_flushrecv(struct ath_softc *sc)
 {
-	spin_lock_bh(&sc->sc_rxflushlock);
+	spin_lock_bh(&sc->rx.rxflushlock);
 	sc->sc_flags |= SC_OP_RXFLUSH;
 	ath_rx_tasklet(sc, 1);
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
-	spin_unlock_bh(&sc->sc_rxflushlock);
+	spin_unlock_bh(&sc->rx.rxflushlock);
 }
 
 int ath_rx_tasklet(struct ath_softc *sc, int flush)
 {
 #define PA2DESC(_sc, _pa)                                               \
-	((struct ath_desc *)((caddr_t)(_sc)->sc_rxdma.dd_desc +		\
-			     ((_pa) - (_sc)->sc_rxdma.dd_desc_paddr)))
+	((struct ath_desc *)((caddr_t)(_sc)->rx.rxdma.dd_desc +		\
+			     ((_pa) - (_sc)->rx.rxdma.dd_desc_paddr)))
 
 	struct ath_buf *bf;
 	struct ath_desc *ds;
@@ -464,19 +464,19 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	bool decrypt_error = false;
 	u8 keyix;
 
-	spin_lock_bh(&sc->sc_rxbuflock);
+	spin_lock_bh(&sc->rx.rxbuflock);
 
 	do {
 		/* If handling rx interrupt and flush is in progress => exit */
 		if ((sc->sc_flags & SC_OP_RXFLUSH) && (flush == 0))
 			break;
 
-		if (list_empty(&sc->sc_rxbuf)) {
-			sc->sc_rxlink = NULL;
+		if (list_empty(&sc->rx.rxbuf)) {
+			sc->rx.rxlink = NULL;
 			break;
 		}
 
-		bf = list_first_entry(&sc->sc_rxbuf, struct ath_buf, list);
+		bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
 		ds = bf->bf_desc;
 
 		/*
@@ -498,8 +498,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			struct ath_buf *tbf;
 			struct ath_desc *tds;
 
-			if (list_is_last(&bf->list, &sc->sc_rxbuf)) {
-				sc->sc_rxlink = NULL;
+			if (list_is_last(&bf->list, &sc->rx.rxbuf)) {
+				sc->rx.rxlink = NULL;
 				break;
 			}
 
@@ -539,7 +539,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			goto requeue;
 
 		/* The status portion of the descriptor could get corrupted. */
-		if (sc->sc_rxbufsize < ds->ds_rxstat.rs_datalen)
+		if (sc->rx.bufsize < ds->ds_rxstat.rs_datalen)
 			goto requeue;
 
 		if (!ath_rx_prepare(skb, ds, &rx_status, &decrypt_error, sc))
@@ -547,21 +547,21 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
-		requeue_skb = ath_rxbuf_alloc(sc, sc->sc_rxbufsize);
+		requeue_skb = ath_rxbuf_alloc(sc, sc->rx.bufsize);
 
 		/* If there is no memory we ignore the current RX'd frame,
 		 * tell hardware it can give us a new frame using the old
-		 * skb and put it at the tail of the sc->sc_rxbuf list for
+		 * skb and put it at the tail of the sc->rx.rxbuf list for
 		 * processing. */
 		if (!requeue_skb)
 			goto requeue;
 
 		/* Sync and unmap the frame */
 		pci_dma_sync_single_for_cpu(sc->pdev, bf->bf_buf_addr,
-					    sc->sc_rxbufsize,
+					    sc->rx.bufsize,
 					    PCI_DMA_FROMDEVICE);
 		pci_unmap_single(sc->pdev, bf->bf_buf_addr,
-				 sc->sc_rxbufsize,
+				 sc->rx.bufsize,
 				 PCI_DMA_FROMDEVICE);
 
 		skb_put(skb, ds->ds_rxstat.rs_datalen);
@@ -595,7 +595,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
 		bf->bf_buf_addr = pci_map_single(sc->pdev, requeue_skb->data,
-					 sc->sc_rxbufsize,
+					 sc->rx.bufsize,
 					 PCI_DMA_FROMDEVICE);
 		if (unlikely(pci_dma_mapping_error(sc->pdev,
 			  bf->bf_buf_addr))) {
@@ -611,18 +611,18 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		 * change the default rx antenna if rx diversity chooses the
 		 * other antenna 3 times in a row.
 		 */
-		if (sc->sc_defant != ds->ds_rxstat.rs_antenna) {
-			if (++sc->sc_rxotherant >= 3)
+		if (sc->rx.defant != ds->ds_rxstat.rs_antenna) {
+			if (++sc->rx.rxotherant >= 3)
 				ath_setdefantenna(sc, ds->ds_rxstat.rs_antenna);
 		} else {
-			sc->sc_rxotherant = 0;
+			sc->rx.rxotherant = 0;
 		}
 requeue:
-		list_move_tail(&bf->list, &sc->sc_rxbuf);
+		list_move_tail(&bf->list, &sc->rx.rxbuf);
 		ath_rx_buf_link(sc, bf);
 	} while (1);
 
-	spin_unlock_bh(&sc->sc_rxbuflock);
+	spin_unlock_bh(&sc->rx.rxbuflock);
 
 	return 0;
 #undef PA2DESC
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index ec359c6..e20816e 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -286,17 +286,17 @@ static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
 {
 	struct ath_buf *bf = NULL;
 
-	spin_lock_bh(&sc->sc_txbuflock);
+	spin_lock_bh(&sc->tx.txbuflock);
 
-	if (unlikely(list_empty(&sc->sc_txbuf))) {
-		spin_unlock_bh(&sc->sc_txbuflock);
+	if (unlikely(list_empty(&sc->tx.txbuf))) {
+		spin_unlock_bh(&sc->tx.txbuflock);
 		return NULL;
 	}
 
-	bf = list_first_entry(&sc->sc_txbuf, struct ath_buf, list);
+	bf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
 	list_del(&bf->list);
 
-	spin_unlock_bh(&sc->sc_txbuflock);
+	spin_unlock_bh(&sc->tx.txbuflock);
 
 	return bf;
 }
@@ -340,9 +340,9 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 	/*
 	 * Return the list of ath_buf of this mpdu to free queue
 	 */
-	spin_lock_bh(&sc->sc_txbuflock);
-	list_splice_tail_init(bf_q, &sc->sc_txbuf);
-	spin_unlock_bh(&sc->sc_txbuflock);
+	spin_lock_bh(&sc->tx.txbuflock);
+	list_splice_tail_init(bf_q, &sc->tx.txbuf);
+	spin_unlock_bh(&sc->tx.txbuflock);
 }
 
 /*
@@ -383,7 +383,7 @@ static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 
 static void ath_tx_pause_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_txq *txq = &sc->sc_txq[tid->ac->qnum];
+	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
 
 	spin_lock_bh(&txq->axq_lock);
 
@@ -396,7 +396,7 @@ static void ath_tx_pause_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 
 void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_txq *txq = &sc->sc_txq[tid->ac->qnum];
+	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
 
 	ASSERT(tid->paused > 0);
 	spin_lock_bh(&txq->axq_lock);
@@ -685,7 +685,7 @@ static int ath_tx_send_normal(struct ath_softc *sc,
 
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_txq *txq = &sc->sc_txq[tid->ac->qnum];
+	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
 	struct ath_buf *bf;
 	struct list_head bf_head;
 	INIT_LIST_HEAD(&bf_head);
@@ -860,12 +860,12 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 				struct ath_buf *tbf;
 
 				/* allocate new descriptor */
-				spin_lock_bh(&sc->sc_txbuflock);
-				ASSERT(!list_empty((&sc->sc_txbuf)));
-				tbf = list_first_entry(&sc->sc_txbuf,
+				spin_lock_bh(&sc->tx.txbuflock);
+				ASSERT(!list_empty((&sc->tx.txbuf)));
+				tbf = list_first_entry(&sc->tx.txbuf,
 						struct ath_buf, list);
 				list_del(&tbf->list);
-				spin_unlock_bh(&sc->sc_txbuflock);
+				spin_unlock_bh(&sc->tx.txbuflock);
 
 				ATH_TXBUF_RESET(tbf);
 
@@ -1057,9 +1057,9 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 		if (bf_held) {
 			list_del(&bf_held->list);
-			spin_lock_bh(&sc->sc_txbuflock);
-			list_add_tail(&bf_held->list, &sc->sc_txbuf);
-			spin_unlock_bh(&sc->sc_txbuflock);
+			spin_lock_bh(&sc->tx.txbuflock);
+			list_add_tail(&bf_held->list, &sc->tx.txbuf);
+			spin_unlock_bh(&sc->tx.txbuflock);
 		}
 
 		if (!bf_isampdu(bf)) {
@@ -1128,11 +1128,11 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 			if (ATH_TXQ_SETUP(sc, i)) {
-				ath_tx_stopdma(sc, &sc->sc_txq[i]);
+				ath_tx_stopdma(sc, &sc->tx.txq[i]);
 				/* The TxDMA may not really be stopped.
 				 * Double check the hal tx pending count */
 				npend += ath9k_hw_numtxpending(ah,
-						       sc->sc_txq[i].axq_qnum);
+						       sc->tx.txq[i].axq_qnum);
 			}
 		}
 	}
@@ -1157,7 +1157,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (ATH_TXQ_SETUP(sc, i))
-			ath_tx_draintxq(sc, &sc->sc_txq[i], retry_tx);
+			ath_tx_draintxq(sc, &sc->tx.txq[i], retry_tx);
 	}
 }
 
@@ -1819,9 +1819,9 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 		}
 		spin_unlock_bh(&txq->axq_lock);
 
-		spin_lock_bh(&sc->sc_txbuflock);
-		list_add_tail(&bf->list, &sc->sc_txbuf);
-		spin_unlock_bh(&sc->sc_txbuflock);
+		spin_lock_bh(&sc->tx.txbuflock);
+		list_add_tail(&bf->list, &sc->tx.txbuf);
+		spin_unlock_bh(&sc->tx.txbuflock);
 
 		return r;
 	}
@@ -1838,10 +1838,10 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	int error = 0;
 
 	do {
-		spin_lock_init(&sc->sc_txbuflock);
+		spin_lock_init(&sc->tx.txbuflock);
 
 		/* Setup tx descriptors */
-		error = ath_descdma_setup(sc, &sc->sc_txdma, &sc->sc_txbuf,
+		error = ath_descdma_setup(sc, &sc->tx.txdma, &sc->tx.txbuf,
 			"tx", nbufs, 1);
 		if (error != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
@@ -1851,7 +1851,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 		}
 
 		/* XXX allocate beacon state together with vap */
-		error = ath_descdma_setup(sc, &sc->sc_bdma, &sc->sc_bbuf,
+		error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
 					  "beacon", ATH_BCBUF, 1);
 		if (error != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
@@ -1873,12 +1873,12 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 int ath_tx_cleanup(struct ath_softc *sc)
 {
 	/* cleanup beacon descriptors */
-	if (sc->sc_bdma.dd_desc_len != 0)
-		ath_descdma_cleanup(sc, &sc->sc_bdma, &sc->sc_bbuf);
+	if (sc->beacon.bdma.dd_desc_len != 0)
+		ath_descdma_cleanup(sc, &sc->beacon.bdma, &sc->beacon.bbuf);
 
 	/* cleanup tx descriptors */
-	if (sc->sc_txdma.dd_desc_len != 0)
-		ath_descdma_cleanup(sc, &sc->sc_txdma, &sc->sc_txbuf);
+	if (sc->tx.txdma.dd_desc_len != 0)
+		ath_descdma_cleanup(sc, &sc->tx.txdma, &sc->tx.txbuf);
 
 	return 0;
 }
@@ -1926,15 +1926,15 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		 */
 		return NULL;
 	}
-	if (qnum >= ARRAY_SIZE(sc->sc_txq)) {
+	if (qnum >= ARRAY_SIZE(sc->tx.txq)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"qnum %u out of range, max %u!\n",
-			qnum, (unsigned int)ARRAY_SIZE(sc->sc_txq));
+			qnum, (unsigned int)ARRAY_SIZE(sc->tx.txq));
 		ath9k_hw_releasetxqueue(ah, qnum);
 		return NULL;
 	}
 	if (!ATH_TXQ_SETUP(sc, qnum)) {
-		struct ath_txq *txq = &sc->sc_txq[qnum];
+		struct ath_txq *txq = &sc->tx.txq[qnum];
 
 		txq->axq_qnum = qnum;
 		txq->axq_link = NULL;
@@ -1945,9 +1945,9 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_aggr_depth = 0;
 		txq->axq_totalqueued = 0;
 		txq->axq_linkbuf = NULL;
-		sc->sc_txqsetup |= 1<<qnum;
+		sc->tx.txqsetup |= 1<<qnum;
 	}
-	return &sc->sc_txq[qnum];
+	return &sc->tx.txq[qnum];
 }
 
 /* Reclaim resources for a setup queue */
@@ -1955,7 +1955,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	ath9k_hw_releasetxqueue(sc->sc_ah, txq->axq_qnum);
-	sc->sc_txqsetup &= ~(1<<txq->axq_qnum);
+	sc->tx.txqsetup &= ~(1<<txq->axq_qnum);
 }
 
 /*
@@ -1972,15 +1972,15 @@ int ath_tx_setup(struct ath_softc *sc, int haltype)
 {
 	struct ath_txq *txq;
 
-	if (haltype >= ARRAY_SIZE(sc->sc_haltype2q)) {
+	if (haltype >= ARRAY_SIZE(sc->tx.hwq_map)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"HAL AC %u out of range, max %zu!\n",
-			 haltype, ARRAY_SIZE(sc->sc_haltype2q));
+			 haltype, ARRAY_SIZE(sc->tx.hwq_map));
 		return 0;
 	}
 	txq = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, haltype);
 	if (txq != NULL) {
-		sc->sc_haltype2q[haltype] = txq->axq_qnum;
+		sc->tx.hwq_map[haltype] = txq->axq_qnum;
 		return 1;
 	} else
 		return 0;
@@ -1992,19 +1992,19 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 
 	switch (qtype) {
 	case ATH9K_TX_QUEUE_DATA:
-		if (haltype >= ARRAY_SIZE(sc->sc_haltype2q)) {
+		if (haltype >= ARRAY_SIZE(sc->tx.hwq_map)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"HAL AC %u out of range, max %zu!\n",
-				haltype, ARRAY_SIZE(sc->sc_haltype2q));
+				haltype, ARRAY_SIZE(sc->tx.hwq_map));
 			return -1;
 		}
-		qnum = sc->sc_haltype2q[haltype];
+		qnum = sc->tx.hwq_map[haltype];
 		break;
 	case ATH9K_TX_QUEUE_BEACON:
-		qnum = sc->sc_bhalq;
+		qnum = sc->beacon.beaconq;
 		break;
 	case ATH9K_TX_QUEUE_CAB:
-		qnum = sc->sc_cabq->axq_qnum;
+		qnum = sc->beacon.cabq->axq_qnum;
 		break;
 	default:
 		qnum = -1;
@@ -2020,7 +2020,7 @@ struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 	int qnum;
 
 	qnum = ath_get_hal_qnum(skb_get_queue_mapping(skb), sc);
-	txq = &sc->sc_txq[qnum];
+	txq = &sc->tx.txq[qnum];
 
 	spin_lock_bh(&txq->axq_lock);
 
@@ -2049,17 +2049,17 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 	int error = 0;
 	struct ath9k_tx_queue_info qi;
 
-	if (qnum == sc->sc_bhalq) {
+	if (qnum == sc->beacon.beaconq) {
 		/*
 		 * XXX: for beacon queue, we just save the parameter.
 		 * It will be picked up by ath_beaconq_config when
 		 * it's necessary.
 		 */
-		sc->sc_beacon_qi = *qinfo;
+		sc->beacon.beacon_qi = *qinfo;
 		return 0;
 	}
 
-	ASSERT(sc->sc_txq[qnum].axq_qnum == qnum);
+	ASSERT(sc->tx.txq[qnum].axq_qnum == qnum);
 
 	ath9k_hw_get_txq_props(ah, qnum, &qi);
 	qi.tqi_aifs = qinfo->tqi_aifs;
@@ -2082,7 +2082,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 int ath_cabq_update(struct ath_softc *sc)
 {
 	struct ath9k_tx_queue_info qi;
-	int qnum = sc->sc_cabq->axq_qnum;
+	int qnum = sc->beacon.cabq->axq_qnum;
 	struct ath_beacon_config conf;
 
 	ath9k_hw_get_txq_props(sc->sc_ah, qnum, &qi);
@@ -2116,7 +2116,7 @@ void ath_tx_tasklet(struct ath_softc *sc)
 	 */
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (ATH_TXQ_SETUP(sc, i) && (qcumask & (1 << i)))
-			ath_tx_processq(sc, &sc->sc_txq[i]);
+			ath_tx_processq(sc, &sc->tx.txq[i]);
 	}
 }
 
@@ -2148,9 +2148,9 @@ void ath_tx_draintxq(struct ath_softc *sc,
 			list_del(&bf->list);
 			spin_unlock_bh(&txq->axq_lock);
 
-			spin_lock_bh(&sc->sc_txbuflock);
-			list_add_tail(&bf->list, &sc->sc_txbuf);
-			spin_unlock_bh(&sc->sc_txbuflock);
+			spin_lock_bh(&sc->tx.txbuflock);
+			list_add_tail(&bf->list, &sc->tx.txbuf);
+			spin_unlock_bh(&sc->tx.txbuflock);
 			continue;
 		}
 
@@ -2188,9 +2188,9 @@ void ath_draintxq(struct ath_softc *sc, bool retry_tx)
 	/* stop beacon queue. The beacon will be freed when
 	 * we go to INIT state */
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
-		(void) ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
+		(void) ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		DPRINTF(sc, ATH_DBG_XMIT, "beacon queue %x\n",
-			ath9k_hw_gettxbuf(sc->sc_ah, sc->sc_bhalq));
+			ath9k_hw_gettxbuf(sc->sc_ah, sc->beacon.beaconq));
 	}
 
 	ath_drain_txdataq(sc, retry_tx);
@@ -2198,12 +2198,12 @@ void ath_draintxq(struct ath_softc *sc, bool retry_tx)
 
 u32 ath_txq_depth(struct ath_softc *sc, int qnum)
 {
-	return sc->sc_txq[qnum].axq_depth;
+	return sc->tx.txq[qnum].axq_depth;
 }
 
 u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum)
 {
-	return sc->sc_txq[qnum].axq_aggr_depth;
+	return sc->tx.txq[qnum].axq_aggr_depth;
 }
 
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno)
@@ -2284,7 +2284,7 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 void ath_tx_aggr_teardown(struct ath_softc *sc, struct ath_node *an, u8 tid)
 {
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
-	struct ath_txq *txq = &sc->sc_txq[txtid->ac->qnum];
+	struct ath_txq *txq = &sc->tx.txq[txtid->ac->qnum];
 	struct ath_buf *bf;
 	struct list_head bf_head;
 	INIT_LIST_HEAD(&bf_head);
@@ -2466,7 +2466,7 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 	struct ath_txq *txq;
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (ATH_TXQ_SETUP(sc, i)) {
-			txq = &sc->sc_txq[i];
+			txq = &sc->tx.txq[i];
 
 			spin_lock(&txq->axq_lock);
 
@@ -2511,9 +2511,9 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			sc->seq_no += 0x10;
+			sc->tx.seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(sc->seq_no);
+		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
 	}
 
 	/* Add the padding after the header if this is not already done */
@@ -2529,7 +2529,7 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
 		memmove(skb->data, skb->data + padsize, hdrlen);
 	}
 
-	txctl.txq = sc->sc_cabq;
+	txctl.txq = sc->beacon.cabq;
 
 	DPRINTF(sc, ATH_DBG_XMIT, "transmitting CABQ packet, skb: %p\n", skb);
 
-- 
1.6.0.3

