Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbbCATcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/31] iwlwifi: mvm: don't override passive dwell in case of fragmented scan
Date: Sun,  1 Mar 2015 21:31:44 +0200
Message-Id: <1425238304-498-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203417_378466_F8EB24E5)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Currently scan params structure has only active or passive dwell time
fields, passive one is used for fragmented scans too. FW needs the
passive dwell time even when performing fragmented scan for calculating
time between channels. Add a separate parameter for fragmented dwell time
and pass both fragmented and passive to FW.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index c8377e1..f0946b5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -82,6 +82,7 @@ struct iwl_mvm_scan_params {
 	struct _dwell {
 		u16 passive;
 		u16 active;
+		u16 fragmented;
 	} dwell[IEEE80211_NUM_BANDS];
 };
 
@@ -263,10 +264,10 @@ not_bound:
 
 	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
 		if (params->passive_fragmented)
-			params->dwell[band].passive = frag_passive_dwell;
-		else
-			params->dwell[band].passive =
-				iwl_mvm_get_passive_dwell(mvm, band);
+			params->dwell[band].fragmented = frag_passive_dwell;
+
+		params->dwell[band].passive = iwl_mvm_get_passive_dwell(mvm,
+									band);
 		params->dwell[band].active = iwl_mvm_get_active_dwell(mvm, band,
 								      n_ssids);
 	}
@@ -768,7 +769,7 @@ iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
 	cmd->passive_dwell = params->dwell[IEEE80211_BAND_2GHZ].passive;
 	if (params->passive_fragmented)
 		cmd->fragmented_dwell =
-				params->dwell[IEEE80211_BAND_2GHZ].passive;
+				params->dwell[IEEE80211_BAND_2GHZ].fragmented;
 	cmd->rx_chain_select = iwl_mvm_scan_rx_chain(mvm);
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
@@ -1214,7 +1215,7 @@ iwl_mvm_build_generic_umac_scan_cmd(struct iwl_mvm *mvm,
 	cmd->passive_dwell = params->dwell[IEEE80211_BAND_2GHZ].passive;
 	if (params->passive_fragmented)
 		cmd->fragmented_dwell =
-				params->dwell[IEEE80211_BAND_2GHZ].passive;
+				params->dwell[IEEE80211_BAND_2GHZ].fragmented;
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
 	cmd->scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
-- 
1.9.1

