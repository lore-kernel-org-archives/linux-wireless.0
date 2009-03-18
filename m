Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57755 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbZCREq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohames Abbas <mohames.abbas@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/13] iwlagn: use changed in mac_config
Date: Tue, 17 Mar 2009 21:51:41 -0700
Message-Id: <1237351913-19202-2-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054713_873938_6F180D68)
In-Reply-To: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohames Abbas <mohames.abbas@intel.com>

In function iwl_mac_config use changed flag to call only
the affected functions. This patch also allow user to cache
channel, txpower and power value when the interface is not
ready and apply the changes once the interface ready.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |  161 ++++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 +
 2 files changed, 85 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0db3bc0..4d2ed52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1567,9 +1567,8 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	if (iwl_is_associated(priv)) {
 		struct iwl_rxon_cmd *active_rxon =
 				(struct iwl_rxon_cmd *)&priv->active_rxon;
-
-		memcpy(&priv->staging_rxon, &priv->active_rxon,
-		       sizeof(priv->staging_rxon));
+		/* apply any changes in staging */
+		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
@@ -2184,110 +2183,112 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct iwl_priv *priv = hw->priv;
 	const struct iwl_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
-	unsigned long flags;
+	unsigned long flags = 0;
 	int ret = 0;
-	u16 channel;
+	u16 ch;
+	int scan_active = 0;
 
 	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211(priv, "enter to channel %d\n", conf->channel->hw_value);
-
-	priv->current_ht_config.is_ht = conf_is_ht(conf);
+	IWL_DEBUG_MAC80211(priv, "enter to channel %d changed 0x%X\n",
+					conf->channel->hw_value, changed);
 
-	if (conf->radio_enabled && iwl_radio_kill_sw_enable_radio(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF-KILL - waiting for uCode\n");
-		goto out;
+	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
+			test_bit(STATUS_SCANNING, &priv->status))) {
+		scan_active = 1;
+		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 	}
 
-	if (!conf->radio_enabled)
-		iwl_radio_kill_sw_disable_radio(priv);
 
-	if (!iwl_is_ready(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		ret = -EIO;
-		goto out;
-	}
+	/* during scanning mac80211 will delay channel setting until
+	 * scan finish with changed = 0
+	 */
+	if (!changed || (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
+		if (scan_active)
+			goto set_ch_out;
+
+		ch = ieee80211_frequency_to_channel(conf->channel->center_freq);
+		ch_info = iwl_get_channel_info(priv, conf->channel->band, ch);
+		if (!is_channel_valid(ch_info)) {
+			IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
+			ret = -EINVAL;
+			goto set_ch_out;
+		}
 
-	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
-		     test_bit(STATUS_SCANNING, &priv->status))) {
-		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
-		mutex_unlock(&priv->mutex);
-		return 0;
-	}
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
+			!is_channel_ibss(ch_info)) {
+			IWL_ERR(priv, "channel %d in band %d not "
+				"IBSS channel\n",
+				conf->channel->hw_value, conf->channel->band);
+			ret = -EINVAL;
+			goto set_ch_out;
+		}
 
-	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
-	ch_info = iwl_get_channel_info(priv, conf->channel->band, channel);
-	if (!is_channel_valid(ch_info)) {
-		IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
-		ret = -EINVAL;
-		goto out;
-	}
+		priv->current_ht_config.is_ht = conf_is_ht(conf);
 
-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
-	    !is_channel_ibss(ch_info)) {
-		IWL_ERR(priv, "channel %d in band %d not IBSS channel\n",
-			conf->channel->hw_value, conf->channel->band);
-		ret = -EINVAL;
-		goto out;
-	}
+		spin_lock_irqsave(&priv->lock, flags);
 
-	spin_lock_irqsave(&priv->lock, flags);
 
+		/* if we are switching from ht to 2.4 clear flags
+		 * from any ht related info since 2.4 does not
+		 * support ht */
+		if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
+			priv->staging_rxon.flags = 0;
 
-	/* if we are switching from ht to 2.4 clear flags
-	 * from any ht related info since 2.4 does not
-	 * support ht */
-	if ((le16_to_cpu(priv->staging_rxon.channel) != channel)
-#ifdef IEEE80211_CONF_CHANNEL_SWITCH
-	    && !(conf->flags & IEEE80211_CONF_CHANNEL_SWITCH)
-#endif
-	)
-		priv->staging_rxon.flags = 0;
+		iwl_set_rxon_channel(priv, conf->channel);
+
+		iwl_set_flags_for_band(priv, conf->channel->band);
+		spin_unlock_irqrestore(&priv->lock, flags);
+ set_ch_out:
+		/* The list of supported rates and rate mask can be different
+		 * for each band; since the band may have changed, reset
+		 * the rate mask to what mac80211 lists */
+		iwl_set_rate(priv);
+	}
 
-	iwl_set_rxon_channel(priv, conf->channel);
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		if (conf->flags & IEEE80211_CONF_PS)
+			ret = iwl_power_set_user_mode(priv, IWL_POWER_INDEX_3);
+		else
+			ret = iwl_power_set_user_mode(priv, IWL_POWER_MODE_CAM);
+		if (ret)
+			IWL_DEBUG_MAC80211(priv, "Error setting power level\n");
 
-	iwl_set_flags_for_band(priv, conf->channel->band);
+	}
 
-	/* The list of supported rates and rate mask can be different
-	 * for each band; since the band may have changed, reset
-	 * the rate mask to what mac80211 lists */
-	iwl_set_rate(priv);
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
+			priv->tx_power_user_lmt, conf->power_level);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+		iwl_set_tx_power(priv, conf->power_level, false);
+	}
 
-#ifdef IEEE80211_CONF_CHANNEL_SWITCH
-	if (conf->flags & IEEE80211_CONF_CHANNEL_SWITCH) {
-		iwl_hw_channel_switch(priv, conf->channel);
-		goto out;
+	/* call to ensure that 4965 rx_chain is set properly in monitor mode */
+	iwl_set_rxon_chain(priv);
+
+	if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
+		if (conf->radio_enabled &&
+			iwl_radio_kill_sw_enable_radio(priv)) {
+			IWL_DEBUG_MAC80211(priv, "leave - RF-KILL - "
+						"waiting for uCode\n");
+			goto out;
+		}
+
+		if (!conf->radio_enabled)
+			iwl_radio_kill_sw_disable_radio(priv);
 	}
-#endif
 
 	if (!conf->radio_enabled) {
 		IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
 		goto out;
 	}
 
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF kill\n");
-		ret = -EIO;
+	if (!iwl_is_ready(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		goto out;
 	}
 
-	if (conf->flags & IEEE80211_CONF_PS)
-		ret = iwl_power_set_user_mode(priv, IWL_POWER_INDEX_3);
-	else
-		ret = iwl_power_set_user_mode(priv, IWL_POWER_MODE_CAM);
-	if (ret)
-		IWL_DEBUG_MAC80211(priv, "Error setting power level\n");
-
-	IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
-			   priv->tx_power_user_lmt, conf->power_level);
-
-	iwl_set_tx_power(priv, conf->power_level, false);
-
-	iwl_set_rate(priv);
-
-	/* call to ensure that 4965 rx_chain is set properly in monitor mode */
-	iwl_set_rxon_chain(priv);
+	if (scan_active)
+		goto out;
 
 	if (memcmp(&priv->active_rxon,
 		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
@@ -2295,9 +2296,9 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	else
 		IWL_DEBUG_INFO(priv, "No re-sending same RXON configuration.\n");
 
-	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 out:
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	mutex_unlock(&priv->mutex);
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 085e9cf..bcdecb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1437,6 +1437,10 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 
 	priv->tx_power_user_lmt = tx_power;
 
+	/* if nic is not up don't send command */
+	if (!iwl_is_ready_rf(priv))
+		return ret;
+
 	if (force && priv->cfg->ops->lib->send_tx_power)
 		ret = priv->cfg->ops->lib->send_tx_power(priv);
 
-- 
1.5.6.3

