Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbYICDbE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/39] iwlwifi: align set channel with mac80211
Date: Wed,  3 Sep 2008 11:26:26 +0800
Message-Id: <1220412419-15404-7-git-send-email-yi.zhu@intel.com> (sfid-20080903_053109_203875_2D44885A)
In-Reply-To: <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch makes use of mac80211 defaults for channel and band.
Older code that uses G band channel 6 was removed. This patch also
changes iwl_set_rxon_channel signature.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c |   11 +++++------
 drivers/net/wireless/iwlwifi/iwl-core.h |    4 +---
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 08ca2a3..f1a5225 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2841,7 +2841,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	)
 		priv->staging_rxon.flags = 0;
 
-	iwl_set_rxon_channel(priv, conf->channel->band, channel);
+	iwl_set_rxon_channel(priv, conf->channel);
 
 	iwl_set_flags_for_band(priv, conf->channel->band);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fbf75a6..bb03032 100644
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
@@ -906,8 +907,6 @@ int iwl_init_drv(struct iwl_priv *priv)
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

