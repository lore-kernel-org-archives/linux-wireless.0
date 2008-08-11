Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51645 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYHKIqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:46:40 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:46:40 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63932.991262.587426@localhost.localdomain> (sfid-20080811_104643_563380_AACF9ED6)
Date: Mon, 11 Aug 2008 14:05:08 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 08/10] ath9k: Use bitfields for sc operations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |    4 +-
 drivers/net/wireless/ath9k/core.c   |   45 ++++++++++++++++++-----------------
 drivers/net/wireless/ath9k/core.h   |   24 ++++++++++--------
 drivers/net/wireless/ath9k/main.c   |   14 +++++-----
 drivers/net/wireless/ath9k/rc.c     |    2 +-
 drivers/net/wireless/ath9k/recv.c   |    8 +++---
 drivers/net/wireless/ath9k/xmit.c   |   31 ++++++++++++-----------
 7 files changed, 66 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 2736a4b..f1c4201 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -111,7 +111,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	rix = 0;
 	rt = sc->sc_currates;
 	rate = rt->info[rix].rateCode;
-	if (sc->sc_flags & ATH_PREAMBLE_SHORT)
+	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
 		rate |= rt->info[rix].shortPreamble;
 
 	ath9k_hw_set11n_txdesc(ah, ds
@@ -975,5 +975,5 @@ void ath_beacon_sync(struct ath_softc *sc, int if_id)
 	 * beacon frame we just received.
 	 */
 	ath_beacon_config(sc, if_id);
-	sc->sc_beacons = 1;
+	sc->sc_flags |= SC_OP_BEACONS;
 }
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 8359356..9b8258d 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -272,8 +272,8 @@ static int ath_stop(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: invalid %u\n",
-		__func__, sc->sc_invalid);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: invalid %ld\n",
+		__func__, sc->sc_flags & SC_OP_INVALID);
 
 	/*
 	 * Shutdown the hardware and driver:
@@ -291,10 +291,10 @@ static int ath_stop(struct ath_softc *sc)
 	 * hardware is gone (invalid).
 	 */
 
-	if (!sc->sc_invalid)
+	if (!(sc->sc_flags & SC_OP_INVALID))
 		ath9k_hw_set_interrupts(ah, 0);
 	ath_draintxq(sc, false);
-	if (!sc->sc_invalid) {
+	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
 	} else
@@ -316,7 +316,7 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	bool fastcc = true, stopped;
 	enum ath9k_ht_macmode ht_macmode;
 
-	if (sc->sc_invalid)	/* if the device is invalid or removed */
+	if (sc->sc_flags & SC_OP_INVALID) /* the device is invalid or removed */
 		return -EIO;
 
 	DPRINTF(sc, ATH_DBG_CONFIG,
@@ -332,7 +332,8 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 	if (hchan->channel != sc->sc_curchan.channel ||
 	    hchan->channelFlags != sc->sc_curchan.channelFlags ||
-	    sc->sc_update_chainmask || sc->sc_full_reset) {
+	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
+	    (sc->sc_flags & SC_OP_FULL_RESET)) {
 		int status;
 		/*
 		 * This is only performed if the channel settings have
@@ -351,7 +352,7 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 		 * to flush data frames already in queue because of
 		 * changing channel. */
 
-		if (!stopped || sc->sc_full_reset)
+		if (!stopped || (sc->sc_flags & SC_OP_FULL_RESET))
 			fastcc = false;
 
 		spin_lock_bh(&sc->sc_resetlock);
@@ -372,8 +373,8 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 		spin_unlock_bh(&sc->sc_resetlock);
 
 		sc->sc_curchan = *hchan;
-		sc->sc_update_chainmask = 0;
-		sc->sc_full_reset = 0;
+		sc->sc_flags &= ~SC_OP_CHAINMASK_UPDATE;
+		sc->sc_flags &= ~SC_OP_FULL_RESET;
 
 		/* Re-enable rx framework */
 		if (ath_startrecv(sc) != 0) {
@@ -484,7 +485,7 @@ int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an)
 
 void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 {
-	sc->sc_update_chainmask = 1;
+	sc->sc_flags |= SC_OP_CHAINMASK_UPDATE;
 	if (is_ht) {
 		sc->sc_tx_chainmask = sc->sc_ah->ah_caps.tx_chainmask;
 		sc->sc_rx_chainmask = sc->sc_ah->ah_caps.rx_chainmask;
@@ -553,7 +554,7 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 		sc->sc_imask & ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS));
 	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
 	/* need to reconfigure the beacons when it moves to RUN */
-	sc->sc_beacons = 0;
+	sc->sc_flags &= ~SC_OP_BEACONS;
 
 	return 0;
 }
@@ -773,7 +774,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 
 	/* XXX: we must make sure h/w is ready and clear invalid flag
 	 * before turning on interrupt. */
-	sc->sc_invalid = 0;
+	sc->sc_flags &= ~SC_OP_INVALID;
 done:
 	return error;
 }
@@ -816,7 +817,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	ath_update_txpow(sc);
 
-	if (sc->sc_beacons)
+	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, ATH_IF_ID_ANY);	/* restart beacons */
 
 	ath9k_hw_set_interrupts(ah, sc->sc_imask);
@@ -841,7 +842,7 @@ int ath_suspend(struct ath_softc *sc)
 	struct ath_hal *ah = sc->sc_ah;
 
 	/* No I/O if device has been surprise removed */
-	if (sc->sc_invalid)
+	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
 
 	/* Shut off the interrupt before setting sc->sc_invalid to '1' */
@@ -849,7 +850,7 @@ int ath_suspend(struct ath_softc *sc)
 
 	/* XXX: we must make sure h/w will not generate any interrupt
 	 * before setting the invalid flag. */
-	sc->sc_invalid = 1;
+	sc->sc_flags |= SC_OP_INVALID;
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
@@ -870,7 +871,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	bool sched = false;
 
 	do {
-		if (sc->sc_invalid) {
+		if (sc->sc_flags & SC_OP_INVALID) {
 			/*
 			 * The hardware is not ready/present, don't
 			 * touch anything. Note this can happen early
@@ -1026,7 +1027,7 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	u32 rd;
 
 	/* XXX: hardware will not be ready until ath_open() being called */
-	sc->sc_invalid = 1;
+	sc->sc_flags |= SC_OP_INVALID;
 
 	sc->sc_debug = DBG_DEFAULT;
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: devid 0x%x\n", __func__, devid);
@@ -1210,8 +1211,8 @@ int ath_init(u16 devid, struct ath_softc *sc)
 
 	/* 11n Capabilities */
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
-		sc->sc_txaggr = 1;
-		sc->sc_rxaggr = 1;
+		sc->sc_flags |= SC_OP_TXAGGR;
+		sc->sc_flags |= SC_OP_RXAGGR;
 	}
 
 	sc->sc_tx_chainmask = ah->ah_caps.tx_chainmask;
@@ -1267,7 +1268,7 @@ void ath_deinit(struct ath_softc *sc)
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s\n", __func__);
 
 	ath_stop(sc);
-	if (!sc->sc_invalid)
+	if (!(sc->sc_flags & SC_OP_INVALID))
 		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 	ath_rate_detach(sc->sc_rc);
 	/* cleanup tx queues */
@@ -1394,9 +1395,9 @@ void ath_newassoc(struct ath_softc *sc,
 	/* if station reassociates, tear down the aggregation state. */
 	if (!isnew) {
 		for (tidno = 0; tidno < WME_NUM_TID; tidno++) {
-			if (sc->sc_txaggr)
+			if (sc->sc_flags & SC_OP_TXAGGR)
 				ath_tx_aggr_teardown(sc, an, tidno);
-			if (sc->sc_rxaggr)
+			if (sc->sc_flags & SC_OP_RXAGGR)
 				ath_rx_aggr_teardown(sc, an, tidno);
 		}
 	}
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index bfe1623..702f7b8 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -830,8 +830,6 @@ void ath_setdefantenna(void *sc, u32 antenna);
 #define	ATH_DEFAULT_NOISE_FLOOR -95
 #define ATH_REGCLASSIDS_MAX     10
 #define ATH_CABQ_READY_TIME     80  /* % of beacon interval */
-#define ATH_PREAMBLE_SHORT	(1<<0)
-#define ATH_PROTECT_ENABLE	(1<<1)
 #define ATH_MAX_SW_RETRIES      10
 #define ATH_CHAN_MAX            255
 #define IEEE80211_WEP_NKID      4       /* number of key ids */
@@ -892,25 +890,30 @@ struct ath_ht_info {
 	u8 ext_chan_offset;
 };
 
+#define SC_OP_INVALID		BIT(0)
+#define SC_OP_BEACONS		BIT(1)
+#define SC_OP_RXAGGR		BIT(2)
+#define SC_OP_TXAGGR		BIT(3)
+#define SC_OP_CHAINMASK_UPDATE	BIT(4)
+#define SC_OP_FULL_RESET	BIT(5)
+#define SC_OP_PREAMBLE_SHORT	BIT(6)
+#define SC_OP_PROTECT_ENABLE	BIT(7)
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct pci_dev *pdev;
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
-	struct ath_config sc_config;	/* load-time parameters */
+	struct ath_config sc_config;
 	struct ath_hal *sc_ah;
-	struct ath_rate_softc *sc_rc;	/* tx rate control support */
+	struct ath_rate_softc *sc_rc;
 	void __iomem *mem;
 
 	int sc_debug;
 	u32 sc_intrstatus;
+	u32 sc_flags; /* SC_OP_* */
 	unsigned int rx_filter;
-	u8 sc_invalid;			/* being detached */
-	u8 sc_beacons;			/* beacons running */
-	u8 sc_txaggr;			/* enable 11n tx aggregation */
-	u8 sc_rxaggr;			/* enable 11n rx aggregation */
-	u8 sc_update_chainmask;		/* change chain mask */
-	u8 sc_full_reset;		/* force full reset */
+
 	enum wireless_mode sc_curmode;	/* current phy mode */
 	u16 sc_curtxpow;
 	u16 sc_curaid;
@@ -944,7 +947,6 @@ struct ath_softc {
 	u8 sc_rxchaindetect_delta5GHz;
 	u8 sc_rxchaindetect_delta2GHz;
 	u32 sc_rtsaggrlimit;		/* Chipset specific aggr limit */
-	u32 sc_flags;
 #ifdef CONFIG_SLOW_ANT_DIV
 	struct ath_antdiv sc_antdiv;
 #endif
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7504b64..7fb57ee 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -481,7 +481,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	/* Set interrupt mask */
 	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask & ~ATH9K_INT_GLOBAL);
-	sc->sc_beacons = 0;
+	sc->sc_flags &= ~SC_OP_BEACONS;
 
 	error = ath_vap_detach(sc, 0);
 	if (error)
@@ -582,7 +582,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 				print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
 
 			/* need to reconfigure the beacon */
-			sc->sc_beacons = 0;
+			sc->sc_flags &= ~SC_OP_BEACONS ;
 
 			break;
 		default:
@@ -833,7 +833,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 
 		/* Configure the beacon */
 		ath_beacon_config(sc, 0);
-		sc->sc_beacons = 1;
+		sc->sc_flags |= SC_OP_BEACONS;
 
 		/* Reset rssi stats */
 		sc->sc_halstats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
@@ -896,9 +896,9 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			__func__,
 			bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
-			sc->sc_flags |= ATH_PREAMBLE_SHORT;
+			sc->sc_flags |= SC_OP_PREAMBLE_SHORT;
 		else
-			sc->sc_flags &= ~ATH_PREAMBLE_SHORT;
+			sc->sc_flags &= ~SC_OP_PREAMBLE_SHORT;
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
@@ -907,9 +907,9 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot &&
 		    hw->conf.channel->band != IEEE80211_BAND_5GHZ)
-			sc->sc_flags |= ATH_PROTECT_ENABLE;
+			sc->sc_flags |= SC_OP_PROTECT_ENABLE;
 		else
-			sc->sc_flags &= ~ATH_PROTECT_ENABLE;
+			sc->sc_flags &= ~SC_OP_PROTECT_ENABLE;
 	}
 
 	if (changed & BSS_CHANGED_HT) {
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 73c460a..20e1084 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1903,7 +1903,7 @@ static void ath_tx_aggr_resp(struct ath_softc *sc,
 	int state;
 	DECLARE_MAC_BUF(mac);
 
-	if (!sc->sc_txaggr)
+	if (!(sc->sc_flags & SC_OP_TXAGGR))
 		return;
 
 	txtid = ATH_AN_2_TID(an, tidno);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 6d1d503..9c75832 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -724,7 +724,7 @@ int ath_rx_input(struct ath_softc *sc,
 		 struct ath_recv_status *rx_status,
 		 enum ATH_RX_TYPE *status)
 {
-	if (is_ampdu && sc->sc_rxaggr) {
+	if (is_ampdu && (sc->sc_flags & SC_OP_RXAGGR)) {
 		*status = ATH_RX_CONSUMED;
 		return ath_ampdu_input(sc, an, skb, rx_status);
 	} else {
@@ -1132,7 +1132,7 @@ int ath_rx_aggr_start(struct ath_softc *sc,
 	rxtid = &an->an_aggr.rx.tid[tid];
 
 	spin_lock_bh(&rxtid->tidlock);
-	if (sc->sc_rxaggr) {
+	if (sc->sc_flags & SC_OP_RXAGGR) {
 		/* Allow aggregation reception
 		 * Adjust rx BA window size. Peer might indicate a
 		 * zero buffer size for a _dont_care_ condition.
@@ -1232,7 +1232,7 @@ void ath_rx_aggr_teardown(struct ath_softc *sc,
 
 void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an)
 {
-	if (sc->sc_rxaggr) {
+	if (sc->sc_flags & SC_OP_RXAGGR) {
 		struct ath_arx_tid *rxtid;
 		int tidno;
 
@@ -1264,7 +1264,7 @@ void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an)
 
 void ath_rx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 {
-	if (sc->sc_rxaggr) {
+	if (sc->sc_flags & SC_OP_RXAGGR) {
 		struct ath_arx_tid *rxtid;
 		int tidno, i;
 
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 0b5b2dd..75a8492 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -392,7 +392,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 		 * incremented by the fragmentation routine.
 		 */
 		if (likely(!(txctl->flags & ATH9K_TXDESC_FRAG_IS_ON)) &&
-			txctl->ht && sc->sc_txaggr) {
+		    txctl->ht && (sc->sc_flags & SC_OP_TXAGGR)) {
 			struct ath_atx_tid *tid;
 
 			tid = ATH_AN_2_TID(txctl->an, txctl->tidno);
@@ -422,7 +422,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 		/*
 		 * XXX not right with fragmentation.
 		 */
-		if (sc->sc_flags & ATH_PREAMBLE_SHORT)
+		if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
 			dur = rt->info[rix].spAckDuration;
 		else
 			dur = rt->info[rix].lpAckDuration;
@@ -438,8 +438,9 @@ static int ath_tx_prepare(struct ath_softc *sc,
 			** Add time for next fragment.
 			*/
 			dur += ath9k_hw_computetxtime(sc->sc_ah, rt,
-					txctl->nextfraglen,
-					rix, sc->sc_flags & ATH_PREAMBLE_SHORT);
+				      txctl->nextfraglen,
+				      rix,
+				      (sc->sc_flags & SC_OP_PREAMBLE_SHORT));
 		}
 
 		if (ieee80211_has_morefrags(fc) ||
@@ -1406,7 +1407,7 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		/*
 		 * schedule any pending packets if aggregation is enabled
 		 */
-		if (sc->sc_txaggr)
+		if (sc->sc_flags & SC_OP_TXAGGR)
 			ath_txq_schedule(sc, txq);
 		spin_unlock_bh(&txq->axq_lock);
 	}
@@ -1433,7 +1434,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
 	/* XXX return value */
-	if (!sc->sc_invalid) {
+	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 			if (ATH_TXQ_SETUP(sc, i)) {
 				ath_tx_stopdma(sc, &sc->sc_txq[i]);
@@ -2024,7 +2025,7 @@ static int ath_tx_start_dma(struct ath_softc *sc,
 	ieee80211_is_pspoll(fc) ?
 		(bf->bf_state.bf_type |= BUF_PSPOLL) :
 		(bf->bf_state.bf_type &= ~BUF_PSPOLL);
-	(sc->sc_flags & ATH_PREAMBLE_SHORT) ?
+	(sc->sc_flags & SC_OP_PREAMBLE_SHORT) ?
 		(bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE) :
 		(bf->bf_state.bf_type &= ~BUF_SHORT_PREAMBLE);
 
@@ -2076,7 +2077,7 @@ static int ath_tx_start_dma(struct ath_softc *sc,
 
 	spin_lock_bh(&txq->axq_lock);
 
-	if (txctl->ht && sc->sc_txaggr) {
+	if (txctl->ht && (sc->sc_flags & SC_OP_TXAGGR)) {
 		struct ath_atx_tid *tid = ATH_AN_2_TID(an, txctl->tidno);
 		if (ath_aggr_query(sc, an, txctl->tidno)) {
 			/*
@@ -2153,7 +2154,7 @@ static void xmit_map_sg(struct ath_softc *sc,
 		tx_status.retries = 0;
 		tx_status.flags = ATH_TX_ERROR;
 
-		if (txctl->ht && sc->sc_txaggr) {
+		if (txctl->ht && (sc->sc_flags & SC_OP_TXAGGR)) {
 			/* Reclaim the seqno. */
 			tid = ATH_AN_2_TID((struct ath_node *)
 				txctl->an, txctl->tidno);
@@ -2505,7 +2506,7 @@ void ath_tx_draintxq(struct ath_softc *sc,
 	}
 
 	/* flush any pending frames if aggregation is enabled */
-	if (sc->sc_txaggr) {
+	if (sc->sc_flags & SC_OP_TXAGGR) {
 		if (!retry_tx) {
 			spin_lock_bh(&txq->axq_lock);
 			ath_txq_drain_pending_buffers(sc, txq,
@@ -2521,7 +2522,7 @@ void ath_draintxq(struct ath_softc *sc, bool retry_tx)
 {
 	/* stop beacon queue. The beacon will be freed when
 	 * we go to INIT state */
-	if (!sc->sc_invalid) {
+	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		(void) ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
 		DPRINTF(sc, ATH_DBG_XMIT, "%s: beacon queue %x\n", __func__,
 			ath9k_hw_gettxbuf(sc->sc_ah, sc->sc_bhalq));
@@ -2548,7 +2549,7 @@ enum ATH_AGGR_CHECK ath_tx_aggr_check(struct ath_softc *sc,
 	struct ath_atx_tid *txtid;
 	DECLARE_MAC_BUF(mac);
 
-	if (!sc->sc_txaggr)
+	if (!(sc->sc_flags & SC_OP_TXAGGR))
 		return AGGR_NOT_REQUIRED;
 
 	/* ADDBA exchange must be completed before sending aggregates */
@@ -2595,7 +2596,7 @@ int ath_tx_aggr_start(struct ath_softc *sc,
 		return -1;
 	}
 
-	if (sc->sc_txaggr) {
+	if (sc->sc_flags & SC_OP_TXAGGR) {
 		txtid = ATH_AN_2_TID(an, tid);
 		txtid->addba_exchangeinprogress = 1;
 		ath_tx_pause_tid(sc, txtid);
@@ -2755,7 +2756,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 {
-	if (sc->sc_txaggr) {
+	if (sc->sc_flags & SC_OP_TXAGGR) {
 		struct ath_atx_tid *tid;
 		struct ath_atx_ac *ac;
 		int tidno, acno;
@@ -2867,7 +2868,7 @@ void ath_tx_node_cleanup(struct ath_softc *sc,
 
 void ath_tx_node_free(struct ath_softc *sc, struct ath_node *an)
 {
-	if (sc->sc_txaggr) {
+	if (sc->sc_flags & SC_OP_TXAGGR) {
 		struct ath_atx_tid *tid;
 		int tidno, i;
 
-- 
1.5.6.5

