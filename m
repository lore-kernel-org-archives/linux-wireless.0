Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab2EJJP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:26 -0400
Received: by wgbdr13 with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:25 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 25/78] wlcore: track current channel type per vif
Date: Thu, 10 May 2012 12:13:30 +0300
Message-Id: <1336641263-5761-26-git-send-email-arik@wizery.com> (sfid-20120510_111533_967330_040B3729)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track the current 802.11 channel type, defaulting to a NO_HT channel.
Update the channel type element when changed by mac80211.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c   |    9 ++++++++-
 drivers/net/wireless/ti/wlcore/wl12xx.h |    1 +
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 45fe911..3cd2ddd 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1766,6 +1766,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 
 	wl->rx_counter = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
+	wl->channel_type = NL80211_CHAN_NO_HT;
 	wl->tx_blocks_available = 0;
 	wl->tx_allocated_blocks = 0;
 	wl->tx_results_count = 0;
@@ -1918,6 +1919,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	wlvif->band = wl->band;
 	wlvif->channel = wl->channel;
 	wlvif->power_level = wl->power_level;
+	wlvif->channel_type = wl->channel_type;
 
 	INIT_WORK(&wlvif->rx_streaming_enable_work,
 		  wl1271_rx_streaming_enable_work);
@@ -2468,11 +2470,13 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	/* if the channel changes while joined, join again */
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
 	    ((wlvif->band != conf->channel->band) ||
-	     (wlvif->channel != channel))) {
+	     (wlvif->channel != channel) ||
+	     (wlvif->channel_type != conf->channel_type))) {
 		/* send all pending packets */
 		wl1271_tx_work_locked(wl);
 		wlvif->band = conf->channel->band;
 		wlvif->channel = channel;
+		wlvif->channel_type = conf->channel_type;
 
 		if (!is_ap) {
 			/*
@@ -2592,6 +2596,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		wl->band = conf->channel->band;
 		wl->channel = channel;
+		wl->channel_type = conf->channel_type;
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
@@ -3703,6 +3708,7 @@ sta_not_found:
 			u32 rates;
 			int ieoffset;
 			wlvif->aid = bss_conf->aid;
+			wlvif->channel_type = bss_conf->channel_type;
 			wlvif->beacon_int = bss_conf->beacon_int;
 			do_join = true;
 			set_assoc = true;
@@ -5116,6 +5122,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 	wl->rx_counter = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->band = IEEE80211_BAND_2GHZ;
+	wl->channel_type = NL80211_CHAN_NO_HT;
 	wl->flags = 0;
 	wl->sg_enabled = true;
 	wl->hw_pg_ver = -1;
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx.h b/drivers/net/wireless/ti/wlcore/wl12xx.h
index f12bdf7..05e6f74 100644
--- a/drivers/net/wireless/ti/wlcore/wl12xx.h
+++ b/drivers/net/wireless/ti/wlcore/wl12xx.h
@@ -367,6 +367,7 @@ struct wl12xx_vif {
 	/* The current band */
 	enum ieee80211_band band;
 	int channel;
+	enum nl80211_channel_type channel_type;
 
 	u32 bitrate_masks[IEEE80211_NUM_BANDS];
 	u32 basic_rate_set;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 2922d8a..83c43c9 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -362,6 +362,9 @@ struct wl1271 {
 
 	/* RX Data filter rule state - enabled/disabled */
 	bool rx_filter_enabled[WL1271_MAX_RX_FILTERS];
+
+	/* the current channel type */
+	enum nl80211_channel_type channel_type;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.9.5

