Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48974 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaBJLry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:47:54 -0500
Received: by mail-wg0-f44.google.com with SMTP id l18so4014952wgh.11
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:47:53 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/18] wlcore/wl12xx/wl18xx: configure max_stations per-hw
Date: Mon, 10 Feb 2014 13:47:23 +0200
Message-Id: <1392032854-28126-8-git-send-email-eliad@wizery.com> (sfid-20140210_124759_908525_E6CEAF06)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each hw supports a different max stations (connected to the
same ap). add a new wl->max_ap_stations and use it instead
of the current common AP_MAX_STATIONS.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c     | 2 ++
 drivers/net/wireless/ti/wl12xx/wl12xx.h   | 1 +
 drivers/net/wireless/ti/wl18xx/main.c     | 2 ++
 drivers/net/wireless/ti/wl18xx/wl18xx.h   | 1 +
 drivers/net/wireless/ti/wlcore/main.c     | 4 +---
 drivers/net/wireless/ti/wlcore/wlcore.h   | 2 ++
 drivers/net/wireless/ti/wlcore/wlcore_i.h | 2 --
 7 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 69df5bc..f486f0f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1750,11 +1750,13 @@ static int wl12xx_setup(struct wl1271 *wl)
 	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 
 	BUILD_BUG_ON(WL12XX_MAX_LINKS > WLCORE_MAX_LINKS);
+	BUILD_BUG_ON(WL12XX_MAX_AP_STATIONS > WL12XX_MAX_LINKS);
 
 	wl->rtable = wl12xx_rtable;
 	wl->num_tx_desc = WL12XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL12XX_NUM_RX_DESCRIPTORS;
 	wl->num_links = WL12XX_MAX_LINKS;
+	wl->max_ap_stations = WL12XX_MAX_AP_STATIONS;
 	wl->num_channels = 1;
 	wl->num_mac_addr = WL12XX_NUM_MAC_ADDRESSES;
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 26b1a3f..75c9265 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -65,6 +65,7 @@
 
 #define WL12XX_RX_BA_MAX_SESSIONS 3
 
+#define WL12XX_MAX_AP_STATIONS 8
 #define WL12XX_MAX_LINKS 12
 
 struct wl127x_rx_mem_pool_addr {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 6011b22..f19e9b5 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1753,11 +1753,13 @@ static int wl18xx_setup(struct wl1271 *wl)
 	int ret;
 
 	BUILD_BUG_ON(WL18XX_MAX_LINKS > WLCORE_MAX_LINKS);
+	BUILD_BUG_ON(WL18XX_MAX_AP_STATIONS > WL18XX_MAX_LINKS);
 
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = WL18XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL18XX_NUM_RX_DESCRIPTORS;
 	wl->num_links = WL18XX_MAX_LINKS;
+	wl->max_ap_stations = WL18XX_MAX_AP_STATIONS;
 	wl->num_channels = 2;
 	wl->num_mac_addr = WL18XX_NUM_MAC_ADDRESSES;
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 38174e9..9785bf8 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -42,6 +42,7 @@
 
 #define WL18XX_RX_BA_MAX_SESSIONS 5
 
+#define WL18XX_MAX_AP_STATIONS 8
 #define WL18XX_MAX_LINKS 12
 
 struct wl18xx_priv {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c35d1dc..b649726 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4662,7 +4662,7 @@ static int wl1271_allocate_sta(struct wl1271 *wl,
 	int ret;
 
 
-	if (wl->active_sta_count >= AP_MAX_STATIONS) {
+	if (wl->active_sta_count >= wl->max_ap_stations) {
 		wl1271_warning("could not allocate HLID - too much stations");
 		return -EBUSY;
 	}
@@ -5855,8 +5855,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	int i, j, ret;
 	unsigned int order;
 
-	BUILD_BUG_ON(AP_MAX_STATIONS > WLCORE_MAX_LINKS);
-
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
 		wl1271_error("could not alloc ieee80211_hw");
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 98b1875..2356bdd 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -438,6 +438,8 @@ struct wl1271 {
 	u32 num_rx_desc;
 	/* number of links the HW supports */
 	u8 num_links;
+	/* max stations a single AP can support */
+	u8 max_ap_stations;
 
 	/* translate HW Tx rates to standard rate-indices */
 	const u8 **band_rate_to_idx;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 256d09b..a53a37f 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -123,8 +123,6 @@ struct wl1271_chip {
 
 #define NUM_TX_QUEUES              4
 
-#define AP_MAX_STATIONS            8
-
 struct wl_fw_status {
 	u32 intr;
 	u8  fw_rx_counter;
-- 
1.8.5.2.229.g4448466.dirty

