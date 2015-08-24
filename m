Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbbHXUAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 16:00:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/6] iwlwifi: mvm: support new TX power command
Date: Mon, 24 Aug 2015 23:00:36 +0300
Message-Id: <1440446437-29188-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150824_220053_212379_C8227798)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support for the new (bigger) TX power command. This doesn't
actually take advantage of the new capabilities (to set per-chain
TX power limits) but makes the code compatible with newer firmware
images expecting the larger command.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  3 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 29 +++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 15 ++++++++-----
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 75809ab..84653e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -259,6 +259,8 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_NEW_VERSION: new versioning format
  * @IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY: scan APIs use 8-level priority
  *	instead of 3.
+ * @IWL_UCODE_TLV_API_TX_POWER_CHAIN: TX power API has larger command size
+ *	(command version 3) that supports per-chain limits
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = (__force iwl_ucode_tlv_api_t)3,
@@ -274,6 +276,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_STATS_V10		= (__force iwl_ucode_tlv_api_t)19,
 	IWL_UCODE_TLV_API_NEW_VERSION		= (__force iwl_ucode_tlv_api_t)20,
 	IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY	= (__force iwl_ucode_tlv_api_t)24,
+	IWL_UCODE_TLV_API_TX_POWER_CHAIN	= (__force iwl_ucode_tlv_api_t)27,
 };
 
 typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index b86b169..7005fa4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -310,17 +312,22 @@ struct iwl_reduce_tx_power_cmd {
 	__le16 pwr_restriction;
 } __packed; /* TX_REDUCED_POWER_API_S_VER_1 */
 
+enum iwl_dev_tx_power_cmd_mode {
+	IWL_TX_POWER_MODE_SET_MAC = 0,
+	IWL_TX_POWER_MODE_SET_DEVICE = 1,
+	IWL_TX_POWER_MODE_SET_CHAINS = 2,
+}; /* TX_POWER_REDUCED_FLAGS_TYPE_API_E_VER_2 */;
+
 /**
- * struct iwl_dev_tx_power_cmd - TX power reduction command
- * REDUCE_TX_POWER_CMD = 0x9f
- * @set_mode: 0 - MAC tx power, 1 - device tx power
+ * struct iwl_dev_tx_power_cmd_v2 - TX power reduction command
+ * @set_mode: see &enum iwl_dev_tx_power_cmd_mode
  * @mac_context_id: id of the mac ctx for which we are reducing TX power.
  * @pwr_restriction: TX power restriction in 1/8 dBms.
  * @dev_24: device TX power restriction in 1/8 dBms
  * @dev_52_low: device TX power restriction upper band - low
  * @dev_52_high: device TX power restriction upper band - high
  */
-struct iwl_dev_tx_power_cmd {
+struct iwl_dev_tx_power_cmd_v2 {
 	__le32 set_mode;
 	__le32 mac_context_id;
 	__le16 pwr_restriction;
@@ -329,6 +336,20 @@ struct iwl_dev_tx_power_cmd {
 	__le16 dev_52_high;
 } __packed; /* TX_REDUCED_POWER_API_S_VER_2 */
 
+#define IWL_NUM_CHAIN_LIMITS	2
+#define IWL_NUM_SUB_BANDS	5
+
+/**
+ * struct iwl_dev_tx_power_cmd - TX power reduction command
+ * @v2: version 2 of the command, embedded here for easier software handling
+ * @per_chain_restriction: per chain restrictions
+ */
+struct iwl_dev_tx_power_cmd {
+	/* v3 is just an extension of v2 - keep this here */
+	struct iwl_dev_tx_power_cmd_v2 v2;
+	__le16 per_chain_restriction[IWL_NUM_CHAIN_LIMITS][IWL_NUM_SUB_BANDS];
+} __packed; /* TX_REDUCED_POWER_API_S_VER_3 */
+
 #define IWL_DEV_MAX_TX_POWER 0x7FFF
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 537a157..aa8c2b7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1595,20 +1595,23 @@ static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				s16 tx_power)
 {
 	struct iwl_dev_tx_power_cmd cmd = {
-		.set_mode = 0,
-		.mac_context_id =
+		.v2.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_MAC),
+		.v2.mac_context_id =
 			cpu_to_le32(iwl_mvm_vif_from_mac80211(vif)->id),
-		.pwr_restriction = cpu_to_le16(8 * tx_power),
+		.v2.pwr_restriction = cpu_to_le16(8 * tx_power),
 	};
+	int len = sizeof(cmd);
 
 	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_TX_POWER_DEV))
 		return iwl_mvm_set_tx_power_old(mvm, vif, tx_power);
 
 	if (tx_power == IWL_DEFAULT_MAX_TX_POWER)
-		cmd.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
+		cmd.v2.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
 
-	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0,
-				    sizeof(cmd), &cmd);
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_TX_POWER_CHAIN))
+		len = sizeof(cmd.v2);
+
+	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
 
 static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
-- 
2.1.4

