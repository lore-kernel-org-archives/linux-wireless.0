Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56565 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab1KJBdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/28] iwlagn: move ucode files out of the iwl_priv structure
Date: Wed,  9 Nov 2011 16:39:14 -0800
Message-Id: <1320885571-19122-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023430_640591_5EB0EBBF)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Relocate the ucode files and update relevant code.
More code refactoring.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   96 +++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   73 ++++----------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    6 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   24 +------
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   29 ++++++++
 6 files changed, 121 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 9144ef5..9ec315b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/dma-mapping.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -72,6 +73,52 @@ static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 	{COEX_CU_RSRVD2_RP, COEX_CU_RSRVD2_WP, 0, COEX_RSRVD2_FLAGS}
 };
 
+/******************************************************************************
+ *
+ * uCode download functions
+ *
+ ******************************************************************************/
+
+static void iwl_free_fw_desc(struct iwl_bus *bus, struct fw_desc *desc)
+{
+	if (desc->v_addr)
+		dma_free_coherent(bus->dev, desc->len,
+				  desc->v_addr, desc->p_addr);
+	desc->v_addr = NULL;
+	desc->len = 0;
+}
+
+static void iwl_free_fw_img(struct iwl_bus *bus, struct fw_img *img)
+{
+	iwl_free_fw_desc(bus, &img->code);
+	iwl_free_fw_desc(bus, &img->data);
+}
+
+void iwl_dealloc_ucode(struct iwl_trans *trans)
+{
+	iwl_free_fw_img(bus(trans), &trans->ucode_rt);
+	iwl_free_fw_img(bus(trans), &trans->ucode_init);
+	iwl_free_fw_img(bus(trans), &trans->ucode_wowlan);
+}
+
+int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
+		      const void *data, size_t len)
+{
+	if (!len) {
+		desc->v_addr = NULL;
+		return -EINVAL;
+	}
+
+	desc->v_addr = dma_alloc_coherent(bus->dev, len,
+					  &desc->p_addr, GFP_KERNEL);
+	if (!desc->v_addr)
+		return -ENOMEM;
+
+	desc->len = len;
+	memcpy(desc->v_addr, data, len);
+	return 0;
+}
+
 /*
  * ucode
  */
@@ -125,40 +172,41 @@ static int iwlagn_load_section(struct iwl_trans *trans, const char *name,
 	return 0;
 }
 
-static inline struct fw_img *iwl_get_ucode_image(struct iwl_priv *priv,
-					enum iwlagn_ucode_type ucode_type)
+static inline struct fw_img *iwl_get_ucode_image(struct iwl_trans *trans,
+					enum iwl_ucode_type ucode_type)
 {
 	switch (ucode_type) {
 	case IWL_UCODE_INIT:
-		return &priv->ucode_init;
+		return &trans->ucode_init;
 	case IWL_UCODE_WOWLAN:
-		return &priv->ucode_wowlan;
+		return &trans->ucode_wowlan;
 	case IWL_UCODE_REGULAR:
-		return &priv->ucode_rt;
+		return &trans->ucode_rt;
 	case IWL_UCODE_NONE:
 		break;
 	}
 	return NULL;
 }
 
-static int iwlagn_load_given_ucode(struct iwl_priv *priv,
-				   enum iwlagn_ucode_type ucode_type)
+static int iwlagn_load_given_ucode(struct iwl_trans *trans,
+				   enum iwl_ucode_type ucode_type)
 {
 	int ret = 0;
-	struct fw_img *image = iwl_get_ucode_image(priv, ucode_type);
+	struct fw_img *image = iwl_get_ucode_image(trans, ucode_type);
 
 
 	if (!image) {
-		IWL_ERR(priv, "Invalid ucode requested (%d)\n", ucode_type);
+		IWL_ERR(trans, "Invalid ucode requested (%d)\n",
+			ucode_type);
 		return -EINVAL;
 	}
 
-	ret = iwlagn_load_section(trans(priv), "INST", &image->code,
+	ret = iwlagn_load_section(trans, "INST", &image->code,
 				   IWLAGN_RTC_INST_LOWER_BOUND);
 	if (ret)
 		return ret;
 
-	return iwlagn_load_section(trans(priv), "DATA", &image->data,
+	return iwlagn_load_section(trans, "DATA", &image->data,
 				    IWLAGN_RTC_DATA_LOWER_BOUND);
 }
 
@@ -498,24 +546,24 @@ static void iwl_print_mismatch_inst(struct iwl_bus *bus,
  * iwl_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-static int iwl_verify_ucode(struct iwl_priv *priv,
-			    enum iwlagn_ucode_type ucode_type)
+static int iwl_verify_ucode(struct iwl_trans *trans,
+			    enum iwl_ucode_type ucode_type)
 {
-	struct fw_img *img = iwl_get_ucode_image(priv, ucode_type);
+	struct fw_img *img = iwl_get_ucode_image(trans, ucode_type);
 
 	if (!img) {
-		IWL_ERR(priv, "Invalid ucode requested (%d)\n", ucode_type);
+		IWL_ERR(trans, "Invalid ucode requested (%d)\n", ucode_type);
 		return -EINVAL;
 	}
 
-	if (!iwl_verify_inst_sparse(bus(priv), &img->code)) {
-		IWL_DEBUG_FW(priv, "uCode is good in inst SRAM\n");
+	if (!iwl_verify_inst_sparse(bus(trans), &img->code)) {
+		IWL_DEBUG_FW(trans, "uCode is good in inst SRAM\n");
 		return 0;
 	}
 
-	IWL_ERR(priv, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
+	IWL_ERR(trans, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
 
-	iwl_print_mismatch_inst(bus(priv), &img->code);
+	iwl_print_mismatch_inst(bus(trans), &img->code);
 	return -EIO;
 }
 
@@ -551,12 +599,12 @@ static void iwlagn_alive_fn(struct iwl_priv *priv,
 #define UCODE_CALIB_TIMEOUT	(2*HZ)
 
 int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
-				 enum iwlagn_ucode_type ucode_type)
+				 enum iwl_ucode_type ucode_type)
 {
 	struct iwl_notification_wait alive_wait;
 	struct iwlagn_alive_data alive_data;
 	int ret;
-	enum iwlagn_ucode_type old_type;
+	enum iwl_ucode_type old_type;
 
 	ret = iwl_trans_start_device(trans(priv));
 	if (ret)
@@ -568,7 +616,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	old_type = priv->ucode_type;
 	priv->ucode_type = ucode_type;
 
-	ret = iwlagn_load_given_ucode(priv, ucode_type);
+	ret = iwlagn_load_given_ucode(trans(priv), ucode_type);
 	if (ret) {
 		priv->ucode_type = old_type;
 		iwlagn_remove_notification(priv, &alive_wait);
@@ -599,7 +647,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	 * skip it for WoWLAN.
 	 */
 	if (ucode_type != IWL_UCODE_WOWLAN) {
-		ret = iwl_verify_ucode(priv, ucode_type);
+		ret = iwl_verify_ucode(trans(priv), ucode_type);
 		if (ret) {
 			priv->ucode_type = old_type;
 			return ret;
@@ -628,7 +676,7 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
-	if (!priv->ucode_init.code.len)
+	if (!trans(priv)->ucode_init.code.len)
 		return 0;
 
 	if (priv->ucode_type != IWL_UCODE_NONE)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d5d3309..d7960f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/skbuff.h>
@@ -452,52 +451,6 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
 }
 
-/******************************************************************************
- *
- * uCode download functions
- *
- ******************************************************************************/
-
-static void iwl_free_fw_desc(struct iwl_priv *priv, struct fw_desc *desc)
-{
-	if (desc->v_addr)
-		dma_free_coherent(bus(priv)->dev, desc->len,
-				  desc->v_addr, desc->p_addr);
-	desc->v_addr = NULL;
-	desc->len = 0;
-}
-
-static void iwl_free_fw_img(struct iwl_priv *priv, struct fw_img *img)
-{
-	iwl_free_fw_desc(priv, &img->code);
-	iwl_free_fw_desc(priv, &img->data);
-}
-
-static void iwl_dealloc_ucode(struct iwl_priv *priv)
-{
-	iwl_free_fw_img(priv, &priv->ucode_rt);
-	iwl_free_fw_img(priv, &priv->ucode_init);
-	iwl_free_fw_img(priv, &priv->ucode_wowlan);
-}
-
-static int iwl_alloc_fw_desc(struct iwl_priv *priv, struct fw_desc *desc,
-			     const void *data, size_t len)
-{
-	if (!len) {
-		desc->v_addr = NULL;
-		return -EINVAL;
-	}
-
-	desc->v_addr = dma_alloc_coherent(bus(priv)->dev, len,
-					  &desc->p_addr, GFP_KERNEL);
-	if (!desc->v_addr)
-		return -ENOMEM;
-
-	desc->len = len;
-	memcpy(desc->v_addr, data, len);
-	return 0;
-}
-
 static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 {
 	int i;
@@ -1040,30 +993,32 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
-	if (iwl_alloc_fw_desc(priv, &priv->ucode_rt.code,
+	if (iwl_alloc_fw_desc(bus(priv), &trans(priv)->ucode_rt.code,
 			      pieces.inst, pieces.inst_size))
 		goto err_pci_alloc;
-	if (iwl_alloc_fw_desc(priv, &priv->ucode_rt.data,
+	if (iwl_alloc_fw_desc(bus(priv), &trans(priv)->ucode_rt.data,
 			      pieces.data, pieces.data_size))
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
 	if (pieces.init_size && pieces.init_data_size) {
-		if (iwl_alloc_fw_desc(priv, &priv->ucode_init.code,
+		if (iwl_alloc_fw_desc(bus(priv), &trans(priv)->ucode_init.code,
 				      pieces.init, pieces.init_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(priv, &priv->ucode_init.data,
+		if (iwl_alloc_fw_desc(bus(priv), &trans(priv)->ucode_init.data,
 				      pieces.init_data, pieces.init_data_size))
 			goto err_pci_alloc;
 	}
 
 	/* WoWLAN instructions and data */
 	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
-		if (iwl_alloc_fw_desc(priv, &priv->ucode_wowlan.code,
+		if (iwl_alloc_fw_desc(bus(priv),
+				      &trans(priv)->ucode_wowlan.code,
 				      pieces.wowlan_inst,
 				      pieces.wowlan_inst_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(priv, &priv->ucode_wowlan.data,
+		if (iwl_alloc_fw_desc(bus(priv),
+				      &trans(priv)->ucode_wowlan.data,
 				      pieces.wowlan_data,
 				      pieces.wowlan_data_size))
 			goto err_pci_alloc;
@@ -1156,7 +1111,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
  err_pci_alloc:
 	IWL_ERR(priv, "failed to allocate pci memory\n");
-	iwl_dealloc_ucode(priv);
+	iwl_dealloc_ucode(trans(priv));
  out_unbind:
 	complete(&priv->firmware_loading_complete);
 	device_release_driver(bus(priv)->dev);
@@ -1697,7 +1652,8 @@ static int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
-	if (priv->ucode_wowlan.code.len && device_can_wakeup(bus(priv)->dev)) {
+	if (trans(priv)->ucode_wowlan.code.len &&
+	    device_can_wakeup(bus(priv)->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
 					  WIPHY_WOWLAN_EAP_IDENTITY_REQ |
@@ -2241,15 +2197,16 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (ret == 0) {
+			struct iwl_trans *trans = trans(priv);
 			if (!priv->wowlan_sram)
 				priv->wowlan_sram =
-					kzalloc(priv->ucode_wowlan.data.len,
+					kzalloc(trans->ucode_wowlan.data.len,
 						GFP_KERNEL);
 
 			if (priv->wowlan_sram)
 				_iwl_read_targ_mem_words(
 					bus(priv), 0x800000, priv->wowlan_sram,
-					priv->ucode_wowlan.data.len / 4);
+					trans->ucode_wowlan.data.len / 4);
 		}
 #endif
 	}
@@ -3400,7 +3357,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	/*This will stop the queues, move the device to low power state */
 	iwl_trans_stop_device(trans(priv));
 
-	iwl_dealloc_ucode(priv);
+	iwl_dealloc_ucode(trans(priv));
 
 	iwl_eeprom_free(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index adefab5..7cc5cd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -95,7 +95,7 @@ int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwlagn_send_prio_tbl(struct iwl_priv *priv);
 int iwlagn_run_init_ucode(struct iwl_priv *priv);
 int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
-				 enum iwlagn_ucode_type ucode_type);
+				 enum iwl_ucode_type ucode_type);
 
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a1670e3..42871ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -236,9 +236,9 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset = 0x800000;
 		if (priv->ucode_type == IWL_UCODE_INIT)
-			priv->dbgfs_sram_len = priv->ucode_init.data.len;
+			priv->dbgfs_sram_len = trans(priv)->ucode_init.data.len;
 		else
-			priv->dbgfs_sram_len = priv->ucode_rt.data.len;
+			priv->dbgfs_sram_len = trans(priv)->ucode_rt.data.len;
 	}
 	len = priv->dbgfs_sram_len;
 
@@ -341,7 +341,7 @@ static ssize_t iwl_dbgfs_wowlan_sram_read(struct file *file,
 
 	return simple_read_from_buffer(user_buf, count, ppos,
 				       priv->wowlan_sram,
-				       priv->ucode_wowlan.data.len);
+				       trans(priv)->ucode_wowlan.data.len);
 }
 static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 					size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4279e01..2c68b9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -230,17 +230,6 @@ struct iwl_vif_priv {
 	u8 ibss_bssid_sta_id;
 };
 
-/* one for each uCode image (inst/data, boot/init/runtime) */
-struct fw_desc {
-	void *v_addr;		/* access by driver */
-	dma_addr_t p_addr;	/* access by card's busmaster DMA */
-	u32 len;		/* bytes */
-};
-
-struct fw_img {
-	struct fw_desc code, data;
-};
-
 /* v1/v2 uCode file layout */
 struct iwl_ucode_header {
 	__le32 ver;	/* major/minor/API/serial */
@@ -805,13 +794,6 @@ enum iwl_scan_type {
 	IWL_SCAN_ROC,
 };
 
-enum iwlagn_ucode_type {
-	IWL_UCODE_NONE,
-	IWL_UCODE_REGULAR,
-	IWL_UCODE_INIT,
-	IWL_UCODE_WOWLAN,
-};
-
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 struct iwl_testmode_trace {
 	u32 buff_size;
@@ -915,11 +897,7 @@ struct iwl_priv {
 	u32 ucode_ver;			/* version of ucode, copy of
 					   iwl_ucode.ver */
 
-	struct fw_img ucode_rt;
-	struct fw_img ucode_init;
-	struct fw_img ucode_wowlan;
-
-	enum iwlagn_ucode_type ucode_type;
+	enum iwl_ucode_type ucode_type;
 	char firmware_name[25];
 
 	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 34b817f..1ecdd1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -207,12 +207,34 @@ struct iwl_trans_ops {
 #endif
 };
 
+/* one for each uCode image (inst/data, boot/init/runtime) */
+struct fw_desc {
+	dma_addr_t p_addr;	/* hardware address */
+	void *v_addr;		/* software address */
+	u32 len;		/* size in bytes */
+};
+
+struct fw_img {
+	struct fw_desc code;	/* firmware code image */
+	struct fw_desc data;	/* firmware data image */
+};
+
+enum iwl_ucode_type {
+	IWL_UCODE_NONE,
+	IWL_UCODE_REGULAR,
+	IWL_UCODE_INIT,
+	IWL_UCODE_WOWLAN,
+};
+
 /**
  * struct iwl_trans - transport common data
  * @ops - pointer to iwl_trans_ops
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  * @hcmd_lock: protects HCMD
  * @ucode_write_complete: indicates that the ucode has been copied.
+ * @ucode_rt: run time ucode image
+ * @ucode_init: init ucode image
+ * @ucode_wowlan: wake on wireless ucode image (optional)
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -220,6 +242,9 @@ struct iwl_trans {
 	spinlock_t hcmd_lock;
 
 	u8 ucode_write_complete;	/* the image write is complete */
+	struct fw_img ucode_rt;
+	struct fw_img ucode_init;
+	struct fw_img ucode_wowlan;
 
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
@@ -351,4 +376,8 @@ static inline int iwl_trans_resume(struct iwl_trans *trans)
 ******************************************************/
 extern const struct iwl_trans_ops trans_ops_pcie;
 
+int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
+		      const void *data, size_t len);
+void iwl_dealloc_ucode(struct iwl_trans *trans);
+
 #endif /* __iwl_trans_h__ */
-- 
1.7.0.4

