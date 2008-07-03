Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:16942 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYGCQlW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 12:41:22 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>
Subject: [RFC PATCH] iwlwifi: Memory allocation optimization.
Date: Thu,  3 Jul 2008 19:41:14 +0300
Message-Id: <1215103274-8516-1-git-send-email-tomas.winkler@intel.com> (sfid-20080703_184125_847930_BC19863A)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch optimizes memory allocation. The cmd member of
iwl_tx_queue was allocated previously as a continuous block
of memory. This patch allocates separate memory chunks for each command
and maps/unmaps these chunks in the run time.


Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
This patch should help a bit the memory allocation problems seen on 64 bit platforms
This patch still not went through exesive testing so it's not to be applied yet into 
a production code 

 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   75 ++++++++++++++++++++++---------
 4 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 717db0d..3cf2a69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -914,8 +914,8 @@ static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 
 	if (txq_id != IWL_CMD_QUEUE_NUM) {
-		sta = txq->cmd[txq->q.write_ptr].cmd.tx.sta_id;
-		sec_ctl = txq->cmd[txq->q.write_ptr].cmd.tx.sec_ctl;
+		sta = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
+		sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
 
 		switch (sec_ctl & TX_CMD_SEC_MSK) {
 		case TX_CMD_SEC_CCM:
@@ -954,7 +954,7 @@ static void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 	u8 sta = 0;
 
 	if (txq_id != IWL_CMD_QUEUE_NUM)
-		sta = txq->cmd[txq->q.read_ptr].cmd.tx.sta_id;
+		sta = txq->cmd[txq->q.read_ptr]->cmd.tx.sta_id;
 
 	shared_data->queues_byte_cnt_tbls[txq_id].tfd_offset[txq->q.read_ptr].
 					val = cpu_to_le16(1 | (sta << 12));
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d1289cf..8a5f981 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -138,8 +138,7 @@ struct iwl_tx_info {
 struct iwl_tx_queue {
 	struct iwl_queue q;
 	struct iwl_tfd_frame *bd;
-	struct iwl_cmd *cmd;
-	dma_addr_t dma_addr_cmd;
+	struct iwl_cmd *cmd[TFD_TX_CMD_SLOTS];
 	struct iwl_tx_info *txb;
 	int need_update;
 	int sched_retry;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 8fa991b..6512834 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -228,7 +228,7 @@ cancel:
 		 * TX cmd queue. Otherwise in case the cmd comes
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source). */
-		qcmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
+		qcmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
 		qcmd->meta.flags &= ~CMD_WANT_SKB;
 	}
 fail:
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 032641d..f5f7cd3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -208,11 +208,12 @@ EXPORT_SYMBOL(iwl_txq_update_write_ptr);
  * Free all buffers.
  * 0-fill, but do not free "txq" descriptor structure.
  */
-static void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 {
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
-	int len;
+	int i, slots_num, len;
 
 	if (q->n_bd == 0)
 		return;
@@ -227,7 +228,12 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		len += IWL_MAX_SCAN_SIZE;
 
 	/* De-alloc array of command/tx buffers */
-	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
+	slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
+			TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+	for (i = 0; i < slots_num; i++)
+		kfree(txq->cmd[i]);
+	if (txq_id == IWL_CMD_QUEUE_NUM)
+		kfree(txq->cmd[slots_num]);
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
@@ -400,8 +406,7 @@ static int iwl_tx_queue_init(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq,
 			     int slots_num, u32 txq_id)
 {
-	struct pci_dev *dev = priv->pci_dev;
-	int len;
+	int i, len;
 	int rc = 0;
 
 	/*
@@ -412,17 +417,24 @@ static int iwl_tx_queue_init(struct iwl_priv *priv,
 	 * For normal Tx queues (all other queues), no super-size command
 	 * space is needed.
 	 */
-	len = sizeof(struct iwl_cmd) * slots_num;
-	if (txq_id == IWL_CMD_QUEUE_NUM)
-		len +=  IWL_MAX_SCAN_SIZE;
-	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
-	if (!txq->cmd)
-		return -ENOMEM;
+	for (i = 0; i <= slots_num; i++) {
+		if (i == slots_num)
+			if (txq_id == IWL_CMD_QUEUE_NUM)
+				len = IWL_MAX_SCAN_SIZE;
+			else
+				continue;
+		else
+			len = sizeof(struct iwl_cmd);
+		txq->cmd[i] = kmalloc(len, GFP_KERNEL | GFP_DMA);
+		if (!txq->cmd[i])
+			return -ENOMEM;
+	}
 
 	/* Alloc driver data array and TFD circular buffer */
 	rc = iwl_tx_queue_alloc(priv, txq, txq_id);
 	if (rc) {
-		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
+		for (i = 0; i < slots_num; i++)
+			kfree(txq->cmd[i]);
 
 		return -ENOMEM;
 	}
@@ -451,7 +463,7 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 
 	/* Tx queues */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		iwl_tx_queue_free(priv, &priv->txq[txq_id]);
+		iwl_tx_queue_free(priv, txq_id);
 
 	/* Keep-warm buffer */
 	iwl_kw_free(priv);
@@ -865,7 +877,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq->txb[q->write_ptr].skb[0] = skb;
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
-	out_cmd = &txq->cmd[idx];
+	out_cmd = txq->cmd[idx];
 	tx_cmd = &out_cmd->cmd.tx;
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(tx_cmd, 0, sizeof(struct iwl_tx_cmd));
@@ -905,8 +917,9 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
-		     offsetof(struct iwl_cmd, hdr);
+	txcmd_phys = pci_map_single(priv->pci_dev, out_cmd,
+				sizeof(struct iwl_cmd), PCI_DMA_TODEVICE);
+	txcmd_phys += offsetof(struct iwl_cmd, hdr);
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
@@ -1010,7 +1023,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	u32 idx;
 	u16 fix_size;
 	dma_addr_t phys_addr;
-	int ret;
+	int len, ret;
 	unsigned long flags;
 
 	cmd->len = priv->cfg->ops->utils->get_hcmd_size(cmd->id, cmd->len);
@@ -1040,7 +1053,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	control_flags = (u32 *) tfd;
 
 	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
-	out_cmd = &txq->cmd[idx];
+	out_cmd = txq->cmd[idx];
 
 	out_cmd->hdr.cmd = cmd->id;
 	memcpy(&out_cmd->meta, &cmd->meta, sizeof(cmd->meta));
@@ -1054,9 +1067,11 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			INDEX_TO_SEQ(q->write_ptr));
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
-
-	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
-			offsetof(struct iwl_cmd, hdr);
+	len = (idx == TFD_CMD_SLOTS) ?
+			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
+	phys_addr = pci_map_single(priv->pci_dev, out_cmd, len,
+						PCI_DMA_TODEVICE);
+	phys_addr += offsetof(struct iwl_cmd, hdr);
 	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
 	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
@@ -1121,6 +1136,9 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
+	struct iwl_tfd_frame *bd = &txq->bd[index];
+	dma_addr_t dma_addr;
+	int is_odd, buf_len;
 	int nfreed = 0;
 
 	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
@@ -1138,6 +1156,19 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 					q->write_ptr, q->read_ptr);
 			queue_work(priv->workqueue, &priv->restart);
 		}
+		is_odd = (index/2) & 0x1;
+		if (is_odd) {
+			dma_addr = IWL_GET_BITS(bd->pa[index], tb2_addr_lo16) |
+					(IWL_GET_BITS(bd->pa[index],
+							tb2_addr_hi20) << 16);
+			buf_len = IWL_GET_BITS(bd->pa[index], tb2_len);
+		} else {
+			dma_addr = le32_to_cpu(bd->pa[index].tb1_addr);
+			buf_len = IWL_GET_BITS(bd->pa[index], tb1_len);
+		}
+
+		pci_unmap_single(priv->pci_dev, dma_addr, buf_len,
+				 PCI_DMA_TODEVICE);
 		nfreed++;
 	}
 }
@@ -1169,7 +1200,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
-	cmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
+	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
 
 	/* Input error checking is done when commands are added to queue. */
 	if (cmd->meta.flags & CMD_WANT_SKB) {
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

