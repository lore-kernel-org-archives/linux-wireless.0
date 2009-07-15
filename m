Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbZGOARP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:17:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 3/9] ath9k: Fix TX hang issue with Atheros chipsets
Date: Tue, 14 Jul 2009 20:17:09 -0400
Message-Id: <1247617035-15402-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
References: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

The hardware doesn't generate interrupts in some cases and so work
around this by monitoring the TX status periodically and reset the
chip if required.

This behavior of the hardware not generating the TX interrupts can
be noticed through ath9k debugfs interrupt statistics when heavy
traffic is being sent from STA to AP. One can easily see this behavior
when the STA is transmitting at a higher rates. The interrupt statistics
in the debugfs interface clearly shows that only RX interrupts alone
being generated and TX being stuck.

TX should be monitored through a timer and reset the chip only when
frames are queued to the hardware but TX interrupts are not generated
for the same even after one second. Also, we shouldn't remove holding
descriptor from AC queue if it happens to be the only descriptor and
schedule TX aggregation regarless of queue depth as it improves
scheduling of AMPDUs from software to hardware queue.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++
 drivers/net/wireless/ath/ath9k/main.c  |    3 ++
 drivers/net/wireless/ath/ath9k/xmit.c  |   57 ++++++++++++++++++++++++--------
 3 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 544599b..20bf4a7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -225,6 +225,8 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_DS_TX_BA(_ds)          ((_ds)->ds_us.tx.ts_flags & ATH9K_TX_BA)
 #define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
 
+#define ATH_TX_COMPLETE_POLL_INT	1000
+
 enum ATH_AGGR_STATUS {
 	ATH_AGGR_DONE,
 	ATH_AGGR_BAW_CLOSED,
@@ -240,6 +242,7 @@ struct ath_txq {
 	u8 axq_aggr_depth;
 	u32 axq_totalqueued;
 	bool stopped;
+	bool axq_tx_inprogress;
 	struct ath_buf *axq_linkbuf;
 
 	/* first desc of the last descriptor that contains CTS */
@@ -605,6 +608,7 @@ struct ath_softc {
 #endif
 	struct ath_bus_ops *bus_ops;
 	struct ath_beacon_config cur_beacon_conf;
+	struct delayed_work tx_complete_work;
 };
 
 struct ath_wiphy {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2ad7184..46f4a69 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1259,6 +1259,7 @@ void ath_detach(struct ath_softc *sc)
 	ath_deinit_leds(sc);
 	cancel_work_sync(&sc->chan_work);
 	cancel_delayed_work_sync(&sc->wiphy_work);
+	cancel_delayed_work_sync(&sc->tx_complete_work);
 
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
@@ -1979,6 +1980,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ieee80211_wake_queues(hw);
 
+	queue_delayed_work(sc->hw->workqueue, &sc->tx_complete_work, 0);
+
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5de9878..a3bc431 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -857,6 +857,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_aggr_depth = 0;
 		txq->axq_totalqueued = 0;
 		txq->axq_linkbuf = NULL;
+		txq->axq_tx_inprogress = false;
 		sc->tx.txqsetup |= 1<<qnum;
 	}
 	return &sc->tx.txq[qnum];
@@ -1023,6 +1024,10 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 			ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
 	}
 
+	spin_lock_bh(&txq->axq_lock);
+	txq->axq_tx_inprogress = false;
+	spin_unlock_bh(&txq->axq_lock);
+
 	/* flush any pending frames if aggregation is enabled */
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		if (!retry_tx) {
@@ -1103,8 +1108,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		if (tid->paused)
 			continue;
 
-		if ((txq->axq_depth % 2) == 0)
-			ath_tx_sched_aggr(sc, txq, tid);
+		ath_tx_sched_aggr(sc, txq, tid);
 
 		/*
 		 * add tid to round-robin queue if more frames
@@ -1947,19 +1951,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		if (bf->bf_stale) {
 			bf_held = bf;
 			if (list_is_last(&bf_held->list, &txq->axq_q)) {
-				txq->axq_link = NULL;
-				txq->axq_linkbuf = NULL;
 				spin_unlock_bh(&txq->axq_lock);
-
-				/*
-				 * The holding descriptor is the last
-				 * descriptor in queue. It's safe to remove
-				 * the last holding descriptor in BH context.
-				 */
-				spin_lock_bh(&sc->tx.txbuflock);
-				list_move_tail(&bf_held->list, &sc->tx.txbuf);
-				spin_unlock_bh(&sc->tx.txbuflock);
-
 				break;
 			} else {
 				bf = list_entry(bf_held->list.next,
@@ -1996,6 +1988,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			txq->axq_aggr_depth--;
 
 		txok = (ds->ds_txstat.ts_status == 0);
+		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
 
 		if (bf_held) {
@@ -2029,6 +2022,40 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	}
 }
 
+void ath_tx_complete_poll_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+			tx_complete_work.work);
+	struct ath_txq *txq;
+	int i;
+	bool needreset = false;
+
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
+		if (ATH_TXQ_SETUP(sc, i)) {
+			txq = &sc->tx.txq[i];
+			spin_lock_bh(&txq->axq_lock);
+			if (txq->axq_depth) {
+				if (txq->axq_tx_inprogress) {
+					needreset = true;
+					spin_unlock_bh(&txq->axq_lock);
+					break;
+				} else {
+					txq->axq_tx_inprogress = true;
+				}
+			}
+			spin_unlock_bh(&txq->axq_lock);
+		}
+
+	if (needreset) {
+		DPRINTF(sc, ATH_DBG_RESET, "tx hung, resetting the chip\n");
+		ath_reset(sc, false);
+	}
+
+	queue_delayed_work(sc->hw->workqueue, &sc->tx_complete_work,
+			msecs_to_jiffies(ATH_TX_COMPLETE_POLL_INT));
+}
+
+
 
 void ath_tx_tasklet(struct ath_softc *sc)
 {
@@ -2069,6 +2096,8 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 		goto err;
 	}
 
+	INIT_DELAYED_WORK(&sc->tx_complete_work, ath_tx_complete_poll_work);
+
 err:
 	if (error != 0)
 		ath_tx_cleanup(sc);
-- 
1.6.0.6

