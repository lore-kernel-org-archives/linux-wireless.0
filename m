Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab2BQUX4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:56 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/26] iwlwifi: changes args to iwl_nic for firmware operations
Date: Fri, 17 Feb 2012 11:13:50 -0800
Message-Id: <1329506034-1394-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212411_536708_7680EC07)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Remove the references to iwl_priv from the firmware request and
parsing routines.  They are generic to the nic.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c |  149 +++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-ucode.h |    4 -
 drivers/net/wireless/iwlwifi/iwl-wifi.h  |    1 +
 4 files changed, 77 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 68b9e5e..e8fed16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1262,7 +1262,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 
 	init_completion(&nic(priv)->request_firmware_complete);
 
-	err = iwl_request_firmware(priv, true);
+	err = iwl_request_firmware(nic(priv), true);
 	if (err)
 		goto out_destroy_workqueue;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 0d04a4d..01768f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -690,10 +690,10 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
 #define UCODE_EXPERIMENTAL_INDEX	100
 #define UCODE_EXPERIMENTAL_TAG		"exp"
 
-int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
+int __must_check iwl_request_firmware(struct iwl_nic *nic, bool first)
 {
-	struct iwl_nic *nic = nic(priv);
-	const char *name_pre = cfg(priv)->fw_name_pre;
+	struct iwl_cfg *cfg = cfg(nic);
+	const char *name_pre = cfg->fw_name_pre;
 	char tag[8];
 
 	if (first) {
@@ -702,28 +702,28 @@ int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
 	} else if (nic->fw_index == UCODE_EXPERIMENTAL_INDEX) {
 #endif
-		nic->fw_index = cfg(priv)->ucode_api_max;
+		nic->fw_index = cfg->ucode_api_max;
 		sprintf(tag, "%d", nic->fw_index);
 	} else {
 		nic->fw_index--;
 		sprintf(tag, "%d", nic->fw_index);
 	}
 
-	if (nic->fw_index < cfg(priv)->ucode_api_min) {
-		IWL_ERR(priv, "no suitable firmware found!\n");
+	if (nic->fw_index < cfg->ucode_api_min) {
+		IWL_ERR(nic, "no suitable firmware found!\n");
 		return -ENOENT;
 	}
 
 	sprintf(nic->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
 
-	IWL_DEBUG_INFO(priv, "attempting to load firmware %s'%s'\n",
+	IWL_DEBUG_INFO(nic, "attempting to load firmware %s'%s'\n",
 		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
 				? "EXPERIMENTAL " : "",
 		       nic->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, nic->firmware_name,
-				       trans(priv)->dev,
-				       GFP_KERNEL, priv, iwl_ucode_callback);
+				       trans(nic)->dev,
+				       GFP_KERNEL, nic, iwl_ucode_callback);
 }
 
 struct iwlagn_firmware_pieces {
@@ -737,11 +737,10 @@ struct iwlagn_firmware_pieces {
 	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 };
 
-static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
+static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 				       const struct firmware *ucode_raw,
 				       struct iwlagn_firmware_pieces *pieces)
 {
-	struct iwl_nic *nic = nic(priv);
 	struct iwl_ucode_header *ucode = (void *)ucode_raw->data;
 	u32 api_ver, hdr_size;
 	const u8 *src;
@@ -753,7 +752,7 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 	default:
 		hdr_size = 28;
 		if (ucode_raw->size < hdr_size) {
-			IWL_ERR(priv, "File size too small!\n");
+			IWL_ERR(nic, "File size too small!\n");
 			return -EINVAL;
 		}
 		pieces->build = le32_to_cpu(ucode->u.v2.build);
@@ -768,7 +767,7 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 	case 2:
 		hdr_size = 24;
 		if (ucode_raw->size < hdr_size) {
-			IWL_ERR(priv, "File size too small!\n");
+			IWL_ERR(nic, "File size too small!\n");
 			return -EINVAL;
 		}
 		pieces->build = 0;
@@ -785,7 +784,7 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 				pieces->data_size + pieces->init_size +
 				pieces->init_data_size) {
 
-		IWL_ERR(priv,
+		IWL_ERR(nic,
 			"uCode file size %d does not match expected size\n",
 			(int)ucode_raw->size);
 		return -EINVAL;
@@ -803,12 +802,11 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 	return 0;
 }
 
-static int iwlagn_load_firmware(struct iwl_priv *priv,
+static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 				const struct firmware *ucode_raw,
 				struct iwlagn_firmware_pieces *pieces,
 				struct iwlagn_ucode_capabilities *capa)
 {
-	struct iwl_nic *nic = nic(priv);
 	struct iwl_tlv_ucode_header *ucode = (void *)ucode_raw->data;
 	struct iwl_ucode_tlv *tlv;
 	size_t len = ucode_raw->size;
@@ -821,12 +819,12 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 	const u8 *tlv_data;
 
 	if (len < sizeof(*ucode)) {
-		IWL_ERR(priv, "uCode has invalid length: %zd\n", len);
+		IWL_ERR(nic, "uCode has invalid length: %zd\n", len);
 		return -EINVAL;
 	}
 
 	if (ucode->magic != cpu_to_le32(IWL_TLV_UCODE_MAGIC)) {
-		IWL_ERR(priv, "invalid uCode magic: 0X%x\n",
+		IWL_ERR(nic, "invalid uCode magic: 0X%x\n",
 			le32_to_cpu(ucode->magic));
 		return -EINVAL;
 	}
@@ -844,7 +842,7 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 	while (wanted_alternative && !(alternatives & BIT(wanted_alternative)))
 		wanted_alternative--;
 	if (wanted_alternative && wanted_alternative != tmp)
-		IWL_WARN(priv,
+		IWL_WARN(nic,
 			 "uCode alternative %d not available, choosing %d\n",
 			 tmp, wanted_alternative);
 
@@ -866,7 +864,7 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 		tlv_data = tlv->data;
 
 		if (len < tlv_len) {
-			IWL_ERR(priv, "invalid TLV len: %zd/%u\n",
+			IWL_ERR(nic, "invalid TLV len: %zd/%u\n",
 				len, tlv_len);
 			return -EINVAL;
 		}
@@ -899,7 +897,7 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 			pieces->init_data_size = tlv_len;
 			break;
 		case IWL_UCODE_TLV_BOOT:
-			IWL_ERR(priv, "Found unexpected BOOT ucode\n");
+			IWL_ERR(nic, "Found unexpected BOOT ucode\n");
 			break;
 		case IWL_UCODE_TLV_PROBE_MAX_LEN:
 			if (tlv_len != sizeof(u32))
@@ -984,22 +982,22 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		default:
-			IWL_DEBUG_INFO(priv, "unknown TLV: %d\n", tlv_type);
+			IWL_DEBUG_INFO(nic, "unknown TLV: %d\n", tlv_type);
 			break;
 		}
 	}
 
 	if (len) {
-		IWL_ERR(priv, "invalid TLV after parsing: %zd\n", len);
-		iwl_print_hex_dump(priv, IWL_DL_FW, (u8 *)data, len);
+		IWL_ERR(nic, "invalid TLV after parsing: %zd\n", len);
+		iwl_print_hex_dump(nic, IWL_DL_FW, (u8 *)data, len);
 		return -EINVAL;
 	}
 
 	return 0;
 
  invalid_tlv_len:
-	IWL_ERR(priv, "TLV %d has invalid size: %u\n", tlv_type, tlv_len);
-	iwl_print_hex_dump(priv, IWL_DL_FW, tlv_data, tlv_len);
+	IWL_ERR(nic, "TLV %d has invalid size: %u\n", tlv_type, tlv_len);
+	iwl_print_hex_dump(nic, IWL_DL_FW, tlv_data, tlv_len);
 
 	return -EINVAL;
 }
@@ -1012,14 +1010,15 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
  */
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 {
-	struct iwl_priv *priv = context;
-	struct iwl_nic *nic = nic(priv);
+	struct iwl_nic *nic = context;
+	struct iwl_cfg *cfg = cfg(nic);
+	struct iwl_priv *priv = priv(nic); /* temporary */
 	struct iwl_ucode_header *ucode;
 	int err;
 	struct iwlagn_firmware_pieces pieces;
-	const unsigned int api_max = cfg(priv)->ucode_api_max;
-	unsigned int api_ok = cfg(priv)->ucode_api_ok;
-	const unsigned int api_min = cfg(priv)->ucode_api_min;
+	const unsigned int api_max = cfg->ucode_api_max;
+	unsigned int api_ok = cfg->ucode_api_ok;
+	const unsigned int api_min = cfg->ucode_api_min;
 	u32 api_ver;
 	char buildstr[25];
 	u32 build;
@@ -1036,18 +1035,18 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	if (!ucode_raw) {
 		if (nic->fw_index <= api_ok)
-			IWL_ERR(priv,
+			IWL_ERR(nic,
 				"request for firmware file '%s' failed.\n",
 				nic->firmware_name);
 		goto try_again;
 	}
 
-	IWL_DEBUG_INFO(priv, "Loaded firmware file '%s' (%zd bytes).\n",
+	IWL_DEBUG_INFO(nic, "Loaded firmware file '%s' (%zd bytes).\n",
 		       nic->firmware_name, ucode_raw->size);
 
 	/* Make sure that we got at least the API version number */
 	if (ucode_raw->size < 4) {
-		IWL_ERR(priv, "File size way too small!\n");
+		IWL_ERR(nic, "File size way too small!\n");
 		goto try_again;
 	}
 
@@ -1055,9 +1054,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	ucode = (struct iwl_ucode_header *)ucode_raw->data;
 
 	if (ucode->ver)
-		err = iwlagn_load_legacy_firmware(priv, ucode_raw, &pieces);
+		err = iwl_parse_v1_v2_firmware(nic, ucode_raw, &pieces);
 	else
-		err = iwlagn_load_firmware(priv, ucode_raw, &pieces,
+		err = iwl_parse_tlv_firmware(nic, ucode_raw, &pieces,
 					   &ucode_capa);
 
 	if (err)
@@ -1074,7 +1073,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* no api version check required for experimental uCode */
 	if (nic->fw_index != UCODE_EXPERIMENTAL_INDEX) {
 		if (api_ver < api_min || api_ver > api_max) {
-			IWL_ERR(priv,
+			IWL_ERR(nic,
 				"Driver unable to support your firmware API. "
 				"Driver supports v%u, firmware is v%u.\n",
 				api_max, api_ver);
@@ -1083,14 +1082,14 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 		if (api_ver < api_ok) {
 			if (api_ok != api_max)
-				IWL_ERR(priv, "Firmware has old API version, "
+				IWL_ERR(nic, "Firmware has old API version, "
 					"expected v%u through v%u, got v%u.\n",
 					api_ok, api_max, api_ver);
 			else
-				IWL_ERR(priv, "Firmware has old API version, "
+				IWL_ERR(nic, "Firmware has old API version, "
 					"expected v%u, got v%u.\n",
 					api_max, api_ver);
-			IWL_ERR(priv, "New firmware can be obtained from "
+			IWL_ERR(nic, "New firmware can be obtained from "
 				      "http://www.intellinuxwireless.org/.\n");
 		}
 	}
@@ -1102,7 +1101,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	else
 		buildstr[0] = '\0';
 
-	IWL_INFO(priv, "loaded firmware version %u.%u.%u.%u%s\n",
+	IWL_INFO(nic, "loaded firmware version %u.%u.%u.%u%s\n",
 		 IWL_UCODE_MAJOR(nic->fw.ucode_ver),
 		 IWL_UCODE_MINOR(nic->fw.ucode_ver),
 		 IWL_UCODE_API(nic->fw.ucode_ver),
@@ -1124,38 +1123,38 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * user just got a corrupted version of the latest API.
 	 */
 
-	IWL_DEBUG_INFO(priv, "f/w package hdr ucode version raw = 0x%x\n",
+	IWL_DEBUG_INFO(nic, "f/w package hdr ucode version raw = 0x%x\n",
 		       nic->fw.ucode_ver);
-	IWL_DEBUG_INFO(priv, "f/w package hdr runtime inst size = %Zd\n",
+	IWL_DEBUG_INFO(nic, "f/w package hdr runtime inst size = %Zd\n",
 		       pieces.inst_size);
-	IWL_DEBUG_INFO(priv, "f/w package hdr runtime data size = %Zd\n",
+	IWL_DEBUG_INFO(nic, "f/w package hdr runtime data size = %Zd\n",
 		       pieces.data_size);
-	IWL_DEBUG_INFO(priv, "f/w package hdr init inst size = %Zd\n",
+	IWL_DEBUG_INFO(nic, "f/w package hdr init inst size = %Zd\n",
 		       pieces.init_size);
-	IWL_DEBUG_INFO(priv, "f/w package hdr init data size = %Zd\n",
+	IWL_DEBUG_INFO(nic, "f/w package hdr init data size = %Zd\n",
 		       pieces.init_data_size);
 
 	/* Verify that uCode images will fit in card's SRAM */
-	if (pieces.inst_size > hw_params(priv).max_inst_size) {
-		IWL_ERR(priv, "uCode instr len %Zd too large to fit in\n",
+	if (pieces.inst_size > hw_params(nic).max_inst_size) {
+		IWL_ERR(nic, "uCode instr len %Zd too large to fit in\n",
 			pieces.inst_size);
 		goto try_again;
 	}
 
-	if (pieces.data_size > hw_params(priv).max_data_size) {
-		IWL_ERR(priv, "uCode data len %Zd too large to fit in\n",
+	if (pieces.data_size > hw_params(nic).max_data_size) {
+		IWL_ERR(nic, "uCode data len %Zd too large to fit in\n",
 			pieces.data_size);
 		goto try_again;
 	}
 
-	if (pieces.init_size > hw_params(priv).max_inst_size) {
-		IWL_ERR(priv, "uCode init instr len %Zd too large to fit in\n",
+	if (pieces.init_size > hw_params(nic).max_inst_size) {
+		IWL_ERR(nic, "uCode init instr len %Zd too large to fit in\n",
 			pieces.init_size);
 		goto try_again;
 	}
 
-	if (pieces.init_data_size > hw_params(priv).max_data_size) {
-		IWL_ERR(priv, "uCode init data len %Zd too large to fit in\n",
+	if (pieces.init_data_size > hw_params(nic).max_data_size) {
+		IWL_ERR(nic, "uCode init data len %Zd too large to fit in\n",
 			pieces.init_data_size);
 		goto try_again;
 	}
@@ -1165,34 +1164,34 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
-	if (iwl_alloc_fw_desc(nic(priv), &nic(priv)->fw.ucode_rt.code,
+	if (iwl_alloc_fw_desc(nic, &nic->fw.ucode_rt.code,
 			      pieces.inst, pieces.inst_size))
 		goto err_pci_alloc;
-	if (iwl_alloc_fw_desc(nic(priv), &nic(priv)->fw.ucode_rt.data,
+	if (iwl_alloc_fw_desc(nic, &nic->fw.ucode_rt.data,
 			      pieces.data, pieces.data_size))
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
 	if (pieces.init_size && pieces.init_data_size) {
-		if (iwl_alloc_fw_desc(nic(priv),
-				      &nic(priv)->fw.ucode_init.code,
+		if (iwl_alloc_fw_desc(nic,
+				      &nic->fw.ucode_init.code,
 				      pieces.init, pieces.init_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(nic(priv),
-				      &nic(priv)->fw.ucode_init.data,
+		if (iwl_alloc_fw_desc(nic,
+				      &nic->fw.ucode_init.data,
 				      pieces.init_data, pieces.init_data_size))
 			goto err_pci_alloc;
 	}
 
 	/* WoWLAN instructions and data */
 	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
-		if (iwl_alloc_fw_desc(nic(priv),
-				      &nic(priv)->fw.ucode_wowlan.code,
+		if (iwl_alloc_fw_desc(nic,
+				      &nic->fw.ucode_wowlan.code,
 				      pieces.wowlan_inst,
 				      pieces.wowlan_inst_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(nic(priv),
-				      &nic(priv)->fw.ucode_wowlan.data,
+		if (iwl_alloc_fw_desc(nic,
+				      &nic->fw.ucode_wowlan.data,
 				      pieces.wowlan_data,
 				      pieces.wowlan_data_size))
 			goto err_pci_alloc;
@@ -1210,14 +1209,14 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		nic->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
 	else
 		nic->init_evtlog_size =
-			cfg(priv)->base_params->max_event_log_size;
+			cfg->base_params->max_event_log_size;
 	nic->init_errlog_ptr = pieces.init_errlog_ptr;
 	nic->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
 	if (pieces.inst_evtlog_size)
 		nic->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
 	else
 		nic->inst_evtlog_size =
-			cfg(priv)->base_params->max_event_log_size;
+			cfg->base_params->max_event_log_size;
 	nic->inst_errlog_ptr = pieces.inst_errlog_ptr;
 #ifndef CONFIG_IWLWIFI_P2P
 	ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
@@ -1226,7 +1225,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	priv->new_scan_threshold_behaviour =
 		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
 
-	if (!(cfg(priv)->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
+	if (!(cfg->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
 		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 
 	/*
@@ -1238,10 +1237,10 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
-		priv->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
+		nic->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
 	} else {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
-		priv->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+		nic->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 	}
 	/*
 	 * figure out the offset of chain noise reset and gain commands
@@ -1271,7 +1270,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	err = iwl_dbgfs_register(priv, DRV_NAME);
 	if (err)
-		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
+		IWL_ERR(nic,
+			"failed to create debugfs files. Ignoring error: %d\n",
+			err);
 
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
@@ -1280,17 +1281,17 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
  try_again:
 	/* try next, if any */
-	if (iwl_request_firmware(priv, false))
+	if (iwl_request_firmware(nic, false))
 		goto out_unbind;
 	release_firmware(ucode_raw);
 	return;
 
  err_pci_alloc:
-	IWL_ERR(priv, "failed to allocate pci memory\n");
-	iwl_dealloc_ucode(nic(priv));
+	IWL_ERR(nic, "failed to allocate pci memory\n");
+	iwl_dealloc_ucode(nic);
  out_unbind:
 	complete(&nic->request_firmware_complete);
-	device_release_driver(trans(priv)->dev);
+	device_release_driver(trans(nic)->dev);
 	release_firmware(ucode_raw);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.h b/drivers/net/wireless/iwlwifi/iwl-ucode.h
index 5e4b88e..d13e624 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.h
@@ -218,8 +218,4 @@ struct iwl_fw {
 	bool enhance_sensitivity_table;
 };
 
-struct iwl_priv;
-
-int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first);
-
 #endif  /* __iwl_ucode_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
index 392f111..84172f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-wifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-wifi.h
@@ -95,6 +95,7 @@ struct iwl_nic {
 };
 
 
+int __must_check iwl_request_firmware(struct iwl_nic *nic, bool first);
 void iwl_dealloc_ucode(struct iwl_nic *nic);
 
 int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type);
-- 
1.7.0.4

