Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbbLUUvQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:16 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/45] iwlwifi: block the queues when we send ADD_STA for uAPSD
Date: Mon, 21 Dec 2015 22:50:14 +0200
Message-Id: <1450731046-2796-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215129_530655_84D76FE5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We send an ADD_STA to instruct the firmware to release
frames despite the peer being in PS.
Since the ADD_STA command and the Tx frame that comes
immediately afterwards can be reordered by the DMA engine,
we need to block the Tx queues until the firmware replies
with the ADD_STA response.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 13 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |  7 ++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index b71c85b..4e417fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -839,6 +839,18 @@ static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 	}
 }
 
+static void iwl_mvm_async_cb(struct iwl_op_mode *op_mode,
+			     const struct iwl_device_cmd *cmd)
+{
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	/*
+	 * For now, we only set the CMD_WANT_ASYNC_CALLBACK for ADD_STA
+	 * commands that need to block the Tx queues.
+	 */
+	iwl_trans_block_txq_ptrs(mvm->trans, false);
+}
+
 static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
@@ -1414,6 +1426,7 @@ int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 
 #define IWL_MVM_COMMON_OPS					\
 	/* these could be differentiated */			\
+	.async_cb = iwl_mvm_async_cb,				\
 	.queue_full = iwl_mvm_stop_sw_queue,			\
 	.queue_not_full = iwl_mvm_wake_sw_queue,		\
 	.hw_rf_kill = iwl_mvm_set_hw_rfkill_state,		\
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index dc3206a..566b659 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1708,7 +1708,12 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 		cmd.sleep_state_flags |= cpu_to_le16(STA_SLEEP_STATE_UAPSD);
 	}
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA, CMD_ASYNC, sizeof(cmd), &cmd);
+	/* block the Tx queues until the FW updated the sleep Tx count */
+	iwl_trans_block_txq_ptrs(mvm->trans, true);
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA,
+				   CMD_ASYNC | CMD_WANT_ASYNC_CALLBACK,
+				   sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
 }
-- 
2.5.0

