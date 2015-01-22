Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbbAVUeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:25 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/38] iwlwifi: mvm: add support for new LTR command
Date: Thu, 22 Jan 2015 22:33:16 +0200
Message-Id: <1421958809-3371-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214446_456852_82A05B25)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new command will give finer granularity to configure
the platform.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 20 ++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw.c           | 38 +++++++++++++++++++------
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 4aa26b2..b998aaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -241,6 +241,7 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
+ * IWL_UCODE_TLV_API_HDC_PHASE_0: ucode supports finer configuration of LTR
  * @IWL_UCODE_TLV_API_BASIC_DWELL: use only basic dwell time in scan command,
  *	regardless of the band or the number of the probes. FW will calculate
  *	the actual dwell time.
@@ -255,6 +256,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_LMAC_SCAN		= BIT(6),
 	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
+	IWL_UCODE_TLV_API_HDC_PHASE_0		= BIT(10),
 	IWL_UCODE_TLV_API_BASIC_DWELL		= BIT(13),
 	IWL_UCODE_TLV_API_SCD_CFG		= BIT(15),
 	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= BIT(16),
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 4300200..4fc0938b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -92,14 +92,32 @@ enum iwl_ltr_config_flags {
 };
 
 /**
+ * struct iwl_ltr_config_cmd_v1 - configures the LTR
+ * @flags: See %enum iwl_ltr_config_flags
+ */
+struct iwl_ltr_config_cmd_v1 {
+	__le32 flags;
+	__le32 static_long;
+	__le32 static_short;
+} __packed; /* LTR_CAPABLE_API_S_VER_1 */
+
+#define LTR_VALID_STATES_NUM 4
+
+/**
  * struct iwl_ltr_config_cmd - configures the LTR
  * @flags: See %enum iwl_ltr_config_flags
+ * @static_long:
+ * @static_short:
+ * @ltr_cfg_values:
+ * @ltr_short_idle_timeout:
  */
 struct iwl_ltr_config_cmd {
 	__le32 flags;
 	__le32 static_long;
 	__le32 static_short;
-} __packed;
+	__le32 ltr_cfg_values[LTR_VALID_STATES_NUM];
+	__le32 ltr_short_idle_timeout;
+} __packed; /* LTR_CAPABLE_API_S_VER_2 */
 
 /* Radio LP RX Energy Threshold measured in dBm */
 #define POWER_LPRX_RSSI_THRESHOLD	75
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 2e12f41..a322a5e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -499,6 +499,35 @@ int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, enum iwl_fw_dbg_conf conf_id)
 	return ret;
 }
 
+static int iwl_mvm_config_ltr_v1(struct iwl_mvm *mvm)
+{
+	struct iwl_ltr_config_cmd_v1 cmd_v1 = {
+		.flags = cpu_to_le32(LTR_CFG_FLAG_FEATURE_ENABLE),
+	};
+
+	if (!mvm->trans->ltr_enabled)
+		return 0;
+
+	return iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, 0,
+				    sizeof(cmd_v1), &cmd_v1);
+}
+
+static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
+{
+	struct iwl_ltr_config_cmd cmd = {
+		.flags = cpu_to_le32(LTR_CFG_FLAG_FEATURE_ENABLE),
+	};
+
+	if (!mvm->trans->ltr_enabled)
+		return 0;
+
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_HDC_PHASE_0))
+		return iwl_mvm_config_ltr_v1(mvm);
+
+	return iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, 0,
+				    sizeof(cmd), &cmd);
+}
+
 int iwl_mvm_up(struct iwl_mvm *mvm)
 {
 	int ret, i;
@@ -604,14 +633,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	/* Initialize tx backoffs to the minimal possible */
 	iwl_mvm_tt_tx_backoff(mvm, 0);
 
-	if (mvm->trans->ltr_enabled) {
-		struct iwl_ltr_config_cmd cmd = {
-			.flags = cpu_to_le32(LTR_CFG_FLAG_FEATURE_ENABLE),
-		};
-
-		WARN_ON(iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, 0,
-					     sizeof(cmd), &cmd));
-	}
+	WARN_ON(iwl_mvm_config_ltr(mvm));
 
 	ret = iwl_mvm_power_update_device(mvm);
 	if (ret)
-- 
1.9.1

