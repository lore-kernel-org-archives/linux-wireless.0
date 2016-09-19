Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55968 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936248AbcISHbm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:31:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Roee Zamir <roee.zamir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:22 +0300
Message-Id: <20160919073028.22065-19-luca@coelho.fi> (sfid-20160919_093144_907984_1D02B5AC)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: mvm: Add debugfs function for clocks diff
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roee Zamir <roee.zamir@intel.com>

New function, reveals the diff between gp2 and host time.

Signed-off-by: Roee Zamir <roee.zamir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index b232717..8ff1921 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -504,6 +504,28 @@ static inline char *iwl_dbgfs_is_match(char *name, char *buf)
 	return !strncmp(name, buf, len) ? buf + len : NULL;
 }
 
+static ssize_t iwl_dbgfs_os_device_timediff_read(struct file *file,
+						 char __user *user_buf,
+						 size_t count, loff_t *ppos)
+{
+	struct ieee80211_vif *vif = file->private_data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	u32 curr_gp2;
+	u64 curr_os;
+	s64 diff;
+	char buf[64];
+	const size_t bufsz = sizeof(buf);
+	int pos = 0;
+
+	iwl_mvm_get_sync_time(mvm, &curr_gp2, &curr_os);
+	do_div(curr_os, NSEC_PER_USEC);
+	diff = curr_os - curr_gp2;
+	pos += scnprintf(buf + pos, bufsz - pos, "diff=%lld\n", diff);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 static ssize_t iwl_dbgfs_tof_enable_write(struct ieee80211_vif *vif,
 					  char *buf,
 					  size_t count, loff_t *ppos)
@@ -1530,6 +1552,8 @@ MVM_DEBUGFS_READ_FILE_OPS(tof_range_response);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_responder_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(quota_min, 32);
 MVM_DEBUGFS_WRITE_FILE_OPS(lqm_send_cmd, 64);
+MVM_DEBUGFS_READ_FILE_OPS(os_device_timediff);
+
 
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -1570,6 +1594,8 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	MVM_DEBUGFS_ADD_FILE_VIF(quota_min, mvmvif->dbgfs_dir,
 				 S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE_VIF(lqm_send_cmd, mvmvif->dbgfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE_VIF(os_device_timediff,
+				 mvmvif->dbgfs_dir, S_IRUSR);
 
 	if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvmvif == mvm->bf_allowed_vif)
-- 
2.9.3
