Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:59736 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbbECTcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:04 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/42] iwlwifi: mvm: add scan parameters debugging info
Date: Sun,  3 May 2015 22:31:15 +0300
Message-Id: <1430681513-7838-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213209_975372_80CB790E)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add scan parameters information to make it easier to debug scan dwell
times and fragmentation.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 1075a21..9f72505 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -271,6 +271,21 @@ not_bound:
 		params->dwell[band].active = iwl_mvm_get_active_dwell(mvm, band,
 								      n_ssids);
 	}
+
+	IWL_DEBUG_SCAN(mvm,
+		       "scan parameters: max_out_time %d, suspend_time %d, passive_fragmented %d\n",
+		       params->max_out_time, params->suspend_time,
+		       params->passive_fragmented);
+	IWL_DEBUG_SCAN(mvm,
+		       "dwell[IEEE80211_BAND_2GHZ]: passive %d, active %d, fragmented %d\n",
+		       params->dwell[IEEE80211_BAND_2GHZ].passive,
+		       params->dwell[IEEE80211_BAND_2GHZ].active,
+		       params->dwell[IEEE80211_BAND_2GHZ].fragmented);
+	IWL_DEBUG_SCAN(mvm,
+		       "dwell[IEEE80211_BAND_5GHZ]: passive %d, active %d, fragmented %d\n",
+		       params->dwell[IEEE80211_BAND_5GHZ].passive,
+		       params->dwell[IEEE80211_BAND_5GHZ].active,
+		       params->dwell[IEEE80211_BAND_5GHZ].fragmented);
 }
 
 static inline bool iwl_mvm_rrm_scan_needed(struct iwl_mvm *mvm)
-- 
2.1.0

