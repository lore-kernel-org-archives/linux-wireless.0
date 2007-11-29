Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbXK2DK2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:28 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/36] iwlwifi: Support for uCode without init and bsm section
Date: Thu, 29 Nov 2007 11:09:41 +0800
Message-Id: <1196305816-23023-2-git-send-email-yi.zhu@intel.com> (sfid-20071129_033543_143441_5079CEE1)
In-Reply-To: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch enables loading fw w/o init and bsm section. It also provides
general cleanup of the rutine.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  120 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  122 ++++++++++++--------------
 2 files changed, 112 insertions(+), 130 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 96420d5..f93cd1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5761,6 +5761,12 @@ static void iwl3945_nic_start(struct iwl3945_priv *priv)
 	iwl3945_write32(priv, CSR_RESET, 0);
 }
 
+static int iwl3945_alloc_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc)
+{
+	desc->v_addr = pci_alloc_consistent(pci_dev, desc->len, &desc->p_addr);
+	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
+}
+
 /**
  * iwl3945_read_ucode - Read uCode images from disk file.
  *
@@ -5769,7 +5775,7 @@ static void iwl3945_nic_start(struct iwl3945_priv *priv)
 static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 {
 	struct iwl3945_ucode *ucode;
-	int rc = 0;
+	int ret = 0;
 	const struct firmware *ucode_raw;
 	/* firmware file name contains uCode/driver compatibility version */
 	const char *name = "iwlwifi-3945" IWL3945_UCODE_API ".ucode";
@@ -5779,9 +5785,10 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 
 	/* Ask kernel firmware_class module to get the boot firmware off disk.
 	 * request_firmware() is synchronous, file is in memory on return. */
-	rc = request_firmware(&ucode_raw, name, &priv->pci_dev->dev);
-	if (rc < 0) {
-		IWL_ERROR("%s firmware file req failed: Reason %d\n", name, rc);
+	ret = request_firmware(&ucode_raw, name, &priv->pci_dev->dev);
+	if (ret < 0) {
+		IWL_ERROR("%s firmware file req failed: Reason %d\n",
+				name, ret);
 		goto error;
 	}
 
@@ -5791,7 +5798,7 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	/* Make sure that we got at least our header! */
 	if (ucode_raw->size < sizeof(*ucode)) {
 		IWL_ERROR("File size way too small!\n");
-		rc = -EINVAL;
+		ret = -EINVAL;
 		goto err_release;
 	}
 
@@ -5819,43 +5826,40 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 
 		IWL_DEBUG_INFO("uCode file size %d too small\n",
 			       (int)ucode_raw->size);
-		rc = -EINVAL;
+		ret = -EINVAL;
 		goto err_release;
 	}
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (inst_size > IWL_MAX_INST_SIZE) {
-		IWL_DEBUG_INFO("uCode instr len %d too large to fit in card\n",
-			       (int)inst_size);
-		rc = -EINVAL;
+		IWL_DEBUG_INFO("uCode instr len %d too large to fit in\n",
+			       inst_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 
 	if (data_size > IWL_MAX_DATA_SIZE) {
-		IWL_DEBUG_INFO("uCode data len %d too large to fit in card\n",
-			       (int)data_size);
-		rc = -EINVAL;
+		IWL_DEBUG_INFO("uCode data len %d too large to fit in\n",
+			       data_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_size > IWL_MAX_INST_SIZE) {
-		IWL_DEBUG_INFO
-		    ("uCode init instr len %d too large to fit in card\n",
-		     (int)init_size);
-		rc = -EINVAL;
+		IWL_DEBUG_INFO("uCode init instr len %d too large to fit in\n",
+				init_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_data_size > IWL_MAX_DATA_SIZE) {
-		IWL_DEBUG_INFO
-		    ("uCode init data len %d too large to fit in card\n",
-		     (int)init_data_size);
-		rc = -EINVAL;
+		IWL_DEBUG_INFO("uCode init data len %d too large to fit in\n",
+				init_data_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 	if (boot_size > IWL_MAX_BSM_SIZE) {
-		IWL_DEBUG_INFO
-		    ("uCode boot instr len %d too large to fit in bsm\n",
-		     (int)boot_size);
-		rc = -EINVAL;
+		IWL_DEBUG_INFO("uCode boot instr len %d too large to fit in\n",
+				boot_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 
@@ -5865,56 +5869,45 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
 	priv->ucode_code.len = inst_size;
-	priv->ucode_code.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_code.len,
-				 &(priv->ucode_code.p_addr));
+	iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_code);
 
 	priv->ucode_data.len = data_size;
-	priv->ucode_data.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_data.len,
-				 &(priv->ucode_data.p_addr));
+	iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_data);
 
 	priv->ucode_data_backup.len = data_size;
-	priv->ucode_data_backup.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_data_backup.len,
-				 &(priv->ucode_data_backup.p_addr));
+	iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
 
+	if (!priv->ucode_code.v_addr || !priv->ucode_data.v_addr ||
+	    !priv->ucode_data_backup.v_addr)
+		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
-	priv->ucode_init.len = init_size;
-	priv->ucode_init.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_init.len,
-				 &(priv->ucode_init.p_addr));
-
-	priv->ucode_init_data.len = init_data_size;
-	priv->ucode_init_data.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_init_data.len,
-				 &(priv->ucode_init_data.p_addr));
+	if (init_size && init_data_size) {
+		priv->ucode_init.len = init_size;
+		iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_init);
+
+		priv->ucode_init_data.len = init_data_size;
+		iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_init_data);
+
+		if (!priv->ucode_init.v_addr || !priv->ucode_init_data.v_addr)
+			goto err_pci_alloc;
+	}
 
 	/* Bootstrap (instructions only, no data) */
-	priv->ucode_boot.len = boot_size;
-	priv->ucode_boot.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_boot.len,
-				 &(priv->ucode_boot.p_addr));
+	if (boot_size) {
+		priv->ucode_boot.len = boot_size;
+		iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_boot);
 
-	if (!priv->ucode_code.v_addr || !priv->ucode_data.v_addr ||
-	    !priv->ucode_init.v_addr || !priv->ucode_init_data.v_addr ||
-	    !priv->ucode_boot.v_addr || !priv->ucode_data_backup.v_addr)
-		goto err_pci_alloc;
+		if (!priv->ucode_boot.v_addr)
+			goto err_pci_alloc;
+	}
 
 	/* Copy images into buffers for card's bus-master reads ... */
 
 	/* Runtime instructions (first block of data in file) */
 	src = &ucode->data[0];
 	len = priv->ucode_code.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode instr len %d\n",
-		       (int)len);
+	IWL_DEBUG_INFO("Copying (but not loading) uCode instr len %Zd\n", len);
 	memcpy(priv->ucode_code.v_addr, src, len);
 	IWL_DEBUG_INFO("uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
 		priv->ucode_code.v_addr, (u32)priv->ucode_code.p_addr);
@@ -5923,8 +5916,7 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	 * NOTE:  Copy into backup buffer will be done in iwl3945_up()  */
 	src = &ucode->data[inst_size];
 	len = priv->ucode_data.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %d\n",
-		       (int)len);
+	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %Zd\n", len);
 	memcpy(priv->ucode_data.v_addr, src, len);
 	memcpy(priv->ucode_data_backup.v_addr, src, len);
 
@@ -5932,8 +5924,8 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	if (init_size) {
 		src = &ucode->data[inst_size + data_size];
 		len = priv->ucode_init.len;
-		IWL_DEBUG_INFO("Copying (but not loading) init instr len %d\n",
-			       (int)len);
+		IWL_DEBUG_INFO("Copying (but not loading) init instr len %Zd\n",
+			       len);
 		memcpy(priv->ucode_init.v_addr, src, len);
 	}
 
@@ -5959,14 +5951,14 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 
  err_pci_alloc:
 	IWL_ERROR("failed to allocate pci memory\n");
-	rc = -ENOMEM;
+	ret = -ENOMEM;
 	iwl3945_dealloc_ucode_pci(priv);
 
  err_release:
 	release_firmware(ucode_raw);
 
  error:
-	return rc;
+	return ret;
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index df011ea..04aadfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6140,6 +6140,12 @@ static void iwl4965_nic_start(struct iwl4965_priv *priv)
 	iwl4965_write32(priv, CSR_RESET, 0);
 }
 
+static int iwl4965_alloc_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc)
+{
+	desc->v_addr = pci_alloc_consistent(pci_dev, desc->len, &desc->p_addr);
+	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
+}
+
 /**
  * iwl4965_read_ucode - Read uCode images from disk file.
  *
@@ -6148,7 +6154,7 @@ static void iwl4965_nic_start(struct iwl4965_priv *priv)
 static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 {
 	struct iwl4965_ucode *ucode;
-	int rc = 0;
+	int ret;
 	const struct firmware *ucode_raw;
 	const char *name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode";
 	u8 *src;
@@ -6157,9 +6163,10 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 
 	/* Ask kernel firmware_class module to get the boot firmware off disk.
 	 * request_firmware() is synchronous, file is in memory on return. */
-	rc = request_firmware(&ucode_raw, name, &priv->pci_dev->dev);
-	if (rc < 0) {
-		IWL_ERROR("%s firmware file req failed: Reason %d\n", name, rc);
+	ret = request_firmware(&ucode_raw, name, &priv->pci_dev->dev);
+	if (ret < 0) {
+		IWL_ERROR("%s firmware file req failed: Reason %d\n",
+					name, ret);
 		goto error;
 	}
 
@@ -6169,7 +6176,7 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	/* Make sure that we got at least our header! */
 	if (ucode_raw->size < sizeof(*ucode)) {
 		IWL_ERROR("File size way too small!\n");
-		rc = -EINVAL;
+		ret = -EINVAL;
 		goto err_release;
 	}
 
@@ -6202,43 +6209,43 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 
 		IWL_DEBUG_INFO("uCode file size %d too small\n",
 			       (int)ucode_raw->size);
-		rc = -EINVAL;
+		ret = -EINVAL;
 		goto err_release;
 	}
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (inst_size > IWL_MAX_INST_SIZE) {
-		IWL_DEBUG_INFO("uCode instr len %d too large to fit in card\n",
-			       (int)inst_size);
-		rc = -EINVAL;
+		IWL_DEBUG_INFO("uCode instr len %d too large to fit in\n",
+			       inst_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 
 	if (data_size > IWL_MAX_DATA_SIZE) {
-		IWL_DEBUG_INFO("uCode data len %d too large to fit in card\n",
-			       (int)data_size);
-		rc = -EINVAL;
+		IWL_DEBUG_INFO("uCode data len %d too large to fit in\n",
+				data_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_size > IWL_MAX_INST_SIZE) {
 		IWL_DEBUG_INFO
-		    ("uCode init instr len %d too large to fit in card\n",
-		     (int)init_size);
-		rc = -EINVAL;
+		    ("uCode init instr len %d too large to fit in\n",
+		      init_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_data_size > IWL_MAX_DATA_SIZE) {
 		IWL_DEBUG_INFO
-		    ("uCode init data len %d too large to fit in card\n",
-		     (int)init_data_size);
-		rc = -EINVAL;
+		    ("uCode init data len %d too large to fit in\n",
+		      init_data_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 	if (boot_size > IWL_MAX_BSM_SIZE) {
 		IWL_DEBUG_INFO
-		    ("uCode boot instr len %d too large to fit in bsm\n",
-		     (int)boot_size);
-		rc = -EINVAL;
+		    ("uCode boot instr len %d too large to fit in\n",
+		      boot_size);
+		ret = -EINVAL;
 		goto err_release;
 	}
 
@@ -6248,56 +6255,41 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
 	priv->ucode_code.len = inst_size;
-	priv->ucode_code.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_code.len,
-				 &(priv->ucode_code.p_addr));
+	iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_code);
 
 	priv->ucode_data.len = data_size;
-	priv->ucode_data.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_data.len,
-				 &(priv->ucode_data.p_addr));
+	iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_data);
 
 	priv->ucode_data_backup.len = data_size;
-	priv->ucode_data_backup.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_data_backup.len,
-				 &(priv->ucode_data_backup.p_addr));
-
+	iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
 
 	/* Initialization instructions and data */
-	priv->ucode_init.len = init_size;
-	priv->ucode_init.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_init.len,
-				 &(priv->ucode_init.p_addr));
-
-	priv->ucode_init_data.len = init_data_size;
-	priv->ucode_init_data.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_init_data.len,
-				 &(priv->ucode_init_data.p_addr));
+	if (init_size && init_data_size) {
+		priv->ucode_init.len = init_size;
+		iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_init);
+
+		priv->ucode_init_data.len = init_data_size;
+		iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_init_data);
+
+		if (!priv->ucode_init.v_addr || !priv->ucode_init_data.v_addr)
+			goto err_pci_alloc;
+	}
 
 	/* Bootstrap (instructions only, no data) */
-	priv->ucode_boot.len = boot_size;
-	priv->ucode_boot.v_addr =
-	    pci_alloc_consistent(priv->pci_dev,
-				 priv->ucode_boot.len,
-				 &(priv->ucode_boot.p_addr));
+	if (boot_size) {
+		priv->ucode_boot.len = boot_size;
+		iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_boot);
 
-	if (!priv->ucode_code.v_addr || !priv->ucode_data.v_addr ||
-	    !priv->ucode_init.v_addr || !priv->ucode_init_data.v_addr ||
-	    !priv->ucode_boot.v_addr || !priv->ucode_data_backup.v_addr)
-		goto err_pci_alloc;
+		if (!priv->ucode_boot.v_addr)
+			goto err_pci_alloc;
+	}
 
 	/* Copy images into buffers for card's bus-master reads ... */
 
 	/* Runtime instructions (first block of data in file) */
 	src = &ucode->data[0];
 	len = priv->ucode_code.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode instr len %d\n",
-		       (int)len);
+	IWL_DEBUG_INFO("Copying (but not loading) uCode instr len %Zd\n", len);
 	memcpy(priv->ucode_code.v_addr, src, len);
 	IWL_DEBUG_INFO("uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
 		priv->ucode_code.v_addr, (u32)priv->ucode_code.p_addr);
@@ -6306,8 +6298,7 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	 * NOTE:  Copy into backup buffer will be done in iwl4965_up()  */
 	src = &ucode->data[inst_size];
 	len = priv->ucode_data.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %d\n",
-		       (int)len);
+	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %Zd\n", len);
 	memcpy(priv->ucode_data.v_addr, src, len);
 	memcpy(priv->ucode_data_backup.v_addr, src, len);
 
@@ -6315,8 +6306,8 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	if (init_size) {
 		src = &ucode->data[inst_size + data_size];
 		len = priv->ucode_init.len;
-		IWL_DEBUG_INFO("Copying (but not loading) init instr len %d\n",
-			       (int)len);
+		IWL_DEBUG_INFO("Copying (but not loading) init instr len %Zd\n",
+				len);
 		memcpy(priv->ucode_init.v_addr, src, len);
 	}
 
@@ -6324,16 +6315,15 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	if (init_data_size) {
 		src = &ucode->data[inst_size + data_size + init_size];
 		len = priv->ucode_init_data.len;
-		IWL_DEBUG_INFO("Copying (but not loading) init data len %d\n",
-			       (int)len);
+		IWL_DEBUG_INFO("Copying (but not loading) init data len %Zd\n",
+			       len);
 		memcpy(priv->ucode_init_data.v_addr, src, len);
 	}
 
 	/* Bootstrap instructions (5th block) */
 	src = &ucode->data[inst_size + data_size + init_size + init_data_size];
 	len = priv->ucode_boot.len;
-	IWL_DEBUG_INFO("Copying (but not loading) boot instr len %d\n",
-		       (int)len);
+	IWL_DEBUG_INFO("Copying (but not loading) boot instr len %Zd\n", len);
 	memcpy(priv->ucode_boot.v_addr, src, len);
 
 	/* We have our copies now, allow OS release its copies */
@@ -6342,14 +6332,14 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 
  err_pci_alloc:
 	IWL_ERROR("failed to allocate pci memory\n");
-	rc = -ENOMEM;
+	ret = -ENOMEM;
 	iwl4965_dealloc_ucode_pci(priv);
 
  err_release:
 	release_firmware(ucode_raw);
 
  error:
-	return rc;
+	return ret;
 }
 
 
-- 
1.5.3.6
