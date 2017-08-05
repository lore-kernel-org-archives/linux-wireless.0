Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42480 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752081AbdHETnk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:43:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:16 +0300
Message-Id: <20170805194331.17426-5-luca@coelho.fi> (sfid-20170805_214351_248499_E3D069B6)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 04/19] iwlwifi: mvm: add debugfs to force CT-kill
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

In order to test the enter/exit CT-kill flow.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 14 ++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c      |  2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 29f1d1807415..0b5cae54b86b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -114,6 +114,18 @@ static ssize_t iwl_dbgfs_stop_ctdp_write(struct iwl_mvm *mvm, char *buf,
 	return ret ?: count;
 }
 
+static ssize_t iwl_dbgfs_force_ctkill_write(struct iwl_mvm *mvm, char *buf,
+					    size_t count, loff_t *ppos)
+{
+	if (!iwl_mvm_firmware_running(mvm) ||
+	    mvm->fwrt.cur_fw_img != IWL_UCODE_REGULAR)
+		return -EIO;
+
+	iwl_mvm_enter_ctkill(mvm);
+
+	return count;
+}
+
 static ssize_t iwl_dbgfs_tx_flush_write(struct iwl_mvm *mvm, char *buf,
 					size_t count, loff_t *ppos)
 {
@@ -1641,6 +1653,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(prph_reg, 64);
 /* Device wide debugfs entries */
 MVM_DEBUGFS_READ_FILE_OPS(ctdp_budget);
 MVM_DEBUGFS_WRITE_FILE_OPS(stop_ctdp, 8);
+MVM_DEBUGFS_WRITE_FILE_OPS(force_ctkill, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush, 16);
 MVM_DEBUGFS_WRITE_FILE_OPS(sta_drain, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(send_echo_cmd, 8);
@@ -1828,6 +1841,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(nic_temp, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(ctdp_budget, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(stop_ctdp, dbgfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(force_ctkill, dbgfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(stations, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_cmd, dbgfs_dir, S_IRUSR);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ae53d8564342..7423b5632bfa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1753,6 +1753,7 @@ void iwl_mvm_thermal_exit(struct iwl_mvm *mvm);
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
 int iwl_mvm_get_temp(struct iwl_mvm *mvm, s32 *temp);
 void iwl_mvm_ct_kill_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm);
 int iwl_mvm_send_temp_report_ths_cmd(struct iwl_mvm *mvm);
 int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 budget);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 3f143402cf7f..8876c2abc440 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -71,7 +71,7 @@
 
 #define IWL_MVM_TEMP_NOTIF_WAIT_TIMEOUT	HZ
 
-static void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
+void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
 {
 	struct iwl_mvm_tt_mgmt *tt = &mvm->thermal_throttle;
 	u32 duration = tt->params.ct_kill_duration;
-- 
2.13.2
