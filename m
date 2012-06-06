Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab2FFNWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/29] iwlwifi: use mac80211 channel in connection init
Date: Wed,  6 Jun 2012 15:21:45 +0200
Message-Id: <1338988930-11561-4-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152232_508544_5BFA86A6)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 guarantees that the channel pointer is
always valid, so we can use that instead of our
own channel list.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 7fc8c25..c570318 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -37,8 +37,6 @@
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct iwl_rxon_context *ctx)
 {
-	const struct iwl_channel_info *ch_info;
-
 	memset(&ctx->staging, 0, sizeof(ctx->staging));
 
 	if (!ctx->vif) {
@@ -80,14 +78,8 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
-	ch_info = iwl_get_channel_info(priv, priv->band,
-				       le16_to_cpu(ctx->active.channel));
-
-	if (!ch_info)
-		ch_info = &priv->channel_info[0];
-
-	ctx->staging.channel = cpu_to_le16(ch_info->channel);
-	priv->band = ch_info->band;
+	ctx->staging.channel = cpu_to_le16(priv->hw->conf.channel->hw_value);
+	priv->band = priv->hw->conf.channel->band;
 
 	iwl_set_flags_for_band(priv, ctx, priv->band, ctx->vif);
 
-- 
1.7.10

