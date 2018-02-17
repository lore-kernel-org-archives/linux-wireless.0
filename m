Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59248 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751029AbeBQIeD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:03 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:46 +0200
Message-Id: <20180217083354.31160-2-luca@coelho.fi> (sfid-20180217_093424_368543_DE33A556)
In-Reply-To: <20180217083354.31160-1-luca@coelho.fi>
References: <20180217083354.31160-1-luca@coelho.fi>
Subject: [PATCH 1/9] iwlwifi: Cancel and set MARKER_CMD timer during suspend-resume
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

While entering to D3 mode there is a gap between the time the
driver handles the D3_CONFIG_CMD response to the time the host is going
to sleep.
In between there might be cases which MARKER_CMD can tailgate.
Also during resume flow the MARKER_CMD might get sent while D0I3_CMD
is being handled in the FW.
Cancel MARKER_CMD timer and set it again properly during suspend
resume flows to prevent this command from being sent accidentlly.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h | 18 ++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/init.c    | 12 ++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h |  4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c     |  8 ++++++++
 4 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
index e57ff92a68ae..3da468d2cc92 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
@@ -75,6 +75,20 @@ static inline void iwl_fw_cancel_timestamp(struct iwl_fw_runtime *fwrt)
 	cancel_delayed_work_sync(&fwrt->timestamp.wk);
 }
 
+static inline void iwl_fw_suspend_timestamp(struct iwl_fw_runtime *fwrt)
+{
+	cancel_delayed_work_sync(&fwrt->timestamp.wk);
+}
+
+static inline void iwl_fw_resume_timestamp(struct iwl_fw_runtime *fwrt)
+{
+	if (!fwrt->timestamp.delay)
+		return;
+
+	schedule_delayed_work(&fwrt->timestamp.wk,
+			      round_jiffies_relative(fwrt->timestamp.delay));
+}
+
 #else
 static inline int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
 					  struct dentry *dbgfs_dir)
@@ -84,4 +98,8 @@ static inline int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
 
 static inline void iwl_fw_cancel_timestamp(struct iwl_fw_runtime *fwrt) {}
 
+static inline void iwl_fw_suspend_timestamp(struct iwl_fw_runtime *fwrt) {}
+
+static inline void iwl_fw_resume_timestamp(struct iwl_fw_runtime *fwrt) {}
+
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/init.c b/drivers/net/wireless/intel/iwlwifi/fw/init.c
index 45f21acbd842..2efac307909e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/init.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/init.c
@@ -76,3 +76,15 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 	iwl_fwrt_dbgfs_register(fwrt, dbgfs_dir);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_runtime_init);
+
+void iwl_fw_runtime_suspend(struct iwl_fw_runtime *fwrt)
+{
+	iwl_fw_suspend_timestamp(fwrt);
+}
+IWL_EXPORT_SYMBOL(iwl_fw_runtime_suspend);
+
+void iwl_fw_runtime_resume(struct iwl_fw_runtime *fwrt)
+{
+	iwl_fw_resume_timestamp(fwrt);
+}
+IWL_EXPORT_SYMBOL(iwl_fw_runtime_resume);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index e25c049f980f..f3197f7c13b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -150,6 +150,10 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 
 void iwl_fw_runtime_exit(struct iwl_fw_runtime *fwrt);
 
+void iwl_fw_runtime_suspend(struct iwl_fw_runtime *fwrt);
+
+void iwl_fw_runtime_resume(struct iwl_fw_runtime *fwrt);
+
 static inline void iwl_fw_set_current_image(struct iwl_fw_runtime *fwrt,
 					    enum iwl_ucode_type cur_fw_img)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 0e6cf39285f4..2efe9b099556 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1098,6 +1098,8 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	/* make sure the d0i3 exit work is not pending */
 	flush_work(&mvm->d0i3_exit_work);
 
+	iwl_fw_runtime_suspend(&mvm->fwrt);
+
 	ret = iwl_trans_suspend(trans);
 	if (ret)
 		return ret;
@@ -2012,6 +2014,8 @@ int iwl_mvm_resume(struct ieee80211_hw *hw)
 
 	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
 
+	iwl_fw_runtime_resume(&mvm->fwrt);
+
 	return ret;
 }
 
@@ -2038,6 +2042,8 @@ static int iwl_mvm_d3_test_open(struct inode *inode, struct file *file)
 
 	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_D3;
 
+	iwl_fw_runtime_suspend(&mvm->fwrt);
+
 	/* start pseudo D3 */
 	rtnl_lock();
 	err = __iwl_mvm_suspend(mvm->hw, mvm->hw->wiphy->wowlan_config, true);
@@ -2098,6 +2104,8 @@ static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 	__iwl_mvm_resume(mvm, true);
 	rtnl_unlock();
 
+	iwl_fw_runtime_resume(&mvm->fwrt);
+
 	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
 
 	iwl_abort_notification_waits(&mvm->notif_wait);
-- 
2.15.1
