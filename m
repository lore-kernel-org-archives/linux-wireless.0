Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab2CJU73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/10] iwlwifi: Add TLVs and fields for 16.0 uCode
Date: Sat, 10 Mar 2012 13:00:13 -0800
Message-Id: <1331413215-10027-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_220009_358283_C21CD8E0)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

New TLVs for ucode sections that are not known as
instruction or data.

New TLVs for phy-configuration and default calibrations.

Add default calib and phy config fields to iwl_fw.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c     |   84 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |    5 ++
 drivers/net/wireless/iwlwifi/iwl-fw.h      |   19 ++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h  |   16 -----
 4 files changed, 108 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index a21af3d..19ccd36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -208,6 +208,25 @@ struct fw_img_parsing {
 	int sec_counter;
 };
 
+/*
+ * struct fw_sec_parsing: to extract fw section and it's offset from tlv
+ */
+struct fw_sec_parsing {
+	__le32 offset;
+	const u8 data[];
+} __packed;
+
+/**
+ * struct iwl_tlv_calib_data - parse the default calib data from TLV
+ *
+ * @ucode_type: the uCode to which the following default calib relates.
+ * @calib: default calibrations.
+ */
+struct iwl_tlv_calib_data {
+	__le32 ucode_type;
+	__le64 calib;
+} __packed;
+
 struct iwl_firmware_pieces {
 	struct fw_img_parsing img[IWL_UCODE_TYPE_MAX];
 
@@ -257,6 +276,47 @@ static void set_sec_offset(struct iwl_firmware_pieces *pieces,
 	pieces->img[type].sec[sec].offset = offset;
 }
 
+/*
+ * Gets uCode section from tlv.
+ */
+static int iwl_store_ucode_sec(struct iwl_firmware_pieces *pieces,
+			       const void *data, enum iwl_ucode_type type,
+			       int size)
+{
+	struct fw_img_parsing *img;
+	struct fw_sec *sec;
+	struct fw_sec_parsing *sec_parse;
+
+	if (WARN_ON(!pieces || !data || type >= IWL_UCODE_TYPE_MAX))
+		return -1;
+
+	sec_parse = (struct fw_sec_parsing *)data;
+
+	img = &pieces->img[type];
+	sec = &img->sec[img->sec_counter];
+
+	sec->offset = le32_to_cpu(sec_parse->offset);
+	sec->data = sec_parse->data;
+
+	++img->sec_counter;
+
+	return 0;
+}
+
+static int iwl_set_default_calib(struct iwl_drv *drv, const u8 *data)
+{
+	struct iwl_tlv_calib_data *def_calib =
+					(struct iwl_tlv_calib_data *)data;
+	u32 ucode_type = le32_to_cpu(def_calib->ucode_type);
+	if (ucode_type >= IWL_UCODE_TYPE_MAX) {
+		IWL_ERR(drv, "Wrong ucode_type %u for default calibration.\n",
+			ucode_type);
+		return -EINVAL;
+	}
+	drv->fw.default_calib[ucode_type] = le64_to_cpu(def_calib->calib);
+	return 0;
+}
+
 static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 				    const struct firmware *ucode_raw,
 				    struct iwl_firmware_pieces *pieces)
@@ -586,6 +646,29 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			capa->standard_phy_calibration_size =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
+		 case IWL_UCODE_TLV_SEC_RT:
+			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_REGULAR,
+					    tlv_len);
+			break;
+		case IWL_UCODE_TLV_SEC_INIT:
+			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_INIT,
+					    tlv_len);
+			break;
+		case IWL_UCODE_TLV_SEC_WOWLAN:
+			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_WOWLAN,
+					    tlv_len);
+			break;
+		case IWL_UCODE_TLV_DEF_CALIB:
+			if (tlv_len != sizeof(struct iwl_tlv_calib_data))
+				goto invalid_tlv_len;
+			if (iwl_set_default_calib(drv, tlv_data))
+				goto tlv_error;
+			break;
+		case IWL_UCODE_TLV_PHY_SKU:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			drv->fw.phy_config = le32_to_cpup((__le32 *)tlv_data);
+			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
@@ -602,6 +685,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 
  invalid_tlv_len:
 	IWL_ERR(drv, "TLV %d has invalid size: %u\n", tlv_type, tlv_len);
+ tlv_error:
 	iwl_print_hex_dump(drv, IWL_DL_FW, tlv_data, tlv_len);
 
 	return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 7ca6c95..c924ccb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -124,6 +124,11 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_WOWLAN_INST	= 16,
 	IWL_UCODE_TLV_WOWLAN_DATA	= 17,
 	IWL_UCODE_TLV_FLAGS		= 18,
+	IWL_UCODE_TLV_SEC_RT		= 19,
+	IWL_UCODE_TLV_SEC_INIT		= 20,
+	IWL_UCODE_TLV_SEC_WOWLAN	= 21,
+	IWL_UCODE_TLV_DEF_CALIB		= 22,
+	IWL_UCODE_TLV_PHY_SKU		= 23,
 };
 
 struct iwl_ucode_tlv {
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 253f7e5..c99a7fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -85,6 +85,22 @@ enum iwl_ucode_tlv_flag {
 #define IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE		19
 #define IWL_MAX_PHY_CALIBRATE_TBL_SIZE			253
 
+/**
+ * enum iwl_ucode_type
+ *
+ * The type of ucode.
+ *
+ * @IWL_UCODE_REGULAR: Normal runtime ucode
+ * @IWL_UCODE_INIT: Initial ucode
+ * @IWL_UCODE_WOWLAN: Wake on Wireless enabled ucode
+ */
+enum iwl_ucode_type {
+	IWL_UCODE_REGULAR,
+	IWL_UCODE_INIT,
+	IWL_UCODE_WOWLAN,
+	IWL_UCODE_TYPE_MAX,
+};
+
 struct iwl_ucode_capabilities {
 	u32 max_probe_length;
 	u32 standard_phy_calibration_size;
@@ -142,6 +158,9 @@ struct iwl_fw {
 
 	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
 	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
+
+	u64 default_calib[IWL_UCODE_TYPE_MAX];
+	u32 phy_config;
 };
 
 #endif  /* __iwl_fw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index d899c5c..b515d65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -192,22 +192,6 @@ struct iwl_hw_params {
 	const struct iwl_sensitivity_ranges *sens;
 };
 
-/**
- * enum iwl_ucode_type
- *
- * The type of ucode.
- *
- * @IWL_UCODE_REGULAR: Normal runtime ucode
- * @IWL_UCODE_INIT: Initial ucode
- * @IWL_UCODE_WOWLAN: Wake on Wireless enabled ucode
- */
-enum iwl_ucode_type {
-	IWL_UCODE_REGULAR,
-	IWL_UCODE_INIT,
-	IWL_UCODE_WOWLAN,
-	IWL_UCODE_TYPE_MAX,
-};
-
 /*
  * LED mode
  *    IWL_LED_DEFAULT:  use device default
-- 
1.7.0.4

