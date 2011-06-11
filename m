Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758578Ab1FKOzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:41 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/18] iwlagn: use sku capabilities information from EEPROM
Date: Sat, 11 Jun 2011 07:25:42 -0700
Message-Id: <1307802352-16398-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165554_772477_0AE4C698)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of having the separated define, use the sku capabilities in EEPROM

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    9 +--------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-core.c       |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-core.h       |    6 +-----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |    3 ---
 6 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 2ef9448..512d8be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -108,18 +108,11 @@ err:
 
 int iwl_eeprom_check_sku(struct iwl_priv *priv)
 {
-	u16 eeprom_sku;
 	u16 radio_cfg;
 
-	eeprom_sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
-
 	if (!priv->cfg->sku) {
 		/* not using sku overwrite */
-		priv->cfg->sku =
-			((eeprom_sku & EEPROM_SKU_CAP_BAND_SELECTION) >>
-			EEPROM_SKU_CAP_BAND_POS);
-		if (eeprom_sku & EEPROM_SKU_CAP_11N_ENABLE)
-			priv->cfg->sku |= IWL_SKU_N;
+		priv->cfg->sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
 	}
 	if (!priv->cfg->sku) {
 		IWL_ERR(priv, "Invalid device sku\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 58f6da0..90cd647 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1532,7 +1532,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 	memset(&flush_cmd, 0, sizeof(flush_cmd));
 	flush_cmd.fifo_control = IWL_TX_FIFO_VO_MSK | IWL_TX_FIFO_VI_MSK |
 				 IWL_TX_FIFO_BE_MSK | IWL_TX_FIFO_BK_MSK;
-	if (priv->cfg->sku & IWL_SKU_N)
+	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		flush_cmd.fifo_control |= IWL_AGG_TX_QUEUE_MSK;
 
 	IWL_DEBUG_INFO(priv, "fifo queue control: 0X%x\n",
@@ -2318,7 +2318,8 @@ int iwlagn_start_device(struct iwl_priv *priv)
 {
 	int ret;
 
-	if (iwl_prepare_card_hw(priv)) {
+	if ((priv->cfg->sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
+	     iwl_prepare_card_hw(priv)) {
 		IWL_WARN(priv, "Exit HW not ready\n");
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3cd42a5..488081f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2515,7 +2515,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 	hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
-	if (priv->cfg->sku & IWL_SKU_N)
+	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
@@ -2756,7 +2756,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
 
-	if (!(priv->cfg->sku & IWL_SKU_N))
+	if (!(priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE))
 		return -EACCES;
 
 	mutex_lock(&priv->mutex);
@@ -3375,7 +3375,7 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_beacon_itrvl = IWL_MAX_UCODE_BEACON_INTERVAL;
 
 	if (iwlagn_mod_params.disable_11n)
-		priv->cfg->sku &= ~IWL_SKU_N;
+		priv->cfg->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
 	/* Device-specific setup */
 	return priv->cfg->ops->lib->set_hw_params(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ad54f82..445ddac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -143,7 +143,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
 
-	if (priv->cfg->sku & IWL_SKU_N)
+	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		iwlcore_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_5GHZ);
 
@@ -153,7 +153,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	sband->bitrates = rates;
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY;
 
-	if (priv->cfg->sku & IWL_SKU_N)
+	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		iwlcore_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_2GHZ);
 
@@ -208,12 +208,12 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	priv->tx_power_next = max_tx_power;
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
-	     priv->cfg->sku & IWL_SKU_A) {
+	     priv->cfg->sku & EEPROM_SKU_CAP_BAND_52GHZ) {
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
 			"Please send your PCI ID 0x%04X:0x%04X to maintainer.\n",
 			   priv->pci_dev->device,
 			   priv->pci_dev->subsystem_device);
-		priv->cfg->sku &= ~IWL_SKU_A;
+		priv->cfg->sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
 	}
 
 	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a16daf7..83ec5eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -83,10 +83,6 @@ struct iwl_cmd;
 
 #define TIME_UNIT		1024
 
-#define IWL_SKU_G       0x1
-#define IWL_SKU_A       0x2
-#define IWL_SKU_N       0x8
-
 #define IWL_CMD(x) case x: return #x
 
 struct iwl_hcmd_ops {
@@ -292,7 +288,7 @@ struct iwl_cfg {
 	const unsigned int ucode_api_min;
 	u8   valid_tx_ant;
 	u8   valid_rx_ant;
-	unsigned int sku;
+	u16  sku;
 	u16  eeprom_ver;
 	u16  eeprom_calib_ver;
 	const struct iwl_ops *ops;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 5086318..2d70053 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -110,9 +110,6 @@ enum {
 };
 
 /* SKU Capabilities */
-#define EEPROM_SKU_CAP_BAND_POS				(4)
-#define EEPROM_SKU_CAP_BAND_SELECTION	                \
-		(3 << EEPROM_SKU_CAP_BAND_POS)
 #define EEPROM_SKU_CAP_BAND_24GHZ			(1 << 4)
 #define EEPROM_SKU_CAP_BAND_52GHZ			(1 << 5)
 #define EEPROM_SKU_CAP_11N_ENABLE	                (1 << 6)
-- 
1.7.0.4

