Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42834 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726797AbeHUJzz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:55:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:46 +0300
Message-Id: <20180821063657.30071-5-luca@coelho.fi> (sfid-20180821_083713_517647_0BE1CC9E)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 04/15] iwlwifi: mvm: support new reduce tx power FW API.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Update reduce tx power command API to be compatible with new FW API.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/commands.h  |  3 +-
 .../net/wireless/intel/iwlwifi/fw/api/power.h | 30 +++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 23 +++++++++-----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 25 +++++++++++-----
 5 files changed, 66 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index 6dad748e5cdc..8b4922bbe139 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -436,7 +436,8 @@ enum iwl_legacy_cmds {
 
 	/**
 	 * @REDUCE_TX_POWER_CMD:
-	 * &struct iwl_dev_tx_power_cmd_v3 or &struct iwl_dev_tx_power_cmd
+	 * &struct iwl_dev_tx_power_cmd_v3 or &struct iwl_dev_tx_power_cmd_v4
+	 * or &struct iwl_dev_tx_power_cmd
 	 */
 	REDUCE_TX_POWER_CMD = 0x9f,
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index a3c77e01863b..286a22da232d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -316,7 +318,9 @@ enum iwl_dev_tx_power_cmd_mode {
 	IWL_TX_POWER_MODE_SET_DEVICE = 1,
 	IWL_TX_POWER_MODE_SET_CHAINS = 2,
 	IWL_TX_POWER_MODE_SET_ACK = 3,
-}; /* TX_POWER_REDUCED_FLAGS_TYPE_API_E_VER_4 */;
+	IWL_TX_POWER_MODE_SET_SAR_TIMER = 4,
+	IWL_TX_POWER_MODE_SET_SAR_TIMER_DEFAULT_TABLE = 5,
+}; /* TX_POWER_REDUCED_FLAGS_TYPE_API_E_VER_5 */;
 
 #define IWL_NUM_CHAIN_LIMITS	2
 #define IWL_NUM_SUB_BANDS	5
@@ -350,13 +354,35 @@ struct iwl_dev_tx_power_cmd_v3 {
  *	reduction.
  * @reserved: reserved (padding)
  */
-struct iwl_dev_tx_power_cmd {
+struct iwl_dev_tx_power_cmd_v4 {
 	/* v4 is just an extension of v3 - keep this here */
 	struct iwl_dev_tx_power_cmd_v3 v3;
 	u8 enable_ack_reduction;
 	u8 reserved[3];
 } __packed; /* TX_REDUCED_POWER_API_S_VER_4 */
 
+/**
+ * struct iwl_dev_tx_power_cmd - TX power reduction command
+ * @v3: version 3 of the command, embedded here for easier software handling
+ * @enable_ack_reduction: enable or disable close range ack TX power
+ *	reduction.
+ * @per_chain_restriction_changed: is per_chain_restriction has changed
+ *	from last command. used if set_mode is
+ *	IWL_TX_POWER_MODE_SET_SAR_TIMER.
+ *	note: if not changed, the command is used for keep alive only.
+ * @reserved: reserved (padding)
+ * @timer_period: timer in milliseconds. if expires FW will change to default
+ *	BIOS values. relevant if setMode is IWL_TX_POWER_MODE_SET_SAR_TIMER
+ */
+struct iwl_dev_tx_power_cmd {
+	/* v5 is just an extension of v3 - keep this here */
+	struct iwl_dev_tx_power_cmd_v3 v3;
+	u8 enable_ack_reduction;
+	u8 per_chain_restriction_changed;
+	u8 reserved[2];
+	__le32 timer_period;
+} __packed; /* TX_REDUCED_POWER_API_S_VER_5 */
+
 #define IWL_NUM_GEO_PROFILES   3
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index c7e296a5dda9..fce52ee4caec 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -259,6 +259,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_ADAPTIVE_DWELL_V2: This ucode supports version 8
  *	of scan request: SCAN_REQUEST_CMD_UMAC_API_S_VER_8
  * @IWL_UCODE_TLV_API_FRAG_EBS: This ucode supports fragmented EBS
+ * @IWL_UCODE_TLV_API_REDUCE_TX_POWER: This ucode supports v5 of
+ *	the REDUCE_TX_POWER_CMD.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -282,6 +284,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_DEPRECATE_TTAK	= (__force iwl_ucode_tlv_api_t)41,
 	IWL_UCODE_TLV_API_ADAPTIVE_DWELL_V2	= (__force iwl_ucode_tlv_api_t)42,
 	IWL_UCODE_TLV_API_FRAG_EBS		= (__force iwl_ucode_tlv_api_t)44,
+	IWL_UCODE_TLV_API_REDUCE_TX_POWER	= (__force iwl_ucode_tlv_api_t)45,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 6bb1a99a197a..878dc29c2010 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -773,19 +773,28 @@ static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm)
 
 int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 {
-	struct iwl_dev_tx_power_cmd cmd = {
-		.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS),
-	};
+	union {
+		struct iwl_dev_tx_power_cmd v5;
+		struct iwl_dev_tx_power_cmd_v4 v4;
+	} cmd;
 	int i, j, idx;
 	int profs[ACPI_SAR_NUM_CHAIN_LIMITS] = { prof_a, prof_b };
-	int len = sizeof(cmd);
+	int len;
 
 	BUILD_BUG_ON(ACPI_SAR_NUM_CHAIN_LIMITS < 2);
 	BUILD_BUG_ON(ACPI_SAR_NUM_CHAIN_LIMITS * ACPI_SAR_NUM_SUB_BANDS !=
 		     ACPI_SAR_TABLE_SIZE);
 
-	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
-		len = sizeof(cmd.v3);
+	cmd.v5.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS);
+
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_REDUCE_TX_POWER))
+		len = sizeof(cmd.v5);
+	else if (fw_has_capa(&mvm->fw->ucode_capa,
+			     IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
+		len = sizeof(cmd.v4);
+	else
+		len = sizeof(cmd.v4.v3);
 
 	for (i = 0; i < ACPI_SAR_NUM_CHAIN_LIMITS; i++) {
 		struct iwl_mvm_sar_profile *prof;
@@ -812,7 +821,7 @@ int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 		IWL_DEBUG_RADIO(mvm, "  Chain[%d]:\n", i);
 		for (j = 0; j < ACPI_SAR_NUM_SUB_BANDS; j++) {
 			idx = (i * ACPI_SAR_NUM_SUB_BANDS) + j;
-			cmd.v3.per_chain_restriction[i][j] =
+			cmd.v5.v3.per_chain_restriction[i][j] =
 				cpu_to_le16(prof->table[idx]);
 			IWL_DEBUG_RADIO(mvm, "    Band[%d] = %d * .125dBm\n",
 					j, prof->table[idx]);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 66a4ca090412..c0c3ff6a0e6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1309,19 +1309,28 @@ static struct iwl_mvm_phy_ctxt *iwl_mvm_get_free_phy_ctxt(struct iwl_mvm *mvm)
 static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				s16 tx_power)
 {
-	struct iwl_dev_tx_power_cmd cmd = {
-		.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_MAC),
-		.v3.mac_context_id =
+	int len;
+	union {
+		struct iwl_dev_tx_power_cmd v5;
+		struct iwl_dev_tx_power_cmd_v4 v4;
+	} cmd = {
+		.v5.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_MAC),
+		.v5.v3.mac_context_id =
 			cpu_to_le32(iwl_mvm_vif_from_mac80211(vif)->id),
-		.v3.pwr_restriction = cpu_to_le16(8 * tx_power),
+		.v5.v3.pwr_restriction = cpu_to_le16(8 * tx_power),
 	};
-	int len = sizeof(cmd);
 
 	if (tx_power == IWL_DEFAULT_MAX_TX_POWER)
-		cmd.v3.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
+		cmd.v5.v3.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
 
-	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
-		len = sizeof(cmd.v3);
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_REDUCE_TX_POWER))
+		len = sizeof(cmd.v5);
+	else if (fw_has_capa(&mvm->fw->ucode_capa,
+			     IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
+		len = sizeof(cmd.v4);
+	else
+		len = sizeof(cmd.v4.v3);
 
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
-- 
2.18.0
