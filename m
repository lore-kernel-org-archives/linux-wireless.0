Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbbLAJ7r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:47 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/41] iwlwifi: mvm: Support setting continuous recording debug mode
Date: Tue,  1 Dec 2015 11:58:51 +0200
Message-Id: <1448963947-24302-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110300_963206_6569A662)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Add ability to set the continuous recording mode of the FW, while
the FW debug data is configured to be stored on the NIC.
This could be useful for storing large segments of FW usniffer
debug data on the host, while having small store space on the NIC.
The host receives the usniffer data through the regular RX path, and
the data can get extracted using trace-cmd.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 40 ++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h  | 21 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c     |  1 +
 3 files changed, 62 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 3f7682d..7e2a814 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -961,6 +961,44 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+/*
+ * Enable / Disable continuous recording.
+ * Cause the FW to start continuous recording, by sending the relevant hcmd.
+ * Enable: input of every integer larger than 0, ENABLE_CONT_RECORDING.
+ * Disable: for 0 as input, DISABLE_CONT_RECORDING.
+ */
+static ssize_t iwl_dbgfs_cont_recording_write(struct iwl_mvm *mvm,
+					      char *buf, size_t count,
+					      loff_t *ppos)
+{
+	struct iwl_trans *trans = mvm->trans;
+	const struct iwl_fw_dbg_dest_tlv *dest = trans->dbg_dest_tlv;
+	struct iwl_continuous_record_cmd cont_rec = {};
+	int ret, rec_mode;
+
+	if (!dest)
+		return -EOPNOTSUPP;
+
+	if (dest->monitor_mode != SMEM_MODE ||
+	    trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		return -EOPNOTSUPP;
+
+	ret = kstrtouint(buf, 0, &rec_mode);
+	if (ret)
+		return ret;
+
+	cont_rec.record_mode.enable_recording = rec_mode ?
+		cpu_to_le16(ENABLE_CONT_RECORDING) :
+		cpu_to_le16(DISABLE_CONT_RECORDING);
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_send_cmd_pdu(mvm, LDBG_CONFIG_CMD, 0,
+				   sizeof(cont_rec), &cont_rec);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
 static ssize_t iwl_dbgfs_fw_dbg_conf_write(struct iwl_mvm *mvm,
 					   char *buf, size_t count,
 					   loff_t *ppos)
@@ -1413,6 +1451,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_collect, 8);
+MVM_DEBUGFS_WRITE_FILE_OPS(cont_recording, 8);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
@@ -1456,6 +1495,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_conf, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(send_echo_cmd, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(cont_recording, mvm->debugfs_dir, S_IWUSR);
 	if (!debugfs_create_bool("enable_scan_iteration_notif",
 				 S_IRUSR | S_IWUSR,
 				 mvm->debugfs_dir,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 181590f..68dfa28 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -239,6 +239,7 @@ enum {
 	DTS_MEASUREMENT_NOTIFICATION = 0xdd,
 
 	REPLY_DEBUG_CMD = 0xf0,
+	LDBG_CONFIG_CMD = 0xf6,
 	DEBUG_LOG_MSG = 0xf7,
 
 	BCAST_FILTER_CMD = 0xcf,
@@ -426,6 +427,26 @@ struct iwl_fw_get_item_cmd {
 	__le32 item_id;
 } __packed; /* FW_GET_ITEM_CMD_API_S_VER_1 */
 
+#define CONT_REC_COMMAND_SIZE	80
+#define ENABLE_CONT_RECORDING	0x15
+#define DISABLE_CONT_RECORDING	0x16
+
+/*
+ * struct iwl_continuous_record_mode - recording mode
+ */
+struct iwl_continuous_record_mode {
+	__le16 enable_recording;
+} __packed;
+
+/*
+ * struct iwl_continuous_record_cmd - enable/disable continuous recording
+ */
+struct iwl_continuous_record_cmd {
+	struct iwl_continuous_record_mode record_mode;
+	u8 pad[CONT_REC_COMMAND_SIZE -
+		sizeof(struct iwl_continuous_record_mode)];
+} __packed;
+
 struct iwl_fw_get_item_resp {
 	__le32 item_id;
 	__le32 item_byte_cnt;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index f96ed55..fa849a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -363,6 +363,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX + 1] = {
 	CMD(TDLS_CONFIG_CMD),
 	CMD(MCC_UPDATE_CMD),
 	CMD(SCAN_ITERATION_COMPLETE_UMAC),
+	CMD(LDBG_CONFIG_CMD),
 };
 #undef CMD
 
-- 
2.5.0

