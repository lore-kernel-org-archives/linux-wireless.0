Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbcC3OFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Aviya Erenfeld <aviya.erenfeld@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/43] iwlwifi: add a debugfs hook for LQM
Date: Wed, 30 Mar 2016 17:04:38 +0300
Message-Id: <1459346715-7954-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160547_857360_6A8D8884)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

Add debugfs entry named lqm_send_cmd for kicking a
measurement. This hook takes the duration and the timeout
as parameter.

Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   | 85 ++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 1400445..3a279d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -1425,6 +1425,89 @@ static ssize_t iwl_dbgfs_quota_min_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
+static const char * const chanwidths[] = {
+	[NL80211_CHAN_WIDTH_20_NOHT] = "noht",
+	[NL80211_CHAN_WIDTH_20] = "ht20",
+	[NL80211_CHAN_WIDTH_40] = "ht40",
+	[NL80211_CHAN_WIDTH_80] = "vht80",
+	[NL80211_CHAN_WIDTH_80P80] = "vht80p80",
+	[NL80211_CHAN_WIDTH_160] = "vht160",
+};
+
+static bool iwl_mvm_lqm_notif_wait(struct iwl_notif_wait_data *notif_wait,
+				   struct iwl_rx_packet *pkt, void *data)
+{
+	struct ieee80211_vif *vif = data;
+	struct iwl_mvm *mvm =
+		container_of(notif_wait, struct iwl_mvm, notif_wait);
+	struct iwl_link_qual_msrmnt_notif *report = (void *)pkt->data;
+	u32 num_of_stations = le32_to_cpu(report->number_of_stations);
+	int i;
+
+	IWL_INFO(mvm, "LQM report:\n");
+	IWL_INFO(mvm, "\tstatus: %d\n", report->status);
+	IWL_INFO(mvm, "\tmacID: %d\n", le32_to_cpu(report->mac_id));
+	IWL_INFO(mvm, "\ttx_frame_dropped: %d\n",
+		 le32_to_cpu(report->tx_frame_dropped));
+	IWL_INFO(mvm, "\ttime_in_measurement_window: %d us\n",
+		 le32_to_cpu(report->time_in_measurement_window));
+	IWL_INFO(mvm, "\ttotal_air_time_other_stations: %d\n",
+		 le32_to_cpu(report->total_air_time_other_stations));
+	IWL_INFO(mvm, "\tchannel_freq: %d\n",
+		 vif->bss_conf.chandef.center_freq1);
+	IWL_INFO(mvm, "\tchannel_width: %s\n",
+		 chanwidths[vif->bss_conf.chandef.width]);
+	IWL_INFO(mvm, "\tnumber_of_stations: %d\n", num_of_stations);
+	for (i = 0; i < num_of_stations; i++)
+		IWL_INFO(mvm, "\t\tsta[%d]: %d\n", i,
+			 report->frequent_stations_air_time[i]);
+
+	return true;
+}
+
+static ssize_t iwl_dbgfs_lqm_send_cmd_write(struct ieee80211_vif *vif,
+					    char *buf, size_t count,
+					    loff_t *ppos)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	struct iwl_notification_wait wait_lqm_notif;
+	static u16 lqm_notif[] = {
+		WIDE_ID(MAC_CONF_GROUP,
+			LINK_QUALITY_MEASUREMENT_COMPLETE_NOTIF)
+	};
+	int err;
+	u32 duration;
+	u32 timeout;
+
+	if (sscanf(buf, "%d,%d", &duration, &timeout) != 2)
+		return -EINVAL;
+
+	iwl_init_notification_wait(&mvm->notif_wait, &wait_lqm_notif,
+				   lqm_notif, ARRAY_SIZE(lqm_notif),
+				   iwl_mvm_lqm_notif_wait, vif);
+	mutex_lock(&mvm->mutex);
+	err = iwl_mvm_send_lqm_cmd(vif, LQM_CMD_OPERATION_START_MEASUREMENT,
+				   duration, timeout);
+	mutex_unlock(&mvm->mutex);
+
+	if (err) {
+		IWL_ERR(mvm, "Failed to send lqm cmdf(err=%d)\n", err);
+		iwl_remove_notification(&mvm->notif_wait, &wait_lqm_notif);
+		return err;
+	}
+
+	/* wait for 2 * timeout (safety guard) and convert to jiffies*/
+	timeout = msecs_to_jiffies((timeout * 2) / 1000);
+
+	err = iwl_wait_notification(&mvm->notif_wait, &wait_lqm_notif,
+				    timeout);
+	if (err)
+		IWL_ERR(mvm, "Getting lqm notif timed out\n");
+
+	return count;
+}
+
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
@@ -1449,6 +1532,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_range_abort, 32);
 MVM_DEBUGFS_READ_FILE_OPS(tof_range_response);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_responder_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(quota_min, 32);
+MVM_DEBUGFS_WRITE_FILE_OPS(lqm_send_cmd, 64);
 
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -1488,6 +1572,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 				 S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE_VIF(quota_min, mvmvif->dbgfs_dir,
 				 S_IRUSR | S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE_VIF(lqm_send_cmd, mvmvif->dbgfs_dir, S_IWUSR);
 
 	if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvmvif == mvm->bf_allowed_vif)
-- 
2.5.0

