Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab3BLQCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:46 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 12/15] iwlwifi: mvm: don't delay the association until after beacon
Date: Tue, 12 Feb 2013 17:02:04 +0100
Message-Id: <1360684927-1367-12-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170256_484205_B8E9B328)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we haven't heard a beacon before we associate we can
still start the association process and set the MAC in
the firmware to associated only after having received a
beacon with DTIM period by reacting to the new change
flag (BSS_CHANGED_DTIM_PERIOD) from mac80211.

This reduces the association time in these cases.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |  6 +++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 10 +++++++---
 drivers/net/wireless/iwlwifi/mvm/time-event.c |  4 +++-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index c08a17a..0854dc3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -584,7 +584,11 @@ static void iwl_mvm_mac_ctxt_cmd_fill_sta(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif,
 					  struct iwl_mac_data_sta *ctxt_sta)
 {
-	ctxt_sta->is_assoc = cpu_to_le32(vif->bss_conf.assoc ? 1 : 0);
+	/* We need the dtim_period to set the MAC as associated */
+	if (vif->bss_conf.assoc && vif->bss_conf.dtim_period)
+		ctxt_sta->is_assoc = cpu_to_le32(1);
+	else
+		ctxt_sta->is_assoc = cpu_to_le32(0);
 
 	ctxt_sta->bi = cpu_to_le32(vif->bss_conf.beacon_int);
 	ctxt_sta->bi_reciprocal =
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e0d79e3..6bfcb3b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -114,7 +114,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_QUEUE_CONTROL |
 		    IEEE80211_HW_WANT_MONITOR_VIF |
 		    IEEE80211_HW_SCAN_WHILE_IDLE |
-		    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
 		    IEEE80211_HW_SUPPORTS_PS |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
 		    IEEE80211_HW_AMPDU_AGGREGATION;
@@ -671,8 +670,6 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				IWL_ERR(mvm, "failed to update quotas\n");
 				return;
 			}
-			iwl_mvm_remove_time_event(mvm, mvmvif,
-						  &mvmvif->time_event_data);
 		} else if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
 			/* remove AP station now that the MAC is unassoc */
 			ret = iwl_mvm_rm_sta_id(mvm, vif, mvmvif->ap_sta_id);
@@ -684,6 +681,13 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			if (ret)
 				IWL_ERR(mvm, "failed to update quotas\n");
 		}
+	} else if (changes & BSS_CHANGED_DTIM_PERIOD) {
+		/*
+		 * We received a beacon _after_ association so
+		 * remove the session protection.
+		 */
+		iwl_mvm_remove_time_event(mvm, mvmvif,
+					  &mvmvif->time_event_data);
 	} else if (changes & BSS_CHANGED_PS) {
 		/*
 		 * TODO: remove this temporary code.
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 4d62a5d4..194bfb7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -184,9 +184,11 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 		 */
 		if (te_data->vif->type == NL80211_IFTYPE_STATION &&
 		    (!te_data->vif->bss_conf.assoc ||
-		     !te_data->vif->bss_conf.dtim_period))
+		     !te_data->vif->bss_conf.dtim_period)) {
 			IWL_ERR(mvm,
 				"No assocation and the time event is over already...\n");
+			ieee80211_connection_loss(te_data->vif);
+		}
 
 		iwl_mvm_te_clear_data(mvm, te_data);
 	} else if (le32_to_cpu(notif->action) == TE_NOTIF_HOST_START) {
-- 
1.8.0

