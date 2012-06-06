Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2FFNXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/29] iwlwifi: trust mac80211 HT40 setting
Date: Wed,  6 Jun 2012 15:21:52 +0200
Message-Id: <1338988930-11561-11-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152324_709590_ECB1522F)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When mac80211 asks us to do HT40, it'll not do so
on a channel that we marked as not having HT40+/-
with IEEE80211_CHAN_NO_HT40PLUS (or MINUS). Thus,
there's no need to verify it again in the driver.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 36055ed..01fbf06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -171,26 +171,6 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	return cmd.handler_status;
 }
 
-static bool iwl_is_channel_extension(struct iwl_priv *priv,
-				     enum ieee80211_band band,
-				     u16 channel, u8 extension_chan_offset)
-{
-	const struct iwl_channel_info *ch_info;
-
-	ch_info = iwl_get_channel_info(priv, band, channel);
-	if (!is_channel_valid(ch_info))
-		return false;
-
-	if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
-		return !(ch_info->ht40_extension_channel &
-					IEEE80211_CHAN_NO_HT40PLUS);
-	else if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_BELOW)
-		return !(ch_info->ht40_extension_channel &
-					IEEE80211_CHAN_NO_HT40MINUS);
-
-	return false;
-}
-
 bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
 			    struct ieee80211_sta_ht_cap *ht_cap)
@@ -210,9 +190,7 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 		return false;
 #endif
 
-	return iwl_is_channel_extension(priv, priv->band,
-			le16_to_cpu(ctx->staging.channel),
-			ctx->ht.extension_chan_offset);
+	return true;
 }
 
 static void iwl_sta_calc_ht_flags(struct iwl_priv *priv,
-- 
1.7.10

