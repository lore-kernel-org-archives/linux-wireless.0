Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:36231 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaGVT1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:54 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so116998wes.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:52 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/20] iwlwifi: mvm: teardown TDLS peers during chan-switch and AP DCM
Date: Tue, 22 Jul 2014 22:26:51 +0300
Message-Id: <1406057211-31752-20-git-send-email-egrumbach@gmail.com> (sfid-20140722_212802_707475_6206FD9B)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The DCM condition was not checked well for channel switch in both AP and
station scenarios. Teardown was also not done for AP/GO DCM. Add the
missing checks.

Reported-by: Peer, Ilan <ilan.peer@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 52 +++++++++++++++++------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 6639341..0d6a8b7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1406,6 +1406,28 @@ static inline int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
 }
 #endif
 
+static void iwl_mvm_teardown_tdls_peers(struct iwl_mvm *mvm)
+{
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
+	int i;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
+						lockdep_is_held(&mvm->mutex));
+		if (!sta || IS_ERR(sta) || !sta->tdls)
+			continue;
+
+		mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		ieee80211_tdls_oper_request(mvmsta->vif, sta->addr,
+				NL80211_TDLS_TEARDOWN,
+				WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED,
+				GFP_KERNEL);
+	}
+}
+
 static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 					     struct ieee80211_vif *vif,
 					     struct ieee80211_bss_conf *bss_conf,
@@ -1600,6 +1622,10 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 
 	iwl_mvm_bt_coex_vif_change(mvm);
 
+	/* we don't support TDLS during DCM */
+	if (iwl_mvm_phy_ctx_count(mvm) > 1)
+		iwl_mvm_teardown_tdls_peers(mvm);
+
 	mutex_unlock(&mvm->mutex);
 	return 0;
 
@@ -1947,28 +1973,6 @@ static void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm,
 		iwl_mvm_power_update_mac(mvm);
 }
 
-static void iwl_mvm_teardown_tdls_peers(struct iwl_mvm *mvm)
-{
-	struct ieee80211_sta *sta;
-	struct iwl_mvm_sta *mvmsta;
-	int i;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
-		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
-						lockdep_is_held(&mvm->mutex));
-		if (!sta || IS_ERR(sta) || !sta->tdls)
-			continue;
-
-		mvmsta = iwl_mvm_sta_from_mac80211(sta);
-		ieee80211_tdls_oper_request(mvmsta->vif, sta->addr,
-				NL80211_TDLS_TEARDOWN,
-				WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED,
-				GFP_KERNEL);
-	}
-}
-
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -2846,6 +2850,10 @@ static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
 		goto out_remove;
 	}
 
+	/* we don't support TDLS during DCM - can be caused by channel switch */
+	if (iwl_mvm_phy_ctx_count(mvm) > 1)
+		iwl_mvm_teardown_tdls_peers(mvm);
+
 	goto out;
 
 out_remove:
-- 
1.8.3.2

