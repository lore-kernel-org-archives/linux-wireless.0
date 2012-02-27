Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45594 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab2B0XTI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/24] iwlwifi: eeprom gets transport and not bus
Date: Mon, 27 Feb 2012 14:07:40 -0800
Message-Id: <1330380468-17674-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001935_119228_56932326)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is temporary, but at least we can now throw the bus away
and move the iwl_pci_{probe,remove} functions.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |  152 +++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    3 +-
 3 files changed, 80 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a0346ed..7e3e00d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1215,7 +1215,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans)
 	 * 4. Read EEPROM
 	 *****************/
 	/* Read the EEPROM */
-	err = iwl_eeprom_init(priv, trans(priv)->hw_rev);
+	err = iwl_eeprom_init(trans(priv), trans(priv)->hw_rev);
 	/* Reset chip to save power until we load uCode during "up". */
 	iwl_trans_stop_hw(trans(priv));
 	if (err) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 5936833..07e9378 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -153,23 +153,23 @@ static const u8 iwl_eeprom_band_7[] = {       /* 5.2 ht40 channel */
 #define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
 #define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
 
-static int iwl_eeprom_acquire_semaphore(struct iwl_bus *bus)
+static int iwl_eeprom_acquire_semaphore(struct iwl_trans *trans)
 {
 	u16 count;
 	int ret;
 
 	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
 		/* Request semaphore */
-		iwl_set_bit(trans(bus), CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 		/* See if we got it */
-		ret = iwl_poll_bit(trans(bus), CSR_HW_IF_CONFIG_REG,
+		ret = iwl_poll_bit(trans, CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				EEPROM_SEM_TIMEOUT);
 		if (ret >= 0) {
-			IWL_DEBUG_EEPROM(trans(bus),
+			IWL_DEBUG_EEPROM(trans,
 				"Acquired semaphore after %d tries.\n",
 				count+1);
 			return ret;
@@ -179,9 +179,9 @@ static int iwl_eeprom_acquire_semaphore(struct iwl_bus *bus)
 	return ret;
 }
 
-static void iwl_eeprom_release_semaphore(struct iwl_bus *bus)
+static void iwl_eeprom_release_semaphore(struct iwl_trans *trans)
 {
-	iwl_clear_bit(trans(bus), CSR_HW_IF_CONFIG_REG,
+	iwl_clear_bit(trans, CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 }
@@ -308,19 +308,20 @@ void iwl_eeprom_get_mac(const struct iwl_shared *shrd, u8 *mac)
  *
 ******************************************************************************/
 
-static void iwl_set_otp_access(struct iwl_bus *bus, enum iwl_access_mode mode)
+static void iwl_set_otp_access(struct iwl_trans *trans,
+			       enum iwl_access_mode mode)
 {
-	iwl_read32(trans(bus), CSR_OTP_GP_REG);
+	iwl_read32(trans, CSR_OTP_GP_REG);
 
 	if (mode == IWL_OTP_ACCESS_ABSOLUTE)
-		iwl_clear_bit(trans(bus), CSR_OTP_GP_REG,
+		iwl_clear_bit(trans, CSR_OTP_GP_REG,
 			      CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 	else
-		iwl_set_bit(trans(bus), CSR_OTP_GP_REG,
+		iwl_set_bit(trans, CSR_OTP_GP_REG,
 			    CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 }
 
-static int iwl_get_nvm_type(struct iwl_bus *bus, u32 hw_rev)
+static int iwl_get_nvm_type(struct iwl_trans *trans, u32 hw_rev)
 {
 	u32 otpgp;
 	int nvm_type;
@@ -328,7 +329,7 @@ static int iwl_get_nvm_type(struct iwl_bus *bus, u32 hw_rev)
 	/* OTP only valid for CP/PP and after */
 	switch (hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_NONE:
-		IWL_ERR(bus, "Unknown hardware type\n");
+		IWL_ERR(trans, "Unknown hardware type\n");
 		return -ENOENT;
 	case CSR_HW_REV_TYPE_5300:
 	case CSR_HW_REV_TYPE_5350:
@@ -337,7 +338,7 @@ static int iwl_get_nvm_type(struct iwl_bus *bus, u32 hw_rev)
 		nvm_type = NVM_DEVICE_TYPE_EEPROM;
 		break;
 	default:
-		otpgp = iwl_read32(trans(bus), CSR_OTP_GP_REG);
+		otpgp = iwl_read32(trans, CSR_OTP_GP_REG);
 		if (otpgp & CSR_OTP_GP_REG_DEVICE_SELECT)
 			nvm_type = NVM_DEVICE_TYPE_OTP;
 		else
@@ -347,73 +348,74 @@ static int iwl_get_nvm_type(struct iwl_bus *bus, u32 hw_rev)
 	return  nvm_type;
 }
 
-static int iwl_init_otp_access(struct iwl_bus *bus)
+static int iwl_init_otp_access(struct iwl_trans *trans)
 {
 	int ret;
 
 	/* Enable 40MHz radio clock */
-	iwl_write32(trans(bus), CSR_GP_CNTRL,
-		    iwl_read32(trans(bus), CSR_GP_CNTRL) |
+	iwl_write32(trans, CSR_GP_CNTRL,
+		    iwl_read32(trans, CSR_GP_CNTRL) |
 		    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock to be ready */
-	ret = iwl_poll_bit(trans(bus), CSR_GP_CNTRL,
+	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				 25000);
 	if (ret < 0)
-		IWL_ERR(bus, "Time out access OTP\n");
+		IWL_ERR(trans, "Time out access OTP\n");
 	else {
-		iwl_set_bits_prph(trans(bus), APMG_PS_CTRL_REG,
+		iwl_set_bits_prph(trans, APMG_PS_CTRL_REG,
 				  APMG_PS_CTRL_VAL_RESET_REQ);
 		udelay(5);
-		iwl_clear_bits_prph(trans(bus), APMG_PS_CTRL_REG,
+		iwl_clear_bits_prph(trans, APMG_PS_CTRL_REG,
 				    APMG_PS_CTRL_VAL_RESET_REQ);
 
 		/*
 		 * CSR auto clock gate disable bit -
 		 * this is only applicable for HW with OTP shadow RAM
 		 */
-		if (cfg(bus)->base_params->shadow_ram_support)
-			iwl_set_bit(trans(bus), CSR_DBG_LINK_PWR_MGMT_REG,
+		if (cfg(trans)->base_params->shadow_ram_support)
+			iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
 				CSR_RESET_LINK_PWR_MGMT_DISABLED);
 	}
 	return ret;
 }
 
-static int iwl_read_otp_word(struct iwl_bus *bus, u16 addr, __le16 *eeprom_data)
+static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
+			     __le16 *eeprom_data)
 {
 	int ret = 0;
 	u32 r;
 	u32 otpgp;
 
-	iwl_write32(trans(bus), CSR_EEPROM_REG,
+	iwl_write32(trans, CSR_EEPROM_REG,
 		    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-	ret = iwl_poll_bit(trans(bus), CSR_EEPROM_REG,
+	ret = iwl_poll_bit(trans, CSR_EEPROM_REG,
 				 CSR_EEPROM_REG_READ_VALID_MSK,
 				 CSR_EEPROM_REG_READ_VALID_MSK,
 				 IWL_EEPROM_ACCESS_TIMEOUT);
 	if (ret < 0) {
-		IWL_ERR(bus, "Time out reading OTP[%d]\n", addr);
+		IWL_ERR(trans, "Time out reading OTP[%d]\n", addr);
 		return ret;
 	}
-	r = iwl_read32(trans(bus), CSR_EEPROM_REG);
+	r = iwl_read32(trans, CSR_EEPROM_REG);
 	/* check for ECC errors: */
-	otpgp = iwl_read32(trans(bus), CSR_OTP_GP_REG);
+	otpgp = iwl_read32(trans, CSR_OTP_GP_REG);
 	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
 		/* stop in this case */
 		/* set the uncorrectable OTP ECC bit for acknowledgement */
-		iwl_set_bit(trans(bus), CSR_OTP_GP_REG,
+		iwl_set_bit(trans, CSR_OTP_GP_REG,
 			CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
-		IWL_ERR(bus, "Uncorrectable OTP ECC error, abort OTP read\n");
+		IWL_ERR(trans, "Uncorrectable OTP ECC error, abort OTP read\n");
 		return -EINVAL;
 	}
 	if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
 		/* continue in this case */
 		/* set the correctable OTP ECC bit for acknowledgement */
-		iwl_set_bit(trans(bus), CSR_OTP_GP_REG,
+		iwl_set_bit(trans, CSR_OTP_GP_REG,
 				CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
-		IWL_ERR(bus, "Correctable OTP ECC error, continue read\n");
+		IWL_ERR(trans, "Correctable OTP ECC error, continue read\n");
 	}
 	*eeprom_data = cpu_to_le16(r >> 16);
 	return 0;
@@ -422,20 +424,20 @@ static int iwl_read_otp_word(struct iwl_bus *bus, u16 addr, __le16 *eeprom_data)
 /*
  * iwl_is_otp_empty: check for empty OTP
  */
-static bool iwl_is_otp_empty(struct iwl_bus *bus)
+static bool iwl_is_otp_empty(struct iwl_trans *trans)
 {
 	u16 next_link_addr = 0;
 	__le16 link_value;
 	bool is_empty = false;
 
 	/* locate the beginning of OTP link list */
-	if (!iwl_read_otp_word(bus, next_link_addr, &link_value)) {
+	if (!iwl_read_otp_word(trans, next_link_addr, &link_value)) {
 		if (!link_value) {
-			IWL_ERR(bus, "OTP is empty\n");
+			IWL_ERR(trans, "OTP is empty\n");
 			is_empty = true;
 		}
 	} else {
-		IWL_ERR(bus, "Unable to read first block of OTP list.\n");
+		IWL_ERR(trans, "Unable to read first block of OTP list.\n");
 		is_empty = true;
 	}
 
@@ -452,7 +454,7 @@ static bool iwl_is_otp_empty(struct iwl_bus *bus)
  *   we should read and used to configure the device.
  *   only perform this operation if shadow RAM is disabled
  */
-static int iwl_find_otp_image(struct iwl_bus *bus,
+static int iwl_find_otp_image(struct iwl_trans *trans,
 					u16 *validblockaddr)
 {
 	u16 next_link_addr = 0, valid_addr;
@@ -460,10 +462,10 @@ static int iwl_find_otp_image(struct iwl_bus *bus,
 	int usedblocks = 0;
 
 	/* set addressing mode to absolute to traverse the link list */
-	iwl_set_otp_access(bus, IWL_OTP_ACCESS_ABSOLUTE);
+	iwl_set_otp_access(trans, IWL_OTP_ACCESS_ABSOLUTE);
 
 	/* checking for empty OTP or error */
-	if (iwl_is_otp_empty(bus))
+	if (iwl_is_otp_empty(trans))
 		return -EINVAL;
 
 	/*
@@ -477,9 +479,9 @@ static int iwl_find_otp_image(struct iwl_bus *bus,
 		 */
 		valid_addr = next_link_addr;
 		next_link_addr = le16_to_cpu(link_value) * sizeof(u16);
-		IWL_DEBUG_EEPROM(bus, "OTP blocks %d addr 0x%x\n",
+		IWL_DEBUG_EEPROM(trans, "OTP blocks %d addr 0x%x\n",
 			       usedblocks, next_link_addr);
-		if (iwl_read_otp_word(bus, next_link_addr, &link_value))
+		if (iwl_read_otp_word(trans, next_link_addr, &link_value))
 			return -EINVAL;
 		if (!link_value) {
 			/*
@@ -494,10 +496,10 @@ static int iwl_find_otp_image(struct iwl_bus *bus,
 		}
 		/* more in the link list, continue */
 		usedblocks++;
-	} while (usedblocks <= cfg(bus)->base_params->max_ll_items);
+	} while (usedblocks <= cfg(trans)->base_params->max_ll_items);
 
 	/* OTP has no valid blocks */
-	IWL_DEBUG_EEPROM(bus, "OTP has no valid blocks\n");
+	IWL_DEBUG_EEPROM(trans, "OTP has no valid blocks\n");
 	return -EINVAL;
 }
 
@@ -657,63 +659,62 @@ void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
-int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
+int iwl_eeprom_init(struct iwl_trans *trans, u32 hw_rev)
 {
-	struct iwl_shared *shrd = priv->shrd;
 	__le16 *e;
-	u32 gp = iwl_read32(trans(priv), CSR_EEPROM_GP);
+	u32 gp = iwl_read32(trans, CSR_EEPROM_GP);
 	int sz;
 	int ret;
 	u16 addr;
 	u16 validblockaddr = 0;
 	u16 cache_addr = 0;
 
-	trans(priv)->nvm_device_type = iwl_get_nvm_type(bus(priv), hw_rev);
-	if (trans(priv)->nvm_device_type == -ENOENT)
+	trans->nvm_device_type = iwl_get_nvm_type(trans, hw_rev);
+	if (trans->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
-	sz = cfg(priv)->base_params->eeprom_size;
-	IWL_DEBUG_EEPROM(priv, "NVM size = %d\n", sz);
-	shrd->eeprom = kzalloc(sz, GFP_KERNEL);
-	if (!shrd->eeprom) {
+	sz = cfg(trans)->base_params->eeprom_size;
+	IWL_DEBUG_EEPROM(trans, "NVM size = %d\n", sz);
+	trans->shrd->eeprom = kzalloc(sz, GFP_KERNEL);
+	if (!trans->shrd->eeprom) {
 		ret = -ENOMEM;
 		goto alloc_err;
 	}
-	e = (__le16 *)shrd->eeprom;
+	e = (__le16 *)trans->shrd->eeprom;
 
-	ret = iwl_eeprom_verify_signature(trans(priv));
+	ret = iwl_eeprom_verify_signature(trans);
 	if (ret < 0) {
-		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
+		IWL_ERR(trans, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		ret = -ENOENT;
 		goto err;
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = iwl_eeprom_acquire_semaphore(bus(priv));
+	ret = iwl_eeprom_acquire_semaphore(trans);
 	if (ret < 0) {
-		IWL_ERR(priv, "Failed to acquire EEPROM semaphore.\n");
+		IWL_ERR(trans, "Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
 		goto err;
 	}
 
-	if (trans(priv)->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
+	if (trans->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
 
-		ret = iwl_init_otp_access(bus(priv));
+		ret = iwl_init_otp_access(trans);
 		if (ret) {
-			IWL_ERR(priv, "Failed to initialize OTP access.\n");
+			IWL_ERR(trans, "Failed to initialize OTP access.\n");
 			ret = -ENOENT;
 			goto done;
 		}
-		iwl_write32(trans(priv), CSR_EEPROM_GP,
-			    iwl_read32(trans(priv), CSR_EEPROM_GP) &
+		iwl_write32(trans, CSR_EEPROM_GP,
+			    iwl_read32(trans, CSR_EEPROM_GP) &
 			    ~CSR_EEPROM_GP_IF_OWNER_MSK);
 
-		iwl_set_bit(trans(priv), CSR_OTP_GP_REG,
+		iwl_set_bit(trans, CSR_OTP_GP_REG,
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
-		if (!cfg(priv)->base_params->shadow_ram_support) {
-			if (iwl_find_otp_image(bus(priv), &validblockaddr)) {
+		if (!cfg(trans)->base_params->shadow_ram_support) {
+			if (iwl_find_otp_image(trans, &validblockaddr)) {
 				ret = -ENOENT;
 				goto done;
 			}
@@ -722,7 +723,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 		     addr += sizeof(u16)) {
 			__le16 eeprom_data;
 
-			ret = iwl_read_otp_word(bus(priv), addr, &eeprom_data);
+			ret = iwl_read_otp_word(trans, addr, &eeprom_data);
 			if (ret)
 				goto done;
 			e[cache_addr / 2] = eeprom_data;
@@ -733,34 +734,35 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 		for (addr = 0; addr < sz; addr += sizeof(u16)) {
 			u32 r;
 
-			iwl_write32(trans(priv), CSR_EEPROM_REG,
+			iwl_write32(trans, CSR_EEPROM_REG,
 				    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
-			ret = iwl_poll_bit(trans(priv), CSR_EEPROM_REG,
+			ret = iwl_poll_bit(trans, CSR_EEPROM_REG,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  IWL_EEPROM_ACCESS_TIMEOUT);
 			if (ret < 0) {
-				IWL_ERR(priv, "Time out reading EEPROM[%d]\n", addr);
+				IWL_ERR(trans,
+					"Time out reading EEPROM[%d]\n", addr);
 				goto done;
 			}
-			r = iwl_read32(trans(priv), CSR_EEPROM_REG);
+			r = iwl_read32(trans, CSR_EEPROM_REG);
 			e[addr / 2] = cpu_to_le16(r >> 16);
 		}
 	}
 
-	IWL_DEBUG_EEPROM(priv, "NVM Type: %s, version: 0x%x\n",
-		       (trans(priv)->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+	IWL_DEBUG_EEPROM(trans, "NVM Type: %s, version: 0x%x\n",
+		       (trans->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 		       ? "OTP" : "EEPROM",
-		       iwl_eeprom_query16(shrd, EEPROM_VERSION));
+		       iwl_eeprom_query16(trans->shrd, EEPROM_VERSION));
 
 	ret = 0;
 done:
-	iwl_eeprom_release_semaphore(bus(priv));
+	iwl_eeprom_release_semaphore(trans);
 
 err:
 	if (ret)
-		iwl_eeprom_free(priv->shrd);
+		iwl_eeprom_free(trans->shrd);
 alloc_err:
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 13f2d39..cbb8611 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -67,6 +67,7 @@
 
 struct iwl_priv;
 struct iwl_shared;
+struct iwl_trans;
 
 /*
  * EEPROM access time values:
@@ -305,7 +306,7 @@ struct iwl_eeprom_ops {
 };
 
 
-int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev);
+int iwl_eeprom_init(struct iwl_trans *trans, u32 hw_rev);
 void iwl_eeprom_free(struct iwl_shared *shrd);
 int  iwl_eeprom_check_version(struct iwl_priv *priv);
 int  iwl_eeprom_check_sku(struct iwl_priv *priv);
-- 
1.7.0.4

