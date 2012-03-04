Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab2CDUnE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 038/101] iwlwifi: move RF/CT kill check to command wrapper
Date: Sun,  4 Mar 2012 11:28:52 -0800
Message-Id: <1330889395-533-39-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214622_001068_39B2494C)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, we cannot send any commands when the
uCode is in RF or CT kill, but that will not be
true for all new uCode versions, so we need to
move the check into the uCode specific code.

Also remove the duplicate rfkill check.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   19 ++++---------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 4c777df..11f2411 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1292,6 +1292,12 @@ int iwlagn_suspend(struct iwl_priv *priv,
 
 int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
+	if (iwl_is_rfkill(priv->shrd) || iwl_is_ctkill(priv->shrd)) {
+		IWL_WARN(priv, "Not sending command - %s KILL\n",
+			 iwl_is_rfkill(priv->shrd) ? "RF" : "CT");
+		return -EIO;
+	}
+
 	return iwl_trans_send_cmd(trans(priv), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 0164154..c85975e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -721,12 +721,6 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	if (WARN_ON(copy_size > TFD_MAX_PAYLOAD_SIZE))
 		return -EINVAL;
 
-	if (iwl_is_rfkill(trans->shrd) || iwl_is_ctkill(trans->shrd)) {
-		IWL_WARN(trans, "Not sending command - %s KILL\n",
-			 iwl_is_rfkill(trans->shrd) ? "RF" : "CT");
-		return -EIO;
-	}
-
 	spin_lock_bh(&txq->lock);
 
 	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
@@ -965,7 +959,7 @@ static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 	ret = iwl_enqueue_hcmd(trans, cmd);
 	if (ret < 0) {
-		IWL_DEBUG_QUIET_RFKILL(trans,
+		IWL_ERR(trans,
 			"Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		return ret;
@@ -984,11 +978,6 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
-	if (test_bit(STATUS_RF_KILL_HW, &trans->shrd->status)) {
-		IWL_ERR(trans, "Command %s aborted: RF KILL Switch\n",
-			       get_cmd_string(cmd->id));
-		return -ECANCELED;
-	}
 	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
 		IWL_ERR(trans, "Command %s failed: FW Error\n",
 			       get_cmd_string(cmd->id));
@@ -1002,7 +991,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		IWL_DEBUG_QUIET_RFKILL(trans,
+		IWL_ERR(trans,
 			"Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		return ret;
@@ -1017,12 +1006,12 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 				&trans_pcie->txq[trans->shrd->cmd_queue];
 			struct iwl_queue *q = &txq->q;
 
-			IWL_DEBUG_QUIET_RFKILL(trans,
+			IWL_ERR(trans,
 				"Error sending %s: time out after %dms.\n",
 				get_cmd_string(cmd->id),
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
-			IWL_DEBUG_QUIET_RFKILL(trans,
+			IWL_ERR(trans,
 				"Current CMD queue read_ptr %d write_ptr %d\n",
 				q->read_ptr, q->write_ptr);
 
-- 
1.7.0.4

