Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51545 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1KUWcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 17:32:32 -0500
Received: by qadc14 with SMTP id c14so700736qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 14:32:32 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v3] ath9k: improve ath_tx_aggr_stop to avoid TID stuck in cleanup state
Date: Mon, 21 Nov 2011 17:32:06 -0500
Message-Id: <1321914726-15781-1-git-send-email-mar.kolya@gmail.com> (sfid-20111121_233236_432726_D2E523FD)
In-Reply-To: <1321684883-6870-1-git-send-email-mar.kolya@gmail.com>
References: <1321684883-6870-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When tx agg is being stopped TID is flushed using ath_tx_flush_tid. It
is possible that ath_tx_flush_tid completelly flushes TID (if all
packets in this TID have already been retried). If this happened
ath_tx_aggr_stop would leave TID in cleanup state permanently.
Fix this by making ath_tx_flush_tid remove AGGR_ADDBA_COMPLETE and
AGGR_CLEANUP flags from TID status if TID is empty.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
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

