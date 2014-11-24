Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33438 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaKXOfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:30 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so12518645wgh.34
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:29 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/75] iwlwifi: mvm: move deferred d0i3 exit to resume_complete op
Date: Mon, 24 Nov 2014 16:33:56 +0200
Message-Id: <1416839691-28533-20-git-send-email-egrumbach@gmail.com> (sfid-20141124_154347_035282_A82AE1BF)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The deferred d0i3 exit is currently implemented in the
resume op, which is called when mac80211 starts its
resume process.

However, mac80211 still doesn't handle frames at this stage,
which results in frames being dropped.

Move the deferred d0i3 handling to the reconfig_complete
callback, in order to make sure mac80211 is fully available
at this point.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       | 12 +-----------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index b61075b..faa7d5c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1659,18 +1659,8 @@ int iwl_mvm_resume(struct ieee80211_hw *hw)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
-	if (iwl_mvm_is_d0i3_supported(mvm)) {
-		bool exit_now;
-
-		mutex_lock(&mvm->d0i3_suspend_mutex);
-		__clear_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
-		exit_now = __test_and_clear_bit(D0I3_PENDING_WAKEUP,
-						&mvm->d0i3_suspend_flags);
-		mutex_unlock(&mvm->d0i3_suspend_mutex);
-		if (exit_now)
-			_iwl_mvm_exit_d0i3(mvm);
+	if (iwl_mvm_is_d0i3_supported(mvm))
 		return 0;
-	}
 
 	return __iwl_mvm_resume(mvm, false);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 19aff50..e3259b6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -941,6 +941,25 @@ static void iwl_mvm_restart_complete(struct iwl_mvm *mvm)
 	mutex_unlock(&mvm->mutex);
 }
 
+static void iwl_mvm_resume_complete(struct iwl_mvm *mvm)
+{
+	bool exit_now;
+
+	if (!iwl_mvm_is_d0i3_supported(mvm))
+		return;
+
+	mutex_lock(&mvm->d0i3_suspend_mutex);
+	__clear_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
+	exit_now = __test_and_clear_bit(D0I3_PENDING_WAKEUP,
+					&mvm->d0i3_suspend_flags);
+	mutex_unlock(&mvm->d0i3_suspend_mutex);
+
+	if (exit_now) {
+		IWL_DEBUG_RPM(mvm, "Run deferred d0i3 exit\n");
+		_iwl_mvm_exit_d0i3(mvm);
+	}
+}
+
 static void
 iwl_mvm_mac_reconfig_complete(struct ieee80211_hw *hw,
 			      enum ieee80211_reconfig_type reconfig_type)
@@ -952,6 +971,7 @@ iwl_mvm_mac_reconfig_complete(struct ieee80211_hw *hw,
 		iwl_mvm_restart_complete(mvm);
 		break;
 	case IEEE80211_RECONFIG_TYPE_SUSPEND:
+		iwl_mvm_resume_complete(mvm);
 		break;
 	}
 }
-- 
1.9.1

