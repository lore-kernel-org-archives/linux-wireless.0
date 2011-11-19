Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50348 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1KSGlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 01:41:55 -0500
Received: by ywt32 with SMTP id 32so3224493ywt.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 22:41:54 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, kolya <mar.kolya@gmail.com>
Subject: [PATCH] ath9k: Improve ath_tx_aggr_stop to avoid TID stuck in cleanup state.
Date: Sat, 19 Nov 2011 01:41:23 -0500
Message-Id: <1321684883-6870-1-git-send-email-mar.kolya@gmail.com> (sfid-20111119_074215_032103_73C58851)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: kolya <mar.kolya@gmail.com>

  When tx agg is being stopped TID is flushed using ath_tx_flush_tid. It is possible that ath_tx_flush_tid completelly flushes TID (if all packets in this TID have already been retried). If this happened ath_tx_aggr_stop would leave TID in cleanup state permanently. Fix this by making ath_tx_flush_tid remove AGGR_ADDBA_COMPLETE and AGGR_CLEANUP flags from TID status if TID is empty.
---
 drivers/net/wireless/ath/ath9k/xmit.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 55d077e..3574b0f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -180,6 +180,11 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	}
 
 	spin_unlock_bh(&txq->axq_lock);
+
+	if (tid->baw_head == tid->baw_tail) {
+		tid->state &= ~AGGR_ADDBA_COMPLETE;
+		tid->state &= ~AGGR_CLEANUP;
+	}
 }
 
 static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
@@ -556,15 +561,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		spin_unlock_bh(&txq->axq_lock);
 	}
 
-	if (tid->state & AGGR_CLEANUP) {
+	if (tid->state & AGGR_CLEANUP)
 		ath_tx_flush_tid(sc, tid);
 
-		if (tid->baw_head == tid->baw_tail) {
-			tid->state &= ~AGGR_ADDBA_COMPLETE;
-			tid->state &= ~AGGR_CLEANUP;
-		}
-	}
-
 	rcu_read_unlock();
 
 	if (needreset) {
-- 
1.7.4.1

