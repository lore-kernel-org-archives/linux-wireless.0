Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46196 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab2EOOJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:25 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj8so2859247wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:24 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 10/10] wlcore: set wl->ht_cap per-band
Date: Tue, 15 May 2012 17:09:00 +0300
Message-Id: <1337090940-13750-10-git-send-email-arik@wizery.com> (sfid-20120515_160930_310415_F7912ED4)
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Save the ht_cap IE per-band, so we can configure different
params to BG and A bands (we currently don't support MIMO
on A band)

[Small fix for rx_highest - Arik]

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    5 ++++-
 drivers/net/wireless/ti/wl18xx/main.c   |   36 +++++++++++++++++++++++++------
 drivers/net/wireless/ti/wlcore/main.c   |   10 +++++----
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 +-
 4 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 08bec7f..07cc94f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1425,7 +1425,10 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
 	wl->fw_status_priv_len = 0;
 	wl->stats.fw_stats_len = sizeof(struct wl12xx_acx_statistics);
-	memcpy(&wl->ht_cap, &wl12xx_ht_cap, sizeof(wl12xx_ht_cap));
+	memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ], &wl12xx_ht_cap,
+	       sizeof(wl12xx_ht_cap));
+	memcpy(&wl->ht_cap[IEEE80211_BAND_5GHZ], &wl12xx_ht_cap,
+	       sizeof(wl12xx_ht_cap));
 	wl12xx_conf_init(wl);
 
 	if (!fref_param) {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 10a0ba1..809bb93 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -595,7 +595,7 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN;
 
 		/* PG 1.0 has some problems with MCS_13, so disable it */
-		wl->ht_cap.mcs.rx_mask[1] &= ~BIT(5);
+		wl->ht_cap[IEEE80211_BAND_2GHZ].mcs.rx_mask[1] &= ~BIT(5);
 
 		/* TODO: need to blocksize alignment for RX/TX separately? */
 		break;
@@ -1085,7 +1085,7 @@ static struct ieee80211_sta_ht_cap wl18xx_siso20_ht_cap = {
 };
 
 /* HT cap appropriate for MIMO rates in 20mhz channel */
-static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap = {
+static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap_2ghz = {
 	.cap = IEEE80211_HT_CAP_SGI_20,
 	.ht_supported = true,
 	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
@@ -1097,6 +1097,18 @@ static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap = {
 		},
 };
 
+static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap_5ghz = {
+	.cap = IEEE80211_HT_CAP_SGI_20,
+	.ht_supported = true,
+	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
+	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
+	.mcs = {
+		.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
+		.rx_highest = cpu_to_le16(72),
+		.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
+		},
+};
+
 static int __devinit wl18xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -1126,13 +1138,25 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->static_data_priv_len = sizeof(struct wl18xx_static_data_priv);
 
 	if (!strcmp(ht_mode_param, "wide")) {
-		memcpy(&wl->ht_cap, &wl18xx_siso40_ht_cap,
+		memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ],
+		       &wl18xx_siso40_ht_cap,
+		       sizeof(wl18xx_siso40_ht_cap));
+		memcpy(&wl->ht_cap[IEEE80211_BAND_5GHZ],
+		       &wl18xx_siso40_ht_cap,
 		       sizeof(wl18xx_siso40_ht_cap));
 	} else if (!strcmp(ht_mode_param, "mimo")) {
-		memcpy(&wl->ht_cap, &wl18xx_mimo_ht_cap,
-		       sizeof(wl18xx_mimo_ht_cap));
+		memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ],
+		       &wl18xx_mimo_ht_cap_2ghz,
+		       sizeof(wl18xx_mimo_ht_cap_2ghz));
+		memcpy(&wl->ht_cap[IEEE80211_BAND_5GHZ],
+		       &wl18xx_mimo_ht_cap_5ghz,
+		       sizeof(wl18xx_mimo_ht_cap_5ghz));
 	} else if (!strcmp(ht_mode_param, "siso20")) {
-		memcpy(&wl->ht_cap, &wl18xx_siso20_ht_cap,
+		memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ],
+		       &wl18xx_siso20_ht_cap,
+		       sizeof(wl18xx_siso20_ht_cap));
+		memcpy(&wl->ht_cap[IEEE80211_BAND_5GHZ],
+		       &wl18xx_siso20_ht_cap,
 		       sizeof(wl18xx_siso20_ht_cap));
 	} else {
 		wl1271_error("invalid ht_mode '%s'", ht_mode_param);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 92478cb..68bac74 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5027,12 +5027,14 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	 */
 	memcpy(&wl->bands[IEEE80211_BAND_2GHZ], &wl1271_band_2ghz,
 	       sizeof(wl1271_band_2ghz));
-	memcpy(&wl->bands[IEEE80211_BAND_2GHZ].ht_cap, &wl->ht_cap,
-	       sizeof(wl->ht_cap));
+	memcpy(&wl->bands[IEEE80211_BAND_2GHZ].ht_cap,
+	       &wl->ht_cap[IEEE80211_BAND_2GHZ],
+	       sizeof(*wl->ht_cap));
 	memcpy(&wl->bands[IEEE80211_BAND_5GHZ], &wl1271_band_5ghz,
 	       sizeof(wl1271_band_5ghz));
-	memcpy(&wl->bands[IEEE80211_BAND_5GHZ].ht_cap, &wl->ht_cap,
-	       sizeof(wl->ht_cap));
+	memcpy(&wl->bands[IEEE80211_BAND_5GHZ].ht_cap,
+	       &wl->ht_cap[IEEE80211_BAND_5GHZ],
+	       sizeof(*wl->ht_cap));
 
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 		&wl->bands[IEEE80211_BAND_2GHZ];
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 1967873..37a80f4 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -368,7 +368,7 @@ struct wl1271 {
 	u8 hw_min_ht_rate;
 
 	/* HW HT (11n) capabilities */
-	struct ieee80211_sta_ht_cap ht_cap;
+	struct ieee80211_sta_ht_cap ht_cap[IEEE80211_NUM_BANDS];
 
 	/* size of the private FW status data */
 	size_t fw_status_priv_len;
-- 
1.7.9.5

