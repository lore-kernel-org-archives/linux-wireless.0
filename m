Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929Ab1KJBdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 27/28] iwlagn: Remove dependence of iwl_priv from eeprom routines.
Date: Wed,  9 Nov 2011 16:39:30 -0800
Message-Id: <1320885571-19122-28-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023350_622034_47DBEBD6)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Make the eeprom routines less dependent on the iwl_priv structure.
Don't use the priv when bus structure is sufficient.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |  116 ++++++++++++++--------------
 1 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index a4e43bd..2fcde58 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -149,23 +149,23 @@ static const u8 iwl_eeprom_band_7[] = {       /* 5.2 ht40 channel */
  * EEPROM chip, not a single event, so even reads could conflict if they
  * weren't arbitrated by the semaphore.
  */
-static int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv)
+static int iwl_eeprom_acquire_semaphore(struct iwl_bus *bus)
 {
 	u16 count;
 	int ret;
 
 	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
 		/* Request semaphore */
-		iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(bus, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 		/* See if we got it */
-		ret = iwl_poll_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
+		ret = iwl_poll_bit(bus, CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				EEPROM_SEM_TIMEOUT);
 		if (ret >= 0) {
-			IWL_DEBUG_EEPROM(priv,
+			IWL_DEBUG_EEPROM(bus,
 				"Acquired semaphore after %d tries.\n",
 				count+1);
 			return ret;
@@ -175,9 +175,9 @@ static int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv)
 	return ret;
 }
 
-static void iwl_eeprom_release_semaphore(struct iwl_priv *priv)
+static void iwl_eeprom_release_semaphore(struct iwl_bus *bus)
 {
-	iwl_clear_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
+	iwl_clear_bit(bus, CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 }
@@ -302,19 +302,19 @@ void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac)
  *
 ******************************************************************************/
 
-static void iwl_set_otp_access(struct iwl_priv *priv, enum iwl_access_mode mode)
+static void iwl_set_otp_access(struct iwl_bus *bus, enum iwl_access_mode mode)
 {
-	iwl_read32(bus(priv), CSR_OTP_GP_REG);
+	iwl_read32(bus, CSR_OTP_GP_REG);
 
 	if (mode == IWL_OTP_ACCESS_ABSOLUTE)
-		iwl_clear_bit(bus(priv), CSR_OTP_GP_REG,
+		iwl_clear_bit(bus, CSR_OTP_GP_REG,
 			      CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 	else
-		iwl_set_bit(bus(priv), CSR_OTP_GP_REG,
+		iwl_set_bit(bus, CSR_OTP_GP_REG,
 			    CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 }
 
-static int iwl_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
+static int iwl_get_nvm_type(struct iwl_bus *bus, u32 hw_rev)
 {
 	u32 otpgp;
 	int nvm_type;
@@ -322,7 +322,7 @@ static int iwl_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
 	/* OTP only valid for CP/PP and after */
 	switch (hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_NONE:
-		IWL_ERR(priv, "Unknown hardware type\n");
+		IWL_ERR(bus, "Unknown hardware type\n");
 		return -ENOENT;
 	case CSR_HW_REV_TYPE_5300:
 	case CSR_HW_REV_TYPE_5350:
@@ -331,7 +331,7 @@ static int iwl_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
 		nvm_type = NVM_DEVICE_TYPE_EEPROM;
 		break;
 	default:
-		otpgp = iwl_read32(bus(priv), CSR_OTP_GP_REG);
+		otpgp = iwl_read32(bus, CSR_OTP_GP_REG);
 		if (otpgp & CSR_OTP_GP_REG_DEVICE_SELECT)
 			nvm_type = NVM_DEVICE_TYPE_OTP;
 		else
@@ -341,73 +341,73 @@ static int iwl_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
 	return  nvm_type;
 }
 
-static int iwl_init_otp_access(struct iwl_priv *priv)
+static int iwl_init_otp_access(struct iwl_bus *bus)
 {
 	int ret;
 
 	/* Enable 40MHz radio clock */
-	iwl_write32(bus(priv), CSR_GP_CNTRL,
-		    iwl_read32(bus(priv), CSR_GP_CNTRL) |
+	iwl_write32(bus, CSR_GP_CNTRL,
+		    iwl_read32(bus, CSR_GP_CNTRL) |
 		    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock to be ready */
-	ret = iwl_poll_bit(bus(priv), CSR_GP_CNTRL,
+	ret = iwl_poll_bit(bus, CSR_GP_CNTRL,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				 25000);
 	if (ret < 0)
-		IWL_ERR(priv, "Time out access OTP\n");
+		IWL_ERR(bus, "Time out access OTP\n");
 	else {
-		iwl_set_bits_prph(bus(priv), APMG_PS_CTRL_REG,
+		iwl_set_bits_prph(bus, APMG_PS_CTRL_REG,
 				  APMG_PS_CTRL_VAL_RESET_REQ);
 		udelay(5);
-		iwl_clear_bits_prph(bus(priv), APMG_PS_CTRL_REG,
+		iwl_clear_bits_prph(bus, APMG_PS_CTRL_REG,
 				    APMG_PS_CTRL_VAL_RESET_REQ);
 
 		/*
 		 * CSR auto clock gate disable bit -
 		 * this is only applicable for HW with OTP shadow RAM
 		 */
-		if (priv->cfg->base_params->shadow_ram_support)
-			iwl_set_bit(bus(priv), CSR_DBG_LINK_PWR_MGMT_REG,
+		if (priv(bus)->cfg->base_params->shadow_ram_support)
+			iwl_set_bit(bus, CSR_DBG_LINK_PWR_MGMT_REG,
 				CSR_RESET_LINK_PWR_MGMT_DISABLED);
 	}
 	return ret;
 }
 
-static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, __le16 *eeprom_data)
+static int iwl_read_otp_word(struct iwl_bus *bus, u16 addr, __le16 *eeprom_data)
 {
 	int ret = 0;
 	u32 r;
 	u32 otpgp;
 
-	iwl_write32(bus(priv), CSR_EEPROM_REG,
+	iwl_write32(bus, CSR_EEPROM_REG,
 		    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-	ret = iwl_poll_bit(bus(priv), CSR_EEPROM_REG,
+	ret = iwl_poll_bit(bus, CSR_EEPROM_REG,
 				 CSR_EEPROM_REG_READ_VALID_MSK,
 				 CSR_EEPROM_REG_READ_VALID_MSK,
 				 IWL_EEPROM_ACCESS_TIMEOUT);
 	if (ret < 0) {
-		IWL_ERR(priv, "Time out reading OTP[%d]\n", addr);
+		IWL_ERR(bus, "Time out reading OTP[%d]\n", addr);
 		return ret;
 	}
-	r = iwl_read32(bus(priv), CSR_EEPROM_REG);
+	r = iwl_read32(bus, CSR_EEPROM_REG);
 	/* check for ECC errors: */
-	otpgp = iwl_read32(bus(priv), CSR_OTP_GP_REG);
+	otpgp = iwl_read32(bus, CSR_OTP_GP_REG);
 	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
 		/* stop in this case */
 		/* set the uncorrectable OTP ECC bit for acknowledgement */
-		iwl_set_bit(bus(priv), CSR_OTP_GP_REG,
+		iwl_set_bit(bus, CSR_OTP_GP_REG,
 			CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
-		IWL_ERR(priv, "Uncorrectable OTP ECC error, abort OTP read\n");
+		IWL_ERR(bus, "Uncorrectable OTP ECC error, abort OTP read\n");
 		return -EINVAL;
 	}
 	if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
 		/* continue in this case */
 		/* set the correctable OTP ECC bit for acknowledgement */
-		iwl_set_bit(bus(priv), CSR_OTP_GP_REG,
+		iwl_set_bit(bus, CSR_OTP_GP_REG,
 				CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
-		IWL_ERR(priv, "Correctable OTP ECC error, continue read\n");
+		IWL_ERR(bus, "Correctable OTP ECC error, continue read\n");
 	}
 	*eeprom_data = cpu_to_le16(r >> 16);
 	return 0;
@@ -416,20 +416,20 @@ static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, __le16 *eeprom_dat
 /*
  * iwl_is_otp_empty: check for empty OTP
  */
-static bool iwl_is_otp_empty(struct iwl_priv *priv)
+static bool iwl_is_otp_empty(struct iwl_bus *bus)
 {
 	u16 next_link_addr = 0;
 	__le16 link_value;
 	bool is_empty = false;
 
 	/* locate the beginning of OTP link list */
-	if (!iwl_read_otp_word(priv, next_link_addr, &link_value)) {
+	if (!iwl_read_otp_word(bus, next_link_addr, &link_value)) {
 		if (!link_value) {
-			IWL_ERR(priv, "OTP is empty\n");
+			IWL_ERR(bus, "OTP is empty\n");
 			is_empty = true;
 		}
 	} else {
-		IWL_ERR(priv, "Unable to read first block of OTP list.\n");
+		IWL_ERR(bus, "Unable to read first block of OTP list.\n");
 		is_empty = true;
 	}
 
@@ -446,7 +446,7 @@ static bool iwl_is_otp_empty(struct iwl_priv *priv)
  *   we should read and used to configure the device.
  *   only perform this operation if shadow RAM is disabled
  */
-static int iwl_find_otp_image(struct iwl_priv *priv,
+static int iwl_find_otp_image(struct iwl_bus *bus,
 					u16 *validblockaddr)
 {
 	u16 next_link_addr = 0, valid_addr;
@@ -454,10 +454,10 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 	int usedblocks = 0;
 
 	/* set addressing mode to absolute to traverse the link list */
-	iwl_set_otp_access(priv, IWL_OTP_ACCESS_ABSOLUTE);
+	iwl_set_otp_access(bus, IWL_OTP_ACCESS_ABSOLUTE);
 
 	/* checking for empty OTP or error */
-	if (iwl_is_otp_empty(priv))
+	if (iwl_is_otp_empty(bus))
 		return -EINVAL;
 
 	/*
@@ -471,9 +471,9 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 		 */
 		valid_addr = next_link_addr;
 		next_link_addr = le16_to_cpu(link_value) * sizeof(u16);
-		IWL_DEBUG_EEPROM(priv, "OTP blocks %d addr 0x%x\n",
+		IWL_DEBUG_EEPROM(bus, "OTP blocks %d addr 0x%x\n",
 			       usedblocks, next_link_addr);
-		if (iwl_read_otp_word(priv, next_link_addr, &link_value))
+		if (iwl_read_otp_word(bus, next_link_addr, &link_value))
 			return -EINVAL;
 		if (!link_value) {
 			/*
@@ -488,10 +488,10 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 		}
 		/* more in the link list, continue */
 		usedblocks++;
-	} while (usedblocks <= priv->cfg->base_params->max_ll_items);
+	} while (usedblocks <= priv(bus)->cfg->base_params->max_ll_items);
 
 	/* OTP has no valid blocks */
-	IWL_DEBUG_EEPROM(priv, "OTP has no valid blocks\n");
+	IWL_DEBUG_EEPROM(bus, "OTP has no valid blocks\n");
 	return -EINVAL;
 }
 
@@ -504,28 +504,28 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
  * iwl_get_max_txpower_avg - get the highest tx power from all chains.
  *     find the highest tx power from all chains for the channel
  */
-static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
+static s8 iwl_get_max_txpower_avg(struct iwl_cfg *cfg,
 		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
 		int element, s8 *max_txpower_in_half_dbm)
 {
 	s8 max_txpower_avg = 0; /* (dBm) */
 
 	/* Take the highest tx power from any valid chains */
-	if ((priv->cfg->valid_tx_ant & ANT_A) &&
+	if ((cfg->valid_tx_ant & ANT_A) &&
 	    (enhanced_txpower[element].chain_a_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].chain_a_max;
-	if ((priv->cfg->valid_tx_ant & ANT_B) &&
+	if ((cfg->valid_tx_ant & ANT_B) &&
 	    (enhanced_txpower[element].chain_b_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].chain_b_max;
-	if ((priv->cfg->valid_tx_ant & ANT_C) &&
+	if ((cfg->valid_tx_ant & ANT_C) &&
 	    (enhanced_txpower[element].chain_c_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].chain_c_max;
-	if (((priv->cfg->valid_tx_ant == ANT_AB) |
-	    (priv->cfg->valid_tx_ant == ANT_BC) |
-	    (priv->cfg->valid_tx_ant == ANT_AC)) &&
+	if (((cfg->valid_tx_ant == ANT_AB) |
+	    (cfg->valid_tx_ant == ANT_BC) |
+	    (cfg->valid_tx_ant == ANT_AC)) &&
 	    (enhanced_txpower[element].mimo2_max > max_txpower_avg))
 		max_txpower_avg =  enhanced_txpower[element].mimo2_max;
-	if ((priv->cfg->valid_tx_ant == ANT_ABC) &&
+	if ((cfg->valid_tx_ant == ANT_ABC) &&
 	    (enhanced_txpower[element].mimo3_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].mimo3_max;
 
@@ -627,7 +627,7 @@ void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 				 ((txp->delta_20_in_40 & 0xf0) >> 4),
 				 (txp->delta_20_in_40 & 0x0f));
 
-		max_txp_avg = iwl_get_max_txpower_avg(priv, txp_array, idx,
+		max_txp_avg = iwl_get_max_txpower_avg(priv->cfg, txp_array, idx,
 						      &max_txp_avg_halfdbm);
 
 		/*
@@ -660,7 +660,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	u16 validblockaddr = 0;
 	u16 cache_addr = 0;
 
-	priv->nvm_device_type = iwl_get_nvm_type(priv, hw_rev);
+	priv->nvm_device_type = iwl_get_nvm_type(bus(priv), hw_rev);
 	if (priv->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
@@ -683,7 +683,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = iwl_eeprom_acquire_semaphore(priv);
+	ret = iwl_eeprom_acquire_semaphore(bus(priv));
 	if (ret < 0) {
 		IWL_ERR(priv, "Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
@@ -692,7 +692,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 
 	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
 
-		ret = iwl_init_otp_access(priv);
+		ret = iwl_init_otp_access(bus(priv));
 		if (ret) {
 			IWL_ERR(priv, "Failed to initialize OTP access.\n");
 			ret = -ENOENT;
@@ -707,7 +707,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
 		if (!priv->cfg->base_params->shadow_ram_support) {
-			if (iwl_find_otp_image(priv, &validblockaddr)) {
+			if (iwl_find_otp_image(bus(priv), &validblockaddr)) {
 				ret = -ENOENT;
 				goto done;
 			}
@@ -716,7 +716,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 		     addr += sizeof(u16)) {
 			__le16 eeprom_data;
 
-			ret = iwl_read_otp_word(priv, addr, &eeprom_data);
+			ret = iwl_read_otp_word(bus(priv), addr, &eeprom_data);
 			if (ret)
 				goto done;
 			e[cache_addr / 2] = eeprom_data;
@@ -750,7 +750,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 
 	ret = 0;
 done:
-	iwl_eeprom_release_semaphore(priv);
+	iwl_eeprom_release_semaphore(bus(priv));
 
 err:
 	if (ret)
-- 
1.7.0.4

