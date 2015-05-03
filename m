Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbbECTcv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:51 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/42] iwlwifi: mvm: revert order of SSIDs for sched scans
Date: Sun,  3 May 2015 22:31:36 +0300
Message-Id: <1430681513-7838-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213309_353952_69CB7F76)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The firmware inverts the order of the SSIDs sent out in probe requests
(for some reason).  For regular scans, we've been passing the SSIDs in
the opposite order so they go out in the order we want.  With
scheduled scans, we were not doing that, so they were sent out in
reverse order of priority.  Fix that by using the reverse order when
populating the SSIDs array for scheduled scans as well.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 551f66d..785e99c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -446,7 +446,7 @@ static int iwl_ssid_exist(u8 *ssid, u8 ssid_len, struct iwl_ssid_ie *ssid_list)
 }
 
 static void iwl_scan_offload_build_ssid(struct iwl_mvm_scan_params *params,
-					struct iwl_ssid_ie *direct_scan,
+					struct iwl_ssid_ie *ssid,
 					u32 *ssid_bitmap)
 {
 	int i, j;
@@ -457,31 +457,34 @@ static void iwl_scan_offload_build_ssid(struct iwl_mvm_scan_params *params,
 	 * iwl_config_sched_scan_profiles() uses the order of these ssids to
 	 * config match list.
 	 */
-	for (i = 0; i < params->n_match_sets && i < PROBE_OPTION_MAX; i++) {
+	for (i = 0, j = params->n_match_sets - 1;
+	     j >= 0 && i < PROBE_OPTION_MAX;
+	     i++, j--) {
 		/* skip empty SSID matchsets */
-		if (!params->match_sets[i].ssid.ssid_len)
+		if (!params->match_sets[j].ssid.ssid_len)
 			continue;
-		direct_scan[i].id = WLAN_EID_SSID;
-		direct_scan[i].len = params->match_sets[i].ssid.ssid_len;
-		memcpy(direct_scan[i].ssid, params->match_sets[i].ssid.ssid,
-		       direct_scan[i].len);
+		ssid[i].id = WLAN_EID_SSID;
+		ssid[i].len = params->match_sets[j].ssid.ssid_len;
+		memcpy(ssid[i].ssid, params->match_sets[j].ssid.ssid,
+		       ssid[i].len);
 	}
 
 	/* add SSIDs from scan SSID list */
 	*ssid_bitmap = 0;
-	for (j = 0; j < params->n_ssids && i < PROBE_OPTION_MAX; j++) {
+	for (j = params->n_ssids - 1;
+	     j >= 0 && i < PROBE_OPTION_MAX;
+	     i++, j--) {
 		index = iwl_ssid_exist(params->ssids[j].ssid,
 				       params->ssids[j].ssid_len,
-				       direct_scan);
+				       ssid);
 		if (index < 0) {
 			if (!params->ssids[j].ssid_len)
 				continue;
-			direct_scan[i].id = WLAN_EID_SSID;
-			direct_scan[i].len = params->ssids[j].ssid_len;
-			memcpy(direct_scan[i].ssid, params->ssids[j].ssid,
-			       direct_scan[i].len);
+			ssid[i].id = WLAN_EID_SSID;
+			ssid[i].len = params->ssids[j].ssid_len;
+			memcpy(ssid[i].ssid, params->ssids[j].ssid,
+			       ssid[i].len);
 			*ssid_bitmap |= BIT(i + 1);
-			i++;
 		} else {
 			*ssid_bitmap |= BIT(index + 1);
 		}
-- 
2.1.0

