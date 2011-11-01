Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43109 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1KAHXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 03:23:51 -0400
Received: by wwi36 with SMTP id 36so2663232wwi.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2011 00:23:50 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/2] wl12xx: set scan probe requests rate according to the no_cck flag
Date: Tue,  1 Nov 2011 09:23:51 +0200
Message-Id: <1320132232-12283-1-git-send-email-eliad@wizery.com> (sfid-20111101_082355_851210_1A5BEBF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Eilam <guy@wizery.com>

Set the TX rate of probe requests during scanning according to the
no_cck flag in the scan request struct.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: consider bitrate_mask

 drivers/net/wireless/wl12xx/conf.h |    4 ++++
 drivers/net/wireless/wl12xx/scan.c |   19 +++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 04bb8fb..1bcfb01 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -440,6 +440,10 @@ struct conf_rx_settings {
 	CONF_HW_BIT_RATE_36MBPS | CONF_HW_BIT_RATE_48MBPS |      \
 	CONF_HW_BIT_RATE_54MBPS)
 
+#define CONF_TX_CCK_RATES  (CONF_HW_BIT_RATE_1MBPS |		\
+	CONF_HW_BIT_RATE_2MBPS | CONF_HW_BIT_RATE_5_5MBPS |	\
+	CONF_HW_BIT_RATE_11MBPS)
+
 #define CONF_TX_OFDM_RATES (CONF_HW_BIT_RATE_6MBPS |             \
 	CONF_HW_BIT_RATE_12MBPS | CONF_HW_BIT_RATE_24MBPS |      \
 	CONF_HW_BIT_RATE_36MBPS | CONF_HW_BIT_RATE_48MBPS |      \
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index fb2c431..de82ccf 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -203,7 +203,6 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 
 	cmd->params.tx_rate = cpu_to_le32(basic_rate);
 	cmd->params.n_probe_reqs = wl->conf.scan.num_probe_reqs;
-	cmd->params.tx_rate = cpu_to_le32(basic_rate);
 	cmd->params.tid_trigger = 0;
 	cmd->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
@@ -255,7 +254,7 @@ void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret = 0;
 	enum ieee80211_band band;
-	u32 rate;
+	u32 rate, mask;
 
 	switch (wl->scan.state) {
 	case WL1271_SCAN_STATE_IDLE:
@@ -263,7 +262,13 @@ void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 	case WL1271_SCAN_STATE_2GHZ_ACTIVE:
 		band = IEEE80211_BAND_2GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
+		mask = wlvif->bitrate_masks[band];
+		if (wl->scan.req->no_cck) {
+			mask &= ~CONF_TX_CCK_RATES;
+			if (!mask)
+				mask = CONF_TX_RATE_MASK_BASIC_P2P;
+		}
+		rate = wl1271_tx_min_rate_get(wl, mask);
 		ret = wl1271_scan_send(wl, vif, band, false, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
@@ -274,7 +279,13 @@ void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 	case WL1271_SCAN_STATE_2GHZ_PASSIVE:
 		band = IEEE80211_BAND_2GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
+		mask = wlvif->bitrate_masks[band];
+		if (wl->scan.req->no_cck) {
+			mask &= ~CONF_TX_CCK_RATES;
+			if (!mask)
+				mask = CONF_TX_RATE_MASK_BASIC_P2P;
+		}
+		rate = wl1271_tx_min_rate_get(wl, mask);
 		ret = wl1271_scan_send(wl, vif, band, true, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			if (wl->enable_11a)
-- 
1.7.6.401.g6a319

