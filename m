Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbZASX2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:17 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/15] iwlwifi: Add TFD library operations
Date: Mon, 19 Jan 2009 15:30:26 -0800
Message-Id: <1232407835-19451-7-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002827_432748_4BD70C83)
In-Reply-To: <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

The TFD structures for 3945 and agn HWs are fundamentally different. We thus
need to define operations for attaching and freeing them. This will allow us
to share a fair amount of code (cmd and tx queue related) between both
drivers.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   28 ++++--
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  120 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |   10 ++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |  134 ++-------------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   34 ++-----
 8 files changed, 176 insertions(+), 163 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index e6d4503..18e0f0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -318,7 +318,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 		tx_info = &txq->txb[txq->q.read_ptr];
 		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
 		tx_info->skb[0] = NULL;
-		iwl3945_hw_txq_free_tfd(priv, txq);
+		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 	}
 
 	if (iwl_queue_space(q) > q->low_mark && (txq_id >= 0) &&
@@ -724,15 +724,21 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
 }
 
-int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
-				 dma_addr_t addr, u16 len)
+int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+				     struct iwl_tx_queue *txq,
+				     dma_addr_t addr, u16 len, u8 reset, u8 pad)
 {
 	int count;
-	u32 pad;
-	struct iwl3945_tfd *tfd = (struct iwl3945_tfd *)ptr;
+	struct iwl_queue *q;
+	struct iwl3945_tfd *tfd;
+
+	q = &txq->q;
+	tfd = &txq->tfds39[q->write_ptr];
+
+	if (reset)
+		memset(tfd, 0, sizeof(*tfd));
 
 	count = TFD_CTL_COUNT_GET(le32_to_cpu(tfd->control_flags));
-	pad = TFD_CTL_PAD_GET(le32_to_cpu(tfd->control_flags));
 
 	if ((count >= NUM_TFD_CHUNKS) || (count < 0)) {
 		IWL_ERR(priv, "Error can not send more than %d chunks\n",
@@ -756,7 +762,7 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
  *
  * Does NOT advance any indexes
  */
-int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)&txq->tfds39[0];
 	struct iwl3945_tfd *tfd = &tfd_tmp[txq->q.read_ptr];
@@ -767,14 +773,14 @@ int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* classify bd */
 	if (txq->q.id == IWL_CMD_QUEUE_NUM)
 		/* nothing to cleanup after for host commands */
-		return 0;
+		return;
 
 	/* sanity check */
 	counter = TFD_CTL_COUNT_GET(le32_to_cpu(tfd->control_flags));
 	if (counter > NUM_TFD_CHUNKS) {
 		IWL_ERR(priv, "Too many chunks: %i\n", counter);
 		/* @todo issue fatal error, it is quite serious situation */
-		return 0;
+		return;
 	}
 
 	/* unmap chunks if any */
@@ -791,7 +797,7 @@ int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 			}
 		}
 	}
-	return 0;
+	return ;
 }
 
 u8 iwl3945_hw_find_station(struct iwl_priv *priv, const u8 *addr)
@@ -2697,6 +2703,8 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 }
 
 static struct iwl_lib_ops iwl3945_lib = {
+	.txq_attach_buf_to_tfd = iwl3945_hw_txq_attach_buf_to_tfd,
+	.txq_free_tfd = iwl3945_hw_txq_free_tfd,
 	.load_ucode = iwl3945_load_bsm,
 	.apm_ops = {
 		.init = iwl3945_apm_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 97dfa7c..54538df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -260,9 +260,12 @@ extern int iwl3945_hw_nic_stop_master(struct iwl_priv *priv);
 extern void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv);
 extern void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl3945_hw_nic_reset(struct iwl_priv *priv);
-extern int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
-					dma_addr_t addr, u16 len);
-extern int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+extern int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+					    struct iwl_tx_queue *txq,
+					    dma_addr_t addr, u16 len,
+					    u8 reset, u8 pad);
+extern void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv,
+				    struct iwl_tx_queue *txq);
 extern int iwl3945_hw_get_temperature(struct iwl_priv *priv);
 extern int iwl3945_hw_tx_queue_init(struct iwl_priv *priv,
 				struct iwl_tx_queue *txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6171ba5..31315de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2295,6 +2295,8 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.txq_set_sched = iwl4965_txq_set_sched,
 	.txq_agg_enable = iwl4965_txq_agg_enable,
 	.txq_agg_disable = iwl4965_txq_agg_disable,
+	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
+	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.rx_handler_setup = iwl4965_rx_handler_setup,
 	.setup_deferred_work = iwl4965_setup_deferred_work,
 	.cancel_deferred_work = iwl4965_cancel_deferred_work,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 429dcbe..a35af67 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1492,6 +1492,8 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.txq_set_sched = iwl5000_txq_set_sched,
 	.txq_agg_enable = iwl5000_txq_agg_enable,
 	.txq_agg_disable = iwl5000_txq_agg_disable,
+	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
+	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index de6e999..9d06d4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -471,6 +471,126 @@ static int iwl_send_beacon_cmd(struct iwl_priv *priv)
 	return rc;
 }
 
+static inline dma_addr_t iwl_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+
+	dma_addr_t addr = get_unaligned_le32(&tb->lo);
+	if (sizeof(dma_addr_t) > sizeof(u32))
+		addr |=
+		((dma_addr_t)(le16_to_cpu(tb->hi_n_len) & 0xF) << 16) << 16;
+
+	return addr;
+}
+
+static inline u16 iwl_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+
+	return le16_to_cpu(tb->hi_n_len) >> 4;
+}
+
+static inline void iwl_tfd_set_tb(struct iwl_tfd *tfd, u8 idx,
+				  dma_addr_t addr, u16 len)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+	u16 hi_n_len = len << 4;
+
+	put_unaligned_le32(addr, &tb->lo);
+	if (sizeof(dma_addr_t) > sizeof(u32))
+		hi_n_len |= ((addr >> 16) >> 16) & 0xF;
+
+	tb->hi_n_len = cpu_to_le16(hi_n_len);
+
+	tfd->num_tbs = idx + 1;
+}
+
+static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
+{
+	return tfd->num_tbs & 0x1f;
+}
+
+/**
+ * iwl_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
+ * @priv - driver private data
+ * @txq - tx queue
+ *
+ * Does NOT advance any TFD circular buffer read/write indexes
+ * Does NOT free the TFD itself (which is within circular buffer)
+ */
+void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+{
+	struct iwl_tfd *tfd_tmp = (struct iwl_tfd *)&txq->tfds[0];
+	struct iwl_tfd *tfd;
+	struct pci_dev *dev = priv->pci_dev;
+	int index = txq->q.read_ptr;
+	int i;
+	int num_tbs;
+
+	tfd = &tfd_tmp[index];
+
+	/* Sanity check on number of chunks */
+	num_tbs = iwl_tfd_get_num_tbs(tfd);
+
+	if (num_tbs >= IWL_NUM_OF_TBS) {
+		IWL_ERR(priv, "Too many chunks: %i\n", num_tbs);
+		/* @todo issue fatal error, it is quite serious situation */
+		return;
+	}
+
+	/* Unmap tx_cmd */
+	if (num_tbs)
+		pci_unmap_single(dev,
+				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
+				pci_unmap_len(&txq->cmd[index]->meta, len),
+				PCI_DMA_TODEVICE);
+
+	/* Unmap chunks, if any. */
+	for (i = 1; i < num_tbs; i++) {
+		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
+				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
+
+		if (txq->txb) {
+			dev_kfree_skb(txq->txb[txq->q.read_ptr].skb[i - 1]);
+			txq->txb[txq->q.read_ptr].skb[i - 1] = NULL;
+		}
+	}
+}
+
+int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+				 struct iwl_tx_queue *txq,
+				 dma_addr_t addr, u16 len,
+				 u8 reset, u8 pad)
+{
+	struct iwl_queue *q;
+	struct iwl_tfd *tfd;
+	u32 num_tbs;
+
+	q = &txq->q;
+	tfd = &txq->tfds[q->write_ptr];
+
+	if (reset)
+		memset(tfd, 0, sizeof(*tfd));
+
+	num_tbs = iwl_tfd_get_num_tbs(tfd);
+
+	/* Each TFD can point to a maximum 20 Tx buffers */
+	if (num_tbs >= IWL_NUM_OF_TBS) {
+		IWL_ERR(priv, "Error can not send more than %d chunks\n",
+			  IWL_NUM_OF_TBS);
+		return -EINVAL;
+	}
+
+	BUG_ON(addr & ~DMA_BIT_MASK(36));
+	if (unlikely(addr & ~IWL_TX_DMA_MASK))
+		IWL_ERR(priv, "Unaligned address = %llx\n",
+			  (unsigned long long)addr);
+
+	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
+
+	return 0;
+}
+
 /******************************************************************************
  *
  * Misc. internal state and helper functions
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 466130f..9abdfb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -110,6 +110,12 @@ struct iwl_lib_ops {
 	void (*txq_inval_byte_cnt_tbl)(struct iwl_priv *priv,
 				       struct iwl_tx_queue *txq);
 	void (*txq_set_sched)(struct iwl_priv *priv, u32 mask);
+	int (*txq_attach_buf_to_tfd)(struct iwl_priv *priv,
+				     struct iwl_tx_queue *txq,
+				     dma_addr_t addr,
+				     u16 len, u8 reset, u8 pad);
+	void (*txq_free_tfd)(struct iwl_priv *priv,
+			     struct iwl_tx_queue *txq);
 	/* aggregations */
 	int (*txq_agg_enable)(struct iwl_priv *priv, int txq_id, int tx_fifo,
 			      int sta_id, int tid, u16 ssn_idx);
@@ -252,6 +258,10 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 * TX
 ******************************************************/
 int iwl_txq_ctx_reset(struct iwl_priv *priv);
+void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+				 struct iwl_tx_queue *txq,
+				 dma_addr_t addr, u16 len, u8 reset, u8 pad);
 int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
 void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
 int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 913c77a..487a1d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -76,116 +76,6 @@ static inline void iwl_free_dma_ptr(struct iwl_priv *priv,
 	memset(ptr, 0, sizeof(*ptr));
 }
 
-static inline dma_addr_t iwl_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-
-	dma_addr_t addr = get_unaligned_le32(&tb->lo);
-	if (sizeof(dma_addr_t) > sizeof(u32))
-		addr |=
-		((dma_addr_t)(le16_to_cpu(tb->hi_n_len) & 0xF) << 16) << 16;
-
-	return addr;
-}
-
-static inline u16 iwl_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-
-	return le16_to_cpu(tb->hi_n_len) >> 4;
-}
-
-static inline void iwl_tfd_set_tb(struct iwl_tfd *tfd, u8 idx,
-				  dma_addr_t addr, u16 len)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-	u16 hi_n_len = len << 4;
-
-	put_unaligned_le32(addr, &tb->lo);
-	if (sizeof(dma_addr_t) > sizeof(u32))
-		hi_n_len |= ((addr >> 16) >> 16) & 0xF;
-
-	tb->hi_n_len = cpu_to_le16(hi_n_len);
-
-	tfd->num_tbs = idx + 1;
-}
-
-static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
-{
-	return tfd->num_tbs & 0x1f;
-}
-
-/**
- * iwl_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
- * @priv - driver private data
- * @txq - tx queue
- *
- * Does NOT advance any TFD circular buffer read/write indexes
- * Does NOT free the TFD itself (which is within circular buffer)
- */
-static void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
-{
-	struct iwl_tfd *tfd_tmp = (struct iwl_tfd *)&txq->tfds[0];
-	struct iwl_tfd *tfd;
-	struct pci_dev *dev = priv->pci_dev;
-	int index = txq->q.read_ptr;
-	int i;
-	int num_tbs;
-
-	tfd = &tfd_tmp[index];
-
-	/* Sanity check on number of chunks */
-	num_tbs = iwl_tfd_get_num_tbs(tfd);
-
-	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERR(priv, "Too many chunks: %i\n", num_tbs);
-		/* @todo issue fatal error, it is quite serious situation */
-		return;
-	}
-
-	/* Unmap tx_cmd */
-	if (num_tbs)
-		pci_unmap_single(dev,
-				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
-				pci_unmap_len(&txq->cmd[index]->meta, len),
-				PCI_DMA_TODEVICE);
-
-	/* Unmap chunks, if any. */
-	for (i = 1; i < num_tbs; i++) {
-		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
-				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
-
-		if (txq->txb) {
-			dev_kfree_skb(txq->txb[txq->q.read_ptr].skb[i - 1]);
-			txq->txb[txq->q.read_ptr].skb[i - 1] = NULL;
-		}
-	}
-}
-
-static int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
-					struct iwl_tfd *tfd,
-					dma_addr_t addr, u16 len)
-{
-
-	u32 num_tbs = iwl_tfd_get_num_tbs(tfd);
-
-	/* Each TFD can point to a maximum 20 Tx buffers */
-	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERR(priv, "Error can not send more than %d chunks\n",
-			  IWL_NUM_OF_TBS);
-		return -EINVAL;
-	}
-
-	BUG_ON(addr & ~DMA_BIT_MASK(36));
-	if (unlikely(addr & ~IWL_TX_DMA_MASK))
-		IWL_ERR(priv, "Unaligned address = %llx\n",
-			  (unsigned long long)addr);
-
-	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
-
-	return 0;
-}
-
 /**
  * iwl_txq_update_write_ptr - Send new write index to hardware
  */
@@ -254,7 +144,7 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 	/* first, empty all BD's */
 	for (; q->write_ptr != q->read_ptr;
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
-		iwl_hw_txq_free_tfd(priv, txq);
+		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl_cmd) * q->n_window;
 
@@ -822,7 +712,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct iwl_tfd *tfd;
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
 	struct iwl_cmd *out_cmd;
@@ -913,10 +802,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	/* Set up first empty TFD within this queue's circular TFD buffer */
-	tfd = &txq->tfds[q->write_ptr];
-	memset(tfd, 0, sizeof(*tfd));
-
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
 	txq->txb[q->write_ptr].skb[0] = skb;
@@ -970,7 +855,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
 	txcmd_phys += offsetof(struct iwl_cmd, hdr);
-	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
+	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+						   txcmd_phys, len, 1, 0);
 
 	if (info->control.hw_key)
 		iwl_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
@@ -981,7 +867,9 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (len) {
 		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
 					   len, PCI_DMA_TODEVICE);
-		iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
+		priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+							   phys_addr, len,
+							   0, 0);
 	}
 
 	/* Tell NIC about any 2-byte padding after MAC header */
@@ -1063,7 +951,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
-	struct iwl_tfd *tfd;
 	struct iwl_cmd *out_cmd;
 	dma_addr_t phys_addr;
 	unsigned long flags;
@@ -1092,10 +979,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
-	tfd = &txq->tfds[q->write_ptr];
-	memset(tfd, 0, sizeof(*tfd));
-
-
 	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
 	out_cmd = txq->cmd[idx];
 
@@ -1120,7 +1003,8 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	pci_unmap_len_set(&out_cmd->meta, len, len);
 	phys_addr += offsetof(struct iwl_cmd, hdr);
 
-	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
+	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+						   phys_addr, fix_size, 1, 0);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	switch (out_cmd->hdr.cmd) {
@@ -1180,7 +1064,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
 			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
 
-		iwl_hw_txq_free_tfd(priv, txq);
+		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 		nfreed++;
 	}
 	return nfreed;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2ab9162..d76ad43 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -274,7 +274,7 @@ void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* first, empty all BD's */
 	for (; q->write_ptr != q->read_ptr;
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
-		iwl3945_hw_txq_free_tfd(priv, txq);
+		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl_cmd) * q->n_window;
 	if (q->id == IWL_CMD_QUEUE_NUM)
@@ -453,12 +453,10 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
-	struct iwl3945_tfd *tfd;
 	struct iwl_cmd *out_cmd;
 	u32 idx;
 	u16 fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
 	dma_addr_t phys_addr;
-	int pad;
 	int ret, len;
 	unsigned long flags;
 
@@ -481,9 +479,6 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
-	tfd = &txq->tfds39[q->write_ptr];
-	memset(tfd, 0, sizeof(*tfd));
-
 	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
 	out_cmd = txq->cmd[idx];
 
@@ -509,10 +504,9 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	pci_unmap_len_set(&out_cmd->meta, len, len);
 	phys_addr += offsetof(struct iwl_cmd, hdr);
 
-	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
-
-	pad = U32_PAD(cmd->len);
-	tfd->control_flags |= cpu_to_le32(TFD_CTL_PAD_SET(pad));
+	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+						   phys_addr, fix_size,
+						   1, U32_PAD(cmd->len));
 
 	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
 		     "%d bytes at %d[%d]:%d\n",
@@ -2158,7 +2152,6 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct iwl3945_tfd *tfd;
 	struct iwl3945_tx_cmd *tx;
 	struct iwl_tx_queue *txq = NULL;
 	struct iwl_queue *q = NULL;
@@ -2243,9 +2236,6 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	/* Set up first empty TFD within this queue's circular TFD buffer */
-	tfd = &txq->tfds39[q->write_ptr];
-	memset(tfd, 0, sizeof(*tfd));
 	idx = get_cmd_index(q, q->write_ptr, 0);
 
 	/* Set up driver data for this TFD */
@@ -2304,7 +2294,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
-	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
+	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+						   txcmd_phys, len, 1, 0);
 
 	if (info->control.hw_key)
 		iwl3945_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, 0);
@@ -2315,18 +2306,11 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (len) {
 		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
 					   len, PCI_DMA_TODEVICE);
-		iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
+		priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+							   phys_addr, len,
+							   0, U32_PAD(len));
 	}
 
-	if (!len)
-		/* If there is no payload, then we use only one Tx buffer */
-		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(1));
-	else
-		/* Else use 2 buffers.
-		 * Tell 3945 about any padding after MAC header */
-		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(2) |
-			TFD_CTL_PAD_SET(U32_PAD(len)));
-
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
 	tx->len = cpu_to_le16(len);
-- 
1.5.4.3

