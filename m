Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1JJINS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:18 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so8786663wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:17 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 24/29] wl12xx: make op_config configure all vifs
Date: Mon, 10 Oct 2011 10:13:12 +0200
Message-Id: <1318234397-21081-25-git-send-email-eliad@wizery.com> (sfid-20111010_101324_468739_A3BAAFF4)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 changes a global (hw) config, iterate
through all the relevant vifs and update them.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |  112 +++++++++++++++++++----------------
 1 files changed, 61 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c8b5290..43cd276 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2398,63 +2398,20 @@ out:
 	return ret;
 }
 
-static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
+static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			     struct ieee80211_conf *conf, u32 changed)
 {
-	struct wl1271 *wl = hw->priv;
-	struct ieee80211_vif *vif = wl->vif; /* TODO: reconfig all vifs */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	struct ieee80211_conf *conf = &hw->conf;
-	int channel, ret = 0;
-	bool is_ap;
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
+	int channel, ret;
 
 	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d %s"
-		     " changed 0x%x",
-		     channel,
-		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
-		     conf->power_level,
-		     conf->flags & IEEE80211_CONF_IDLE ? "idle" : "in use",
-			 changed);
-
-	/*
-	 * mac80211 will go to idle nearly immediately after transmitting some
-	 * frames, such as the deauth. To make sure those frames reach the air,
-	 * wait here until the TX queue is fully flushed.
-	 */
-	if ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
-	    (conf->flags & IEEE80211_CONF_IDLE))
-		wl1271_tx_flush(wl);
-
-	mutex_lock(&wl->mutex);
-
-	if (unlikely(wl->state == WL1271_STATE_OFF)) {
-		/* we support configuring the channel and band while off */
-		if ((changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
-			wl->band = conf->channel->band;
-			wl->channel = channel;
-		}
-
-		if ((changed & IEEE80211_CONF_CHANGE_POWER))
-			wl->power_level = conf->power_level;
-
-		goto out;
-	}
-
-	is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
-
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
 	/* if the channel changes while joined, join again */
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
 	    ((wlvif->band != conf->channel->band) ||
 	     (wlvif->channel != channel))) {
 		/* send all pending packets */
 		wl1271_tx_work_locked(wl);
-		wl->band = conf->channel->band;
-		wl->channel = channel;
 		wlvif->band = conf->channel->band;
 		wlvif->channel = channel;
 
@@ -2483,7 +2440,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 					ret = wl12xx_croc(wl,
 							  wlvif->dev_role_id);
 					if (ret < 0)
-						goto out_sleep;
+						return ret;
 				}
 				ret = wl1271_join(wl, wlvif, false);
 				if (ret < 0)
@@ -2500,7 +2457,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 					ret = wl12xx_croc(wl,
 							  wlvif->dev_role_id);
 					if (ret < 0)
-						goto out_sleep;
+						return ret;
 
 					ret = wl12xx_roc(wl, wlvif,
 							 wlvif->dev_role_id);
@@ -2556,12 +2513,65 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (conf->power_level != wlvif->power_level) {
 		ret = wl1271_acx_tx_power(wl, wlvif, conf->power_level);
 		if (ret < 0)
-			goto out_sleep;
+			return ret;
 
-		wl->power_level = conf->power_level;
 		wlvif->power_level = conf->power_level;
 	}
 
+	return 0;
+}
+
+static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif;
+	struct ieee80211_conf *conf = &hw->conf;
+	int channel, ret = 0;
+
+	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d %s"
+		     " changed 0x%x",
+		     channel,
+		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
+		     conf->power_level,
+		     conf->flags & IEEE80211_CONF_IDLE ? "idle" : "in use",
+			 changed);
+
+	/*
+	 * mac80211 will go to idle nearly immediately after transmitting some
+	 * frames, such as the deauth. To make sure those frames reach the air,
+	 * wait here until the TX queue is fully flushed.
+	 */
+	if ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
+	    (conf->flags & IEEE80211_CONF_IDLE))
+		wl1271_tx_flush(wl);
+
+	mutex_lock(&wl->mutex);
+
+	/* we support configuring the channel and band even while off */
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		wl->band = conf->channel->band;
+		wl->channel = channel;
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_POWER)
+		wl->power_level = conf->power_level;
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	/* configure each interface */
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		ret = wl12xx_config_vif(wl, wlvif, conf, changed);
+		if (ret < 0)
+			goto out_sleep;
+	}
+
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
-- 
1.7.6.401.g6a319

