Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab1FBOq7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 10:46:59 -0400
Date: Thu, 2 Jun 2011 16:46:20 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] iwlagn: refactor iwlagn_mac_channel_switch
Message-ID: <20110602144619.GB4580@redhat.com> (sfid-20110602_164702_861625_4A5254B8)
References: <20110602144424.GA4580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110602144424.GA4580@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use less indentions and remove uneeded irq-save flags.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |  106 ++++++++++++++++----------------
 1 files changed, 52 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1a143b2..df72cef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2833,7 +2833,6 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	u16 ch;
-	unsigned long flags = 0;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
@@ -2850,65 +2849,64 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	if (!iwl_is_associated_ctx(ctx))
 		goto out;
 
-	if (priv->cfg->ops->lib->set_channel_switch) {
+	if (!priv->cfg->ops->lib->set_channel_switch)
+		goto out;
 
-		ch = channel->hw_value;
-		if (le16_to_cpu(ctx->active.channel) != ch) {
-			ch_info = iwl_get_channel_info(priv,
-						       channel->band,
-						       ch);
-			if (!is_channel_valid(ch_info)) {
-				IWL_DEBUG_MAC80211(priv, "invalid channel\n");
-				goto out;
-			}
-			spin_lock_irqsave(&priv->lock, flags);
-
-			priv->current_ht_config.smps = conf->smps_mode;
-
-			/* Configure HT40 channels */
-			ctx->ht.enabled = conf_is_ht(conf);
-			if (ctx->ht.enabled) {
-				if (conf_is_ht40_minus(conf)) {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-					ctx->ht.is_40mhz = true;
-				} else if (conf_is_ht40_plus(conf)) {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-					ctx->ht.is_40mhz = true;
-				} else {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_NONE;
-					ctx->ht.is_40mhz = false;
-				}
-			} else
-				ctx->ht.is_40mhz = false;
+	ch = channel->hw_value;
+	if (le16_to_cpu(ctx->active.channel) == ch)
+		goto out;
+
+	ch_info = iwl_get_channel_info(priv, channel->band, ch);
+	if (!is_channel_valid(ch_info)) {
+		IWL_DEBUG_MAC80211(priv, "invalid channel\n");
+		goto out;
+	}
 
-			if ((le16_to_cpu(ctx->staging.channel) != ch))
-				ctx->staging.flags = 0;
+	spin_lock_irq(&priv->lock);
 
-			iwl_set_rxon_channel(priv, channel, ctx);
-			iwl_set_rxon_ht(priv, ht_conf);
-			iwl_set_flags_for_band(priv, ctx, channel->band,
-					       ctx->vif);
-			spin_unlock_irqrestore(&priv->lock, flags);
+	priv->current_ht_config.smps = conf->smps_mode;
 
-			iwl_set_rate(priv);
-			/*
-			 * at this point, staging_rxon has the
-			 * configuration for channel switch
-			 */
-			set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
-			priv->switch_channel = cpu_to_le16(ch);
-			if (priv->cfg->ops->lib->set_channel_switch(priv,
-								    ch_switch)) {
-				clear_bit(STATUS_CHANNEL_SWITCH_PENDING,
-					  &priv->status);
-				priv->switch_channel = 0;
-				ieee80211_chswitch_done(ctx->vif, false);
-			}
+	/* Configure HT40 channels */
+	ctx->ht.enabled = conf_is_ht(conf);
+	if (ctx->ht.enabled) {
+		if (conf_is_ht40_minus(conf)) {
+			ctx->ht.extension_chan_offset =
+				IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+			ctx->ht.is_40mhz = true;
+		} else if (conf_is_ht40_plus(conf)) {
+			ctx->ht.extension_chan_offset =
+				IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+			ctx->ht.is_40mhz = true;
+		} else {
+			ctx->ht.extension_chan_offset =
+				IEEE80211_HT_PARAM_CHA_SEC_NONE;
+			ctx->ht.is_40mhz = false;
 		}
+	} else
+		ctx->ht.is_40mhz = false;
+
+	if ((le16_to_cpu(ctx->staging.channel) != ch))
+		ctx->staging.flags = 0;
+
+	iwl_set_rxon_channel(priv, channel, ctx);
+	iwl_set_rxon_ht(priv, ht_conf);
+	iwl_set_flags_for_band(priv, ctx, channel->band, ctx->vif);
+
+	spin_unlock_irq(&priv->lock);
+
+	iwl_set_rate(priv);
+	/*
+	 * at this point, staging_rxon has the
+	 * configuration for channel switch
+	 */
+	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
+	priv->switch_channel = cpu_to_le16(ch);
+	if (priv->cfg->ops->lib->set_channel_switch(priv, ch_switch)) {
+		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
+		priv->switch_channel = 0;
+		ieee80211_chswitch_done(ctx->vif, false);
 	}
+
 out:
 	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-- 
1.7.1

