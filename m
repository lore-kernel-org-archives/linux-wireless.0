Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56086 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756422AbcISIfi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 04:35:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Roee Zamir <roee.zamir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 11:35:30 +0300
Message-Id: <20160919083530.7496-1-luca@coelho.fi> (sfid-20160919_103630_430243_AA4AA17C)
In-Reply-To: <0160919073028.22065-19-luca@coelho.fi>
References: <0160919073028.22065-19-luca@coelho.fi>
Subject: [PATCH v2 19/25] iwlwifi: mvm: Add debugfs function for clocks diff
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roee Zamir <roee.zamir@intel.com>

New function, reveals the diff between gp2 and host time.

Signed-off-by: Roee Zamir <roee.zamir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

Sorry, I was missing a compilation flag in my .config and missed a
compilation error detected by kbuild-bot.  Here's the fix.

In v2:
   * added a helper function that was missing

Luca.

.../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   | 26 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 22 ++++++++++++++++++
 3 files changed, 49 insertions(+)

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
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index e68a2bd..b7cfdcb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1268,6 +1268,7 @@ u8 iwl_mvm_mac80211_idx_to_hwrate(int rate_idx);
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm);
 u8 first_antenna(u8 mask);
 u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx);
+void iwl_mvm_get_sync_time(struct iwl_mvm *mvm, u32 *gp2, u64 *boottime);
 
 /* Tx / Host Commands */
 int __must_check iwl_mvm_send_cmd(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 7c138fe..9e366e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1225,6 +1225,28 @@ void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 	rcu_read_unlock();
 }
 
+void iwl_mvm_get_sync_time(struct iwl_mvm *mvm, u32 *gp2, u64 *boottime)
+{
+	bool ps_disabled;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* Disable power save when reading GP2 */
+	ps_disabled = mvm->ps_disabled;
+	if (!ps_disabled) {
+		mvm->ps_disabled = true;
+		iwl_mvm_power_update_device(mvm);
+	}
+
+	*gp2 = iwl_read_prph(mvm->trans, DEVICE_SYSTEM_TIME_REG);
+	*boottime = ktime_get_boot_ns();
+
+	if (!ps_disabled) {
+		mvm->ps_disabled = ps_disabled;
+		iwl_mvm_power_update_device(mvm);
+	}
+}
+
 int iwl_mvm_send_lqm_cmd(struct ieee80211_vif *vif,
 			 enum iwl_lqm_cmd_operatrions operation,
 			 u32 duration, u32 timeout)
-- 
2.9.3
