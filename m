Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab2BMKZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:25:09 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 21/24] iwlegacy: small queue initializations cleanup
Date: Mon, 13 Feb 2012 11:23:28 +0100
Message-Id: <1329128611-6815-22-git-send-email-sgruszka@redhat.com> (sfid-20120213_112513_622528_7C06A9AC)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c     |    9 +---
 drivers/net/wireless/iwlegacy/4965-mac.c |   18 ++------
 drivers/net/wireless/iwlegacy/common.c   |   66 ++++++++++++++++-------------
 drivers/net/wireless/iwlegacy/common.h   |   20 ++++-----
 4 files changed, 52 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 103251d..8900e3c 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -790,7 +790,6 @@ il3945_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 static int
 il3945_tx_reset(struct il_priv *il)
 {
-
 	/* bypass mode */
 	il_wr_prph(il, ALM_SCD_MODE_REG, 0x2);
 
@@ -827,8 +826,7 @@ il3945_tx_reset(struct il_priv *il)
 static int
 il3945_txq_ctx_reset(struct il_priv *il)
 {
-	int rc;
-	int txq_id, slots_num;
+	int rc, txq_id;
 
 	il3945_hw_txq_ctx_free(il);
 
@@ -844,10 +842,7 @@ il3945_txq_ctx_reset(struct il_priv *il)
 
 	/* Tx queue(s) */
 	for (txq_id = 0; txq_id < il->hw_params.max_txq_num; txq_id++) {
-		slots_num =
-		    (txq_id ==
-		     IL39_CMD_QUEUE_NUM) ? TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		rc = il_tx_queue_init(il, &il->txq[txq_id], slots_num, txq_id);
+		rc = il_tx_queue_init(il, txq_id);
 		if (rc) {
 			IL_ERR("Tx %d queue init failed\n", txq_id);
 			goto error;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index cf14861..a0158e3 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1952,8 +1952,7 @@ il4965_hw_txq_ctx_free(struct il_priv *il)
 int
 il4965_txq_ctx_alloc(struct il_priv *il)
 {
-	int ret;
-	int txq_id, slots_num;
+	int ret, txq_id;
 	unsigned long flags;
 
 	/* Free all tx/cmd queues and keep-warm buffer */
@@ -1990,10 +1989,7 @@ il4965_txq_ctx_alloc(struct il_priv *il)
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < il->hw_params.max_txq_num; txq_id++) {
-		slots_num =
-		    (txq_id ==
-		     il->cmd_queue) ? TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = il_tx_queue_init(il, &il->txq[txq_id], slots_num, txq_id);
+		ret = il_tx_queue_init(il, txq_id);
 		if (ret) {
 			IL_ERR("Tx %d queue init failed\n", txq_id);
 			goto error;
@@ -2014,25 +2010,21 @@ error_bc_tbls:
 void
 il4965_txq_ctx_reset(struct il_priv *il)
 {
-	int txq_id, slots_num;
+	int txq_id;
 	unsigned long flags;
 
 	spin_lock_irqsave(&il->lock, flags);
 
 	/* Turn off all Tx DMA fifos */
 	il4965_txq_set_sched(il, 0);
-
 	/* Tell NIC where to find the "keep warm" buffer */
 	il_wr(il, FH49_KW_MEM_ADDR_REG, il->kw.dma >> 4);
 
 	spin_unlock_irqrestore(&il->lock, flags);
 
 	/* Alloc and init all Tx queues, including the command queue (#4) */
-	for (txq_id = 0; txq_id < il->hw_params.max_txq_num; txq_id++) {
-		slots_num =
-		    txq_id == il->cmd_queue ? TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		il_tx_queue_reset(il, &il->txq[txq_id], slots_num, txq_id);
-	}
+	for (txq_id = 0; txq_id < il->hw_params.max_txq_num; txq_id++)
+		il_tx_queue_reset(il, txq_id);
 }
 
 void
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index d0d408e..872302a 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -2887,20 +2887,22 @@ EXPORT_SYMBOL(il_queue_space);
  * il_queue_init - Initialize queue's high/low-water and read/write idxes
  */
 static int
-il_queue_init(struct il_priv *il, struct il_queue *q, int count, int slots_num,
-	      u32 id)
+il_queue_init(struct il_priv *il, struct il_queue *q, int slots, u32 id)
 {
-	q->n_bd = count;
-	q->n_win = slots_num;
-	q->id = id;
+	/*
+	 * TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
+	 * il_queue_inc_wrap and il_queue_dec_wrap are broken.
+	 */
+	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
+	/* FIXME: remove q->n_bd */
+	q->n_bd = TFD_QUEUE_SIZE_MAX;
 
-	/* count must be power-of-two size, otherwise il_queue_inc_wrap
-	 * and il_queue_dec_wrap are broken. */
-	BUG_ON(!is_power_of_2(count));
+	q->n_win = slots;
+	q->id = id;
 
-	/* slots_num must be power-of-two size, otherwise
+	/* slots_must be power-of-two size, otherwise
 	 * il_get_cmd_idx is broken. */
-	BUG_ON(!is_power_of_2(slots_num));
+	BUG_ON(!is_power_of_2(slots));
 
 	q->low_mark = q->n_win / 4;
 	if (q->low_mark < 4)
@@ -2959,12 +2961,11 @@ error:
  * il_tx_queue_init - Allocate and initialize one tx/cmd queue
  */
 int
-il_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
-		 u32 txq_id)
+il_tx_queue_init(struct il_priv *il, u32 txq_id)
 {
-	int i, len;
-	int ret;
-	int actual_slots = slots_num;
+	int i, len, ret;
+	int slots, actual_slots;
+	struct il_tx_queue *txq = &il->txq[txq_id];
 
 	/*
 	 * Alloc buffer array for commands (Tx or other types of commands).
@@ -2974,8 +2975,13 @@ il_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
 	 * For normal Tx queues (all other queues), no super-size command
 	 * space is needed.
 	 */
-	if (txq_id == il->cmd_queue)
-		actual_slots++;
+	if (txq_id == il->cmd_queue) {
+		slots = TFD_CMD_SLOTS;
+		actual_slots = slots + 1;
+	} else {
+		slots = TFD_TX_CMD_SLOTS;
+		actual_slots = slots;
+	}
 
 	txq->meta =
 	    kzalloc(sizeof(struct il_cmd_meta) * actual_slots, GFP_KERNEL);
@@ -2988,7 +2994,7 @@ il_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
 	len = sizeof(struct il_device_cmd);
 	for (i = 0; i < actual_slots; i++) {
 		/* only happens for cmd queue */
-		if (i == slots_num)
+		if (i == slots)
 			len = IL_MAX_CMD_SIZE;
 
 		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
@@ -3011,12 +3017,8 @@ il_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
 	if (txq_id < 4)
 		il_set_swq_id(txq, txq_id, txq_id);
 
-	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-	 * il_queue_inc_wrap and il_queue_dec_wrap are broken. */
-	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
-
 	/* Initialize queue's high/low-water marks, and head/tail idxes */
-	il_queue_init(il, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
+	il_queue_init(il, &txq->q, slots, txq_id);
 
 	/* Tell device where to find queue */
 	il->ops->txq_init(il, txq);
@@ -3034,20 +3036,24 @@ out_free_arrays:
 EXPORT_SYMBOL(il_tx_queue_init);
 
 void
-il_tx_queue_reset(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
-		  u32 txq_id)
+il_tx_queue_reset(struct il_priv *il, u32 txq_id)
 {
-	int actual_slots = slots_num;
+	int slots, actual_slots;
+	struct il_tx_queue *txq = &il->txq[txq_id];
 
-	if (txq_id == il->cmd_queue)
-		actual_slots++;
+	if (txq_id == il->cmd_queue) {
+		slots = TFD_CMD_SLOTS;
+		actual_slots = TFD_CMD_SLOTS + 1;
+	} else {
+		slots = TFD_TX_CMD_SLOTS;
+		actual_slots = TFD_TX_CMD_SLOTS;
+	}
 
 	memset(txq->meta, 0, sizeof(struct il_cmd_meta) * actual_slots);
-
 	txq->need_update = 0;
 
 	/* Initialize queue's high/low-water marks, and head/tail idxes */
-	il_queue_init(il, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
+	il_queue_init(il, &txq->q, slots, txq_id);
 
 	/* Tell device where to find queue */
 	il->ops->txq_init(il, txq);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 13bfd43..e2f55dc 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1783,14 +1783,12 @@ void il_chswitch_done(struct il_priv *il, bool is_success);
 /*****************************************************
 * TX
 ******************************************************/
-void il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq);
-int il_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq, int slots_num,
-		     u32 txq_id);
-void il_tx_queue_reset(struct il_priv *il, struct il_tx_queue *txq,
-		       int slots_num, u32 txq_id);
-void il_tx_queue_unmap(struct il_priv *il, int txq_id);
-void il_tx_queue_free(struct il_priv *il, int txq_id);
-void il_setup_watchdog(struct il_priv *il);
+extern void il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq);
+extern int il_tx_queue_init(struct il_priv *il, u32 txq_id);
+extern void il_tx_queue_reset(struct il_priv *il, u32 txq_id);
+extern void il_tx_queue_unmap(struct il_priv *il, int txq_id);
+extern void il_tx_queue_free(struct il_priv *il, int txq_id);
+extern void il_setup_watchdog(struct il_priv *il);
 /*****************************************************
  * TX power
  ****************************************************/
@@ -2405,10 +2403,10 @@ struct il_rb_status {
 	__le32 __unused;	/* 3945 only */
 } __packed;
 
-#define TFD_QUEUE_SIZE_MAX      (256)
-#define TFD_QUEUE_SIZE_BC_DUP	(64)
+#define TFD_QUEUE_SIZE_MAX      256
+#define TFD_QUEUE_SIZE_BC_DUP	64
 #define TFD_QUEUE_BC_SIZE	(TFD_QUEUE_SIZE_MAX + TFD_QUEUE_SIZE_BC_DUP)
-#define IL_TX_DMA_MASK        DMA_BIT_MASK(36)
+#define IL_TX_DMA_MASK		DMA_BIT_MASK(36)
 #define IL_NUM_OF_TBS		20
 
 static inline u8
-- 
1.7.1

