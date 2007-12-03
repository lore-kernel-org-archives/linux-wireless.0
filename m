Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbXLCLpf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:35 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 01/34] iwlwifi: Support for uCode without init and bsm section
Date: Mon,  3 Dec 2007 13:43:13 +0200
Message-Id: <11966822291406-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120559_167828_4DFEF743)
In-Reply-To: <11966822261109-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 0d4fd60..bbcdd4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5765,6 +5765,12 @@ static void iwl3945_nic_start(struct iwl3945_priv *priv)
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
@@ -5773,7 +5779,7 @@ static void iwl3945_nic_start(struct iwl3945_priv *priv)
 static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 {
 	struct iwl3945_ucode *ucode;
-	int rc = 0;
+	int ret = 0;
 	const struct firmware *ucode_raw;
 	/* firmware file name contains uCode/driver compatibility version */
 	const char *name = "iwlwifi-3945" IWL3945_UCODE_API ".ucode";
@@ -5783,9 +5789,10 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 
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
 
@@ -5795,7 +5802,7 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	/* Make sure that we got at least our header! */
 	if (ucode_raw->size < sizeof(*ucode)) {
 		IWL_ERROR("File size way too small!\n");
-		rc = -EINVAL;
+		ret = -EINVAL;
 		goto err_release;
 	}
 
@@ -5823,43 +5830,40 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 
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
 
@@ -5869,56 +5873,45 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
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
@@ -5927,8 +5920,7 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	 * NOTE:  Copy into backup buffer will be done in iwl3945_up()  */
 	src = &ucode->data[inst_size];
 	len = priv->ucode_data.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %d\n",
-		       (int)len);
+	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %Zd\n", len);
 	memcpy(priv->ucode_data.v_addr, src, len);
 	memcpy(priv->ucode_data_backup.v_addr, src, len);
 
@@ -5936,8 +5928,8 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	if (init_size) {
 		src = &ucode->data[inst_size + data_size];
 		len = priv->ucode_init.len;
-		IWL_DEBUG_INFO("Copying (but not loading) init instr len %d\n",
-			       (int)len);
+		IWL_DEBUG_INFO("Copying (but not loading) init instr len %Zd\n",
+			       len);
 		memcpy(priv->ucode_init.v_addr, src, len);
 	}
 
@@ -5963,14 +5955,14 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 
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
index 5d92389..e179683 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6155,6 +6155,12 @@ static void iwl4965_nic_start(struct iwl4965_priv *priv)
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
@@ -6163,7 +6169,7 @@ static void iwl4965_nic_start(struct iwl4965_priv *priv)
 static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 {
 	struct iwl4965_ucode *ucode;
-	int rc = 0;
+	int ret;
 	const struct firmware *ucode_raw;
 	const char *name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode";
 	u8 *src;
@@ -6172,9 +6178,10 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 
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
 
@@ -6184,7 +6191,7 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	/* Make sure that we got at least our header! */
 	if (ucode_raw->size < sizeof(*ucode)) {
 		IWL_ERROR("File size way too small!\n");
-		rc = -EINVAL;
+		ret = -EINVAL;
 		goto err_release;
 	}
 
@@ -6217,43 +6224,43 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 
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
 
@@ -6263,56 +6270,41 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
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
@@ -6321,8 +6313,7 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	 * NOTE:  Copy into backup buffer will be done in iwl4965_up()  */
 	src = &ucode->data[inst_size];
 	len = priv->ucode_data.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %d\n",
-		       (int)len);
+	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %Zd\n", len);
 	memcpy(priv->ucode_data.v_addr, src, len);
 	memcpy(priv->ucode_data_backup.v_addr, src, len);
 
@@ -6330,8 +6321,8 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	if (init_size) {
 		src = &ucode->data[inst_size + data_size];
 		len = priv->ucode_init.len;
-		IWL_DEBUG_INFO("Copying (but not loading) init instr len %d\n",
-			       (int)len);
+		IWL_DEBUG_INFO("Copying (but not loading) init instr len %Zd\n",
+				len);
 		memcpy(priv->ucode_init.v_addr, src, len);
 	}
 
@@ -6339,16 +6330,15 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
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
@@ -6357,14 +6347,14 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 
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
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
