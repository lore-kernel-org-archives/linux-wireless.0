Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYE2IiD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:38:03 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 43/43] iwlwifi: clean iwl4965_mac_config
Date: Thu, 29 May 2008 16:35:28 +0800
Message-Id: <1212050128-17132-44-git-send-email-yi.zhu@intel.com> (sfid-20080529_103817_849957_0617130D)
In-Reply-To: <1212050128-17132-43-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-40-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-41-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-42-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-43-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch cleans up iwl4965_mac_config.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    5 ++---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   23 +++++++++++------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index e559c19..11f9d95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -573,9 +573,8 @@ void iwl_free_channel_map(struct iwl_priv *priv)
  *
  * Based on band and channel number.
  */
-const struct iwl_channel_info *iwl_get_channel_info(
-		const struct iwl_priv *priv,
-		enum ieee80211_band band, u16 channel)
+const struct iwl_channel_info *iwl_get_channel_info(const struct iwl_priv *priv,
+					enum ieee80211_band band, u16 channel)
 {
 	int i;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e5e8ad8..c71daec 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1084,8 +1084,8 @@ static int iwl4965_scan_initiate(struct iwl_priv *priv)
 }
 
 
-static void iwl4965_set_flags_for_phymode(struct iwl_priv *priv,
-					  enum ieee80211_band band)
+static void iwl_set_flags_for_band(struct iwl_priv *priv,
+				   enum ieee80211_band band)
 {
 	if (band == IEEE80211_BAND_5GHZ) {
 		priv->staging_rxon.flags &=
@@ -1170,7 +1170,7 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
 	priv->band = ch_info->band;
 
-	iwl4965_set_flags_for_phymode(priv, priv->band);
+	iwl_set_flags_for_band(priv, priv->band);
 
 	priv->staging_rxon.ofdm_basic_rates =
 	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
@@ -3823,6 +3823,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	const struct iwl_channel_info *ch_info;
 	unsigned long flags;
 	int ret = 0;
+	u16 channel;
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_value);
@@ -3843,22 +3844,21 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		return 0;
 	}
 
-	spin_lock_irqsave(&priv->lock, flags);
-
-	ch_info = iwl_get_channel_info(priv, conf->channel->band,
-			ieee80211_frequency_to_channel(conf->channel->center_freq));
+	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	ch_info = iwl_get_channel_info(priv, conf->channel->band, channel);
 	if (!is_channel_valid(ch_info)) {
 		IWL_DEBUG_MAC80211("leave - invalid channel\n");
-		spin_unlock_irqrestore(&priv->lock, flags);
 		ret = -EINVAL;
 		goto out;
 	}
 
+	spin_lock_irqsave(&priv->lock, flags);
+
 #ifdef CONFIG_IWL4965_HT
 	/* if we are switching from ht to 2.4 clear flags
 	 * from any ht related info since 2.4 does not
 	 * support ht */
-	if ((le16_to_cpu(priv->staging_rxon.channel) != conf->channel->hw_value)
+	if ((le16_to_cpu(priv->staging_rxon.channel) != channel)
 #ifdef IEEE80211_CONF_CHANNEL_SWITCH
 	    && !(conf->flags & IEEE80211_CONF_CHANNEL_SWITCH)
 #endif
@@ -3866,10 +3866,9 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		priv->staging_rxon.flags = 0;
 #endif /* CONFIG_IWL4965_HT */
 
-	iwl_set_rxon_channel(priv, conf->channel->band,
-		ieee80211_frequency_to_channel(conf->channel->center_freq));
+	iwl_set_rxon_channel(priv, conf->channel->band, channel);
 
-	iwl4965_set_flags_for_phymode(priv, conf->channel->band);
+	iwl_set_flags_for_band(priv, conf->channel->band);
 
 	/* The list of supported rates and rate mask can be different
 	 * for each band; since the band may have changed, reset
-- 
1.5.3.6

