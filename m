Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42980 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaBLLVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 06:21:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC] iwlwifi: refactor the TX / RX ampdu override
Date: Wed, 12 Feb 2014 13:19:49 +0200
Message-Id: <1392203989-15645-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140212_122154_730879_43432A57)
In-Reply-To: <1392196175-6219-1-git-send-email-egrumbach@gmail.com>
References: <1392196175-6219-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note that this modifies the module parameter values / string
which means that distro will need to update their *.conf file
(if any).

Change-Id: Icfd5a1a6100fcb126e560046551bfb0d1f28179c
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     | 22 ++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-drv.c          |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |  2 --
 drivers/net/wireless/iwlwifi/iwl-modparams.h    | 13 +++++++------
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |  2 --
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 22 ++++++++++++++++++++--
 6 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index ad8f81d..0a9c2ec 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -697,6 +697,24 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
+static inline bool iwl_enable_rx_ampdu(struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.override_ampdu & IWL_DISABLE_HT_RXAGG)
+		return false;
+	return true;
+}
+
+static inline bool iwl_enable_tx_ampdu(struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.override_ampdu & IWL_DISABLE_HT_TXAGG)
+		return false;
+	if (iwlwifi_mod_params.override_ampdu & IWL_ENABLE_HT_TXAGG)
+		return true;
+
+	/* disabled by default */
+	return false;
+}
+
 static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   enum ieee80211_ampdu_mlme_action action,
@@ -718,7 +736,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
+		if (!iwl_enable_rx_ampdu(priv->cfg))
 			break;
 		IWL_DEBUG_HT(priv, "start Rx\n");
 		ret = iwl_sta_rx_agg_start(priv, sta, tid, *ssn);
@@ -730,7 +748,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_START:
 		if (!priv->trans->ops->txq_enable)
 			break;
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
+		if (!iwl_enable_tx_ampdu(priv->cfg))
 			break;
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 65bc944..68e8f3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1661,8 +1661,8 @@ MODULE_PARM_DESC(xvt_default_mode, "xVT is the default operation mode (default:
 
 module_param_named(swcrypto, iwlwifi_mod_params.sw_crypto, int, S_IRUGO);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
-module_param_named(11n_disable, iwlwifi_mod_params.disable_11n, uint, S_IRUGO);
-MODULE_PARM_DESC(11n_disable,
+module_param_named(override_ampdu, iwlwifi_mod_params.override_ampdu, uint, S_IRUGO);
+MODULE_PARM_DESC(override_ampdu,
 	"disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX");
 module_param_named(amsdu_size_8K, iwlwifi_mod_params.amsdu_size_8K,
 		   int, S_IRUGO);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index c44cf11..ae98cb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -893,8 +893,6 @@ iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 	data->sku_cap_band_24GHz_enable = sku & EEPROM_SKU_CAP_BAND_24GHZ;
 	data->sku_cap_band_52GHz_enable = sku & EEPROM_SKU_CAP_BAND_52GHZ;
 	data->sku_cap_ipan_enable = sku & EEPROM_SKU_CAP_IPAN_ENABLE;
-	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
-		data->sku_cap_11n_enable = false;
 
 	data->nvm_version = iwl_eeprom_query16(eeprom, eeprom_size,
 					       EEPROM_VERSION);
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index 1d2f793..9022091 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -79,9 +79,10 @@ enum iwl_power_level {
 	IWL_POWER_NUM
 };
 
-#define IWL_DISABLE_HT_ALL	BIT(0)
-#define IWL_DISABLE_HT_TXAGG	BIT(1)
-#define IWL_DISABLE_HT_RXAGG	BIT(2)
+#define IWL_DISABLE_HT_TXAGG	BIT(0)
+#define IWL_DISABLE_HT_RXAGG	BIT(1)
+#define IWL_ENABLE_HT_TXAGG	BIT(2)
+#define IWL_ENABLE_HT_RXAGG	BIT(3)
 
 /**
  * struct iwl_mod_params
@@ -89,8 +90,8 @@ enum iwl_power_level {
  * Holds the module parameters
  *
  * @sw_crypto: using hardware encryption, default = 0
- * @disable_11n: disable 11n capabilities, default = 0,
- *	use IWL_DISABLE_HT_* constants
+ * @override_ampdu: disable 11n capabilities, default = 0,
+ *	use IWL_[DIS,EN]ABLE_HT_* constants
  * @amsdu_size_8K: enable 8K amsdu size, default = 0
  * @restart_fw: restart firmware, default = 1
  * @wd_disable: disable stuck queue check, default = 1
@@ -104,7 +105,7 @@ enum iwl_power_level {
  */
 struct iwl_mod_params {
 	int sw_crypto;
-	unsigned int disable_11n;
+	unsigned int override_ampdu;
 	int amsdu_size_8K;
 	bool restart_fw;
 	int  wd_disable;
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 3f3536c..9a4ae64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -498,8 +498,6 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 	data->sku_cap_band_52GHz_enable = sku & NVM_SKU_CAP_BAND_52GHZ;
 	data->sku_cap_11n_enable = sku & NVM_SKU_CAP_11N_ENABLE;
 	data->sku_cap_11ac_enable = sku & NVM_SKU_CAP_11AC_ENABLE;
-	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
-		data->sku_cap_11n_enable = false;
 
 	/* check overrides (some devices have wrong NVM) */
 	if (cfg->valid_tx_ant)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 19925bb..daa7d9b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -468,6 +468,24 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	ieee80211_free_txskb(hw, skb);
 }
 
+static inline bool iwl_enable_rx_ampdu(struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.override_ampdu & IWL_DISABLE_HT_RXAGG)
+		return false;
+	return true;
+}
+
+static inline bool iwl_enable_tx_ampdu(struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.override_ampdu & IWL_DISABLE_HT_TXAGG)
+		return false;
+	if (iwlwifi_mod_params.override_ampdu & IWL_ENABLE_HT_TXAGG)
+		return true;
+
+	/* enabled by default */
+	return true;
+}
+
 static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    enum ieee80211_ampdu_mlme_action action,
@@ -487,7 +505,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG) {
+		if (!iwl_enable_rx_ampdu(mvm->cfg)) {
 			ret = -EINVAL;
 			break;
 		}
@@ -497,7 +515,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = iwl_mvm_sta_rx_agg(mvm, sta, tid, 0, false);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG) {
+		if (!iwl_enable_tx_ampdu(mvm->cfg)) {
 			ret = -EINVAL;
 			break;
 		}
-- 
1.8.3.2

