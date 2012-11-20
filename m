Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57714 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2KTLUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:25 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1625946eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:25 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 08/11] wlcore: specify correct supported_rates
Date: Tue, 20 Nov 2012 13:20:08 +0200
Message-Id: <1353410411-18833-9-git-send-email-eliad@wizery.com> (sfid-20121120_122034_731268_FAA707BC)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The supported_rates field should contain all our supported
rates, even if the remote peer doesn't support them.

(rename CONF_TX_AP_ENABLED_RATES to CONF_TX_ENABLED_RATES,
as we now use it for both ap and sta)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: rename CONF_TX_AP_ENABLED_RATES (thanks Luca!)

 drivers/net/wireless/ti/wlcore/cmd.c  |   12 ++++++++++--
 drivers/net/wireless/ti/wlcore/conf.h |    4 ++--
 drivers/net/wireless/ti/wlcore/init.c |    2 +-
 drivers/net/wireless/ti/wlcore/main.c |    6 +++---
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 38fa8ff..1cf1225 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -441,6 +441,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct wl12xx_cmd_role_start *cmd;
+	u32 supported_rates;
 	int ret;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -461,7 +462,14 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->sta.ssid_len = wlvif->ssid_len;
 	memcpy(cmd->sta.ssid, wlvif->ssid, wlvif->ssid_len);
 	memcpy(cmd->sta.bssid, vif->bss_conf.bssid, ETH_ALEN);
-	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
+
+	supported_rates = CONF_TX_ENABLED_RATES | CONF_TX_MCS_RATES |
+			  wlcore_hw_sta_get_ap_rate_mask(wl, wlvif);
+	if (wlvif->p2p)
+		supported_rates &= ~CONF_TX_CCK_RATES;
+
+	cmd->sta.local_rates = cpu_to_le32(supported_rates);
+
 	cmd->channel_type = wlcore_get_native_channel_type(wlvif->channel_type);
 
 	if (wlvif->sta.hlid == WL12XX_INVALID_LINK_ID) {
@@ -601,7 +609,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		memcpy(cmd->ap.ssid, bss_conf->ssid, bss_conf->ssid_len);
 	}
 
-	supported_rates = CONF_TX_AP_ENABLED_RATES | CONF_TX_MCS_RATES |
+	supported_rates = CONF_TX_ENABLED_RATES | CONF_TX_MCS_RATES |
 		wlcore_hw_ap_get_mimo_wide_rate_mask(wl, wlvif);
 
 	wl1271_debug(DEBUG_CMD, "cmd role start ap with supported_rates 0x%08x",
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 9e40760..a5d1908 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -415,11 +415,11 @@ struct conf_rx_settings {
 #define CONF_TX_RATE_MASK_BASIC_P2P    CONF_HW_BIT_RATE_6MBPS
 
 /*
- * Rates supported for data packets when operating as AP. Note the absence
+ * Rates supported for data packets when operating as STA/AP. Note the absence
  * of the 22Mbps rate. There is a FW limitation on 12 rates so we must drop
  * one. The rate dropped is not mandatory under any operating mode.
  */
-#define CONF_TX_AP_ENABLED_RATES       (CONF_HW_BIT_RATE_1MBPS | \
+#define CONF_TX_ENABLED_RATES       (CONF_HW_BIT_RATE_1MBPS |    \
 	CONF_HW_BIT_RATE_2MBPS | CONF_HW_BIT_RATE_5_5MBPS |      \
 	CONF_HW_BIT_RATE_6MBPS | CONF_HW_BIT_RATE_9MBPS |        \
 	CONF_HW_BIT_RATE_11MBPS | CONF_HW_BIT_RATE_12MBPS |      \
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 32d157f..84641b3 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -463,7 +463,7 @@ int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if ((wlvif->basic_rate_set & CONF_TX_OFDM_RATES))
 		supported_rates = CONF_TX_OFDM_RATES;
 	else
-		supported_rates = CONF_TX_AP_ENABLED_RATES;
+		supported_rates = CONF_TX_ENABLED_RATES;
 
 	/* unconditionally enable HT rates */
 	supported_rates |= CONF_TX_MCS_RATES;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e393cea..6170e9e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2035,15 +2035,15 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 		for (i = 0; i < CONF_TX_MAX_AC_COUNT; i++)
 			wl12xx_allocate_rate_policy(wl,
 						&wlvif->ap.ucast_rate_idx[i]);
-		wlvif->basic_rate_set = CONF_TX_AP_ENABLED_RATES;
+		wlvif->basic_rate_set = CONF_TX_ENABLED_RATES;
 		/*
 		 * TODO: check if basic_rate shouldn't be
 		 * wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
 		 * instead (the same thing for STA above).
 		*/
-		wlvif->basic_rate = CONF_TX_AP_ENABLED_RATES;
+		wlvif->basic_rate = CONF_TX_ENABLED_RATES;
 		/* TODO: this seems to be used only for STA, check it */
-		wlvif->rate_set = CONF_TX_AP_ENABLED_RATES;
+		wlvif->rate_set = CONF_TX_ENABLED_RATES;
 	}
 
 	wlvif->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
-- 
1.7.6.401.g6a319

