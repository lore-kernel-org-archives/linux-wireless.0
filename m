Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab1GHQUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/21] iwlagn: remove indirection for eeprom_query_addr
Date: Fri,  8 Jul 2011 08:46:19 -0700
Message-Id: <1310139989-27661-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182101_992667_8D1366FF)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fry, Donald H <donald.h.fry@intel.com>

Not needed since the driver split.  Eliminate redundant routine.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c       |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c       |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn.h        |    2 --
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |    5 -----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |    1 -
 9 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5be2767..a558df9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -182,7 +182,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
-		.query_addr = iwlagn_eeprom_query_addr,
 	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 2580dc3..2855994 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -182,7 +182,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
-		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
 	.temp_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1d9bae3..55972cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -335,7 +335,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.query_addr = iwlagn_eeprom_query_addr,
 	},
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
@@ -359,7 +358,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.query_addr = iwlagn_eeprom_query_addr,
 	},
 	.temp_ops = {
 		.temperature = iwl5150_temperature,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 73ea73e..17dc337 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -275,7 +275,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
 	.temp_ops = {
@@ -301,7 +300,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
 	.temp_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 7745816..b8347db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -150,7 +150,7 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 
 void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac)
 {
-	const u8 *addr = priv->cfg->ops->lib->eeprom_ops.query_addr(priv,
+	const u8 *addr = iwl_eeprom_query_addr(priv,
 					EEPROM_MAC_ADDRESS);
 	memcpy(mac, addr, ETH_ALEN);
 }
@@ -245,10 +245,10 @@ void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 	BUILD_BUG_ON(sizeof(struct iwl_eeprom_enhanced_txpwr) != 8);
 
 	/* the length is in 16-bit words, but we want entries */
-	txp_len = (__le16 *) iwlagn_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
+	txp_len = (__le16 *) iwl_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
 	entries = le16_to_cpup(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
 
-	txp_array = (void *) iwlagn_eeprom_query_addr(priv, EEPROM_TXP_OFFS);
+	txp_array = (void *) iwl_eeprom_query_addr(priv, EEPROM_TXP_OFFS);
 
 	for (idx = 0; idx < entries; idx++) {
 		txp = &txp_array[idx];
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index f787ef5..94f6d60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -611,8 +611,7 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 	return (address & ADDRESS_MSK) + (offset << 1);
 }
 
-const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
-					   size_t offset)
+const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset)
 {
 	u32 address = eeprom_indirect_address(priv, offset);
 	BUG_ON(address >= priv->cfg->base_params->eeprom_size);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ff0b2ed..bde03b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -180,8 +180,6 @@ int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
 u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
-const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
-				   size_t offset);
 int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_hw_nic_init(struct iwl_priv *priv);
 int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index eab2834..eee97bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -407,11 +407,6 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 	return -EINVAL;
 }
 
-const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset)
-{
-	return priv->cfg->ops->lib->eeprom_ops.query_addr(priv, offset);
-}
-
 u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset)
 {
 	if (!priv->eeprom)
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 804f910..e4bf8ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -292,7 +292,6 @@ extern const u8 iwl_eeprom_band_1[14];
 
 struct iwl_eeprom_ops {
 	const u32 regulatory_bands[7];
-	const u8* (*query_addr) (const struct iwl_priv *priv, size_t offset);
 	void (*update_enhanced_txpower) (struct iwl_priv *priv);
 };
 
-- 
1.7.0.4

