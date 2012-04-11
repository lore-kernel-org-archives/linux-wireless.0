Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:54552 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933057Ab2DKTyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:15 -0400
Received: by lagr15 with SMTP id r15so1078173lag.30
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:08 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 20/24] wlcore/wl12xx: set HT capabilities per chip-family
Date: Wed, 11 Apr 2012 22:53:36 +0300
Message-Id: <1334174020-18957-21-git-send-email-coelho@ti.com> (sfid-20120411_215434_685932_61682206)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Set HT capabilities in the low-level HW driver. These are then used by
wlcore when registering with mac80211.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   14 ++++++++++++++
 drivers/net/wireless/ti/wlcore/main.c   |   22 ++++------------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index f22cd55..ec94ad6 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1291,6 +1291,19 @@ static struct wlcore_ops wl12xx_ops = {
 	.get_mac		= wl12xx_get_mac,
 };
 
+static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
+	.cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 |
+	       (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT),
+	.ht_supported = true,
+	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K,
+	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8,
+	.mcs = {
+		.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
+		.rx_highest = cpu_to_le16(72),
+		.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
+		},
+};
+
 static int __devinit wl12xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -1313,6 +1326,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
+	memcpy(&wl->ht_cap, &wl12xx_ht_cap, sizeof(wl12xx_ht_cap));
 	wl12xx_conf_init(wl);
 
 	return wlcore_probe(wl, pdev);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d351c8f..ef0d04e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4256,29 +4256,12 @@ static struct ieee80211_channel wl1271_channels[] = {
 	{ .hw_value = 14, .center_freq = 2484, .max_power = 25 },
 };
 
-/* 11n STA capabilities */
-#define HW_RX_HIGHEST_RATE	72
-
-#define WL12XX_HT_CAP { \
-	.cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 | \
-	       (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT), \
-	.ht_supported = true, \
-	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K, \
-	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8, \
-	.mcs = { \
-		.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, }, \
-		.rx_highest = cpu_to_le16(HW_RX_HIGHEST_RATE), \
-		.tx_params = IEEE80211_HT_MCS_TX_DEFINED, \
-		}, \
-}
-
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_supported_band wl1271_band_2ghz = {
 	.channels = wl1271_channels,
 	.n_channels = ARRAY_SIZE(wl1271_channels),
 	.bitrates = wl1271_rates,
 	.n_bitrates = ARRAY_SIZE(wl1271_rates),
-	.ht_cap	= WL12XX_HT_CAP,
 };
 
 /* 5 GHz data rates for WL1273 */
@@ -4352,7 +4335,6 @@ static struct ieee80211_supported_band wl1271_band_5ghz = {
 	.n_channels = ARRAY_SIZE(wl1271_channels_5ghz),
 	.bitrates = wl1271_rates_5ghz,
 	.n_bitrates = ARRAY_SIZE(wl1271_rates_5ghz),
-	.ht_cap	= WL12XX_HT_CAP,
 };
 
 static const struct ieee80211_ops wl1271_ops = {
@@ -4729,8 +4711,12 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	 */
 	memcpy(&wl->bands[IEEE80211_BAND_2GHZ], &wl1271_band_2ghz,
 	       sizeof(wl1271_band_2ghz));
+	memcpy(&wl->bands[IEEE80211_BAND_2GHZ].ht_cap, &wl->ht_cap,
+	       sizeof(wl->ht_cap));
 	memcpy(&wl->bands[IEEE80211_BAND_5GHZ], &wl1271_band_5ghz,
 	       sizeof(wl1271_band_5ghz));
+	memcpy(&wl->bands[IEEE80211_BAND_5GHZ].ht_cap, &wl->ht_cap,
+	       sizeof(wl->ht_cap));
 
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 		&wl->bands[IEEE80211_BAND_2GHZ];
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 0660f75..1c2d81f 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -342,6 +342,9 @@ struct wl1271 {
 
 	/* this HW rate and below are considered HT rates for this chip */
 	u8 hw_min_ht_rate;
+
+	/* HW HT (11n) capabilities */
+	struct ieee80211_sta_ht_cap ht_cap;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.5.4

