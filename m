Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24824 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580AbZDHSVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/18] iwl3945: use iwl_mac_config from iwlwifi
Date: Wed,  8 Apr 2009 11:26:48 -0700
Message-Id: <1239215212-1657-15-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202123_287617_F23D7F21)
In-Reply-To: <1239215212-1657-14-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-6-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-7-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-8-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-9-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-10-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-11-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-12-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-13-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-14-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can now use iwl_mac_config from iwlwifi

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  133 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |  136 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  106 +---------------------
 4 files changed, 138 insertions(+), 238 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index facd348..8a8ff0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2036,139 +2036,6 @@ static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-/**
- * iwl_mac_config - mac80211 config callback
- *
- * We ignore conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME since it seems to
- * be set inappropriately and the driver currently sets the hardware up to
- * use it whenever needed.
- */
-static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
-{
-	struct iwl_priv *priv = hw->priv;
-	const struct iwl_channel_info *ch_info;
-	struct ieee80211_conf *conf = &hw->conf;
-	unsigned long flags = 0;
-	int ret = 0;
-	u16 ch;
-	int scan_active = 0;
-
-	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211(priv, "enter to channel %d changed 0x%X\n",
-					conf->channel->hw_value, changed);
-
-	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
-			test_bit(STATUS_SCANNING, &priv->status))) {
-		scan_active = 1;
-		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
-	}
-
-
-	/* during scanning mac80211 will delay channel setting until
-	 * scan finish with changed = 0
-	 */
-	if (!changed || (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
-		if (scan_active)
-			goto set_ch_out;
-
-		ch = ieee80211_frequency_to_channel(conf->channel->center_freq);
-		ch_info = iwl_get_channel_info(priv, conf->channel->band, ch);
-		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
-			ret = -EINVAL;
-			goto set_ch_out;
-		}
-
-		if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
-			!is_channel_ibss(ch_info)) {
-			IWL_ERR(priv, "channel %d in band %d not "
-				"IBSS channel\n",
-				conf->channel->hw_value, conf->channel->band);
-			ret = -EINVAL;
-			goto set_ch_out;
-		}
-
-		priv->current_ht_config.is_ht = conf_is_ht(conf);
-
-		spin_lock_irqsave(&priv->lock, flags);
-
-
-		/* if we are switching from ht to 2.4 clear flags
-		 * from any ht related info since 2.4 does not
-		 * support ht */
-		if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
-			priv->staging_rxon.flags = 0;
-
-		iwl_set_rxon_channel(priv, conf->channel);
-
-		iwl_set_flags_for_band(priv, conf->channel->band);
-		spin_unlock_irqrestore(&priv->lock, flags);
- set_ch_out:
-		/* The list of supported rates and rate mask can be different
-		 * for each band; since the band may have changed, reset
-		 * the rate mask to what mac80211 lists */
-		iwl_set_rate(priv);
-	}
-
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		if (conf->flags & IEEE80211_CONF_PS)
-			ret = iwl_power_set_user_mode(priv, IWL_POWER_INDEX_3);
-		else
-			ret = iwl_power_set_user_mode(priv, IWL_POWER_MODE_CAM);
-		if (ret)
-			IWL_DEBUG_MAC80211(priv, "Error setting power level\n");
-
-	}
-
-	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
-			priv->tx_power_user_lmt, conf->power_level);
-
-		iwl_set_tx_power(priv, conf->power_level, false);
-	}
-
-	/* call to ensure that 4965 rx_chain is set properly in monitor mode */
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
-
-	if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
-		if (conf->radio_enabled &&
-			iwl_radio_kill_sw_enable_radio(priv)) {
-			IWL_DEBUG_MAC80211(priv, "leave - RF-KILL - "
-						"waiting for uCode\n");
-			goto out;
-		}
-
-		if (!conf->radio_enabled)
-			iwl_radio_kill_sw_disable_radio(priv);
-	}
-
-	if (!conf->radio_enabled) {
-		IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
-		goto out;
-	}
-
-	if (!iwl_is_ready(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		goto out;
-	}
-
-	if (scan_active)
-		goto out;
-
-	if (memcmp(&priv->active_rxon,
-		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
-		iwlcore_commit_rxon(priv);
-	else
-		IWL_DEBUG_INFO(priv, "No re-sending same RXON configuration.\n");
-
-
-out:
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	mutex_unlock(&priv->mutex);
-	return ret;
-}
-
 static void iwl_config_ap(struct iwl_priv *priv)
 {
 	int ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 042452f..5876fe5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2442,6 +2442,142 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(iwl_mac_remove_interface);
 
+/**
+ * iwl_mac_config - mac80211 config callback
+ *
+ * We ignore conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME since it seems to
+ * be set inappropriately and the driver currently sets the hardware up to
+ * use it whenever needed.
+ */
+int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct iwl_priv *priv = hw->priv;
+	const struct iwl_channel_info *ch_info;
+	struct ieee80211_conf *conf = &hw->conf;
+	unsigned long flags = 0;
+	int ret = 0;
+	u16 ch;
+	int scan_active = 0;
+
+	mutex_lock(&priv->mutex);
+
+	if (!iwl_is_ready(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	IWL_DEBUG_MAC80211(priv, "enter to channel %d changed 0x%X\n",
+					conf->channel->hw_value, changed);
+
+	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
+			test_bit(STATUS_SCANNING, &priv->status))) {
+		scan_active = 1;
+		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
+	}
+
+
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
+
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
+			!is_channel_ibss(ch_info)) {
+			IWL_ERR(priv, "channel %d in band %d not "
+				"IBSS channel\n",
+				conf->channel->hw_value, conf->channel->band);
+			ret = -EINVAL;
+			goto set_ch_out;
+		}
+
+		priv->current_ht_config.is_ht = conf_is_ht(conf);
+
+		spin_lock_irqsave(&priv->lock, flags);
+
+
+		/* if we are switching from ht to 2.4 clear flags
+		 * from any ht related info since 2.4 does not
+		 * support ht */
+		if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
+			priv->staging_rxon.flags = 0;
+
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
+
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		if (conf->flags & IEEE80211_CONF_PS)
+			ret = iwl_power_set_user_mode(priv, IWL_POWER_INDEX_3);
+		else
+			ret = iwl_power_set_user_mode(priv, IWL_POWER_MODE_CAM);
+		if (ret)
+			IWL_DEBUG_MAC80211(priv, "Error setting power level\n");
+
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
+			priv->tx_power_user_lmt, conf->power_level);
+
+		iwl_set_tx_power(priv, conf->power_level, false);
+	}
+
+	/* call to ensure that 4965 rx_chain is set properly in monitor mode */
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
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
+	}
+
+	if (!conf->radio_enabled) {
+		IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
+		goto out;
+	}
+
+	if (scan_active)
+		goto out;
+
+	if (memcmp(&priv->active_rxon,
+		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
+		iwlcore_commit_rxon(priv);
+	else
+		IWL_DEBUG_INFO(priv, "Not re-sending same RXON configuration.\n");
+
+
+out:
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	mutex_unlock(&priv->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_mac_config);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5dc3306..da8fae5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -278,6 +278,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf);
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf);
+int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
 
 /*****************************************************
  * RX handlers.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 896694b..8407bb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3166,8 +3166,6 @@ static void iwl3945_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed);
-
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 
 void iwl3945_post_associate(struct iwl_priv *priv)
@@ -3380,108 +3378,6 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-/**
- * iwl3945_mac_config - mac80211 config callback
- *
- * We ignore conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME since it seems to
- * be set inappropriately and the driver currently sets the hardware up to
- * use it whenever needed.
- */
-static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
-{
-	struct iwl_priv *priv = hw->priv;
-	const struct iwl_channel_info *ch_info;
-	struct ieee80211_conf *conf = &hw->conf;
-	unsigned long flags;
-	int ret = 0;
-
-	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211(priv, "enter to channel %d\n",
-				conf->channel->hw_value);
-
-	if (!iwl_is_ready(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		ret = -EIO;
-		goto out;
-	}
-
-	if (unlikely(!iwl3945_mod_params.disable_hw_scan &&
-		     test_bit(STATUS_SCANNING, &priv->status))) {
-		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
-		set_bit(STATUS_CONF_PENDING, &priv->status);
-		mutex_unlock(&priv->mutex);
-		return 0;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	ch_info = iwl_get_channel_info(priv, conf->channel->band,
-				       conf->channel->hw_value);
-	if (!is_channel_valid(ch_info)) {
-		IWL_DEBUG_SCAN(priv,
-				"Channel %d [%d] is INVALID for this band.\n",
-				conf->channel->hw_value, conf->channel->band);
-		IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
-		spin_unlock_irqrestore(&priv->lock, flags);
-		ret = -EINVAL;
-		goto out;
-	}
-
-	iwl_set_rxon_channel(priv, conf->channel);
-
-	iwl_set_flags_for_band(priv, conf->channel->band);
-
-	/* The list of supported rates and rate mask can be different
-	 * for each phymode; since the phymode may have changed, reset
-	 * the rate mask to what mac80211 lists */
-	iwl_set_rate(priv);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-#ifdef IEEE80211_CONF_CHANNEL_SWITCH
-	if (conf->flags & IEEE80211_CONF_CHANNEL_SWITCH) {
-		iwl3945_hw_channel_switch(priv, conf->channel);
-		goto out;
-	}
-#endif
-
-	if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
-		if (conf->radio_enabled &&
-		    iwl_radio_kill_sw_enable_radio(priv)) {
-			IWL_DEBUG_MAC80211(priv, "leave - RF-KILL - "
-						 "waiting for uCode\n");
-			goto out;
-		}
-
-		if (!conf->radio_enabled) {
-			iwl_radio_kill_sw_disable_radio(priv);
-			IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
-			goto out;
-		}
-	}
-
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF kill\n");
-		ret = -EIO;
-		goto out;
-	}
-
-	iwl_set_rate(priv);
-
-	if (memcmp(&priv->active_rxon,
-		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
-		iwlcore_commit_rxon(priv);
-	else
-		IWL_DEBUG_INFO(priv, "Not re-sending same RXON configuration\n");
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-out:
-	clear_bit(STATUS_CONF_PENDING, &priv->status);
-	mutex_unlock(&priv->mutex);
-	return ret;
-}
-
 static void iwl3945_config_ap(struct iwl_priv *priv)
 {
 	int rc = 0;
@@ -4316,7 +4212,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.stop = iwl3945_mac_stop,
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
-	.config = iwl3945_mac_config,
+	.config = iwl_mac_config,
 	.config_interface = iwl3945_mac_config_interface,
 	.configure_filter = iwl_configure_filter,
 	.set_key = iwl3945_mac_set_key,
-- 
1.5.6.3

