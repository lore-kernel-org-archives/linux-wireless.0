Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54762 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752915AbcIOSLt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:11:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:14 +0300
Message-Id: <20160915181131.32213-8-luca@coelho.fi> (sfid-20160915_201158_727614_B829D0D9)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 08/25] iwlwifi: pcie: assign and access a000 TFD & TBs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Previous patch introduced the new formats. This patch
allocates the new structures and adjusts code accordingly.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  19 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  16 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 141 ++++++++++++++-------
 3 files changed, 120 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index b9dc82b..d185692 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -280,7 +280,7 @@ struct iwl_pcie_first_tb_buf {
  */
 struct iwl_txq {
 	struct iwl_queue q;
-	struct iwl_tfd *tfds;
+	void *tfds;
 	struct iwl_pcie_first_tb_buf *first_tb_bufs;
 	dma_addr_t first_tb_dma;
 	struct iwl_pcie_txq_entry *entries;
@@ -393,6 +393,7 @@ struct iwl_trans_pcie {
 	u8 n_no_reclaim_cmds;
 	u8 no_reclaim_cmds[MAX_NO_RECLAIM_CMDS];
 	u8 max_tbs;
+	u16 tfd_size;
 
 	enum iwl_amsdu_size rx_buf_size;
 	bool bc_table_dword;
@@ -489,9 +490,21 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			    struct sk_buff_head *skbs);
 void iwl_trans_pcie_tx_reset(struct iwl_trans *trans);
 
-static inline u16 iwl_pcie_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
+static inline u16 iwl_pcie_tfd_tb_get_len(struct iwl_trans *trans, void *tfd,
+					  u8 idx)
 {
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+	struct iwl_tfd *tfd_fh;
+	struct iwl_tfd_tb *tb;
+
+	if (trans->cfg->use_tfh) {
+		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
+		struct iwl_tfh_tb *tb = &tfd_fh->tbs[idx];
+
+		return le16_to_cpu(tb->tb_len);
+	}
+
+	tfd_fh = (void *)tfd;
+	tb = &tfd_fh->tbs[idx];
 
 	return le16_to_cpu(tb->hi_n_len) >> 4;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 21b1be1..e908bb8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2437,15 +2437,14 @@ err:
 }
 #endif /*CONFIG_IWLWIFI_DEBUGFS */
 
-static u32 iwl_trans_pcie_get_cmdlen(struct iwl_trans *trans,
-				     struct iwl_tfd *tfd)
+static u32 iwl_trans_pcie_get_cmdlen(struct iwl_trans *trans, void *tfd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 cmdlen = 0;
 	int i;
 
 	for (i = 0; i < trans_pcie->max_tbs; i++)
-		cmdlen += iwl_pcie_tfd_tb_get_len(tfd, i);
+		cmdlen += iwl_pcie_tfd_tb_get_len(trans, tfd, i);
 
 	return cmdlen;
 }
@@ -2733,7 +2732,8 @@ static struct iwl_trans_dump_data
 		u8 idx = get_cmd_index(&cmdq->q, ptr);
 		u32 caplen, cmdlen;
 
-		cmdlen = iwl_trans_pcie_get_cmdlen(trans, &cmdq->tfds[ptr]);
+		cmdlen = iwl_trans_pcie_get_cmdlen(trans, cmdq->tfds +
+						   trans_pcie->tfd_size * ptr);
 		caplen = min_t(u32, TFD_MAX_PAYLOAD_SIZE, cmdlen);
 
 		if (cmdlen) {
@@ -2876,10 +2876,14 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	else
 		addr_size = 36;
 
-	if (cfg->use_tfh)
+	if (cfg->use_tfh) {
 		trans_pcie->max_tbs = IWL_TFH_NUM_TBS;
-	else
+		trans_pcie->tfd_size = sizeof(struct iwl_tfh_tb);
+
+	} else {
 		trans_pcie->max_tbs = IWL_NUM_OF_TBS;
+		trans_pcie->tfd_size = sizeof(struct iwl_tfd);
+	}
 	trans->max_skb_frags = IWL_PCIE_MAX_FRAGS(trans_pcie);
 
 	pci_set_master(pdev);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 57a657a..f893ee1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -312,11 +312,30 @@ void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans)
 	}
 }
 
-static inline dma_addr_t iwl_pcie_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
+static inline void *iwl_pcie_get_tfd(struct iwl_trans_pcie *trans_pcie,
+				     struct iwl_txq *txq, int idx)
 {
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+	return txq->tfds + trans_pcie->tfd_size * idx;
+}
+
+static inline dma_addr_t iwl_pcie_tfd_tb_get_addr(struct iwl_trans *trans,
+						  void *tfd, u8 idx)
+{
+	struct iwl_tfd *tfd_fh;
+	struct iwl_tfd_tb *tb;
+	dma_addr_t addr;
+
+	if (trans->cfg->use_tfh) {
+		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
+		struct iwl_tfh_tb *tb = &tfd_fh->tbs[idx];
+
+		return (dma_addr_t)(le64_to_cpu(tb->addr));
+	}
+
+	tfd_fh = (void *)tfd;
+	tb = &tfd_fh->tbs[idx];
+	addr = get_unaligned_le32(&tb->lo);
 
-	dma_addr_t addr = get_unaligned_le32(&tb->lo);
 	if (sizeof(dma_addr_t) > sizeof(u32))
 		addr |=
 		((dma_addr_t)(le16_to_cpu(tb->hi_n_len) & 0xF) << 16) << 16;
@@ -324,35 +343,57 @@ static inline dma_addr_t iwl_pcie_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
 	return addr;
 }
 
-static inline void iwl_pcie_tfd_set_tb(struct iwl_tfd *tfd, u8 idx,
-				       dma_addr_t addr, u16 len)
+static inline void iwl_pcie_tfd_set_tb(struct iwl_trans *trans, void *tfd,
+				       u8 idx, dma_addr_t addr, u16 len)
 {
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-	u16 hi_n_len = len << 4;
+	if (trans->cfg->use_tfh) {
+		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
+		struct iwl_tfh_tb *tb = &tfd_fh->tbs[idx];
 
-	put_unaligned_le32(addr, &tb->lo);
-	if (sizeof(dma_addr_t) > sizeof(u32))
-		hi_n_len |= ((addr >> 16) >> 16) & 0xF;
+		put_unaligned_le64(addr, &tb->addr);
+		tb->tb_len = cpu_to_le16(len);
+
+		tfd_fh->num_tbs = cpu_to_le16(idx + 1);
+	} else {
+		struct iwl_tfd *tfd_fh = (void *)tfd;
+		struct iwl_tfd_tb *tb = &tfd_fh->tbs[idx];
 
-	tb->hi_n_len = cpu_to_le16(hi_n_len);
+		u16 hi_n_len = len << 4;
 
-	tfd->num_tbs = idx + 1;
+		put_unaligned_le32(addr, &tb->lo);
+		if (sizeof(dma_addr_t) > sizeof(u32))
+			hi_n_len |= ((addr >> 16) >> 16) & 0xF;
+
+		tb->hi_n_len = cpu_to_le16(hi_n_len);
+
+		tfd_fh->num_tbs = idx + 1;
+	}
 }
 
-static inline u8 iwl_pcie_tfd_get_num_tbs(struct iwl_tfd *tfd)
+static inline u8 iwl_pcie_tfd_get_num_tbs(struct iwl_trans *trans, void *tfd)
 {
-	return tfd->num_tbs & 0x1f;
+	struct iwl_tfd *tfd_fh;
+
+	if (trans->cfg->use_tfh) {
+		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
+
+		return le16_to_cpu(tfd_fh->num_tbs) & 0x1f;
+	}
+
+	tfd_fh = (void *)tfd;
+	return tfd_fh->num_tbs & 0x1f;
 }
 
 static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
 			       struct iwl_cmd_meta *meta,
-			       struct iwl_tfd *tfd)
+			       struct iwl_txq *txq, int index)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i, num_tbs;
+	void *tfd = iwl_pcie_get_tfd(trans_pcie, txq, index);
 
 	/* Sanity check on number of chunks */
-	num_tbs = iwl_pcie_tfd_get_num_tbs(tfd);
+	num_tbs = iwl_pcie_tfd_get_num_tbs(trans, tfd);
 
 	if (num_tbs >= trans_pcie->max_tbs) {
 		IWL_ERR(trans, "Too many chunks: %i\n", num_tbs);
@@ -365,16 +406,28 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
 	for (i = 1; i < num_tbs; i++) {
 		if (meta->tbs & BIT(i))
 			dma_unmap_page(trans->dev,
-				       iwl_pcie_tfd_tb_get_addr(tfd, i),
-				       iwl_pcie_tfd_tb_get_len(tfd, i),
+				       iwl_pcie_tfd_tb_get_addr(trans, tfd, i),
+				       iwl_pcie_tfd_tb_get_len(trans, tfd, i),
 				       DMA_TO_DEVICE);
 		else
 			dma_unmap_single(trans->dev,
-					 iwl_pcie_tfd_tb_get_addr(tfd, i),
-					 iwl_pcie_tfd_tb_get_len(tfd, i),
+					 iwl_pcie_tfd_tb_get_addr(trans, tfd,
+								  i),
+					 iwl_pcie_tfd_tb_get_len(trans, tfd,
+								 i),
 					 DMA_TO_DEVICE);
 	}
-	tfd->num_tbs = 0;
+
+	if (trans->cfg->use_tfh) {
+		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
+
+		tfd_fh->num_tbs = 0;
+	} else {
+		struct iwl_tfd *tfd_fh = (void *)tfd;
+
+		tfd_fh->num_tbs = 0;
+	}
+
 }
 
 /*
@@ -388,8 +441,6 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
  */
 static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 {
-	struct iwl_tfd *tfd_tmp = txq->tfds;
-
 	/* rd_ptr is bounded by TFD_QUEUE_SIZE_MAX and
 	 * idx is bounded by n_window
 	 */
@@ -401,7 +452,7 @@ static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 	/* We have only q->n_window txq->entries, but we use
 	 * TFD_QUEUE_SIZE_MAX tfds
 	 */
-	iwl_pcie_tfd_unmap(trans, &txq->entries[idx].meta, &tfd_tmp[rd_ptr]);
+	iwl_pcie_tfd_unmap(trans, &txq->entries[idx].meta, txq, rd_ptr);
 
 	/* free SKB */
 	if (txq->entries) {
@@ -425,19 +476,18 @@ static int iwl_pcie_txq_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_queue *q;
-	struct iwl_tfd *tfd, *tfd_tmp;
+	void *tfd;
 	u32 num_tbs;
 
 	q = &txq->q;
-	tfd_tmp = txq->tfds;
-	tfd = &tfd_tmp[q->write_ptr];
+	tfd = txq->tfds + trans_pcie->tfd_size * q->write_ptr;
 
 	if (reset)
-		memset(tfd, 0, sizeof(*tfd));
+		memset(tfd, 0, trans_pcie->tfd_size);
 
-	num_tbs = iwl_pcie_tfd_get_num_tbs(tfd);
+	num_tbs = iwl_pcie_tfd_get_num_tbs(trans, tfd);
 
-	/* Each TFD can point to a maximum 20 Tx buffers */
+	/* Each TFD can point to a maximum max_tbs Tx buffers */
 	if (num_tbs >= trans_pcie->max_tbs) {
 		IWL_ERR(trans, "Error can not send more than %d chunks\n",
 			trans_pcie->max_tbs);
@@ -448,7 +498,7 @@ static int iwl_pcie_txq_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
 		 "Unaligned address = %llx\n", (unsigned long long)addr))
 		return -EINVAL;
 
-	iwl_pcie_tfd_set_tb(tfd, num_tbs, addr, len);
+	iwl_pcie_tfd_set_tb(trans, tfd, num_tbs, addr, len);
 
 	return num_tbs;
 }
@@ -458,7 +508,7 @@ static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 			       u32 txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	size_t tfd_sz = sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX;
+	size_t tfd_sz = trans_pcie->tfd_size * TFD_QUEUE_SIZE_MAX;
 	size_t tb0_buf_sz;
 	int i;
 
@@ -672,7 +722,7 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 	/* De-alloc circular buffer of TFDs */
 	if (txq->tfds) {
 		dma_free_coherent(dev,
-				  sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX,
+				  trans_pcie->tfd_size * TFD_QUEUE_SIZE_MAX,
 				  txq->tfds, txq->q.dma_addr);
 		txq->q.dma_addr = 0;
 		txq->tfds = NULL;
@@ -1616,8 +1666,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 					   copy_size - tb0_size,
 					   DMA_TO_DEVICE);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
-			iwl_pcie_tfd_unmap(trans, out_meta,
-					   &txq->tfds[q->write_ptr]);
+			iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -1640,8 +1689,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		phys_addr = dma_map_single(trans->dev, (void *)data,
 					   cmdlen[i], DMA_TO_DEVICE);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
-			iwl_pcie_tfd_unmap(trans, out_meta,
-					   &txq->tfds[q->write_ptr]);
+			iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -1721,7 +1769,7 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 	meta = &txq->entries[cmd_index].meta;
 	cmd_id = iwl_cmd_id(cmd->hdr.cmd, group_id, 0);
 
-	iwl_pcie_tfd_unmap(trans, meta, &txq->tfds[index]);
+	iwl_pcie_tfd_unmap(trans, meta, txq, index);
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
@@ -1919,6 +1967,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 			     struct iwl_cmd_meta *out_meta,
 			     struct iwl_device_cmd *dev_cmd, u16 tb1_len)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_queue *q = &txq->q;
 	u16 tb2_len;
 	int i;
@@ -1934,8 +1983,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 						     skb->data + hdr_len,
 						     tb2_len, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(trans->dev, tb2_phys))) {
-			iwl_pcie_tfd_unmap(trans, out_meta,
-					   &txq->tfds[q->write_ptr]);
+			iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
 			return -EINVAL;
 		}
 		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, false);
@@ -1954,8 +2002,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 					   skb_frag_size(frag), DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
-			iwl_pcie_tfd_unmap(trans, out_meta,
-					   &txq->tfds[q->write_ptr]);
+			iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
 			return -EINVAL;
 		}
 		tb_idx = iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
@@ -1965,8 +2012,8 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 	}
 
 	trace_iwlwifi_dev_tx(trans->dev, skb,
-			     &txq->tfds[txq->q.write_ptr],
-			     sizeof(struct iwl_tfd),
+			     iwl_pcie_get_tfd(trans_pcie, txq, q->write_ptr),
+			     trans_pcie->tfd_size,
 			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
 			     skb->data + hdr_len, tb2_len);
 	trace_iwlwifi_dev_tx_data(trans->dev, skb,
@@ -2041,8 +2088,8 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 		IEEE80211_CCMP_HDR_LEN : 0;
 
 	trace_iwlwifi_dev_tx(trans->dev, skb,
-			     &txq->tfds[txq->q.write_ptr],
-			     sizeof(struct iwl_tfd),
+			     iwl_pcie_get_tfd(trans_pcie, txq, q->write_ptr),
+			     trans_pcie->tfd_size,
 			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
 			     NULL, 0);
 
@@ -2198,7 +2245,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 	return 0;
 
 out_unmap:
-	iwl_pcie_tfd_unmap(trans, out_meta, &txq->tfds[q->write_ptr]);
+	iwl_pcie_tfd_unmap(trans, out_meta, txq, q->write_ptr);
 	return ret;
 }
 #else /* CONFIG_INET */
-- 
2.9.3
