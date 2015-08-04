Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbbHDU7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:10 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/37] Revert "iwlwifi: mvm: move deferred d0i3 exit to resume_complete op"
Date: Tue,  4 Aug 2015 23:43:12 +0300
Message-Id: <1438721007-23283-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230031_811913_B80E0044)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

This reverts commit 088070a2f6575402d3dd82e1c5a4a8e1941805f6.

When working in d0i3_on_idle mode, we explicitly go out
of d0i3 on resume (so other potential commands could
be sent).

However, D0I3_DEFER_WAKEUP is currently cleared on
resume complete (which happens only later on), causing
d0i3 exit to timeout.

Since mac80211 was modified to accept incoming frames
once drv_resume was called, we can safely revert this
patch, and handle the pending work on iwl_mvm_resume().

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       | 58 +++++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 13 -------
 2 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 4165d10..246e60a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1935,28 +1935,56 @@ out:
 	return 1;
 }
 
-int iwl_mvm_resume(struct ieee80211_hw *hw)
+static int iwl_mvm_resume_d3(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	iwl_trans_resume(mvm->trans);
+
+	return __iwl_mvm_resume(mvm, false);
+}
+
+static int iwl_mvm_resume_d0i3(struct iwl_mvm *mvm)
+{
+	bool exit_now;
+
+	/*
+	 * make sure to clear D0I3_DEFER_WAKEUP before
+	 * calling iwl_trans_resume(), which might wait
+	 * for d0i3 exit completion.
+	 */
+	mutex_lock(&mvm->d0i3_suspend_mutex);
+	__clear_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
+	exit_now = __test_and_clear_bit(D0I3_PENDING_WAKEUP,
+					&mvm->d0i3_suspend_flags);
+	mutex_unlock(&mvm->d0i3_suspend_mutex);
+	if (exit_now) {
+		IWL_DEBUG_RPM(mvm, "Run deferred d0i3 exit\n");
+		_iwl_mvm_exit_d0i3(mvm);
+	}
 
 	iwl_trans_resume(mvm->trans);
 
-	if (mvm->hw->wiphy->wowlan_config->any) {
-		/* 'any' trigger means d0i3 usage */
-		if (mvm->trans->d0i3_mode == IWL_D0I3_MODE_ON_SUSPEND) {
-			int ret = iwl_mvm_exit_d0i3(hw->priv);
+	if (mvm->trans->d0i3_mode == IWL_D0I3_MODE_ON_SUSPEND) {
+		int ret = iwl_mvm_exit_d0i3(mvm->hw->priv);
 
-			if (ret)
-				return ret;
-			/*
-			 * d0i3 exit will be deferred until reconfig_complete.
-			 * make sure there we are out of d0i3.
-			 */
-		}
-		return 0;
+		if (ret)
+			return ret;
+		/*
+		 * d0i3 exit will be deferred until reconfig_complete.
+		 * make sure there we are out of d0i3.
+		 */
 	}
+	return 0;
+}
 
-	return __iwl_mvm_resume(mvm, false);
+int iwl_mvm_resume(struct ieee80211_hw *hw)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	/* 'any' trigger means d0i3 was used */
+	if (hw->wiphy->wowlan_config->any)
+		return iwl_mvm_resume_d0i3(mvm);
+	else
+		return iwl_mvm_resume_d3(mvm);
 }
 
 void iwl_mvm_set_wakeup(struct ieee80211_hw *hw, bool enabled)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index dfdab38..45e9913 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1433,22 +1433,9 @@ static void iwl_mvm_restart_complete(struct iwl_mvm *mvm)
 
 static void iwl_mvm_resume_complete(struct iwl_mvm *mvm)
 {
-	bool exit_now;
-
 	if (!iwl_mvm_is_d0i3_supported(mvm))
 		return;
 
-	mutex_lock(&mvm->d0i3_suspend_mutex);
-	__clear_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
-	exit_now = __test_and_clear_bit(D0I3_PENDING_WAKEUP,
-					&mvm->d0i3_suspend_flags);
-	mutex_unlock(&mvm->d0i3_suspend_mutex);
-
-	if (exit_now) {
-		IWL_DEBUG_RPM(mvm, "Run deferred d0i3 exit\n");
-		_iwl_mvm_exit_d0i3(mvm);
-	}
-
 	if (mvm->trans->d0i3_mode == IWL_D0I3_MODE_ON_SUSPEND)
 		if (!wait_event_timeout(mvm->d0i3_exit_waitq,
 					!test_bit(IWL_MVM_STATUS_IN_D0I3,
-- 
2.1.4

