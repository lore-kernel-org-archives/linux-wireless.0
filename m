Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38608 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730088AbeG0OKn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:10:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 27 Jul 2018 15:48:28 +0300
Message-Id: <20180727124838.25910-7-luca@coelho.fi> (sfid-20180727_144859_046824_AECA6407)
In-Reply-To: <20180727124838.25910-1-luca@coelho.fi>
References: <20180727124838.25910-1-luca@coelho.fi>
Subject: [PATCH 06/16] iwlwifi: trans: add a new op for getting DMA data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Op mode will need this data in order to feed FW with it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 26 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 17 ++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 4229992073b6..9483f76476de 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -439,6 +439,20 @@ struct iwl_trans_txq_scd_cfg {
 	int frame_limit;
 };
 
+/**
+ * struct iwl_trans_rxq_dma_data - RX queue DMA data
+ * @fr_bd_cb: DMA address of free BD cyclic buffer
+ * @fr_bd_wid: Initial write index of the free BD cyclic buffer
+ * @urbd_stts_wrptr: DMA address of urbd_stts_wrptr
+ * @ur_bd_cb: DMA address of used BD cyclic buffer
+ */
+struct iwl_trans_rxq_dma_data {
+	u64 fr_bd_cb;
+	u32 fr_bd_wid;
+	u64 urbd_stts_wrptr;
+	u64 ur_bd_cb;
+};
+
 /**
  * struct iwl_trans_ops - transport specific operations
  *
@@ -559,6 +573,8 @@ struct iwl_trans_ops {
 			 int cmd_id, int size,
 			 unsigned int queue_wdg_timeout);
 	void (*txq_free)(struct iwl_trans *trans, int queue);
+	int (*rxq_dma_data)(struct iwl_trans *trans, int queue,
+			    struct iwl_trans_rxq_dma_data *data);
 
 	void (*txq_set_shared_mode)(struct iwl_trans *trans, u32 txq_id,
 				    bool shared);
@@ -947,6 +963,16 @@ iwl_trans_txq_enable_cfg(struct iwl_trans *trans, int queue, u16 ssn,
 				      cfg, queue_wdg_timeout);
 }
 
+static inline int
+iwl_trans_get_rxq_dma_data(struct iwl_trans *trans, int queue,
+			   struct iwl_trans_rxq_dma_data *data)
+{
+	if (WARN_ON_ONCE(!trans->ops->rxq_dma_data))
+		return -ENOTSUPP;
+
+	return trans->ops->rxq_dma_data(trans, queue, data);
+}
+
 static inline void
 iwl_trans_txq_free(struct iwl_trans *trans, int queue)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 64c781eab6a5..603458aa2923 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2265,6 +2265,22 @@ void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans, struct iwl_txq *txq)
 		iwl_read_direct32(trans, FH_TX_TRB_REG(fifo)));
 }
 
+static int iwl_trans_pcie_rxq_dma_data(struct iwl_trans *trans, int queue,
+				       struct iwl_trans_rxq_dma_data *data)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (queue >= trans->num_rx_queues || !trans_pcie->rxq)
+		return -EINVAL;
+
+	data->fr_bd_cb = trans_pcie->rxq[queue].bd_dma;
+	data->urbd_stts_wrptr = trans_pcie->rxq[queue].rb_stts_dma;
+	data->ur_bd_cb = trans_pcie->rxq[queue].used_bd_dma;
+	data->fr_bd_wid = 0;
+
+	return 0;
+}
+
 static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, int txq_idx)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -3212,6 +3228,7 @@ static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
 	.txq_alloc = iwl_trans_pcie_dyn_txq_alloc,
 	.txq_free = iwl_trans_pcie_dyn_txq_free,
 	.wait_txq_empty = iwl_trans_pcie_wait_txq_empty,
+	.rxq_dma_data = iwl_trans_pcie_rxq_dma_data,
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
-- 
2.18.0
