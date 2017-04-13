Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51272 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751803AbdDMPZZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:25:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:46 +0300
Message-Id: <20170413152507.9648-6-luca@coelho.fi> (sfid-20170413_172530_847256_17313E2D)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 05/26] iwlwifi: mvm: use same scan API for all a000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

API will be the same regardless of FW compilation.
CDB related values will be filled in only for CDB.
Cahneg code and names accordingly.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   | 14 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 80 ++++++++++++----------
 2 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
index c78a0c499459..3178eb96e395 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
@@ -516,7 +516,7 @@ struct iwl_scan_dwell {
  *				scan_config_channel_flag
  * @channel_array:		default supported channels
  */
-struct iwl_scan_config {
+struct iwl_scan_config_v1 {
 	__le32 flags;
 	__le32 tx_chains;
 	__le32 rx_chains;
@@ -532,7 +532,7 @@ struct iwl_scan_config {
 
 #define SCAN_TWO_LMACS 2
 
-struct iwl_scan_config_cdb {
+struct iwl_scan_config {
 	__le32 flags;
 	__le32 tx_chains;
 	__le32 rx_chains;
@@ -669,7 +669,7 @@ struct iwl_scan_req_umac {
 			u8 n_channels;
 			__le16 reserved;
 			u8 data[];
-		} no_cdb; /* SCAN_REQUEST_CMD_UMAC_API_S_VER_1 */
+		} v1; /* SCAN_REQUEST_CMD_UMAC_API_S_VER_1 */
 		struct {
 			__le32 max_out_time[SCAN_TWO_LMACS];
 			__le32 suspend_time[SCAN_TWO_LMACS];
@@ -679,13 +679,13 @@ struct iwl_scan_req_umac {
 			u8 n_channels;
 			__le16 reserved;
 			u8 data[];
-		} cdb; /* SCAN_REQUEST_CMD_UMAC_API_S_VER_5 */
+		} v6; /* SCAN_REQUEST_CMD_UMAC_API_S_VER_6 */
 	};
 } __packed;
 
-#define IWL_SCAN_REQ_UMAC_SIZE_CDB sizeof(struct iwl_scan_req_umac)
-#define IWL_SCAN_REQ_UMAC_SIZE (sizeof(struct iwl_scan_req_umac) - \
-				2 * sizeof(__le32))
+#define IWL_SCAN_REQ_UMAC_SIZE sizeof(struct iwl_scan_req_umac)
+#define IWL_SCAN_REQ_UMAC_SIZE_V1 (sizeof(struct iwl_scan_req_umac) - \
+				   2 * sizeof(__le32))
 
 /**
  * struct iwl_umac_scan_abort
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 0a64efa844b7..ce6a2b3b021e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -966,11 +966,11 @@ static void iwl_mvm_fill_channels(struct iwl_mvm *mvm, u8 *channels)
 		channels[j] = band->channels[i].hw_value;
 }
 
-static void iwl_mvm_fill_scan_config(struct iwl_mvm *mvm, void *config,
-				     u32 flags, u8 channel_flags)
+static void iwl_mvm_fill_scan_config_v1(struct iwl_mvm *mvm, void *config,
+					u32 flags, u8 channel_flags)
 {
 	enum iwl_mvm_scan_type type = iwl_mvm_get_scan_type(mvm, false);
-	struct iwl_scan_config *cfg = config;
+	struct iwl_scan_config_v1 *cfg = config;
 
 	cfg->flags = cpu_to_le32(flags);
 	cfg->tx_chains = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
@@ -989,11 +989,11 @@ static void iwl_mvm_fill_scan_config(struct iwl_mvm *mvm, void *config,
 	iwl_mvm_fill_channels(mvm, cfg->channel_array);
 }
 
-static void iwl_mvm_fill_scan_config_cdb(struct iwl_mvm *mvm, void *config,
-					 u32 flags, u8 channel_flags)
+static void iwl_mvm_fill_scan_config(struct iwl_mvm *mvm, void *config,
+				     u32 flags, u8 channel_flags)
 {
 	enum iwl_mvm_scan_type type = iwl_mvm_get_scan_type(mvm, false);
-	struct iwl_scan_config_cdb *cfg = config;
+	struct iwl_scan_config *cfg = config;
 
 	cfg->flags = cpu_to_le32(flags);
 	cfg->tx_chains = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
@@ -1001,10 +1001,14 @@ static void iwl_mvm_fill_scan_config_cdb(struct iwl_mvm *mvm, void *config,
 	cfg->legacy_rates = iwl_mvm_scan_config_rates(mvm);
 	cfg->out_of_channel_time[0] =
 		cpu_to_le32(scan_timing[type].max_out_time);
-	cfg->out_of_channel_time[1] =
-		cpu_to_le32(scan_timing[type].max_out_time);
 	cfg->suspend_time[0] = cpu_to_le32(scan_timing[type].suspend_time);
-	cfg->suspend_time[1] = cpu_to_le32(scan_timing[type].suspend_time);
+
+	if (iwl_mvm_is_cdb_supported(mvm)) {
+		cfg->suspend_time[1] =
+			cpu_to_le32(scan_timing[type].suspend_time);
+		cfg->out_of_channel_time[1] =
+			cpu_to_le32(scan_timing[type].max_out_time);
+	}
 
 	iwl_mvm_fill_scan_dwell(mvm, &cfg->dwell, &scan_timing[type]);
 
@@ -1039,10 +1043,10 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 		return 0;
 	}
 
-	if (iwl_mvm_is_cdb_supported(mvm))
-		cmd_size = sizeof(struct iwl_scan_config_cdb);
-	else
+	if (iwl_mvm_has_new_tx_api(mvm))
 		cmd_size = sizeof(struct iwl_scan_config);
+	else
+		cmd_size = sizeof(struct iwl_scan_config_v1);
 	cmd_size += mvm->fw->ucode_capa.n_scan_channels;
 
 	cfg = kzalloc(cmd_size, GFP_KERNEL);
@@ -1068,13 +1072,13 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 			IWL_CHANNEL_FLAG_EBS_ADD |
 			IWL_CHANNEL_FLAG_PRE_SCAN_PASSIVE2ACTIVE;
 
-	if (iwl_mvm_is_cdb_supported(mvm)) {
+	if (iwl_mvm_has_new_tx_api(mvm)) {
 		flags |= (type == IWL_SCAN_TYPE_FRAGMENTED) ?
 			 SCAN_CONFIG_FLAG_SET_LMAC2_FRAGMENTED :
 			 SCAN_CONFIG_FLAG_CLEAR_LMAC2_FRAGMENTED;
-		iwl_mvm_fill_scan_config_cdb(mvm, cfg, flags, channel_flags);
-	} else {
 		iwl_mvm_fill_scan_config(mvm, cfg, flags, channel_flags);
+	} else {
+		iwl_mvm_fill_scan_config_v1(mvm, cfg, flags, channel_flags);
 	}
 
 	cmd.data[0] = cfg;
@@ -1119,16 +1123,20 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 	}
 	cmd->fragmented_dwell = timing->dwell_fragmented;
 
-	if (iwl_mvm_is_cdb_supported(mvm)) {
-		cmd->cdb.max_out_time[0] = cpu_to_le32(timing->max_out_time);
-		cmd->cdb.suspend_time[0] = cpu_to_le32(timing->suspend_time);
-		cmd->cdb.max_out_time[1] = cpu_to_le32(timing->max_out_time);
-		cmd->cdb.suspend_time[1] = cpu_to_le32(timing->suspend_time);
-		cmd->cdb.scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		cmd->v6.scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
+		cmd->v6.max_out_time[0] = cpu_to_le32(timing->max_out_time);
+		cmd->v6.suspend_time[0] = cpu_to_le32(timing->suspend_time);
+		if (iwl_mvm_is_cdb_supported(mvm)) {
+			cmd->v6.max_out_time[1] =
+				cpu_to_le32(timing->max_out_time);
+			cmd->v6.suspend_time[1] =
+				cpu_to_le32(timing->suspend_time);
+		}
 	} else {
-		cmd->no_cdb.max_out_time = cpu_to_le32(timing->max_out_time);
-		cmd->no_cdb.suspend_time = cpu_to_le32(timing->suspend_time);
-		cmd->no_cdb.scan_priority =
+		cmd->v1.max_out_time = cpu_to_le32(timing->max_out_time);
+		cmd->v1.suspend_time = cpu_to_le32(timing->suspend_time);
+		cmd->v1.scan_priority =
 			cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
 	}
 
@@ -1207,8 +1215,8 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     int type)
 {
 	struct iwl_scan_req_umac *cmd = mvm->scan_cmd;
-	void *cmd_data = iwl_mvm_is_cdb_supported(mvm) ?
-			 (void *)&cmd->cdb.data : (void *)&cmd->no_cdb.data;
+	void *cmd_data = iwl_mvm_has_new_tx_api(mvm) ?
+			 (void *)&cmd->v6.data : (void *)&cmd->v1.data;
 	struct iwl_scan_req_umac_tail *sec_part = cmd_data +
 		sizeof(struct iwl_scan_channel_cfg_umac) *
 			mvm->fw->ucode_capa.n_scan_channels;
@@ -1245,12 +1253,12 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
 
-	if (iwl_mvm_is_cdb_supported(mvm)) {
-		cmd->cdb.channel_flags = channel_flags;
-		cmd->cdb.n_channels = params->n_channels;
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		cmd->v6.channel_flags = channel_flags;
+		cmd->v6.n_channels = params->n_channels;
 	} else {
-		cmd->no_cdb.channel_flags = channel_flags;
-		cmd->no_cdb.n_channels = params->n_channels;
+		cmd->v1.channel_flags = channel_flags;
+		cmd->v1.n_channels = params->n_channels;
 	}
 
 	iwl_scan_build_ssids(params, sec_part->direct_scan, &ssid_bitmap);
@@ -1692,10 +1700,10 @@ static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 
 int iwl_mvm_scan_size(struct iwl_mvm *mvm)
 {
-	int base_size = IWL_SCAN_REQ_UMAC_SIZE;
+	int base_size = IWL_SCAN_REQ_UMAC_SIZE_V1;
 
-	if (iwl_mvm_is_cdb_supported(mvm))
-		base_size = IWL_SCAN_REQ_UMAC_SIZE_CDB;
+	if (iwl_mvm_has_new_tx_api(mvm))
+		base_size = IWL_SCAN_REQ_UMAC_SIZE;
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN))
 		return base_size +
-- 
2.11.0
