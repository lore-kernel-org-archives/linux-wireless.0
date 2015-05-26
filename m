Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbbEZTSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/39] iwlwifi: mvm: fix the net-detect SSIDs report order
Date: Tue, 26 May 2015 22:17:33 +0300
Message-Id: <1432667872-18092-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213348_097057_3520A7D0)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

After the scan refactor, the order of the SSIDs passed to the firmware
in all scans (including net-detect) are inverted.  This was causing
the reporting code to use the wrong SSIDs.  To fix this, invert the
array index when accessing the saved match SSIDs to report the
wake-up.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index d30f168..408b0ce 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1785,7 +1785,7 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 	for_each_set_bit(i, &matched_profiles, mvm->n_nd_match_sets) {
 		struct iwl_scan_offload_profile_match *fw_match;
 		struct cfg80211_wowlan_nd_match *match;
-		int n_channels = 0;
+		int idx, n_channels = 0;
 
 		fw_match = &query.matches[i];
 
@@ -1800,8 +1800,12 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 
 		net_detect->matches[net_detect->n_matches++] = match;
 
-		match->ssid.ssid_len = mvm->nd_match_sets[i].ssid.ssid_len;
-		memcpy(match->ssid.ssid, mvm->nd_match_sets[i].ssid.ssid,
+		/* We inverted the order of the SSIDs in the scan
+		 * request, so invert the index here.
+		 */
+		idx = mvm->n_nd_match_sets - i - 1;
+		match->ssid.ssid_len = mvm->nd_match_sets[idx].ssid.ssid_len;
+		memcpy(match->ssid.ssid, mvm->nd_match_sets[idx].ssid.ssid,
 		       match->ssid.ssid_len);
 
 		if (mvm->n_nd_channels < n_channels)
-- 
2.1.4

