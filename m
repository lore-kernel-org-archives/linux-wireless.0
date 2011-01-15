Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34642 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1AONaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 08:30:22 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 1/2] ath9k: try more than one tid when scheduling a new aggregate
Date: Sat, 15 Jan 2011 14:30:14 +0100
Message-Id: <1295098215-98910-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the first TID in the first AC's list is not available for forming
a new aggregate (the BAW might not allow it), however other TIDs may have
data available for sending.
Prevent a slowdown of other TIDs by going through multiple entries until
we've either hit the last one or enough AMPDUs are pending in the hardware
queue.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ab4f7b4..fffd13d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1224,12 +1224,14 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_atx_ac *ac;
-	struct ath_atx_tid *tid;
+	struct ath_atx_tid *tid, *last;
 
-	if (list_empty(&txq->axq_acq))
+	if (list_empty(&txq->axq_acq) ||
+	    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
 		return;
 
 	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
+	last = list_entry(ac->tid_q.prev, struct ath_atx_tid, list);
 	list_del(&ac->list);
 	ac->sched = false;
 
@@ -1253,7 +1255,8 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		if (!list_empty(&tid->buf_q))
 			ath_tx_queue_tid(txq, tid);
 
-		break;
+		if (tid == last || txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
+			break;
 	} while (!list_empty(&ac->tid_q));
 
 	if (!list_empty(&ac->tid_q)) {
-- 
1.7.3.2

