Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39913 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab1ASBaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 20:30:08 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Try more than one queue when scheduling new aggregate.
Date: Tue, 18 Jan 2011 17:30:00 -0800
Message-Id: <1295400600-20596-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Try all xmit queues until the hardware buffers are full.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 2ad732d... 5f05a3a... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/xmit.c |   64 +++++++++++++++++++--------------
 1 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2ad732d..5f05a3a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1222,49 +1222,59 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 	sc->tx.txqsetup &= ~(1<<txq->axq_qnum);
 }
 
+/* For each axq_acq entry, for each tid, try to schedule packets
+ * for transmit until ampdu_depth has reached min Q depth.
+ */
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
-	struct ath_atx_ac *ac;
-	struct ath_atx_tid *tid, *last;
+	struct ath_atx_ac *ac, *ac_tmp, *last_ac;
+	struct ath_atx_tid *tid, *last_tid;
 
 	if (list_empty(&txq->axq_acq) ||
 	    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
 		return;
 
 	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
-	last = list_entry(ac->tid_q.prev, struct ath_atx_tid, list);
-	list_del(&ac->list);
-	ac->sched = false;
+	last_ac = list_entry(txq->axq_acq.prev, struct ath_atx_ac, list);
 
-	do {
-		if (list_empty(&ac->tid_q))
-			return;
+	list_for_each_entry_safe(ac, ac_tmp, &txq->axq_acq, list) {
+		last_tid = list_entry(ac->tid_q.prev, struct ath_atx_tid, list);
+		list_del(&ac->list);
+		ac->sched = false;
 
-		tid = list_first_entry(&ac->tid_q, struct ath_atx_tid, list);
-		list_del(&tid->list);
-		tid->sched = false;
+		while (!list_empty(&ac->tid_q)) {
+			tid = list_first_entry(&ac->tid_q, struct ath_atx_tid,
+					       list);
+			list_del(&tid->list);
+			tid->sched = false;
 
-		if (tid->paused)
-			continue;
+			if (tid->paused)
+				continue;
 
-		ath_tx_sched_aggr(sc, txq, tid);
+			ath_tx_sched_aggr(sc, txq, tid);
 
-		/*
-		 * add tid to round-robin queue if more frames
-		 * are pending for the tid
-		 */
-		if (!list_empty(&tid->buf_q))
-			ath_tx_queue_tid(txq, tid);
+			/*
+			 * add tid to round-robin queue if more frames
+			 * are pending for the tid
+			 */
+			if (!list_empty(&tid->buf_q))
+				ath_tx_queue_tid(txq, tid);
 
-		if (tid == last || txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
-			break;
-	} while (!list_empty(&ac->tid_q));
+			if (tid == last_tid ||
+			    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
+				break;
+		}
 
-	if (!list_empty(&ac->tid_q)) {
-		if (!ac->sched) {
-			ac->sched = true;
-			list_add_tail(&ac->list, &txq->axq_acq);
+		if (!list_empty(&ac->tid_q)) {
+			if (!ac->sched) {
+				ac->sched = true;
+				list_add_tail(&ac->list, &txq->axq_acq);
+			}
 		}
+
+		if (ac == last_ac ||
+		    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
+			return;
 	}
 }
 
-- 
1.7.2.3

