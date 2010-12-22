Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62173 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab0LVO2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:28:22 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so5082982wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:28:22 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 10/18] wl1271: AP mode config in ieee80211_ops.config
Date: Wed, 22 Dec 2010 16:27:29 +0200
Message-Id: <1293028057-6212-11-git-send-email-arik@wizery.com>
In-Reply-To: <1293028057-6212-1-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Separate configuration according to mode. AP has different rate
set configuration and no handling of idle-state.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   58 +++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 59c7fb3..4b26451 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1391,7 +1391,7 @@ u32 wl1271_min_rate_get(struct wl1271 *wl)
 	return rate;
 }
 
-static int wl1271_handle_idle(struct wl1271 *wl, bool idle)
+static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
 {
 	int ret;
 
@@ -1432,14 +1432,17 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct wl1271 *wl = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 	int channel, ret = 0;
+	bool is_ap;
 
 	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d %s",
+	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d %s"
+		     " changed 0x%x",
 		     channel,
 		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
 		     conf->power_level,
-		     conf->flags & IEEE80211_CONF_IDLE ? "idle" : "in use");
+		     conf->flags & IEEE80211_CONF_IDLE ? "idle" : "in use",
+			 changed);
 
 	/*
 	 * mac80211 will go to idle nearly immediately after transmitting some
@@ -1468,31 +1471,40 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		wl->band = conf->channel->band;
 		wl->channel = channel;
 
-		/*
-		 * FIXME: the mac80211 should really provide a fixed rate
-		 * to use here. for now, just use the smallest possible rate
-		 * for the band as a fixed rate for association frames and
-		 * other control messages.
-		 */
-		if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
-			wl1271_set_band_rate(wl);
-
-		wl->basic_rate = wl1271_min_rate_get(wl);
-		ret = wl1271_acx_sta_rate_policies(wl);
-		if (ret < 0)
-			wl1271_warning("rate policy for update channel "
-				       "failed %d", ret);
+		if (is_ap) {
+			/* set basic rates according to HW */
+			u32 rates = wl->vif->bss_conf.basic_rates;
+			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
+									rates);
+			wl->basic_rate = wl1271_min_rate_get(wl);
+		} else {
+			/*
+			 * FIXME: the mac80211 should really provide a fixed
+			 * rate to use here. for now, just use the smallest
+			 * possible rate for the band as a fixed rate for
+			 * association frames and other control messages.
+			 */
+			if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+				wl1271_set_band_rate(wl);
 
-		if (test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
-			ret = wl1271_join(wl, false);
+			wl->basic_rate = wl1271_min_rate_get(wl);
+			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
-				wl1271_warning("cmd join to update channel "
+				wl1271_warning("rate policy for channel "
 					       "failed %d", ret);
+
+			if (test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
+				ret = wl1271_join(wl, false);
+				if (ret < 0)
+					wl1271_warning("cmd join on channel "
+						       "failed %d", ret);
+			}
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
-		ret = wl1271_handle_idle(wl, conf->flags & IEEE80211_CONF_IDLE);
+	if (changed & IEEE80211_CONF_CHANGE_IDLE && !is_ap) {
+		ret = wl1271_sta_handle_idle(wl,
+					conf->flags & IEEE80211_CONF_IDLE);
 		if (ret < 0)
 			wl1271_warning("idle mode change failed %d", ret);
 	}
-- 
1.7.1

