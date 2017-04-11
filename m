Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50732 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752312AbdDKMkJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:40:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:33 +0300
Message-Id: <20170411123742.12214-17-luca@coelho.fi> (sfid-20170411_145544_172242_43166C89)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 16/25] Revert "iwlwifi: introduce trans API to get byte count table"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This reverts commit 8aacf4b73fe8 ("iwlwifi: introduce trans API
to get byte count table").
The commit is not needed as a better approach will be taken.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 11 -----------
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  1 -
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  2 --
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  8 --------
 4 files changed, 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 0296124a7f9c..b52804dd884f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -644,8 +644,6 @@ struct iwl_trans_ops {
 	void (*txq_set_shared_mode)(struct iwl_trans *trans, u32 txq_id,
 				    bool shared);
 
-	dma_addr_t (*get_txq_byte_table)(struct iwl_trans *trans, int txq_id);
-
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans, u32 txq_bm);
 	void (*freeze_txq_timer)(struct iwl_trans *trans, unsigned long txqs,
 				 bool freeze);
@@ -1072,15 +1070,6 @@ static inline void iwl_trans_txq_set_shared_mode(struct iwl_trans *trans,
 		trans->ops->txq_set_shared_mode(trans, queue, shared_mode);
 }
 
-static inline dma_addr_t iwl_trans_get_txq_byte_table(struct iwl_trans *trans,
-						      int queue)
-{
-	/* we should never be called if the trans doesn't support it */
-	BUG_ON(!trans->ops->get_txq_byte_table);
-
-	return trans->ops->get_txq_byte_table(trans, queue);
-}
-
 static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 					int fifo, int sta_id, int tid,
 					int frame_limit, u16 ssn,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 10937309641a..541b969fe283 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -484,7 +484,6 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue,
 				bool configure_scd);
 void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
 					bool shared_mode);
-dma_addr_t iwl_trans_pcie_get_txq_byte_table(struct iwl_trans *trans, int txq);
 void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans,
 				  struct iwl_txq *txq);
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index fbb0afa9de14..69f1b032260c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2897,8 +2897,6 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.txq_disable = iwl_trans_pcie_txq_disable,
 	.txq_enable = iwl_trans_pcie_txq_enable,
 
-	.get_txq_byte_table = iwl_trans_pcie_get_txq_byte_table,
-
 	.txq_set_shared_mode = iwl_trans_pcie_txq_set_shared_mode,
 
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_txq_empty,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 03df578bed00..a313c187524b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1424,14 +1424,6 @@ void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
 	txq->ampdu = !shared_mode;
 }
 
-dma_addr_t iwl_trans_pcie_get_txq_byte_table(struct iwl_trans *trans, int txq)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	return trans_pcie->scd_bc_tbls.dma +
-	       txq * sizeof(struct iwlagn_scd_bc_tbl);
-}
-
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
 				bool configure_scd)
 {
-- 
2.11.0
