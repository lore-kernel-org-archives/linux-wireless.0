Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23017 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab1DVRzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/10] iwlagn: combine firmware code/data
Date: Fri, 22 Apr 2011 10:33:17 -0700
Message-Id: <1303493598-10979-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

On new hardware, ucode images always come in
pairs: code and data. Therefore, combine the
variables into an appropriate struct and use
that when both code and data are needed.

Also, combine allocation and copying so that
we have less code in total.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   23 +++----
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   98 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   11 ++-
 drivers/net/wireless/iwlwifi/iwl-helpers.h   |   24 ------
 6 files changed, 65 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 56dc771..c3ae2e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -161,17 +161,16 @@ static int iwlagn_load_section(struct iwl_priv *priv, const char *name,
 }
 
 static int iwlagn_load_given_ucode(struct iwl_priv *priv,
-				   struct fw_desc *inst_image,
-				   struct fw_desc *data_image)
+				   struct fw_img *image)
 {
 	int ret = 0;
 
-	ret = iwlagn_load_section(priv, "INST", inst_image,
+	ret = iwlagn_load_section(priv, "INST", &image->code,
 				   IWLAGN_RTC_INST_LOWER_BOUND);
 	if (ret)
 		return ret;
 
-	return iwlagn_load_section(priv, "DATA", data_image,
+	return iwlagn_load_section(priv, "DATA", &image->data,
 				    IWLAGN_RTC_DATA_LOWER_BOUND);
 }
 
@@ -557,16 +556,16 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
  * iwl_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-static int iwl_verify_ucode(struct iwl_priv *priv, struct fw_desc *fw_desc)
+static int iwl_verify_ucode(struct iwl_priv *priv, struct fw_img *img)
 {
-	if (!iwlcore_verify_inst_sparse(priv, fw_desc)) {
+	if (!iwlcore_verify_inst_sparse(priv, &img->code)) {
 		IWL_DEBUG_INFO(priv, "uCode is good in inst SRAM\n");
 		return 0;
 	}
 
 	IWL_ERR(priv, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
 
-	iwl_print_mismatch_inst(priv, fw_desc);
+	iwl_print_mismatch_inst(priv, &img->code);
 	return -EIO;
 }
 
@@ -602,8 +601,7 @@ static void iwlagn_alive_fn(struct iwl_priv *priv,
 #define UCODE_CALIB_TIMEOUT	(2*HZ)
 
 int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
-				 struct fw_desc *inst_image,
-				 struct fw_desc *data_image,
+				 struct fw_img *image,
 				 int subtype, int alternate_subtype)
 {
 	struct iwl_notification_wait alive_wait;
@@ -621,7 +619,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	old_type = priv->ucode_type;
 	priv->ucode_type = subtype;
 
-	ret = iwlagn_load_given_ucode(priv, inst_image, data_image);
+	ret = iwlagn_load_given_ucode(priv, image);
 	if (ret) {
 		priv->ucode_type = old_type;
 		iwlagn_remove_notification(priv, &alive_wait);
@@ -656,7 +654,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 		return -EIO;
 	}
 
-	ret = iwl_verify_ucode(priv, inst_image);
+	ret = iwl_verify_ucode(priv, image);
 	if (ret) {
 		priv->ucode_type = old_type;
 		return ret;
@@ -684,7 +682,7 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	lockdep_assert_held(&priv->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
-	if (!priv->ucode_init.len)
+	if (!priv->ucode_init.code.len)
 		return 0;
 
 	if (priv->ucode_type != UCODE_SUBTYPE_NONE_LOADED)
@@ -696,7 +694,6 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 
 	/* Will also start the device */
 	ret = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_init,
-					   &priv->ucode_init_data,
 					   UCODE_SUBTYPE_INIT, -1);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 12cd5e0..f30735b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1173,12 +1173,42 @@ static struct attribute_group iwl_attribute_group = {
  *
  ******************************************************************************/
 
+static void iwl_free_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc)
+{
+	if (desc->v_addr)
+		dma_free_coherent(&pci_dev->dev, desc->len,
+				  desc->v_addr, desc->p_addr);
+	desc->v_addr = NULL;
+	desc->len = 0;
+}
+
+static void iwl_free_fw_img(struct pci_dev *pci_dev, struct fw_img *img)
+{
+	iwl_free_fw_desc(pci_dev, &img->code);
+	iwl_free_fw_desc(pci_dev, &img->data);
+}
+
+static int iwl_alloc_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc,
+			     const void *data, size_t len)
+{
+	if (!len) {
+		desc->v_addr = NULL;
+		return -EINVAL;
+	}
+
+	desc->v_addr = dma_alloc_coherent(&pci_dev->dev, len,
+					  &desc->p_addr, GFP_KERNEL);
+	if (!desc->v_addr)
+		return -ENOMEM;
+	desc->len = len;
+	memcpy(desc->v_addr, data, len);
+	return 0;
+}
+
 static void iwl_dealloc_ucode_pci(struct iwl_priv *priv)
 {
-	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_code);
-	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data);
-	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init);
-	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init_data);
+	iwl_free_fw_img(priv->pci_dev, &priv->ucode_rt);
+	iwl_free_fw_img(priv->pci_dev, &priv->ucode_init);
 }
 
 struct iwlagn_ucode_capabilities {
@@ -1647,24 +1677,20 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
-	priv->ucode_code.len = pieces.inst_size;
-	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_code);
-
-	priv->ucode_data.len = pieces.data_size;
-	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_data);
-
-	if (!priv->ucode_code.v_addr || !priv->ucode_data.v_addr)
+	if (iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_rt.code,
+			      pieces.inst, pieces.inst_size))
+		goto err_pci_alloc;
+	if (iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_rt.data,
+			      pieces.data, pieces.data_size))
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
 	if (pieces.init_size && pieces.init_data_size) {
-		priv->ucode_init.len = pieces.init_size;
-		iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init);
-
-		priv->ucode_init_data.len = pieces.init_data_size;
-		iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init_data);
-
-		if (!priv->ucode_init.v_addr || !priv->ucode_init_data.v_addr)
+		if (iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init.code,
+				      pieces.init, pieces.init_size))
+			goto err_pci_alloc;
+		if (iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init.data,
+				      pieces.init_data, pieces.init_data_size))
 			goto err_pci_alloc;
 	}
 
@@ -1701,39 +1727,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	else
 		priv->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 
-	/* Copy images into buffers for card's bus-master reads ... */
-
-	/* Runtime instructions (first block of data in file) */
-	IWL_DEBUG_INFO(priv, "Copying (but not loading) uCode instr len %Zd\n",
-			pieces.inst_size);
-	memcpy(priv->ucode_code.v_addr, pieces.inst, pieces.inst_size);
-
-	IWL_DEBUG_INFO(priv, "uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
-		priv->ucode_code.v_addr, (u32)priv->ucode_code.p_addr);
-
-	/*
-	 * Runtime data
-	 * NOTE:  Copy into backup buffer will be done in iwl_up()
-	 */
-	IWL_DEBUG_INFO(priv, "Copying (but not loading) uCode data len %Zd\n",
-			pieces.data_size);
-	memcpy(priv->ucode_data.v_addr, pieces.data, pieces.data_size);
-
-	/* Initialization instructions */
-	if (pieces.init_size) {
-		IWL_DEBUG_INFO(priv, "Copying (but not loading) init instr len %Zd\n",
-				pieces.init_size);
-		memcpy(priv->ucode_init.v_addr, pieces.init, pieces.init_size);
-	}
-
-	/* Initialization data */
-	if (pieces.init_data_size) {
-		IWL_DEBUG_INFO(priv, "Copying (but not loading) init data len %Zd\n",
-			       pieces.init_data_size);
-		memcpy(priv->ucode_init_data.v_addr, pieces.init_data,
-		       pieces.init_data_size);
-	}
-
 	/*
 	 * figure out the offset of chain noise reset and gain commands
 	 * base on the size of standard phy calibration commands table size
@@ -2450,8 +2443,7 @@ static int __iwl_up(struct iwl_priv *priv)
 	}
 
 	ret = iwlagn_load_ucode_wait_alive(priv,
-					   &priv->ucode_code,
-					   &priv->ucode_data,
+					   &priv->ucode_rt,
 					   UCODE_SUBTYPE_REGULAR,
 					   UCODE_SUBTYPE_REGULAR_NEW);
 	if (ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index cf05f87..c475ac4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -164,8 +164,7 @@ int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwlagn_send_prio_tbl(struct iwl_priv *priv);
 int iwlagn_run_init_ucode(struct iwl_priv *priv);
 int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
-				 struct fw_desc *inst_image,
-				 struct fw_desc *data_image,
+				 struct fw_img *image,
 				 int subtype, int alternate_subtype);
 
 /* lib */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 2b60688..7bd4f5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -227,9 +227,9 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset = 0x800000;
 		if (priv->ucode_type == UCODE_SUBTYPE_INIT)
-			priv->dbgfs_sram_len = priv->ucode_init_data.len;
+			priv->dbgfs_sram_len = priv->ucode_init.data.len;
 		else
-			priv->dbgfs_sram_len = priv->ucode_data.len;
+			priv->dbgfs_sram_len = priv->ucode_rt.data.len;
 	}
 	len = priv->dbgfs_sram_len;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 414968c..857eb0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -479,6 +479,10 @@ struct fw_desc {
 	u32 len;		/* bytes */
 };
 
+struct fw_img {
+	struct fw_desc code, data;
+};
+
 /* v1/v2 uCode file layout */
 struct iwl_ucode_header {
 	__le32 ver;	/* major/minor/API/serial */
@@ -1266,10 +1270,9 @@ struct iwl_priv {
 	int fw_index;			/* firmware we're trying to load */
 	u32 ucode_ver;			/* version of ucode, copy of
 					   iwl_ucode.ver */
-	struct fw_desc ucode_code;	/* runtime inst */
-	struct fw_desc ucode_data;	/* runtime data original */
-	struct fw_desc ucode_init;	/* initialization inst */
-	struct fw_desc ucode_init_data;	/* initialization data */
+	struct fw_img ucode_rt;
+	struct fw_img ucode_init;
+
 	enum iwlagn_ucode_subtype ucode_type;
 	u8 ucode_write_complete;	/* the image write is complete */
 	char firmware_name[25];
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 9309ff2..41207a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -64,30 +64,6 @@ static inline int iwl_queue_dec_wrap(int index, int n_bd)
 	return --index & (n_bd - 1);
 }
 
-/* TODO: Move fw_desc functions to iwl-pci.ko */
-static inline void iwl_free_fw_desc(struct pci_dev *pci_dev,
-				    struct fw_desc *desc)
-{
-	if (desc->v_addr)
-		dma_free_coherent(&pci_dev->dev, desc->len,
-				  desc->v_addr, desc->p_addr);
-	desc->v_addr = NULL;
-	desc->len = 0;
-}
-
-static inline int iwl_alloc_fw_desc(struct pci_dev *pci_dev,
-				    struct fw_desc *desc)
-{
-	if (!desc->len) {
-		desc->v_addr = NULL;
-		return -EINVAL;
-	}
-
-	desc->v_addr = dma_alloc_coherent(&pci_dev->dev, desc->len,
-					  &desc->p_addr, GFP_KERNEL);
-	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
-}
-
 /*
  * we have 8 bits used like this:
  *
-- 
1.7.0.4

