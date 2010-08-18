Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab0HRQSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/16] iwlwifi: avoid race condition in channel change
Date: Wed, 18 Aug 2010 09:22:41 -0700
Message-Id: <1282148571-9258-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

When iwl_mac_config() is called by mac80211, the channel pointer
hw->conf->channel can potentially change, resulting in mismatch
band and channel number when configuring RXON command. To avoid
this situation, save the channel pointer in local variables
and validate the channel before using it. Note that priv->mutex
is locked during the whole function so the local variables are safe.

Same change is applied to iwl_mac_channel_switch() since basically
it copies code from iwl_mac_config().

Also removed an outdated comment in the flow.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   14 ++++++--------
 drivers/net/wireless/iwlwifi/iwl-core.c |   14 ++++++--------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 00cbb83..8011105 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3632,6 +3632,7 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 	const struct iwl_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_channel *channel = ch_switch->channel;
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
 	u16 ch;
 	unsigned long flags = 0;
@@ -3655,10 +3656,10 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 	if (priv->cfg->ops->lib->set_channel_switch) {
 
-		ch = ch_switch->channel->hw_value;
+		ch = channel->hw_value;
 		if (le16_to_cpu(priv->active_rxon.channel) != ch) {
 			ch_info = iwl_get_channel_info(priv,
-						       conf->channel->band,
+						       channel->band,
 						       ch);
 			if (!is_channel_valid(ch_info)) {
 				IWL_DEBUG_MAC80211(priv, "invalid channel\n");
@@ -3687,15 +3688,12 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 			} else
 				ht_conf->is_40mhz = false;
 
-			/* if we are switching from ht to 2.4 clear flags
-			 * from any ht related info since 2.4 does not
-			 * support ht */
-			if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
+			if (le16_to_cpu(priv->staging_rxon.channel) != ch)
 				priv->staging_rxon.flags = 0;
 
-			iwl_set_rxon_channel(priv, conf->channel);
+			iwl_set_rxon_channel(priv, channel);
 			iwl_set_rxon_ht(priv, ht_conf);
-			iwl_set_flags_for_band(priv, conf->channel->band,
+			iwl_set_flags_for_band(priv, channel->band,
 					       priv->vif);
 			spin_unlock_irqrestore(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 221a211..fc78690 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1947,6 +1947,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct iwl_priv *priv = hw->priv;
 	const struct iwl_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_channel *channel = conf->channel;
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
 	unsigned long flags = 0;
 	int ret = 0;
@@ -1956,7 +1957,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "enter to channel %d changed 0x%X\n",
-					conf->channel->hw_value, changed);
+					channel->hw_value, changed);
 
 	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
 			test_bit(STATUS_SCANNING, &priv->status))) {
@@ -1987,8 +1988,8 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		if (scan_active)
 			goto set_ch_out;
 
-		ch = conf->channel->hw_value;
-		ch_info = iwl_get_channel_info(priv, conf->channel->band, ch);
+		ch = channel->hw_value;
+		ch_info = iwl_get_channel_info(priv, channel->band, ch);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
 			ret = -EINVAL;
@@ -2019,16 +2020,13 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		 * from BSS config in iwl_ht_conf */
 		ht_conf->ht_protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
 
-		/* if we are switching from ht to 2.4 clear flags
-		 * from any ht related info since 2.4 does not
-		 * support ht */
 		if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
 			priv->staging_rxon.flags = 0;
 
-		iwl_set_rxon_channel(priv, conf->channel);
+		iwl_set_rxon_channel(priv, channel);
 		iwl_set_rxon_ht(priv, ht_conf);
 
-		iwl_set_flags_for_band(priv, conf->channel->band, priv->vif);
+		iwl_set_flags_for_band(priv, channel->band, priv->vif);
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 		if (priv->cfg->ops->lib->update_bcast_station)
-- 
1.7.0.4

