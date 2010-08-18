Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab0HRQSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/16] iwlwifi: do not call ieee80211_frequency_to_channel
Date: Wed, 18 Aug 2010 09:22:40 -0700
Message-Id: <1282148571-9258-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

A few cases in iwlwifi driver function ieee80211_frequency_to_channel()
is called to get channel number from center frequency. This is not needed
since the channel number is already saved in hw_value field of struct
ieee80211_channel in function iwlcore_init_geos(). So replace those function
calls with hw_value field of struct ieee80211_channel.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.c    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    6 ++----
 7 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d92b729..f0a47f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1470,7 +1470,7 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv,
 
 	cmd.band = band;
 	cmd.expect_beacon = 0;
-	ch = ieee80211_frequency_to_channel(ch_switch->channel->center_freq);
+	ch = ch_switch->channel->hw_value;
 	cmd.channel = cpu_to_le16(ch);
 	cmd.rxon_flags = priv->staging_rxon.flags;
 	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 173f556..efd9e6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -291,7 +291,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	};
 
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
-	ch = ieee80211_frequency_to_channel(ch_switch->channel->center_freq);
+	ch = ch_switch->channel->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
 		priv->active_rxon.channel, ch);
 	cmd.channel = cpu_to_le16(ch);
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a7af5e3..9e390f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -214,7 +214,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	};
 
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
-	ch = ieee80211_frequency_to_channel(ch_switch->channel->center_freq);
+	ch = ch_switch->channel->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
 		      priv->active_rxon.channel, ch);
 	cmd.channel = cpu_to_le16(ch);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 9dd9e64..eedd71f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1098,7 +1098,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		if (chan->band != band)
 			continue;
 
-		channel = ieee80211_frequency_to_channel(chan->center_freq);
+		channel = chan->hw_value;
 		scan_ch->channel = cpu_to_le16(channel);
 
 		ch_info = iwl_get_channel_info(priv, band, channel);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c8dec4a..00cbb83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3655,8 +3655,7 @@ static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 	if (priv->cfg->ops->lib->set_channel_switch) {
 
-		ch = ieee80211_frequency_to_channel(
-			ch_switch->channel->center_freq);
+		ch = ch_switch->channel->hw_value;
 		if (le16_to_cpu(priv->active_rxon.channel) != ch) {
 			ch_info = iwl_get_channel_info(priv,
 						       conf->channel->band,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 98cd710..221a211 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -916,7 +916,7 @@ EXPORT_SYMBOL(iwl_get_single_channel_number);
 int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
 {
 	enum ieee80211_band band = ch->band;
-	u16 channel = ieee80211_frequency_to_channel(ch->center_freq);
+	u16 channel = ch->hw_value;
 
 	if (!iwl_get_channel_info(priv, band, channel)) {
 		IWL_DEBUG_INFO(priv, "Could not set channel to %d [%d]\n",
@@ -1987,7 +1987,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		if (scan_active)
 			goto set_ch_out;
 
-		ch = ieee80211_frequency_to_channel(conf->channel->center_freq);
+		ch = conf->channel->hw_value;
 		ch_info = iwl_get_channel_info(priv, conf->channel->band, ch);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index e96a1bb..d3acdae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -467,8 +467,7 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 		for (i = 0; i < supp_band->n_channels; i++)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					"%d: %ddBm: BSS%s%s, %s.\n",
-					ieee80211_frequency_to_channel(
-					channels[i].center_freq),
+					channels[i].hw_value,
 					channels[i].max_power,
 					channels[i].flags & IEEE80211_CHAN_RADAR ?
 					" (IEEE 802.11h required)" : "",
@@ -491,8 +490,7 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 		for (i = 0; i < supp_band->n_channels; i++)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					"%d: %ddBm: BSS%s%s, %s.\n",
-					ieee80211_frequency_to_channel(
-					channels[i].center_freq),
+					channels[i].hw_value,
 					channels[i].max_power,
 					channels[i].flags & IEEE80211_CHAN_RADAR ?
 					" (IEEE 802.11h required)" : "",
-- 
1.7.0.4

