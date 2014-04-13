Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54168 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbaDMTVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:15 -0400
Received: by mail-wi0-f176.google.com with SMTP id r20so3129465wiv.15
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:14 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 44/47] iwlwifi: mvm: don't use d3 fw if d0i3 is used
Date: Sun, 13 Apr 2014 22:19:59 +0300
Message-Id: <1397416802-32403-44-git-send-email-egrumbach@gmail.com> (sfid-20140413_213515_627492_E1A5413E)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

bail out from the suspend/resume callbacks if
d0i3 is used.

declare support for ANY wowlan trigger (i.e.
normal operation).

On resume, we shouldn't execute the d0i3 exit
flow (which might disconnect stations, etc.)
until mac80211 was resumed.
Add new flags to indicate we are in suspend,
and call the pending exit work on resume.

Since the resume flow can take some time, add
a new EXIT_WORK reference type to prevent going
back to d0i3 at this stage.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       | 22 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  |  1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  6 +++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 10 ++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c      | 22 ++++++++++++++++++++--
 5 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 5c9f14d..7694472 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1074,6 +1074,15 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	if (iwl_mvm_is_d0i3_supported(mvm)) {
+		mutex_lock(&mvm->d0i3_suspend_mutex);
+		__set_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
+		mutex_unlock(&mvm->d0i3_suspend_mutex);
+		return 0;
+	}
+
 	return __iwl_mvm_suspend(hw, wowlan, false);
 }
 
@@ -1646,6 +1655,19 @@ int iwl_mvm_resume(struct ieee80211_hw *hw)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
+	if (iwl_mvm_is_d0i3_supported(mvm)) {
+		bool exit_now;
+
+		mutex_lock(&mvm->d0i3_suspend_mutex);
+		__clear_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
+		exit_now = __test_and_clear_bit(D0I3_PENDING_WAKEUP,
+						&mvm->d0i3_suspend_flags);
+		mutex_unlock(&mvm->d0i3_suspend_mutex);
+		if (exit_now)
+			_iwl_mvm_exit_d0i3(mvm);
+		return 0;
+	}
+
 	return __iwl_mvm_resume(mvm, false);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index db368cd..c152188 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1001,6 +1001,7 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 	PRINT_MVM_REF(IWL_MVM_REF_P2P_CLIENT);
 	PRINT_MVM_REF(IWL_MVM_REF_AP_IBSS);
 	PRINT_MVM_REF(IWL_MVM_REF_USER);
+	PRINT_MVM_REF(IWL_MVM_REF_EXIT_WORK);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 374ecd4..3e8437f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -381,7 +381,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	}
 
 #ifdef CONFIG_PM_SLEEP
-	if (mvm->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
+	if (iwl_mvm_is_d0i3_supported(mvm) &&
+	    device_can_wakeup(mvm->trans->dev)) {
+		mvm->wowlan.flags = WIPHY_WOWLAN_ANY;
+		hw->wiphy->wowlan = &mvm->wowlan;
+	} else if (mvm->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
 	    mvm->trans->ops->d3_suspend &&
 	    mvm->trans->ops->d3_resume &&
 	    device_can_wakeup(mvm->trans->dev)) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 41184a4..17c42da 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -230,6 +230,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_USER,
 	IWL_MVM_REF_TX,
 	IWL_MVM_REF_TX_AGG,
+	IWL_MVM_REF_EXIT_WORK,
 
 	IWL_MVM_REF_COUNT,
 };
@@ -451,6 +452,11 @@ struct iwl_mvm_frame_stats {
 	int last_frame_idx;
 };
 
+enum {
+	D0I3_DEFER_WAKEUP,
+	D0I3_PENDING_WAKEUP,
+};
+
 struct iwl_mvm {
 	/* for logger access */
 	struct device *dev;
@@ -605,6 +611,9 @@ struct iwl_mvm {
 	bool d0i3_offloading;
 	struct work_struct d0i3_exit_work;
 	struct sk_buff_head d0i3_tx;
+	/* protect d0i3_suspend_flags */
+	struct mutex d0i3_suspend_mutex;
+	unsigned long d0i3_suspend_flags;
 	/* sync d0i3_tx queue and IWL_MVM_STATUS_IN_D0I3 status flag */
 	spinlock_t d0i3_tx_lock;
 	wait_queue_head_t d0i3_exit_waitq;
@@ -923,6 +932,7 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq);
+int _iwl_mvm_exit_d0i3(struct iwl_mvm *mvm);
 
 /* BT Coex */
 int iwl_send_bt_init_conf(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index fd53128..7a5a8ba 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -402,6 +402,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mvm->sf_state = SF_UNINIT;
 
 	mutex_init(&mvm->mutex);
+	mutex_init(&mvm->d0i3_suspend_mutex);
 	spin_lock_init(&mvm->async_handlers_lock);
 	INIT_LIST_HEAD(&mvm->time_event_list);
 	INIT_LIST_HEAD(&mvm->async_handlers_list);
@@ -1174,18 +1175,27 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 	iwl_free_resp(&get_status_cmd);
 out:
 	iwl_mvm_d0i3_enable_tx(mvm, qos_seq);
+	iwl_mvm_unref(mvm, IWL_MVM_REF_EXIT_WORK);
 	mutex_unlock(&mvm->mutex);
 }
 
-static int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
+int _iwl_mvm_exit_d0i3(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE |
 		    CMD_WAKE_UP_TRANS;
 	int ret;
 
 	IWL_DEBUG_RPM(mvm, "MVM exiting D0i3\n");
 
+	mutex_lock(&mvm->d0i3_suspend_mutex);
+	if (test_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags)) {
+		IWL_DEBUG_RPM(mvm, "Deferring d0i3 exit until resume\n");
+		__set_bit(D0I3_PENDING_WAKEUP, &mvm->d0i3_suspend_flags);
+		mutex_unlock(&mvm->d0i3_suspend_mutex);
+		return 0;
+	}
+	mutex_unlock(&mvm->d0i3_suspend_mutex);
+
 	ret = iwl_mvm_send_cmd_pdu(mvm, D0I3_END_CMD, flags, 0, NULL);
 	if (ret)
 		goto out;
@@ -1199,6 +1209,14 @@ out:
 	return ret;
 }
 
+static int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
+{
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	iwl_mvm_ref(mvm, IWL_MVM_REF_EXIT_WORK);
+	return _iwl_mvm_exit_d0i3(mvm);
+}
+
 static void iwl_mvm_napi_add(struct iwl_op_mode *op_mode,
 			     struct napi_struct *napi,
 			     struct net_device *napi_dev,
-- 
1.8.3.2

