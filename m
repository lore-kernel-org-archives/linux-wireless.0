Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41230 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758217AbcH3LkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:40:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:39:00 +0300
Message-Id: <1472557142-14782-14-git-send-email-luca@coelho.fi> (sfid-20160830_134015_307820_FADF4F80)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 14/16] iwlwifi: pcie: refrain from SCD accesses
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Up till now we accessed SCD configuration only for initial
configuration and for enabling command queue.
For a000 generation the command queue is open by default
and firmware configures the rest. No driver SCD accesses
are expected. Make sure this is the case.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  4 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c    | 13 ++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 74f2f03..559f118 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1960,6 +1960,10 @@ void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans, struct iwl_txq *txq)
 	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
 		txq->q.read_ptr, txq->q.write_ptr);
 
+	if (trans->cfg->use_tfh)
+		/* TODO: access new SCD registers and dump them */
+		return;
+
 	scd_sram_addr = trans_pcie->scd_base_addr +
 			SCD_TX_STTS_QUEUE_OFFSET(txq->q.id);
 	iwl_trans_read_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 18650dc..9636dc8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -703,6 +703,9 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
 	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
 
+	if (trans->cfg->use_tfh)
+		return;
+
 	trans_pcie->scd_base_addr =
 		iwl_read_prph(trans, SCD_SRAM_BASE_ADDR);
 
@@ -970,11 +973,13 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 		}
 	}
 
-	if (trans->cfg->use_tfh)
+	if (trans->cfg->use_tfh) {
 		iwl_write_direct32(trans, TFH_TRANSFER_MODE,
 				   TFH_TRANSFER_MAX_PENDING_REQ |
 				   TFH_CHUNK_SIZE_128 |
 				   TFH_CHUNK_SPLIT_MODE);
+		return 0;
+	}
 
 	iwl_set_bits_prph(trans, SCD_GP_CTRL, SCD_GP_CTRL_AUTO_ACTIVE_MODE);
 	if (trans->cfg->base_params->num_of_queues > 20)
@@ -1249,6 +1254,9 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 	if (test_and_set_bit(txq_id, trans_pcie->queue_used))
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
+	if (cfg && trans->cfg->use_tfh)
+		WARN_ONCE(1, "Expected no calls to SCD configuration");
+
 	txq->wd_timeout = msecs_to_jiffies(wdg_timeout);
 
 	if (cfg) {
@@ -1366,6 +1374,9 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
 		return;
 	}
 
+	if (configure_scd && trans->cfg->use_tfh)
+		WARN_ONCE(1, "Expected no calls to SCD configuration");
+
 	if (configure_scd) {
 		iwl_scd_txq_set_inactive(trans, txq_id);
 
-- 
2.8.1
