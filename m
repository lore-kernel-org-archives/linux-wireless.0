Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab2CDUm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:42:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 013/101] iwlwifi: remove SKU from config
Date: Sun,  4 Mar 2012 11:28:27 -0800
Message-Id: <1330889395-533-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214644_938323_AAEE6DA4)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no SKU override, we always just use
it from EEPROM. As such, we can remove it
from the config and use it in hw_param only.
Since iwl_eeprom_check_sku() really needs
to fill it in also rename that to
iwl_eeprom_init_hw_params().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   20 +++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    2 --
 7 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 2470ca7..79ac7cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -235,7 +235,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
 				IWL_PAN_SCD_MULTICAST_MSK;
 
-	if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
 		flush_cmd.fifo_control |= IWL_AGG_TX_QUEUE_MSK;
 
 	IWL_DEBUG_INFO(priv, "fifo queue control: 0X%x\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c14eda0..e1bf125 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1124,13 +1124,12 @@ static void iwl_set_hw_params(struct iwl_priv *priv)
 			get_order(IWL_RX_BUF_SIZE_4K);
 
 	if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
-		cfg(priv)->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
+		hw_params(priv).sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
 	hw_params(priv).num_ampdu_queues =
 		cfg(priv)->base_params->num_of_ampdu_queues;
 	hw_params(priv).shadow_reg_enable =
 		cfg(priv)->base_params->shadow_reg_enable;
-	hw_params(priv).sku = cfg(priv)->sku;
 	hw_params(priv).wd_timeout = cfg(priv)->base_params->wd_timeout;
 
 	/* Device-specific setup */
@@ -1257,7 +1256,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans)
 	if (err)
 		goto out_free_eeprom;
 
-	err = iwl_eeprom_check_sku(priv);
+	err = iwl_eeprom_init_hw_params(priv);
 	if (err)
 		goto out_free_eeprom;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 67c82a4..3c1b1e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -137,7 +137,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
 
-	if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
 		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_5GHZ);
 
@@ -147,7 +147,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 	sband->bitrates = rates;
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY;
 
-	if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
 		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_2GHZ);
 
@@ -202,11 +202,11 @@ int iwl_init_geos(struct iwl_priv *priv)
 	priv->tx_power_next = max_tx_power;
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
-	     cfg(priv)->sku & EEPROM_SKU_CAP_BAND_52GHZ) {
+	     hw_params(priv).sku & EEPROM_SKU_CAP_BAND_52GHZ) {
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
 			"Please send your %s to maintainer.\n",
 			trans(priv)->hw_id_str);
-		cfg(priv)->sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
+		hw_params(priv).sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
 	}
 
 	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 07e9378..d8668bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -252,26 +252,24 @@ err:
 
 }
 
-int iwl_eeprom_check_sku(struct iwl_priv *priv)
+int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 {
 	struct iwl_shared *shrd = priv->shrd;
 	u16 radio_cfg;
 
-	if (!cfg(priv)->sku) {
-		/* not using sku overwrite */
-		cfg(priv)->sku = iwl_eeprom_query16(shrd, EEPROM_SKU_CAP);
-		if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE &&
-		    !cfg(priv)->ht_params) {
-			IWL_ERR(priv, "Invalid 11n configuration\n");
-			return -EINVAL;
-		}
+	hw_params(priv).sku = iwl_eeprom_query16(shrd, EEPROM_SKU_CAP);
+	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE &&
+	    !cfg(priv)->ht_params) {
+		IWL_ERR(priv, "Invalid 11n configuration\n");
+		return -EINVAL;
 	}
-	if (!cfg(priv)->sku) {
+
+	if (!hw_params(priv).sku) {
 		IWL_ERR(priv, "Invalid device sku\n");
 		return -EINVAL;
 	}
 
-	IWL_INFO(priv, "Device SKU: 0x%X\n", cfg(priv)->sku);
+	IWL_INFO(priv, "Device SKU: 0x%X\n", hw_params(priv).sku);
 
 	if (!cfg(priv)->valid_tx_ant && !cfg(priv)->valid_rx_ant) {
 		/* not using .cfg overwrite */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index cbb8611..3b17056 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -309,7 +309,7 @@ struct iwl_eeprom_ops {
 int iwl_eeprom_init(struct iwl_trans *trans, u32 hw_rev);
 void iwl_eeprom_free(struct iwl_shared *shrd);
 int  iwl_eeprom_check_version(struct iwl_priv *priv);
-int  iwl_eeprom_check_sku(struct iwl_priv *priv);
+int iwl_eeprom_init_hw_params(struct iwl_priv *priv);
 const u8 *iwl_eeprom_query_addr(const struct iwl_shared *shrd, size_t offset);
 u16 iwl_eeprom_query16(const struct iwl_shared *shrd, size_t offset);
 int iwl_init_channel_map(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 005763f..8b26f32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -161,7 +161,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
-	if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
@@ -633,7 +633,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
 
-	if (!(cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE))
+	if (!(hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE))
 		return -EACCES;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 239dfbc..11184f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -282,7 +282,6 @@ enum iwl_led_mode {
  * @max_data_size: The maximal length of the fw data section
  * @valid_tx_ant: valid transmit antenna
  * @valid_rx_ant: valid receive antenna
- * @sku: sku information from EEPROM
  * @eeprom_ver: EEPROM version
  * @eeprom_calib_ver: EEPROM calibration version
  * @lib: pointer to the lib ops
@@ -321,7 +320,6 @@ struct iwl_cfg {
 	const u32 max_inst_size;
 	u8   valid_tx_ant;
 	u8   valid_rx_ant;
-	u16  sku;
 	u16  eeprom_ver;
 	u16  eeprom_calib_ver;
 	const struct iwl_lib_ops *lib;
-- 
1.7.0.4

