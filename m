Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37138 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752416AbeC1TxC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 15:53:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        "Zamir, Roee" <roee.zamir@intel.com>,
        Beni Lev <beni.lev@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Mar 2018 22:52:53 +0300
Message-Id: <20180328195253.24380-1-luca@coelho.fi> (sfid-20180328_215306_695436_58830B0F)
In-Reply-To: <20180328142517.8940-1-luca@coelho.fi>
References: <20180328142517.8940-1-luca@coelho.fi>
Subject: [PATCH v2 06/14] iwlwifi: mvm: add adaptive dwell support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Zamir, Roee" <roee.zamir@intel.com>

Update the scan command API with support for adaptive dwell.  Adaptive
dwell is a type of scan that dynamically changes the time it remains
on each channel listening for beacons or probe responses.

Signed-off-by: Roee Zamir <roee.zamir@intel.com>
Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 98 ++++++++++++++--------
 2 files changed, 67 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index 976640fed334..96b52a275ee3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -110,6 +110,8 @@
 #define IWL_MVM_SW_TX_CSUM_OFFLOAD		0
 #define IWL_MVM_HW_CSUM_DISABLE			0
 #define IWL_MVM_PARSE_NVM			0
+#define IWL_MVM_ADWELL_ENABLE			1
+#define IWL_MVM_ADWELL_MAX_BUDGET		0
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE_TW   1
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 356b16f40e78..f910098e9531 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -86,6 +86,15 @@ enum iwl_mvm_traffic_load {
 #define IWL_SCAN_DWELL_FRAGMENTED	44
 #define IWL_SCAN_DWELL_EXTENDED		90
 
+/* adaptive dwell max budget time [TU] for full scan */
+#define IWL_SCAN_ADWELL_MAX_BUDGET_FULL_SCAN 300
+/* adaptive dwell max budget time [TU] for directed scan */
+#define IWL_SCAN_ADWELL_MAX_BUDGET_DIRECTED_SCAN 100
+/* adaptive dwell default APs number */
+#define IWL_SCAN_ADWELL_DEFAULT_N_APS 2
+/* adaptive dwell default APs number in social channels (1, 6, 11) */
+#define IWL_SCAN_ADWELL_DEFAULT_N_APS_SOCIAL 10
+
 struct iwl_mvm_scan_timing_params {
 	u32 suspend_time;
 	u32 max_out_time;
@@ -1115,11 +1124,6 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_scan_timing_params *timing = &scan_timing[params->type];
 
-	if (iwl_mvm_is_regular_scan(params))
-		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
-	else
-		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_2);
-
 	if (iwl_mvm_is_adaptive_dwell_supported(mvm)) {
 		if (params->measurement_dwell) {
 			cmd->v7.active_dwell = params->measurement_dwell;
@@ -1129,6 +1133,21 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 			cmd->v7.passive_dwell = IWL_SCAN_DWELL_PASSIVE;
 		}
 		cmd->v7.fragmented_dwell = IWL_SCAN_DWELL_FRAGMENTED;
+		cmd->v7.adwell_default_n_aps_social =
+			IWL_SCAN_ADWELL_DEFAULT_N_APS_SOCIAL;
+		cmd->v7.adwell_default_n_aps =
+			IWL_SCAN_ADWELL_DEFAULT_N_APS;
+
+		/* if custom max budget was configured with debugfs */
+		if (IWL_MVM_ADWELL_MAX_BUDGET)
+			cmd->v7.adwell_max_budget =
+				cpu_to_le16(IWL_MVM_ADWELL_MAX_BUDGET);
+		else if (params->ssids && params->ssids[0].ssid_len)
+			cmd->v7.adwell_max_budget =
+				cpu_to_le16(IWL_SCAN_ADWELL_MAX_BUDGET_DIRECTED_SCAN);
+		else
+			cmd->v7.adwell_max_budget =
+				cpu_to_le16(IWL_SCAN_ADWELL_MAX_BUDGET_FULL_SCAN);
 
 		cmd->v7.scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
 		cmd->v7.max_out_time[SCAN_LB_LMAC_IDX] =
@@ -1136,43 +1155,47 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 		cmd->v7.suspend_time[SCAN_LB_LMAC_IDX] =
 			cpu_to_le32(timing->suspend_time);
 		if (iwl_mvm_is_cdb_supported(mvm)) {
-			cmd->v7.max_out_time[SCAN_HB_LMAC_IDX] =
+			cmd->v6.max_out_time[SCAN_HB_LMAC_IDX] =
 				cpu_to_le32(timing->max_out_time);
-			cmd->v7.suspend_time[SCAN_HB_LMAC_IDX] =
+			cmd->v6.suspend_time[SCAN_HB_LMAC_IDX] =
 				cpu_to_le32(timing->suspend_time);
 		}
-
-		return;
-	}
-
-	if (params->measurement_dwell) {
-		cmd->v1.active_dwell = params->measurement_dwell;
-		cmd->v1.passive_dwell = params->measurement_dwell;
-		cmd->v1.extended_dwell = params->measurement_dwell;
 	} else {
-		cmd->v1.active_dwell = IWL_SCAN_DWELL_ACTIVE;
-		cmd->v1.passive_dwell = IWL_SCAN_DWELL_PASSIVE;
-		cmd->v1.extended_dwell = IWL_SCAN_DWELL_EXTENDED;
-	}
-	cmd->v1.fragmented_dwell = IWL_SCAN_DWELL_FRAGMENTED;
-
-	if (iwl_mvm_has_new_tx_api(mvm)) {
-		cmd->v6.scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
-		cmd->v6.max_out_time[SCAN_LB_LMAC_IDX] =
-			cpu_to_le32(timing->max_out_time);
-		cmd->v6.suspend_time[SCAN_LB_LMAC_IDX] =
-			cpu_to_le32(timing->suspend_time);
+		if (params->measurement_dwell) {
+			cmd->v1.active_dwell = params->measurement_dwell;
+			cmd->v1.passive_dwell = params->measurement_dwell;
+			cmd->v1.extended_dwell = params->measurement_dwell;
+		} else {
+			cmd->v1.active_dwell = IWL_SCAN_DWELL_ACTIVE;
+			cmd->v1.passive_dwell = IWL_SCAN_DWELL_PASSIVE;
+			cmd->v1.extended_dwell = IWL_SCAN_DWELL_EXTENDED;
+		}
+		cmd->v1.fragmented_dwell = IWL_SCAN_DWELL_FRAGMENTED;
 		if (iwl_mvm_is_cdb_supported(mvm)) {
+			struct iwl_mvm_scan_timing_params *hb_timing =
+				&scan_timing[params->type];
+
 			cmd->v6.max_out_time[SCAN_HB_LMAC_IDX] =
-				cpu_to_le32(timing->max_out_time);
+					cpu_to_le32(hb_timing->max_out_time);
 			cmd->v6.suspend_time[SCAN_HB_LMAC_IDX] =
+					cpu_to_le32(hb_timing->suspend_time);
+		}
+
+		if (iwl_mvm_has_new_tx_api(mvm)) {
+			cmd->v6.scan_priority =
+				cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
+			cmd->v6.max_out_time[SCAN_LB_LMAC_IDX] =
+				cpu_to_le32(timing->max_out_time);
+			cmd->v6.suspend_time[SCAN_LB_LMAC_IDX] =
+				cpu_to_le32(timing->suspend_time);
+		} else {
+			cmd->v1.scan_priority =
+				cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
+			cmd->v1.max_out_time =
+				cpu_to_le32(timing->max_out_time);
+			cmd->v1.suspend_time =
 				cpu_to_le32(timing->suspend_time);
 		}
-	} else {
-		cmd->v1.max_out_time = cpu_to_le32(timing->max_out_time);
-		cmd->v1.suspend_time = cpu_to_le32(timing->suspend_time);
-		cmd->v1.scan_priority =
-			cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
 	}
 }
 
@@ -1234,6 +1257,15 @@ static u16 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 	if (mvm->sched_scan_pass_all == SCHED_SCAN_PASS_ALL_ENABLED)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_ITER_COMPLETE;
 
+	if (iwl_mvm_is_adaptive_dwell_supported(mvm) && IWL_MVM_ADWELL_ENABLE &&
+	    vif->type != NL80211_IFTYPE_P2P_DEVICE)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_ADAPTIVE_DWELL;
+
+	/*
+	 * Extended dwell is relevant only for low band to start with, as it is
+	 * being used for social channles only (1, 6, 11), so we can check
+	 * only scan type on low band also for CDB.
+	 */
 	if (iwl_mvm_is_regular_scan(params) &&
 	    vif->type != NL80211_IFTYPE_P2P_DEVICE &&
 	    params->type != IWL_SCAN_TYPE_FRAGMENTED)
-- 
2.16.2
