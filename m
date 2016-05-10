Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40700 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbcEJU2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:28:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:35 +0300
Message-Id: <1462910797-20303-39-git-send-email-luca@coelho.fi> (sfid-20160510_222854_481557_775B8C30)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 39/41] iwlwifi: pcie: grab NIC access only once on RX init
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When initializing RX we grab NIC access for every read and
write. This is redundant - we can just grab access once.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 97 ++++++++++++++++------------
 1 file changed, 57 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 3477821..0a4a3c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -161,10 +161,11 @@ static inline __le32 iwl_pcie_dma_addr2rbd_ptr(dma_addr_t dma_addr)
 	return cpu_to_le32((u32)(dma_addr >> 8));
 }
 
-static void iwl_pcie_write_prph_64(struct iwl_trans *trans, u64 ofs, u64 val)
+static void iwl_pcie_write_prph_64_no_grab(struct iwl_trans *trans, u64 ofs,
+					   u64 val)
 {
-	iwl_write_prph(trans, ofs, val & 0xffffffff);
-	iwl_write_prph(trans, ofs + 4, val >> 32);
+	iwl_write_prph_no_grab(trans, ofs, val & 0xffffffff);
+	iwl_write_prph_no_grab(trans, ofs + 4, val >> 32);
 }
 
 /*
@@ -698,6 +699,7 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 rb_size;
+	unsigned long flags;
 	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
 
 	switch (trans_pcie->rx_buf_size) {
@@ -715,23 +717,26 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
 	}
 
+	if (!iwl_trans_grab_nic_access(trans, &flags))
+		return;
+
 	/* Stop Rx DMA */
-	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	iwl_write32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 	/* reset and flush pointers */
-	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_RBDCB_WPTR, 0);
-	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_FLUSH_RB_REQ, 0);
-	iwl_write_direct32(trans, FH_RSCSR_CHNL0_RDPTR, 0);
+	iwl_write32(trans, FH_MEM_RCSR_CHNL0_RBDCB_WPTR, 0);
+	iwl_write32(trans, FH_MEM_RCSR_CHNL0_FLUSH_RB_REQ, 0);
+	iwl_write32(trans, FH_RSCSR_CHNL0_RDPTR, 0);
 
 	/* Reset driver's Rx queue write index */
-	iwl_write_direct32(trans, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+	iwl_write32(trans, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
 
 	/* Tell device where to find RBD circular buffer in DRAM */
-	iwl_write_direct32(trans, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-			   (u32)(rxq->bd_dma >> 8));
+	iwl_write32(trans, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+		    (u32)(rxq->bd_dma >> 8));
 
 	/* Tell device where in DRAM to update its Rx status */
-	iwl_write_direct32(trans, FH_RSCSR_CHNL0_STTS_WPTR_REG,
-			   rxq->rb_stts_dma >> 4);
+	iwl_write32(trans, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+		    rxq->rb_stts_dma >> 4);
 
 	/* Enable Rx DMA
 	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
@@ -741,13 +746,15 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 	 * RB timeout 0x10
 	 * 256 RBDs
 	 */
-	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG,
-			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
-			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
-			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			   rb_size|
-			   (RX_RB_TIMEOUT << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
-			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
+	iwl_write32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG,
+		    FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
+		    FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
+		    FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
+		    rb_size |
+		    (RX_RB_TIMEOUT << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS) |
+		    (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
+
+	iwl_trans_release_nic_access(trans, &flags);
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
 	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
@@ -761,6 +768,7 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 rb_size, enabled = 0;
+	unsigned long flags;
 	int i;
 
 	switch (trans_pcie->rx_buf_size) {
@@ -778,25 +786,31 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 		rb_size = RFH_RXF_DMA_RB_SIZE_4K;
 	}
 
+	if (!iwl_trans_grab_nic_access(trans, &flags))
+		return;
+
 	/* Stop Rx DMA */
-	iwl_write_prph(trans, RFH_RXF_DMA_CFG, 0);
+	iwl_write_prph_no_grab(trans, RFH_RXF_DMA_CFG, 0);
 	/* disable free amd used rx queue operation */
-	iwl_write_prph(trans, RFH_RXF_RXQ_ACTIVE, 0);
+	iwl_write_prph_no_grab(trans, RFH_RXF_RXQ_ACTIVE, 0);
 
 	for (i = 0; i < trans->num_rx_queues; i++) {
 		/* Tell device where to find RBD free table in DRAM */
-		iwl_pcie_write_prph_64(trans, RFH_Q_FRBDCB_BA_LSB(i),
-				       (u64)(trans_pcie->rxq[i].bd_dma));
+		iwl_pcie_write_prph_64_no_grab(trans,
+					       RFH_Q_FRBDCB_BA_LSB(i),
+					       trans_pcie->rxq[i].bd_dma);
 		/* Tell device where to find RBD used table in DRAM */
-		iwl_pcie_write_prph_64(trans, RFH_Q_URBDCB_BA_LSB(i),
-				       (u64)(trans_pcie->rxq[i].used_bd_dma));
+		iwl_pcie_write_prph_64_no_grab(trans,
+					       RFH_Q_URBDCB_BA_LSB(i),
+					       trans_pcie->rxq[i].used_bd_dma);
 		/* Tell device where in DRAM to update its Rx status */
-		iwl_pcie_write_prph_64(trans, RFH_Q_URBD_STTS_WPTR_LSB(i),
-				       trans_pcie->rxq[i].rb_stts_dma);
+		iwl_pcie_write_prph_64_no_grab(trans,
+					       RFH_Q_URBD_STTS_WPTR_LSB(i),
+					       trans_pcie->rxq[i].rb_stts_dma);
 		/* Reset device indice tables */
-		iwl_write_prph(trans, RFH_Q_FRBDCB_WIDX(i), 0);
-		iwl_write_prph(trans, RFH_Q_FRBDCB_RIDX(i), 0);
-		iwl_write_prph(trans, RFH_Q_URBDCB_WIDX(i), 0);
+		iwl_write_prph_no_grab(trans, RFH_Q_FRBDCB_WIDX(i), 0);
+		iwl_write_prph_no_grab(trans, RFH_Q_FRBDCB_RIDX(i), 0);
+		iwl_write_prph_no_grab(trans, RFH_Q_URBDCB_WIDX(i), 0);
 
 		enabled |= BIT(i) | BIT(i + 16);
 	}
@@ -812,23 +826,26 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 	 * Drop frames that exceed RB size
 	 * 512 RBDs
 	 */
-	iwl_write_prph(trans, RFH_RXF_DMA_CFG,
-		       RFH_DMA_EN_ENABLE_VAL |
-		       rb_size | RFH_RXF_DMA_SINGLE_FRAME_MASK |
-		       RFH_RXF_DMA_MIN_RB_4_8 |
-		       RFH_RXF_DMA_DROP_TOO_LARGE_MASK |
-		       RFH_RXF_DMA_RBDCB_SIZE_512);
+	iwl_write_prph_no_grab(trans, RFH_RXF_DMA_CFG,
+			       RFH_DMA_EN_ENABLE_VAL |
+			       rb_size | RFH_RXF_DMA_SINGLE_FRAME_MASK |
+			       RFH_RXF_DMA_MIN_RB_4_8 |
+			       RFH_RXF_DMA_DROP_TOO_LARGE_MASK |
+			       RFH_RXF_DMA_RBDCB_SIZE_512);
 
 	/*
 	 * Activate DMA snooping.
 	 * Set RX DMA chunk size to 64B
 	 * Default queue is 0
 	 */
-	iwl_write_prph(trans, RFH_GEN_CFG, RFH_GEN_CFG_RFH_DMA_SNOOP |
-		       (DEFAULT_RXQ_NUM << RFH_GEN_CFG_DEFAULT_RXQ_NUM_POS) |
-		       RFH_GEN_CFG_SERVICE_DMA_SNOOP);
+	iwl_write_prph_no_grab(trans, RFH_GEN_CFG, RFH_GEN_CFG_RFH_DMA_SNOOP |
+			       (DEFAULT_RXQ_NUM <<
+				RFH_GEN_CFG_DEFAULT_RXQ_NUM_POS) |
+			       RFH_GEN_CFG_SERVICE_DMA_SNOOP);
 	/* Enable the relevant rx queues */
-	iwl_write_prph(trans, RFH_RXF_RXQ_ACTIVE, enabled);
+	iwl_write_prph_no_grab(trans, RFH_RXF_RXQ_ACTIVE, enabled);
+
+	iwl_trans_release_nic_access(trans, &flags);
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
 	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
-- 
2.8.1

