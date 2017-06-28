Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35754 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751540AbdF1UNu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:13:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:01 +0300
Message-Id: <20170628201330.9432-3-luca@coelho.fi> (sfid-20170628_221357_230011_3C3FD62B)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 02/31] iwlwifi: mvm: Add debugfs entry to retrieve SAR geographic profile
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Add a debugfs entry to get a verbose description of the power settings
used in each band with the currently selected SAR geographic profile.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 50 ++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index c2a1aeef74ec..c3ab13ee4097 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -336,6 +336,49 @@ static ssize_t iwl_dbgfs_nic_temp_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+#ifdef CONFIG_ACPI
+static ssize_t iwl_dbgfs_sar_geo_profile_read(struct file *file,
+					      char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	char buf[256];
+	int pos = 0;
+	int bufsz = sizeof(buf);
+	int tbl_idx;
+	u8 *value;
+
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
+	mutex_lock(&mvm->mutex);
+	tbl_idx = iwl_mvm_get_sar_geo_profile(mvm);
+	if (tbl_idx < 0) {
+		mutex_unlock(&mvm->mutex);
+		return tbl_idx;
+	}
+
+	if (!tbl_idx) {
+		pos = scnprintf(buf, bufsz,
+				"SAR geographic profile disabled\n");
+	} else {
+		value = &mvm->geo_profiles[tbl_idx - 1].values[0];
+
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "Use geographic profile %d\n", tbl_idx);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "2.4GHz:\n\tChain A offset: %hhd dBm\n\tChain B offset: %hhd dBm\n\tmax tx power: %hhd dBm\n",
+				 value[1], value[2], value[0]);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "5.2GHz:\n\tChain A offset: %hhd dBm\n\tChain B offset: %hhd dBm\n\tmax tx power: %hhd dBm\n",
+				 value[4], value[5], value[3]);
+	}
+	mutex_unlock(&mvm->mutex);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+#endif
+
 static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
@@ -1572,6 +1615,9 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters_macs, 256);
 #ifdef CONFIG_PM_SLEEP
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d3_sram, 8);
 #endif
+#ifdef CONFIG_ACPI
+MVM_DEBUGFS_READ_FILE_OPS(sar_geo_profile);
+#endif
 
 static ssize_t iwl_dbgfs_mem_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
@@ -1744,6 +1790,10 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(cont_recording, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(indirection_tbl, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(inject_packet, mvm->debugfs_dir, S_IWUSR);
+#ifdef CONFIG_ACPI
+	MVM_DEBUGFS_ADD_FILE(sar_geo_profile, dbgfs_dir, S_IRUSR);
+#endif
+
 	if (!debugfs_create_bool("enable_scan_iteration_notif",
 				 S_IRUSR | S_IWUSR,
 				 mvm->debugfs_dir,
-- 
2.11.0
