Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:64671 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753936AbdDNJEB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:04:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:02:07 +0300
Message-Id: <20170414090210.31397-24-luca@coelho.fi> (sfid-20170414_110417_427531_226EB478)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 23/26] iwlwifi: pcie: remove block and freeze operations from new transport
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

New transport will be used only by op modes that supports
buffer station offload - hence those will never be called.
Clean it up.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  3 ---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 22 +++-------------------
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 16a057398de2..d39ca944f484 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2925,9 +2925,6 @@ static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
 
 	.txq_alloc = iwl_trans_pcie_dyn_txq_alloc,
 	.txq_free = iwl_trans_pcie_dyn_txq_free,
-
-	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
-	.block_txq_ptrs = iwl_trans_pcie_block_txq_ptrs,
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index e8eb11282795..2019ccda31c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -107,9 +107,7 @@ static void iwl_pcie_gen2_txq_inc_wr_ptr(struct iwl_trans *trans,
 	 * if not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx).
 	 */
-	if (!txq->block)
-		iwl_write32(trans, HBUS_TARG_WRPTR,
-			    txq->write_ptr | (txq->id << 16));
+	iwl_write32(trans, HBUS_TARG_WRPTR, txq->write_ptr | (txq->id << 16));
 }
 
 static u8 iwl_pcie_gen2_get_num_tbs(struct iwl_trans *trans,
@@ -341,19 +339,8 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/* start timer if queue currently empty */
 	if (txq->read_ptr == txq->write_ptr) {
-		if (txq->wd_timeout) {
-			/*
-			 * If the TXQ is active, then set the timer, if not,
-			 * set the timer in remainder so that the timer will
-			 * be armed with the right value when the station will
-			 * wake up.
-			 */
-			if (!txq->frozen)
-				mod_timer(&txq->stuck_timer,
-					  jiffies + txq->wd_timeout);
-			else
-				txq->frozen_expiry_remainder = txq->wd_timeout;
-		}
+		if (txq->wd_timeout)
+			mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
 		IWL_DEBUG_RPM(trans, "Q: %d first tx - take ref\n", txq->id);
 		iwl_trans_ref(trans);
 	}
@@ -843,9 +830,6 @@ void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	trans_pcie->txq[queue].frozen_expiry_remainder = 0;
-	trans_pcie->txq[queue].frozen = false;
-
 	/*
 	 * Upon HW Rfkill - we stop the device, and then stop the queues
 	 * in the op_mode. Just for the sake of the simplicity of the op_mode,
-- 
2.11.0
