Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab1FHN3H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:29:07 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 6/6] iwlegacy: refactor iwl4965_mac_channel_switch
Date: Wed,  8 Jun 2011 15:28:29 +0200
Message-Id: <1307539709-11320-6-git-send-email-sgruszka@redhat.com> (sfid-20110608_152921_249433_3A044480)
In-Reply-To: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
References: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use less indentions and remove uneeded irq-save flags.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl4965-base.c |  111 +++++++++++++-------------
 1 files changed, 55 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index c0ea858..49a80bb 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2510,7 +2510,6 @@ void iwl4965_mac_channel_switch(struct ieee80211_hw *hw,
 
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	u16 ch;
-	unsigned long flags = 0;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
@@ -2527,64 +2526,64 @@ void iwl4965_mac_channel_switch(struct ieee80211_hw *hw,
 	if (!iwl_legacy_is_associated_ctx(ctx))
 		goto out;
 
-	if (priv->cfg->ops->lib->set_channel_switch) {
+	if (priv->cfg->ops->lib->set_channel_switch)
+		goto out;
 
-		ch = channel->hw_value;
-		if (le16_to_cpu(ctx->active.channel) != ch) {
-			ch_info = iwl_legacy_get_channel_info(priv,
-						       channel->band,
-						       ch);
-			if (!iwl_legacy_is_channel_valid(ch_info)) {
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
-					IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-					ctx->ht.is_40mhz = true;
-				} else if (conf_is_ht40_plus(conf)) {
-					ctx->ht.extension_chan_offset =
-					IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-					ctx->ht.is_40mhz = true;
-				} else {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_NONE;
-					ctx->ht.is_40mhz = false;
-				}
-			} else
-				ctx->ht.is_40mhz = false;
-
-			if ((le16_to_cpu(ctx->staging.channel) != ch))
-				ctx->staging.flags = 0;
-
-			iwl_legacy_set_rxon_channel(priv, channel, ctx);
-			iwl_legacy_set_rxon_ht(priv, ht_conf);
-			iwl_legacy_set_flags_for_band(priv, ctx, channel->band,
-					       ctx->vif);
-			spin_unlock_irqrestore(&priv->lock, flags);
-
-			iwl_legacy_set_rate(priv);
-			/*
-			 * at this point, staging_rxon has the
-			 * configuration for channel switch
-			 */
-			set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
-			priv->switch_channel = cpu_to_le16(ch);
-			if (priv->cfg->ops->lib->set_channel_switch(priv, ch_switch)) {
-				clear_bit(STATUS_CHANNEL_SWITCH_PENDING,
-					  &priv->status);
-				priv->switch_channel = 0;
-				ieee80211_chswitch_done(ctx->vif, false);
-			}
+	ch = channel->hw_value;
+	if (le16_to_cpu(ctx->active.channel) == ch)
+		goto out;
+
+	ch_info = iwl_legacy_get_channel_info(priv, channel->band, ch);
+	if (!iwl_legacy_is_channel_valid(ch_info)) {
+		IWL_DEBUG_MAC80211(priv, "invalid channel\n");
+		goto out;
+	}
+
+	spin_lock(&priv->lock);
+
+	priv->current_ht_config.smps = conf->smps_mode;
+
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
+	iwl_legacy_set_rxon_channel(priv, channel, ctx);
+	iwl_legacy_set_rxon_ht(priv, ht_conf);
+	iwl_legacy_set_flags_for_band(priv, ctx, channel->band, ctx->vif);
+
+	spin_unlock_irq(&priv->lock);
+
+	iwl_legacy_set_rate(priv);
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

