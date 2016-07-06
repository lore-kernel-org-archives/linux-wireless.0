Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33180 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753242AbcGFKlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:41:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:39:57 +0300
Message-Id: <1467801651-1816-2-git-send-email-luca@coelho.fi> (sfid-20160706_124126_650504_67D9AC45)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 02/56] iwlwifi: change fw.mvm_fw to fw.type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of explicitly indicating the difference between just
DVM and MVM with an mvm_fw boolean change this to fw.type to
be more extensible and easier to understand.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 26 ++++++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h  | 14 ++++++++++++--
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 26afa72..e2df544 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -795,17 +795,17 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		 case IWL_UCODE_TLV_SEC_RT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_REGULAR,
 					    tlv_len);
-			drv->fw.mvm_fw = true;
+			drv->fw.type = IWL_FW_MVM;
 			break;
 		case IWL_UCODE_TLV_SEC_INIT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_INIT,
 					    tlv_len);
-			drv->fw.mvm_fw = true;
+			drv->fw.type = IWL_FW_MVM;
 			break;
 		case IWL_UCODE_TLV_SEC_WOWLAN:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_WOWLAN,
 					    tlv_len);
-			drv->fw.mvm_fw = true;
+			drv->fw.type = IWL_FW_MVM;
 			break;
 		case IWL_UCODE_TLV_DEF_CALIB:
 			if (tlv_len != sizeof(struct iwl_tlv_calib_data))
@@ -827,17 +827,17 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		 case IWL_UCODE_TLV_SECURE_SEC_RT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_REGULAR,
 					    tlv_len);
-			drv->fw.mvm_fw = true;
+			drv->fw.type = IWL_FW_MVM;
 			break;
 		case IWL_UCODE_TLV_SECURE_SEC_INIT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_INIT,
 					    tlv_len);
-			drv->fw.mvm_fw = true;
+			drv->fw.type = IWL_FW_MVM;
 			break;
 		case IWL_UCODE_TLV_SECURE_SEC_WOWLAN:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_WOWLAN,
 					    tlv_len);
-			drv->fw.mvm_fw = true;
+			drv->fw.type = IWL_FW_MVM;
 			break;
 		case IWL_UCODE_TLV_NUM_OF_CPU:
 			if (tlv_len != sizeof(u32))
@@ -1272,7 +1272,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * In mvm uCode there is no difference between data and instructions
 	 * sections.
 	 */
-	if (!fw->mvm_fw && validate_sec_sizes(drv, pieces, drv->cfg))
+	if (fw->type == IWL_FW_DVM && validate_sec_sizes(drv, pieces, drv->cfg))
 		goto try_again;
 
 	/* Allocate ucode buffers for card's bus-master loading ... */
@@ -1400,10 +1400,16 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 
 	mutex_lock(&iwlwifi_opmode_table_mtx);
-	if (fw->mvm_fw)
-		op = &iwlwifi_opmode_table[MVM_OP_MODE];
-	else
+	switch (fw->type) {
+	case IWL_FW_DVM:
 		op = &iwlwifi_opmode_table[DVM_OP_MODE];
+		break;
+	default:
+		WARN(1, "Invalid fw type %d\n", fw->type);
+	case IWL_FW_MVM:
+		op = &iwlwifi_opmode_table[MVM_OP_MODE];
+		break;
+	}
 
 	IWL_INFO(drv, "loaded firmware version %s op_mode %s\n",
 		 drv->fw.fw_version, op->name);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
index e461d63..655ec52 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
@@ -231,6 +231,16 @@ struct iwl_gscan_capabilities {
 };
 
 /**
+ * enum iwl_fw_type - iwlwifi firmware type
+ * @IWL_FW_DVM: DVM firmware
+ * @IWL_FW_MVM: MVM firmware
+ */
+enum iwl_fw_type {
+	IWL_FW_DVM,
+	IWL_FW_MVM,
+};
+
+/**
  * struct iwl_fw - variables associated with the firmware
  *
  * @ucode_ver: ucode version from the ucode file
@@ -244,7 +254,7 @@ struct iwl_gscan_capabilities {
  * @inst_evtlog_ptr: event log offset for runtime ucode.
  * @inst_evtlog_size: event log size for runtime ucode.
  * @inst_errlog_ptr: error log offfset for runtime ucode.
- * @mvm_fw: indicates this is MVM firmware
+ * @type: firmware type (&enum iwl_fw_type)
  * @cipher_scheme: optional external cipher scheme.
  * @human_readable: human readable version
  * @sdio_adma_addr: the default address to set for the ADMA in SDIO mode until
@@ -275,7 +285,7 @@ struct iwl_fw {
 	u8 valid_tx_ant;
 	u8 valid_rx_ant;
 
-	bool mvm_fw;
+	enum iwl_fw_type type;
 
 	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
 	u8 human_readable[FW_VER_HUMAN_READABLE_SZ];
-- 
2.8.1

