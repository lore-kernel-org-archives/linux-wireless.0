Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4314 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbbFCHcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:32:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/15] iwlwifi: mvm: Add DC2DC_CONFIG_CMD (0x83) cmd & TLV
Date: Wed,  3 Jun 2015 10:31:34 +0300
Message-Id: <1433316696-4612-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093350_555713_E4D2C840)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Add DC2DC_CONFIG_CMD (0x83) cmd.

Add IWL_UCODE_TLV_CAPA_DC2DC_CONFIG_SUPPORT tlv.

The command allows the driver get & set the DCDC's frequency tune.
(freq_tune is the divider that is used to calculate the actual DCDC's
clock rate)
The command always returns the current/updated frequency tune values of
the DCDC.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h  | 46 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c     |  1 +
 3 files changed, 49 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 7efd629..a9b5ae4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -297,6 +297,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  *	which also implies support for the scheduler configuration command
  * @IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH: supports TDLS channel switching
  * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
+ * @IWL_UCODE_TLV_CAPA_DC2DC_SUPPORT: supports DC2DC Command
  * @IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS: support radio and beacon statistics
  * @IWL_UCODE_TLV_CAPA_BT_COEX_PLCR: enabled BT Coex packet level co-running
  * @IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC: ucode supports LAR updates with different
@@ -318,6 +319,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= (__force iwl_ucode_tlv_capa_t)12,
 	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= (__force iwl_ucode_tlv_capa_t)13,
 	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)18,
+	IWL_UCODE_TLV_CAPA_DC2DC_CONFIG_SUPPORT		= (__force iwl_ucode_tlv_capa_t)19,
 	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= (__force iwl_ucode_tlv_capa_t)22,
 	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= (__force iwl_ucode_tlv_capa_t)28,
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 7128379..16e9ef4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -171,6 +171,9 @@ enum {
 	/* Thermal Throttling*/
 	REPLY_THERMAL_MNG_BACKOFF = 0x7e,
 
+	/* Set/Get DC2DC frequency tune */
+	DC2DC_CONFIG_CMD = 0x83,
+
 	/* NVM */
 	NVM_ACCESS_CMD = 0x88,
 
@@ -1389,6 +1392,49 @@ struct iwl_mvm_marker {
 	__le32 metadata[0];
 } __packed; /* MARKER_API_S_VER_1 */
 
+/*
+ * enum iwl_dc2dc_config_id - flag ids
+ *
+ * Ids of dc2dc configuration flags
+ */
+enum iwl_dc2dc_config_id {
+	DCDC_LOW_POWER_MODE_MSK_SET  = 0x1, /* not used */
+	DCDC_FREQ_TUNE_SET = 0x2,
+}; /* MARKER_ID_API_E_VER_1 */
+
+/**
+ * struct iwl_dc2dc_config_cmd - configure dc2dc values
+ *
+ * (DC2DC_CONFIG_CMD = 0x83)
+ *
+ * Set/Get & configure dc2dc values.
+ * The command always returns the current dc2dc values.
+ *
+ * @flags: set/get dc2dc
+ * @enable_low_power_mode: not used.
+ * @dc2dc_freq_tune0: frequency divider - digital domain
+ * @dc2dc_freq_tune1: frequency divider - analog domain
+ */
+struct iwl_dc2dc_config_cmd {
+	__le32 flags;
+	__le32 enable_low_power_mode; /* not used */
+	__le32 dc2dc_freq_tune0;
+	__le32 dc2dc_freq_tune1;
+} __packed; /* DC2DC_CONFIG_CMD_API_S_VER_1 */
+
+/**
+ * struct iwl_dc2dc_config_resp - response for iwl_dc2dc_config_cmd
+ *
+ * Current dc2dc values returned by the FW.
+ *
+ * @dc2dc_freq_tune0: frequency divider - digital domain
+ * @dc2dc_freq_tune1: frequency divider - analog domain
+ */
+struct iwl_dc2dc_config_resp {
+	__le32 dc2dc_freq_tune0;
+	__le32 dc2dc_freq_tune1;
+} __packed; /* DC2DC_CONFIG_RESP_API_S_VER_1 */
+
 /***********************************
  * Smart Fifo API
  ***********************************/
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 2801f97..e4fa500 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -281,6 +281,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(BINDING_CONTEXT_CMD),
 	CMD(TIME_QUOTA_CMD),
 	CMD(NON_QOS_TX_COUNTER_CMD),
+	CMD(DC2DC_CONFIG_CMD),
 	CMD(NVM_ACCESS_CMD),
 	CMD(PHY_CONFIGURATION_CMD),
 	CMD(CALIB_RES_NOTIF_PHY_DB),
-- 
2.1.4

