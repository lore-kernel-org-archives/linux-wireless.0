Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347AbcAaLHB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:07:01 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/31] iwlwifi: pcie: enable multi-queue rx path
Date: Sun, 31 Jan 2016 13:06:24 +0200
Message-Id: <1454238386-27032-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123653_836468_F5C936DD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Previous patches enabled new 9000 hardware DMA for one queue
only.
Enable the actual multi-queue path and configuration now.
This requires also per-queue NAPI struct.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 35 +++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 14 +--------
 3 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 7bc02e0..2f95916 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -136,6 +136,7 @@ struct iwl_rxq {
 	struct iwl_rb_status *rb_stts;
 	dma_addr_t rb_stts_dma;
 	spinlock_t lock;
+	struct napi_struct napi;
 	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
 };
 
@@ -345,7 +346,6 @@ struct iwl_trans_pcie {
 	struct iwl_drv *drv;
 
 	struct net_device napi_dev;
-	struct napi_struct napi;
 
 	struct __percpu iwl_tso_hdr_page *tso_hdr_page;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index a385f3c..51314e56 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -2,6 +2,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -730,7 +731,7 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 		iwl_set_bit(trans, CSR_INT_COALESCING, IWL_HOST_INT_OPER_MODE);
 }
 
-static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
+static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 rb_size, enabled = 0;
@@ -759,13 +760,13 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 	for (i = 0; i < trans->num_rx_queues; i++) {
 		/* Tell device where to find RBD free table in DRAM */
 		iwl_pcie_write_prph_64(trans, RFH_Q_FRBDCB_BA_LSB(i),
-				       (u64)(rxq->bd_dma));
+				       (u64)(trans_pcie->rxq[i].bd_dma));
 		/* Tell device where to find RBD used table in DRAM */
 		iwl_pcie_write_prph_64(trans, RFH_Q_URBDCB_BA_LSB(i),
-				       (u64)(rxq->used_bd_dma));
+				       (u64)(trans_pcie->rxq[i].used_bd_dma));
 		/* Tell device where in DRAM to update its Rx status */
 		iwl_pcie_write_prph_64(trans, RFH_Q_URBD_STTS_WPTR_LSB(i),
-				       rxq->rb_stts_dma);
+				       trans_pcie->rxq[i].rb_stts_dma);
 		/* Reset device indice tables */
 		iwl_write_prph(trans, RFH_Q_FRBDCB_WIDX(i), 0);
 		iwl_write_prph(trans, RFH_Q_FRBDCB_RIDX(i), 0);
@@ -808,6 +809,12 @@ static void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq)
 	rxq->used_count = 0;
 }
 
+static int iwl_pcie_dummy_napi_poll(struct napi_struct *napi, int budget)
+{
+	WARN_ON(1);
+	return 0;
+}
+
 int iwl_pcie_rx_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -857,6 +864,10 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 
 		iwl_pcie_rx_init_rxb_lists(rxq);
 
+		if (!rxq->napi.poll)
+			netif_napi_add(&trans_pcie->napi_dev, &rxq->napi,
+				       iwl_pcie_dummy_napi_poll, 64);
+
 		spin_unlock(&rxq->lock);
 	}
 
@@ -878,7 +889,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 
 	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL, def_rxq);
 	if (trans->cfg->mq_rx_supported) {
-		iwl_pcie_rx_mq_hw_init(trans, def_rxq);
+		iwl_pcie_rx_mq_hw_init(trans);
 	} else {
 		iwl_pcie_rxq_restock(trans, def_rxq);
 		iwl_pcie_rx_hw_init(trans, def_rxq);
@@ -940,6 +951,9 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 					  rxq->used_bd, rxq->used_bd_dma);
 		rxq->used_bd_dma = 0;
 		rxq->used_bd = NULL;
+
+		if (rxq->napi.poll)
+			netif_napi_del(&rxq->napi);
 	}
 	kfree(trans_pcie->rxq);
 }
@@ -1055,7 +1069,12 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		index = SEQ_TO_INDEX(sequence);
 		cmd_index = get_cmd_index(&txq->q, index);
 
-		iwl_op_mode_rx(trans->op_mode, &trans_pcie->napi, &rxcb);
+		if (rxq->id == 0)
+			iwl_op_mode_rx(trans->op_mode, &rxq->napi,
+				       &rxcb);
+		else
+			iwl_op_mode_rx_rss(trans->op_mode, &rxq->napi,
+					   &rxcb, rxq->id);
 
 		if (reclaim) {
 			kzfree(txq->entries[cmd_index].free_buf);
@@ -1236,8 +1255,8 @@ restart:
 	if (unlikely(emergency && count))
 		iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
 
-	if (trans_pcie->napi.poll)
-		napi_gro_flush(&trans_pcie->napi, false);
+	if (rxq->napi.poll)
+		napi_gro_flush(&rxq->napi, false);
 }
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index abe0916..b796952 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1428,12 +1428,6 @@ static void iwl_trans_pcie_write_prph(struct iwl_trans *trans, u32 addr,
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WDAT, val);
 }
 
-static int iwl_pcie_dummy_napi_poll(struct napi_struct *napi, int budget)
-{
-	WARN_ON(1);
-	return 0;
-}
-
 static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 				     const struct iwl_trans_config *trans_cfg)
 {
@@ -1470,11 +1464,8 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	 * As this function may be called again in some corner cases don't
 	 * do anything if NAPI was already initialized.
 	 */
-	if (!trans_pcie->napi.poll) {
+	if (trans_pcie->napi_dev.reg_state != NETREG_DUMMY)
 		init_dummy_netdev(&trans_pcie->napi_dev);
-		netif_napi_add(&trans_pcie->napi_dev, &trans_pcie->napi,
-			       iwl_pcie_dummy_napi_poll, 64);
-	}
 }
 
 void iwl_trans_pcie_free(struct iwl_trans *trans)
@@ -1498,9 +1489,6 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	pci_release_regions(trans_pcie->pci_dev);
 	pci_disable_device(trans_pcie->pci_dev);
 
-	if (trans_pcie->napi.poll)
-		netif_napi_del(&trans_pcie->napi);
-
 	iwl_pcie_free_fw_monitor(trans);
 
 	for_each_possible_cpu(i) {
-- 
2.5.0

