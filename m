Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab3CDOA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/11] iwlwifi: use coherent DMA memory for command header
Date: Mon,  4 Mar 2013 15:00:44 +0100
Message-Id: <1362405651-26456-4-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150111_163094_C0CCE557)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Recently in commit 8a964f44e01ad3bbc208c3e80d931ba91b9ea786
("iwlwifi: always copy first 16 bytes of commands") we fixed
the problem that the hardware writes back to the command and
that could overwrite parts of the data that was still needed
and would thus be corrupted.

Investigating this problem more closely we found that this
write-back isn't really ordered very well with respect to
other DMA traffic. Therefore, it sometimes happened that the
write-back occurred after unmapping the command again which
is clearly an issue and could corrupt the next allocation
that goes to that spot, or (better) cause IOMMU faults.

To fix this, allocate coherent memory for the first 16 bytes
of each command, containing the write-back part, and use it
for all queues. All the dynamic DMA mappings only need to be
TO_DEVICE then. This ensures that even when the write-back
happens "too late" it can't hit memory that has been freed
or a mapping that doesn't exist any more.

Since now the actual command is no longer modified, we can
also remove CMD_WANT_HCMD and get rid of the DMA sync that
was necessary to update the scratch pointer.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/sta.c       |   2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   8 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h |  34 +++--
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  14 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 221 +++++++++++++--------------
 5 files changed, 137 insertions(+), 142 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index 94ef338..b775769 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -151,7 +151,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		       sta_id, sta->sta.addr, flags & CMD_ASYNC ?  "a" : "");
 
 	if (!(flags & CMD_ASYNC)) {
-		cmd.flags |= CMD_WANT_SKB | CMD_WANT_HCMD;
+		cmd.flags |= CMD_WANT_SKB;
 		might_sleep();
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 058947f..0cac2b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -186,19 +186,13 @@ struct iwl_rx_packet {
  * @CMD_ASYNC: Return right away and don't want for the response
  * @CMD_WANT_SKB: valid only with CMD_SYNC. The caller needs the buffer of the
  *	response. The caller needs to call iwl_free_resp when done.
- * @CMD_WANT_HCMD: The caller needs to get the HCMD that was sent in the
- *	response handler. Chunks flagged by %IWL_HCMD_DFL_NOCOPY won't be
- *	copied. The pointer passed to the response handler is in the transport
- *	ownership and don't need to be freed by the op_mode. This also means
- *	that the pointer is invalidated after the op_mode's handler returns.
  * @CMD_ON_DEMAND: This command is sent by the test mode pipe.
  */
 enum CMD_MODE {
 	CMD_SYNC		= 0,
 	CMD_ASYNC		= BIT(0),
 	CMD_WANT_SKB		= BIT(1),
-	CMD_WANT_HCMD		= BIT(2),
-	CMD_ON_DEMAND		= BIT(3),
+	CMD_ON_DEMAND		= BIT(2),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 3d62e80..148843e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -137,10 +137,6 @@ static inline int iwl_queue_dec_wrap(int index, int n_bd)
 struct iwl_cmd_meta {
 	/* only for SYNC commands, iff the reply skb is wanted */
 	struct iwl_host_cmd *source;
-
-	DEFINE_DMA_UNMAP_ADDR(mapping);
-	DEFINE_DMA_UNMAP_LEN(len);
-
 	u32 flags;
 };
 
@@ -185,25 +181,36 @@ struct iwl_queue {
 /*
  * The FH will write back to the first TB only, so we need
  * to copy some data into the buffer regardless of whether
- * it should be mapped or not. This indicates how much to
- * copy, even for HCMDs it must be big enough to fit the
- * DRAM scratch from the TX cmd, at least 16 bytes.
+ * it should be mapped or not. This indicates how big the
+ * first TB must be to include the scratch buffer. Since
+ * the scratch is 4 bytes at offset 12, it's 16 now. If we
+ * make it bigger then allocations will be bigger and copy
+ * slower, so that's probably not useful.
  */
-#define IWL_HCMD_MIN_COPY_SIZE	16
+#define IWL_HCMD_SCRATCHBUF_SIZE	16
 
 struct iwl_pcie_txq_entry {
 	struct iwl_device_cmd *cmd;
-	struct iwl_device_cmd *copy_cmd;
 	struct sk_buff *skb;
 	/* buffer to free after command completes */
 	const void *free_buf;
 	struct iwl_cmd_meta meta;
 };
 
+struct iwl_pcie_txq_scratch_buf {
+	struct iwl_cmd_header hdr;
+	u8 buf[8];
+	__le32 scratch;
+};
+
 /**
  * struct iwl_txq - Tx Queue for DMA
  * @q: generic Rx/Tx queue descriptor
  * @tfds: transmit frame descriptors (DMA memory)
+ * @scratchbufs: start of command headers, including scratch buffers, for
+ *	the writeback -- this is DMA memory and an array holding one buffer
+ *	for each command on the queue
+ * @scratchbufs_dma: DMA address for the scratchbufs start
  * @entries: transmit entries (driver state)
  * @lock: queue lock
  * @stuck_timer: timer that fires if queue gets stuck
@@ -217,6 +224,8 @@ struct iwl_pcie_txq_entry {
 struct iwl_txq {
 	struct iwl_queue q;
 	struct iwl_tfd *tfds;
+	struct iwl_pcie_txq_scratch_buf *scratchbufs;
+	dma_addr_t scratchbufs_dma;
 	struct iwl_pcie_txq_entry *entries;
 	spinlock_t lock;
 	struct timer_list stuck_timer;
@@ -225,6 +234,13 @@ struct iwl_txq {
 	u8 active;
 };
 
+static inline dma_addr_t
+iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
+{
+	return txq->scratchbufs_dma +
+	       sizeof(struct iwl_pcie_txq_scratch_buf) * idx;
+}
+
 /**
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index b0ae06d..567e67a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -637,22 +637,14 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		index = SEQ_TO_INDEX(sequence);
 		cmd_index = get_cmd_index(&txq->q, index);
 
-		if (reclaim) {
-			struct iwl_pcie_txq_entry *ent;
-			ent = &txq->entries[cmd_index];
-			cmd = ent->copy_cmd;
-			WARN_ON_ONCE(!cmd && ent->meta.flags & CMD_WANT_HCMD);
-		} else {
+		if (reclaim)
+			cmd = txq->entries[cmd_index].cmd;
+		else
 			cmd = NULL;
-		}
 
 		err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
 
 		if (reclaim) {
-			/* The original command isn't needed any more */
-			kfree(txq->entries[cmd_index].copy_cmd);
-			txq->entries[cmd_index].copy_cmd = NULL;
-			/* nor is the duplicated part of the command */
 			kfree(txq->entries[cmd_index].free_buf);
 			txq->entries[cmd_index].free_buf = NULL;
 		}
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index ff80a7e..8595c16 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -191,12 +191,9 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 	}
 
 	for (i = q->read_ptr; i != q->write_ptr;
-	     i = iwl_queue_inc_wrap(i, q->n_bd)) {
-		struct iwl_tx_cmd *tx_cmd =
-			(struct iwl_tx_cmd *)txq->entries[i].cmd->payload;
+	     i = iwl_queue_inc_wrap(i, q->n_bd))
 		IWL_ERR(trans, "scratch %d = 0x%08x\n", i,
-			get_unaligned_le32(&tx_cmd->scratch));
-	}
+			le32_to_cpu(txq->scratchbufs[i].scratch));
 
 	iwl_op_mode_nic_error(trans->op_mode);
 }
@@ -382,14 +379,8 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
 		return;
 	}
 
-	/* Unmap tx_cmd */
-	if (num_tbs)
-		dma_unmap_single(trans->dev,
-				dma_unmap_addr(meta, mapping),
-				dma_unmap_len(meta, len),
-				DMA_BIDIRECTIONAL);
+	/* first TB is never freed - it's the scratchbuf data */
 
-	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
 		dma_unmap_single(trans->dev, iwl_pcie_tfd_tb_get_addr(tfd, i),
 				 iwl_pcie_tfd_tb_get_len(tfd, i),
@@ -478,6 +469,7 @@ static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	size_t tfd_sz = sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX;
+	size_t scratchbuf_sz;
 	int i;
 
 	if (WARN_ON(txq->entries || txq->tfds))
@@ -513,9 +505,25 @@ static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 		IWL_ERR(trans, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
 		goto error;
 	}
+
+	BUILD_BUG_ON(IWL_HCMD_SCRATCHBUF_SIZE != sizeof(*txq->scratchbufs));
+	BUILD_BUG_ON(offsetof(struct iwl_pcie_txq_scratch_buf, scratch) !=
+			sizeof(struct iwl_cmd_header) +
+			offsetof(struct iwl_tx_cmd, scratch));
+
+	scratchbuf_sz = sizeof(*txq->scratchbufs) * slots_num;
+
+	txq->scratchbufs = dma_alloc_coherent(trans->dev, scratchbuf_sz,
+					      &txq->scratchbufs_dma,
+					      GFP_KERNEL);
+	if (!txq->scratchbufs)
+		goto err_free_tfds;
+
 	txq->q.id = txq_id;
 
 	return 0;
+err_free_tfds:
+	dma_free_coherent(trans->dev, tfd_sz, txq->tfds, txq->q.dma_addr);
 error:
 	if (txq->entries && txq_id == trans_pcie->cmd_queue)
 		for (i = 0; i < slots_num; i++)
@@ -600,7 +608,6 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 	if (txq_id == trans_pcie->cmd_queue)
 		for (i = 0; i < txq->q.n_window; i++) {
 			kfree(txq->entries[i].cmd);
-			kfree(txq->entries[i].copy_cmd);
 			kfree(txq->entries[i].free_buf);
 		}
 
@@ -609,6 +616,10 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 		dma_free_coherent(dev, sizeof(struct iwl_tfd) *
 				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 		txq->q.dma_addr = 0;
+
+		dma_free_coherent(dev,
+				  sizeof(*txq->scratchbufs) * txq->q.n_window,
+				  txq->scratchbufs, txq->scratchbufs_dma);
 	}
 
 	kfree(txq->entries);
@@ -1142,7 +1153,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	void *dup_buf = NULL;
 	dma_addr_t phys_addr;
 	int idx;
-	u16 copy_size, cmd_size, dma_size;
+	u16 copy_size, cmd_size, scratch_size;
 	bool had_nocopy = false;
 	int i;
 	u32 cmd_pos;
@@ -1162,9 +1173,9 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		if (!cmd->len[i])
 			continue;
 
-		/* need at least IWL_HCMD_MIN_COPY_SIZE copied */
-		if (copy_size < IWL_HCMD_MIN_COPY_SIZE) {
-			int copy = IWL_HCMD_MIN_COPY_SIZE - copy_size;
+		/* need at least IWL_HCMD_SCRATCHBUF_SIZE copied */
+		if (copy_size < IWL_HCMD_SCRATCHBUF_SIZE) {
+			int copy = IWL_HCMD_SCRATCHBUF_SIZE - copy_size;
 
 			if (copy > cmdlen[i])
 				copy = cmdlen[i];
@@ -1256,9 +1267,9 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		if (!cmd->len)
 			continue;
 
-		/* need at least IWL_HCMD_MIN_COPY_SIZE copied */
-		if (copy_size < IWL_HCMD_MIN_COPY_SIZE) {
-			copy = IWL_HCMD_MIN_COPY_SIZE - copy_size;
+		/* need at least IWL_HCMD_SCRATCHBUF_SIZE copied */
+		if (copy_size < IWL_HCMD_SCRATCHBUF_SIZE) {
+			copy = IWL_HCMD_SCRATCHBUF_SIZE - copy_size;
 
 			if (copy > cmd->len[i])
 				copy = cmd->len[i];
@@ -1276,48 +1287,36 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		}
 	}
 
-	WARN_ON_ONCE(txq->entries[idx].copy_cmd);
-
-	/*
-	 * since out_cmd will be the source address of the FH, it will write
-	 * the retry count there. So when the user needs to receivce the HCMD
-	 * that corresponds to the response in the response handler, it needs
-	 * to set CMD_WANT_HCMD.
-	 */
-	if (cmd->flags & CMD_WANT_HCMD) {
-		txq->entries[idx].copy_cmd =
-			kmemdup(out_cmd, cmd_pos, GFP_ATOMIC);
-		if (unlikely(!txq->entries[idx].copy_cmd)) {
-			idx = -ENOMEM;
-			goto out;
-		}
-	}
-
 	IWL_DEBUG_HC(trans,
 		     "Sending command %s (#%x), seq: 0x%04X, %d bytes at %d[%d]:%d\n",
 		     get_cmd_string(trans_pcie, out_cmd->hdr.cmd),
 		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
 		     cmd_size, q->write_ptr, idx, trans_pcie->cmd_queue);
 
-	/*
-	 * If the entire command is smaller than IWL_HCMD_MIN_COPY_SIZE, we must
-	 * still map at least that many bytes for the hardware to write back to.
-	 * We have enough space, so that's not a problem.
-	 */
-	dma_size = max_t(u16, copy_size, IWL_HCMD_MIN_COPY_SIZE);
+	/* start the TFD with the scratchbuf */
+	scratch_size = min_t(int, copy_size, IWL_HCMD_SCRATCHBUF_SIZE);
+	memcpy(&txq->scratchbufs[q->write_ptr], &out_cmd->hdr, scratch_size);
+	iwl_pcie_txq_build_tfd(trans, txq,
+			       iwl_pcie_get_scratchbuf_dma(txq, q->write_ptr),
+			       scratch_size, 1);
+
+	/* map first command fragment, if any remains */
+	if (copy_size > scratch_size) {
+		phys_addr = dma_map_single(trans->dev,
+					   ((u8 *)&out_cmd->hdr) + scratch_size,
+					   copy_size - scratch_size,
+					   DMA_TO_DEVICE);
+		if (dma_mapping_error(trans->dev, phys_addr)) {
+			iwl_pcie_tfd_unmap(trans, out_meta,
+					   &txq->tfds[q->write_ptr]);
+			idx = -ENOMEM;
+			goto out;
+		}
 
-	phys_addr = dma_map_single(trans->dev, &out_cmd->hdr, dma_size,
-				   DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(trans->dev, phys_addr))) {
-		idx = -ENOMEM;
-		goto out;
+		iwl_pcie_txq_build_tfd(trans, txq, phys_addr,
+				       copy_size - scratch_size, 0);
 	}
 
-	dma_unmap_addr_set(out_meta, mapping, phys_addr);
-	dma_unmap_len_set(out_meta, len, dma_size);
-
-	iwl_pcie_txq_build_tfd(trans, txq, phys_addr, copy_size, 1);
-
 	/* map the remaining (adjusted) nocopy/dup fragments */
 	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
 		const void *data = cmddata[i];
@@ -1586,10 +1585,9 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	struct iwl_cmd_meta *out_meta;
 	struct iwl_txq *txq;
 	struct iwl_queue *q;
-	dma_addr_t phys_addr = 0;
-	dma_addr_t txcmd_phys;
-	dma_addr_t scratch_phys;
-	u16 len, firstlen, secondlen;
+	dma_addr_t tb0_phys, tb1_phys, scratch_phys;
+	void *tb1_addr;
+	u16 len, tb1_len, tb2_len;
 	u8 wait_write_ptr = 0;
 	__le16 fc = hdr->frame_control;
 	u8 hdr_len = ieee80211_hdrlen(fc);
@@ -1627,85 +1625,80 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
 			    INDEX_TO_SEQ(q->write_ptr)));
 
+	tb0_phys = iwl_pcie_get_scratchbuf_dma(txq, q->write_ptr);
+	scratch_phys = tb0_phys + sizeof(struct iwl_cmd_header) +
+		       offsetof(struct iwl_tx_cmd, scratch);
+
+	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
+	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
+
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_meta = &txq->entries[q->write_ptr].meta;
 
 	/*
-	 * Use the first empty entry in this queue's command buffer array
-	 * to contain the Tx command and MAC header concatenated together
-	 * (payload data will be in another buffer).
-	 * Size of this varies, due to varying MAC header length.
-	 * If end is not dword aligned, we'll have 2 extra bytes at the end
-	 * of the MAC header (device reads on dword boundaries).
-	 * We'll tell device about this padding later.
+	 * The second TB (tb1) points to the remainder of the TX command
+	 * and the 802.11 header - dword aligned size
+	 * (This calculation modifies the TX command, so do it before the
+	 * setup of the first TB)
 	 */
-	len = sizeof(struct iwl_tx_cmd) +
-		sizeof(struct iwl_cmd_header) + hdr_len;
-	firstlen = (len + 3) & ~3;
+	len = sizeof(struct iwl_tx_cmd) + sizeof(struct iwl_cmd_header) +
+	      hdr_len - IWL_HCMD_SCRATCHBUF_SIZE;
+	tb1_len = (len + 3) & ~3;
 
 	/* Tell NIC about any 2-byte padding after MAC header */
-	if (firstlen != len)
+	if (tb1_len != len)
 		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
 
-	/* Physical address of this Tx command's header (not MAC header!),
-	 * within command buffer array. */
-	txcmd_phys = dma_map_single(trans->dev,
-				    &dev_cmd->hdr, firstlen,
-				    DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(trans->dev, txcmd_phys)))
-		goto out_err;
-	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
-	dma_unmap_len_set(out_meta, len, firstlen);
+	/* The first TB points to the scratchbuf data - min_copy bytes */
+	memcpy(&txq->scratchbufs[q->write_ptr], &dev_cmd->hdr,
+	       IWL_HCMD_SCRATCHBUF_SIZE);
+	iwl_pcie_txq_build_tfd(trans, txq, tb0_phys,
+			       IWL_HCMD_SCRATCHBUF_SIZE, 1);
 
-	if (!ieee80211_has_morefrags(fc)) {
-		txq->need_update = 1;
-	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
-	}
+	/* there must be data left over for TB1 or this code must be changed */
+	BUILD_BUG_ON(sizeof(struct iwl_tx_cmd) < IWL_HCMD_SCRATCHBUF_SIZE);
+
+	/* map the data for TB1 */
+	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_HCMD_SCRATCHBUF_SIZE;
+	tb1_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(trans->dev, tb1_phys)))
+		goto out_err;
+	iwl_pcie_txq_build_tfd(trans, txq, tb1_phys, tb1_len, 0);
 
-	/* Set up TFD's 2nd entry to point directly to remainder of skb,
-	 * if any (802.11 null frames have no payload). */
-	secondlen = skb->len - hdr_len;
-	if (secondlen > 0) {
-		phys_addr = dma_map_single(trans->dev, skb->data + hdr_len,
-					   secondlen, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, phys_addr))) {
-			dma_unmap_single(trans->dev,
-					 dma_unmap_addr(out_meta, mapping),
-					 dma_unmap_len(out_meta, len),
-					 DMA_BIDIRECTIONAL);
+	/*
+	 * Set up TFD's third entry to point directly to remainder
+	 * of skb, if any (802.11 null frames have no payload).
+	 */
+	tb2_len = skb->len - hdr_len;
+	if (tb2_len > 0) {
+		dma_addr_t tb2_phys = dma_map_single(trans->dev,
+						     skb->data + hdr_len,
+						     tb2_len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(trans->dev, tb2_phys))) {
+			iwl_pcie_tfd_unmap(trans, out_meta,
+					   &txq->tfds[q->write_ptr]);
 			goto out_err;
 		}
+		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, 0);
 	}
 
-	/* Attach buffers to TFD */
-	iwl_pcie_txq_build_tfd(trans, txq, txcmd_phys, firstlen, 1);
-	if (secondlen > 0)
-		iwl_pcie_txq_build_tfd(trans, txq, phys_addr, secondlen, 0);
-
-	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
-				offsetof(struct iwl_tx_cmd, scratch);
-
-	/* take back ownership of DMA buffer to enable update */
-	dma_sync_single_for_cpu(trans->dev, txcmd_phys, firstlen,
-				DMA_BIDIRECTIONAL);
-	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
-
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len));
 
-	dma_sync_single_for_device(trans->dev, txcmd_phys, firstlen,
-				   DMA_BIDIRECTIONAL);
-
 	trace_iwlwifi_dev_tx(trans->dev, skb,
 			     &txq->tfds[txq->q.write_ptr],
 			     sizeof(struct iwl_tfd),
-			     &dev_cmd->hdr, firstlen,
-			     skb->data + hdr_len, secondlen);
+			     &dev_cmd->hdr, IWL_HCMD_SCRATCHBUF_SIZE + tb1_len,
+			     skb->data + hdr_len, tb2_len);
 	trace_iwlwifi_dev_tx_data(trans->dev, skb,
-				  skb->data + hdr_len, secondlen);
+				  skb->data + hdr_len, tb2_len);
+
+	if (!ieee80211_has_morefrags(fc)) {
+		txq->need_update = 1;
+	} else {
+		wait_write_ptr = 1;
+		txq->need_update = 0;
+	}
 
 	/* start timer if queue currently empty */
 	if (txq->need_update && q->read_ptr == q->write_ptr &&
-- 
1.8.0

