Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54752 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752856AbcIOSLr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:11:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:13 +0300
Message-Id: <20160915181131.32213-7-luca@coelho.fi> (sfid-20160915_201156_820917_DBC1C1FB)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: introduce trans API to get byte count table
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In future HW the byte count table address will be configured
by ucode per queue. Add API to expose the byte count table to
the opmode

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 10 ++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  8 ++++++++
 4 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 883cb487b..93cdfd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -645,6 +645,8 @@ struct iwl_trans_ops {
 	void (*txq_set_shared_mode)(struct iwl_trans *trans, u32 txq_id,
 				    bool shared);
 
+	dma_addr_t (*get_txq_byte_table)(struct iwl_trans *trans, int txq_id);
+
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans, u32 txq_bm);
 	void (*freeze_txq_timer)(struct iwl_trans *trans, unsigned long txqs,
 				 bool freeze);
@@ -1069,6 +1071,14 @@ static inline void iwl_trans_txq_set_shared_mode(struct iwl_trans *trans,
 		trans->ops->txq_set_shared_mode(trans, queue, shared_mode);
 }
 
+static inline dma_addr_t iwl_trans_get_txq_byte_table(struct iwl_trans *trans,
+						      int queue)
+{
+	if (trans->ops->get_txq_byte_table)
+		return trans->ops->get_txq_byte_table(trans, queue);
+	return DMA_ERROR_CODE;
+}
+
 static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 					int fifo, int sta_id, int tid,
 					int frame_limit, u16 ssn,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 975900a..b9dc82b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -476,6 +476,7 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue,
 				bool configure_scd);
 void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
 					bool shared_mode);
+dma_addr_t iwl_trans_pcie_get_txq_byte_table(struct iwl_trans *trans, int txq);
 void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans,
 				  struct iwl_txq *txq);
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 0c2ccbe..21b1be1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2803,6 +2803,8 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.txq_disable = iwl_trans_pcie_txq_disable,
 	.txq_enable = iwl_trans_pcie_txq_enable,
 
+	.get_txq_byte_table = iwl_trans_pcie_get_txq_byte_table,
+
 	.txq_set_shared_mode = iwl_trans_pcie_txq_set_shared_mode,
 
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_txq_empty,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 1c46f14..57a657a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1352,6 +1352,14 @@ void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
 	txq->ampdu = !shared_mode;
 }
 
+dma_addr_t iwl_trans_pcie_get_txq_byte_table(struct iwl_trans *trans, int txq)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	return trans_pcie->scd_bc_tbls.dma +
+	       txq * sizeof(struct iwlagn_scd_bc_tbl);
+}
+
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
 				bool configure_scd)
 {
-- 
2.9.3
