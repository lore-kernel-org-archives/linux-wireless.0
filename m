Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42926 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726560AbeHUJ4O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:56:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:53 +0300
Message-Id: <20180821063657.30071-12-luca@coelho.fi> (sfid-20180821_083732_826726_9F3A77F4)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 11/15] iwlwifi: improve the flow when a NIC is disconnected
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When the NIC is disconnected, we just can't do anything
besides seeking for help from the bus driver.  Dumping the
device's memory is not necessary and just bloats the logs
with unusable data.  Moreover, asking mac80211 to restart
the hardware is also useless.  Bypass all this.

Also, use the STATUS_TRANS_DEAD status bit instead of a
bool inside the transport layer. The advantage of this is
that now, the transport and the op_mode can know what is the
situation and bypass the useless recovery steps mentioned
above.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  6 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 --
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 10 ++++------
 4 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d275832dbb14..da1aafb71298 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1254,7 +1254,8 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
 	} else if (mvm->fwrt.cur_fw_img == IWL_UCODE_REGULAR &&
-		   mvm->hw_registered) {
+		   mvm->hw_registered &&
+		   !test_bit(STATUS_TRANS_DEAD, &mvm->trans->status)) {
 		/* don't let the transport/FW power down */
 		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
@@ -1269,7 +1270,8 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
-	iwl_mvm_dump_nic_error_log(mvm);
+	if (!test_bit(STATUS_TRANS_DEAD, &mvm->trans->status))
+		iwl_mvm_dump_nic_error_log(mvm);
 
 	iwl_mvm_nic_restart(mvm, true);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 8fdef4a26db4..1089e6b216aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -480,7 +480,6 @@ struct iwl_self_init_dram {
  * @fh_mask: current unmasked fh causes
  * @hw_mask: current unmasked hw causes
  * @in_rescan: true if we have triggered a device rescan
- * @scheduled_for_removal: true if we have scheduled a device removal
  */
 struct iwl_trans_pcie {
 	struct iwl_rxq *rxq;
@@ -573,7 +572,6 @@ struct iwl_trans_pcie {
 	cpumask_t affinity_mask[IWL_MAX_RX_HW_QUEUES];
 	u16 tx_cmd_queue_size;
 	bool in_rescan;
-	bool scheduled_for_removal;
 };
 
 static inline struct iwl_trans_pcie *
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index cf7d1acc8e7a..2a20999d4c15 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2013,7 +2013,7 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans,
 		if (iwlwifi_mod_params.remove_when_gone && cntrl == ~0U) {
 			struct iwl_trans_pcie_removal *removal;
 
-			if (trans_pcie->scheduled_for_removal)
+			if (test_bit(STATUS_TRANS_DEAD, &trans->status))
 				goto err;
 
 			IWL_ERR(trans, "Device gone - scheduling removal!\n");
@@ -2039,7 +2039,7 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans,
 			 * we don't need to clear this flag, because
 			 * the trans will be freed and reallocated.
 			*/
-			trans_pcie->scheduled_for_removal = true;
+			set_bit(STATUS_TRANS_DEAD, &trans->status);
 
 			removal->pdev = to_pci_dev(trans->dev);
 			INIT_WORK(&removal->work, iwl_trans_pcie_removal_wk);
@@ -2267,8 +2267,8 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, int txq_idx)
 	u8 wr_ptr;
 
 	/* Make sure the NIC is still alive in the bus */
-	if (trans_pcie->scheduled_for_removal)
-		return -EIO;
+	if (test_bit(STATUS_TRANS_DEAD, &trans->status))
+		return -ENODEV;
 
 	if (!test_bit(txq_idx, trans_pcie->queue_used))
 		return -EINVAL;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index d5aba9ebd84a..b89e976ecfcd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1189,8 +1189,8 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
 	lockdep_assert_held(&trans_pcie->reg_lock);
 
 	/* Make sure the NIC is still alive in the bus */
-	if (trans_pcie->scheduled_for_removal)
-		return -EIO;
+	if (test_bit(STATUS_TRANS_DEAD, &trans->status))
+		return -ENODEV;
 
 	if (!(cmd->flags & CMD_SEND_IN_IDLE) &&
 	    !trans_pcie->ref_cmd_in_flight) {
@@ -1961,11 +1961,9 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 
 int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
 	/* Make sure the NIC is still alive in the bus */
-	if (trans_pcie->scheduled_for_removal)
-		return -EIO;
+	if (test_bit(STATUS_TRANS_DEAD, &trans->status))
+		return -ENODEV;
 
 	if (!(cmd->flags & CMD_SEND_IN_RFKILL) &&
 	    test_bit(STATUS_RFKILL_OPMODE, &trans->status)) {
-- 
2.18.0
