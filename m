Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48127 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab0GGRmU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 13:42:20 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/2] ath9k: fix a potential buffer leak in the STA teardown path
Date: Wed,  7 Jul 2010 19:42:08 +0200
Message-Id: <1278524529-30246-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like it might be possible for a TID to be paused, while still
holding some queued buffers, however ath_tx_node_cleanup currently only
iterates over active TIDs.
Fix this by always checking every allocated TID for the STA that is being
cleaned up.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/xmit.c |   52 ++++++++++++++++----------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c3681a1..408d1c5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2430,37 +2430,37 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 {
-	int i;
-	struct ath_atx_ac *ac, *ac_tmp;
-	struct ath_atx_tid *tid, *tid_tmp;
+	struct ath_atx_ac *ac;
+	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
+	int i, tidno;
 
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (ATH_TXQ_SETUP(sc, i)) {
-			txq = &sc->tx.txq[i];
+	for (tidno = 0, tid = &an->tid[tidno];
+	     tidno < WME_NUM_TID; tidno++, tid++) {
+		i = tid->ac->qnum;
 
-			spin_lock_bh(&txq->axq_lock);
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
 
-			list_for_each_entry_safe(ac,
-					ac_tmp, &txq->axq_acq, list) {
-				tid = list_first_entry(&ac->tid_q,
-						struct ath_atx_tid, list);
-				if (tid && tid->an != an)
-					continue;
-				list_del(&ac->list);
-				ac->sched = false;
-
-				list_for_each_entry_safe(tid,
-						tid_tmp, &ac->tid_q, list) {
-					list_del(&tid->list);
-					tid->sched = false;
-					ath_tid_drain(sc, txq, tid);
-					tid->state &= ~AGGR_ADDBA_COMPLETE;
-					tid->state &= ~AGGR_CLEANUP;
-				}
-			}
+		txq = &sc->tx.txq[i];
+		ac = tid->ac;
 
-			spin_unlock_bh(&txq->axq_lock);
+		spin_lock_bh(&txq->axq_lock);
+
+		if (tid->sched) {
+			list_del(&tid->list);
+			tid->sched = false;
+		}
+
+		if (ac->sched) {
+			list_del(&ac->list);
+			tid->ac->sched = false;
 		}
+
+		ath_tid_drain(sc, txq, tid);
+		tid->state &= ~AGGR_ADDBA_COMPLETE;
+		tid->state &= ~AGGR_CLEANUP;
+
+		spin_unlock_bh(&txq->axq_lock);
 	}
 }
-- 
1.6.4.2

