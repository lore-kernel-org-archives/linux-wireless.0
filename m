Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63057 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2KSQjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:49 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1209547eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:48 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/15] wlcore: remove channel handling from op_config
Date: Mon, 19 Nov 2012 18:39:24 +0200
Message-Id: <1353343170-26516-10-git-send-email-eliad@wizery.com> (sfid-20121119_173954_146397_922AFEDD)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After setting the channel on chanctx callbacks, we
no longer need to handle channel change notifications
on op_config.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   68 +-------------------------------
 1 files changed, 3 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index caafd8c..fcdf381 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2569,49 +2569,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     struct ieee80211_conf *conf, u32 changed)
 {
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
-	int channel, ret;
-
-	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
-
-	/* if the channel changes while joined, join again */
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
-	    ((wlvif->band != conf->channel->band) ||
-	     (wlvif->channel != channel) ||
-	     (wlvif->channel_type != conf->channel_type))) {
-		/* send all pending packets */
-		ret = wlcore_tx_work_locked(wl);
-		if (ret < 0)
-			return ret;
-
-		wlvif->band = conf->channel->band;
-		wlvif->channel = channel;
-		wlvif->channel_type = conf->channel_type;
-
-		if (is_ap) {
-			wl1271_set_band_rate(wl, wlvif);
-			ret = wl1271_init_ap_rates(wl, wlvif);
-			if (ret < 0)
-				wl1271_error("AP rate policy change failed %d",
-					     ret);
-		} else {
-			/*
-			 * FIXME: the mac80211 should really provide a fixed
-			 * rate to use here. for now, just use the smallest
-			 * possible rate for the band as a fixed rate for
-			 * association frames and other control messages.
-			 */
-			if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-				wl1271_set_band_rate(wl, wlvif);
-
-			wlvif->basic_rate =
-				wl1271_tx_min_rate_get(wl,
-						       wlvif->basic_rate_set);
-			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
-			if (ret < 0)
-				wl1271_warning("rate policy for channel "
-					       "failed %d", ret);
-		}
-	}
+	int ret;
 
 	if ((changed & IEEE80211_CONF_CHANGE_PS) && !is_ap) {
 
@@ -2666,37 +2624,17 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif;
 	struct ieee80211_conf *conf = &hw->conf;
-	int channel, ret = 0;
-
-	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int ret = 0;
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d %s"
+	wl1271_debug(DEBUG_MAC80211, "mac80211 config psm %s power %d %s"
 		     " changed 0x%x",
-		     channel,
 		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
 		     conf->power_level,
 		     conf->flags & IEEE80211_CONF_IDLE ? "idle" : "in use",
 			 changed);
 
-	/*
-	 * mac80211 will go to idle nearly immediately after transmitting some
-	 * frames, such as the deauth. To make sure those frames reach the air,
-	 * wait here until the TX queue is fully flushed.
-	 */
-	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) ||
-	    ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
-	     (conf->flags & IEEE80211_CONF_IDLE)))
-		wl1271_tx_flush(wl);
-
 	mutex_lock(&wl->mutex);
 
-	/* we support configuring the channel and band even while off */
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		wl->band = conf->channel->band;
-		wl->channel = channel;
-		wl->channel_type = conf->channel_type;
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		wl->power_level = conf->power_level;
 
-- 
1.7.6.401.g6a319

