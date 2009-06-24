Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21386 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756955AbZFXN1C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 09:27:02 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2009 06:27:05 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 3/7] ath9k: Fix TX hang issue with Atheros chipsets
Date: Wed, 24 Jun 2009 18:56:38 +0530
Message-ID: <1245850002-26351-4-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1245850002-26351-3-git-send-email-senthilkumar@atheros.com>
References: <1245850002-26351-1-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-2-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-3-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 6fa72b8..a86e384 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -230,6 +230,8 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_DS_TX_BA(_ds)          ((_ds)->ds_us.tx.ts_flags & ATH9K_TX_BA)
 #define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
 
+#define ATH_TX_COMPLETE_POLL_INT	1000
+
 enum ATH_AGGR_STATUS {
 	ATH_AGGR_DONE,
 	ATH_AGGR_BAW_CLOSED,
@@ -245,6 +247,7 @@ struct ath_txq {
 	u8 axq_aggr_depth;
 	u32 axq_totalqueued;
 	bool stopped;
+	bool axq_tx_inprogress;
 	struct ath_buf *axq_linkbuf;
 
 	/* first desc of the last descriptor that contains CTS */
@@ -609,6 +612,7 @@ struct ath_softc {
 #endif
 	struct ath_bus_ops *bus_ops;
 	struct ath_beacon_config cur_beacon_conf;
+	struct delayed_work tx_complete_work;
 };
 
 struct ath_wiphy {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f2bbc28..66d2190 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1256,6 +1256,7 @@ void ath_detach(struct ath_softc *sc)
 	ath_deinit_leds(sc);
 	cancel_work_sync(&sc->chan_work);
 	cancel_delayed_work_sync(&sc->wiphy_work);
+	cancel_delayed_work_sync(&sc->tx_complete_work);
 
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
@@ -1974,6 +1975,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ieee80211_wake_queues(hw);
 
+	queue_delayed_work(sc->hw->workqueue, &sc->tx_complete_work, 0);
+
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c140f81..6b32b40 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -850,6 +850,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_aggr_depth = 0;
 		txq->axq_totalqueued = 0;
 		txq->axq_linkbuf = NULL;
+		txq->axq_tx_inprogress = false;
 		sc->tx.txqsetup |= 1<<qnum;
 	}
 	return &sc->tx.txq[qnum];
@@ -1016,6 +1017,10 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 			ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
 	}
 
+	spin_lock_bh(&txq->axq_lock);
+	txq->axq_tx_inprogress = false;
+	spin_unlock_bh(&txq->axq_lock);
+
 	/* flush any pending frames if aggregation is enabled */
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		if (!retry_tx) {
@@ -1096,8 +1101,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		if (tid->paused)
 			continue;
 
-		if ((txq->axq_depth % 2) == 0)
-			ath_tx_sched_aggr(sc, txq, tid);
+		ath_tx_sched_aggr(sc, txq, tid);
 
 		/*
 		 * add tid to round-robin queue if more frames
@@ -1940,19 +1944,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
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
@@ -1989,6 +1981,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			txq->axq_aggr_depth--;
 
 		txok = (ds->ds_txstat.ts_status == 0);
+		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
 
 		if (bf_held) {
@@ -2022,6 +2015,40 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
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
@@ -2062,6 +2089,8 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 		goto err;
 	}
 
+	INIT_DELAYED_WORK(&sc->tx_complete_work, ath_tx_complete_poll_work);
+
 err:
 	if (error != 0)
 		ath_tx_cleanup(sc);
-- 
1.6.0.4

