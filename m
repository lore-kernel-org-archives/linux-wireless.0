Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62728 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaIOFNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:34 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so3285622wgh.8
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:33 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/28] iwlwifi: mvm: allow to collect debug data when restart is disabled
Date: Mon, 15 Sep 2014 08:12:52 +0300
Message-Id: <1410757980-2138-20-git-send-email-egrumbach@gmail.com> (sfid-20140915_073114_663092_762C485A)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In some testing configuration, the firmware restart flow is
not enabled. Allow to collect logs even in this case.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 14 ++++++--------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  6 ++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c      | 15 +++++++++++++++
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5c33d2d..e4d62f2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -670,8 +670,9 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-static void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
+void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 {
+	static char *env[] = { "DRIVER=iwlwifi", "EVENT=error_dump", NULL };
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
@@ -763,20 +764,16 @@ static void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		file_len += fw_error_dump->trans_ptr->len;
 	dump_file->file_len = cpu_to_le32(file_len);
 	mvm->fw_error_dump = fw_error_dump;
+
+	/* notify the userspace about the error we had */
+	kobject_uevent_env(&mvm->hw->wiphy->dev.kobj, KOBJ_CHANGE, env);
 }
 #endif
 
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	static char *env[] = { "DRIVER=iwlwifi", "EVENT=error_dump", NULL };
-
 	iwl_mvm_fw_error_dump(mvm);
 
-	/* notify the userspace about the error we had */
-	kobject_uevent_env(&mvm->hw->wiphy->dev.kobj, KOBJ_CHANGE, env);
-#endif
-
 	iwl_trans_stop_device(mvm->trans);
 
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
@@ -903,6 +900,7 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 
 	flush_work(&mvm->d0i3_exit_work);
 	flush_work(&mvm->async_handlers_wk);
+	flush_work(&mvm->fw_error_dump_wk);
 
 	mutex_lock(&mvm->mutex);
 	__iwl_mvm_mac_stop(mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a36fa6c6..1fdebb8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -651,6 +651,7 @@ struct iwl_mvm {
 
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 restart_fw;
+	struct work_struct fw_error_dump_wk;
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
 
 #ifdef CONFIG_IWLWIFI_LEDS
@@ -1162,5 +1163,10 @@ int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
+#else
+static inline void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm) {}
+#endif
 
 #endif /* __IWL_MVM_H__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 9710084..f887779 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -366,6 +366,8 @@ static u32 calc_min_backoff(struct iwl_trans *trans, const struct iwl_cfg *cfg)
 	return 0;
 }
 
+static void iwl_mvm_fw_error_dump_wk(struct work_struct *work);
+
 static struct iwl_op_mode *
 iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		      const struct iwl_fw *fw, struct dentry *dbgfs_dir)
@@ -433,6 +435,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_WORK(&mvm->roc_done_wk, iwl_mvm_roc_done_wk);
 	INIT_WORK(&mvm->sta_drained_wk, iwl_mvm_sta_drained_wk);
 	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
+	INIT_WORK(&mvm->fw_error_dump_wk, iwl_mvm_fw_error_dump_wk);
 
 	spin_lock_init(&mvm->d0i3_tx_lock);
 	spin_lock_init(&mvm->refs_lock);
@@ -784,6 +787,16 @@ static void iwl_mvm_reprobe_wk(struct work_struct *wk)
 	module_put(THIS_MODULE);
 }
 
+static void iwl_mvm_fw_error_dump_wk(struct work_struct *work)
+{
+	struct iwl_mvm *mvm =
+		container_of(work, struct iwl_mvm, fw_error_dump_wk);
+
+	mutex_lock(&mvm->mutex);
+	iwl_mvm_fw_error_dump(mvm);
+	mutex_unlock(&mvm->mutex);
+}
+
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 {
 	iwl_abort_notification_waits(&mvm->notif_wait);
@@ -849,6 +862,8 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 		if (fw_error && mvm->restart_fw > 0)
 			mvm->restart_fw--;
 		ieee80211_restart_hw(mvm->hw);
+	} else if (fw_error) {
+		schedule_work(&mvm->fw_error_dump_wk);
 	}
 }
 
-- 
1.9.1

