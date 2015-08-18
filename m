Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbbHRH6l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/26] iwlwifi: mvm: don't disconnect on beacon loss in D0I3
Date: Tue, 18 Aug 2015 10:57:35 +0300
Message-Id: <1439884656-18146-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100109_986031_EF023E4D)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Currently if we wake up during D0I3 due to beacon loss we disconnect
immediately. This behaviour causes redundant disconnection, which could
be prevented by polling as it is usually done in mac80211.
Instead, we prefer reporting beacon loss and let mac80211 try polling
before disconnection.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 37 ++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index c15c994..02ce184 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1170,15 +1170,25 @@ static void iwl_mvm_exit_d0i3_iterator(void *_data, u8 *mac,
 	iwl_mvm_update_d0i3_power_mode(mvm, vif, false, flags);
 }
 
-static void iwl_mvm_d0i3_disconnect_iter(void *data, u8 *mac,
-					 struct ieee80211_vif *vif)
+struct iwl_mvm_wakeup_reason_iter_data {
+	struct iwl_mvm *mvm;
+	u32 wakeup_reasons;
+};
+
+static void iwl_mvm_d0i3_wakeup_reason_iter(void *_data, u8 *mac,
+					    struct ieee80211_vif *vif)
 {
-	struct iwl_mvm *mvm = data;
+	struct iwl_mvm_wakeup_reason_iter_data *data = _data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (vif->type == NL80211_IFTYPE_STATION && vif->bss_conf.assoc &&
-	    mvm->d0i3_ap_sta_id == mvmvif->ap_sta_id)
-		iwl_mvm_connection_loss(mvm, vif, "D0i3");
+	    data->mvm->d0i3_ap_sta_id == mvmvif->ap_sta_id) {
+		if (data->wakeup_reasons &
+		    IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH)
+			iwl_mvm_connection_loss(data->mvm, vif, "D0i3");
+		else
+			ieee80211_beacon_loss(vif);
+	}
 }
 
 void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq)
@@ -1246,7 +1256,7 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 	};
 	struct iwl_wowlan_status *status;
 	int ret;
-	u32 disconnection_reasons, wakeup_reasons;
+	u32 handled_reasons, wakeup_reasons;
 	__le16 *qos_seq = NULL;
 
 	mutex_lock(&mvm->mutex);
@@ -1263,13 +1273,18 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 
 	IWL_DEBUG_RPM(mvm, "wakeup reasons: 0x%x\n", wakeup_reasons);
 
-	disconnection_reasons =
-		IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_MISSED_BEACON |
-		IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH;
-	if (wakeup_reasons & disconnection_reasons)
+	handled_reasons = IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_MISSED_BEACON |
+				IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH;
+	if (wakeup_reasons & handled_reasons) {
+		struct iwl_mvm_wakeup_reason_iter_data data = {
+			.mvm = mvm,
+			.wakeup_reasons = wakeup_reasons,
+		};
+
 		ieee80211_iterate_active_interfaces(
 			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-			iwl_mvm_d0i3_disconnect_iter, mvm);
+			iwl_mvm_d0i3_wakeup_reason_iter, &data);
+	}
 out:
 	iwl_mvm_d0i3_enable_tx(mvm, qos_seq);
 
-- 
2.1.4

