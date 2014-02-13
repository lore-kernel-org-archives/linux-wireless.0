Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29629 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbaBMMaA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 07:30:00 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlwifi: disable TX AMPDU by default for iwldvm
Date: Thu, 13 Feb 2014 14:28:03 +0200
Message-Id: <1392294483-6041-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140213_133004_537751_77DB8CCC)
In-Reply-To: <1392196175-6219-1-git-send-email-egrumbach@gmail.com>
References: <1392196175-6219-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NICs supported by iwldvm don't handle well TX AMPDU.
Disable it by default, still leave the possibility to
the user to force enable it with a debug parameter.

NICs supported by iwlmvm don't suffer from the same issue,
leave TX AMPDU enabled by default for these.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  | 22 ++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-drv.c       |  2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h | 11 +++++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 22 ++++++++++++++++++++--
 4 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index ad8f81d..99bf6f9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -697,6 +697,24 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
+static inline bool iwl_enable_rx_ampdu(const struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
+		return false;
+	return true;
+}
+
+static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
+		return false;
+	if (iwlwifi_mod_params.disable_11n & IWL_ENABLE_HT_TXAGG)
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
index 65bc944..dfdeccd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1663,7 +1663,7 @@ module_param_named(swcrypto, iwlwifi_mod_params.sw_crypto, int, S_IRUGO);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(11n_disable, iwlwifi_mod_params.disable_11n, uint, S_IRUGO);
 MODULE_PARM_DESC(11n_disable,
-	"disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX");
+	"disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX");
 module_param_named(amsdu_size_8K, iwlwifi_mod_params.amsdu_size_8K,
 		   int, S_IRUGO);
 MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size (default 0)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index 1d2f793..34ce808 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -79,9 +79,12 @@ enum iwl_power_level {
 	IWL_POWER_NUM
 };
 
-#define IWL_DISABLE_HT_ALL	BIT(0)
-#define IWL_DISABLE_HT_TXAGG	BIT(1)
-#define IWL_DISABLE_HT_RXAGG	BIT(2)
+enum iwl_disable_11n {
+	IWL_DISABLE_HT_ALL	 = BIT(0),
+	IWL_DISABLE_HT_TXAGG	 = BIT(1),
+	IWL_DISABLE_HT_RXAGG	 = BIT(2),
+	IWL_ENABLE_HT_TXAGG	 = BIT(3),
+};
 
 /**
  * struct iwl_mod_params
@@ -90,7 +93,7 @@ enum iwl_power_level {
  *
  * @sw_crypto: using hardware encryption, default = 0
  * @disable_11n: disable 11n capabilities, default = 0,
- *	use IWL_DISABLE_HT_* constants
+ *	use IWL_[DIS,EN]ABLE_HT_* constants
  * @amsdu_size_8K: enable 8K amsdu size, default = 0
  * @restart_fw: restart firmware, default = 1
  * @wd_disable: disable stuck queue check, default = 1
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 19925bb..068f785 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -468,6 +468,24 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	ieee80211_free_txskb(hw, skb);
 }
 
+static inline bool iwl_enable_rx_ampdu(const struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
+		return false;
+	return true;
+}
+
+static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
+		return false;
+	if (iwlwifi_mod_params.disable_11n & IWL_ENABLE_HT_TXAGG)
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

