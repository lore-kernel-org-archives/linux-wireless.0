Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933610AbcCIRqM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/21] iwlwifi: mvm: add ctdp operations to debugfs
Date: Wed,  9 Mar 2016 19:45:38 +0200
Message-Id: <1457545550-30677-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_184617_556020_C2F699F5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

Add debugfs entries to get the ctdp budget average
and to stop ctdp.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 42 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c      | 76 +++++++++++++-----------
 2 files changed, 84 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 56e6b0b..a43b392 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -73,6 +73,44 @@
 #include "debugfs.h"
 #include "iwl-fw-error-dump.h"
 
+static ssize_t iwl_dbgfs_ctdp_budget_read(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	char buf[16];
+	int pos, budget;
+
+	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
+		return -EIO;
+
+	mutex_lock(&mvm->mutex);
+	budget = iwl_mvm_ctdp_command(mvm, CTDP_CMD_OPERATION_REPORT, 0);
+	mutex_unlock(&mvm->mutex);
+
+	if (budget < 0)
+		return budget;
+
+	pos = scnprintf(buf, sizeof(buf), "%d\n", budget);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+static ssize_t iwl_dbgfs_stop_ctdp_write(struct iwl_mvm *mvm, char *buf,
+					 size_t count, loff_t *ppos)
+{
+	int ret;
+
+	if (!mvm->ucode_loaded || mvm->cur_ucode != IWL_UCODE_REGULAR)
+		return -EIO;
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_ctdp_command(mvm, CTDP_CMD_OPERATION_STOP, 0);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
 static ssize_t iwl_dbgfs_tx_flush_write(struct iwl_mvm *mvm, char *buf,
 					size_t count, loff_t *ppos)
 {
@@ -1493,6 +1531,8 @@ iwl_dbgfs_send_echo_cmd_write(struct iwl_mvm *mvm, char *buf,
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(prph_reg, 64);
 
 /* Device wide debugfs entries */
+MVM_DEBUGFS_READ_FILE_OPS(ctdp_budget);
+MVM_DEBUGFS_WRITE_FILE_OPS(stop_ctdp, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush, 16);
 MVM_DEBUGFS_WRITE_FILE_OPS(sta_drain, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(send_echo_cmd, 8);
@@ -1542,6 +1582,8 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(set_nic_temperature, mvm->debugfs_dir,
 			     S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(nic_temp, dbgfs_dir, S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(ctdp_budget, dbgfs_dir, S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(stop_ctdp, dbgfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(stations, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_cmd, dbgfs_dir, S_IRUSR);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 0a02e98..a396549 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -510,6 +510,48 @@ static const struct iwl_tt_params iwl_mvm_default_tt_params = {
 	.support_tx_backoff = true,
 };
 
+int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 budget)
+{
+	struct iwl_mvm_ctdp_cmd cmd = {
+		.operation = cpu_to_le32(op),
+		.budget = cpu_to_le32(budget),
+		.window_size = 0,
+	};
+	int ret;
+	u32 status;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, WIDE_ID(PHY_OPS_GROUP,
+						       CTDP_CONFIG_CMD),
+					  sizeof(cmd), &cmd, &status);
+
+	if (ret) {
+		IWL_ERR(mvm, "cTDP command failed (err=%d)\n", ret);
+		return ret;
+	}
+
+	switch (op) {
+	case CTDP_CMD_OPERATION_START:
+		mvm->cooling_dev.cur_state = budget;
+		break;
+	case CTDP_CMD_OPERATION_REPORT:
+		IWL_DEBUG_TEMP(mvm, "cTDP avg energy in mWatt = %d\n", status);
+		/* when the function is called with CTDP_CMD_OPERATION_REPORT
+		 * option the function should return the average budget value
+		 * that is received from the FW.
+		 * The budget can't be less or equal to 0, so it's possible
+		 * to distinguish between error values and budgets.
+		 */
+		return status;
+	case CTDP_CMD_OPERATION_STOP:
+		IWL_DEBUG_TEMP(mvm, "cTDP stopped successfully\n");
+		break;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_THERMAL
 static int compare_temps(const void *a, const void *b)
 {
@@ -738,40 +780,6 @@ static const u32 iwl_mvm_cdev_budgets[] = {
 	150,	/* cooling state 19 */
 };
 
-int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 budget)
-{
-	struct iwl_mvm_ctdp_cmd cmd = {
-		.operation = cpu_to_le32(op),
-		.budget = cpu_to_le32(budget),
-		.window_size = 0,
-	};
-	int ret;
-	u32 status;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	ret = iwl_mvm_send_cmd_pdu_status(mvm, WIDE_ID(PHY_OPS_GROUP,
-						       CTDP_CONFIG_CMD),
-					  sizeof(cmd), &cmd, &status);
-
-	if (ret) {
-		IWL_ERR(mvm, "cTDP command failed (err=%d)\n", ret);
-		return ret;
-	}
-
-	/* can happen if the registration failed */
-	if (!mvm->cooling_dev.cdev)
-		return -EINVAL;
-
-	if (op == CTDP_CMD_OPERATION_START)
-		mvm->cooling_dev.cur_state = budget;
-
-	else if (op == CTDP_CMD_OPERATION_REPORT)
-		IWL_DEBUG_TEMP(mvm, "cTDP avg energy in mWatt = %d\n", status);
-
-	return 0;
-}
-
 static int iwl_mvm_tcool_get_max_state(struct thermal_cooling_device *cdev,
 				       unsigned long *state)
 {
-- 
2.5.0

