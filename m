Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab1LIBZD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/15] iwlwifi: move eeprom pointer from iwl_priv to iwl_shared
Date: Thu,  8 Dec 2011 16:26:17 -0800
Message-Id: <1323390382-1678-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022513_266137_852F4419)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The eeprom image is a device level component, move from iwl_priv
to iwl_shared, with associated code changes.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   32 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 --
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   60 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    7 ++-
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    3 +
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |   12 +++--
 12 files changed, 78 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cf2fb47..6706d7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -134,10 +134,10 @@ static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
 
 #define IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF	(-5)
 
-static s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
+static s32 iwl_temp_calib_to_offset(struct iwl_shared *shrd)
 {
 	u16 temperature, voltage;
-	__le16 *temp_calib = (__le16 *)iwl_eeprom_query_addr(priv,
+	__le16 *temp_calib = (__le16 *)iwl_eeprom_query_addr(shrd,
 				EEPROM_KELVIN_TEMPERATURE);
 
 	temperature = le16_to_cpu(temp_calib[0]);
@@ -151,7 +151,7 @@ static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
 {
 	const s32 volt2temp_coef = IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF;
 	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY) -
-			iwl_temp_calib_to_offset(priv);
+			iwl_temp_calib_to_offset(priv->shrd);
 
 	hw_params(priv).ct_kill_threshold = threshold * volt2temp_coef;
 }
@@ -223,7 +223,7 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 static void iwl5150_temperature(struct iwl_priv *priv)
 {
 	u32 vt = 0;
-	s32 offset =  iwl_temp_calib_to_offset(priv);
+	s32 offset =  iwl_temp_calib_to_offset(priv->shrd);
 
 	vt = le32_to_cpu(priv->statistics.common.temperature);
 	vt = vt / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF + offset;
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 617ad1c..3e277b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -81,7 +81,7 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
-	if (iwlagn_eeprom_calib_version(priv) >= 6)
+	if (iwl_eeprom_calib_version(priv->shrd) >= 6)
 		iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 }
@@ -89,7 +89,7 @@ static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 static void iwl6150_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
-	if (iwlagn_eeprom_calib_version(priv) >= 6)
+	if (iwl_eeprom_calib_version(priv->shrd) >= 6)
 		iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 	iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 575d1bb..1d63422 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -92,11 +92,11 @@ void iwlagn_temperature(struct iwl_priv *priv)
 	iwl_tt_handler(priv);
 }
 
-u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv)
+u16 iwl_eeprom_calib_version(struct iwl_shared *shrd)
 {
 	struct iwl_eeprom_calib_hdr *hdr;
 
-	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
+	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(shrd,
 							EEPROM_CALIB_ALL);
 	return hdr->version;
 
@@ -105,7 +105,7 @@ u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv)
 /*
  * EEPROM
  */
-static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
+static u32 eeprom_indirect_address(const struct iwl_shared *shrd, u32 address)
 {
 	u16 offset = 0;
 
@@ -114,31 +114,31 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 
 	switch (address & INDIRECT_TYPE_MSK) {
 	case INDIRECT_HOST:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_HOST);
+		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_HOST);
 		break;
 	case INDIRECT_GENERAL:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_GENERAL);
+		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_GENERAL);
 		break;
 	case INDIRECT_REGULATORY:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_REGULATORY);
+		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_REGULATORY);
 		break;
 	case INDIRECT_TXP_LIMIT:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_TXP_LIMIT);
+		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_TXP_LIMIT);
 		break;
 	case INDIRECT_TXP_LIMIT_SIZE:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_TXP_LIMIT_SIZE);
+		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_TXP_LIMIT_SIZE);
 		break;
 	case INDIRECT_CALIBRATION:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_CALIBRATION);
+		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_CALIBRATION);
 		break;
 	case INDIRECT_PROCESS_ADJST:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_PROCESS_ADJST);
+		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_PROCESS_ADJST);
 		break;
 	case INDIRECT_OTHERS:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_OTHERS);
+		offset = iwl_eeprom_query16(shrd, EEPROM_LINK_OTHERS);
 		break;
 	default:
-		IWL_ERR(priv, "illegal indirect type: 0x%X\n",
+		IWL_ERR(shrd->trans, "illegal indirect type: 0x%X\n",
 		address & INDIRECT_TYPE_MSK);
 		break;
 	}
@@ -147,11 +147,11 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 	return (address & ADDRESS_MSK) + (offset << 1);
 }
 
-const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset)
+const u8 *iwl_eeprom_query_addr(const struct iwl_shared *shrd, size_t offset)
 {
-	u32 address = eeprom_indirect_address(priv, offset);
-	BUG_ON(address >= priv->cfg->base_params->eeprom_size);
-	return &priv->eeprom[address];
+	u32 address = eeprom_indirect_address(shrd, offset);
+	BUG_ON(address >= shrd->priv->cfg->base_params->eeprom_size);
+	return &shrd->eeprom[address];
 }
 
 struct iwl_mod_params iwlagn_mod_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6dd1e10..6b99448 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1822,11 +1822,11 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 		goto out_free_eeprom;
 
 	/* extract MAC Address */
-	iwl_eeprom_get_mac(priv, priv->addresses[0].addr);
+	iwl_eeprom_get_mac(priv->shrd, priv->addresses[0].addr);
 	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->addresses[0].addr);
 	priv->hw->wiphy->addresses = priv->addresses;
 	priv->hw->wiphy->n_addresses = 1;
-	num_mac = iwl_eeprom_query16(priv, EEPROM_NUM_MAC_ADDRESS);
+	num_mac = iwl_eeprom_query16(priv->shrd, EEPROM_NUM_MAC_ADDRESS);
 	if (num_mac > 1) {
 		memcpy(priv->addresses[1].addr, priv->addresses[0].addr,
 		       ETH_ALEN);
@@ -1891,7 +1891,7 @@ out_destroy_workqueue:
 	priv->shrd->workqueue = NULL;
 	iwl_uninit_drv(priv);
 out_free_eeprom:
-	iwl_eeprom_free(priv);
+	iwl_eeprom_free(priv->shrd);
 out_free_trans:
 	iwl_trans_free(trans(priv));
 out_free_traffic_mem:
@@ -1930,7 +1930,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 
 	iwl_dealloc_ucode(trans(priv));
 
-	iwl_eeprom_free(priv);
+	iwl_eeprom_free(priv->shrd);
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->shrd->workqueue);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index b891bd9..eb453ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -117,7 +117,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
-u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
+u16 iwl_eeprom_calib_version(struct iwl_shared *shrd);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
@@ -354,7 +354,7 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 
 /* eeprom */
 void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv);
-void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
+void iwl_eeprom_get_mac(const struct iwl_shared *shrd, u8 *mac);
 
 extern int iwlagn_init_alive_start(struct iwl_priv *priv);
 extern int iwl_alive_start(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ccbcab4..6bf6845 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -416,7 +416,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 		return -ENODATA;
 	}
 
-	ptr = priv->eeprom;
+	ptr = priv->shrd->eeprom;
 	if (!ptr) {
 		IWL_ERR(priv, "Invalid EEPROM/OTP memory\n");
 		return -ENOMEM;
@@ -428,7 +428,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 		IWL_ERR(priv, "Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
-	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
+	eeprom_ver = iwl_eeprom_query16(priv->shrd, EEPROM_VERSION);
 	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s, "
 			"version: 0x%x\n",
 			(trans(priv)->nvm_device_type == NVM_DEVICE_TYPE_OTP)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d7b64af..68f9dc5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -903,10 +903,6 @@ struct iwl_priv {
 	/* Indication if ieee80211_ops->open has been called */
 	u8 is_open;
 
-	/* eeprom -- this is in the card's little endian byte order */
-	u8 *eeprom;
-	struct iwl_eeprom_calib_info *calib_info;
-
 	enum nl80211_iftype iw_mode;
 
 	/* Last Rx'd beacon timestamp */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index dcada08..6fcc7d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -215,11 +215,11 @@ static int iwl_eeprom_verify_signature(struct iwl_trans *trans)
 	return ret;
 }
 
-u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset)
+u16 iwl_eeprom_query16(const struct iwl_shared *shrd, size_t offset)
 {
-	if (!priv->eeprom)
+	if (!shrd->eeprom)
 		return 0;
-	return (u16)priv->eeprom[offset] | ((u16)priv->eeprom[offset + 1] << 8);
+	return (u16)shrd->eeprom[offset] | ((u16)shrd->eeprom[offset + 1] << 8);
 }
 
 int iwl_eeprom_check_version(struct iwl_priv *priv)
@@ -227,8 +227,8 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 	u16 eeprom_ver;
 	u16 calib_ver;
 
-	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-	calib_ver = iwlagn_eeprom_calib_version(priv);
+	eeprom_ver = iwl_eeprom_query16(priv->shrd, EEPROM_VERSION);
+	calib_ver = iwl_eeprom_calib_version(priv->shrd);
 
 	if (eeprom_ver < priv->cfg->eeprom_ver ||
 	    calib_ver < priv->cfg->eeprom_calib_ver)
@@ -249,11 +249,12 @@ err:
 
 int iwl_eeprom_check_sku(struct iwl_priv *priv)
 {
+	struct iwl_shared *shrd = priv->shrd;
 	u16 radio_cfg;
 
 	if (!priv->cfg->sku) {
 		/* not using sku overwrite */
-		priv->cfg->sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
+		priv->cfg->sku = iwl_eeprom_query16(shrd, EEPROM_SKU_CAP);
 		if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE &&
 		    !priv->cfg->ht_params) {
 			IWL_ERR(priv, "Invalid 11n configuration\n");
@@ -269,7 +270,7 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 
 	if (!priv->cfg->valid_tx_ant && !priv->cfg->valid_rx_ant) {
 		/* not using .cfg overwrite */
-		radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
+		radio_cfg = iwl_eeprom_query16(shrd, EEPROM_RADIO_CONFIG);
 		priv->cfg->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
 		priv->cfg->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
 		if (!priv->cfg->valid_tx_ant || !priv->cfg->valid_rx_ant) {
@@ -289,9 +290,9 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 	return 0;
 }
 
-void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac)
+void iwl_eeprom_get_mac(const struct iwl_shared *shrd, u8 *mac)
 {
-	const u8 *addr = iwl_eeprom_query_addr(priv,
+	const u8 *addr = iwl_eeprom_query_addr(shrd,
 					EEPROM_MAC_ADDRESS);
 	memcpy(mac, addr, ETH_ALEN);
 }
@@ -582,6 +583,7 @@ iwl_eeprom_enh_txp_read_element(struct iwl_priv *priv,
 
 void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 {
+	struct iwl_shared *shrd = priv->shrd;
 	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
 	int idx, entries;
 	__le16 *txp_len;
@@ -590,10 +592,10 @@ void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 	BUILD_BUG_ON(sizeof(struct iwl_eeprom_enhanced_txpwr) != 8);
 
 	/* the length is in 16-bit words, but we want entries */
-	txp_len = (__le16 *) iwl_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
+	txp_len = (__le16 *) iwl_eeprom_query_addr(shrd, EEPROM_TXP_SZ_OFFS);
 	entries = le16_to_cpup(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
 
-	txp_array = (void *) iwl_eeprom_query_addr(priv, EEPROM_TXP_OFFS);
+	txp_array = (void *) iwl_eeprom_query_addr(shrd, EEPROM_TXP_OFFS);
 
 	for (idx = 0; idx < entries; idx++) {
 		txp = &txp_array[idx];
@@ -646,12 +648,13 @@ void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 /**
  * iwl_eeprom_init - read EEPROM contents
  *
- * Load the EEPROM contents from adapter into priv->eeprom
+ * Load the EEPROM contents from adapter into shrd->eeprom
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
 int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 {
+	struct iwl_shared *shrd = priv->shrd;
 	__le16 *e;
 	u32 gp = iwl_read32(bus(priv), CSR_EEPROM_GP);
 	int sz;
@@ -666,12 +669,12 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	/* allocate eeprom */
 	sz = priv->cfg->base_params->eeprom_size;
 	IWL_DEBUG_EEPROM(priv, "NVM size = %d\n", sz);
-	priv->eeprom = kzalloc(sz, GFP_KERNEL);
-	if (!priv->eeprom) {
+	shrd->eeprom = kzalloc(sz, GFP_KERNEL);
+	if (!shrd->eeprom) {
 		ret = -ENOMEM;
 		goto alloc_err;
 	}
-	e = (__le16 *)priv->eeprom;
+	e = (__le16 *)shrd->eeprom;
 
 	iwl_apm_init(priv);
 
@@ -746,7 +749,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	IWL_DEBUG_EEPROM(priv, "NVM Type: %s, version: 0x%x\n",
 		       (trans(priv)->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 		       ? "OTP" : "EEPROM",
-		       iwl_eeprom_query16(priv, EEPROM_VERSION));
+		       iwl_eeprom_query16(shrd, EEPROM_VERSION));
 
 	ret = 0;
 done:
@@ -754,17 +757,17 @@ done:
 
 err:
 	if (ret)
-		iwl_eeprom_free(priv);
+		iwl_eeprom_free(priv->shrd);
 	/* Reset chip to save power until we load uCode during "up". */
 	iwl_apm_stop(priv);
 alloc_err:
 	return ret;
 }
 
-void iwl_eeprom_free(struct iwl_priv *priv)
+void iwl_eeprom_free(struct iwl_shared *shrd)
 {
-	kfree(priv->eeprom);
-	priv->eeprom = NULL;
+	kfree(shrd->eeprom);
+	shrd->eeprom = NULL;
 }
 
 static void iwl_init_band_reference(const struct iwl_priv *priv,
@@ -772,49 +775,50 @@ static void iwl_init_band_reference(const struct iwl_priv *priv,
 			const struct iwl_eeprom_channel **eeprom_ch_info,
 			const u8 **eeprom_ch_index)
 {
+	struct iwl_shared *shrd = priv->shrd;
 	u32 offset = priv->cfg->lib->
 			eeprom_ops.regulatory_bands[eep_band - 1];
 	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_1);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
+				iwl_eeprom_query_addr(shrd, offset);
 		*eeprom_ch_index = iwl_eeprom_band_1;
 		break;
 	case 2:		/* 4.9GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_2);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
+				iwl_eeprom_query_addr(shrd, offset);
 		*eeprom_ch_index = iwl_eeprom_band_2;
 		break;
 	case 3:		/* 5.2GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_3);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
+				iwl_eeprom_query_addr(shrd, offset);
 		*eeprom_ch_index = iwl_eeprom_band_3;
 		break;
 	case 4:		/* 5.5GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_4);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
+				iwl_eeprom_query_addr(shrd, offset);
 		*eeprom_ch_index = iwl_eeprom_band_4;
 		break;
 	case 5:		/* 5.7GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_5);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
+				iwl_eeprom_query_addr(shrd, offset);
 		*eeprom_ch_index = iwl_eeprom_band_5;
 		break;
 	case 6:		/* 2.4GHz ht40 channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_6);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
+				iwl_eeprom_query_addr(shrd, offset);
 		*eeprom_ch_index = iwl_eeprom_band_6;
 		break;
 	case 7:		/* 5 GHz ht40 channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_7);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
+				iwl_eeprom_query_addr(shrd, offset);
 		*eeprom_ch_index = iwl_eeprom_band_7;
 		break;
 	default:
@@ -1064,7 +1068,7 @@ void iwl_rf_config(struct iwl_priv *priv)
 {
 	u16 radio_cfg;
 
-	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
+	radio_cfg = iwl_eeprom_query16(priv->shrd, EEPROM_RADIO_CONFIG);
 
 	/* write radio config values to register */
 	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index c94747e..9fa937e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -66,6 +66,7 @@
 #include <net/mac80211.h>
 
 struct iwl_priv;
+struct iwl_shared;
 
 /*
  * EEPROM access time values:
@@ -305,11 +306,11 @@ struct iwl_eeprom_ops {
 
 
 int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev);
-void iwl_eeprom_free(struct iwl_priv *priv);
+void iwl_eeprom_free(struct iwl_shared *shrd);
 int  iwl_eeprom_check_version(struct iwl_priv *priv);
 int  iwl_eeprom_check_sku(struct iwl_priv *priv);
-const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset);
-u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset);
+const u8 *iwl_eeprom_query_addr(const struct iwl_shared *shrd, size_t offset);
+u16 iwl_eeprom_query16(const struct iwl_shared *shrd, size_t offset);
 int iwl_init_channel_map(struct iwl_priv *priv);
 void iwl_free_channel_map(struct iwl_priv *priv);
 const struct iwl_channel_info *iwl_get_channel_info(
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 39aa9cf..53cddd3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -351,6 +351,9 @@ struct iwl_shared {
 
 	wait_queue_head_t wait_command_queue;
 
+	/* eeprom -- this is in the card's little endian byte order */
+	u8 *eeprom;
+
 	/* ucode related variables */
 	enum iwl_ucode_type ucode_type;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 0b0ff11..a874eb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -485,7 +485,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
-		if (priv->eeprom) {
+		if (priv->shrd->eeprom) {
 			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
 				priv->cfg->base_params->eeprom_size + 20);
 			if (!skb) {
@@ -497,7 +497,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 				IWL_TM_CMD_DEV2APP_EEPROM_RSP);
 			NLA_PUT(skb, IWL_TM_ATTR_EEPROM,
 				priv->cfg->base_params->eeprom_size,
-				priv->eeprom);
+				priv->shrd->eeprom);
 			status = cfg80211_testmode_reply(skb);
 			if (status < 0)
 				IWL_DEBUG_INFO(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index b365de4..f560669 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -217,7 +217,7 @@ static int iwl_set_Xtal_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
 	__le16 *xtal_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_XTAL);
+		(__le16 *)iwl_eeprom_query_addr(priv->shrd, EEPROM_XTAL);
 
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD);
 	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
@@ -229,7 +229,8 @@ static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_cmd cmd;
 	__le16 *offset_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_RAW_TEMPERATURE);
+		(__le16 *)iwl_eeprom_query_addr(priv->shrd,
+						EEPROM_RAW_TEMPERATURE);
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
@@ -245,15 +246,16 @@ static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 static int iwl_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_v2_cmd cmd;
-	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(priv,
+	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(priv->shrd,
 				     EEPROM_KELVIN_TEMPERATURE);
 	__le16 *offset_calib_low =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_RAW_TEMPERATURE);
+		(__le16 *)iwl_eeprom_query_addr(priv->shrd,
+						EEPROM_RAW_TEMPERATURE);
 	struct iwl_eeprom_calib_hdr *hdr;
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
+	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv->shrd,
 							EEPROM_CALIB_ALL);
 	memcpy(&cmd.radio_sensor_offset_high, offset_calib_high,
 		sizeof(*offset_calib_high));
-- 
1.7.0.4

