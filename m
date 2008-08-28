Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32034 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbYH1J3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:29:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/11] iwlwifi: use mac80211 band and channel settings
Date: Thu, 28 Aug 2008 17:25:01 +0800
Message-Id: <1219915510-3647-3-git-send-email-yi.zhu@intel.com> (sfid-20080828_112915_673742_B4496816)
In-Reply-To: <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch makes use of mac80211 defaults for channel and band settings
instead of setting them by the driver own. The iwlwifi driver used to
set G band channel 6 as the default channel.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c |   11 +++++------
 drivers/net/wireless/iwlwifi/iwl-core.h |    4 +---
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d44587f..93af115 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2843,7 +2843,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	)
 		priv->staging_rxon.flags = 0;
 
-	iwl_set_rxon_channel(priv, conf->channel->band, channel);
+	iwl_set_rxon_channel(priv, conf->channel);
 
 	iwl_set_flags_for_band(priv, conf->channel->band);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c72f725..09a677c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -773,7 +773,7 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_set_rxon_chain);
 
 /**
- * iwlcore_set_rxon_channel - Set the phymode and channel values in staging RXON
+ * iwl_set_rxon_channel - Set the phymode and channel values in staging RXON
  * @phymode: MODE_IEEE80211A sets to 5.2GHz; all else set to 2.4GHz
  * @channel: Any channel valid for the requested phymode
 
@@ -782,10 +782,11 @@ EXPORT_SYMBOL(iwl_set_rxon_chain);
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the phymode
  */
-int iwl_set_rxon_channel(struct iwl_priv *priv,
-				enum ieee80211_band band,
-				u16 channel)
+int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
 {
+	enum ieee80211_band band = ch->band;
+	u16 channel = ieee80211_frequency_to_channel(ch->center_freq);
+
 	if (!iwl_get_channel_info(priv, band, channel)) {
 		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
 			       channel, band);
@@ -907,8 +908,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
 
-	iwl_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
-
 	priv->rates_mask = IWL_RATES_MASK;
 	/* If power management is turned on, default to AC mode */
 	priv->power_mode = IWL_POWER_AC;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 64f139e..ff86abc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -189,9 +189,7 @@ void iwl_clear_stations_table(struct iwl_priv *priv);
 void iwl_free_calib_results(struct iwl_priv *priv);
 void iwl_reset_qos(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
-int iwl_set_rxon_channel(struct iwl_priv *priv,
-				enum ieee80211_band band,
-				u16 channel);
+int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info);
 u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_ht_info *sta_ht_inf);
-- 
1.5.3.6

