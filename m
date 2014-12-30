Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbaL3OUV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:21 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/33] iwlwifi: mvm: use iwl_mvm_vif_from_mac80211() consistently
Date: Tue, 30 Dec 2014 16:19:01 +0200
Message-Id: <1419949148-24046-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154348_374185_8E7ABEED)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a few places not using it, use it at those places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/sta.c         | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index a3bfda4..d2fd48c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -989,7 +989,7 @@ int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 				   struct ieee80211_vif *vif)
 {
-	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_bt_iterator_data *data = _data;
 	struct iwl_mvm *mvm = data->mvm;
 
@@ -1025,7 +1025,7 @@ static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   enum ieee80211_rssi_event rssi_event)
 {
-	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_bt_iterator_data data = {
 		.mvm = mvm,
 	};
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index b3210cf..973f288 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -1034,7 +1034,7 @@ int iwl_mvm_rx_bt_coex_notif_old(struct iwl_mvm *mvm,
 static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
-	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_bt_iterator_data *data = _data;
 	struct iwl_mvm *mvm = data->mvm;
 
@@ -1070,7 +1070,7 @@ static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 void iwl_mvm_bt_rssi_event_old(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			       enum ieee80211_rssi_event rssi_event)
 {
-	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_bt_iterator_data data = {
 		.mvm = mvm,
 	};
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index d86fe43..9eaa96e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1144,7 +1144,7 @@ static int iwl_mvm_set_fw_key_idx(struct iwl_mvm *mvm)
 static u8 iwl_mvm_get_key_sta_id(struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta)
 {
-	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (sta) {
 		struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
@@ -1280,7 +1280,7 @@ static inline u8 *iwl_mvm_get_mac_addr(struct iwl_mvm *mvm,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_sta *sta)
 {
-	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (sta)
 		return sta->addr;
-- 
1.9.1

