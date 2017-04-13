Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51458 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754626AbdDMP1c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:27:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:59 +0300
Message-Id: <20170413152507.9648-19-luca@coelho.fi> (sfid-20170413_172736_235376_ADB43627)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 18/26] iwlwifi: pcie: cleanup old transport code from gen2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Cleanup code that is irrelevant for a000 devices.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   4 -
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 195 +++------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   8 +-
 3 files changed, 30 insertions(+), 177 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index b9afffae8a4d..bd358895caee 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -766,10 +766,6 @@ void iwl_pcie_synchronize_irqs(struct iwl_trans *trans);
 bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans);
 void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq);
 int iwl_queue_space(const struct iwl_txq *q);
-int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
-			    struct iwl_txq *txq, u8 hdr_len,
-			    struct iwl_cmd_meta *out_meta,
-			    struct iwl_device_cmd *dev_cmd, u16 tb1_len);
 
 /* transport gen 2 exported functions */
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 2ddaf7a1a1b5..3a36bda5fd27 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -98,88 +98,23 @@ static void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans *trans,
 static void iwl_pcie_gen2_txq_inc_wr_ptr(struct iwl_trans *trans,
 					 struct iwl_txq *txq)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 reg = 0;
-	int txq_id = txq->id;
-
 	lockdep_assert_held(&txq->lock);
 
-	/*
-	 * explicitly wake up the NIC if:
-	 * 1. shadow registers aren't enabled
-	 * 2. NIC is woken up for CMD regardless of shadow outside this function
-	 * 3. there is a chance that the NIC is asleep
-	 */
-	if (!trans->cfg->base_params->shadow_reg_enable &&
-	    txq_id != trans_pcie->cmd_queue &&
-	    test_bit(STATUS_TPOWER_PMI, &trans->status)) {
-		/*
-		 * wake up nic if it's powered down ...
-		 * uCode will wake up, and interrupt us again, so next
-		 * time we'll skip this part.
-		 */
-		reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
-
-		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			IWL_DEBUG_INFO(trans,
-				       "Tx queue %d requesting wakeup, GP1 = 0x%x\n",
-				       txq_id, reg);
-			iwl_set_bit(trans, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			txq->need_update = true;
-			return;
-		}
-	}
+	IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq->id, txq->write_ptr);
 
 	/*
 	 * if not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx).
 	 */
-	IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id, txq->write_ptr);
 	if (!txq->block)
 		iwl_write32(trans, HBUS_TARG_WRPTR,
-			    txq->write_ptr | (txq_id << 8));
+			    txq->write_ptr | (txq->id << 8));
 }
 
-static inline u8 iwl_pcie_gen2_get_num_tbs(struct iwl_trans *trans, void *_tfd)
+static u8 iwl_pcie_gen2_get_num_tbs(struct iwl_trans *trans,
+				    struct iwl_tfh_tfd *tfd)
 {
-	if (trans->cfg->use_tfh) {
-		struct iwl_tfh_tfd *tfd = _tfd;
-
-		return le16_to_cpu(tfd->num_tbs) & 0x1f;
-	} else {
-		struct iwl_tfd *tfd = _tfd;
-
-		return tfd->num_tbs & 0x1f;
-	}
-}
-
-static inline dma_addr_t iwl_pcie_gen2_tb_get_addr(struct iwl_trans *trans,
-						   void *_tfd, u8 idx)
-{
-	if (trans->cfg->use_tfh) {
-		struct iwl_tfh_tfd *tfd = _tfd;
-		struct iwl_tfh_tb *tb = &tfd->tbs[idx];
-
-		return (dma_addr_t)(le64_to_cpu(tb->addr));
-	} else {
-		struct iwl_tfd *tfd = _tfd;
-		struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-		dma_addr_t addr = get_unaligned_le32(&tb->lo);
-		dma_addr_t hi_len;
-
-		if (sizeof(dma_addr_t) <= sizeof(u32))
-			return addr;
-
-		hi_len = le16_to_cpu(tb->hi_n_len) & 0xF;
-
-		/*
-		 * shift by 16 twice to avoid warnings on 32-bit
-		 * (where this code never runs anyway due to the
-		 * if statement above)
-		 */
-		return addr | ((hi_len << 16) << 16);
-	}
+	return le16_to_cpu(tfd->num_tbs) & 0x1f;
 }
 
 static void iwl_pcie_gen2_tfd_unmap(struct iwl_trans *trans,
@@ -188,45 +123,31 @@ static void iwl_pcie_gen2_tfd_unmap(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i, num_tbs;
-	void *tfd = iwl_pcie_get_tfd(trans_pcie, txq, index);
+	struct iwl_tfh_tfd *tfd = iwl_pcie_get_tfd(trans_pcie, txq, index);
 
 	/* Sanity check on number of chunks */
 	num_tbs = iwl_pcie_gen2_get_num_tbs(trans, tfd);
 
 	if (num_tbs >= trans_pcie->max_tbs) {
 		IWL_ERR(trans, "Too many chunks: %i\n", num_tbs);
-		/* @todo issue fatal error, it is quite serious situation */
 		return;
 	}
 
 	/* first TB is never freed - it's the bidirectional DMA data */
-
 	for (i = 1; i < num_tbs; i++) {
 		if (meta->tbs & BIT(i))
 			dma_unmap_page(trans->dev,
-				       iwl_pcie_gen2_tb_get_addr(trans, tfd,
-								 i),
-				       iwl_pcie_gen2_tb_get_addr(trans, tfd,
-								 i),
+				       le64_to_cpu(tfd->tbs[i].addr),
+				       le16_to_cpu(tfd->tbs[i].tb_len),
 				       DMA_TO_DEVICE);
 		else
 			dma_unmap_single(trans->dev,
-					 iwl_pcie_gen2_tb_get_addr(trans, tfd,
-								   i),
-					 iwl_pcie_gen2_tb_get_addr(trans, tfd,
-								   i),
+					 le64_to_cpu(tfd->tbs[i].addr),
+					 le16_to_cpu(tfd->tbs[i].tb_len),
 					 DMA_TO_DEVICE);
 	}
 
-	if (trans->cfg->use_tfh) {
-		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
-
-		tfd_fh->num_tbs = 0;
-	} else {
-		struct iwl_tfd *tfd_fh = (void *)tfd;
-
-		tfd_fh->num_tbs = 0;
-	}
+	tfd->num_tbs = 0;
 }
 
 static void iwl_pcie_gen2_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
@@ -264,27 +185,13 @@ static void iwl_pcie_gen2_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 static inline void iwl_pcie_gen2_set_tb(struct iwl_trans *trans, void *tfd,
 					u8 idx, dma_addr_t addr, u16 len)
 {
-	if (trans->cfg->use_tfh) {
-		struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
-		struct iwl_tfh_tb *tb = &tfd_fh->tbs[idx];
-
-		put_unaligned_le64(addr, &tb->addr);
-		tb->tb_len = cpu_to_le16(len);
-
-		tfd_fh->num_tbs = cpu_to_le16(idx + 1);
-	} else {
-		struct iwl_tfd *tfd_fh = (void *)tfd;
-		struct iwl_tfd_tb *tb = &tfd_fh->tbs[idx];
+	struct iwl_tfh_tfd *tfd_fh = (void *)tfd;
+	struct iwl_tfh_tb *tb = &tfd_fh->tbs[idx];
 
-		u16 hi_n_len = len << 4;
+	put_unaligned_le64(addr, &tb->addr);
+	tb->tb_len = cpu_to_le16(len);
 
-		put_unaligned_le32(addr, &tb->lo);
-		hi_n_len |= iwl_get_dma_hi_addr(addr);
-
-		tb->hi_n_len = cpu_to_le16(hi_n_len);
-
-		tfd_fh->num_tbs = idx + 1;
-	}
+	tfd_fh->num_tbs = cpu_to_le16(idx + 1);
 }
 
 int iwl_pcie_gen2_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
@@ -391,11 +298,9 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	void *tb1_addr;
 	void *tfd;
 	u16 len, tb1_len;
-	bool wait_write_ptr;
 	__le16 fc;
 	u8 hdr_len;
 	u16 wifi_seq;
-	bool amsdu;
 
 	txq = &trans_pcie->txq[txq_id];
 
@@ -403,21 +308,6 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      "TX on unused queue %d\n", txq_id))
 		return -EINVAL;
 
-	if (unlikely(trans_pcie->sw_csum_tx &&
-		     skb->ip_summed == CHECKSUM_PARTIAL)) {
-		int offs = skb_checksum_start_offset(skb);
-		int csum_offs = offs + skb->csum_offset;
-		__wsum csum;
-
-		if (skb_ensure_writable(skb, csum_offs + sizeof(__sum16)))
-			return -1;
-
-		csum = skb_checksum(skb, offs, skb->len - offs, 0);
-		*(__sum16 *)(skb->data + csum_offs) = csum_fold(csum);
-
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-	}
-
 	if (skb_is_nonlinear(skb) &&
 	    skb_shinfo(skb)->nr_frags > IWL_PCIE_MAX_FRAGS(trans_pcie) &&
 	    __skb_linearize(skb))
@@ -432,24 +322,6 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	spin_lock(&txq->lock);
 
-	if (iwl_queue_space(txq) < txq->high_mark) {
-		iwl_stop_queue(trans, txq);
-
-		/* don't put the packet on the ring, if there is no room */
-		if (unlikely(iwl_queue_space(txq) < 3)) {
-			struct iwl_device_cmd **dev_cmd_ptr;
-
-			dev_cmd_ptr = (void *)((u8 *)skb->cb +
-					       trans_pcie->dev_cmd_offs);
-
-			*dev_cmd_ptr = dev_cmd;
-			__skb_queue_tail(&txq->overflow_q, skb);
-
-			spin_unlock(&txq->lock);
-			return 0;
-		}
-	}
-
 	/* In AGG mode, the index in the ring must correspond to the WiFi
 	 * sequence number. This is a HW requirements to help the SCD to parse
 	 * the BA.
@@ -488,18 +360,10 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	 */
 	len = sizeof(struct iwl_tx_cmd) + sizeof(struct iwl_cmd_header) +
 	      hdr_len - IWL_FIRST_TB_SIZE;
-	/* do not align A-MSDU to dword as the subframe header aligns it */
-	amsdu = ieee80211_is_data_qos(fc) &&
-		(*ieee80211_get_qos_ctl(hdr) &
-		 IEEE80211_QOS_CTL_A_MSDU_PRESENT);
-	if (trans_pcie->sw_csum_tx || !amsdu) {
-		tb1_len = ALIGN(len, 4);
-		/* Tell NIC about any 2-byte padding after MAC header */
-		if (tb1_len != len)
-			tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
-	} else {
-		tb1_len = len;
-	}
+	tb1_len = ALIGN(len, 4);
+	/* Tell NIC about any 2-byte padding after MAC header */
+	if (tb1_len != len)
+		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
 
 	/*
 	 * The first TB points to bi-directional DMA data, we'll
@@ -517,15 +381,9 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		goto out_err;
 	iwl_pcie_gen2_build_tfd(trans, txq, tb1_phys, tb1_len, false);
 
-	if (amsdu) {
-		if (unlikely(iwl_fill_data_tbs_amsdu(trans, skb, txq, hdr_len,
-						     out_meta, dev_cmd,
-						     tb1_len)))
-			goto out_err;
-	} else if (unlikely(iwl_fill_data_tbs(trans, skb, txq, hdr_len,
-				       out_meta, dev_cmd, tb1_len))) {
+	if (unlikely(iwl_fill_data_tbs(trans, skb, txq, hdr_len,
+				       out_meta, dev_cmd, tb1_len)))
 		goto out_err;
-	}
 
 	/* building the A-MSDU might have changed this data, so memcpy it now */
 	memcpy(&txq->first_tb_bufs[txq->write_ptr], &dev_cmd->hdr,
@@ -536,8 +394,6 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	iwl_pcie_gen2_update_byte_tbl(trans, txq, le16_to_cpu(tx_cmd->len),
 				      iwl_pcie_gen2_get_num_tbs(trans, tfd));
 
-	wait_write_ptr = ieee80211_has_morefrags(fc);
-
 	/* start timer if queue currently empty */
 	if (txq->read_ptr == txq->write_ptr) {
 		if (txq->wd_timeout) {
@@ -559,8 +415,9 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	txq->write_ptr = iwl_queue_inc_wrap(txq->write_ptr);
-	if (!wait_write_ptr)
-		iwl_pcie_gen2_txq_inc_wr_ptr(trans, txq);
+	iwl_pcie_gen2_txq_inc_wr_ptr(trans, txq);
+	if (iwl_queue_space(txq) < txq->high_mark)
+		iwl_stop_queue(trans, txq);
 
 	/*
 	 * At this point the frame is "transmitted" successfully
@@ -586,7 +443,7 @@ void iwl_pcie_gen2_txq_unmap(struct iwl_trans *trans, int txq_id)
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
 				   txq_id, txq->read_ptr);
 
-		iwl_pcie_txq_free_tfd(trans, txq);
+		iwl_pcie_gen2_free_tfd(trans, txq);
 		txq->read_ptr = iwl_queue_inc_wrap(txq->read_ptr);
 
 		if (txq->read_ptr == txq->write_ptr) {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 9572330e22c0..d57310eaaef7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2080,10 +2080,10 @@ static void iwl_compute_pseudo_hdr_csum(void *iph, struct tcphdr *tcph,
 	}
 }
 
-int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
-			    struct iwl_txq *txq, u8 hdr_len,
-			    struct iwl_cmd_meta *out_meta,
-			    struct iwl_device_cmd *dev_cmd, u16 tb1_len)
+static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
+				   struct iwl_txq *txq, u8 hdr_len,
+				   struct iwl_cmd_meta *out_meta,
+				   struct iwl_device_cmd *dev_cmd, u16 tb1_len)
 {
 	struct iwl_tx_cmd *tx_cmd = (void *)dev_cmd->payload;
 	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
-- 
2.11.0
