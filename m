Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64236 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaGFJhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:22 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so13747721wib.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:21 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/40] iwlwifi: mvm: teardown TDLS peers when initiating DCM
Date: Sun,  6 Jul 2014 12:36:14 +0300
Message-Id: <1404639376-3792-38-git-send-email-egrumbach@gmail.com> (sfid-20140706_115953_170415_8E1CFC08)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The FW currently doesn't optimally support TDLS in DCM mode. Teardown
all TDLS peers when we have more than a single phy context.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8aa6fa4..2eb6ebe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1885,6 +1885,28 @@ static void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm,
 		iwl_mvm_power_update_mac(mvm);
 }
 
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
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -1954,6 +1976,11 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 					     true);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
+
+		/* we don't support TDLS during DCM */
+		if (iwl_mvm_phy_ctx_count(mvm) > 1)
+			iwl_mvm_teardown_tdls_peers(mvm);
+
 		/* enable beacon filtering */
 		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
 		ret = 0;
-- 
1.8.3.2

