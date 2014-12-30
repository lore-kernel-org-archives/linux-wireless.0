Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaL3OUC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:02 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/33] iwlwifi: mvm: support IWL_D0I3_MODE_ON_SUSPEND d0i3 mode
Date: Tue, 30 Dec 2014 16:18:53 +0200
Message-Id: <1419949148-24046-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154347_052382_C40A6B48)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Enter d0i3 on suspend, and exit d0i3. Wait for the
command responses in both cases.

Use this mode in case of pcie trans.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       | 40 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  7 +++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  5 ++--
 drivers/net/wireless/iwlwifi/pcie/trans.c   |  1 +
 5 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index a64894c..4b5849e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1137,6 +1137,29 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static int iwl_mvm_enter_d0i3_sync(struct iwl_mvm *mvm)
+{
+	struct iwl_notification_wait wait_d3;
+	static const u8 d3_notif[] = { D3_CONFIG_CMD };
+	int ret;
+
+	iwl_init_notification_wait(&mvm->notif_wait, &wait_d3,
+				   d3_notif, ARRAY_SIZE(d3_notif),
+				   NULL, NULL);
+
+	ret = iwl_mvm_enter_d0i3(mvm->hw->priv);
+	if (ret)
+		goto remove_notif;
+
+	ret = iwl_wait_notification(&mvm->notif_wait, &wait_d3, HZ);
+	WARN_ON_ONCE(ret);
+	return ret;
+
+remove_notif:
+	iwl_remove_notification(&mvm->notif_wait, &wait_d3);
+	return ret;
+}
+
 int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
@@ -1144,6 +1167,13 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	iwl_trans_suspend(mvm->trans);
 	if (wowlan->any) {
 		/* 'any' trigger means d0i3 usage */
+		if (mvm->trans->d0i3_mode == IWL_D0I3_MODE_ON_SUSPEND) {
+			int ret = iwl_mvm_enter_d0i3_sync(mvm);
+
+			if (ret)
+				return ret;
+		}
+
 		mutex_lock(&mvm->d0i3_suspend_mutex);
 		__set_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
 		mutex_unlock(&mvm->d0i3_suspend_mutex);
@@ -1879,6 +1909,16 @@ int iwl_mvm_resume(struct ieee80211_hw *hw)
 
 	if (mvm->hw->wiphy->wowlan_config->any) {
 		/* 'any' trigger means d0i3 usage */
+		if (mvm->trans->d0i3_mode == IWL_D0I3_MODE_ON_SUSPEND) {
+			int ret = iwl_mvm_exit_d0i3(hw->priv);
+
+			if (ret)
+				return ret;
+			/*
+			 * d0i3 exit will be deferred until reconfig_complete.
+			 * make sure there we are out of d0i3.
+			 */
+		}
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index fd0f8ce..29f0feb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1021,6 +1021,13 @@ static void iwl_mvm_resume_complete(struct iwl_mvm *mvm)
 		IWL_DEBUG_RPM(mvm, "Run deferred d0i3 exit\n");
 		_iwl_mvm_exit_d0i3(mvm);
 	}
+
+	if (mvm->trans->d0i3_mode == IWL_D0I3_MODE_ON_SUSPEND)
+		if (!wait_event_timeout(mvm->d0i3_exit_waitq,
+					!test_bit(IWL_MVM_STATUS_IN_D0I3,
+						  &mvm->status),
+					HZ))
+			WARN_ONCE(1, "D0i3 exit on resume timed out\n");
 }
 
 static void
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e608dc4..33a674a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1187,6 +1187,8 @@ void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 int iwl_mvm_ref_sync(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 bool iwl_mvm_ref_taken(struct iwl_mvm *mvm);
 void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq);
+int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode);
+int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode);
 int _iwl_mvm_exit_d0i3(struct iwl_mvm *mvm);
 
 /* BT Coex */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index b2fa3b8..17f58ca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1030,7 +1030,8 @@ static void iwl_mvm_set_wowlan_data(struct iwl_mvm *mvm,
 out:
 	rcu_read_unlock();
 }
-static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
+
+int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE;
@@ -1244,7 +1245,7 @@ out:
 	return ret;
 }
 
-static int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
+int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index fbdbec8..daec2f8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2453,6 +2453,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	}
 
 	trans_pcie->inta_mask = CSR_INI_SET_MASK;
+	trans->d0i3_mode = IWL_D0I3_MODE_ON_SUSPEND;
 
 	return trans;
 
-- 
1.9.1

