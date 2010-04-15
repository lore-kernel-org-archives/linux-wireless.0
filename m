Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab0DODay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:54 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 41/97] ath9k: Remove ATH9K_TX_SW_ABORTED and introduce a bool for this purpose
Date: Wed, 14 Apr 2010 23:29:55 -0400
Message-Id: <1271302251-9075-42-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/common.h |    1 +
 drivers/net/wireless/ath/ath9k/mac.h    |    1 -
 drivers/net/wireless/ath/ath9k/xmit.c   |    9 ++++-----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 1a87283..5fd7fe1 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -82,6 +82,7 @@ struct ath_buf {
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
 	bool bf_stale;
 	bool bf_isnullfunc;
+	bool bf_tx_aborted;
 	u16 bf_flags;
 	struct ath_buf_state bf_state;
 	dma_addr_t bf_dmacontext;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index f2f4ad2..99f81eb 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -86,7 +86,6 @@
 #define ATH9K_TX_DESC_CFG_ERR      0x04
 #define ATH9K_TX_DATA_UNDERRUN     0x08
 #define ATH9K_TX_DELIM_UNDERRUN    0x10
-#define ATH9K_TX_SW_ABORTED        0x40
 #define ATH9K_TX_SW_FILTERED       0x80
 
 /* 64 bytes */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4bc52f4..6ab2099 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -359,7 +359,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			acked_cnt++;
 		} else {
 			if (!(tid->state & AGGR_CLEANUP) &&
-			    ts->ts_flags != ATH9K_TX_SW_ABORTED) {
+			    !bf_last->bf_tx_aborted) {
 				if (bf->bf_retries < ATH_MAX_SW_RETRIES) {
 					ath_tx_set_retry(sc, txq, bf);
 					txpending = 1;
@@ -1036,9 +1036,6 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 	struct ath_tx_status ts;
 
 	memset(&ts, 0, sizeof(ts));
-	if (!retry_tx)
-		ts.ts_flags = ATH9K_TX_SW_ABORTED;
-
 	INIT_LIST_HEAD(&bf_head);
 
 	for (;;) {
@@ -1063,6 +1060,8 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 		}
 
 		lastbf = bf->bf_lastbf;
+		if (!retry_tx)
+			lastbf->bf_tx_aborted = true;
 
 		/* remove ath_buf's of the same mpdu from txq */
 		list_cut_position(&bf_head, &txq->axq_q, &lastbf->list);
@@ -1897,7 +1896,7 @@ static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
 	int nbad = 0;
 	int isaggr = 0;
 
-	if (ts->ts_flags == ATH9K_TX_SW_ABORTED)
+	if (bf->bf_tx_aborted)
 		return 0;
 
 	isaggr = bf_isaggr(bf);
-- 
1.6.3.3

