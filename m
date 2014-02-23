Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56589 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBWT5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:37 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi5so2357470wib.14
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:36 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/17] iwlwifi: mvm: prepare infrastructure for more TLV flags
Date: Sun, 23 Feb 2014 21:57:07 +0200
Message-Id: <1393185428-8524-16-git-send-email-egrumbach@gmail.com> (sfid-20140223_211709_576277_A16ADB42)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

We use the TLV flags as a handshake between the firmware
and the driver. These flags allow the firmware to advertise
its capabilities and API version.
Since we are running short of bits, we add a new
infrastructure which is more scalable, yet backward
compatible.

We make now the difference between API changes and the
capabilities. Both can have an index which allows to scale
at will.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c     |   44 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |   17 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw.h      |    4 +++
 3 files changed, 65 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 662d993..d49e9b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -404,6 +404,38 @@ static int iwl_set_default_calib(struct iwl_drv *drv, const u8 *data)
 	return 0;
 }
 
+static int iwl_set_ucode_api_flags(struct iwl_drv *drv, const u8 *data,
+				   struct iwl_ucode_capabilities *capa)
+{
+	const struct iwl_ucode_api *ucode_api = (void *)data;
+	u32 api_index = le32_to_cpu(ucode_api->api_index);
+
+	if (api_index >= IWL_API_ARRAY_SIZE) {
+		IWL_ERR(drv, "api_index larger than supported by driver\n");
+		return -EINVAL;
+	}
+
+	capa->api[api_index] = le32_to_cpu(ucode_api->api_flags);
+
+	return 0;
+}
+
+static int iwl_set_ucode_capabilities(struct iwl_drv *drv, const u8 *data,
+				      struct iwl_ucode_capabilities *capa)
+{
+	const struct iwl_ucode_capa *ucode_capa = (void *)data;
+	u32 api_index = le32_to_cpu(ucode_capa->api_index);
+
+	if (api_index >= IWL_CAPABILITIES_ARRAY_SIZE) {
+		IWL_ERR(drv, "api_index larger than supported by driver\n");
+		return -EINVAL;
+	}
+
+	capa->capa[api_index] = le32_to_cpu(ucode_capa->api_capa);
+
+	return 0;
+}
+
 static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 				    const struct firmware *ucode_raw,
 				    struct iwl_firmware_pieces *pieces)
@@ -638,6 +670,18 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			 */
 			capa->flags = le32_to_cpup((__le32 *)tlv_data);
 			break;
+		case IWL_UCODE_TLV_API_CHANGES_SET:
+			if (tlv_len != sizeof(struct iwl_ucode_api))
+				goto invalid_tlv_len;
+			if (iwl_set_ucode_api_flags(drv, tlv_data, capa))
+				goto tlv_error;
+			break;
+		case IWL_UCODE_TLV_ENABLED_CAPABILITIES:
+			if (tlv_len != sizeof(struct iwl_ucode_capa))
+				goto invalid_tlv_len;
+			if (iwl_set_ucode_capabilities(drv, tlv_data, capa))
+				goto tlv_error;
+			break;
 		case IWL_UCODE_TLV_INIT_EVTLOG_PTR:
 			if (tlv_len != sizeof(u32))
 				goto invalid_tlv_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 88e2d6e..b45e576 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -126,6 +126,8 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_SECURE_SEC_WOWLAN	= 26,
 	IWL_UCODE_TLV_NUM_OF_CPU	= 27,
 	IWL_UCODE_TLV_CSCHEME		= 28,
+	IWL_UCODE_TLV_API_CHANGES_SET	= 29,
+	IWL_UCODE_TLV_ENABLED_CAPABILITIES	= 30,
 };
 
 struct iwl_ucode_tlv {
@@ -158,4 +160,19 @@ struct iwl_tlv_ucode_header {
 	u8 data[0];
 };
 
+/*
+ * ucode TLVs
+ *
+ * ability to get extension for: flags & capabilities from ucode binaries files
+ */
+struct iwl_ucode_api {
+	__le32 api_index;
+	__le32 api_flags;
+} __packed;
+
+struct iwl_ucode_capa {
+	__le32 api_index;
+	__le32 api_capa;
+} __packed;
+
 #endif  /* __iwl_fw_file_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index af6b452..f04ff87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -165,11 +165,15 @@ enum iwl_ucode_sec {
  * just an offset to the HW address.
  */
 #define IWL_UCODE_SECTION_MAX 12
+#define IWL_API_ARRAY_SIZE	1
+#define IWL_CAPABILITIES_ARRAY_SIZE	1
 
 struct iwl_ucode_capabilities {
 	u32 max_probe_length;
 	u32 standard_phy_calibration_size;
 	u32 flags;
+	u32 api[IWL_API_ARRAY_SIZE];
+	u32 capa[IWL_CAPABILITIES_ARRAY_SIZE];
 };
 
 /* one for each uCode image (inst/data, init/runtime/wowlan) */
-- 
1.7.9.5

