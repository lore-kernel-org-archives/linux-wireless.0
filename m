Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab1HZGxZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/60] iwlagn: Rename iwlcore prefix
Date: Thu, 25 Aug 2011 23:10:33 -0700
Message-Id: <1314339092-20797-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085330_846759_647C8C77)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are number of functions with "iwlcore_" prefix which not feels right,
rename those to "iwl_".

No functional changes by making the renames.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c       |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.h       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |    1 -
 10 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 54d931d..3e1cdd3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -179,7 +179,7 @@ static struct iwl_lib_ops iwl2000_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
-		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
+		.update_enhanced_txpower = iwl_eeprom_enhanced_txpower,
 	},
 	.temperature = iwlagn_temperature,
 };
@@ -200,7 +200,7 @@ static struct iwl_lib_ops iwl2030_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
-		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
+		.update_enhanced_txpower = iwl_eeprom_enhanced_txpower,
 	},
 	.temperature = iwlagn_temperature,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 339de88..850f924 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -272,7 +272,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
+		.update_enhanced_txpower = iwl_eeprom_enhanced_txpower,
 	},
 	.temperature = iwlagn_temperature,
 };
@@ -294,7 +294,7 @@ static struct iwl_lib_ops iwl6030_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
+		.update_enhanced_txpower = iwl_eeprom_enhanced_txpower,
 	},
 	.temperature = iwlagn_temperature,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index b8347db..c62ddc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -195,7 +195,7 @@ static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
 }
 
 static void
-iwlcore_eeprom_enh_txp_read_element(struct iwl_priv *priv,
+iwl_eeprom_enh_txp_read_element(struct iwl_priv *priv,
 				    struct iwl_eeprom_enhanced_txpwr *txp,
 				    s8 max_txpower_avg)
 {
@@ -235,7 +235,7 @@ iwlcore_eeprom_enh_txp_read_element(struct iwl_priv *priv,
 #define TXP_CHECK_AND_PRINT(x) ((txp->flags & IWL_EEPROM_ENH_TXP_FL_##x) \
 			    ? # x " " : "")
 
-void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
+void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 {
 	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
 	int idx, entries;
@@ -294,6 +294,6 @@ void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 		if (max_txp_avg_halfdbm > priv->tx_power_lmt_in_half_dbm)
 			priv->tx_power_lmt_in_half_dbm = max_txp_avg_halfdbm;
 
-		iwlcore_eeprom_enh_txp_read_element(priv, txp, max_txp_avg);
+		iwl_eeprom_enh_txp_read_element(priv, txp, max_txp_avg);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index a895a09..0fc1237 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -369,7 +369,7 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwlcore_verify_inst_sparse(struct iwl_priv *priv,
+static int iwl_verify_inst_sparse(struct iwl_priv *priv,
 				      struct fw_desc *fw_desc)
 {
 	__le32 *image = (__le32 *)fw_desc->v_addr;
@@ -427,7 +427,7 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
  */
 static int iwl_verify_ucode(struct iwl_priv *priv, struct fw_img *img)
 {
-	if (!iwlcore_verify_inst_sparse(priv, &img->code)) {
+	if (!iwl_verify_inst_sparse(priv, &img->code)) {
 		IWL_DEBUG_FW(priv, "uCode is good in inst SRAM\n");
 		return 0;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 33894dd..7f50d9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3459,7 +3459,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 		goto err;
 	}
 
-	ret = iwlcore_init_geos(priv);
+	ret = iwl_init_geos(priv);
 	if (ret) {
 		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
 		goto err_free_channel_map;
@@ -3477,7 +3477,7 @@ err:
 static void iwl_uninit_drv(struct iwl_priv *priv)
 {
 	iwl_calib_free_results(priv);
-	iwlcore_free_geos(priv);
+	iwl_free_geos(priv);
 	iwl_free_channel_map(priv);
 	kfree(priv->scan_cmd);
 	kfree(priv->beacon_cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index df2960a..a2f2f28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -287,7 +287,7 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 }
 
 /* eeprom */
-void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv);
+void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv);
 void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
 
 /* notification wait support */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e269987..e1c5f59 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -51,7 +51,7 @@ const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 #define MAX_BIT_RATE_40_MHZ 150 /* Mbps */
 #define MAX_BIT_RATE_20_MHZ 72 /* Mbps */
-static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
+static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 			      struct ieee80211_sta_ht_cap *ht_info,
 			      enum ieee80211_band band)
 {
@@ -107,9 +107,9 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 }
 
 /**
- * iwlcore_init_geos - Initialize mac80211's geo/channel info based from eeprom
+ * iwl_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
-int iwlcore_init_geos(struct iwl_priv *priv)
+int iwl_init_geos(struct iwl_priv *priv)
 {
 	struct iwl_channel_info *ch;
 	struct ieee80211_supported_band *sband;
@@ -146,7 +146,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
 
 	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
-		iwlcore_init_ht_hw_capab(priv, &sband->ht_cap,
+		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_5GHZ);
 
 	sband = &priv->bands[IEEE80211_BAND_2GHZ];
@@ -156,7 +156,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY;
 
 	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
-		iwlcore_init_ht_hw_capab(priv, &sband->ht_cap,
+		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_2GHZ);
 
 	priv->ieee_channels = channels;
@@ -228,9 +228,9 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 }
 
 /*
- * iwlcore_free_geos - undo allocations in iwlcore_init_geos
+ * iwl_free_geos - undo allocations in iwl_init_geos
  */
-void iwlcore_free_geos(struct iwl_priv *priv)
+void iwl_free_geos(struct iwl_priv *priv)
 {
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 42bcb46..9c2b3f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -429,8 +429,8 @@ void iwl_clear_isr_stats(struct iwl_priv *priv);
 /*****************************************************
 *  GEOS
 ******************************************************/
-int iwlcore_init_geos(struct iwl_priv *priv);
-void iwlcore_free_geos(struct iwl_priv *priv);
+int iwl_init_geos(struct iwl_priv *priv);
+void iwl_free_geos(struct iwl_priv *priv);
 
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 19d31a5..c790f7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -226,7 +226,7 @@ static void iwl_set_otp_access(struct iwl_priv *priv, enum iwl_access_mode mode)
 			    CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 }
 
-static int iwlcore_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
+static int iwl_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
 {
 	u32 otpgp;
 	int nvm_type;
@@ -431,7 +431,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	u16 validblockaddr = 0;
 	u16 cache_addr = 0;
 
-	priv->nvm_device_type = iwlcore_get_nvm_type(priv, hw_rev);
+	priv->nvm_device_type = iwl_get_nvm_type(priv, hw_rev);
 	if (priv->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index e4bf8ac..e2b5e0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -301,7 +301,6 @@ void iwl_eeprom_free(struct iwl_priv *priv);
 int  iwl_eeprom_check_version(struct iwl_priv *priv);
 int  iwl_eeprom_check_sku(struct iwl_priv *priv);
 const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset);
-int iwlcore_eeprom_verify_signature(struct iwl_priv *priv);
 u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset);
 int iwl_init_channel_map(struct iwl_priv *priv);
 void iwl_free_channel_map(struct iwl_priv *priv);
-- 
1.7.0.4

