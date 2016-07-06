Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33410 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753349AbcGFKo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:49 +0300
Message-Id: <1467801651-1816-54-git-send-email-luca@coelho.fi> (sfid-20160706_124433_320471_0A6017BC)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 54/56] iwlwifi: mvm: support v4 of the TX power command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add support for the v4 version of the TX power command.  Just add a
new version and do the same sizing tricks that were done when support
for v3 was introduced.

This patch doesn't support the new functionality introduced, but makes
the driver work with the new size of the command.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |  4 ++++
 .../net/wireless/intel/iwlwifi/mvm/fw-api-power.h  | 22 ++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 11 +++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 12 +++++++-----
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index eb18de8..d56b3d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -328,6 +328,9 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG: support getting more shared
  *	memory addresses from the firmware.
  * @IWL_UCODE_TLV_CAPA_LQM_SUPPORT: supports Link Quality Measurement
+ * @IWL_UCODE_TLV_CAPA_TX_POWER_ACK: reduced TX power API has larger
+ *	command size (command version 4) that supports toggling ACK TX
+ *	power reduction.
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -368,6 +371,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_USNIFFER_UNIFIED		= (__force iwl_ucode_tlv_capa_t)77,
 	IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG	= (__force iwl_ucode_tlv_capa_t)80,
 	IWL_UCODE_TLV_CAPA_LQM_SUPPORT			= (__force iwl_ucode_tlv_capa_t)81,
+	IWL_UCODE_TLV_CAPA_TX_POWER_ACK			= (__force iwl_ucode_tlv_capa_t)84,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
index 65a7c8a..404b0de 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -310,7 +310,8 @@ enum iwl_dev_tx_power_cmd_mode {
 	IWL_TX_POWER_MODE_SET_MAC = 0,
 	IWL_TX_POWER_MODE_SET_DEVICE = 1,
 	IWL_TX_POWER_MODE_SET_CHAINS = 2,
-}; /* TX_POWER_REDUCED_FLAGS_TYPE_API_E_VER_2 */;
+	IWL_TX_POWER_MODE_SET_ACK = 3,
+}; /* TX_POWER_REDUCED_FLAGS_TYPE_API_E_VER_4 */;
 
 /**
  * struct iwl_dev_tx_power_cmd_v2 - TX power reduction command
@@ -338,7 +339,7 @@ struct iwl_dev_tx_power_cmd_v2 {
  * @v2: version 2 of the command, embedded here for easier software handling
  * @per_chain_restriction: per chain restrictions
  */
-struct iwl_dev_tx_power_cmd {
+struct iwl_dev_tx_power_cmd_v3 {
 	/* v3 is just an extension of v2 - keep this here */
 	struct iwl_dev_tx_power_cmd_v2 v2;
 	__le16 per_chain_restriction[IWL_NUM_CHAIN_LIMITS][IWL_NUM_SUB_BANDS];
@@ -347,6 +348,19 @@ struct iwl_dev_tx_power_cmd {
 #define IWL_DEV_MAX_TX_POWER 0x7FFF
 
 /**
+ * struct iwl_dev_tx_power_cmd - TX power reduction command
+ * @v3: version 3 of the command, embedded here for easier software handling
+ * @enable_ack_reduction: enable or disable close range ack TX power
+ *	reduction.
+ */
+struct iwl_dev_tx_power_cmd {
+	/* v4 is just an extension of v3 - keep this here */
+	struct iwl_dev_tx_power_cmd_v3 v3;
+	u8 enable_ack_reduction;
+	u8 reserved[3];
+} __packed; /* TX_REDUCED_POWER_API_S_VER_4 */
+
+/**
  * struct iwl_beacon_filter_cmd
  * REPLY_BEACON_FILTERING_CMD = 0xd2 (command)
  * @id_and_color: MAC contex identifier
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 4c16fa7..7e0cdbf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1027,9 +1027,10 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 {
 	struct iwl_mvm_sar_table sar_table;
 	struct iwl_dev_tx_power_cmd cmd = {
-		.v2.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS),
+		.v3.v2.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS),
 	};
 	int ret, i, j, idx;
+	int len = sizeof(cmd);
 
 	/* we can't do anything with the table if the FW doesn't support it */
 	if (!fw_has_api(&mvm->fw->ucode_capa,
@@ -1039,6 +1040,9 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 		return 0;
 	}
 
+	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
+		len = sizeof(cmd.v3);
+
 	ret = iwl_mvm_sar_get_table(mvm, &sar_table);
 	if (ret < 0) {
 		IWL_DEBUG_RADIO(mvm,
@@ -1060,15 +1064,14 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 		IWL_DEBUG_RADIO(mvm, "  Chain[%d]:\n", i);
 		for (j = 0; j < IWL_NUM_SUB_BANDS; j++) {
 			idx = (i * IWL_NUM_SUB_BANDS) + j;
-			cmd.per_chain_restriction[i][j] =
+			cmd.v3.per_chain_restriction[i][j] =
 				cpu_to_le16(sar_table.values[idx]);
 			IWL_DEBUG_RADIO(mvm, "    Band[%d] = %d * .125dBm\n",
 					j, sar_table.values[idx]);
 		}
 	}
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0,
-				   sizeof(cmd), &cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 	if (ret)
 		IWL_ERR(mvm, "failed to set per-chain TX power: %d\n", ret);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 73e49d3..53761c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1250,18 +1250,20 @@ static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				s16 tx_power)
 {
 	struct iwl_dev_tx_power_cmd cmd = {
-		.v2.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_MAC),
-		.v2.mac_context_id =
+		.v3.v2.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_MAC),
+		.v3.v2.mac_context_id =
 			cpu_to_le32(iwl_mvm_vif_from_mac80211(vif)->id),
-		.v2.pwr_restriction = cpu_to_le16(8 * tx_power),
+		.v3.v2.pwr_restriction = cpu_to_le16(8 * tx_power),
 	};
 	int len = sizeof(cmd);
 
 	if (tx_power == IWL_DEFAULT_MAX_TX_POWER)
-		cmd.v2.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
+		cmd.v3.v2.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
 
+	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
+		len = sizeof(cmd.v3);
 	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_TX_POWER_CHAIN))
-		len = sizeof(cmd.v2);
+		len = sizeof(cmd.v3.v2);
 
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
-- 
2.8.1

