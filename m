Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50477 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab0BKSmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/12] iwlwifi: cleanup return values
Date: Thu, 11 Feb 2010 10:41:59 -0800
Message-Id: <1265913725-4279-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Cleanup return values and removes unnecessary code.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   11 +++--------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   21 +++++++--------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 ++++------------
 4 files changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index df55879..530fae8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -414,13 +414,13 @@ void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 void iwl_cmd_queue_free(struct iwl_priv *priv);
 int iwl_rx_queue_alloc(struct iwl_priv *priv);
 void iwl_rx_handle(struct iwl_priv *priv);
-int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
+void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
 void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 void iwl_rx_replenish(struct iwl_priv *priv);
 void iwl_rx_replenish_now(struct iwl_priv *priv);
 int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
-int iwl_rx_queue_restock(struct iwl_priv *priv);
+void iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
@@ -450,7 +450,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
 void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
 int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 			 struct iwl_tx_queue *txq);
-int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 909d9c9..428c9d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -123,12 +123,11 @@ EXPORT_SYMBOL(iwl_rx_queue_space);
 /**
  * iwl_rx_queue_update_write_ptr - Update the write pointer for the RX queue
  */
-int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
+void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 {
 	unsigned long flags;
 	u32 rx_wrt_ptr_reg = priv->hw_params.rx_wrt_ptr_reg;
 	u32 reg;
-	int ret = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
 
@@ -161,7 +160,6 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 
  exit_unlock:
 	spin_unlock_irqrestore(&q->lock, flags);
-	return ret;
 }
 EXPORT_SYMBOL(iwl_rx_queue_update_write_ptr);
 /**
@@ -184,14 +182,13 @@ static inline __le32 iwl_dma_addr2rbd_ptr(struct iwl_priv *priv,
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
-int iwl_rx_queue_restock(struct iwl_priv *priv)
+void iwl_rx_queue_restock(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
 	int write;
-	int ret = 0;
 
 	spin_lock_irqsave(&rxq->lock, flags);
 	write = rxq->write & ~0x7;
@@ -220,10 +217,8 @@ int iwl_rx_queue_restock(struct iwl_priv *priv)
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
 		spin_unlock_irqrestore(&rxq->lock, flags);
-		ret = iwl_rx_queue_update_write_ptr(priv, rxq);
+		iwl_rx_queue_update_write_ptr(priv, rxq);
 	}
-
-	return ret;
 }
 EXPORT_SYMBOL(iwl_rx_queue_restock);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3788a3d..2199b1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -80,14 +80,13 @@ static inline void iwl_free_dma_ptr(struct iwl_priv *priv,
 /**
  * iwl_txq_update_write_ptr - Send new write index to hardware
  */
-int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	u32 reg = 0;
-	int ret = 0;
 	int txq_id = txq->q.id;
 
 	if (txq->need_update == 0)
-		return ret;
+		return;
 
 	/* if we're trying to save power */
 	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
@@ -101,7 +100,7 @@ int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 				      txq_id, reg);
 			iwl_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			return ret;
+			return;
 		}
 
 		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
@@ -114,8 +113,6 @@ int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 			    txq->q.write_ptr | (txq_id << 8));
 
 	txq->need_update = 0;
-
-	return ret;
 }
 EXPORT_SYMBOL(iwl_txq_update_write_ptr);
 
@@ -731,7 +728,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u8 tid = 0;
 	u8 *qc = NULL;
 	unsigned long flags;
-	int ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (iwl_is_rfkill(priv)) {
@@ -951,7 +947,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	ret = iwl_txq_update_write_ptr(priv, txq);
+	iwl_txq_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/*
@@ -965,9 +961,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta_priv && sta_priv->client)
 		atomic_inc(&sta_priv->pending_frames);
 
-	if (ret)
-		return ret;
-
 	if ((iwl_queue_space(q) < q->high_mark) && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
@@ -1006,7 +999,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	struct iwl_cmd_meta *out_meta;
 	dma_addr_t phys_addr;
 	unsigned long flags;
-	int len, ret;
+	int len;
 	u32 idx;
 	u16 fix_size;
 
@@ -1103,10 +1096,10 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	ret = iwl_txq_update_write_ptr(priv, txq);
+	iwl_txq_update_write_ptr(priv, txq);
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
-	return ret ? ret : idx;
+	return idx;
 }
 
 static void iwl_tx_status(struct iwl_priv *priv, struct sk_buff *skb)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index eac2b9a..f6e8f45 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -478,7 +478,6 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u8 wait_write_ptr = 0;
 	u8 *qc = NULL;
 	unsigned long flags;
-	int rc;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (iwl_is_rfkill(priv)) {
@@ -663,12 +662,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	rc = iwl_txq_update_write_ptr(priv, txq);
+	iwl_txq_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (rc)
-		return rc;
-
 	if ((iwl_queue_space(q) < q->high_mark)
 	    && priv->mac80211_registered) {
 		if (wait_write_ptr) {
@@ -1063,13 +1059,13 @@ static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl_priv *priv,
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
-static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
+static void iwl3945_rx_queue_restock(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
-	int write, rc;
+	int write;
 
 	spin_lock_irqsave(&rxq->lock, flags);
 	write = rxq->write & ~0x7;
@@ -1099,12 +1095,8 @@ static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
 		spin_unlock_irqrestore(&rxq->lock, flags);
-		rc = iwl_rx_queue_update_write_ptr(priv, rxq);
-		if (rc)
-			return rc;
+		iwl_rx_queue_update_write_ptr(priv, rxq);
 	}
-
-	return 0;
 }
 
 /**
-- 
1.6.3.3

