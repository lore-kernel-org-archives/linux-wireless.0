Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1GHQUg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/21] iwlagn: add an API for TX stop
Date: Fri,  8 Jul 2011 08:46:12 -0700
Message-Id: <1310139989-27661-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182057_699174_87913D42)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Tx stop moves to transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |   33 ----------------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c   |   56 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   17 --------
 7 files changed, 59 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 25a592a..a926142 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2310,7 +2310,7 @@ void iwlagn_stop_device(struct iwl_priv *priv)
 	 * already dead.
 	 */
 	if (test_bit(STATUS_DEVICE_ENABLED, &priv->status)) {
-		iwlagn_txq_ctx_stop(priv);
+		priv->trans.ops->tx_stop(priv);
 		priv->trans.ops->rx_stop(priv);
 
 		/* Power-down device's busmaster DMA clocks */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index b476c95..c420750 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -852,39 +852,6 @@ static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
 	memset(ptr, 0, sizeof(*ptr));
 }
 
-/**
- * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
- */
-void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
-{
-	int ch, txq_id;
-	unsigned long flags;
-
-	/* Turn off all Tx DMA fifos */
-	spin_lock_irqsave(&priv->lock, flags);
-
-	iwlagn_txq_set_sched(priv, 0);
-
-	/* Stop each Tx DMA channel, and wait for it to be idle */
-	for (ch = 0; ch < priv->hw_params.dma_chnl_num; ch++) {
-		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		if (iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
-				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
-				    1000))
-			IWL_ERR(priv, "Failing on timeout while stopping"
-			    " DMA channel %d [0x%08x]", ch,
-			    iwl_read_direct32(priv, FH_TSSR_TX_STATUS_REG));
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (!priv->txq)
-		return;
-
-	/* Unmap DMA from host system and free skb's */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		iwl_tx_queue_unmap(priv, txq_id);
-}
-
 /*
  * Find first available (lowest unused) Tx Queue, mark it "active".
  * Called only when finding queue for aggregation.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 0fa379b..ff0b2ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -217,7 +217,6 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
 int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
-void iwlagn_txq_ctx_stop(struct iwl_priv *priv);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7d8be6b..76f6535 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -384,7 +384,6 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 			  int count, int slots_num, u32 id);
-void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id);
 void iwl_setup_watchdog(struct iwl_priv *priv);
 /*****************************************************
  * TX power
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8611cf0..85e4fa3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -694,8 +694,6 @@ struct iwl_hw_params {
  ****************************************************************************/
 extern void iwl_update_chain_flags(struct iwl_priv *priv);
 extern const u8 iwl_bcast_addr[ETH_ALEN];
-extern int iwl_rxq_stop(struct iwl_priv *priv);
-extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl_queue_space(const struct iwl_queue *q);
 static inline int iwl_queue_used(const struct iwl_queue *q, int i)
 {
@@ -1234,6 +1232,7 @@ struct iwl_trans;
  * @rx_stop: stop the rx
  * @rx_free: frees the rx memory
  * @tx_init:inits the tx memory, allocate if needed
+ * @tx_stop: stop the tx
  * @tx_free: frees the tx memory
  */
 struct iwl_trans_ops {
@@ -1242,6 +1241,7 @@ struct iwl_trans_ops {
 	void (*rx_free)(struct iwl_priv *priv);
 
 	int (*tx_init)(struct iwl_priv *priv);
+	int (*tx_stop)(struct iwl_priv *priv);
 	void (*tx_free)(struct iwl_priv *priv);
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index c4cd363..81716fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -328,6 +328,24 @@ static int iwl_trans_txq_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 }
 
 /**
+ * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
+ */
+static void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+
+	if (!q->n_bd)
+		return;
+
+	while (q->write_ptr != q->read_ptr) {
+		/* The read_ptr needs to bound by q->n_window */
+		iwlagn_txq_free_tfd(priv, txq, get_cmd_index(q, q->read_ptr));
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
+	}
+}
+
+/**
  * iwl_tx_queue_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
  *
@@ -497,12 +515,50 @@ error:
 	return ret;
 }
 
+/**
+ * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
+ */
+static int iwl_trans_tx_stop(struct iwl_priv *priv)
+{
+	int ch, txq_id;
+	unsigned long flags;
+
+	/* Turn off all Tx DMA fifos */
+	spin_lock_irqsave(&priv->lock, flags);
+
+	iwlagn_txq_set_sched(priv, 0);
+
+	/* Stop each Tx DMA channel, and wait for it to be idle */
+	for (ch = 0; ch < priv->hw_params.dma_chnl_num; ch++) {
+		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
+		if (iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
+				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
+				    1000))
+			IWL_ERR(priv, "Failing on timeout while stopping"
+			    " DMA channel %d [0x%08x]", ch,
+			    iwl_read_direct32(priv, FH_TSSR_TX_STATUS_REG));
+	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (!priv->txq) {
+		IWL_WARN(priv, "Stopping tx queues that aren't allocated...");
+		return 0;
+	}
+
+	/* Unmap DMA from host system and free skb's */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+		iwl_tx_queue_unmap(priv, txq_id);
+
+	return 0;
+}
+
 static const struct iwl_trans_ops trans_ops = {
 	.rx_init = iwl_trans_rx_init,
 	.rx_stop = iwl_trans_rx_stop,
 	.rx_free = iwl_trans_rx_free,
 
 	.tx_init = iwl_trans_tx_init,
+	.tx_stop = iwl_trans_tx_stop,
 	.tx_free = iwl_trans_tx_free,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 36b643a..b62d032 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -221,23 +221,6 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 	return 0;
 }
 
-/**
- * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
- */
-void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
-{
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-
-	if (q->n_bd == 0)
-		return;
-
-	 while (q->write_ptr != q->read_ptr) {
-		iwlagn_txq_free_tfd(priv, txq, get_cmd_index(q, q->read_ptr));
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
-	}
-}
-
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
-- 
1.7.0.4

