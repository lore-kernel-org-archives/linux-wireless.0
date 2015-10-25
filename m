Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbJYMB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/16] iwlwifi: mvm: correctly request DTS-measure for new cards
Date: Sun, 25 Oct 2015 14:01:04 +0200
Message-Id: <1445774476-24792-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130132_306972_9A8BB280)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Since the 8000 series, the DTS measurement request command has been
changed. Use an ucode capability flag to determine which version is
supported and send the extended command when needed.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |  2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h  | 63 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/tt.c      | 11 +++++-
 3 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 72ddd4a..847d58b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -306,6 +306,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  *	is supported.
  * @IWL_UCODE_TLV_CAPA_BT_COEX_RRC: supports BT Coex RRC
  * @IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT: supports gscan
+ * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -330,6 +331,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
 	IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT		= (__force iwl_ucode_tlv_capa_t)31,
+	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 44ff684..181590f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1524,6 +1524,69 @@ struct iwl_dts_measurement_cmd {
 } __packed; /* TEMPERATURE_MEASUREMENT_TRIGGER_CMD_S */
 
 /**
+* enum iwl_dts_control_measurement_mode - DTS measurement type
+* @DTS_AUTOMATIC: Automatic mode (full SW control). Provide temperature read
+*                 back (latest value. Not waiting for new value). Use automatic
+*                 SW DTS configuration.
+* @DTS_REQUEST_READ: Request DTS read. Configure DTS with manual settings,
+*                    trigger DTS reading and provide read back temperature read
+*                    when available.
+* @DTS_OVER_WRITE: over-write the DTS temperatures in the SW until next read
+* @DTS_DIRECT_WITHOUT_MEASURE: DTS returns its latest temperature result,
+*                              without measurement trigger.
+*/
+enum iwl_dts_control_measurement_mode {
+	DTS_AUTOMATIC			= 0,
+	DTS_REQUEST_READ		= 1,
+	DTS_OVER_WRITE			= 2,
+	DTS_DIRECT_WITHOUT_MEASURE	= 3,
+};
+
+/**
+* enum iwl_dts_used - DTS to use or used for measurement in the DTS request
+* @DTS_USE_TOP: Top
+* @DTS_USE_CHAIN_A: chain A
+* @DTS_USE_CHAIN_B: chain B
+* @DTS_USE_CHAIN_C: chain C
+* @XTAL_TEMPERATURE - read temperature from xtal
+*/
+enum iwl_dts_used {
+	DTS_USE_TOP		= 0,
+	DTS_USE_CHAIN_A		= 1,
+	DTS_USE_CHAIN_B		= 2,
+	DTS_USE_CHAIN_C		= 3,
+	XTAL_TEMPERATURE	= 4,
+};
+
+/**
+* enum iwl_dts_bit_mode - bit-mode to use in DTS request read mode
+* @DTS_BIT6_MODE: bit 6 mode
+* @DTS_BIT8_MODE: bit 8 mode
+*/
+enum iwl_dts_bit_mode {
+	DTS_BIT6_MODE	= 0,
+	DTS_BIT8_MODE	= 1,
+};
+
+/**
+ * iwl_ext_dts_measurement_cmd - request extended DTS temperature measurements
+ * @control_mode: see &enum iwl_dts_control_measurement_mode
+ * @temperature: used when over write DTS mode is selected
+ * @sensor: set temperature sensor to use. See &enum iwl_dts_used
+ * @avg_factor: average factor to DTS in request DTS read mode
+ * @bit_mode: value defines the DTS bit mode to use. See &enum iwl_dts_bit_mode
+ * @step_duration: step duration for the DTS
+ */
+struct iwl_ext_dts_measurement_cmd {
+	__le32 control_mode;
+	__le32 temperature;
+	__le32 sensor;
+	__le32 avg_factor;
+	__le32 bit_mode;
+	__le32 step_duration;
+} __packed; /* XVT_FW_DTS_CONTROL_MEASUREMENT_REQUEST_API_S */
+
+/**
  * iwl_dts_measurement_notif - notification received with the measurements
  *
  * @temp: the measured temperature
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 58b762f..cadfc04 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -176,6 +176,9 @@ static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
 	struct iwl_dts_measurement_cmd cmd = {
 		.flags = cpu_to_le32(DTS_TRIGGER_CMD_FLAGS_TEMP),
 	};
+	struct iwl_ext_dts_measurement_cmd extcmd = {
+		.control_mode = cpu_to_le32(DTS_AUTOMATIC),
+	};
 	u32 cmdid;
 
 	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_WIDE_CMD_HDR))
@@ -183,8 +186,12 @@ static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
 				   PHY_OPS_GROUP, 0);
 	else
 		cmdid = CMD_DTS_MEASUREMENT_TRIGGER;
-	return iwl_mvm_send_cmd_pdu(mvm, cmdid, 0,
-				    sizeof(cmd), &cmd);
+
+	if (!fw_has_capa(&mvm->fw->ucode_capa,
+			 IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE))
+		return iwl_mvm_send_cmd_pdu(mvm, cmdid, 0, sizeof(cmd), &cmd);
+
+	return iwl_mvm_send_cmd_pdu(mvm, cmdid, 0, sizeof(extcmd), &extcmd);
 }
 
 int iwl_mvm_get_temp(struct iwl_mvm *mvm)
-- 
2.1.4

