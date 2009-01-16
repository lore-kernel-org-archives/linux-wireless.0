Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46735 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756810AbZAPQMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:12:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:12:07 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.45327.605366.83548@gargle.gargle.HOWL> (sfid-20090116_171214_388347_47E2053A)
Date: Fri, 16 Jan 2009 21:38:47 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 5/9] ath9k: Merge queue draining functions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX queue draining routines have confusing names,
rename them approprately and merge ath_drain_txdataq()
with ath_drain_all_txq().

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath9k/core.h   |    4 +-
 drivers/net/wireless/ath9k/main.c   |    8 ++--
 drivers/net/wireless/ath9k/xmit.c   |   98 +++++++++++++++++------------------
 4 files changed, 55 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index be1d84a..61d37be 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -220,7 +220,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 		 * acquires txq lock inside.
 		 */
 		if (sc->sc_nvaps > 1) {
-			ath_tx_draintxq(sc, cabq, false);
+			ath_draintxq(sc, cabq, false);
 			DPRINTF(sc, ATH_DBG_BEACON,
 				"flush previous cabq traffic\n");
 		}
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 4eb21a7..04bc6fd 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -485,8 +485,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush);
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
 void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_setup(struct ath_softc *sc, int haltype);
-void ath_draintxq(struct ath_softc *sc, bool retry_tx);
-void ath_tx_draintxq(struct ath_softc *sc,
+void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx);
+void ath_draintxq(struct ath_softc *sc,
 		     struct ath_txq *txq, bool retry_tx);
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7f4d1bb..8ad927a 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -247,7 +247,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	 * the relevant bits of the h/w.
 	 */
 	ath9k_hw_set_interrupts(ah, 0);
-	ath_draintxq(sc, false);
+	ath_drain_all_txq(sc, false);
 	stopped = ath_stoprecv(sc);
 
 	/* XXX: do not flush receive queue here. We don't want
@@ -1092,7 +1092,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 	/* Disable interrupts */
 	ath9k_hw_set_interrupts(ah, 0);
 
-	ath_draintxq(sc, false);	/* clear pending tx frames */
+	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
 	ath_stoprecv(sc);		/* turn off frame recv */
 	ath_flushrecv(sc);		/* flush recv queue */
 
@@ -1592,7 +1592,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	int r;
 
 	ath9k_hw_set_interrupts(ah, 0);
-	ath_draintxq(sc, retry_tx);
+	ath_drain_all_txq(sc, retry_tx);
 	ath_stoprecv(sc);
 	ath_flushrecv(sc);
 
@@ -1988,7 +1988,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath9k_hw_set_interrupts(sc->sc_ah, 0);
 
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
-		ath_draintxq(sc, false);
+		ath_drain_all_txq(sc, false);
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(sc->sc_ah);
 	} else
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index c9ead1b..a29b998 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -890,43 +890,6 @@ static void ath_get_beaconconfig(struct ath_softc *sc, int if_id,
 	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
 }
 
-static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	struct ath_txq *txq;
-	int i, npend = 0;
-
-	if (sc->sc_flags & SC_OP_INVALID)
-		return;
-
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (ATH_TXQ_SETUP(sc, i)) {
-			txq = &sc->tx.txq[i];
-			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
-			npend += ath9k_hw_numtxpending(ah, txq->axq_qnum);
-		}
-	}
-
-	if (npend) {
-		int r;
-
-		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
-
-		spin_lock_bh(&sc->sc_resetlock);
-		r = ath9k_hw_reset(ah, sc->sc_ah->ah_curchan, true);
-		if (r)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to reset hardware; reset status %u\n",
-				r);
-		spin_unlock_bh(&sc->sc_resetlock);
-	}
-
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (ATH_TXQ_SETUP(sc, i))
-			ath_tx_draintxq(sc, &sc->tx.txq[i], retry_tx);
-	}
-}
-
 static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 					  struct ath_txq *txq)
 {
@@ -1120,17 +1083,19 @@ int ath_cabq_update(struct ath_softc *sc)
 	return 0;
 }
 
-void ath_tx_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
+/*
+ * Drain a given TX queue (could be Beacon or Data)
+ *
+ * This assumes output has been stopped and
+ * we do not need to block ath_tx_tasklet.
+ */
+void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 {
 	struct ath_buf *bf, *lastbf;
 	struct list_head bf_head;
 
 	INIT_LIST_HEAD(&bf_head);
 
-	/*
-	 * NB: this assumes output has been stopped and
-	 *     we do not need to block ath_tx_tasklet
-	 */
 	for (;;) {
 		spin_lock_bh(&txq->axq_lock);
 
@@ -1180,18 +1145,51 @@ void ath_tx_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 	}
 }
 
-void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
+void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 {
-	ath9k_hw_releasetxqueue(sc->sc_ah, txq->axq_qnum);
-	sc->tx.txqsetup &= ~(1<<txq->axq_qnum);
+	struct ath_hal *ah = sc->sc_ah;
+	struct ath_txq *txq;
+	int i, npend = 0;
+
+	if (sc->sc_flags & SC_OP_INVALID)
+		return;
+
+	/* Stop beacon queue */
+	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+
+	/* Stop data queues */
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (ATH_TXQ_SETUP(sc, i)) {
+			txq = &sc->tx.txq[i];
+			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
+			npend += ath9k_hw_numtxpending(ah, txq->axq_qnum);
+		}
+	}
+
+	if (npend) {
+		int r;
+
+		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
+
+		spin_lock_bh(&sc->sc_resetlock);
+		r = ath9k_hw_reset(ah, sc->sc_ah->ah_curchan, true);
+		if (r)
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"Unable to reset hardware; reset status %u\n",
+				r);
+		spin_unlock_bh(&sc->sc_resetlock);
+	}
+
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (ATH_TXQ_SETUP(sc, i))
+			ath_draintxq(sc, &sc->tx.txq[i], retry_tx);
+	}
 }
 
-void ath_draintxq(struct ath_softc *sc, bool retry_tx)
+void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 {
-	if (!(sc->sc_flags & SC_OP_INVALID))
-		(void) ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-
-	ath_drain_txdataq(sc, retry_tx);
+	ath9k_hw_releasetxqueue(sc->sc_ah, txq->axq_qnum);
+	sc->tx.txqsetup &= ~(1<<txq->axq_qnum);
 }
 
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
-- 
1.6.0.3

