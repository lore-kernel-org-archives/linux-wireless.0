Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2830 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2CJU72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:28 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/10] iwlwifi: more modularity in fw images and sections
Date: Sat, 10 Mar 2012 13:00:12 -0800
Message-Id: <1331413215-10027-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_220008_786507_84FCA5DB)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Changed iwl_firmware_pieces structure to support an array of
separate images, and an array of sections for each image.

In fw_sec and fw_desc structures, added a field for
offset from the HW address, to support 16.0 uCode that
provides an offset instead of any other data about the section.
This field is filled with default values when parsing instruction
or data section.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c    |  280 +++++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-fw.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h |    1 +
 3 files changed, 207 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 29a3ae4..a21af3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -69,6 +69,7 @@
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 #include "iwl-op-mode.h"
+#include "iwl-agn-hw.h"
 
 /* private includes */
 #include "iwl-fw-file.h"
@@ -96,6 +97,16 @@ struct iwl_drv {
 
 
 
+/*
+ * struct fw_sec: Just for the image parsing proccess.
+ * For the fw storage we are using struct fw_desc.
+ */
+struct fw_sec {
+	const void *data;		/* the sec data */
+	size_t size;			/* section size */
+	u32 offset;			/* offset of writing in the device */
+};
+
 static void iwl_free_fw_desc(struct iwl_drv *drv, struct fw_desc *desc)
 {
 	if (desc->v_addr)
@@ -119,20 +130,21 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 }
 
 static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
-		      const void *data, size_t len)
+		      struct fw_sec *sec)
 {
-	if (!len) {
+	if (!sec || !sec->size) {
 		desc->v_addr = NULL;
 		return -EINVAL;
 	}
 
-	desc->v_addr = dma_alloc_coherent(trans(drv)->dev, len,
+	desc->v_addr = dma_alloc_coherent(trans(drv)->dev, sec->size,
 					  &desc->p_addr, GFP_KERNEL);
 	if (!desc->v_addr)
 		return -ENOMEM;
 
-	desc->len = len;
-	memcpy(desc->v_addr, data, len);
+	desc->len = sec->size;
+	desc->offset = sec->offset;
+	memcpy(desc->v_addr, sec->data, sec->size);
 	return 0;
 }
 
@@ -177,18 +189,77 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 				       GFP_KERNEL, drv, iwl_ucode_callback);
 }
 
-struct iwlagn_firmware_pieces {
-	const void *inst, *data, *init, *init_data, *wowlan_inst, *wowlan_data;
-	size_t inst_size, data_size, init_size, init_data_size,
-	       wowlan_inst_size, wowlan_data_size;
+/*
+ * enumeration of ucode section.
+ * This enumeration is used for legacy tlv style (before 16.0 uCode).
+ */
+enum iwl_ucode_sec {
+	IWL_UCODE_SECTION_INST,
+	IWL_UCODE_SECTION_DATA,
+};
+/*
+ * For 16.0 uCode and above, there is no differentiation between section,
+ * just an offset to the HW address.
+ */
+#define UCODE_SECTION_MAX 4
+
+struct fw_img_parsing {
+	struct fw_sec sec[UCODE_SECTION_MAX];
+	int sec_counter;
+};
+
+struct iwl_firmware_pieces {
+	struct fw_img_parsing img[IWL_UCODE_TYPE_MAX];
 
 	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
 	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 };
 
+/*
+ * These functions are just to extract uCode section data from the pieces
+ * structure.
+ */
+static struct fw_sec *get_sec(struct iwl_firmware_pieces *pieces,
+			      enum iwl_ucode_type type,
+			      int  sec)
+{
+	return &pieces->img[type].sec[sec];
+}
+
+static void set_sec_data(struct iwl_firmware_pieces *pieces,
+			 enum iwl_ucode_type type,
+			 int sec,
+			 const void *data)
+{
+	pieces->img[type].sec[sec].data = data;
+}
+
+static void set_sec_size(struct iwl_firmware_pieces *pieces,
+			 enum iwl_ucode_type type,
+			 int sec,
+			 size_t size)
+{
+	pieces->img[type].sec[sec].size = size;
+}
+
+static size_t get_sec_size(struct iwl_firmware_pieces *pieces,
+			   enum iwl_ucode_type type,
+			   int sec)
+{
+	return pieces->img[type].sec[sec].size;
+}
+
+static void set_sec_offset(struct iwl_firmware_pieces *pieces,
+			   enum iwl_ucode_type type,
+			   int sec,
+			   u32 offset)
+{
+	pieces->img[type].sec[sec].offset = offset;
+}
+
 static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
-				       const struct firmware *ucode_raw,
-				       struct iwlagn_firmware_pieces *pieces)
+				    const struct firmware *ucode_raw,
+				    struct iwl_firmware_pieces *pieces)
 {
 	struct iwl_ucode_header *ucode = (void *)ucode_raw->data;
 	u32 api_ver, hdr_size, build;
@@ -206,11 +277,14 @@ static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 			return -EINVAL;
 		}
 		build = le32_to_cpu(ucode->u.v2.build);
-		pieces->inst_size = le32_to_cpu(ucode->u.v2.inst_size);
-		pieces->data_size = le32_to_cpu(ucode->u.v2.data_size);
-		pieces->init_size = le32_to_cpu(ucode->u.v2.init_size);
-		pieces->init_data_size =
-			le32_to_cpu(ucode->u.v2.init_data_size);
+		set_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST,
+			     le32_to_cpu(ucode->u.v2.inst_size));
+		set_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA,
+			     le32_to_cpu(ucode->u.v2.data_size));
+		set_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST,
+			     le32_to_cpu(ucode->u.v2.init_size));
+		set_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA,
+			     le32_to_cpu(ucode->u.v2.init_data_size));
 		src = ucode->u.v2.data;
 		break;
 	case 0:
@@ -222,11 +296,14 @@ static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 			return -EINVAL;
 		}
 		build = 0;
-		pieces->inst_size = le32_to_cpu(ucode->u.v1.inst_size);
-		pieces->data_size = le32_to_cpu(ucode->u.v1.data_size);
-		pieces->init_size = le32_to_cpu(ucode->u.v1.init_size);
-		pieces->init_data_size =
-			le32_to_cpu(ucode->u.v1.init_data_size);
+		set_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST,
+			     le32_to_cpu(ucode->u.v1.inst_size));
+		set_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA,
+			     le32_to_cpu(ucode->u.v1.data_size));
+		set_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST,
+			     le32_to_cpu(ucode->u.v1.init_size));
+		set_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA,
+			     le32_to_cpu(ucode->u.v1.init_data_size));
 		src = ucode->u.v1.data;
 		break;
 	}
@@ -248,9 +325,12 @@ static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 		 buildstr);
 
 	/* Verify size of file vs. image size info in file's header */
-	if (ucode_raw->size != hdr_size + pieces->inst_size +
-				pieces->data_size + pieces->init_size +
-				pieces->init_data_size) {
+
+	if (ucode_raw->size != hdr_size +
+	    get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST) +
+	    get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA) +
+	    get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) +
+	    get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA)) {
 
 		IWL_ERR(drv,
 			"uCode file size %d does not match expected size\n",
@@ -258,21 +338,29 @@ static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 		return -EINVAL;
 	}
 
-	pieces->inst = src;
-	src += pieces->inst_size;
-	pieces->data = src;
-	src += pieces->data_size;
-	pieces->init = src;
-	src += pieces->init_size;
-	pieces->init_data = src;
-	src += pieces->init_data_size;
 
+	set_sec_data(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST, src);
+	src += get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST);
+	set_sec_offset(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST,
+		       IWLAGN_RTC_INST_LOWER_BOUND);
+	set_sec_data(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA, src);
+	src += get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA);
+	set_sec_offset(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA,
+		       IWLAGN_RTC_DATA_LOWER_BOUND);
+	set_sec_data(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST, src);
+	src += get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST);
+	set_sec_offset(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST,
+		       IWLAGN_RTC_INST_LOWER_BOUND);
+	set_sec_data(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA, src);
+	src += get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA);
+	set_sec_offset(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA,
+		       IWLAGN_RTC_DATA_LOWER_BOUND);
 	return 0;
 }
 
 static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				const struct firmware *ucode_raw,
-				struct iwlagn_firmware_pieces *pieces,
+				struct iwl_firmware_pieces *pieces,
 				struct iwl_ucode_capabilities *capa)
 {
 	struct iwl_tlv_ucode_header *ucode = (void *)ucode_raw->data;
@@ -368,20 +456,40 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 
 		switch (tlv_type) {
 		case IWL_UCODE_TLV_INST:
-			pieces->inst = tlv_data;
-			pieces->inst_size = tlv_len;
+			set_sec_data(pieces, IWL_UCODE_REGULAR,
+				     IWL_UCODE_SECTION_INST, tlv_data);
+			set_sec_size(pieces, IWL_UCODE_REGULAR,
+				     IWL_UCODE_SECTION_INST, tlv_len);
+			set_sec_offset(pieces, IWL_UCODE_REGULAR,
+				       IWL_UCODE_SECTION_INST,
+				       IWLAGN_RTC_INST_LOWER_BOUND);
 			break;
 		case IWL_UCODE_TLV_DATA:
-			pieces->data = tlv_data;
-			pieces->data_size = tlv_len;
+			set_sec_data(pieces, IWL_UCODE_REGULAR,
+				     IWL_UCODE_SECTION_DATA, tlv_data);
+			set_sec_size(pieces, IWL_UCODE_REGULAR,
+				     IWL_UCODE_SECTION_DATA, tlv_len);
+			set_sec_offset(pieces, IWL_UCODE_REGULAR,
+				       IWL_UCODE_SECTION_DATA,
+				       IWLAGN_RTC_DATA_LOWER_BOUND);
 			break;
 		case IWL_UCODE_TLV_INIT:
-			pieces->init = tlv_data;
-			pieces->init_size = tlv_len;
+			set_sec_data(pieces, IWL_UCODE_INIT,
+				     IWL_UCODE_SECTION_INST, tlv_data);
+			set_sec_size(pieces, IWL_UCODE_INIT,
+				     IWL_UCODE_SECTION_INST, tlv_len);
+			set_sec_offset(pieces, IWL_UCODE_INIT,
+				       IWL_UCODE_SECTION_INST,
+				       IWLAGN_RTC_INST_LOWER_BOUND);
 			break;
 		case IWL_UCODE_TLV_INIT_DATA:
-			pieces->init_data = tlv_data;
-			pieces->init_data_size = tlv_len;
+			set_sec_data(pieces, IWL_UCODE_INIT,
+				     IWL_UCODE_SECTION_DATA, tlv_data);
+			set_sec_size(pieces, IWL_UCODE_INIT,
+				     IWL_UCODE_SECTION_DATA, tlv_len);
+			set_sec_offset(pieces, IWL_UCODE_INIT,
+				       IWL_UCODE_SECTION_DATA,
+				       IWLAGN_RTC_DATA_LOWER_BOUND);
 			break;
 		case IWL_UCODE_TLV_BOOT:
 			IWL_ERR(drv, "Found unexpected BOOT ucode\n");
@@ -455,12 +563,22 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			drv->fw.enhance_sensitivity_table = true;
 			break;
 		case IWL_UCODE_TLV_WOWLAN_INST:
-			pieces->wowlan_inst = tlv_data;
-			pieces->wowlan_inst_size = tlv_len;
+			set_sec_data(pieces, IWL_UCODE_WOWLAN,
+				     IWL_UCODE_SECTION_INST, tlv_data);
+			set_sec_size(pieces, IWL_UCODE_WOWLAN,
+				     IWL_UCODE_SECTION_INST, tlv_len);
+			set_sec_offset(pieces, IWL_UCODE_WOWLAN,
+				       IWL_UCODE_SECTION_INST,
+				       IWLAGN_RTC_INST_LOWER_BOUND);
 			break;
 		case IWL_UCODE_TLV_WOWLAN_DATA:
-			pieces->wowlan_data = tlv_data;
-			pieces->wowlan_data_size = tlv_len;
+			set_sec_data(pieces, IWL_UCODE_WOWLAN,
+				     IWL_UCODE_SECTION_DATA, tlv_data);
+			set_sec_size(pieces, IWL_UCODE_WOWLAN,
+				     IWL_UCODE_SECTION_DATA, tlv_len);
+			set_sec_offset(pieces, IWL_UCODE_WOWLAN,
+				       IWL_UCODE_SECTION_DATA,
+				       IWLAGN_RTC_DATA_LOWER_BOUND);
 			break;
 		case IWL_UCODE_TLV_PHY_CALIBRATION_SIZE:
 			if (tlv_len != sizeof(u32))
@@ -502,7 +620,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	struct iwl_fw *fw = &drv->fw;
 	struct iwl_ucode_header *ucode;
 	int err;
-	struct iwlagn_firmware_pieces pieces;
+	struct iwl_firmware_pieces pieces;
 	const unsigned int api_max = cfg->ucode_api_max;
 	unsigned int api_ok = cfg->ucode_api_ok;
 	const unsigned int api_min = cfg->ucode_api_min;
@@ -588,36 +706,46 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	IWL_DEBUG_INFO(drv, "f/w package hdr ucode version raw = 0x%x\n",
 		       drv->fw.ucode_ver);
 	IWL_DEBUG_INFO(drv, "f/w package hdr runtime inst size = %Zd\n",
-		       pieces.inst_size);
+		get_sec_size(&pieces, IWL_UCODE_REGULAR,
+			     IWL_UCODE_SECTION_INST));
 	IWL_DEBUG_INFO(drv, "f/w package hdr runtime data size = %Zd\n",
-		       pieces.data_size);
+		get_sec_size(&pieces, IWL_UCODE_REGULAR,
+			     IWL_UCODE_SECTION_DATA));
 	IWL_DEBUG_INFO(drv, "f/w package hdr init inst size = %Zd\n",
-		       pieces.init_size);
+		get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST));
 	IWL_DEBUG_INFO(drv, "f/w package hdr init data size = %Zd\n",
-		       pieces.init_data_size);
+		get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA));
 
 	/* Verify that uCode images will fit in card's SRAM */
-	if (pieces.inst_size > cfg->max_inst_size) {
+	if (get_sec_size(&pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST) >
+							cfg->max_inst_size) {
 		IWL_ERR(drv, "uCode instr len %Zd too large to fit in\n",
-			pieces.inst_size);
+			get_sec_size(&pieces, IWL_UCODE_REGULAR,
+				     IWL_UCODE_SECTION_INST));
 		goto try_again;
 	}
 
-	if (pieces.data_size > cfg->max_data_size) {
+	if (get_sec_size(&pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA) >
+							cfg->max_data_size) {
 		IWL_ERR(drv, "uCode data len %Zd too large to fit in\n",
-			pieces.data_size);
+			get_sec_size(&pieces, IWL_UCODE_REGULAR,
+				     IWL_UCODE_SECTION_DATA));
 		goto try_again;
 	}
 
-	if (pieces.init_size > cfg->max_inst_size) {
+	 if (get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) >
+							cfg->max_inst_size) {
 		IWL_ERR(drv, "uCode init instr len %Zd too large to fit in\n",
-			pieces.init_size);
+			get_sec_size(&pieces, IWL_UCODE_INIT,
+				     IWL_UCODE_SECTION_INST));
 		goto try_again;
 	}
 
-	if (pieces.init_data_size > cfg->max_data_size) {
+	if (get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA) >
+							cfg->max_data_size) {
 		IWL_ERR(drv, "uCode init data len %Zd too large to fit in\n",
-			pieces.init_data_size);
+			get_sec_size(&pieces, IWL_UCODE_REGULAR,
+				     IWL_UCODE_SECTION_DATA));
 		goto try_again;
 	}
 
@@ -627,35 +755,35 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
 	if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_rt.code,
-			      pieces.inst, pieces.inst_size))
+		get_sec(&pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST)))
 		goto err_pci_alloc;
 	if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_rt.data,
-			      pieces.data, pieces.data_size))
+		get_sec(&pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA)))
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
-	if (pieces.init_size && pieces.init_data_size) {
-		if (iwl_alloc_fw_desc(drv,
-				      &drv->fw.ucode_init.code,
-				      pieces.init, pieces.init_size))
+	if (get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) &&
+	    get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA)) {
+		if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_init.code,
+			get_sec(&pieces, IWL_UCODE_INIT,
+						IWL_UCODE_SECTION_INST)))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(drv,
-				      &drv->fw.ucode_init.data,
-				      pieces.init_data, pieces.init_data_size))
+		if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_init.data,
+			get_sec(&pieces, IWL_UCODE_INIT,
+						IWL_UCODE_SECTION_DATA)))
 			goto err_pci_alloc;
 	}
 
 	/* WoWLAN instructions and data */
-	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
-		if (iwl_alloc_fw_desc(drv,
-				      &drv->fw.ucode_wowlan.code,
-				      pieces.wowlan_inst,
-				      pieces.wowlan_inst_size))
+	if (get_sec_size(&pieces, IWL_UCODE_WOWLAN, IWL_UCODE_SECTION_INST) &&
+	    get_sec_size(&pieces, IWL_UCODE_WOWLAN, IWL_UCODE_SECTION_DATA)) {
+		if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_wowlan.code,
+			get_sec(&pieces, IWL_UCODE_WOWLAN,
+						IWL_UCODE_SECTION_INST)))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(drv,
-				      &drv->fw.ucode_wowlan.data,
-				      pieces.wowlan_data,
-				      pieces.wowlan_data_size))
+		if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_wowlan.data,
+			get_sec(&pieces, IWL_UCODE_WOWLAN,
+						IWL_UCODE_SECTION_DATA)))
 			goto err_pci_alloc;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 453812a..253f7e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -91,11 +91,12 @@ struct iwl_ucode_capabilities {
 	u32 flags;
 };
 
-/* one for each uCode image (inst/data, boot/init/runtime) */
+/* one for each uCode image (inst/data, init/runtime/wowlan) */
 struct fw_desc {
 	dma_addr_t p_addr;	/* hardware address */
 	void *v_addr;		/* software address */
 	u32 len;		/* size in bytes */
+	u32 offset;		/* offset in the device */
 };
 
 struct fw_img {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 4cd2ece..d899c5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -205,6 +205,7 @@ enum iwl_ucode_type {
 	IWL_UCODE_REGULAR,
 	IWL_UCODE_INIT,
 	IWL_UCODE_WOWLAN,
+	IWL_UCODE_TYPE_MAX,
 };
 
 /*
-- 
1.7.0.4

