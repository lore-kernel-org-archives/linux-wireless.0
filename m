Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaL3OUf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/33] iwlwifi: mvm: Alter passive scan fragmentation parameters in case of multi-MAC
Date: Tue, 30 Dec 2014 16:19:07 +0200
Message-Id: <1419949148-24046-32-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154349_629683_B9971FBB)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Make passive scan fragmentation depends on the number of active
interfaces. In case of single-MAC, make passive scan less fragmented.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index ed229a8..348b9c4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -284,11 +284,11 @@ static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
 					    struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	bool *global_bound = data;
+	int *global_cnt = data;
 
 	if (vif->type != NL80211_IFTYPE_P2P_DEVICE && mvmvif->phy_ctxt &&
 	    mvmvif->phy_ctxt->id < MAX_PHYS)
-		*global_bound = true;
+		*global_cnt += 1;
 }
 
 static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
@@ -296,16 +296,16 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 				     int n_ssids, u32 flags,
 				     struct iwl_mvm_scan_params *params)
 {
-	bool global_bound = false;
+	int global_cnt = 0;
 	enum ieee80211_band band;
 	u8 frag_passive_dwell = 0;
 
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_scan_condition_iterator,
-					    &global_bound);
+					    &global_cnt);
 
-	if (!global_bound)
+	if (!global_cnt)
 		goto not_bound;
 
 	params->suspend_time = 30;
@@ -316,7 +316,11 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 		    IWL_UCODE_TLV_API_FRAGMENTED_SCAN) {
 			params->suspend_time = 105;
 			params->max_out_time = 70;
-			frag_passive_dwell = 20;
+			/*
+			 * If there is more than one active interface make
+			 * passive scan more fragmented.
+			 */
+			frag_passive_dwell = (global_cnt < 2) ? 40 : 20;
 		} else {
 			params->suspend_time = 120;
 			params->max_out_time = 120;
-- 
1.9.1

