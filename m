Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbbAVUdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/38] iwlwifi: mvm: Add debugfs entry to enable scan offload notification
Date: Thu, 22 Jan 2015 22:32:56 +0200
Message-Id: <1421958809-3371-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214446_073977_F6AD4042)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

This option enables scan offload iteration complete notification from
firmware which includes the last iteration's status and the scanned
channels from the current iteration.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 23 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |  5 +++++
 drivers/net/wireless/iwlwifi/mvm/ops.c     |  2 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c    | 18 ++++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index f1b3405..f89b795 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1490,6 +1490,26 @@ out:
 	return count;
 }
 
+static ssize_t iwl_dbgfs_enable_scan_iteration_notif_write(struct iwl_mvm *mvm,
+							   char *buf,
+							   size_t count,
+							   loff_t *ppos)
+{
+	int val;
+
+	mutex_lock(&mvm->mutex);
+
+	if (kstrtoint(buf, 10, &val)) {
+		mutex_unlock(&mvm->mutex);
+		return -EINVAL;
+	}
+
+	mvm->scan_iter_notif_enabled = val;
+	mutex_unlock(&mvm->mutex);
+
+	return count;
+}
+
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(prph_reg, 64);
 
 /* Device wide debugfs entries */
@@ -1512,6 +1532,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_collect, 8);
+MVM_DEBUGFS_WRITE_FILE_OPS(enable_scan_iteration_notif, 8);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
@@ -1555,6 +1576,8 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_conf, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(enable_scan_iteration_notif, mvm->debugfs_dir,
+			     S_IWUSR);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index c95297e..6355127 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -642,6 +642,8 @@ struct iwl_mvm {
 	bool disable_power_off;
 	bool disable_power_off_d3;
 
+	bool scan_iter_notif_enabled;
+
 	struct debugfs_blob_wrapper nvm_hw_blob;
 	struct debugfs_blob_wrapper nvm_sw_blob;
 	struct debugfs_blob_wrapper nvm_calib_blob;
@@ -1061,6 +1063,9 @@ int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan);
 int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 					   struct iwl_rx_cmd_buffer *rxb,
 					   struct iwl_device_cmd *cmd);
+int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
+						struct iwl_rx_cmd_buffer *rxb,
+						struct iwl_device_cmd *cmd);
 int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 			      struct ieee80211_vif *vif,
 			      struct cfg80211_sched_scan_request *req,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index b0583fc..12b565a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -234,6 +234,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 
 	RX_HANDLER(SCAN_REQUEST_CMD, iwl_mvm_rx_scan_response, false),
 	RX_HANDLER(SCAN_COMPLETE_NOTIFICATION, iwl_mvm_rx_scan_complete, true),
+	RX_HANDLER(SCAN_ITERATION_COMPLETE,
+		   iwl_mvm_rx_scan_offload_iter_complete_notif, false),
 	RX_HANDLER(SCAN_OFFLOAD_COMPLETE,
 		   iwl_mvm_rx_scan_offload_complete_notif, true),
 	RX_HANDLER(MATCH_FOUND_NOTIFICATION, iwl_mvm_rx_scan_offload_results,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 348b9c4..199f6fc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -536,6 +536,19 @@ int iwl_mvm_rx_scan_response(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	return 0;
 }
 
+int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
+						struct iwl_rx_cmd_buffer *rxb,
+						struct iwl_device_cmd *cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_scan_complete_notif *notif = (void *)pkt->data;
+
+	IWL_DEBUG_SCAN(mvm,
+		       "Scan offload iteration complete: status=0x%x scanned channels=%d\n",
+		       notif->status, notif->scanned_channels);
+	return 0;
+}
+
 int iwl_mvm_rx_scan_complete(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			  struct iwl_device_cmd *cmd)
 {
@@ -1468,6 +1481,11 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 	if (req->n_ssids == 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (mvm->scan_iter_notif_enabled)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE;
+#endif
+
 	cmd->scan_flags |= cpu_to_le32(flags);
 
 	cmd->flags = iwl_mvm_scan_rxon_flags(req->channels[0]->band);
-- 
1.9.1

