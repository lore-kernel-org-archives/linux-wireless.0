Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39991 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbbFBSdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 14:33:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: rename single hw-scan flag to follow naming convention
Date: Tue,  2 Jun 2015 20:33:02 +0200
Message-Id: <1433269982-29434-1-git-send-email-johannes@sipsolutions.net> (sfid-20150602_203308_516481_308DEDB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The naming convention is to always have the flags prefixed with
IEEE80211_HW_ so they're 'namespaced', make this flag follow it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 include/net/mac80211.h                      | 4 ++--
 net/mac80211/scan.c                         | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 84555170b6f7..6b45b96ac238 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -450,7 +450,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    !iwlwifi_mod_params.sw_crypto)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
-	hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
+	hw->flags |= IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS;
 	hw->wiphy->features |=
 		NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
 		NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 68a3cc9796d2..e09a32cb139f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1885,7 +1885,7 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SUPPORTS_CLONED_SKBS: The driver will never modify the payload
  *	or tailroom of TX skbs without copying them first.
  *
- * @IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS: The HW supports scanning on all bands
+ * @IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS: The HW supports scanning on all bands
  *	in one command, mac80211 doesn't have to run separate scans per band.
  */
 enum ieee80211_hw_flags {
@@ -1917,7 +1917,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
 	IEEE80211_HW_SUPPORTS_CLONED_SKBS		= 1<<29,
-	IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS		= 1<<30,
+	IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS		= 1<<30,
 };
 
 /**
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 7bb6a9383f58..3eb121d2aa45 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -257,7 +257,7 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
 		return false;
 
-	if (local->hw.flags & IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS) {
+	if (local->hw.flags & IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS) {
 		for (i = 0; i < req->n_channels; i++) {
 			local->hw_scan_req->req.channels[i] = req->channels[i];
 			bands_used |= BIT(req->channels[i]->band);
@@ -326,7 +326,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 		return;
 
 	if (hw_scan && !aborted &&
-	    !(local->hw.flags & IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS) &&
+	    !(local->hw.flags & IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS) &&
 	    ieee80211_prep_hw_scan(local)) {
 		int rc;
 
@@ -520,7 +520,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		local->hw_scan_ies_bufsize = local->scan_ies_len + req->ie_len;
 
-		if (local->hw.flags & IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS) {
+		if (local->hw.flags & IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS) {
 			int i, n_bands = 0;
 			u8 bands_counted = 0;
 
-- 
2.1.4

