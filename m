Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbbAVUeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:22 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/38] iwlwifi: mvm: move U-APSD decision to authentication
Date: Thu, 22 Jan 2015 22:33:14 +0200
Message-Id: <1421958809-3371-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214446_727934_2AC259AB)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to change the usage of U-APSD on the fly later,
move the enabling condition into a new function that is
called when authenticated.

This allows the module parameter to become writable, it
won't take effect immediately but at least on the next
association the new value will be used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c      |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 19 +++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 0d34726..e3af724 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1490,7 +1490,7 @@ module_param_named(d0i3_disable, iwlwifi_mod_params.d0i3_disable,
 MODULE_PARM_DESC(d0i3_disable, "disable d0i3 functionality (default: Y)");
 
 module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable,
-		   bool, S_IRUGO);
+		   bool, S_IRUGO | S_IWUSR);
 #ifdef CONFIG_IWLWIFI_UAPSD
 MODULE_PARM_DESC(uapsd_disable, "disable U-APSD functionality (default: N)");
 #else
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 076a781c..d13903e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1354,10 +1354,6 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		mvm->bf_allowed_vif = mvmvif;
 		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
 				     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
-		if (mvm->fw->ucode_capa.flags &
-					IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT &&
-		    !iwlwifi_mod_params.uapsd_disable)
-			vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
 	}
 
 	/*
@@ -2305,6 +2301,20 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
+static void iwl_mvm_check_uapsd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+				const u8 *bssid)
+{
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT))
+		return;
+
+	if (iwlwifi_mod_params.uapsd_disable) {
+		vif->driver_flags &= ~IEEE80211_VIF_SUPPORTS_UAPSD;
+		return;
+	}
+
+	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
+}
+
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -2364,6 +2374,7 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		 * Reset EBS status here assuming environment has been changed.
 		 */
 		mvm->last_ebs_successful = true;
+		iwl_mvm_check_uapsd(mvm, vif, sta->addr);
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC) {
-- 
1.9.1

