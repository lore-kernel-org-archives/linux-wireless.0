Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35606 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaGVT1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:34 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so114506wgh.6
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:33 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/20] iwlwifi: mvm: BT Coex - don't change AP SMPS mode
Date: Tue, 22 Jul 2014 22:26:42 +0300
Message-Id: <1406057211-31752-11-git-send-email-egrumbach@gmail.com> (sfid-20140722_212740_216520_2888AE84)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Leave it to default instead - regardless of the BT activity.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 21 ++++++++-------------
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 17 +++++++----------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index a65b1bb..2291bbc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -768,13 +768,8 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 		break;
 	case NL80211_IFTYPE_AP:
-		/* default smps_mode for AP / GO is OFF */
-		smps_mode = IEEE80211_SMPS_OFF;
-		if (!mvmvif->ap_ibss_active) {
-			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
-					    smps_mode);
+		if (!mvmvif->ap_ibss_active)
 			return;
-		}
 		break;
 	default:
 		return;
@@ -785,10 +780,10 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	/* If channel context is invalid or not on 2.4GHz .. */
 	if ((!chanctx_conf ||
 	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ)) {
-		/* ... relax constraints and disable rssi events */
-		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
-				    smps_mode);
 		if (vif->type == NL80211_IFTYPE_STATION) {
+			/* ... relax constraints and disable rssi events */
+			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+					    smps_mode);
 			iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
 						    false);
 			iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
@@ -800,9 +795,7 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	if (bt_activity_grading >= BT_HIGH_TRAFFIC)
 		smps_mode = IEEE80211_SMPS_STATIC;
 	else if (bt_activity_grading >= BT_LOW_TRAFFIC)
-		smps_mode = vif->type == NL80211_IFTYPE_AP ?
-				IEEE80211_SMPS_OFF :
-				IEEE80211_SMPS_DYNAMIC;
+		smps_mode = IEEE80211_SMPS_DYNAMIC;
 
 	/* relax SMPS contraints for next association */
 	if (!vif->bss_conf.assoc)
@@ -816,7 +809,9 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		       "mac %d: bt_activity_grading %d smps_req %d\n",
 		       mvmvif->id, bt_activity_grading, smps_mode);
 
-	iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX, smps_mode);
+	if (vif->type == NL80211_IFTYPE_STATION)
+		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+				    smps_mode);
 
 	/* low latency is always primary */
 	if (iwl_mvm_vif_low_latency(mvmvif)) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index 9e3ba5a..a3be333 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -793,13 +793,8 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 		break;
 	case NL80211_IFTYPE_AP:
-		/* default smps_mode for AP / GO is OFF */
-		smps_mode = IEEE80211_SMPS_OFF;
-		if (!mvmvif->ap_ibss_active) {
-			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
-					    smps_mode);
+		if (!mvmvif->ap_ibss_active)
 			return;
-		}
 		break;
 	default:
 		return;
@@ -810,10 +805,10 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	/* If channel context is invalid or not on 2.4GHz .. */
 	if ((!chanctx_conf ||
 	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ)) {
-		/* ... relax constraints and disable rssi events */
-		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
-				    smps_mode);
 		if (vif->type == NL80211_IFTYPE_STATION) {
+			/* ... relax constraints and disable rssi events */
+			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+					    smps_mode);
 			iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
 						    false);
 			iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
@@ -838,7 +833,9 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		       mvmvif->id, data->notif->bt_status, bt_activity_grading,
 		       smps_mode);
 
-	iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX, smps_mode);
+	if (vif->type == NL80211_IFTYPE_STATION)
+		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+				    smps_mode);
 
 	/* low latency is always primary */
 	if (iwl_mvm_vif_low_latency(mvmvif)) {
-- 
1.8.3.2

