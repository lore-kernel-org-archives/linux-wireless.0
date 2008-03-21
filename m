Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761420AbYCUU6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 16:58:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/5] iwlwifi: rename iwl4965_get_channel_info to iwl_get_channel_info
Date: Fri, 21 Mar 2008 13:53:43 -0700
Message-Id: <1206132824-20558-5-git-send-email-reinette.chatre@intel.com> (sfid-20080321_210001_205184_D80A467C)
In-Reply-To: <1206132824-20558-4-git-send-email-reinette.chatre@intel.com>
References: <1206132824-20558-1-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-2-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-3-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

iwl4965_get_channel_info was moved to iwlcore module
4965 needs to be stripped off

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 ++++----
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 376968f..772318c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2064,7 +2064,7 @@ iwl4965_get_channel_txpower_info(struct iwl_priv *priv,
 {
 	const struct iwl_channel_info *ch_info;
 
-	ch_info = iwl4965_get_channel_info(priv, band, channel);
+	ch_info = iwl_get_channel_info(priv, band, channel);
 
 	if (!is_channel_valid(ch_info))
 		return NULL;
@@ -2772,7 +2772,7 @@ int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 
 	band = priv->band == IEEE80211_BAND_2GHZ;
 
-	ch_info = iwl4965_get_channel_info(priv, priv->band, channel);
+	ch_info = iwl_get_channel_info(priv, priv->band, channel);
 
 	is_fat = is_fat_channel(priv->staging_rxon.flags);
 
@@ -4582,7 +4582,7 @@ static u8 iwl4965_is_channel_extension(struct iwl_priv *priv,
 {
 	const struct iwl_channel_info *ch_info;
 
-	ch_info = iwl4965_get_channel_info(priv, band, channel);
+	ch_info = iwl_get_channel_info(priv, band, channel);
 	if (!is_channel_valid(ch_info))
 		return 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 0842176..26bd9c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1263,7 +1263,7 @@ static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
-extern const struct iwl_channel_info *iwl4965_get_channel_info(
+extern const struct iwl_channel_info *iwl_get_channel_info(
 	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
 
 /* Requires full declaration of iwl_priv before including */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0e9c3b3..da51349 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -191,7 +191,7 @@ int iwlcore_set_rxon_channel(struct iwl_priv *priv,
 				enum ieee80211_band band,
 				u16 channel)
 {
-	if (!iwl4965_get_channel_info(priv, band, channel)) {
+	if (!iwl_get_channel_info(priv, band, channel)) {
 		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
 			       channel, band);
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 32ebec3..72cad56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -329,7 +329,7 @@ static int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
 	struct iwl_channel_info *ch_info;
 
 	ch_info = (struct iwl_channel_info *)
-			iwl4965_get_channel_info(priv, band, channel);
+			iwl_get_channel_info(priv, band, channel);
 
 	if (!is_channel_valid(ch_info))
 		return -1;
@@ -534,7 +534,7 @@ EXPORT_SYMBOL(iwl_free_channel_map);
  *
  * Based on band and channel number.
  */
-const struct iwl_channel_info *iwl4965_get_channel_info(
+const struct iwl_channel_info *iwl_get_channel_info(
 		const struct iwl_priv *priv,
 		enum ieee80211_band band, u16 channel)
 {
@@ -557,5 +557,5 @@ const struct iwl_channel_info *iwl4965_get_channel_info(
 
 	return NULL;
 }
-EXPORT_SYMBOL(iwl4965_get_channel_info);
+EXPORT_SYMBOL(iwl_get_channel_info);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 8a58394..bd0a042 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -368,7 +368,7 @@ void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv);
 
 int iwl_init_channel_map(struct iwl_priv *priv);
 void iwl_free_channel_map(struct iwl_priv *priv);
-const struct iwl_channel_info *iwl4965_get_channel_info(
+const struct iwl_channel_info *iwl_get_channel_info(
 		const struct iwl_priv *priv,
 		enum ieee80211_band band, u16 channel);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3562449..93ed61d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2263,7 +2263,7 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
-	ch_info = iwl4965_get_channel_info(priv, priv->band,
+	ch_info = iwl_get_channel_info(priv, priv->band,
 				       le16_to_cpu(priv->staging_rxon.channel));
 
 	if (!ch_info)
@@ -2301,7 +2301,7 @@ static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 	if (mode == IEEE80211_IF_TYPE_IBSS) {
 		const struct iwl_channel_info *ch_info;
 
-		ch_info = iwl4965_get_channel_info(priv,
+		ch_info = iwl_get_channel_info(priv,
 			priv->band,
 			le16_to_cpu(priv->staging_rxon.channel));
 
@@ -5013,7 +5013,7 @@ static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 
 		scan_ch->channel = ieee80211_frequency_to_channel(channels[i].center_freq);
 
-		ch_info = iwl4965_get_channel_info(priv, band,
+		ch_info = iwl_get_channel_info(priv, band,
 					 scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
@@ -6815,7 +6815,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ch_info = iwl4965_get_channel_info(priv, conf->channel->band,
+	ch_info = iwl_get_channel_info(priv, conf->channel->band,
 			ieee80211_frequency_to_channel(conf->channel->center_freq));
 	if (!is_channel_valid(ch_info)) {
 		IWL_DEBUG_MAC80211("leave - invalid channel\n");
-- 
1.5.3.4

