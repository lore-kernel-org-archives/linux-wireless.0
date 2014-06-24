Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:65093 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaFXTw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:58 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so6504265wib.0
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:57 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/27] iwlwifi: mvm: BT Coex - add reduced Tx power thresholds to constants
Date: Tue, 24 Jun 2014 22:52:15 +0300
Message-Id: <1403639541-4621-21-git-send-email-egrumbach@gmail.com> (sfid-20140624_215306_181936_E2513B66)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This really belongs to the constants file.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c      | 10 ++++------
 drivers/net/wireless/iwlwifi/mvm/constants.h |  2 ++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 8d7146e..cae44ed 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -100,8 +100,6 @@ static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 
 #undef EVENT_PRIO_ANT
 
-#define BT_ENABLE_REDUCED_TXPOWER_THRESHOLD	(-62)
-#define BT_DISABLE_REDUCED_TXPOWER_THRESHOLD	(-65)
 #define BT_ANTENNA_COUPLING_THRESHOLD		(30)
 
 static int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
@@ -807,9 +805,9 @@ void iwl_mvm_bt_coex_enable_rssi_event(struct iwl_mvm *mvm,
 
 	mvmvif->bf_data.last_bt_coex_event = rssi;
 	mvmvif->bf_data.bt_coex_max_thold =
-		enable ? BT_ENABLE_REDUCED_TXPOWER_THRESHOLD : 0;
+		enable ? -IWL_MVM_BT_COEX_EN_RED_TXP_THRESH : 0;
 	mvmvif->bf_data.bt_coex_min_thold =
-		enable ? BT_DISABLE_REDUCED_TXPOWER_THRESHOLD : 0;
+		enable ? -IWL_MVM_BT_COEX_DIS_RED_TXP_THRESH : 0;
 }
 
 /* must be called under rcu_read_lock */
@@ -946,7 +944,7 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	/* if the RSSI isn't valid, fake it is very low */
 	if (!ave_rssi)
 		ave_rssi = -100;
-	if (ave_rssi > BT_ENABLE_REDUCED_TXPOWER_THRESHOLD) {
+	if (ave_rssi > -IWL_MVM_BT_COEX_EN_RED_TXP_THRESH) {
 		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, true))
 			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
 
@@ -957,7 +955,7 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		 * the iteration, if one interface's rssi isn't good enough,
 		 * bt_kill_msk will be set to default values.
 		 */
-	} else if (ave_rssi < BT_DISABLE_REDUCED_TXPOWER_THRESHOLD) {
+	} else if (ave_rssi < -IWL_MVM_BT_COEX_DIS_RED_TXP_THRESH) {
 		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false))
 			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 5168569..ca79f71 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -79,6 +79,8 @@
 #define IWL_MVM_PS_SNOOZE_WINDOW		50
 #define IWL_MVM_WOWLAN_PS_SNOOZE_WINDOW		25
 #define IWL_MVM_LOWLAT_QUOTA_MIN_PERCENT	64
+#define IWL_MVM_BT_COEX_EN_RED_TXP_THRESH	62
+#define IWL_MVM_BT_COEX_DIS_RED_TXP_THRESH	65
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
 #define IWL_MVM_BT_COEX_CORUNNING		1
 #define IWL_MVM_BT_COEX_MPLUT			1
-- 
1.8.3.2

