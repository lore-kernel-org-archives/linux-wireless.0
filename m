Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaL3OTy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/33] iwlwifi: mvm: allow both d0i3 and d3 wowlan configuration modes
Date: Tue, 30 Dec 2014 16:18:51 +0200
Message-Id: <1419949148-24046-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151959_889445_C447E22F)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

d3 and d0i3 shouldn't be mutually exclusive. Set supported
wowlan triggers by looking for each of them, and check
on suspend/resume which flow should be used ("any" trigger
is supported by d0i3, and all the others by d3)

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       |  7 +++++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 14 ++++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 744de26..a64894c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1142,7 +1142,8 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
 	iwl_trans_suspend(mvm->trans);
-	if (iwl_mvm_is_d0i3_supported(mvm)) {
+	if (wowlan->any) {
+		/* 'any' trigger means d0i3 usage */
 		mutex_lock(&mvm->d0i3_suspend_mutex);
 		__set_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
 		mutex_unlock(&mvm->d0i3_suspend_mutex);
@@ -1876,8 +1877,10 @@ int iwl_mvm_resume(struct ieee80211_hw *hw)
 
 	iwl_trans_resume(mvm->trans);
 
-	if (iwl_mvm_is_d0i3_supported(mvm))
+	if (mvm->hw->wiphy->wowlan_config->any) {
+		/* 'any' trigger means d0i3 usage */
 		return 0;
+	}
 
 	return __iwl_mvm_resume(mvm, false);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b2f4ea5..fd0f8ce 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -462,15 +462,17 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    device_can_wakeup(mvm->trans->dev)) {
 		mvm->wowlan.flags = WIPHY_WOWLAN_ANY;
 		hw->wiphy->wowlan = &mvm->wowlan;
-	} else if (mvm->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
+	}
+
+	if (mvm->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
 	    mvm->trans->ops->d3_suspend &&
 	    mvm->trans->ops->d3_resume &&
 	    device_can_wakeup(mvm->trans->dev)) {
-		mvm->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
-				    WIPHY_WOWLAN_DISCONNECT |
-				    WIPHY_WOWLAN_EAP_IDENTITY_REQ |
-				    WIPHY_WOWLAN_RFKILL_RELEASE |
-				    WIPHY_WOWLAN_NET_DETECT;
+		mvm->wowlan.flags |= WIPHY_WOWLAN_MAGIC_PKT |
+				     WIPHY_WOWLAN_DISCONNECT |
+				     WIPHY_WOWLAN_EAP_IDENTITY_REQ |
+				     WIPHY_WOWLAN_RFKILL_RELEASE |
+				     WIPHY_WOWLAN_NET_DETECT;
 		if (!iwlwifi_mod_params.sw_crypto)
 			mvm->wowlan.flags |= WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
 					     WIPHY_WOWLAN_GTK_REKEY_FAILURE |
-- 
1.9.1

