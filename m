Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38751 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbYHKIrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:47:17 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:47:17 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63970.871452.616691@localhost.localdomain> (sfid-20080811_104824_547343_9D8C8855)
Date: Mon, 11 Aug 2008 14:05:46 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 10/10] ath9k: Trim struct ath_softc
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add sc_rxflush and sc_noreset as bitfields to sc_flags.
Remove a few variables and function prototypes that are unused.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |    8 ++--
 drivers/net/wireless/ath9k/core.c   |   10 ------
 drivers/net/wireless/ath9k/core.h   |   58 ++++++++++++----------------------
 drivers/net/wireless/ath9k/recv.c   |    8 ++--
 drivers/net/wireless/ath9k/xmit.c   |    8 +---
 5 files changed, 31 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index f1c4201..e0ca017 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -555,7 +555,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 	u32 tsftu;
 	u16 intval;
 
-	if (sc->sc_noreset) {
+	if (sc->sc_flags & SC_OP_NO_RESET) {
 		show_cycles = ath9k_hw_GetMibCycleCountsPct(ah,
 							    &rx_clear,
 							    &rx_frame,
@@ -577,7 +577,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 		 *      (in that layer).
 		 */
 		if (sc->sc_bmisscount < BSTUCK_THRESH) {
-			if (sc->sc_noreset) {
+			if (sc->sc_flags & SC_OP_NO_RESET) {
 				DPRINTF(sc, ATH_DBG_BEACON,
 					"%s: missed %u consecutive beacons\n",
 					__func__, sc->sc_bmisscount);
@@ -605,7 +605,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 					__func__, sc->sc_bmisscount);
 			}
 		} else if (sc->sc_bmisscount >= BSTUCK_THRESH) {
-			if (sc->sc_noreset) {
+			if (sc->sc_flags & SC_OP_NO_RESET) {
 				if (sc->sc_bmisscount == BSTUCK_THRESH) {
 					DPRINTF(sc,
 						ATH_DBG_BEACON,
@@ -624,7 +624,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 		return;
 	}
 	if (sc->sc_bmisscount != 0) {
-		if (sc->sc_noreset) {
+		if (sc->sc_flags & SC_OP_NO_RESET) {
 			DPRINTF(sc,
 				ATH_DBG_BEACON,
 				"%s: resume beacon xmit after %u misses\n",
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 87b4ca5..0d953f9 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1055,9 +1055,6 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	}
 	sc->sc_ah = ah;
 
-	/* Get the chipset-specific aggr limit. */
-	sc->sc_rtsaggrlimit = ah->ah_caps.rts_aggr_limit;
-
 	/* Get the hardware key cache size. */
 	sc->sc_keymax = ah->ah_caps.keycache_size;
 	if (sc->sc_keymax > ATH_KEYMAX) {
@@ -1216,13 +1213,6 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_tx_chainmask = ah->ah_caps.tx_chainmask;
 	sc->sc_rx_chainmask = ah->ah_caps.rx_chainmask;
 
-	/* Configuration for rx chain detection */
-	sc->sc_rxchaindetect_ref = 0;
-	sc->sc_rxchaindetect_thresh5GHz = 35;
-	sc->sc_rxchaindetect_thresh2GHz = 35;
-	sc->sc_rxchaindetect_delta5GHz = 30;
-	sc->sc_rxchaindetect_delta2GHz = 30;
-
 	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
 	sc->sc_defant = ath9k_hw_getdefantenna(ah);
 
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 7f4bd15..8243ff0 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -724,11 +724,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id);
 int ath_beaconq_setup(struct ath_hal *ah);
 int ath_beacon_alloc(struct ath_softc *sc, int if_id);
 void ath_bstuck_process(struct ath_softc *sc);
-void ath_beacon_tasklet(struct ath_softc *sc, int *needmark);
-void ath_beacon_free(struct ath_softc *sc);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp);
 void ath_beacon_sync(struct ath_softc *sc, int if_id);
-void ath_update_beacon_info(struct ath_softc *sc, int avgbrssi);
 void ath_get_beaconconfig(struct ath_softc *sc,
 			  int if_id,
 			  struct ath_beacon_config *conf);
@@ -896,8 +893,10 @@ struct ath_ht_info {
 #define SC_OP_TXAGGR		BIT(3)
 #define SC_OP_CHAINMASK_UPDATE	BIT(4)
 #define SC_OP_FULL_RESET	BIT(5)
-#define SC_OP_PREAMBLE_SHORT	BIT(6)
-#define SC_OP_PROTECT_ENABLE	BIT(7)
+#define SC_OP_NO_RESET		BIT(6)
+#define SC_OP_PREAMBLE_SHORT	BIT(7)
+#define SC_OP_PROTECT_ENABLE	BIT(8)
+#define SC_OP_RXFLUSH		BIT(9)
 
 struct ath_softc {
 	struct ieee80211_hw *hw;
@@ -909,44 +908,39 @@ struct ath_softc {
 	struct ath_rate_softc *sc_rc;
 	void __iomem *mem;
 
+	u8 sc_curbssid[ETH_ALEN];
+	u8 sc_myaddr[ETH_ALEN];
+	u8 sc_bssidmask[ETH_ALEN];
+
 	int sc_debug;
 	u32 sc_intrstatus;
 	u32 sc_flags; /* SC_OP_* */
 	unsigned int rx_filter;
-
-	enum wireless_mode sc_curmode;	/* current phy mode */
 	u16 sc_curtxpow;
 	u16 sc_curaid;
-	u8 sc_curbssid[ETH_ALEN];
-	u8 sc_myaddr[ETH_ALEN];
+	u16 sc_cachelsz;
+	int sc_slotupdate;		/* slot to next advance fsm */
+	int sc_slottime;
+	int sc_bslot[ATH_BCBUF];
+	u8 sc_tx_chainmask;
+	u8 sc_rx_chainmask;
+	enum ath9k_int sc_imask;
+	enum wireless_mode sc_curmode;	/* current phy mode */
 	enum PROT_MODE sc_protmode;
-	u8 sc_mcastantenna;
-	u8 sc_txantenna;		/* data tx antenna (fixed or auto) */
+
 	u8 sc_nbcnvaps;			/* # of vaps sending beacons */
 	u16 sc_nvaps;			/* # of active virtual ap's */
 	struct ath_vap *sc_vaps[ATH_BCBUF];
-	enum ath9k_int sc_imask;
-	u8 sc_bssidmask[ETH_ALEN];
+
+	u8 sc_mcastantenna;
 	u8 sc_defant;			/* current default antenna */
 	u8 sc_rxotherant;		/* rx's on non-default antenna */
-	u16 sc_cachelsz;
-	int sc_slotupdate;		/* slot to next advance fsm */
-	int sc_slottime;
-	u8 sc_noreset;
-	int sc_bslot[ATH_BCBUF];
+
 	struct ath9k_node_stats sc_halstats; /* station-mode rssi stats */
 	struct list_head node_list;
 	struct ath_ht_info sc_ht_info;
-	int16_t sc_noise_floor;		/* signal noise floor in dBm */
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
-	u8 sc_tx_chainmask;
-	u8 sc_rx_chainmask;
-	u8 sc_rxchaindetect_ref;
-	u8 sc_rxchaindetect_thresh5GHz;
-	u8 sc_rxchaindetect_thresh2GHz;
-	u8 sc_rxchaindetect_delta5GHz;
-	u8 sc_rxchaindetect_delta2GHz;
-	u32 sc_rtsaggrlimit;		/* Chipset specific aggr limit */
+
 #ifdef CONFIG_SLOW_ANT_DIV
 	struct ath_antdiv sc_antdiv;
 #endif
@@ -967,7 +961,6 @@ struct ath_softc {
 	struct ath_descdma sc_rxdma;
 	int sc_rxbufsize;	/* rx size based on mtu */
 	u32 *sc_rxlink;		/* link ptr in last RX desc */
-	u32 sc_rxflush;		/* rx flush in progress */
 	u64 sc_lastrx;		/* tsf of last rx'd frame */
 
 	/* TX */
@@ -977,7 +970,6 @@ struct ath_softc {
 	u32 sc_txqsetup;
 	u32 sc_txintrperiod;	/* tx interrupt batching */
 	int sc_haltype2q[ATH9K_WME_AC_VO+1]; /* HAL WME	AC -> h/w qnum */
-	u32 sc_ant_tx[8];	/* recent tx frames/antenna */
 
 	/* Beacon */
 	struct ath9k_tx_queue_info sc_beacon_qi;
@@ -1016,13 +1008,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan);
 int ath_suspend(struct ath_softc *sc);
 irqreturn_t ath_isr(int irq, void *dev);
 int ath_reset(struct ath_softc *sc, bool retry_tx);
-void ath_scan_start(struct ath_softc *sc);
-void ath_scan_end(struct ath_softc *sc);
 int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan);
-void ath_setup_rate(struct ath_softc *sc,
-		    enum wireless_mode wMode,
-		    enum RATE_TYPE type,
-		    const struct ath9k_rate_table *rt);
 
 /*********************/
 /* Utility Functions */
@@ -1041,7 +1027,6 @@ int ath_cabq_update(struct ath_softc *);
 void ath_get_currentCountry(struct ath_softc *sc,
 	struct ath9k_country_entry *ctry);
 u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp);
-u32 ath_chan2flags(struct ieee80211_channel *chan, struct ath_softc *sc);
 dma_addr_t ath_skb_map_single(struct ath_softc *sc,
 			      struct sk_buff *skb,
 			      int direction,
@@ -1050,7 +1035,6 @@ void ath_skb_unmap_single(struct ath_softc *sc,
 			  struct sk_buff *skb,
 			  int direction,
 			  dma_addr_t *pa);
-void ath_mcast_merge(struct ath_softc *sc, u32 mfilt[2]);
 enum ath9k_ht_macmode ath_cwm_macmode(struct ath_softc *sc);
 
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 9c75832..af2011f 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -504,7 +504,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 
 	do {
 		spin_lock_init(&sc->sc_rxflushlock);
-		sc->sc_rxflush = 0;
+		sc->sc_flags &= ~SC_OP_RXFLUSH;
 		spin_lock_init(&sc->sc_rxbuflock);
 
 		/*
@@ -707,11 +707,11 @@ void ath_flushrecv(struct ath_softc *sc)
 	 * progress (see references to sc_rxflush)
 	 */
 	spin_lock_bh(&sc->sc_rxflushlock);
-	sc->sc_rxflush = 1;
+	sc->sc_flags |= SC_OP_RXFLUSH;
 
 	ath_rx_tasklet(sc, 1);
 
-	sc->sc_rxflush = 0;
+	sc->sc_flags &= ~SC_OP_RXFLUSH;
 	spin_unlock_bh(&sc->sc_rxflushlock);
 }
 
@@ -755,7 +755,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 	do {
 		/* If handling rx interrupt and flush is in progress => exit */
-		if (sc->sc_rxflush && (flush == 0))
+		if ((sc->sc_flags & SC_OP_RXFLUSH) && (flush == 0))
 			break;
 
 		spin_lock_bh(&sc->sc_rxbuflock);
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 9ea5d93..e2ffa1c 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -485,12 +485,8 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		antenna = sc->sc_mcastantenna + 1;
 		sc->sc_mcastantenna = (sc->sc_mcastantenna + 1) & 0x1;
-	} else
-		antenna = sc->sc_txantenna;
+	}
 
-#ifdef USE_LEGACY_HAL
-	txctl->antenna = antenna;
-#endif
 	return 0;
 }
 
@@ -743,7 +739,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	int i, flags, rtsctsena = 0, dynamic_mimops = 0;
 	u32 ctsduration = 0;
 	u8 rix = 0, cix, ctsrate = 0;
-	u32 aggr_limit_with_rts = sc->sc_rtsaggrlimit;
+	u32 aggr_limit_with_rts = ah->ah_caps.rts_aggr_limit;
 	struct ath_node *an = (struct ath_node *) bf->bf_node;
 
 	/*
-- 
1.5.6.5

