Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbbECTc4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:56 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/42] iwlwifi: mvm: rename scan_calc_params to scan_calc_dwell
Date: Sun,  3 May 2015 22:31:38 +0300
Message-Id: <1430681513-7838-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213312_063661_52F43364)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

To make things clearer, rename the iwl_mvm_scan_calc_params() function
to iwl_mvm_calc_dwell() and make it calculate and fill in only
dwell-related parameters.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 36254c5..e8ec6e2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -194,10 +194,9 @@ static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
 		*global_cnt += 1;
 }
 
-static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
-				     struct ieee80211_vif *vif,
-				     int n_ssids, u32 flags,
-				     struct iwl_mvm_scan_params *params)
+static void iwl_mvm_scan_calc_dwell(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif,
+				    struct iwl_mvm_scan_params *params)
 {
 	int global_cnt = 0;
 	enum ieee80211_band band;
@@ -207,9 +206,6 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_scan_condition_iterator,
 					    &global_cnt);
-	params->n_ssids = n_ssids;
-	params->flags = flags;
-
 	if (!global_cnt)
 		goto not_bound;
 
@@ -250,7 +246,7 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 		}
 	}
 
-	if ((flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+	if ((params->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
 	    (params->max_out_time > 200))
 		params->max_out_time = 200;
 
@@ -262,8 +258,8 @@ not_bound:
 
 		params->dwell[band].passive = iwl_mvm_get_passive_dwell(mvm,
 									band);
-		params->dwell[band].active = iwl_mvm_get_active_dwell(mvm, band,
-								      n_ssids);
+		params->dwell[band].active =
+			iwl_mvm_get_active_dwell(mvm, band, params->n_ssids);
 	}
 
 	IWL_DEBUG_SCAN(mvm,
@@ -1452,8 +1448,8 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
 		return -ENOBUFS;
 
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags, &params);
-
+	params.n_ssids = req->n_ssids;
+	params.flags = req->flags;
 	params.n_channels = req->n_channels;
 	params.delay = 0;
 	params.interval = 0;
@@ -1466,6 +1462,8 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params.n_match_sets = 0;
 	params.match_sets = NULL;
 
+	iwl_mvm_scan_calc_dwell(mvm, vif, &params);
+
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hcmd.id = SCAN_REQ_UMAC;
 		ret = iwl_mvm_scan_umac(mvm, vif, ies, &params);
@@ -1527,8 +1525,8 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
 		return -ENOBUFS;
 
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags, &params);
-
+	params.n_ssids = req->n_ssids;
+	params.flags = req->flags;
 	params.n_channels = req->n_channels;
 	params.delay = req->delay;
 	params.ssids = req->ssids;
@@ -1548,6 +1546,8 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		params.interval = req->interval / MSEC_PER_SEC;
 	}
 
+	iwl_mvm_scan_calc_dwell(mvm, vif, &params);
+
 	ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 	if (ret)
 		return ret;
-- 
2.1.0

