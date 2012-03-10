Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2830 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab2CJU73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/10] iwlwifi: change struct iwl_fw
Date: Sat, 10 Mar 2012 13:00:14 -0800
Message-Id: <1331413215-10027-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_220013_763681_F8586C20)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Change iwl_fw struct to hold an array of fw_img instead of
three separated instances.

Change fw_img to hold an array of fw_desc instead of two
separate descriptors for instructions and data.

Change load_given_ucode, load_section, verification functions
etc. to support this structure.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c    |   17 +--
 drivers/net/wireless/iwlwifi/iwl-drv.c        |  141 +++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-fw.h         |   25 +++--
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |   15 ++-
 drivers/net/wireless/iwlwifi/iwl-testmode.c   |   21 +---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   32 +++---
 drivers/net/wireless/iwlwifi/iwl-ucode.c      |   29 ++---
 7 files changed, 139 insertions(+), 141 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 89cb9a7..b7b1c04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -230,6 +230,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	int pos = 0;
 	int sram;
 	struct iwl_priv *priv = file->private_data;
+	const struct fw_img *img;
 	size_t bufsz;
 
 	/* default is to dump the entire data segment */
@@ -239,17 +240,8 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 			IWL_ERR(priv, "No uCode has been loadded.\n");
 			return -EINVAL;
 		}
-		if (priv->shrd->ucode_type == IWL_UCODE_INIT) {
-			priv->dbgfs_sram_len = priv->fw->ucode_init.data.len;
-		} else if (priv->shrd->ucode_type == IWL_UCODE_REGULAR) {
-			priv->dbgfs_sram_len = priv->fw->ucode_rt.data.len;
-		} else if (priv->shrd->ucode_type == IWL_UCODE_WOWLAN) {
-			priv->dbgfs_sram_len = priv->fw->ucode_wowlan.data.len;
-		} else {
-			IWL_ERR(priv, "Unsupported type of uCode loaded?"
-					" that shouldn't happen.\n");
-			return -EINVAL;
-		}
+		img = &priv->fw->img[priv->shrd->ucode_type];
+		priv->dbgfs_sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
 	}
 	len = priv->dbgfs_sram_len;
 
@@ -346,13 +338,14 @@ static ssize_t iwl_dbgfs_wowlan_sram_read(struct file *file,
 					  size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
+	const struct fw_img *img = &priv->fw->img[IWL_UCODE_WOWLAN];
 
 	if (!priv->wowlan_sram)
 		return -ENODATA;
 
 	return simple_read_from_buffer(user_buf, count, ppos,
 				       priv->wowlan_sram,
-				       priv->fw->ucode_wowlan.data.len);
+				       img->sec[IWL_UCODE_SECTION_DATA].len);
 }
 static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 					size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 19ccd36..54e0969 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -118,15 +118,16 @@ static void iwl_free_fw_desc(struct iwl_drv *drv, struct fw_desc *desc)
 
 static void iwl_free_fw_img(struct iwl_drv *drv, struct fw_img *img)
 {
-	iwl_free_fw_desc(drv, &img->code);
-	iwl_free_fw_desc(drv, &img->data);
+	int i;
+	for (i = 0; i < IWL_UCODE_SECTION_MAX; i++)
+		iwl_free_fw_desc(drv, &img->sec[i]);
 }
 
 static void iwl_dealloc_ucode(struct iwl_drv *drv)
 {
-	iwl_free_fw_img(drv, &drv->fw.ucode_rt);
-	iwl_free_fw_img(drv, &drv->fw.ucode_init);
-	iwl_free_fw_img(drv, &drv->fw.ucode_wowlan);
+	int i;
+	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
+		iwl_free_fw_img(drv, drv->fw.img + i);
 }
 
 static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
@@ -189,22 +190,8 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 				       GFP_KERNEL, drv, iwl_ucode_callback);
 }
 
-/*
- * enumeration of ucode section.
- * This enumeration is used for legacy tlv style (before 16.0 uCode).
- */
-enum iwl_ucode_sec {
-	IWL_UCODE_SECTION_INST,
-	IWL_UCODE_SECTION_DATA,
-};
-/*
- * For 16.0 uCode and above, there is no differentiation between section,
- * just an offset to the HW address.
- */
-#define UCODE_SECTION_MAX 4
-
 struct fw_img_parsing {
-	struct fw_sec sec[UCODE_SECTION_MAX];
+	struct fw_sec sec[IWL_UCODE_SECTION_MAX];
 	int sec_counter;
 };
 
@@ -691,6 +678,71 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	return -EINVAL;
 }
 
+static int alloc_pci_desc(struct iwl_drv *drv,
+			  struct iwl_firmware_pieces *pieces,
+			  enum iwl_ucode_type type)
+{
+	int i;
+	for (i = 0;
+	     i < IWL_UCODE_SECTION_MAX && get_sec_size(pieces, type, i);
+	     i++)
+		if (iwl_alloc_fw_desc(drv, &(drv->fw.img[type].sec[i]),
+						get_sec(pieces, type, i)))
+			return -1;
+	return 0;
+}
+
+static int validate_sec_sizes(struct iwl_drv *drv,
+			      struct iwl_firmware_pieces *pieces,
+			      const struct iwl_cfg *cfg)
+{
+	IWL_DEBUG_INFO(drv, "f/w package hdr runtime inst size = %Zd\n",
+		get_sec_size(pieces, IWL_UCODE_REGULAR,
+			     IWL_UCODE_SECTION_INST));
+	IWL_DEBUG_INFO(drv, "f/w package hdr runtime data size = %Zd\n",
+		get_sec_size(pieces, IWL_UCODE_REGULAR,
+			     IWL_UCODE_SECTION_DATA));
+	IWL_DEBUG_INFO(drv, "f/w package hdr init inst size = %Zd\n",
+		get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST));
+	IWL_DEBUG_INFO(drv, "f/w package hdr init data size = %Zd\n",
+		get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA));
+
+	/* Verify that uCode images will fit in card's SRAM. */
+	if (get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST) >
+							cfg->max_inst_size) {
+		IWL_ERR(drv, "uCode instr len %Zd too large to fit in\n",
+			get_sec_size(pieces, IWL_UCODE_REGULAR,
+						IWL_UCODE_SECTION_INST));
+		return -1;
+	}
+
+	if (get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA) >
+							cfg->max_data_size) {
+		IWL_ERR(drv, "uCode data len %Zd too large to fit in\n",
+			get_sec_size(pieces, IWL_UCODE_REGULAR,
+						IWL_UCODE_SECTION_DATA));
+		return -1;
+	}
+
+	 if (get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) >
+							cfg->max_inst_size) {
+		IWL_ERR(drv, "uCode init instr len %Zd too large to fit in\n",
+			get_sec_size(pieces, IWL_UCODE_INIT,
+						IWL_UCODE_SECTION_INST));
+		return -1;
+	}
+
+	if (get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA) >
+							cfg->max_data_size) {
+		IWL_ERR(drv, "uCode init data len %Zd too large to fit in\n",
+			get_sec_size(pieces, IWL_UCODE_REGULAR,
+						IWL_UCODE_SECTION_DATA));
+		return -1;
+	}
+	return 0;
+}
+
+
 /**
  * iwl_ucode_callback - callback when firmware was loaded
  *
@@ -709,6 +761,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	unsigned int api_ok = cfg->ucode_api_ok;
 	const unsigned int api_min = cfg->ucode_api_min;
 	u32 api_ver;
+	int i;
 
 	fw->ucode_capa.max_probe_length = 200;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -817,59 +870,17 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		goto try_again;
 	}
 
-	 if (get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) >
-							cfg->max_inst_size) {
-		IWL_ERR(drv, "uCode init instr len %Zd too large to fit in\n",
-			get_sec_size(&pieces, IWL_UCODE_INIT,
-				     IWL_UCODE_SECTION_INST));
+	if (validate_sec_sizes(drv, &pieces, cfg))
 		goto try_again;
-	}
-
-	if (get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA) >
-							cfg->max_data_size) {
-		IWL_ERR(drv, "uCode init data len %Zd too large to fit in\n",
-			get_sec_size(&pieces, IWL_UCODE_REGULAR,
-				     IWL_UCODE_SECTION_DATA));
-		goto try_again;
-	}
 
 	/* Allocate ucode buffers for card's bus-master loading ... */
 
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
-	if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_rt.code,
-		get_sec(&pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST)))
-		goto err_pci_alloc;
-	if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_rt.data,
-		get_sec(&pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA)))
-		goto err_pci_alloc;
-
-	/* Initialization instructions and data */
-	if (get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) &&
-	    get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA)) {
-		if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_init.code,
-			get_sec(&pieces, IWL_UCODE_INIT,
-						IWL_UCODE_SECTION_INST)))
-			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_init.data,
-			get_sec(&pieces, IWL_UCODE_INIT,
-						IWL_UCODE_SECTION_DATA)))
+	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
+		if (alloc_pci_desc(drv, &pieces, i))
 			goto err_pci_alloc;
-	}
-
-	/* WoWLAN instructions and data */
-	if (get_sec_size(&pieces, IWL_UCODE_WOWLAN, IWL_UCODE_SECTION_INST) &&
-	    get_sec_size(&pieces, IWL_UCODE_WOWLAN, IWL_UCODE_SECTION_DATA)) {
-		if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_wowlan.code,
-			get_sec(&pieces, IWL_UCODE_WOWLAN,
-						IWL_UCODE_SECTION_INST)))
-			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(drv, &drv->fw.ucode_wowlan.data,
-			get_sec(&pieces, IWL_UCODE_WOWLAN,
-						IWL_UCODE_SECTION_DATA)))
-			goto err_pci_alloc;
-	}
 
 	/* Now that we can no longer fail, copy information */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index c99a7fd..5d634f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -101,6 +101,20 @@ enum iwl_ucode_type {
 	IWL_UCODE_TYPE_MAX,
 };
 
+/*
+ * enumeration of ucode section.
+ * This enumeration is used for legacy tlv style (before 16.0 uCode).
+ */
+enum iwl_ucode_sec {
+	IWL_UCODE_SECTION_INST,
+	IWL_UCODE_SECTION_DATA,
+};
+/*
+ * For 16.0 uCode and above, there is no differentiation between sections,
+ * just an offset to the HW address.
+ */
+#define IWL_UCODE_SECTION_MAX 4
+
 struct iwl_ucode_capabilities {
 	u32 max_probe_length;
 	u32 standard_phy_calibration_size;
@@ -116,8 +130,7 @@ struct fw_desc {
 };
 
 struct fw_img {
-	struct fw_desc code;	/* firmware code image */
-	struct fw_desc data;	/* firmware data image */
+	struct fw_desc sec[IWL_UCODE_SECTION_MAX];
 };
 
 /* uCode version contains 4 values: Major/Minor/API/Serial */
@@ -131,9 +144,7 @@ struct fw_img {
  *
  * @ucode_ver: ucode version from the ucode file
  * @fw_version: firmware version string
- * @ucode_rt: run time ucode image
- * @ucode_init: init ucode image
- * @ucode_wowlan: wake on wireless ucode image (optional)
+ * @img: ucode image like ucode_rt, ucode_init, ucode_wowlan.
  * @ucode_capa: capabilities parsed from the ucode file.
  * @enhance_sensitivity_table: device can do enhanced sensitivity.
  * @init_evtlog_ptr: event log offset for init ucode.
@@ -149,9 +160,7 @@ struct iwl_fw {
 	char fw_version[ETHTOOL_BUSINFO_LEN];
 
 	/* ucode images */
-	struct fw_img ucode_rt;
-	struct fw_img ucode_init;
-	struct fw_img ucode_wowlan;
+	struct fw_img img[IWL_UCODE_TYPE_MAX];
 
 	struct iwl_ucode_capabilities ucode_capa;
 	bool enhance_sensitivity_table;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 9212ee3..b6805f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -196,7 +196,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
-	if (priv->fw->ucode_wowlan.code.len &&
+	if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
 	    trans(priv)->ops->wowlan_suspend &&
 	    device_can_wakeup(trans(priv)->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
@@ -437,6 +437,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	unsigned long flags;
 	u32 base, status = 0xffffffff;
 	int ret = -EIO;
+	const struct fw_img *img;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->mutex);
@@ -457,16 +458,18 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (ret == 0) {
-			if (!priv->wowlan_sram)
+			img = &(priv->fw->img[IWL_UCODE_WOWLAN]);
+			if (!priv->wowlan_sram) {
 				priv->wowlan_sram =
-					kzalloc(priv->fw->ucode_wowlan.data.len,
+				   kzalloc(img->sec[IWL_UCODE_SECTION_DATA].len,
 						GFP_KERNEL);
+			}
 
 			if (priv->wowlan_sram)
 				_iwl_read_targ_mem_words(
-					trans(priv), 0x800000,
-					priv->wowlan_sram,
-					priv->fw->ucode_wowlan.data.len / 4);
+				      trans(priv), 0x800000,
+				      priv->wowlan_sram,
+				      img->sec[IWL_UCODE_SECTION_DATA].len / 4);
 		}
 #endif
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index c6c084f..76f7f92 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -466,6 +466,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	unsigned char *rsp_data_ptr = NULL;
 	int status = 0, rsp_data_len = 0;
 	u32 devid, inst_size = 0, data_size = 0;
+	const struct fw_img *img;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
@@ -597,23 +598,9 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			IWL_ERR(priv, "No uCode has not been loaded\n");
 			return -EINVAL;
 		} else {
-			switch (priv->shrd->ucode_type) {
-			case IWL_UCODE_REGULAR:
-				inst_size = priv->fw->ucode_rt.code.len;
-				data_size = priv->fw->ucode_rt.data.len;
-				break;
-			case IWL_UCODE_INIT:
-				inst_size = priv->fw->ucode_init.code.len;
-				data_size = priv->fw->ucode_init.data.len;
-				break;
-			case IWL_UCODE_WOWLAN:
-				inst_size = priv->fw->ucode_wowlan.code.len;
-				data_size = priv->fw->ucode_wowlan.data.len;
-				break;
-			default:
-				IWL_ERR(priv, "Unsupported uCode type\n");
-				break;
-			}
+			img = &priv->fw->img[priv->shrd->ucode_type];
+			inst_size = img->sec[IWL_UCODE_SECTION_INST].len;
+			data_size = img->sec[IWL_UCODE_SECTION_DATA].len;
 		}
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_TYPE, priv->shrd->ucode_type);
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_INST_SIZE, inst_size);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 0e8e31a..b4f796c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -951,12 +951,13 @@ static const u8 iwlagn_pan_ac_to_queue[] = {
 /*
  * ucode
  */
-static int iwl_load_section(struct iwl_trans *trans, const char *name,
-			    const struct fw_desc *image, u32 dst_addr)
+static int iwl_load_section(struct iwl_trans *trans, u8 section_num,
+			    const struct fw_desc *section)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	dma_addr_t phy_addr = image->p_addr;
-	u32 byte_cnt = image->len;
+	dma_addr_t phy_addr = section->p_addr;
+	u32 byte_cnt = section->len;
+	u32 dst_addr = section->offset;
 	int ret;
 
 	trans_pcie->ucode_write_complete = false;
@@ -989,12 +990,13 @@ static int iwl_load_section(struct iwl_trans *trans, const char *name,
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
-	IWL_DEBUG_FW(trans, "%s uCode section being loaded...\n", name);
+	IWL_DEBUG_FW(trans, "[%d] uCode section being loaded...\n",
+		     section_num);
 	ret = wait_event_timeout(trans_pcie->ucode_write_waitq,
 				 trans_pcie->ucode_write_complete, 5 * HZ);
 	if (!ret) {
-		IWL_ERR(trans, "Could not load the %s uCode section\n",
-			name);
+		IWL_ERR(trans, "Could not load the [%d] uCode section\n",
+			section_num);
 		return -ETIMEDOUT;
 	}
 
@@ -1005,16 +1007,16 @@ static int iwl_load_given_ucode(struct iwl_trans *trans,
 				const struct fw_img *image)
 {
 	int ret = 0;
+		int i;
 
-	ret = iwl_load_section(trans, "INST", &image->code,
-				   IWLAGN_RTC_INST_LOWER_BOUND);
-	if (ret)
-		return ret;
+		for (i = 0; i < IWL_UCODE_SECTION_MAX; i++) {
+			if (!image->sec[i].p_addr)
+				break;
 
-	ret = iwl_load_section(trans, "DATA", &image->data,
-				    IWLAGN_RTC_DATA_LOWER_BOUND);
-	if (ret)
-		return ret;
+			ret = iwl_load_section(trans, i, &image->sec[i]);
+			if (ret)
+				return ret;
+		}
 
 	/* Remove all resets to allow NIC to operate */
 	iwl_write32(trans, CSR_RESET, 0);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 0908880..2528287 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -80,17 +80,10 @@ static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 static inline const struct fw_img *
 iwl_get_ucode_image(struct iwl_priv *priv, enum iwl_ucode_type ucode_type)
 {
-	switch (ucode_type) {
-	case IWL_UCODE_INIT:
-		return &priv->fw->ucode_init;
-	case IWL_UCODE_WOWLAN:
-		return &priv->fw->ucode_wowlan;
-	case IWL_UCODE_REGULAR:
-		return &priv->fw->ucode_rt;
-	default:
-		break;
-	}
-	return NULL;
+	if (ucode_type >= IWL_UCODE_TYPE_MAX)
+		return NULL;
+
+	return &priv->fw->img[ucode_type];
 }
 
 /*
@@ -342,7 +335,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwl_verify_inst_sparse(struct iwl_priv *priv,
+static int iwl_verify_sec_sparse(struct iwl_priv *priv,
 				  const struct fw_desc *fw_desc)
 {
 	__le32 *image = (__le32 *)fw_desc->v_addr;
@@ -357,7 +350,7 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv,
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
 		iwl_write_direct32(trans(priv), HBUS_TARG_MEM_RADDR,
-			i + IWLAGN_RTC_INST_LOWER_BOUND);
+			i + fw_desc->offset);
 		val = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image))
 			return -EIO;
@@ -366,7 +359,7 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv,
 	return 0;
 }
 
-static void iwl_print_mismatch_inst(struct iwl_priv *priv,
+static void iwl_print_mismatch_sec(struct iwl_priv *priv,
 				    const struct fw_desc *fw_desc)
 {
 	__le32 *image = (__le32 *)fw_desc->v_addr;
@@ -378,7 +371,7 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
 	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
 
 	iwl_write_direct32(trans(priv), HBUS_TARG_MEM_RADDR,
-			   IWLAGN_RTC_INST_LOWER_BOUND);
+				fw_desc->offset);
 
 	for (offs = 0;
 	     offs < len && errors < 20;
@@ -408,14 +401,14 @@ static int iwl_verify_ucode(struct iwl_priv *priv,
 		return -EINVAL;
 	}
 
-	if (!iwl_verify_inst_sparse(priv, &img->code)) {
+	if (!iwl_verify_sec_sparse(priv, &img->sec[IWL_UCODE_SECTION_INST])) {
 		IWL_DEBUG_FW(priv, "uCode is good in inst SRAM\n");
 		return 0;
 	}
 
 	IWL_ERR(priv, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
 
-	iwl_print_mismatch_inst(priv, &img->code);
+	iwl_print_mismatch_sec(priv, &img->sec[IWL_UCODE_SECTION_INST]);
 	return -EIO;
 }
 
@@ -534,7 +527,7 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	lockdep_assert_held(&priv->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
-	if (!priv->fw->ucode_init.code.len)
+	if (!priv->fw->img[IWL_UCODE_INIT].sec[0].len)
 		return 0;
 
 	if (priv->init_ucode_run)
-- 
1.7.0.4

