Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48833 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbbKOTeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2015 14:34:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/4] iwlwifi: mvm: Avoid dereferencing sta if it was already flushed
Date: Sun, 15 Nov 2015 21:34:05 +0200
Message-Id: <1447616045-31484-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151115_203421_010102_D03F4084)
In-Reply-To: <1447616045-31484-1-git-send-email-emmanuel.grumbach@intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8EAF98@hasmsx107.ger.corp.intel.com>
 <1447616045-31484-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Be a little bit more careful when dereferencing sta on key removal,
As it might already get flushed on other thread.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 44 ++++++++++++++++------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 4e26008..354acbd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1201,7 +1201,8 @@ static int iwl_mvm_set_fw_key_idx(struct iwl_mvm *mvm)
 	return max_offs;
 }
 
-static u8 iwl_mvm_get_key_sta_id(struct ieee80211_vif *vif,
+static u8 iwl_mvm_get_key_sta_id(struct iwl_mvm *mvm,
+				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
@@ -1218,8 +1219,21 @@ static u8 iwl_mvm_get_key_sta_id(struct ieee80211_vif *vif,
 	 * station ID, then use AP's station ID.
 	 */
 	if (vif->type == NL80211_IFTYPE_STATION &&
-	    mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT)
-		return mvmvif->ap_sta_id;
+	    mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
+		u8 sta_id = mvmvif->ap_sta_id;
+
+		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
+						lockdep_is_held(&mvm->mutex));
+		/*
+		 * It is possible that the 'sta' parameter is NULL,
+		 * for example when a GTK is removed - the sta_id will then
+		 * be the AP ID, and no station was passed by mac80211.
+		 */
+		if (IS_ERR_OR_NULL(sta))
+			return IWL_MVM_STATION_COUNT;
+
+		return sta_id;
+	}
 
 	return IWL_MVM_STATION_COUNT;
 }
@@ -1445,7 +1459,7 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Get the station id from the mvm local station table */
-	sta_id = iwl_mvm_get_key_sta_id(vif, sta);
+	sta_id = iwl_mvm_get_key_sta_id(mvm, vif, sta);
 	if (sta_id == IWL_MVM_STATION_COUNT) {
 		IWL_ERR(mvm, "Failed to find station id\n");
 		return -EINVAL;
@@ -1531,7 +1545,7 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Get the station id from the mvm local station table */
-	sta_id = iwl_mvm_get_key_sta_id(vif, sta);
+	sta_id = iwl_mvm_get_key_sta_id(mvm, vif, sta);
 
 	IWL_DEBUG_WEP(mvm, "mvm remove dynamic key: idx=%d sta=%d\n",
 		      keyconf->keyidx, sta_id);
@@ -1557,24 +1571,6 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 		return 0;
 	}
 
-	/*
-	 * It is possible that the 'sta' parameter is NULL, and thus
-	 * there is a need to retrieve the sta from the local station table,
-	 * for example when a GTK is removed (where the sta_id will then be
-	 * the AP ID, and no station was passed by mac80211.)
-	 */
-	if (!sta) {
-		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
-						lockdep_is_held(&mvm->mutex));
-		if (!sta) {
-			IWL_ERR(mvm, "Invalid station id\n");
-			return -EINVAL;
-		}
-	}
-
-	if (WARN_ON_ONCE(iwl_mvm_sta_from_mac80211(sta)->vif != vif))
-		return -EINVAL;
-
 	ret = __iwl_mvm_remove_sta_key(mvm, sta_id, keyconf, mcast);
 	if (ret)
 		return ret;
@@ -1594,7 +1590,7 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 			     u16 *phase1key)
 {
 	struct iwl_mvm_sta *mvm_sta;
-	u8 sta_id = iwl_mvm_get_key_sta_id(vif, sta);
+	u8 sta_id = iwl_mvm_get_key_sta_id(mvm, vif, sta);
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
 
 	if (WARN_ON_ONCE(sta_id == IWL_MVM_STATION_COUNT))
-- 
2.5.0

