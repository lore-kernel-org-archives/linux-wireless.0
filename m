Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58487 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab1AJHMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 02:12:21 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH RESEND 10/11] ath9k: Restart xmit logic in xmit watchdog.
Date: Sun,  9 Jan 2011 23:11:52 -0800
Message-Id: <1294643513-18820-11-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
References: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The system can get into a state where the xmit queue
is stopped, but there are no packets pending, so
the queue will not be restarted.

Add logic to the xmit watchdog to attempt to restart
the xmit logic if this situation is detected.

Example 'dmesg' output:

ath: txq: f4e723e0 axq_qnum: 2, mac80211_qnum: 2 axq_link: f4e996c8 pending frames: 1 axq_acq empty: 1 stopped: 0 axq_depth: 0  Attempting to restart tx logic.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 3f5c513... 3108699... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 9e009cc... b0cb792... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 59c01ca... 5279653... M	drivers/net/wireless/ath/ath9k/init.c
:100644 100644 46481fb... 8631afb... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/ath9k.h |    9 +++-
 drivers/net/wireless/ath/ath9k/debug.c |    4 +-
 drivers/net/wireless/ath/ath9k/init.c  |    5 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |   79 ++++++++++++++++++++++----------
 4 files changed, 68 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3f5c513..3108699 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -184,7 +184,8 @@ enum ATH_AGGR_STATUS {
 
 #define ATH_TXFIFO_DEPTH 8
 struct ath_txq {
-	u32 axq_qnum;
+	int mac80211_qnum; /* mac80211 queue number, -1 means not mac80211 Q */
+	u32 axq_qnum; /* ath9k hardware queue number */
 	u32 *axq_link;
 	struct list_head axq_q;
 	spinlock_t axq_lock;
@@ -280,6 +281,11 @@ struct ath_tx_control {
 #define ATH_TX_XRETRY       0x02
 #define ATH_TX_BAR          0x04
 
+/**
+ * @txq_map:  Index is mac80211 queue number.  This is
+ *  not necessarily the same as the hardware queue number
+ *  (axq_qnum).
+ */
 struct ath_tx {
 	u16 seq_no;
 	u32 txqsetup;
@@ -629,6 +635,7 @@ struct ath_softc {
 	struct ath9k_debug debug;
 	spinlock_t nodes_lock;
 	struct list_head nodes; /* basically, stations */
+	unsigned int tx_complete_poll_work_seen;
 #endif
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9e009cc..b0cb792 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -629,9 +629,11 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	len += sprintf(buf, "Num-Tx-Queues: %i  tx-queues-setup: 0x%x\n"
+	len += sprintf(buf, "Num-Tx-Queues: %i  tx-queues-setup: 0x%x"
+		       " poll-work-seen: %u\n"
 		       "%30s %10s%10s%10s\n\n",
 		       ATH9K_NUM_TX_QUEUES, sc->tx.txqsetup,
+		       sc->tx_complete_poll_work_seen,
 		       "BE", "BK", "VI", "VO");
 
 	PR("MPDUs Queued:    ", queued);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 59c01ca..5279653 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -442,9 +442,10 @@ static int ath9k_init_queues(struct ath_softc *sc)
 	sc->config.cabqReadytime = ATH_CABQ_READY_TIME;
 	ath_cabq_update(sc);
 
-	for (i = 0; i < WME_NUM_AC; i++)
+	for (i = 0; i < WME_NUM_AC; i++) {
 		sc->tx.txq_map[i] = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, i);
-
+		sc->tx.txq_map[i]->mac80211_qnum = i;
+	}
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 46481fb..8631afb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -953,7 +953,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		[WME_AC_VI] = ATH_TXQ_AC_VI,
 		[WME_AC_VO] = ATH_TXQ_AC_VO,
 	};
-	int qnum, i;
+	int axq_qnum, i;
 
 	memset(&qi, 0, sizeof(qi));
 	qi.tqi_subtype = subtype_txq_to_hwq[subtype];
@@ -987,24 +987,25 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 			qi.tqi_qflags = TXQ_FLAG_TXEOLINT_ENABLE |
 					TXQ_FLAG_TXDESCINT_ENABLE;
 	}
-	qnum = ath9k_hw_setuptxqueue(ah, qtype, &qi);
-	if (qnum == -1) {
+	axq_qnum = ath9k_hw_setuptxqueue(ah, qtype, &qi);
+	if (axq_qnum == -1) {
 		/*
 		 * NB: don't print a message, this happens
 		 * normally on parts with too few tx queues
 		 */
 		return NULL;
 	}
-	if (qnum >= ARRAY_SIZE(sc->tx.txq)) {
+	if (axq_qnum >= ARRAY_SIZE(sc->tx.txq)) {
 		ath_err(common, "qnum %u out of range, max %zu!\n",
-			qnum, ARRAY_SIZE(sc->tx.txq));
-		ath9k_hw_releasetxqueue(ah, qnum);
+			axq_qnum, ARRAY_SIZE(sc->tx.txq));
+		ath9k_hw_releasetxqueue(ah, axq_qnum);
 		return NULL;
 	}
-	if (!ATH_TXQ_SETUP(sc, qnum)) {
-		struct ath_txq *txq = &sc->tx.txq[qnum];
+	if (!ATH_TXQ_SETUP(sc, axq_qnum)) {
+		struct ath_txq *txq = &sc->tx.txq[axq_qnum];
 
-		txq->axq_qnum = qnum;
+		txq->axq_qnum = axq_qnum;
+		txq->mac80211_qnum = -1;
 		txq->axq_link = NULL;
 		INIT_LIST_HEAD(&txq->axq_q);
 		INIT_LIST_HEAD(&txq->axq_acq);
@@ -1012,14 +1013,14 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_depth = 0;
 		txq->axq_ampdu_depth = 0;
 		txq->axq_tx_inprogress = false;
-		sc->tx.txqsetup |= 1<<qnum;
+		sc->tx.txqsetup |= 1<<axq_qnum;
 
 		txq->txq_headidx = txq->txq_tailidx = 0;
 		for (i = 0; i < ATH_TXFIFO_DEPTH; i++)
 			INIT_LIST_HEAD(&txq->txq_fifo[i]);
 		INIT_LIST_HEAD(&txq->txq_fifo_pending);
 	}
-	return &sc->tx.txq[qnum];
+	return &sc->tx.txq[axq_qnum];
 }
 
 int ath_txq_update(struct ath_softc *sc, int qnum,
@@ -1988,17 +1989,16 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
-static void ath_wake_mac80211_queue(struct ath_softc *sc, int qnum)
+/* Has no locking.  Must hold spin_lock_bh(&txq->axq_lock)
+ * before calling this.
+ */
+static void __ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
 {
-	struct ath_txq *txq;
-
-	txq = sc->tx.txq_map[qnum];
-	spin_lock_bh(&txq->axq_lock);
-	if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
-		if (ath_mac80211_start_queue(sc, qnum))
+	if (txq->mac80211_qnum >= 0 &&
+	    txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
+		if (ath_mac80211_start_queue(sc, txq->mac80211_qnum))
 			txq->stopped = 0;
 	}
-	spin_unlock_bh(&txq->axq_lock);
 }
 
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
@@ -2101,10 +2101,9 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		else
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, txok, 0);
 
-		if (txq == sc->tx.txq_map[qnum])
-			ath_wake_mac80211_queue(sc, qnum);
-
 		spin_lock_bh(&txq->axq_lock);
+		__ath_wake_mac80211_queue(sc, txq);
+
 		if (sc->sc_flags & SC_OP_TXAGGR)
 			ath_txq_schedule(sc, txq);
 		spin_unlock_bh(&txq->axq_lock);
@@ -2118,6 +2117,9 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	struct ath_txq *txq;
 	int i;
 	bool needreset = false;
+#ifdef CONFIG_ATH9K_DEBUGFS
+	sc->tx_complete_poll_work_seen++;
+#endif
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i)) {
@@ -2131,6 +2133,34 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 				} else {
 					txq->axq_tx_inprogress = true;
 				}
+			} else {
+				/* If the queue has pending buffers, then it
+				 * should be doing tx work (and have axq_depth).
+				 * Shouldn't get to this state I think..but
+				 * we do.
+				 */
+				if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)) &&
+				    (txq->pending_frames > 0 ||
+				     !list_empty(&txq->axq_acq) ||
+				     txq->stopped)) {
+					ath_err(ath9k_hw_common(sc->sc_ah),
+						"txq: %p axq_qnum: %u,"
+						" mac80211_qnum: %i"
+						" axq_link: %p"
+						" pending frames: %i"
+						" axq_acq empty: %i"
+						" stopped: %i"
+						" axq_depth: 0  Attempting to"
+						" restart tx logic.\n",
+						txq, txq->axq_qnum,
+						txq->mac80211_qnum,
+						txq->axq_link,
+						txq->pending_frames,
+						list_empty(&txq->axq_acq),
+						txq->stopped);
+					__ath_wake_mac80211_queue(sc, txq);
+					ath_txq_schedule(sc, txq);
+				}
 			}
 			spin_unlock_bh(&txq->axq_lock);
 		}
@@ -2227,10 +2257,9 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			ath_tx_complete_buf(sc, bf, txq, &bf_head,
 					    &txs, txok, 0);
 
-		if (txq == sc->tx.txq_map[qnum])
-			ath_wake_mac80211_queue(sc, qnum);
-
 		spin_lock_bh(&txq->axq_lock);
+		__ath_wake_mac80211_queue(sc, txq);
+
 		if (!list_empty(&txq->txq_fifo_pending)) {
 			INIT_LIST_HEAD(&bf_head);
 			bf = list_first_entry(&txq->txq_fifo_pending,
-- 
1.7.2.3

