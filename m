Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27220 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbbECTci (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:38 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/42] iwlwifi: mvm: combine scan size checks into a common function
Date: Sun,  3 May 2015 22:31:29 +0300
Message-Id: <1430681513-7838-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213418_416011_62A51AF2)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of repeating the same code in 4 different places, combine the
comparisons into a new function.  Additionally, this change fixes UMAC
scans where the RRM IEs were not taken into consideration when
calculating the IE length.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 44 +++++++++++++----------------
 3 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 249d020..8d9e5da 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -505,7 +505,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	iwl_mvm_reset_phy_ctxts(mvm);
 
-	hw->wiphy->max_scan_ie_len = iwl_mvm_max_scan_ie_len(mvm, false);
+	hw->wiphy->max_scan_ie_len = iwl_mvm_max_scan_ie_len(mvm);
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a8f51a8..7679ad6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1168,7 +1168,7 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   struct ieee80211_scan_ies *ies);
 int iwl_mvm_scan_size(struct iwl_mvm *mvm);
 int iwl_mvm_cancel_scan(struct iwl_mvm *mvm);
-int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan);
+int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm);
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm);
 
 /* Scheduled scan */
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index cbed9f3..95b9862 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -296,8 +296,7 @@ static inline bool iwl_mvm_rrm_scan_needed(struct iwl_mvm *mvm)
 	       IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT;
 }
 
-static int iwl_mvm_max_scan_ie_fw_cmd_room(struct iwl_mvm *mvm,
-					   bool is_sched_scan)
+static int iwl_mvm_max_scan_ie_fw_cmd_room(struct iwl_mvm *mvm)
 {
 	int max_probe_len;
 
@@ -313,9 +312,9 @@ static int iwl_mvm_max_scan_ie_fw_cmd_room(struct iwl_mvm *mvm,
 	return max_probe_len;
 }
 
-int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan)
+int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm)
 {
-	int max_ie_len = iwl_mvm_max_scan_ie_fw_cmd_room(mvm, is_sched_scan);
+	int max_ie_len = iwl_mvm_max_scan_ie_fw_cmd_room(mvm);
 
 	/* TODO: [BUG] This function should return the maximum allowed size of
 	 * scan IEs, however the LMAC scan api contains both 2GHZ and 5GHZ IEs
@@ -802,6 +801,18 @@ iwl_mvm_build_generic_scan_cmd(struct iwl_mvm *mvm,
 			cpu_to_le32(IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED);
 }
 
+static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
+				     struct ieee80211_scan_ies *ies,
+				     int n_channels)
+{
+	return ((n_ssids <= PROBE_OPTION_MAX) &&
+		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
+		(ies->common_ie_len +
+		 ies->len[NL80211_BAND_2GHZ] +
+		 ies->len[NL80211_BAND_5GHZ] <=
+		 iwl_mvm_max_scan_ie_fw_cmd_room(mvm)));
+}
+
 static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     struct cfg80211_scan_request *req,
 			     struct ieee80211_scan_ies *ies)
@@ -825,11 +836,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (WARN_ON(mvm->scan_cmd == NULL))
 		return -ENOMEM;
 
-	if (req->n_ssids > PROBE_OPTION_MAX ||
-	    ies->common_ie_len + ies->len[NL80211_BAND_2GHZ] +
-	    ies->len[NL80211_BAND_5GHZ] >
-		iwl_mvm_max_scan_ie_fw_cmd_room(mvm, false) ||
-	    req->n_channels > mvm->fw->ucode_capa.n_scan_channels)
+	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
 		return -ENOBUFS;
 
 	mvm->scan_status |= IWL_MVM_SCAN_REGULAR;
@@ -938,11 +945,7 @@ static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
 	if (WARN_ON(mvm->scan_cmd == NULL))
 		return -ENOMEM;
 
-	if (req->n_ssids > PROBE_OPTION_MAX ||
-	    ies->common_ie_len + ies->len[NL80211_BAND_2GHZ] +
-	    ies->len[NL80211_BAND_5GHZ] >
-		iwl_mvm_max_scan_ie_fw_cmd_room(mvm, true) ||
-	    req->n_channels > mvm->fw->ucode_capa.n_scan_channels)
+	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
 		return -ENOBUFS;
 
 	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, 0, &params);
@@ -1316,12 +1319,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (WARN_ON(mvm->scan_cmd == NULL))
 		return -ENOMEM;
 
-	if (WARN_ON(req->n_ssids > PROBE_OPTION_MAX ||
-		    ies->common_ie_len +
-		    ies->len[NL80211_BAND_2GHZ] +
-		    ies->len[NL80211_BAND_5GHZ] + 24 + 2 >
-		    SCAN_OFFLOAD_PROBE_REQ_SIZE || req->n_channels >
-		    mvm->fw->ucode_capa.n_scan_channels))
+	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
 		return -ENOBUFS;
 
 	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
@@ -1414,11 +1412,7 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 	if (WARN_ON(mvm->scan_cmd == NULL))
 		return -ENOMEM;
 
-	if (WARN_ON(req->n_ssids > PROBE_OPTION_MAX ||
-		    ies->common_ie_len + ies->len[NL80211_BAND_2GHZ] +
-		    ies->len[NL80211_BAND_5GHZ] + 24 + 2 >
-		    SCAN_OFFLOAD_PROBE_REQ_SIZE || req->n_channels >
-		    mvm->fw->ucode_capa.n_scan_channels))
+	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
 		return -ENOBUFS;
 
 	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
-- 
2.1.0

