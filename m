Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38989 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZI3WgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 18:36:13 -0400
Subject: Re: [stable] Making Intel WiFi Link 1000 usable in 2.6.31
From: reinette chatre <reinette.chatre@intel.com>
To: Greg KH <greg@kroah.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090930212447.GB30093@kroah.com>
References: <1254339259.26521.1645.camel@rc-desk>
	 <20090930212447.GB30093@kroah.com>
Content-Type: multipart/mixed; boundary="=-TVffhiuTxBkKU8x+a8fj"
Date: Wed, 30 Sep 2009 15:36:15 -0700
Message-Id: <1254350175.26521.1662.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TVffhiuTxBkKU8x+a8fj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2009-09-30 at 14:24 -0700, Greg KH wrote:
> On Wed, Sep 30, 2009 at 12:34:19PM -0700, reinette chatre wrote:
> > commit cc0f555d511a5fe9d4519334c8f674a1dbab9e3a
> > Author: Jay Sternberg <jay.e.sternberg@intel.com>
> > Date:   Fri Jul 17 09:30:16 2009 -0700
> > 
> >     iwlwifi: Handle new firmware file with ucode build number in header
> > 
> > commit cce53aa347c1e023d967b1cb1aa393c725aedba5
> > Author: Jay Sternberg <jay.e.sternberg@intel.com>
> > Date:   Fri Jul 17 09:30:22 2009 -0700
> > 
> >     iwlwifi: update 1000 series API version to match firmware
> > 
> > commit 02c06e4abc0680afd31bf481a803541556757fb6
> > Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > Date:   Fri Jul 17 09:30:14 2009 -0700
> > 
> >     iwlagn: modify digital SVR for 1000
> > 
> > commit 415e49936b4b29b34c2fb561eeab867d41fc43a6
> > Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > Date:   Thu Aug 13 13:30:54 2009 -0700
> > 
> >     iwlwifi: traverse linklist to find the valid OTP block
> > 
> > commit f7ea097d9b4e61a816c041c92548aad7c7ed7915
> > Author: Reinette Chatre <reinette.chatre@intel.com>
> > Date:   Fri Jul 24 11:13:12 2009 -0700
> > 
> >     iwlagn: fix null pointer access during ucode load on 1000
> > 
> > Thank you very much
> 
> Is this the order in which they should be applied?

The first three patches from this list can be applied directly from
linux-2.6 in the order they appear here. That is:

commit cc0f555d511a5fe9d4519334c8f674a1dbab9e3a
Author: Jay Sternberg <jay.e.sternberg@intel.com>
Date:   Fri Jul 17 09:30:16 2009 -0700

    iwlwifi: Handle new firmware file with ucode build number in header

commit cce53aa347c1e023d967b1cb1aa393c725aedba5
Author: Jay Sternberg <jay.e.sternberg@intel.com>
Date:   Fri Jul 17 09:30:22 2009 -0700

    iwlwifi: update 1000 series API version to match firmware

commit 02c06e4abc0680afd31bf481a803541556757fb6
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Fri Jul 17 09:30:14 2009 -0700

    iwlagn: modify digital SVR for 1000


The fourth patch needed backporting and is attached. 

After doing the backporting I determined that the fifth patch is not
needed.

Thank you very much for taking these patches

Reinette



--=-TVffhiuTxBkKU8x+a8fj
Content-Disposition: attachment; filename*0=0001-iwlwifi-traverse-linklist-to-find-the-valid-OTP-blo.patc; filename*1=h
Content-Type: text/x-patch; name="0001-iwlwifi-traverse-linklist-to-find-the-valid-OTP-blo.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 07c88863a94534f36668ed543555e020c949990e Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Thu, 13 Aug 2009 13:30:54 -0700
Subject: [PATCH] iwlwifi: traverse linklist to find the valid OTP block

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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   20 +++-
 drivers/net/wireless/iwlwifi/iwl-core.h   |    4 +
 drivers/net/wireless/iwlwifi/iwl-dev.h    |   12 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |  185 +++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |   10 ++-
 6 files changed, 192 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index a899be9..d83d430 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -62,12 +62,14 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
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
index 26c5d4a..e4a405f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -82,13 +82,15 @@ struct iwl_cfg iwl6000_2ag_cfg = {
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.need_pll_cfg = false,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 struct iwl_cfg iwl6000_2agn_cfg = {
@@ -98,13 +100,15 @@ struct iwl_cfg iwl6000_2agn_cfg = {
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -114,13 +118,15 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -130,13 +136,15 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = false,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -146,13 +154,15 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = false,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e460eb6..1e51891 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -207,6 +207,8 @@ struct iwl_mod_params {
  * 	filename is constructed as fw_name_pre<api>.ucode.
  * @ucode_api_max: Highest version of uCode API supported by driver.
  * @ucode_api_min: Lowest version of uCode API supported by driver.
+ * @max_ll_items: max number of OTP blocks
+ * @shadow_ram_support: shadow support for OTP memory
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -243,6 +245,8 @@ struct iwl_cfg {
 	u8   valid_rx_ant;
 	bool need_pll_cfg;
 	bool use_isr_legacy;
+	const u16 max_ll_items;
+	const bool shadow_ram_support;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5491041..e8c8607 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -835,6 +835,18 @@ enum iwl_nvm_type {
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
+
 /* interrupt statistics */
 struct isr_statistics {
 	u32 hw;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 7d7554a..e8c0e82 100644
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
@@ -249,6 +262,124 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
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
@@ -263,14 +394,13 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 	int sz;
 	int ret;
 	u16 addr;
-	u32 otpgp;
+	u16 validblockaddr = 0;
+	u16 cache_addr = 0;
 
 	priv->nvm_device_type = iwlcore_get_nvm_type(priv);
 
 	/* allocate eeprom */
-	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
-		priv->cfg->eeprom_size =
-			OTP_BLOCK_SIZE * OTP_LOWER_BLOCKS_TOTAL;
+	IWL_DEBUG_INFO(priv, "NVM size = %d\n", priv->cfg->eeprom_size);
 	sz = priv->cfg->eeprom_size;
 	priv->eeprom = kzalloc(sz, GFP_KERNEL);
 	if (!priv->eeprom) {
@@ -298,46 +428,31 @@ int iwl_eeprom_init(struct iwl_priv *priv)
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
index 195b4ef..7899885 100644
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


--=-TVffhiuTxBkKU8x+a8fj--

