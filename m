Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41018 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1KTFa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 00:30:59 -0500
Received: by ghbz2 with SMTP id z2so1829969ghb.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 21:30:59 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, kolya <mar.kolya@gmail.com>
Subject: [PATCH v2] ath9k: Improve ath_tx_aggr_stop to avoid TID stuck in cleanup state.
Date: Sun, 20 Nov 2011 00:30:35 -0500
Message-Id: <1321767035-3263-1-git-send-email-mar.kolya@gmail.com> (sfid-20111120_063106_844821_374E87EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: kolya <mar.kolya@gmail.com>

  When tx agg is being stopped TID is flushed using ath_tx_flush_tid. It is possible that ath_tx_flush_tid completelly flushes TID (if all packets in this TID have already been retried). If this happened ath_tx_aggr_stop would leave TID in cleanup state permanently. Fix this by making ath_tx_flush_tid remove AGGR_ADDBA_COMPLETE and AGGR_CLEANUP flags from TID status if TID is empty.
---
 drivers/net/wireless/ath/ath9k/xmit.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 55d077e..80639e3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -179,6 +179,11 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		spin_lock_bh(&txq->axq_lock);
 	}
 
+	if (tid->baw_head == tid->baw_tail) {
+		tid->state &= ~AGGR_ADDBA_COMPLETE;
+		tid->state &= ~AGGR_CLEANUP;
+	}
+
 	spin_unlock_bh(&txq->axq_lock);
 }
 
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

