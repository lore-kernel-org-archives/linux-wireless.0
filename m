Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33384 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbcGFKoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:45 +0300
Message-Id: <1467801651-1816-50-git-send-email-luca@coelho.fi> (sfid-20160706_124427_935216_0018CC40)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 50/56] iwlwifi: pcie: generalize and increase the size of scratchbuf
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently the scratch buffer is set to 16 bytes and indicates
the size of the bi-directional DMA.
However, next HW generation will perform additional offloading,
and will write the result in the key location of the TX command,
so the size of the bi-directional consistent memory should grow
accordingly - increase it to 40.
Generalize the code to get rid of now irrelevant scratch references.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 37 ++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 75 +++++++++++-----------
 2 files changed, 54 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 190f611..c3d8974 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -232,15 +232,16 @@ struct iwl_queue {
 #define TFD_CMD_SLOTS 32
 
 /*
- * The FH will write back to the first TB only, so we need
- * to copy some data into the buffer regardless of whether
- * it should be mapped or not. This indicates how big the
- * first TB must be to include the scratch buffer. Since
- * the scratch is 4 bytes at offset 12, it's 16 now. If we
- * make it bigger then allocations will be bigger and copy
- * slower, so that's probably not useful.
+ * The FH will write back to the first TB only, so we need to copy some data
+ * into the buffer regardless of whether it should be mapped or not.
+ * This indicates how big the first TB must be to include the scratch buffer
+ * and the assigned PN.
+ * Since PN location is 16 bytes at offset 24, it's 40 now.
+ * If we make it bigger then allocations will be bigger and copy slower, so
+ * that's probably not useful.
  */
-#define IWL_HCMD_SCRATCHBUF_SIZE	16
+#define IWL_FIRST_TB_SIZE	40
+#define IWL_FIRST_TB_SIZE_ALIGN ALIGN(IWL_FIRST_TB_SIZE, 64)
 
 struct iwl_pcie_txq_entry {
 	struct iwl_device_cmd *cmd;
@@ -250,20 +251,18 @@ struct iwl_pcie_txq_entry {
 	struct iwl_cmd_meta meta;
 };
 
-struct iwl_pcie_txq_scratch_buf {
-	struct iwl_cmd_header hdr;
-	u8 buf[8];
-	__le32 scratch;
+struct iwl_pcie_first_tb_buf {
+	u8 buf[IWL_FIRST_TB_SIZE_ALIGN];
 };
 
 /**
  * struct iwl_txq - Tx Queue for DMA
  * @q: generic Rx/Tx queue descriptor
  * @tfds: transmit frame descriptors (DMA memory)
- * @scratchbufs: start of command headers, including scratch buffers, for
+ * @first_tb_bufs: start of command headers, including scratch buffers, for
  *	the writeback -- this is DMA memory and an array holding one buffer
  *	for each command on the queue
- * @scratchbufs_dma: DMA address for the scratchbufs start
+ * @first_tb_dma: DMA address for the first_tb_bufs start
  * @entries: transmit entries (driver state)
  * @lock: queue lock
  * @stuck_timer: timer that fires if queue gets stuck
@@ -281,8 +280,8 @@ struct iwl_pcie_txq_scratch_buf {
 struct iwl_txq {
 	struct iwl_queue q;
 	struct iwl_tfd *tfds;
-	struct iwl_pcie_txq_scratch_buf *scratchbufs;
-	dma_addr_t scratchbufs_dma;
+	struct iwl_pcie_first_tb_buf *first_tb_bufs;
+	dma_addr_t first_tb_dma;
 	struct iwl_pcie_txq_entry *entries;
 	spinlock_t lock;
 	unsigned long frozen_expiry_remainder;
@@ -298,10 +297,10 @@ struct iwl_txq {
 };
 
 static inline dma_addr_t
-iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
+iwl_pcie_get_first_tb_dma(struct iwl_txq *txq, int idx)
 {
-	return txq->scratchbufs_dma +
-	       sizeof(struct iwl_pcie_txq_scratch_buf) * idx;
+	return txq->first_tb_dma +
+	       sizeof(struct iwl_pcie_first_tb_buf) * idx;
 }
 
 struct iwl_tso_hdr_page {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 2b68826..9a1c006 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -393,7 +393,7 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
 		return;
 	}
 
-	/* first TB is never freed - it's the scratchbuf data */
+	/* first TB is never freed - it's the bidirectional DMA data */
 
 	for (i = 1; i < num_tbs; i++) {
 		if (meta->flags & BIT(i + CMD_TB_BITMAP_POS))
@@ -491,7 +491,7 @@ static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	size_t tfd_sz = sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX;
-	size_t scratchbuf_sz;
+	size_t tb0_buf_sz;
 	int i;
 
 	if (WARN_ON(txq->entries || txq->tfds))
@@ -526,17 +526,14 @@ static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 	if (!txq->tfds)
 		goto error;
 
-	BUILD_BUG_ON(IWL_HCMD_SCRATCHBUF_SIZE != sizeof(*txq->scratchbufs));
-	BUILD_BUG_ON(offsetof(struct iwl_pcie_txq_scratch_buf, scratch) !=
-			sizeof(struct iwl_cmd_header) +
-			offsetof(struct iwl_tx_cmd, scratch));
+	BUILD_BUG_ON(IWL_FIRST_TB_SIZE_ALIGN != sizeof(*txq->first_tb_bufs));
 
-	scratchbuf_sz = sizeof(*txq->scratchbufs) * slots_num;
+	tb0_buf_sz = sizeof(*txq->first_tb_bufs) * slots_num;
 
-	txq->scratchbufs = dma_alloc_coherent(trans->dev, scratchbuf_sz,
-					      &txq->scratchbufs_dma,
+	txq->first_tb_bufs = dma_alloc_coherent(trans->dev, tb0_buf_sz,
+					      &txq->first_tb_dma,
 					      GFP_KERNEL);
-	if (!txq->scratchbufs)
+	if (!txq->first_tb_bufs)
 		goto err_free_tfds;
 
 	txq->q.id = txq_id;
@@ -708,8 +705,8 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 		txq->tfds = NULL;
 
 		dma_free_coherent(dev,
-				  sizeof(*txq->scratchbufs) * txq->q.n_window,
-				  txq->scratchbufs, txq->scratchbufs_dma);
+				  sizeof(*txq->first_tb_bufs) * txq->q.n_window,
+				  txq->first_tb_bufs, txq->first_tb_dma);
 	}
 
 	kfree(txq->entries);
@@ -1422,7 +1419,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	void *dup_buf = NULL;
 	dma_addr_t phys_addr;
 	int idx;
-	u16 copy_size, cmd_size, scratch_size;
+	u16 copy_size, cmd_size, tb0_size;
 	bool had_nocopy = false;
 	u8 group_id = iwl_cmd_groupid(cmd->id);
 	int i, ret;
@@ -1453,9 +1450,9 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		if (!cmd->len[i])
 			continue;
 
-		/* need at least IWL_HCMD_SCRATCHBUF_SIZE copied */
-		if (copy_size < IWL_HCMD_SCRATCHBUF_SIZE) {
-			int copy = IWL_HCMD_SCRATCHBUF_SIZE - copy_size;
+		/* need at least IWL_FIRST_TB_SIZE copied */
+		if (copy_size < IWL_FIRST_TB_SIZE) {
+			int copy = IWL_FIRST_TB_SIZE - copy_size;
 
 			if (copy > cmdlen[i])
 				copy = cmdlen[i];
@@ -1576,8 +1573,8 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		}
 
 		/*
-		 * Otherwise we need at least IWL_HCMD_SCRATCHBUF_SIZE copied
-		 * in total (for the scratchbuf handling), but copy up to what
+		 * Otherwise we need at least IWL_FIRST_TB_SIZE copied
+		 * in total (for bi-directional DMA), but copy up to what
 		 * we can fit into the payload for debug dump purposes.
 		 */
 		copy = min_t(int, TFD_MAX_PAYLOAD_SIZE - cmd_pos, cmd->len[i]);
@@ -1586,8 +1583,8 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		cmd_pos += copy;
 
 		/* However, treat copy_size the proper way, we need it below */
-		if (copy_size < IWL_HCMD_SCRATCHBUF_SIZE) {
-			copy = IWL_HCMD_SCRATCHBUF_SIZE - copy_size;
+		if (copy_size < IWL_FIRST_TB_SIZE) {
+			copy = IWL_FIRST_TB_SIZE - copy_size;
 
 			if (copy > cmd->len[i])
 				copy = cmd->len[i];
@@ -1602,18 +1599,18 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		     le16_to_cpu(out_cmd->hdr.sequence),
 		     cmd_size, q->write_ptr, idx, trans_pcie->cmd_queue);
 
-	/* start the TFD with the scratchbuf */
-	scratch_size = min_t(int, copy_size, IWL_HCMD_SCRATCHBUF_SIZE);
-	memcpy(&txq->scratchbufs[idx], &out_cmd->hdr, scratch_size);
+	/* start the TFD with the minimum copy bytes */
+	tb0_size = min_t(int, copy_size, IWL_FIRST_TB_SIZE);
+	memcpy(&txq->first_tb_bufs[idx], &out_cmd->hdr, tb0_size);
 	iwl_pcie_txq_build_tfd(trans, txq,
-			       iwl_pcie_get_scratchbuf_dma(txq, idx),
-			       scratch_size, true);
+			       iwl_pcie_get_first_tb_dma(txq, idx),
+			       tb0_size, true);
 
 	/* map first command fragment, if any remains */
-	if (copy_size > scratch_size) {
+	if (copy_size > tb0_size) {
 		phys_addr = dma_map_single(trans->dev,
-					   ((u8 *)&out_cmd->hdr) + scratch_size,
-					   copy_size - scratch_size,
+					   ((u8 *)&out_cmd->hdr) + tb0_size,
+					   copy_size - tb0_size,
 					   DMA_TO_DEVICE);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
 			iwl_pcie_tfd_unmap(trans, out_meta,
@@ -1623,7 +1620,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		}
 
 		iwl_pcie_txq_build_tfd(trans, txq, phys_addr,
-				       copy_size - scratch_size, false);
+				       copy_size - tb0_size, false);
 	}
 
 	/* map the remaining (adjusted) nocopy/dup fragments */
@@ -1968,7 +1965,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 	trace_iwlwifi_dev_tx(trans->dev, skb,
 			     &txq->tfds[txq->q.write_ptr],
 			     sizeof(struct iwl_tfd),
-			     &dev_cmd->hdr, IWL_HCMD_SCRATCHBUF_SIZE + tb1_len,
+			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
 			     skb->data + hdr_len, tb2_len);
 	trace_iwlwifi_dev_tx_data(trans->dev, skb,
 				  hdr_len, skb->len - hdr_len);
@@ -2044,7 +2041,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 	trace_iwlwifi_dev_tx(trans->dev, skb,
 			     &txq->tfds[txq->q.write_ptr],
 			     sizeof(struct iwl_tfd),
-			     &dev_cmd->hdr, IWL_HCMD_SCRATCHBUF_SIZE + tb1_len,
+			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
 			     NULL, 0);
 
 	ip_hdrlen = skb_transport_header(skb) - skb_network_header(skb);
@@ -2306,7 +2303,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
 			    INDEX_TO_SEQ(q->write_ptr)));
 
-	tb0_phys = iwl_pcie_get_scratchbuf_dma(txq, q->write_ptr);
+	tb0_phys = iwl_pcie_get_first_tb_dma(txq, q->write_ptr);
 	scratch_phys = tb0_phys + sizeof(struct iwl_cmd_header) +
 		       offsetof(struct iwl_tx_cmd, scratch);
 
@@ -2324,7 +2321,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	 * setup of the first TB)
 	 */
 	len = sizeof(struct iwl_tx_cmd) + sizeof(struct iwl_cmd_header) +
-	      hdr_len - IWL_HCMD_SCRATCHBUF_SIZE;
+	      hdr_len - IWL_FIRST_TB_SIZE;
 	/* do not align A-MSDU to dword as the subframe header aligns it */
 	amsdu = ieee80211_is_data_qos(fc) &&
 		(*ieee80211_get_qos_ctl(hdr) &
@@ -2338,17 +2335,17 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		tb1_len = len;
 	}
 
-	/* The first TB points to the scratchbuf data - min_copy bytes */
-	memcpy(&txq->scratchbufs[q->write_ptr], &dev_cmd->hdr,
-	       IWL_HCMD_SCRATCHBUF_SIZE);
+	/* The first TB points to bi-directional DMA data */
+	memcpy(&txq->first_tb_bufs[q->write_ptr], &dev_cmd->hdr,
+	       IWL_FIRST_TB_SIZE);
 	iwl_pcie_txq_build_tfd(trans, txq, tb0_phys,
-			       IWL_HCMD_SCRATCHBUF_SIZE, true);
+			       IWL_FIRST_TB_SIZE, true);
 
 	/* there must be data left over for TB1 or this code must be changed */
-	BUILD_BUG_ON(sizeof(struct iwl_tx_cmd) < IWL_HCMD_SCRATCHBUF_SIZE);
+	BUILD_BUG_ON(sizeof(struct iwl_tx_cmd) < IWL_FIRST_TB_SIZE);
 
 	/* map the data for TB1 */
-	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_HCMD_SCRATCHBUF_SIZE;
+	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
 	tb1_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(trans->dev, tb1_phys)))
 		goto out_err;
-- 
2.8.1

