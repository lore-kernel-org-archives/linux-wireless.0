Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab3GZI2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/30] iwlwifi: mvm: better handle several several vifs in BT Coex
Date: Fri, 26 Jul 2013 10:28:25 +0200
Message-Id: <1374827327-3464-9-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102912_346611_35F0697E)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When there one vif on 5GHz associating, it would clear all
the BT Coex constraints. This can't work if there is
another vif on 2.4GHz. Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c  | 22 ++++------------------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index dbd622a..9195779 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -384,6 +384,10 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 
 	smps_mode = IEEE80211_SMPS_AUTOMATIC;
 
+	/* non associated BSSes aren't to be considered */
+	if (!vif->bss_conf.assoc)
+		return;
+
 	if (band != IEEE80211_BAND_2GHZ) {
 		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
 				    smps_mode);
@@ -588,23 +592,5 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 void iwl_mvm_bt_coex_vif_assoc(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	enum ieee80211_band band;
-
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(vif->chanctx_conf);
-	if (chanctx_conf && chanctx_conf->def.chan)
-		band = chanctx_conf->def.chan->band;
-	else
-		band = -1;
-	rcu_read_unlock();
-
-	/* if we are in 2GHz we will get a notification from the fw */
-	if (band == IEEE80211_BAND_2GHZ)
-		return;
-
-	/* else, we can remove all the constraints */
-	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
-
 	iwl_mvm_bt_coex_notif_handle(mvm);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2d07605..30319e0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -761,7 +761,6 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				IWL_ERR(mvm, "failed to update quotas\n");
 				return;
 			}
-			iwl_mvm_bt_coex_vif_assoc(mvm, vif);
 			iwl_mvm_configure_mcast_filter(mvm, vif);
 		} else if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
 			/* remove AP station now that the MAC is unassoc */
@@ -782,6 +781,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			if (ret)
 				IWL_ERR(mvm, "failed to update power mode\n");
 		}
+		iwl_mvm_bt_coex_vif_assoc(mvm, vif);
 	} else if (changes & BSS_CHANGED_BEACON_INFO) {
 		/*
 		 * We received a beacon _after_ association so
-- 
1.8.0

