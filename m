Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59466 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751237AbdFEUoN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:44:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:05 +0300
Message-Id: <20170605204218.30151-13-luca@coelho.fi> (sfid-20170605_224444_326457_9EE8964C)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 12/25] iwlwifi: mvm: check firmware is up in debugfs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Protect various debugfs files that need to communicate with the
firmware from being used when the firmware isn't running.

Some will just reject getting written to, while others that store
some state will simply store it and not apply it immediately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 55 +++++++++++++++++++++---
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 59aaab8274c2..25092cb08c2e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -583,7 +583,11 @@ iwl_dbgfs_bt_force_ant_write(struct iwl_mvm *mvm, char *buf,
 	mvm->bt_force_ant_mode = bt_force_ant_mode;
 	IWL_DEBUG_COEX(mvm, "Force mode: %s\n",
 		       modes_str[mvm->bt_force_ant_mode]);
-	ret = iwl_send_bt_init_conf(mvm);
+
+	if (iwl_mvm_firmware_running(mvm))
+		ret = iwl_send_bt_init_conf(mvm);
+	else
+		ret = 0;
 
 out:
 	mutex_unlock(&mvm->mutex);
@@ -800,6 +804,9 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct iwl_mvm *mvm, char *buf,
 {
 	int __maybe_unused ret;
 
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
 	mutex_lock(&mvm->mutex);
 
 	/* allow one more restart that we're provoking here */
@@ -817,7 +824,12 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct iwl_mvm *mvm, char *buf,
 static ssize_t iwl_dbgfs_fw_nmi_write(struct iwl_mvm *mvm, char *buf,
 				      size_t count, loff_t *ppos)
 {
-	int ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_NMI);
+	int ret;
+
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
+	ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_NMI);
 	if (ret)
 		return ret;
 
@@ -857,6 +869,9 @@ iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 {
 	u8 scan_rx_ant;
 
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
 	if (sscanf(buf, "%hhx", &scan_rx_ant) != 1)
 		return -EINVAL;
 	if (scan_rx_ant > ANT_ABC)
@@ -911,7 +926,11 @@ static ssize_t iwl_dbgfs_indirection_tbl_write(struct iwl_mvm *mvm,
 	netdev_rss_key_fill(cmd.secret_key, sizeof(cmd.secret_key));
 
 	mutex_lock(&mvm->mutex);
-	ret = iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0, sizeof(cmd), &cmd);
+	if (iwl_mvm_firmware_running(mvm))
+		ret = iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0,
+					   sizeof(cmd), &cmd);
+	else
+		ret = 0;
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
@@ -931,6 +950,9 @@ static ssize_t iwl_dbgfs_inject_packet_write(struct iwl_mvm *mvm,
 	int bin_len = count / 2;
 	int ret = -EINVAL;
 
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
 	/* supporting only 9000 descriptor */
 	if (!mvm->trans->cfg->mq_rx_supported)
 		return -ENOTSUPP;
@@ -1004,6 +1026,9 @@ static ssize_t iwl_dbgfs_cont_recording_write(struct iwl_mvm *mvm,
 	struct iwl_continuous_record_cmd cont_rec = {};
 	int ret, rec_mode;
 
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
 	if (!dest)
 		return -EOPNOTSUPP;
 
@@ -1034,6 +1059,9 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_write(struct iwl_mvm *mvm,
 	unsigned int conf_id;
 	int ret;
 
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
 	ret = kstrtouint(buf, 0, &conf_id);
 	if (ret)
 		return ret;
@@ -1052,8 +1080,12 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 					      char *buf, size_t count,
 					      loff_t *ppos)
 {
-	int ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PRPH_WRITE);
+	int ret;
+
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
 
+	ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PRPH_WRITE);
 	if (ret)
 		return ret;
 	if (count == 0)
@@ -1184,7 +1216,8 @@ static ssize_t iwl_dbgfs_bcast_filters_write(struct iwl_mvm *mvm, char *buf,
 	       &filter, sizeof(filter));
 
 	/* send updated bcast filtering configuration */
-	if (mvm->dbgfs_bcast_filtering.override &&
+	if (iwl_mvm_firmware_running(mvm) &&
+	    mvm->dbgfs_bcast_filtering.override &&
 	    iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
 		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, 0,
 					   sizeof(cmd), &cmd);
@@ -1256,7 +1289,8 @@ static ssize_t iwl_dbgfs_bcast_filters_macs_write(struct iwl_mvm *mvm,
 	       &mac, sizeof(mac));
 
 	/* send updated bcast filtering configuration */
-	if (mvm->dbgfs_bcast_filtering.override &&
+	if (iwl_mvm_firmware_running(mvm) &&
+	    mvm->dbgfs_bcast_filtering.override &&
 	    iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
 		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, 0,
 					   sizeof(cmd), &cmd);
@@ -1473,6 +1507,9 @@ iwl_dbgfs_send_echo_cmd_write(struct iwl_mvm *mvm, char *buf,
 {
 	int ret;
 
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
 	mutex_lock(&mvm->mutex);
 	ret = iwl_mvm_send_cmd_pdu(mvm, ECHO_CMD, 0, 0, NULL);
 	mutex_unlock(&mvm->mutex);
@@ -1534,6 +1571,9 @@ static ssize_t iwl_dbgfs_mem_read(struct file *file, char __user *user_buf,
 	size_t delta;
 	ssize_t ret, len;
 
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
 	hcmd.id = iwl_cmd_id(*ppos >> 24 ? UMAC_RD_WR : LMAC_RD_WR,
 			     DEBUG_GROUP, 0);
 	cmd.op = cpu_to_le32(DEBUG_MEM_OP_READ);
@@ -1586,6 +1626,9 @@ static ssize_t iwl_dbgfs_mem_write(struct file *file,
 	u32 op, len;
 	ssize_t ret;
 
+	if (!iwl_mvm_firmware_running(mvm))
+		return -EIO;
+
 	hcmd.id = iwl_cmd_id(*ppos >> 24 ? UMAC_RD_WR : LMAC_RD_WR,
 			     DEBUG_GROUP, 0);
 
-- 
2.11.0
