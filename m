Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26932 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403AbZHMUbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/13] iwlwifi: traverse linklist to find the valid OTP block
Date: Thu, 13 Aug 2009 13:30:54 -0700
Message-Id: <1250195462-15811-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For devices using OTP memory, EEPROM image can start from
any one of the OTP blocks. If shadow RAM is disabled, we need to
traverse link list to find the last valid block, then start the EEPROM
image reading.

If OTP is not full, the valid block is the block _before_ the last block
on the link list; the last block on the link list is the empty block
ready for next OTP refresh/update.

If OTP is full, then the last block is the valid block to be used for
configure the device.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   20 +++-
 drivers/net/wireless/iwlwifi/iwl-core.h   |    4 +
 drivers/net/wireless/iwlwifi/iwl-dev.h    |   11 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |  185 +++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |   10 ++-
 6 files changed, 191 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 191718a..9bb6a28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -149,12 +149,14 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl1000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
+	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
+	.shadow_ram_support = false,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c3ec6c2..0b731fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -161,7 +161,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
@@ -169,6 +169,8 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
 	.pa_type = IWL_PA_HYBRID,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 /*
@@ -181,7 +183,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
@@ -189,6 +191,8 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.valid_rx_ant = ANT_BC,
 	.need_pll_cfg = false,
 	.pa_type = IWL_PA_INTERNAL,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -198,7 +202,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
@@ -206,6 +210,8 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
 	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -215,7 +221,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
@@ -223,6 +229,8 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = false,
 	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -232,7 +240,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
@@ -240,6 +248,8 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = false,
 	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 32750f4..5096834 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -209,6 +209,8 @@ struct iwl_mod_params {
  * @ucode_api_max: Highest version of uCode API supported by driver.
  * @ucode_api_min: Lowest version of uCode API supported by driver.
  * @pa_type: used by 6000 series only to identify the type of Power Amplifier
+ * @max_ll_items: max number of OTP blocks
+ * @shadow_ram_support: shadow support for OTP memory
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -247,6 +249,8 @@ struct iwl_cfg {
 	bool need_pll_cfg;
 	bool use_isr_legacy;
 	enum iwl_pa_type pa_type;
+	const u16 max_ll_items;
+	const bool shadow_ram_support;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c34f9d7..0b19a6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -887,6 +887,17 @@ enum iwl_nvm_type {
 	NVM_DEVICE_TYPE_OTP,
 };
 
+/*
+ * Two types of OTP memory access modes
+ *   IWL_OTP_ACCESS_ABSOLUTE - absolute address mode,
+ * 			        based on physical memory addressing
+ *   IWL_OTP_ACCESS_RELATIVE - relative address mode,
+ * 			       based on logical memory addressing
+ */
+enum iwl_access_mode {
+	IWL_OTP_ACCESS_ABSOLUTE,
+	IWL_OTP_ACCESS_RELATIVE,
+};
 
 /**
  * enum iwl_pa_type - Power Amplifier type
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index ded6332..01b95e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -152,6 +152,19 @@ int iwlcore_eeprom_verify_signature(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwlcore_eeprom_verify_signature);
 
+static void iwl_set_otp_access(struct iwl_priv *priv, enum iwl_access_mode mode)
+{
+	u32 otpgp;
+
+	otpgp = iwl_read32(priv, CSR_OTP_GP_REG);
+	if (mode == IWL_OTP_ACCESS_ABSOLUTE)
+		iwl_clear_bit(priv, CSR_OTP_GP_REG,
+				CSR_OTP_GP_REG_OTP_ACCESS_MODE);
+	else
+		iwl_set_bit(priv, CSR_OTP_GP_REG,
+				CSR_OTP_GP_REG_OTP_ACCESS_MODE);
+}
+
 static int iwlcore_get_nvm_type(struct iwl_priv *priv)
 {
 	u32 otpgp;
@@ -252,6 +265,124 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 	return ret;
 }
 
+static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, u16 *eeprom_data)
+{
+	int ret = 0;
+	u32 r;
+	u32 otpgp;
+
+	_iwl_write32(priv, CSR_EEPROM_REG,
+		     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+	ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
+				  CSR_EEPROM_REG_READ_VALID_MSK,
+				  IWL_EEPROM_ACCESS_TIMEOUT);
+	if (ret < 0) {
+		IWL_ERR(priv, "Time out reading OTP[%d]\n", addr);
+		return ret;
+	}
+	r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
+	/* check for ECC errors: */
+	otpgp = iwl_read32(priv, CSR_OTP_GP_REG);
+	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
+		/* stop in this case */
+		/* set the uncorrectable OTP ECC bit for acknowledgement */
+		iwl_set_bit(priv, CSR_OTP_GP_REG,
+			CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
+		IWL_ERR(priv, "Uncorrectable OTP ECC error, abort OTP read\n");
+		return -EINVAL;
+	}
+	if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
+		/* continue in this case */
+		/* set the correctable OTP ECC bit for acknowledgement */
+		iwl_set_bit(priv, CSR_OTP_GP_REG,
+				CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
+		IWL_ERR(priv, "Correctable OTP ECC error, continue read\n");
+	}
+	*eeprom_data = le16_to_cpu((__force __le16)(r >> 16));
+	return 0;
+}
+
+/*
+ * iwl_is_otp_empty: check for empty OTP
+ */
+static bool iwl_is_otp_empty(struct iwl_priv *priv)
+{
+	u16 next_link_addr = 0, link_value;
+	bool is_empty = false;
+
+	/* locate the beginning of OTP link list */
+	if (!iwl_read_otp_word(priv, next_link_addr, &link_value)) {
+		if (!link_value) {
+			IWL_ERR(priv, "OTP is empty\n");
+			is_empty = true;
+		}
+	} else {
+		IWL_ERR(priv, "Unable to read first block of OTP list.\n");
+		is_empty = true;
+	}
+
+	return is_empty;
+}
+
+
+/*
+ * iwl_find_otp_image: find EEPROM image in OTP
+ *   finding the OTP block that contains the EEPROM image.
+ *   the last valid block on the link list (the block _before_ the last block)
+ *   is the block we should read and used to configure the device.
+ *   If all the available OTP blocks are full, the last block will be the block
+ *   we should read and used to configure the device.
+ *   only perform this operation if shadow RAM is disabled
+ */
+static int iwl_find_otp_image(struct iwl_priv *priv,
+					u16 *validblockaddr)
+{
+	u16 next_link_addr = 0, link_value = 0, valid_addr;
+	int ret = 0;
+	int usedblocks = 0;
+
+	/* set addressing mode to absolute to traverse the link list */
+	iwl_set_otp_access(priv, IWL_OTP_ACCESS_ABSOLUTE);
+
+	/* checking for empty OTP or error */
+	if (iwl_is_otp_empty(priv))
+		return -EINVAL;
+
+	/*
+	 * start traverse link list
+	 * until reach the max number of OTP blocks
+	 * different devices have different number of OTP blocks
+	 */
+	do {
+		/* save current valid block address
+		 * check for more block on the link list
+		 */
+		valid_addr = next_link_addr;
+		next_link_addr = link_value;
+		IWL_DEBUG_INFO(priv, "OTP blocks %d addr 0x%x\n",
+			       usedblocks, next_link_addr);
+		if (iwl_read_otp_word(priv, next_link_addr, &link_value))
+			return -EINVAL;
+		if (!link_value) {
+			/*
+			 * reach the end of link list,
+			 * set address point to the starting address
+			 * of the image
+			 */
+			goto done;
+		}
+		/* more in the link list, continue */
+		usedblocks++;
+	} while (usedblocks < priv->cfg->max_ll_items);
+	/* OTP full, use last block */
+	IWL_DEBUG_INFO(priv, "OTP is full, use last block\n");
+done:
+	*validblockaddr = valid_addr;
+	/* skip first 2 bytes (link list pointer) */
+	*validblockaddr += 2;
+	return ret;
+}
+
 /**
  * iwl_eeprom_init - read EEPROM contents
  *
@@ -266,15 +397,14 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 	int sz;
 	int ret;
 	u16 addr;
-	u32 otpgp;
+	u16 validblockaddr = 0;
+	u16 cache_addr = 0;
 
 	priv->nvm_device_type = iwlcore_get_nvm_type(priv);
 	if (priv->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
-	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
-		priv->cfg->eeprom_size =
-			OTP_BLOCK_SIZE * OTP_LOWER_BLOCKS_TOTAL;
+	IWL_DEBUG_INFO(priv, "NVM size = %d\n", priv->cfg->eeprom_size);
 	sz = priv->cfg->eeprom_size;
 	priv->eeprom = kzalloc(sz, GFP_KERNEL);
 	if (!priv->eeprom) {
@@ -302,46 +432,31 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		if (ret) {
 			IWL_ERR(priv, "Failed to initialize OTP access.\n");
 			ret = -ENOENT;
-			goto err;
+			goto done;
 		}
 		_iwl_write32(priv, CSR_EEPROM_GP,
 			     iwl_read32(priv, CSR_EEPROM_GP) &
 			     ~CSR_EEPROM_GP_IF_OWNER_MSK);
-		/* clear */
-		_iwl_write32(priv, CSR_OTP_GP_REG,
-			     iwl_read32(priv, CSR_OTP_GP_REG) |
+
+		iwl_set_bit(priv, CSR_OTP_GP_REG,
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
-
-		for (addr = 0; addr < sz; addr += sizeof(u16)) {
-			u32 r;
-
-			_iwl_write32(priv, CSR_EEPROM_REG,
-				     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-
-			ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
-						  CSR_EEPROM_REG_READ_VALID_MSK,
-						  IWL_EEPROM_ACCESS_TIMEOUT);
-			if (ret < 0) {
-				IWL_ERR(priv, "Time out reading OTP[%d]\n", addr);
+		/* traversing the linked list if no shadow ram supported */
+		if (!priv->cfg->shadow_ram_support) {
+			if (iwl_find_otp_image(priv, &validblockaddr)) {
+				ret = -ENOENT;
 				goto done;
 			}
-			r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
-			/* check for ECC errors: */
-			otpgp = iwl_read32(priv, CSR_OTP_GP_REG);
-			if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
-				/* stop in this case */
-				IWL_ERR(priv, "Uncorrectable OTP ECC error, Abort OTP read\n");
+		}
+		for (addr = validblockaddr; addr < validblockaddr + sz;
+		     addr += sizeof(u16)) {
+			u16 eeprom_data;
+
+			ret = iwl_read_otp_word(priv, addr, &eeprom_data);
+			if (ret)
 				goto done;
-			}
-			if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
-				/* continue in this case */
-				_iwl_write32(priv, CSR_OTP_GP_REG,
-					     iwl_read32(priv, CSR_OTP_GP_REG) |
-					     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
-				IWL_ERR(priv, "Correctable OTP ECC error, continue read\n");
-			}
-			e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
+			e[cache_addr / 2] = eeprom_data;
+			cache_addr += sizeof(u16);
 		}
 	} else {
 		/* eeprom is an array of 16bit values */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 05d4fc4..ca7920a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -180,8 +180,14 @@ struct iwl_eeprom_channel {
 #define EEPROM_5050_EEPROM_VERSION	(0x21E)
 
 /* OTP */
-#define OTP_LOWER_BLOCKS_TOTAL		(3)
-#define OTP_BLOCK_SIZE			(0x400)
+/* lower blocks contain EEPROM image and calibration data */
+#define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
+/* high blocks contain PAPD data */
+#define OTP_HIGH_IMAGE_SIZE_6x00        (6 * 512 * sizeof(u16)) /* 6 KB */
+#define OTP_HIGH_IMAGE_SIZE_1000        (0x200 * sizeof(u16)) /* 1024 bytes */
+#define OTP_MAX_LL_ITEMS_1000		(3)	/* OTP blocks for 1000 */
+#define OTP_MAX_LL_ITEMS_6x00		(4)	/* OTP blocks for 6x00 */
+#define OTP_MAX_LL_ITEMS_6x50		(7)	/* OTP blocks for 6x50 */
 
 /* 2.4 GHz */
 extern const u8 iwl_eeprom_band_1[14];
-- 
1.5.6.3

