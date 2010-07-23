Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:54955 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631Ab0GWBxV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 21:53:21 -0400
Message-ID: <4C48F60C.5020808@openwrt.org>
Date: Fri, 23 Jul 2010 03:53:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix yet another buffer leak in the tx aggregation
 code
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an aggregation session is being cleaned up, while the tx status
for some frames is being processed, the TID is flushed and its buffers
are sent out.

Unfortunately that left the pending un-acked frames unprocessed, thus
leaking buffers. Fix this by reordering the code so that those frames
are processed first, before the TID is flushed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -518,6 +518,14 @@ static void ath_tx_complete_aggr(struct 
 		bf = bf_next;
 	}
 
+	/* prepend un-acked frames to the beginning of the pending frame queue */
+	if (!list_empty(&bf_pending)) {
+		spin_lock_bh(&txq->axq_lock);
+		list_splice(&bf_pending, &tid->buf_q);
+		ath_tx_queue_tid(txq, tid);
+		spin_unlock_bh(&txq->axq_lock);
+	}
+
 	if (tid->state & AGGR_CLEANUP) {
 		if (tid->baw_head == tid->baw_tail) {
 			tid->state &= ~AGGR_ADDBA_COMPLETE;
@@ -530,14 +538,6 @@ static void ath_tx_complete_aggr(struct 
 		return;
 	}
 
-	/* prepend un-acked frames to the beginning of the pending frame queue */
-	if (!list_empty(&bf_pending)) {
-		spin_lock_bh(&txq->axq_lock);
-		list_splice(&bf_pending, &tid->buf_q);
-		ath_tx_queue_tid(txq, tid);
-		spin_unlock_bh(&txq->axq_lock);
-	}
-
 	rcu_read_unlock();
 
 	if (needreset)
