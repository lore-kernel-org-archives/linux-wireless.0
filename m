Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161470Ab2COU2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/26] iwlwifi: move FW_ERROR to priv
Date: Thu, 15 Mar 2012 13:27:05 -0700
Message-Id: <1331843226-29860-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212836_753278_B31DC1FF)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The op_mode should check for FW_ERROR before calling send_cmd.  This
removes the need to test for FW_ERROR in the trans layer.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    7 +++----
 drivers/net/wireless/iwlwifi/iwl-core.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   11 -----------
 6 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index d07e0d2..22ff87f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1298,6 +1298,12 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
+	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
+		IWL_ERR(priv, "Command %s failed: FW Error\n",
+			get_cmd_string(cmd->id));
+		return -EIO;
+	}
+
 	/*
 	 * Synchronous commands from this op-mode must hold
 	 * the mutex, this ensures we don't try to send two
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e91d88d..94af564 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -920,11 +920,10 @@ void iwl_down(struct iwl_priv *priv)
 				STATUS_RF_KILL_HW |
 			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 				STATUS_GEO_CONFIGURED |
+			test_bit(STATUS_FW_ERROR, &priv->status) <<
+				STATUS_FW_ERROR |
 			test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 				STATUS_EXIT_PENDING;
-	priv->shrd->status &=
-			test_bit(STATUS_FW_ERROR, &priv->shrd->status) <<
-				STATUS_FW_ERROR;
 
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
@@ -1013,7 +1012,7 @@ static void iwl_bg_restart(struct work_struct *data)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->shrd->status)) {
+	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
 		mutex_lock(&priv->mutex);
 		iwlagn_prepare_restart(priv);
 		mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ed201e7..88ea31d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -369,7 +369,7 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	priv->ucode_loaded = false;
 
 	/* Set the FW error flag -- cleared on iwl_down */
-	set_bit(STATUS_FW_ERROR, &priv->shrd->status);
+	set_bit(STATUS_FW_ERROR, &priv->status);
 
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a2baf17..03fc27d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -557,7 +557,7 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_POWER_PMI:\t %d\n",
 		test_bit(STATUS_POWER_PMI, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_FW_ERROR:\t %d\n",
-		test_bit(STATUS_FW_ERROR, &priv->shrd->status));
+		test_bit(STATUS_FW_ERROR, &priv->status));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index f3e5c2a..56becf2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -69,7 +69,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	if (!test_bit(STATUS_READY, &priv->status) ||
 	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status) ||
 	    !test_bit(STATUS_SCAN_HW, &priv->status) ||
-	    test_bit(STATUS_FW_ERROR, &priv->shrd->status))
+	    test_bit(STATUS_FW_ERROR, &priv->status))
 		return -EIO;
 
 	ret = iwl_dvm_send_cmd(priv, &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 105c093..61b0fba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -536,11 +536,6 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	int trace_idx;
 #endif
 
-	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
-		IWL_WARN(trans, "fw recovery, no hcmd send\n");
-		return -EIO;
-	}
-
 	copy_size = sizeof(out_cmd->hdr);
 	cmd_size = sizeof(out_cmd->hdr);
 
@@ -821,12 +816,6 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
-	if (test_bit(STATUS_FW_ERROR, &trans->shrd->status)) {
-		IWL_ERR(trans, "Command %s failed: FW Error\n",
-			       get_cmd_string(cmd->id));
-		return -EIO;
-	}
-
 	if (WARN_ON(test_and_set_bit(STATUS_HCMD_ACTIVE,
 				     &trans->shrd->status))) {
 		IWL_ERR(trans, "Command %s: a command is already active!\n",
-- 
1.7.0.4

