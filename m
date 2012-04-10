Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab2DJAuY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:24 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/11] iwlwifi: move eeprom into priv
Date: Mon,  9 Apr 2012 17:46:58 -0700
Message-Id: <1334018821-30416-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025030_026131_9E6D8F53)
In-Reply-To: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The whole code around eeprom is distributed
across whole bunch of different files, most
of which belong to the to-be-DVM code. As a
result, it is currently very hard to split
out the EEPROM code to be generic. However,
it is also quite unlikely that the current
EEPROM code will be needed by the MVM code
as that has different mechanisms to query
the EEPROM (it does so through the uCode.)

So, at least temporarily, move everything
into priv. If it becomes necessary to use
the code from MVM, we will have to split it
out, but then it's also easier since we'll
know what pieces we need.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   62 ---------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   13 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    4 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |  190 +++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |   14 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    4 -
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    2 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |   12 +-
 13 files changed, 155 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8870370..056d552 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -126,10 +126,10 @@ static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
 
 #define IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF	(-5)
 
-static s32 iwl_temp_calib_to_offset(struct iwl_shared *shrd)
+static s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
 {
 	u16 temperature, voltage;
-	__le16 *temp_calib = (__le16 *)iwl_eeprom_query_addr(shrd,
+	__le16 *temp_calib = (__le16 *)iwl_eeprom_query_addr(priv,
 				EEPROM_KELVIN_TEMPERATURE);
 
 	temperature = le16_to_cpu(temp_calib[0]);
@@ -143,7 +143,7 @@ static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
 {
 	const s32 volt2temp_coef = IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF;
 	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY) -
-			iwl_temp_calib_to_offset(priv->shrd);
+			iwl_temp_calib_to_offset(priv);
 
 	priv->hw_params.ct_kill_threshold = threshold * volt2temp_coef;
 }
@@ -189,7 +189,7 @@ static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 static void iwl5150_temperature(struct iwl_priv *priv)
 {
 	u32 vt = 0;
-	s32 offset =  iwl_temp_calib_to_offset(priv->shrd);
+	s32 offset =  iwl_temp_calib_to_offset(priv);
 
 	vt = le32_to_cpu(priv->statistics.common.temperature);
 	vt = vt / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF + offset;
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index dc07560..5c8987b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -81,7 +81,7 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
-	if (iwl_eeprom_calib_version(priv->shrd) >= 6)
+	if (iwl_eeprom_calib_version(priv) >= 6)
 		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 }
@@ -89,7 +89,7 @@ static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 static void iwl6150_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
-	if (iwl_eeprom_calib_version(priv->shrd) >= 6)
+	if (iwl_eeprom_calib_version(priv) >= 6)
 		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 	iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index fb6fe7f..4faaccb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -94,68 +94,6 @@ void iwlagn_temperature(struct iwl_priv *priv)
 	iwl_tt_handler(priv);
 }
 
-u16 iwl_eeprom_calib_version(struct iwl_shared *shrd)
-{
-	struct iwl_eeprom_calib_hdr *hdr;
-
-	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(shrd,
-							EEPROM_CALIB_ALL);
-	return hdr->version;
-
-}
-
-/*
- * EEPROM
- */
-static u32 eeprom_indirect_address(const struct iwl_shared *shrd, u32 address)
-{
-	u16 offset = 0;
-
-	if ((address & INDIRECT_ADDRESS) == 0)
-		return address;
-
-	switch (address & INDIRECT_TYPE_MSK) {
-	case INDIRECT_HOST:
-		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_HOST);
-		break;
-	case INDIRECT_GENERAL:
-		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_GENERAL);
-		break;
-	case INDIRECT_REGULATORY:
-		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_REGULATORY);
-		break;
-	case INDIRECT_TXP_LIMIT:
-		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_TXP_LIMIT);
-		break;
-	case INDIRECT_TXP_LIMIT_SIZE:
-		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_TXP_LIMIT_SIZE);
-		break;
-	case INDIRECT_CALIBRATION:
-		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_CALIBRATION);
-		break;
-	case INDIRECT_PROCESS_ADJST:
-		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_PROCESS_ADJST);
-		break;
-	case INDIRECT_OTHERS:
-		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_OTHERS);
-		break;
-	default:
-		IWL_ERR(shrd->trans, "illegal indirect type: 0x%X\n",
-		address & INDIRECT_TYPE_MSK);
-		break;
-	}
-
-	/* translate the offset from words to byte */
-	return (address & ADDRESS_MSK) + (offset << 1);
-}
-
-const u8 *iwl_eeprom_query_addr(const struct iwl_shared *shrd, size_t offset)
-{
-	u32 address = eeprom_indirect_address(shrd, offset);
-	BUG_ON(address >= shrd->cfg->base_params->eeprom_size);
-	return &shrd->eeprom[address];
-}
-
 struct iwl_mod_params iwlagn_mod_params = {
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c41c4c5..ab996f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1547,11 +1547,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	if (iwl_trans_start_hw(trans(priv)))
 		goto out_free_traffic_mem;
 
-	/*****************
-	 * 3. Read EEPROM
-	 *****************/
 	/* Read the EEPROM */
-	if (iwl_eeprom_init(trans(priv), trans(priv)->hw_rev)) {
+	if (iwl_eeprom_init(priv, trans(priv)->hw_rev)) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_free_traffic_mem;
 	}
@@ -1565,11 +1562,11 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		goto out_free_eeprom;
 
 	/* extract MAC Address */
-	iwl_eeprom_get_mac(priv->shrd, priv->addresses[0].addr);
+	iwl_eeprom_get_mac(priv, priv->addresses[0].addr);
 	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->addresses[0].addr);
 	priv->hw->wiphy->addresses = priv->addresses;
 	priv->hw->wiphy->n_addresses = 1;
-	num_mac = iwl_eeprom_query16(priv->shrd, EEPROM_NUM_MAC_ADDRESS);
+	num_mac = iwl_eeprom_query16(priv, EEPROM_NUM_MAC_ADDRESS);
 	if (num_mac > 1) {
 		memcpy(priv->addresses[1].addr, priv->addresses[0].addr,
 		       ETH_ALEN);
@@ -1667,7 +1664,7 @@ out_destroy_workqueue:
 	priv->workqueue = NULL;
 	iwl_uninit_drv(priv);
 out_free_eeprom:
-	iwl_eeprom_free(priv->shrd);
+	iwl_eeprom_free(priv);
 out_free_traffic_mem:
 	iwl_free_traffic_mem(priv);
 	ieee80211_free_hw(priv->hw);
@@ -1693,7 +1690,7 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	priv->ucode_loaded = false;
 	iwl_trans_stop_device(trans(priv));
 
-	iwl_eeprom_free(priv->shrd);
+	iwl_eeprom_free(priv);
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index da5ea1b..17b82e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -138,7 +138,6 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
-u16 iwl_eeprom_calib_version(struct iwl_shared *shrd);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
@@ -312,9 +311,6 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 	return cpu_to_le32(flags|(u32)rate);
 }
 
-/* eeprom */
-void iwl_eeprom_get_mac(const struct iwl_shared *shrd, u8 *mac);
-
 extern int iwl_alive_start(struct iwl_priv *priv);
 /* svtool */
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index de8459a..7012738 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -422,7 +422,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 		return -ENODATA;
 	}
 
-	ptr = priv->shrd->eeprom;
+	ptr = priv->eeprom;
 	if (!ptr) {
 		IWL_ERR(priv, "Invalid EEPROM/OTP memory\n");
 		return -ENOMEM;
@@ -434,10 +434,10 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 		IWL_ERR(priv, "Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
-	eeprom_ver = iwl_eeprom_query16(priv->shrd, EEPROM_VERSION);
+	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
 	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s, "
 			"version: 0x%x\n",
-			(trans(priv)->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 			 ? "OTP" : "EEPROM", eeprom_ver);
 	for (ofs = 0 ; ofs < eeprom_len ; ofs += 16) {
 		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x ", ofs);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 58073da..4a24e86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -993,6 +993,10 @@ struct iwl_priv {
 	void *wowlan_sram;
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
+	/* eeprom -- this is in the card's little endian byte order */
+	u8 *eeprom;
+	enum iwl_nvm_type nvm_device_type;
+
 	struct work_struct txpower_work;
 	u32 disable_sens_cal;
 	u32 disable_chain_noise_cal;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 12744b0..1db98d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -187,33 +187,33 @@ static void iwl_eeprom_release_semaphore(struct iwl_trans *trans)
 
 }
 
-static int iwl_eeprom_verify_signature(struct iwl_trans *trans)
+static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
 {
-	u32 gp = iwl_read32(trans, CSR_EEPROM_GP) &
+	u32 gp = iwl_read32(trans(priv), CSR_EEPROM_GP) &
 			   CSR_EEPROM_GP_VALID_MSK;
 	int ret = 0;
 
-	IWL_DEBUG_EEPROM(trans, "EEPROM signature=0x%08x\n", gp);
+	IWL_DEBUG_EEPROM(priv, "EEPROM signature=0x%08x\n", gp);
 	switch (gp) {
 	case CSR_EEPROM_GP_BAD_SIG_EEP_GOOD_SIG_OTP:
-		if (trans->nvm_device_type != NVM_DEVICE_TYPE_OTP) {
-			IWL_ERR(trans, "EEPROM with bad signature: 0x%08x\n",
+		if (priv->nvm_device_type != NVM_DEVICE_TYPE_OTP) {
+			IWL_ERR(priv, "EEPROM with bad signature: 0x%08x\n",
 				gp);
 			ret = -ENOENT;
 		}
 		break;
 	case CSR_EEPROM_GP_GOOD_SIG_EEP_LESS_THAN_4K:
 	case CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K:
-		if (trans->nvm_device_type != NVM_DEVICE_TYPE_EEPROM) {
-			IWL_ERR(trans, "OTP with bad signature: 0x%08x\n", gp);
+		if (priv->nvm_device_type != NVM_DEVICE_TYPE_EEPROM) {
+			IWL_ERR(priv, "OTP with bad signature: 0x%08x\n", gp);
 			ret = -ENOENT;
 		}
 		break;
 	case CSR_EEPROM_GP_BAD_SIGNATURE_BOTH_EEP_AND_OTP:
 	default:
-		IWL_ERR(trans, "bad EEPROM/OTP signature, type=%s, "
+		IWL_ERR(priv, "bad EEPROM/OTP signature, type=%s, "
 			"EEPROM_GP=0x%08x\n",
-			(trans->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 			? "OTP" : "EEPROM", gp);
 		ret = -ENOENT;
 		break;
@@ -221,11 +221,11 @@ static int iwl_eeprom_verify_signature(struct iwl_trans *trans)
 	return ret;
 }
 
-u16 iwl_eeprom_query16(const struct iwl_shared *shrd, size_t offset)
+u16 iwl_eeprom_query16(struct iwl_priv *priv, size_t offset)
 {
-	if (!shrd->eeprom)
+	if (!priv->eeprom)
 		return 0;
-	return (u16)shrd->eeprom[offset] | ((u16)shrd->eeprom[offset + 1] << 8);
+	return (u16)priv->eeprom[offset] | ((u16)priv->eeprom[offset + 1] << 8);
 }
 
 int iwl_eeprom_check_version(struct iwl_priv *priv)
@@ -233,8 +233,8 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 	u16 eeprom_ver;
 	u16 calib_ver;
 
-	eeprom_ver = iwl_eeprom_query16(priv->shrd, EEPROM_VERSION);
-	calib_ver = iwl_eeprom_calib_version(priv->shrd);
+	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
+	calib_ver = iwl_eeprom_calib_version(priv);
 
 	if (eeprom_ver < cfg(priv)->eeprom_ver ||
 	    calib_ver < cfg(priv)->eeprom_calib_ver)
@@ -255,10 +255,9 @@ err:
 
 int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 {
-	struct iwl_shared *shrd = priv->shrd;
 	u16 radio_cfg;
 
-	priv->hw_params.sku = iwl_eeprom_query16(shrd, EEPROM_SKU_CAP);
+	priv->hw_params.sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
 	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE &&
 	    !cfg(priv)->ht_params) {
 		IWL_ERR(priv, "Invalid 11n configuration\n");
@@ -272,7 +271,7 @@ int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 
 	IWL_INFO(priv, "Device SKU: 0x%X\n", priv->hw_params.sku);
 
-	radio_cfg = iwl_eeprom_query16(shrd, EEPROM_RADIO_CONFIG);
+	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
 
 	priv->hw_params.valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
 	priv->hw_params.valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
@@ -296,9 +295,67 @@ int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
-void iwl_eeprom_get_mac(const struct iwl_shared *shrd, u8 *mac)
+u16 iwl_eeprom_calib_version(struct iwl_priv *priv)
 {
-	const u8 *addr = iwl_eeprom_query_addr(shrd,
+	struct iwl_eeprom_calib_hdr *hdr;
+
+	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
+							EEPROM_CALIB_ALL);
+	return hdr->version;
+}
+
+static u32 eeprom_indirect_address(struct iwl_priv *priv, u32 address)
+{
+	u16 offset = 0;
+
+	if ((address & INDIRECT_ADDRESS) == 0)
+		return address;
+
+	switch (address & INDIRECT_TYPE_MSK) {
+	case INDIRECT_HOST:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_HOST);
+		break;
+	case INDIRECT_GENERAL:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_GENERAL);
+		break;
+	case INDIRECT_REGULATORY:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_REGULATORY);
+		break;
+	case INDIRECT_TXP_LIMIT:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_TXP_LIMIT);
+		break;
+	case INDIRECT_TXP_LIMIT_SIZE:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_TXP_LIMIT_SIZE);
+		break;
+	case INDIRECT_CALIBRATION:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_CALIBRATION);
+		break;
+	case INDIRECT_PROCESS_ADJST:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_PROCESS_ADJST);
+		break;
+	case INDIRECT_OTHERS:
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_OTHERS);
+		break;
+	default:
+		IWL_ERR(priv, "illegal indirect type: 0x%X\n",
+		address & INDIRECT_TYPE_MSK);
+		break;
+	}
+
+	/* translate the offset from words to byte */
+	return (address & ADDRESS_MSK) + (offset << 1);
+}
+
+const u8 *iwl_eeprom_query_addr(struct iwl_priv *priv, size_t offset)
+{
+	u32 address = eeprom_indirect_address(priv, offset);
+	BUG_ON(address >= cfg(priv)->base_params->eeprom_size);
+	return &priv->eeprom[address];
+}
+
+void iwl_eeprom_get_mac(struct iwl_priv *priv, u8 *mac)
+{
+	const u8 *addr = iwl_eeprom_query_addr(priv,
 					EEPROM_MAC_ADDRESS);
 	memcpy(mac, addr, ETH_ALEN);
 }
@@ -591,7 +648,6 @@ iwl_eeprom_enh_txp_read_element(struct iwl_priv *priv,
 
 static void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 {
-	struct iwl_shared *shrd = priv->shrd;
 	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
 	int idx, entries;
 	__le16 *txp_len;
@@ -600,10 +656,10 @@ static void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 	BUILD_BUG_ON(sizeof(struct iwl_eeprom_enhanced_txpwr) != 8);
 
 	/* the length is in 16-bit words, but we want entries */
-	txp_len = (__le16 *) iwl_eeprom_query_addr(shrd, EEPROM_TXP_SZ_OFFS);
+	txp_len = (__le16 *) iwl_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
 	entries = le16_to_cpup(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
 
-	txp_array = (void *) iwl_eeprom_query_addr(shrd, EEPROM_TXP_OFFS);
+	txp_array = (void *) iwl_eeprom_query_addr(priv, EEPROM_TXP_OFFS);
 
 	for (idx = 0; idx < entries; idx++) {
 		txp = &txp_array[idx];
@@ -656,66 +712,66 @@ static void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 /**
  * iwl_eeprom_init - read EEPROM contents
  *
- * Load the EEPROM contents from adapter into shrd->eeprom
+ * Load the EEPROM contents from adapter into priv->eeprom
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
-int iwl_eeprom_init(struct iwl_trans *trans, u32 hw_rev)
+int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 {
 	__le16 *e;
-	u32 gp = iwl_read32(trans, CSR_EEPROM_GP);
+	u32 gp = iwl_read32(trans(priv), CSR_EEPROM_GP);
 	int sz;
 	int ret;
 	u16 addr;
 	u16 validblockaddr = 0;
 	u16 cache_addr = 0;
 
-	trans->nvm_device_type = iwl_get_nvm_type(trans, hw_rev);
-	if (trans->nvm_device_type == -ENOENT)
+	priv->nvm_device_type = iwl_get_nvm_type(trans(priv), hw_rev);
+	if (priv->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
-	sz = cfg(trans)->base_params->eeprom_size;
-	IWL_DEBUG_EEPROM(trans, "NVM size = %d\n", sz);
-	trans->shrd->eeprom = kzalloc(sz, GFP_KERNEL);
-	if (!trans->shrd->eeprom) {
+	sz = cfg(priv)->base_params->eeprom_size;
+	IWL_DEBUG_EEPROM(priv, "NVM size = %d\n", sz);
+	priv->eeprom = kzalloc(sz, GFP_KERNEL);
+	if (!priv->eeprom) {
 		ret = -ENOMEM;
 		goto alloc_err;
 	}
-	e = (__le16 *)trans->shrd->eeprom;
+	e = (__le16 *)priv->eeprom;
 
-	ret = iwl_eeprom_verify_signature(trans);
+	ret = iwl_eeprom_verify_signature(priv);
 	if (ret < 0) {
-		IWL_ERR(trans, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
+		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		ret = -ENOENT;
 		goto err;
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = iwl_eeprom_acquire_semaphore(trans);
+	ret = iwl_eeprom_acquire_semaphore(trans(priv));
 	if (ret < 0) {
-		IWL_ERR(trans, "Failed to acquire EEPROM semaphore.\n");
+		IWL_ERR(priv, "Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
 		goto err;
 	}
 
-	if (trans->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
+	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
 
-		ret = iwl_init_otp_access(trans);
+		ret = iwl_init_otp_access(trans(priv));
 		if (ret) {
-			IWL_ERR(trans, "Failed to initialize OTP access.\n");
+			IWL_ERR(priv, "Failed to initialize OTP access.\n");
 			ret = -ENOENT;
 			goto done;
 		}
-		iwl_write32(trans, CSR_EEPROM_GP,
-			    iwl_read32(trans, CSR_EEPROM_GP) &
+		iwl_write32(trans(priv), CSR_EEPROM_GP,
+			    iwl_read32(trans(priv), CSR_EEPROM_GP) &
 			    ~CSR_EEPROM_GP_IF_OWNER_MSK);
 
-		iwl_set_bit(trans, CSR_OTP_GP_REG,
+		iwl_set_bit(trans(priv), CSR_OTP_GP_REG,
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
-		if (!cfg(trans)->base_params->shadow_ram_support) {
-			if (iwl_find_otp_image(trans, &validblockaddr)) {
+		if (!cfg(priv)->base_params->shadow_ram_support) {
+			if (iwl_find_otp_image(trans(priv), &validblockaddr)) {
 				ret = -ENOENT;
 				goto done;
 			}
@@ -724,7 +780,8 @@ int iwl_eeprom_init(struct iwl_trans *trans, u32 hw_rev)
 		     addr += sizeof(u16)) {
 			__le16 eeprom_data;
 
-			ret = iwl_read_otp_word(trans, addr, &eeprom_data);
+			ret = iwl_read_otp_word(trans(priv), addr,
+						&eeprom_data);
 			if (ret)
 				goto done;
 			e[cache_addr / 2] = eeprom_data;
@@ -735,94 +792,93 @@ int iwl_eeprom_init(struct iwl_trans *trans, u32 hw_rev)
 		for (addr = 0; addr < sz; addr += sizeof(u16)) {
 			u32 r;
 
-			iwl_write32(trans, CSR_EEPROM_REG,
+			iwl_write32(trans(priv), CSR_EEPROM_REG,
 				    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
-			ret = iwl_poll_bit(trans, CSR_EEPROM_REG,
+			ret = iwl_poll_bit(trans(priv), CSR_EEPROM_REG,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  IWL_EEPROM_ACCESS_TIMEOUT);
 			if (ret < 0) {
-				IWL_ERR(trans,
+				IWL_ERR(priv,
 					"Time out reading EEPROM[%d]\n", addr);
 				goto done;
 			}
-			r = iwl_read32(trans, CSR_EEPROM_REG);
+			r = iwl_read32(trans(priv), CSR_EEPROM_REG);
 			e[addr / 2] = cpu_to_le16(r >> 16);
 		}
 	}
 
-	IWL_DEBUG_EEPROM(trans, "NVM Type: %s, version: 0x%x\n",
-		       (trans->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+	IWL_DEBUG_EEPROM(priv, "NVM Type: %s, version: 0x%x\n",
+		       (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 		       ? "OTP" : "EEPROM",
-		       iwl_eeprom_query16(trans->shrd, EEPROM_VERSION));
+		       iwl_eeprom_query16(priv, EEPROM_VERSION));
 
 	ret = 0;
 done:
-	iwl_eeprom_release_semaphore(trans);
+	iwl_eeprom_release_semaphore(trans(priv));
 
 err:
 	if (ret)
-		iwl_eeprom_free(trans->shrd);
+		iwl_eeprom_free(priv);
 alloc_err:
 	return ret;
 }
 
-void iwl_eeprom_free(struct iwl_shared *shrd)
+void iwl_eeprom_free(struct iwl_priv *priv)
 {
-	kfree(shrd->eeprom);
-	shrd->eeprom = NULL;
+	kfree(priv->eeprom);
+	priv->eeprom = NULL;
 }
 
-static void iwl_init_band_reference(const struct iwl_priv *priv,
+static void iwl_init_band_reference(struct iwl_priv *priv,
 			int eep_band, int *eeprom_ch_count,
 			const struct iwl_eeprom_channel **eeprom_ch_info,
 			const u8 **eeprom_ch_index)
 {
-	struct iwl_shared *shrd = priv->shrd;
 	u32 offset = cfg(priv)->lib->
 			eeprom_ops.regulatory_bands[eep_band - 1];
 	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_1);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(shrd, offset);
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_1;
 		break;
 	case 2:		/* 4.9GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_2);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(shrd, offset);
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_2;
 		break;
 	case 3:		/* 5.2GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_3);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(shrd, offset);
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_3;
 		break;
 	case 4:		/* 5.5GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_4);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(shrd, offset);
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_4;
 		break;
 	case 5:		/* 5.7GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_5);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(shrd, offset);
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_5;
 		break;
 	case 6:		/* 2.4GHz ht40 channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_6);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(shrd, offset);
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_6;
 		break;
 	case 7:		/* 5 GHz ht40 channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_7);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(shrd, offset);
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_7;
 		break;
 	default:
@@ -1072,7 +1128,7 @@ void iwl_rf_config(struct iwl_priv *priv)
 {
 	u16 radio_cfg;
 
-	radio_cfg = iwl_eeprom_query16(priv->shrd, EEPROM_RADIO_CONFIG);
+	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
 
 	/* write radio config values to register */
 	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index e4a7583..b3a3b1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -66,8 +66,6 @@
 #include <net/mac80211.h>
 
 struct iwl_priv;
-struct iwl_shared;
-struct iwl_trans;
 
 /*
  * EEPROM access time values:
@@ -306,12 +304,14 @@ struct iwl_eeprom_ops {
 };
 
 
-int iwl_eeprom_init(struct iwl_trans *trans, u32 hw_rev);
-void iwl_eeprom_free(struct iwl_shared *shrd);
-int  iwl_eeprom_check_version(struct iwl_priv *priv);
+int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev);
+void iwl_eeprom_free(struct iwl_priv *priv);
+int iwl_eeprom_check_version(struct iwl_priv *priv);
 int iwl_eeprom_init_hw_params(struct iwl_priv *priv);
-const u8 *iwl_eeprom_query_addr(const struct iwl_shared *shrd, size_t offset);
-u16 iwl_eeprom_query16(const struct iwl_shared *shrd, size_t offset);
+u16 iwl_eeprom_calib_version(struct iwl_priv *priv);
+const u8 *iwl_eeprom_query_addr(struct iwl_priv *priv, size_t offset);
+u16 iwl_eeprom_query16(struct iwl_priv *priv, size_t offset);
+void iwl_eeprom_get_mac(struct iwl_priv *priv, u8 *mac);
 int iwl_init_channel_map(struct iwl_priv *priv);
 void iwl_free_channel_map(struct iwl_priv *priv);
 const struct iwl_channel_info *iwl_get_channel_info(
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index c6325c5..ee155e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -313,10 +313,6 @@ struct iwl_shared {
 	const struct iwl_cfg *cfg;
 	struct iwl_trans *trans;
 	void *drv;
-
-	/* eeprom -- this is in the card's little endian byte order */
-	u8 *eeprom;
-
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index d65dac8..c8e89ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -532,7 +532,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
-		if (priv->shrd->eeprom) {
+		if (priv->eeprom) {
 			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
 				cfg(priv)->base_params->eeprom_size + 20);
 			if (!skb) {
@@ -543,7 +543,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 				IWL_TM_CMD_DEV2APP_EEPROM_RSP);
 			NLA_PUT(skb, IWL_TM_ATTR_EEPROM,
 				cfg(priv)->base_params->eeprom_size,
-				priv->shrd->eeprom);
+				priv->eeprom);
 			status = cfg80211_testmode_reply(skb);
 			if (status < 0)
 				IWL_ERR(priv, "Error sending msg : %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index a6598a2..d0888cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -431,7 +431,6 @@ enum iwl_trans_state {
  * @hw_id: a u32 with the ID of the device / subdevice.
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
- * @nvm_device_type: indicates OTP or eeprom
  * @pm_support: set to true in start_hw if link pm is supported
  * @wait_command_queue: the wait_queue for SYNC host commands
  */
@@ -447,7 +446,6 @@ struct iwl_trans {
 	u32 hw_id;
 	char hw_id_str[52];
 
-	int    nvm_device_type;
 	bool pm_support;
 
 	wait_queue_head_t wait_command_queue;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index ba7c9f8..e78f20e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -62,7 +62,7 @@ static int iwl_set_Xtal_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
 	__le16 *xtal_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv->shrd, EEPROM_XTAL);
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_XTAL);
 
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD);
 	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
@@ -74,8 +74,7 @@ static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_cmd cmd;
 	__le16 *offset_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv->shrd,
-						EEPROM_RAW_TEMPERATURE);
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_RAW_TEMPERATURE);
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
@@ -91,16 +90,15 @@ static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 static int iwl_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_v2_cmd cmd;
-	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(priv->shrd,
+	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(priv,
 				     EEPROM_KELVIN_TEMPERATURE);
 	__le16 *offset_calib_low =
-		(__le16 *)iwl_eeprom_query_addr(priv->shrd,
-						EEPROM_RAW_TEMPERATURE);
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_RAW_TEMPERATURE);
 	struct iwl_eeprom_calib_hdr *hdr;
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv->shrd,
+	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
 							EEPROM_CALIB_ALL);
 	memcpy(&cmd.radio_sensor_offset_high, offset_calib_high,
 		sizeof(*offset_calib_high));
-- 
1.7.0.4

