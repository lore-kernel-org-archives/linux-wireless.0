Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40958 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab1AXSMK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 13:12:10 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k: fix misplaced debug code
Date: Mon, 24 Jan 2011 19:11:54 +0100
Message-Id: <1295892714-985-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 'ath9k: Add more information to debugfs xmit file.' added more
debug counters to ath9k and also added some lines of code to ath9k_hw.

Since ath9k_hw is also used by ath9k_htc, its code must not depend on ath9k
data structures. In this case it was not fatal, but it's still wrong, so
the code needs to be moved back to ath9k.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/mac.c  |    8 --------
 drivers/net/wireless/ath/ath9k/xmit.c |    3 +++
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 5f2b934..c75d40f 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -16,8 +16,6 @@
 
 #include "hw.h"
 #include "hw-ops.h"
-#include "debug.h"
-#include "ath9k.h"
 
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
@@ -52,18 +50,12 @@ EXPORT_SYMBOL(ath9k_hw_gettxbuf);
 
 void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
 {
-	struct ath_wiphy *aphy = ah->hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	TX_STAT_INC(q, puttxbuf);
 	REG_WRITE(ah, AR_QTXDP(q), txdp);
 }
 EXPORT_SYMBOL(ath9k_hw_puttxbuf);
 
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
-	struct ath_wiphy *aphy = ah->hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	TX_STAT_INC(q, txstart);
 	ath_dbg(ath9k_hw_common(ah), ATH_DBG_QUEUE,
 		"Enable TXE on queue: %u\n", q);
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f98bf8f..adec862 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1318,6 +1318,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 		INIT_LIST_HEAD(&txq->txq_fifo[txq->txq_headidx]);
 		list_splice_init(head, &txq->txq_fifo[txq->txq_headidx]);
 		INCR(txq->txq_headidx, ATH_TXFIFO_DEPTH);
+		TX_STAT_INC(txq->axq_qnum, puttxbuf);
 		ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
 		ath_dbg(common, ATH_DBG_XMIT, "TXDP[%u] = %llx (%p)\n",
 			txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
@@ -1325,6 +1326,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 		list_splice_tail_init(head, &txq->axq_q);
 
 		if (txq->axq_link == NULL) {
+			TX_STAT_INC(txq->axq_qnum, puttxbuf);
 			ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
 			ath_dbg(common, ATH_DBG_XMIT, "TXDP[%u] = %llx (%p)\n",
 				txq->axq_qnum, ito64(bf->bf_daddr),
@@ -1338,6 +1340,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 		}
 		ath9k_hw_get_desc_link(ah, bf->bf_lastbf->bf_desc,
 				       &txq->axq_link);
+		TX_STAT_INC(txq->axq_qnum, txstart);
 		ath9k_hw_txstart(ah, txq->axq_qnum);
 	}
 	txq->axq_depth++;
-- 
1.7.3.2

