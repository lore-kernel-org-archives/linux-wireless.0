Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2FFNWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/29] iwlwifi: trust mac80211 channel setting
Date: Wed,  6 Jun 2012 15:21:46 +0200
Message-Id: <1338988930-11561-5-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152231_477839_92E0740A)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 will never set, switch to, or scan on an
invalid channel, so remove the code to validate
the channels against the driver channel list.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    7 -------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   12 +-----------
 3 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index c570318..36b4965 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -1182,7 +1182,6 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct iwl_rxon_context *ctx;
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_channel *channel = conf->channel;
-	const struct iwl_channel_info *ch_info;
 	int ret = 0;
 
 	IWL_DEBUG_MAC80211(priv, "enter: changed %#x\n", changed);
@@ -1216,14 +1215,6 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ch_info = iwl_get_channel_info(priv, channel->band,
-					       channel->hw_value);
-		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
-			ret = -EINVAL;
-			goto out;
-		}
-
 		for_each_context(priv, ctx) {
 			/* Configure HT40 channels */
 			if (ctx->ht.enabled != conf_is_ht(conf))
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index d0b64cd..19e5235 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -844,7 +844,6 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 				      struct ieee80211_channel_switch *ch_switch)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	const struct iwl_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_channel *channel = ch_switch->channel;
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
@@ -881,12 +880,6 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	if (le16_to_cpu(ctx->active.channel) == ch)
 		goto out;
 
-	ch_info = iwl_get_channel_info(priv, channel->band, ch);
-	if (!is_channel_valid(ch_info)) {
-		IWL_DEBUG_MAC80211(priv, "invalid channel\n");
-		goto out;
-	}
-
 	priv->current_ht_config.smps = conf->smps_mode;
 
 	/* Configure HT40 channels */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index eb0ded7..ea05ae8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -534,7 +534,6 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 {
 	struct ieee80211_channel *chan;
 	const struct ieee80211_supported_band *sband;
-	const struct iwl_channel_info *ch_info;
 	u16 passive_dwell = 0;
 	u16 active_dwell = 0;
 	int added, i;
@@ -559,16 +558,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		channel = chan->hw_value;
 		scan_ch->channel = cpu_to_le16(channel);
 
-		ch_info = iwl_get_channel_info(priv, band, channel);
-		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_SCAN(priv,
-				       "Channel %d is INVALID for this band.\n",
-				       channel);
-			continue;
-		}
-
-		if (!is_active || is_channel_passive(ch_info) ||
-		    (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN))
+		if (!is_active || (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN))
 			scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
 		else
 			scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
-- 
1.7.10

