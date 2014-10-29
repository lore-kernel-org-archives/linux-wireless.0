Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:38239 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbaJ2LvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:05 -0400
Received: by mail-wg0-f48.google.com with SMTP id m15so3120709wgh.7
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:04 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/25] iwlwifi: mvm: move the check if associated outside of the iterator for wowlan
Date: Wed, 29 Oct 2014 13:50:26 +0200
Message-Id: <1414583446-11032-5-git-send-email-egrumbach@gmail.com> (sfid-20141029_125117_069261_39BB70C5)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of checking if we are associated when suspending with wowlan
enabled in the interface iterator, allow it to return an unassociated
vif and move the check to the main suspend function.  This will be
needed by netdetect, since it should also work when we are not
associated but the vif is active.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 48 ++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index b8e8a97..7a66a09 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -611,14 +611,10 @@ static void iwl_mvm_d3_iface_iterator(void *_data, u8 *mac,
 				      struct ieee80211_vif *vif)
 {
 	struct iwl_d3_iter_data *data = _data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return;
 
-	if (mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT)
-		return;
-
 	if (data->vif) {
 		IWL_ERR(data->mvm, "More than one managed interface active!\n");
 		data->error = true;
@@ -1029,7 +1025,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	/* see if there's only a single BSS vif and it's associated */
+	/* see if there's only a single BSS vif */
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_d3_iface_iterator, &suspend_iter_data);
@@ -1042,27 +1038,33 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	vif = suspend_iter_data.vif;
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	ap_sta = rcu_dereference_protected(
-		mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
-		lockdep_is_held(&mvm->mutex));
-	if (IS_ERR_OR_NULL(ap_sta)) {
-		ret = -EINVAL;
-		goto out_noreset;
-	}
+	/* if we're associated, this is wowlan */
+	if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
+		ap_sta = rcu_dereference_protected(
+			mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
+			lockdep_is_held(&mvm->mutex));
+		if (IS_ERR_OR_NULL(ap_sta)) {
+			ret = -EINVAL;
+			goto out_noreset;
+		}
 
-	ret = iwl_mvm_get_wowlan_config(mvm, wowlan, &wowlan_config_cmd, vif,
-					mvmvif, ap_sta);
-	if (ret)
-		goto out_noreset;
+		ret = iwl_mvm_get_wowlan_config(mvm, wowlan, &wowlan_config_cmd,
+						vif, mvmvif, ap_sta);
+		if (ret)
+			goto out_noreset;
 
-	ret = iwl_mvm_switch_to_d3(mvm);
-	if (ret)
-		goto out;
+		ret = iwl_mvm_switch_to_d3(mvm);
+		if (ret)
+			goto out;
 
-	ret = iwl_mvm_wowlan_config(mvm, wowlan, &wowlan_config_cmd,
-				    vif, mvmvif, ap_sta);
-	if (ret)
-		goto out;
+		ret = iwl_mvm_wowlan_config(mvm, wowlan, &wowlan_config_cmd,
+					    vif, mvmvif, ap_sta);
+		if (ret)
+			goto out;
+	} else {
+		ret = 1;
+		goto out_noreset;
+	}
 
 	ret = iwl_mvm_power_update_device(mvm);
 	if (ret)
-- 
1.9.1

