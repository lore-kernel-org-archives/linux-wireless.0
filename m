Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51840 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752941AbdDNJEh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:04:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:02:04 +0300
Message-Id: <20170414090210.31397-21-luca@coelho.fi> (sfid-20170414_110512_372565_98301CAB)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 20/26] iwlwifi: pcie: rewrite TFD creation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 215 +++++++++-------------
 1 file changed, 82 insertions(+), 133 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 67af73ef7d0d..4717440bc7f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -119,11 +119,10 @@ static u8 iwl_pcie_gen2_get_num_tbs(struct iwl_trans *trans,
 
 static void iwl_pcie_gen2_tfd_unmap(struct iwl_trans *trans,
 				    struct iwl_cmd_meta *meta,
-				    struct iwl_txq *txq, int index)
+				    struct iwl_tfh_tfd *tfd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i, num_tbs;
-	struct iwl_tfh_tfd *tfd = iwl_pcie_get_tfd(trans_pcie, txq, index);
 
 	/* Sanity check on number of chunks */
 	num_tbs = iwl_pcie_gen2_get_num_tbs(trans, tfd);
@@ -152,6 +151,8 @@ static void iwl_pcie_gen2_tfd_unmap(struct iwl_trans *trans,
 
 static void iwl_pcie_gen2_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
 	/* rd_ptr is bounded by TFD_QUEUE_SIZE_MAX and
 	 * idx is bounded by n_window
 	 */
@@ -163,7 +164,8 @@ static void iwl_pcie_gen2_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 	/* We have only q->n_window txq->entries, but we use
 	 * TFD_QUEUE_SIZE_MAX tfds
 	 */
-	iwl_pcie_gen2_tfd_unmap(trans, &txq->entries[idx].meta, txq, rd_ptr);
+	iwl_pcie_gen2_tfd_unmap(trans, &txq->entries[idx].meta,
+				iwl_pcie_get_tfd(trans_pcie, txq, rd_ptr));
 
 	/* free SKB */
 	if (txq->entries) {
@@ -182,79 +184,89 @@ static void iwl_pcie_gen2_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 	}
 }
 
-static inline void iwl_pcie_gen2_set_tb(struct iwl_trans *trans, void *tfd,
-					u8 idx, dma_addr_t addr, u16 len)
-{
-	struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
-	struct iwl_tfh_tb *tb = &tfd_fh->tbs[idx];
-
-	put_unaligned_le64(addr, &tb->addr);
-	tb->tb_len = cpu_to_le16(len);
-
-	tfd_fh->num_tbs = cpu_to_le16(idx + 1);
-}
-
-int iwl_pcie_gen2_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
-			    dma_addr_t addr, u16 len, bool reset)
+static int iwl_pcie_gen2_set_tb(struct iwl_trans *trans,
+				struct iwl_tfh_tfd *tfd, dma_addr_t addr,
+				u16 len)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	void *tfd;
-	u32 num_tbs;
-
-	tfd = txq->tfds + trans_pcie->tfd_size * txq->write_ptr;
-
-	if (reset)
-		memset(tfd, 0, trans_pcie->tfd_size);
-
-	num_tbs = iwl_pcie_gen2_get_num_tbs(trans, tfd);
+	int idx = iwl_pcie_gen2_get_num_tbs(trans, tfd);
+	struct iwl_tfh_tb *tb = &tfd->tbs[idx];
 
 	/* Each TFD can point to a maximum max_tbs Tx buffers */
-	if (num_tbs >= trans_pcie->max_tbs) {
+	if (tfd->num_tbs >= trans_pcie->max_tbs) {
 		IWL_ERR(trans, "Error can not send more than %d chunks\n",
 			trans_pcie->max_tbs);
 		return -EINVAL;
 	}
 
-	if (WARN(addr & ~IWL_TX_DMA_MASK,
-		 "Unaligned address = %llx\n", (unsigned long long)addr))
-		return -EINVAL;
+	put_unaligned_le64(addr, &tb->addr);
+	tb->tb_len = cpu_to_le16(len);
 
-	iwl_pcie_gen2_set_tb(trans, tfd, num_tbs, addr, len);
+	tfd->num_tbs = cpu_to_le16(idx + 1);
 
-	return num_tbs;
+	return idx;
 }
 
-static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
-			     struct iwl_txq *txq, u8 hdr_len,
-			     struct iwl_cmd_meta *out_meta,
-			     struct iwl_device_cmd *dev_cmd, u16 tb1_len)
+static
+struct iwl_tfh_tfd *iwl_pcie_gen2_build_tfd(struct iwl_trans *trans,
+					    struct iwl_txq *txq,
+					    struct iwl_device_cmd *dev_cmd,
+					    struct sk_buff *skb,
+					    struct iwl_cmd_meta *out_meta)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u16 tb2_len;
-	int i;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct iwl_tfh_tfd *tfd =
+		iwl_pcie_get_tfd(trans_pcie, txq, txq->write_ptr);
+	dma_addr_t tb_phys;
+	int i, len, tb1_len, tb2_len, hdr_len;
+	void *tb1_addr;
+
+	memset(tfd, 0, sizeof(*tfd));
+
+	tb_phys = iwl_pcie_get_first_tb_dma(txq, txq->write_ptr);
+	/* The first TB points to bi-directional DMA data */
+	memcpy(&txq->first_tb_bufs[txq->write_ptr], &dev_cmd->hdr,
+	       IWL_FIRST_TB_SIZE);
+
+	iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, IWL_FIRST_TB_SIZE);
+
+	/* there must be data left over for TB1 or this code must be changed */
+	BUILD_BUG_ON(sizeof(struct iwl_tx_cmd_gen2) < IWL_FIRST_TB_SIZE);
 
 	/*
-	 * Set up TFD's third entry to point directly to remainder
-	 * of skb's head, if any
+	 * The second TB (tb1) points to the remainder of the TX command
+	 * and the 802.11 header - dword aligned size
+	 * (This calculation modifies the TX command, so do it before the
+	 * setup of the first TB)
 	 */
+	len = sizeof(struct iwl_tx_cmd_gen2) + sizeof(struct iwl_cmd_header) +
+	      ieee80211_hdrlen(hdr->frame_control) - IWL_FIRST_TB_SIZE;
+
+	tb1_len = ALIGN(len, 4);
+
+	/* map the data for TB1 */
+	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
+	tb_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+		goto out_err;
+	iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, tb1_len);
+
+	/* set up TFD's third entry to point to remainder of skb's head */
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 	tb2_len = skb_headlen(skb) - hdr_len;
 
 	if (tb2_len > 0) {
-		dma_addr_t tb2_phys = dma_map_single(trans->dev,
-						     skb->data + hdr_len,
-						     tb2_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, tb2_phys))) {
-			iwl_pcie_gen2_tfd_unmap(trans, out_meta, txq,
-						txq->write_ptr);
-			return -EINVAL;
-		}
-		iwl_pcie_gen2_build_tfd(trans, txq, tb2_phys, tb2_len, false);
+		tb_phys = dma_map_single(trans->dev, skb->data + hdr_len,
+					 tb2_len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+			goto out_err;
+		iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, tb2_len);
 	}
 
 	/* set up the remaining entries to point to the data */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		dma_addr_t tb_phys;
 		int tb_idx;
 
 		if (!skb_frag_size(frag))
@@ -263,44 +275,35 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 		tb_phys = skb_frag_dma_map(trans->dev, frag, 0,
 					   skb_frag_size(frag), DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
-			iwl_pcie_gen2_tfd_unmap(trans, out_meta, txq,
-						txq->write_ptr);
-			return -EINVAL;
-		}
-		tb_idx = iwl_pcie_gen2_build_tfd(trans, txq, tb_phys,
-						 skb_frag_size(frag), false);
+		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+			goto out_err;
+		tb_idx = iwl_pcie_gen2_set_tb(trans, tfd, tb_phys,
+					      skb_frag_size(frag));
 
 		out_meta->tbs |= BIT(tb_idx);
 	}
 
-	trace_iwlwifi_dev_tx(trans->dev, skb,
-			     iwl_pcie_get_tfd(trans_pcie, txq, txq->write_ptr),
-			     trans_pcie->tfd_size,
-			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
+	trace_iwlwifi_dev_tx(trans->dev, skb, tfd, sizeof(*tfd), &dev_cmd->hdr,
+			     IWL_FIRST_TB_SIZE + tb1_len,
 			     skb->data + hdr_len, tb2_len);
-	trace_iwlwifi_dev_tx_data(trans->dev, skb,
-				  hdr_len, skb->len - hdr_len);
-	return 0;
+	trace_iwlwifi_dev_tx_data(trans->dev, skb, hdr_len,
+				  skb->len - hdr_len);
+
+	return tfd;
+
+out_err:
+	iwl_pcie_gen2_tfd_unmap(trans, out_meta, tfd);
+	return NULL;
 }
 
 int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			   struct iwl_device_cmd *dev_cmd, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct ieee80211_hdr *hdr;
 	struct iwl_tx_cmd_gen2 *tx_cmd = (void *)dev_cmd->payload;
 	struct iwl_cmd_meta *out_meta;
-	struct iwl_txq *txq;
-	dma_addr_t tb0_phys, tb1_phys, scratch_phys;
-	void *tb1_addr;
+	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
 	void *tfd;
-	u16 len, tb1_len;
-	__le16 fc;
-	u8 hdr_len;
-	u16 wifi_seq;
-
-	txq = &trans_pcie->txq[txq_id];
 
 	if (WARN_ONCE(!test_bit(txq_id, trans_pcie->queue_used),
 		      "TX on unused queue %d\n", txq_id))
@@ -311,26 +314,8 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	    __skb_linearize(skb))
 		return -ENOMEM;
 
-	/* mac80211 always puts the full header into the SKB's head,
-	 * so there's no need to check if it's readable there
-	 */
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-	hdr_len = ieee80211_hdrlen(fc);
-
 	spin_lock(&txq->lock);
 
-	/* In AGG mode, the index in the ring must correspond to the WiFi
-	 * sequence number. This is a HW requirements to help the SCD to parse
-	 * the BA.
-	 * Check here that the packets are in the right place on the ring.
-	 */
-	wifi_seq = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
-	WARN_ONCE(txq->ampdu &&
-		  (wifi_seq & 0xff) != txq->write_ptr,
-		  "Q: %d WiFi Seq %d tfdNum %d",
-		  txq_id, wifi_seq, txq->write_ptr);
-
 	/* Set up driver data for this TFD */
 	txq->entries[txq->write_ptr].skb = skb;
 	txq->entries[txq->write_ptr].cmd = dev_cmd;
@@ -339,49 +324,16 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
 			    INDEX_TO_SEQ(txq->write_ptr)));
 
-	tb0_phys = iwl_pcie_get_first_tb_dma(txq, txq->write_ptr);
-	scratch_phys = tb0_phys + sizeof(struct iwl_cmd_header) +
-		       offsetof(struct iwl_tx_cmd, scratch);
-
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_meta = &txq->entries[txq->write_ptr].meta;
 	out_meta->flags = 0;
 
-	/*
-	 * The second TB (tb1) points to the remainder of the TX command
-	 * and the 802.11 header - dword aligned size
-	 * (This calculation modifies the TX command, so do it before the
-	 * setup of the first TB)
-	 */
-	len = sizeof(struct iwl_tx_cmd) + sizeof(struct iwl_cmd_header) +
-	      hdr_len - IWL_FIRST_TB_SIZE;
-	tb1_len = ALIGN(len, 4);
-
-	/*
-	 * The first TB points to bi-directional DMA data, we'll
-	 * memcpy the data into it later.
-	 */
-	iwl_pcie_gen2_build_tfd(trans, txq, tb0_phys, IWL_FIRST_TB_SIZE, true);
-
-	/* there must be data left over for TB1 or this code must be changed */
-	BUILD_BUG_ON(sizeof(struct iwl_tx_cmd) < IWL_FIRST_TB_SIZE);
-
-	/* map the data for TB1 */
-	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
-	tb1_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(trans->dev, tb1_phys)))
-		goto out_err;
-	iwl_pcie_gen2_build_tfd(trans, txq, tb1_phys, tb1_len, false);
-
-	if (unlikely(iwl_fill_data_tbs(trans, skb, txq, hdr_len,
-				       out_meta, dev_cmd, tb1_len)))
-		goto out_err;
-
-	/* building the A-MSDU might have changed this data, so memcpy it now */
-	memcpy(&txq->first_tb_bufs[txq->write_ptr], &dev_cmd->hdr,
-	       IWL_FIRST_TB_SIZE);
+	tfd = iwl_pcie_gen2_build_tfd(trans, txq, dev_cmd, skb, out_meta);
+	if (!tfd) {
+		spin_unlock(&txq->lock);
+		return -1;
+	}
 
-	tfd = iwl_pcie_get_tfd(trans_pcie, txq, txq->write_ptr);
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_gen2_update_byte_tbl(trans, txq, le16_to_cpu(tx_cmd->len),
 				      iwl_pcie_gen2_get_num_tbs(trans, tfd));
@@ -417,9 +369,6 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	 */
 	spin_unlock(&txq->lock);
 	return 0;
-out_err:
-	spin_unlock(&txq->lock);
-	return -1;
 }
 
 /*
-- 
2.11.0
