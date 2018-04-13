Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39372 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754656AbeDMMnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:37 +0300
Message-Id: <20180413124256.21769-7-luca@coelho.fi> (sfid-20180413_144330_974482_EDCCB287)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: mvm: clean up scan capability checks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Introduce and use iwl_mvm_cdb_scan_api(), which checks the family.
Most of this will go away once the 22000 firmware supports adaptive
dwell, after which the V6 scan API won't be used, but the V3 scan
*config* API will still need to be distinguished.

In any case, this gets rid of the completely bogus has_new_tx_api()
checks.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 10 ++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 15 ++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 6f647fdd4e97..1f5ead472c1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1356,6 +1356,16 @@ static inline bool iwl_mvm_is_cdb_supported(struct iwl_mvm *mvm)
 			   IWL_UCODE_TLV_CAPA_CDB_SUPPORT);
 }
 
+static inline bool iwl_mvm_cdb_scan_api(struct iwl_mvm *mvm)
+{
+	/*
+	 * TODO: should this be the same as iwl_mvm_is_cdb_supported()?
+	 * but then there's a little bit of code in scan that won't make
+	 * any sense...
+	 */
+	return mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22000;
+}
+
 static inline bool iwl_mvm_has_new_rx_stats_api(struct iwl_mvm *mvm)
 {
 	return fw_has_api(&mvm->fw->ucode_capa,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 8fcd92dcaaa7..8c5f4f96d6d4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -147,7 +147,7 @@ static inline void *iwl_mvm_get_scan_req_umac_data(struct iwl_mvm *mvm)
 	if (iwl_mvm_is_adaptive_dwell_supported(mvm))
 		return (void *)&cmd->v7.data;
 
-	if (iwl_mvm_has_new_tx_api(mvm))
+	if (iwl_mvm_cdb_scan_api(mvm))
 		return (void *)&cmd->v6.data;
 
 	return (void *)&cmd->v1.data;
@@ -164,7 +164,7 @@ iwl_mvm_get_scan_req_umac_channel(struct iwl_mvm *mvm)
 	if (iwl_mvm_is_adaptive_dwell_supported(mvm))
 		return &cmd->v7.channel;
 
-	if (iwl_mvm_has_new_tx_api(mvm))
+	if (iwl_mvm_cdb_scan_api(mvm))
 		return &cmd->v6.channel;
 
 	return &cmd->v1.channel;
@@ -1136,7 +1136,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 			return 0;
 	}
 
-	if (iwl_mvm_has_new_tx_api(mvm))
+	if (iwl_mvm_cdb_scan_api(mvm))
 		cmd_size = sizeof(struct iwl_scan_config);
 	else
 		cmd_size = sizeof(struct iwl_scan_config_v1);
@@ -1169,7 +1169,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	 * Check for fragmented scan on LMAC2 - high band.
 	 * LMAC1 - low band is checked above.
 	 */
-	if (iwl_mvm_has_new_tx_api(mvm)) {
+	if (iwl_mvm_cdb_scan_api(mvm)) {
 		if (iwl_mvm_is_cdb_supported(mvm))
 			flags |= (hb_type == IWL_SCAN_TYPE_FRAGMENTED) ?
 				 SCAN_CONFIG_FLAG_SET_LMAC2_FRAGMENTED :
@@ -1281,8 +1281,9 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 					cpu_to_le32(hb_timing->suspend_time);
 		}
 
-		if (iwl_mvm_has_new_tx_api(mvm)) {
-			cmd->v6.scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
+		if (iwl_mvm_cdb_scan_api(mvm)) {
+			cmd->v6.scan_priority =
+				cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
 			cmd->v6.max_out_time[SCAN_LB_LMAC_IDX] =
 				cpu_to_le32(timing->max_out_time);
 			cmd->v6.suspend_time[SCAN_LB_LMAC_IDX] =
@@ -1909,7 +1910,7 @@ int iwl_mvm_scan_size(struct iwl_mvm *mvm)
 		base_size = IWL_SCAN_REQ_UMAC_SIZE_V8;
 	else if (iwl_mvm_is_adaptive_dwell_supported(mvm))
 		base_size = IWL_SCAN_REQ_UMAC_SIZE_V7;
-	else if (iwl_mvm_has_new_tx_api(mvm))
+	else if (iwl_mvm_cdb_scan_api(mvm))
 		base_size = IWL_SCAN_REQ_UMAC_SIZE_V6;
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN))
-- 
2.16.3
