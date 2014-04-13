Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42409 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbaDMTUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:51 -0400
Received: by mail-wi0-f179.google.com with SMTP id z2so3129274wiv.12
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:50 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/47] iwlwifi: mvm: Change scan fragmentation condition
Date: Sun, 13 Apr 2014 22:19:42 +0300
Message-Id: <1397416802-32403-27-git-send-email-egrumbach@gmail.com> (sfid-20140413_213515_163986_15A71DEC)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Do not allow passive scan fragmentation in case of P2P discovery
scan. This is to avoid negative impact on P2P discoverability.
Do some re-factoring to make existing code more clear.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 54 ++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 9e760d0..5481e09 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -272,11 +272,16 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 {
 	bool global_bound = false;
 	enum ieee80211_band band;
+	u8 frag_passive_dwell = 0;
 
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_scan_condition_iterator,
 					    &global_bound);
+
+	if (!global_bound)
+		goto not_bound;
+
 	/*
 	 * Under low latency traffic passive scan is fragmented meaning
 	 * that dwell on a particular channel will be fragmented. Each fragment
@@ -288,37 +293,38 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 	 * 70ms, so for active scanning operating channel will be left for 70ms
 	 * while for passive still for 20ms (fragment dwell).
 	 */
-	if (global_bound) {
-		if (!iwl_mvm_low_latency(mvm)) {
-			params->suspend_time = ieee80211_tu_to_usec(100);
-			params->max_out_time = ieee80211_tu_to_usec(600);
-		} else {
-			params->suspend_time = ieee80211_tu_to_usec(105);
-			/* P2P doesn't support fragmented passive scan, so
-			 * configure max_out_time to be at least longest dwell
-			 * time for passive scan.
-			 */
-			if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p) {
-				params->max_out_time = ieee80211_tu_to_usec(70);
-				params->passive_fragmented = true;
-			} else {
-				u32 passive_dwell;
 
-				/*
-				 * Use band G so that passive channel dwell time
-				 * will be assigned with maximum value.
-				 */
-				band = IEEE80211_BAND_2GHZ;
-				passive_dwell = iwl_mvm_get_passive_dwell(band);
-				params->max_out_time =
+	if (iwl_mvm_low_latency(mvm)) {
+		params->suspend_time = ieee80211_tu_to_usec(105);
+		params->max_out_time = ieee80211_tu_to_usec(70);
+		frag_passive_dwell = 20;
+	} else {
+		params->suspend_time = ieee80211_tu_to_usec(100);
+		params->max_out_time = ieee80211_tu_to_usec(600);
+	}
+
+	if (frag_passive_dwell) {
+		/*
+		* P2P device scan should not be fragmented to avoid negative
+		* impact on P2P device discovery. Configure max_out_time to be
+		* equal to dwell time on passive channel. Take a longest
+		* possible value, one that corresponds to 2GHz band
+		*/
+		if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
+			u32 passive_dwell =
+				iwl_mvm_get_passive_dwell(IEEE80211_BAND_2GHZ);
+			params->max_out_time =
 					ieee80211_tu_to_usec(passive_dwell);
-			}
+		} else {
+			params->passive_fragmented = true;
 		}
 	}
 
+not_bound:
+
 	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
 		if (params->passive_fragmented)
-			params->dwell[band].passive = 20;
+			params->dwell[band].passive = frag_passive_dwell;
 		else
 			params->dwell[band].passive =
 				iwl_mvm_get_passive_dwell(band);
-- 
1.8.3.2

