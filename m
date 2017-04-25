Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54262 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1949103AbdDYUYK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:24:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:32 +0300
Message-Id: <20170425202243.7844-15-luca@coelho.fi> (sfid-20170425_222422_981980_6D972B46)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: mvm: use defines instead of variables for shared dwell times
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Most of the dwells are constant across different scan types.
Use defines instead of depending on scan type.
This is needed as preparation to having different scan type per
band.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 55 ++++++++++-----------------
 1 file changed, 20 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index ca6f3a82b277..8d1b994ae79f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -81,44 +81,30 @@ enum iwl_mvm_traffic_load {
 	IWL_MVM_TRAFFIC_HIGH,
 };
 
+#define IWL_SCAN_DWELL_ACTIVE		10
+#define IWL_SCAN_DWELL_PASSIVE		110
+#define IWL_SCAN_DWELL_FRAGMENTED	44
+#define IWL_SCAN_DWELL_EXTENDED		90
+
 struct iwl_mvm_scan_timing_params {
-	u32 dwell_active;
-	u32 dwell_passive;
-	u32 dwell_fragmented;
-	u32 dwell_extended;
 	u32 suspend_time;
 	u32 max_out_time;
 };
 
 static struct iwl_mvm_scan_timing_params scan_timing[] = {
 	[IWL_SCAN_TYPE_UNASSOC] = {
-		.dwell_active = 10,
-		.dwell_passive = 110,
-		.dwell_fragmented = 44,
-		.dwell_extended = 90,
 		.suspend_time = 0,
 		.max_out_time = 0,
 	},
 	[IWL_SCAN_TYPE_WILD] = {
-		.dwell_active = 10,
-		.dwell_passive = 110,
-		.dwell_fragmented = 44,
-		.dwell_extended = 90,
 		.suspend_time = 30,
 		.max_out_time = 120,
 	},
 	[IWL_SCAN_TYPE_MILD] = {
-		.dwell_active = 10,
-		.dwell_passive = 110,
-		.dwell_fragmented = 44,
-		.dwell_extended = 90,
 		.suspend_time = 120,
 		.max_out_time = 120,
 	},
 	[IWL_SCAN_TYPE_FRAGMENTED] = {
-		.dwell_active = 10,
-		.dwell_passive = 110,
-		.dwell_fragmented = 44,
 		.suspend_time = 95,
 		.max_out_time = 44,
 	},
@@ -724,10 +710,10 @@ static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_lmac *cmd,
 				    struct iwl_mvm_scan_params *params)
 {
-	cmd->active_dwell = scan_timing[params->type].dwell_active;
-	cmd->passive_dwell = scan_timing[params->type].dwell_passive;
-	cmd->fragmented_dwell = scan_timing[params->type].dwell_fragmented;
-	cmd->extended_dwell = scan_timing[params->type].dwell_extended;
+	cmd->active_dwell = IWL_SCAN_DWELL_ACTIVE;
+	cmd->passive_dwell = IWL_SCAN_DWELL_PASSIVE;
+	cmd->fragmented_dwell = IWL_SCAN_DWELL_FRAGMENTED;
+	cmd->extended_dwell = IWL_SCAN_DWELL_EXTENDED;
 	cmd->max_out_time = cpu_to_le32(scan_timing[params->type].max_out_time);
 	cmd->suspend_time = cpu_to_le32(scan_timing[params->type].suspend_time);
 	cmd->scan_prio = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
@@ -925,13 +911,12 @@ static __le32 iwl_mvm_scan_config_rates(struct iwl_mvm *mvm)
 }
 
 static void iwl_mvm_fill_scan_dwell(struct iwl_mvm *mvm,
-				    struct iwl_scan_dwell *dwell,
-				    struct iwl_mvm_scan_timing_params *timing)
+				    struct iwl_scan_dwell *dwell)
 {
-	dwell->active = timing->dwell_active;
-	dwell->passive = timing->dwell_passive;
-	dwell->fragmented = timing->dwell_fragmented;
-	dwell->extended = timing->dwell_extended;
+	dwell->active = IWL_SCAN_DWELL_ACTIVE;
+	dwell->passive = IWL_SCAN_DWELL_PASSIVE;
+	dwell->fragmented = IWL_SCAN_DWELL_FRAGMENTED;
+	dwell->extended = IWL_SCAN_DWELL_EXTENDED;
 }
 
 static void iwl_mvm_fill_channels(struct iwl_mvm *mvm, u8 *channels)
@@ -960,7 +945,7 @@ static void iwl_mvm_fill_scan_config_v1(struct iwl_mvm *mvm, void *config,
 	cfg->out_of_channel_time = cpu_to_le32(scan_timing[type].max_out_time);
 	cfg->suspend_time = cpu_to_le32(scan_timing[type].suspend_time);
 
-	iwl_mvm_fill_scan_dwell(mvm, &cfg->dwell, &scan_timing[type]);
+	iwl_mvm_fill_scan_dwell(mvm, &cfg->dwell);
 
 	memcpy(&cfg->mac_addr, &mvm->addresses[0].addr, ETH_ALEN);
 
@@ -991,7 +976,7 @@ static void iwl_mvm_fill_scan_config(struct iwl_mvm *mvm, void *config,
 			cpu_to_le32(scan_timing[type].max_out_time);
 	}
 
-	iwl_mvm_fill_scan_dwell(mvm, &cfg->dwell, &scan_timing[type]);
+	iwl_mvm_fill_scan_dwell(mvm, &cfg->dwell);
 
 	memcpy(&cfg->mac_addr, &mvm->addresses[0].addr, ETH_ALEN);
 
@@ -1095,11 +1080,11 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 		cmd->passive_dwell = params->measurement_dwell;
 		cmd->extended_dwell = params->measurement_dwell;
 	} else {
-		cmd->active_dwell = timing->dwell_active;
-		cmd->passive_dwell = timing->dwell_passive;
-		cmd->extended_dwell = timing->dwell_extended;
+		cmd->active_dwell = IWL_SCAN_DWELL_ACTIVE;
+		cmd->passive_dwell = IWL_SCAN_DWELL_PASSIVE;
+		cmd->extended_dwell = IWL_SCAN_DWELL_EXTENDED;
 	}
-	cmd->fragmented_dwell = timing->dwell_fragmented;
+	cmd->fragmented_dwell = IWL_SCAN_DWELL_FRAGMENTED;
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		cmd->v6.scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
-- 
2.11.0
