Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab2CDUnE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 036/101] iwlwifi: remove iwl-wifi.h
Date: Sun,  4 Mar 2012 11:28:50 -0800
Message-Id: <1330889395-533-37-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214620_174003_80888B55)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This file was recently introduced, but then
directly abused -- it contained private data
that shouldn't have been used by anything
but the implementation of firmware requests
and some very core code. Now that it is no
longer accessed by any code but the code in
iwl-drv.c, we can dissolve it.

Also rename the iwl_nic struct to iwl_drv to
better reflect where and how it is used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-drv.c           |  272 ++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c         |    1 -
 drivers/net/wireless/iwlwifi/iwl-wifi.h          |   88 -------
 12 files changed, 148 insertions(+), 223 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-wifi.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 4928f6f..588d107 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -68,7 +68,6 @@
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
 #include "iwl-agn.h"
-#include "iwl-wifi.h"
 
 /*****************************************************************************
  * INIT calibrations framework
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 89be056..b062832 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -32,7 +32,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 
-#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c3040ad..cdfe761 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -42,7 +42,6 @@
 #include <asm/div64.h>
 
 #include "iwl-eeprom.h"
-#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3c1b1e9..9a5ebec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -41,7 +41,6 @@
 #include "iwl-shared.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
-#include "iwl-wifi.h"
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 0e63cb7..bc3e267 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -40,7 +40,6 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
-#include "iwl-wifi.h"
 
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 351b2f9..f1beeab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -67,36 +67,58 @@
 
 #include "iwl-drv.h"
 #include "iwl-trans.h"
-#include "iwl-wifi.h"
 #include "iwl-shared.h"
 #include "iwl-op-mode.h"
 
 /* private includes */
 #include "iwl-ucode.h"
 
-static void iwl_free_fw_desc(struct iwl_nic *nic, struct fw_desc *desc)
+/**
+ * struct iwl_drv - drv common data
+ * @fw: the iwl_fw structure
+ * @shrd: pointer to common shared structure
+ * @op_mode: the running op_mode
+ * @fw_index: firmware revision to try loading
+ * @firmware_name: composite filename of ucode file to load
+ * @request_firmware_complete: the firmware has been obtained from user space
+ */
+struct iwl_drv {
+	struct iwl_fw fw;
+
+	struct iwl_shared *shrd;
+	struct iwl_op_mode *op_mode;
+
+	int fw_index;                   /* firmware we're trying to load */
+	char firmware_name[25];         /* name of firmware file to load */
+
+	struct completion request_firmware_complete;
+};
+
+
+
+static void iwl_free_fw_desc(struct iwl_drv *drv, struct fw_desc *desc)
 {
 	if (desc->v_addr)
-		dma_free_coherent(trans(nic)->dev, desc->len,
+		dma_free_coherent(trans(drv)->dev, desc->len,
 				  desc->v_addr, desc->p_addr);
 	desc->v_addr = NULL;
 	desc->len = 0;
 }
 
-static void iwl_free_fw_img(struct iwl_nic *nic, struct fw_img *img)
+static void iwl_free_fw_img(struct iwl_drv *drv, struct fw_img *img)
 {
-	iwl_free_fw_desc(nic, &img->code);
-	iwl_free_fw_desc(nic, &img->data);
+	iwl_free_fw_desc(drv, &img->code);
+	iwl_free_fw_desc(drv, &img->data);
 }
 
-static void iwl_dealloc_ucode(struct iwl_nic *nic)
+static void iwl_dealloc_ucode(struct iwl_drv *drv)
 {
-	iwl_free_fw_img(nic, &nic->fw.ucode_rt);
-	iwl_free_fw_img(nic, &nic->fw.ucode_init);
-	iwl_free_fw_img(nic, &nic->fw.ucode_wowlan);
+	iwl_free_fw_img(drv, &drv->fw.ucode_rt);
+	iwl_free_fw_img(drv, &drv->fw.ucode_init);
+	iwl_free_fw_img(drv, &drv->fw.ucode_wowlan);
 }
 
-static int iwl_alloc_fw_desc(struct iwl_nic *nic, struct fw_desc *desc,
+static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
 		      const void *data, size_t len)
 {
 	if (!len) {
@@ -104,7 +126,7 @@ static int iwl_alloc_fw_desc(struct iwl_nic *nic, struct fw_desc *desc,
 		return -EINVAL;
 	}
 
-	desc->v_addr = dma_alloc_coherent(trans(nic)->dev, len,
+	desc->v_addr = dma_alloc_coherent(trans(drv)->dev, len,
 					  &desc->p_addr, GFP_KERNEL);
 	if (!desc->v_addr)
 		return -ENOMEM;
@@ -119,40 +141,40 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
 #define UCODE_EXPERIMENTAL_INDEX	100
 #define UCODE_EXPERIMENTAL_TAG		"exp"
 
-static int iwl_request_firmware(struct iwl_nic *nic, bool first)
+static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 {
-	const struct iwl_cfg *cfg = cfg(nic);
+	const struct iwl_cfg *cfg = cfg(drv);
 	const char *name_pre = cfg->fw_name_pre;
 	char tag[8];
 
 	if (first) {
 #ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
-		nic->fw_index = UCODE_EXPERIMENTAL_INDEX;
+		drv->fw_index = UCODE_EXPERIMENTAL_INDEX;
 		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
-	} else if (nic->fw_index == UCODE_EXPERIMENTAL_INDEX) {
+	} else if (drv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
 #endif
-		nic->fw_index = cfg->ucode_api_max;
-		sprintf(tag, "%d", nic->fw_index);
+		drv->fw_index = cfg->ucode_api_max;
+		sprintf(tag, "%d", drv->fw_index);
 	} else {
-		nic->fw_index--;
-		sprintf(tag, "%d", nic->fw_index);
+		drv->fw_index--;
+		sprintf(tag, "%d", drv->fw_index);
 	}
 
-	if (nic->fw_index < cfg->ucode_api_min) {
-		IWL_ERR(nic, "no suitable firmware found!\n");
+	if (drv->fw_index < cfg->ucode_api_min) {
+		IWL_ERR(drv, "no suitable firmware found!\n");
 		return -ENOENT;
 	}
 
-	sprintf(nic->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
+	sprintf(drv->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
 
-	IWL_DEBUG_INFO(nic, "attempting to load firmware %s'%s'\n",
-		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
+	IWL_DEBUG_INFO(drv, "attempting to load firmware %s'%s'\n",
+		       (drv->fw_index == UCODE_EXPERIMENTAL_INDEX)
 				? "EXPERIMENTAL " : "",
-		       nic->firmware_name);
+		       drv->firmware_name);
 
-	return request_firmware_nowait(THIS_MODULE, 1, nic->firmware_name,
-				       trans(nic)->dev,
-				       GFP_KERNEL, nic, iwl_ucode_callback);
+	return request_firmware_nowait(THIS_MODULE, 1, drv->firmware_name,
+				       trans(drv)->dev,
+				       GFP_KERNEL, drv, iwl_ucode_callback);
 }
 
 struct iwlagn_firmware_pieces {
@@ -164,7 +186,7 @@ struct iwlagn_firmware_pieces {
 	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 };
 
-static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
+static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 				       const struct firmware *ucode_raw,
 				       struct iwlagn_firmware_pieces *pieces)
 {
@@ -173,14 +195,14 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 	char buildstr[25];
 	const u8 *src;
 
-	nic->fw.ucode_ver = le32_to_cpu(ucode->ver);
-	api_ver = IWL_UCODE_API(nic->fw.ucode_ver);
+	drv->fw.ucode_ver = le32_to_cpu(ucode->ver);
+	api_ver = IWL_UCODE_API(drv->fw.ucode_ver);
 
 	switch (api_ver) {
 	default:
 		hdr_size = 28;
 		if (ucode_raw->size < hdr_size) {
-			IWL_ERR(nic, "File size too small!\n");
+			IWL_ERR(drv, "File size too small!\n");
 			return -EINVAL;
 		}
 		build = le32_to_cpu(ucode->u.v2.build);
@@ -196,7 +218,7 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 	case 2:
 		hdr_size = 24;
 		if (ucode_raw->size < hdr_size) {
-			IWL_ERR(nic, "File size too small!\n");
+			IWL_ERR(drv, "File size too small!\n");
 			return -EINVAL;
 		}
 		build = 0;
@@ -211,18 +233,18 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 
 	if (build)
 		sprintf(buildstr, " build %u%s", build,
-		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
+		       (drv->fw_index == UCODE_EXPERIMENTAL_INDEX)
 				? " (EXP)" : "");
 	else
 		buildstr[0] = '\0';
 
-	snprintf(nic->fw.fw_version,
-		 sizeof(nic->fw.fw_version),
+	snprintf(drv->fw.fw_version,
+		 sizeof(drv->fw.fw_version),
 		 "%u.%u.%u.%u%s",
-		 IWL_UCODE_MAJOR(nic->fw.ucode_ver),
-		 IWL_UCODE_MINOR(nic->fw.ucode_ver),
-		 IWL_UCODE_API(nic->fw.ucode_ver),
-		 IWL_UCODE_SERIAL(nic->fw.ucode_ver),
+		 IWL_UCODE_MAJOR(drv->fw.ucode_ver),
+		 IWL_UCODE_MINOR(drv->fw.ucode_ver),
+		 IWL_UCODE_API(drv->fw.ucode_ver),
+		 IWL_UCODE_SERIAL(drv->fw.ucode_ver),
 		 buildstr);
 
 	/* Verify size of file vs. image size info in file's header */
@@ -230,7 +252,7 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 				pieces->data_size + pieces->init_size +
 				pieces->init_data_size) {
 
-		IWL_ERR(nic,
+		IWL_ERR(drv,
 			"uCode file size %d does not match expected size\n",
 			(int)ucode_raw->size);
 		return -EINVAL;
@@ -248,7 +270,7 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 	return 0;
 }
 
-static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
+static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				const struct firmware *ucode_raw,
 				struct iwlagn_firmware_pieces *pieces,
 				struct iwl_ucode_capabilities *capa)
@@ -267,12 +289,12 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 	u32 build;
 
 	if (len < sizeof(*ucode)) {
-		IWL_ERR(nic, "uCode has invalid length: %zd\n", len);
+		IWL_ERR(drv, "uCode has invalid length: %zd\n", len);
 		return -EINVAL;
 	}
 
 	if (ucode->magic != cpu_to_le32(IWL_TLV_UCODE_MAGIC)) {
-		IWL_ERR(nic, "invalid uCode magic: 0X%x\n",
+		IWL_ERR(drv, "invalid uCode magic: 0X%x\n",
 			le32_to_cpu(ucode->magic));
 		return -EINVAL;
 	}
@@ -290,27 +312,27 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 	while (wanted_alternative && !(alternatives & BIT(wanted_alternative)))
 		wanted_alternative--;
 	if (wanted_alternative && wanted_alternative != tmp)
-		IWL_WARN(nic,
+		IWL_WARN(drv,
 			 "uCode alternative %d not available, choosing %d\n",
 			 tmp, wanted_alternative);
 
-	nic->fw.ucode_ver = le32_to_cpu(ucode->ver);
+	drv->fw.ucode_ver = le32_to_cpu(ucode->ver);
 	build = le32_to_cpu(ucode->build);
 
 	if (build)
 		sprintf(buildstr, " build %u%s", build,
-		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
+		       (drv->fw_index == UCODE_EXPERIMENTAL_INDEX)
 				? " (EXP)" : "");
 	else
 		buildstr[0] = '\0';
 
-	snprintf(nic->fw.fw_version,
-		 sizeof(nic->fw.fw_version),
+	snprintf(drv->fw.fw_version,
+		 sizeof(drv->fw.fw_version),
 		 "%u.%u.%u.%u%s",
-		 IWL_UCODE_MAJOR(nic->fw.ucode_ver),
-		 IWL_UCODE_MINOR(nic->fw.ucode_ver),
-		 IWL_UCODE_API(nic->fw.ucode_ver),
-		 IWL_UCODE_SERIAL(nic->fw.ucode_ver),
+		 IWL_UCODE_MAJOR(drv->fw.ucode_ver),
+		 IWL_UCODE_MINOR(drv->fw.ucode_ver),
+		 IWL_UCODE_API(drv->fw.ucode_ver),
+		 IWL_UCODE_SERIAL(drv->fw.ucode_ver),
 		 buildstr);
 
 	data = ucode->data;
@@ -329,7 +351,7 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 		tlv_data = tlv->data;
 
 		if (len < tlv_len) {
-			IWL_ERR(nic, "invalid TLV len: %zd/%u\n",
+			IWL_ERR(drv, "invalid TLV len: %zd/%u\n",
 				len, tlv_len);
 			return -EINVAL;
 		}
@@ -362,7 +384,7 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 			pieces->init_data_size = tlv_len;
 			break;
 		case IWL_UCODE_TLV_BOOT:
-			IWL_ERR(nic, "Found unexpected BOOT ucode\n");
+			IWL_ERR(drv, "Found unexpected BOOT ucode\n");
 			break;
 		case IWL_UCODE_TLV_PROBE_MAX_LEN:
 			if (tlv_len != sizeof(u32))
@@ -430,7 +452,7 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 		case IWL_UCODE_TLV_ENHANCE_SENS_TBL:
 			if (tlv_len)
 				goto invalid_tlv_len;
-			nic->fw.enhance_sensitivity_table = true;
+			drv->fw.enhance_sensitivity_table = true;
 			break;
 		case IWL_UCODE_TLV_WOWLAN_INST:
 			pieces->wowlan_inst = tlv_data;
@@ -447,22 +469,22 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		default:
-			IWL_DEBUG_INFO(nic, "unknown TLV: %d\n", tlv_type);
+			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
 		}
 	}
 
 	if (len) {
-		IWL_ERR(nic, "invalid TLV after parsing: %zd\n", len);
-		iwl_print_hex_dump(nic, IWL_DL_FW, (u8 *)data, len);
+		IWL_ERR(drv, "invalid TLV after parsing: %zd\n", len);
+		iwl_print_hex_dump(drv, IWL_DL_FW, (u8 *)data, len);
 		return -EINVAL;
 	}
 
 	return 0;
 
  invalid_tlv_len:
-	IWL_ERR(nic, "TLV %d has invalid size: %u\n", tlv_type, tlv_len);
-	iwl_print_hex_dump(nic, IWL_DL_FW, tlv_data, tlv_len);
+	IWL_ERR(drv, "TLV %d has invalid size: %u\n", tlv_type, tlv_len);
+	iwl_print_hex_dump(drv, IWL_DL_FW, tlv_data, tlv_len);
 
 	return -EINVAL;
 }
@@ -475,9 +497,9 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
  */
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 {
-	struct iwl_nic *nic = context;
-	const struct iwl_cfg *cfg = cfg(nic);
-	struct iwl_fw *fw = &nic->fw;
+	struct iwl_drv *drv = context;
+	const struct iwl_cfg *cfg = cfg(drv);
+	struct iwl_fw *fw = &drv->fw;
 	struct iwl_ucode_header *ucode;
 	int err;
 	struct iwlagn_firmware_pieces pieces;
@@ -496,19 +518,19 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	memset(&pieces, 0, sizeof(pieces));
 
 	if (!ucode_raw) {
-		if (nic->fw_index <= api_ok)
-			IWL_ERR(nic,
+		if (drv->fw_index <= api_ok)
+			IWL_ERR(drv,
 				"request for firmware file '%s' failed.\n",
-				nic->firmware_name);
+				drv->firmware_name);
 		goto try_again;
 	}
 
-	IWL_DEBUG_INFO(nic, "Loaded firmware file '%s' (%zd bytes).\n",
-		       nic->firmware_name, ucode_raw->size);
+	IWL_DEBUG_INFO(drv, "Loaded firmware file '%s' (%zd bytes).\n",
+		       drv->firmware_name, ucode_raw->size);
 
 	/* Make sure that we got at least the API version number */
 	if (ucode_raw->size < 4) {
-		IWL_ERR(nic, "File size way too small!\n");
+		IWL_ERR(drv, "File size way too small!\n");
 		goto try_again;
 	}
 
@@ -516,15 +538,15 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	ucode = (struct iwl_ucode_header *)ucode_raw->data;
 
 	if (ucode->ver)
-		err = iwl_parse_v1_v2_firmware(nic, ucode_raw, &pieces);
+		err = iwl_parse_v1_v2_firmware(drv, ucode_raw, &pieces);
 	else
-		err = iwl_parse_tlv_firmware(nic, ucode_raw, &pieces,
+		err = iwl_parse_tlv_firmware(drv, ucode_raw, &pieces,
 					   &fw->ucode_capa);
 
 	if (err)
 		goto try_again;
 
-	api_ver = IWL_UCODE_API(nic->fw.ucode_ver);
+	api_ver = IWL_UCODE_API(drv->fw.ucode_ver);
 
 	/*
 	 * api_ver should match the api version forming part of the
@@ -532,9 +554,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * on the API version read from firmware header from here on forward
 	 */
 	/* no api version check required for experimental uCode */
-	if (nic->fw_index != UCODE_EXPERIMENTAL_INDEX) {
+	if (drv->fw_index != UCODE_EXPERIMENTAL_INDEX) {
 		if (api_ver < api_min || api_ver > api_max) {
-			IWL_ERR(nic,
+			IWL_ERR(drv,
 				"Driver unable to support your firmware API. "
 				"Driver supports v%u, firmware is v%u.\n",
 				api_max, api_ver);
@@ -543,19 +565,19 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 		if (api_ver < api_ok) {
 			if (api_ok != api_max)
-				IWL_ERR(nic, "Firmware has old API version, "
+				IWL_ERR(drv, "Firmware has old API version, "
 					"expected v%u through v%u, got v%u.\n",
 					api_ok, api_max, api_ver);
 			else
-				IWL_ERR(nic, "Firmware has old API version, "
+				IWL_ERR(drv, "Firmware has old API version, "
 					"expected v%u, got v%u.\n",
 					api_max, api_ver);
-			IWL_ERR(nic, "New firmware can be obtained from "
+			IWL_ERR(drv, "New firmware can be obtained from "
 				      "http://www.intellinuxwireless.org/.\n");
 		}
 	}
 
-	IWL_INFO(nic, "loaded firmware version %s", nic->fw.fw_version);
+	IWL_INFO(drv, "loaded firmware version %s", drv->fw.fw_version);
 
 	/*
 	 * For any of the failures below (before allocating pci memory)
@@ -563,38 +585,38 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * user just got a corrupted version of the latest API.
 	 */
 
-	IWL_DEBUG_INFO(nic, "f/w package hdr ucode version raw = 0x%x\n",
-		       nic->fw.ucode_ver);
-	IWL_DEBUG_INFO(nic, "f/w package hdr runtime inst size = %Zd\n",
+	IWL_DEBUG_INFO(drv, "f/w package hdr ucode version raw = 0x%x\n",
+		       drv->fw.ucode_ver);
+	IWL_DEBUG_INFO(drv, "f/w package hdr runtime inst size = %Zd\n",
 		       pieces.inst_size);
-	IWL_DEBUG_INFO(nic, "f/w package hdr runtime data size = %Zd\n",
+	IWL_DEBUG_INFO(drv, "f/w package hdr runtime data size = %Zd\n",
 		       pieces.data_size);
-	IWL_DEBUG_INFO(nic, "f/w package hdr init inst size = %Zd\n",
+	IWL_DEBUG_INFO(drv, "f/w package hdr init inst size = %Zd\n",
 		       pieces.init_size);
-	IWL_DEBUG_INFO(nic, "f/w package hdr init data size = %Zd\n",
+	IWL_DEBUG_INFO(drv, "f/w package hdr init data size = %Zd\n",
 		       pieces.init_data_size);
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (pieces.inst_size > cfg->max_inst_size) {
-		IWL_ERR(nic, "uCode instr len %Zd too large to fit in\n",
+		IWL_ERR(drv, "uCode instr len %Zd too large to fit in\n",
 			pieces.inst_size);
 		goto try_again;
 	}
 
 	if (pieces.data_size > cfg->max_data_size) {
-		IWL_ERR(nic, "uCode data len %Zd too large to fit in\n",
+		IWL_ERR(drv, "uCode data len %Zd too large to fit in\n",
 			pieces.data_size);
 		goto try_again;
 	}
 
 	if (pieces.init_size > cfg->max_inst_size) {
-		IWL_ERR(nic, "uCode init instr len %Zd too large to fit in\n",
+		IWL_ERR(drv, "uCode init instr len %Zd too large to fit in\n",
 			pieces.init_size);
 		goto try_again;
 	}
 
 	if (pieces.init_data_size > cfg->max_data_size) {
-		IWL_ERR(nic, "uCode init data len %Zd too large to fit in\n",
+		IWL_ERR(drv, "uCode init data len %Zd too large to fit in\n",
 			pieces.init_data_size);
 		goto try_again;
 	}
@@ -604,34 +626,34 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
-	if (iwl_alloc_fw_desc(nic, &nic->fw.ucode_rt.code,
+	if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_rt.code,
 			      pieces.inst, pieces.inst_size))
 		goto err_pci_alloc;
-	if (iwl_alloc_fw_desc(nic, &nic->fw.ucode_rt.data,
+	if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_rt.data,
 			      pieces.data, pieces.data_size))
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
 	if (pieces.init_size && pieces.init_data_size) {
-		if (iwl_alloc_fw_desc(nic,
-				      &nic->fw.ucode_init.code,
+		if (iwl_alloc_fw_desc(drv,
+				      &drv->fw.ucode_init.code,
 				      pieces.init, pieces.init_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(nic,
-				      &nic->fw.ucode_init.data,
+		if (iwl_alloc_fw_desc(drv,
+				      &drv->fw.ucode_init.data,
 				      pieces.init_data, pieces.init_data_size))
 			goto err_pci_alloc;
 	}
 
 	/* WoWLAN instructions and data */
 	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
-		if (iwl_alloc_fw_desc(nic,
-				      &nic->fw.ucode_wowlan.code,
+		if (iwl_alloc_fw_desc(drv,
+				      &drv->fw.ucode_wowlan.code,
 				      pieces.wowlan_inst,
 				      pieces.wowlan_inst_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(nic,
-				      &nic->fw.ucode_wowlan.data,
+		if (iwl_alloc_fw_desc(drv,
+				      &drv->fw.ucode_wowlan.data,
 				      pieces.wowlan_data,
 				      pieces.wowlan_data_size))
 			goto err_pci_alloc;
@@ -670,11 +692,11 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
-	complete(&nic->request_firmware_complete);
+	complete(&drv->request_firmware_complete);
 
-	nic->op_mode = iwl_dvm_ops.start(nic->shrd->trans, &nic->fw);
+	drv->op_mode = iwl_dvm_ops.start(drv->shrd->trans, &drv->fw);
 
-	if (!nic->op_mode)
+	if (!drv->op_mode)
 		goto out_unbind;
 
 	return;
@@ -682,43 +704,43 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
  try_again:
 	/* try next, if any */
 	release_firmware(ucode_raw);
-	if (iwl_request_firmware(nic, false))
+	if (iwl_request_firmware(drv, false))
 		goto out_unbind;
 	return;
 
  err_pci_alloc:
-	IWL_ERR(nic, "failed to allocate pci memory\n");
-	iwl_dealloc_ucode(nic);
+	IWL_ERR(drv, "failed to allocate pci memory\n");
+	iwl_dealloc_ucode(drv);
 	release_firmware(ucode_raw);
  out_unbind:
-	complete(&nic->request_firmware_complete);
-	device_release_driver(trans(nic)->dev);
+	complete(&drv->request_firmware_complete);
+	device_release_driver(trans(drv)->dev);
 }
 
 int iwl_drv_start(struct iwl_shared *shrd,
 		  struct iwl_trans *trans, const struct iwl_cfg *cfg)
 {
-	struct iwl_nic *nic;
+	struct iwl_drv *drv;
 	int ret;
 
 	shrd->cfg = cfg;
 
-	nic = kzalloc(sizeof(*nic), GFP_KERNEL);
-	if (!nic) {
-		dev_printk(KERN_ERR, trans->dev, "Couldn't allocate iwl_nic");
+	drv = kzalloc(sizeof(*drv), GFP_KERNEL);
+	if (!drv) {
+		dev_printk(KERN_ERR, trans->dev, "Couldn't allocate iwl_drv");
 		return -ENOMEM;
 	}
-	nic->shrd = shrd;
-	shrd->nic = nic;
+	drv->shrd = shrd;
+	shrd->drv = drv;
 
-	init_completion(&nic->request_firmware_complete);
+	init_completion(&drv->request_firmware_complete);
 
-	ret = iwl_request_firmware(nic, true);
+	ret = iwl_request_firmware(drv, true);
 
 	if (ret) {
 		dev_printk(KERN_ERR, trans->dev, "Couldn't request the fw");
-		kfree(nic);
-		shrd->nic = NULL;
+		kfree(drv);
+		shrd->drv = NULL;
 	}
 
 	return ret;
@@ -726,16 +748,16 @@ int iwl_drv_start(struct iwl_shared *shrd,
 
 void iwl_drv_stop(struct iwl_shared *shrd)
 {
-	struct iwl_nic *nic = shrd->nic;
+	struct iwl_drv *drv = shrd->drv;
 
-	wait_for_completion(&nic->request_firmware_complete);
+	wait_for_completion(&drv->request_firmware_complete);
 
 	/* op_mode can be NULL if its start failed */
-	if (nic->op_mode)
-		iwl_op_mode_stop(nic->op_mode);
+	if (drv->op_mode)
+		iwl_op_mode_stop(drv->op_mode);
 
-	iwl_dealloc_ucode(nic);
+	iwl_dealloc_ucode(drv);
 
-	kfree(nic);
-	shrd->nic = NULL;
+	kfree(drv);
+	shrd->drv = NULL;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 3bcd2a7..3c9a8fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -43,7 +43,6 @@
 #include <asm/div64.h>
 
 #include "iwl-eeprom.h"
-#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 3754c35..bb34766 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -419,7 +419,7 @@ struct iwl_shared {
 	const struct iwl_cfg *cfg;
 	struct iwl_priv *priv;
 	struct iwl_trans *trans;
-	void *nic;
+	void *drv;
 	struct iwl_hw_params hw_params;
 	const struct iwl_fw *fw;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index fd25dd1..c1ecf0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -70,7 +70,6 @@
 #include <net/mac80211.h>
 #include <net/netlink.h>
 
-#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-debug.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 69e4544..c3c2de3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -34,7 +34,6 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-trans-pcie-int.h"
-#include "iwl-wifi.h"
 #include "iwl-op-mode.h"
 
 #ifdef CONFIG_IWLWIFI_IDI
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index f78b155..3747edb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -31,7 +31,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 
-#include "iwl-wifi.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
deleted file mode 100644
index a71624d..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-wifi.h
+++ /dev/null
@@ -1,88 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *****************************************************************************/
-
-#ifndef __iwl_wifi_h__
-#define __iwl_wifi_h__
-
-#include "iwl-shared.h"
-
-/**
- * struct iwl_nic - nic common data
- * @fw: the iwl_fw structure
- * @shrd: pointer to common shared structure
- * @op_mode: the running op_mode
- * @fw_index: firmware revision to try loading
- * @firmware_name: composite filename of ucode file to load
- * @request_firmware_complete: the firmware has been obtained from user space
- */
-struct iwl_nic {
-	struct iwl_fw fw;
-
-	struct iwl_shared *shrd;
-	struct iwl_op_mode *op_mode;
-
-	int fw_index;                   /* firmware we're trying to load */
-	char firmware_name[25];         /* name of firmware file to load */
-
-	struct completion request_firmware_complete;
-};
-#endif  /* __iwl_wifi_h__ */
-- 
1.7.0.4

