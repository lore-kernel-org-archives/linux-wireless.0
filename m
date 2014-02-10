Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53131 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaBJLrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:47:55 -0500
Received: by mail-wg0-f51.google.com with SMTP id z12so4122004wgg.30
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:47:54 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/18] wlcore/wl12xx/wl18xx: configure iface_combinations per-hw
Date: Mon, 10 Feb 2014 13:47:24 +0200
Message-Id: <1392032854-28126-9-git-send-email-eliad@wizery.com> (sfid-20140210_124804_383836_EEBE71B8)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each hw supports a different iface combinations.
Define the supported combinations in each driver,
and save it in wl->iface_combinations.

Since each driver defines its own combinations now,
it can also define its max supported channels, so
we no longer need to save and set it explicitly
in wlcore.

Update wl18xx interface combinations to allow
multiple APs.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   | 26 +++++++++++++++++++++-
 drivers/net/wireless/ti/wl18xx/main.c   | 39 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ti/wlcore/main.c   | 28 ++---------------------
 drivers/net/wireless/ti/wlcore/wlcore.h |  5 +++--
 4 files changed, 68 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index f486f0f..33071a7 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1743,6 +1743,29 @@ static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
 		},
 };
 
+static const struct ieee80211_iface_limit wl12xx_iface_limits[] = {
+	{
+		.max = 3,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_AP) |
+			 BIT(NL80211_IFTYPE_P2P_GO) |
+			 BIT(NL80211_IFTYPE_P2P_CLIENT),
+	},
+};
+
+static const struct ieee80211_iface_combination
+wl12xx_iface_combinations[] = {
+	{
+		.max_interfaces = 3,
+		.limits = wl12xx_iface_limits,
+		.n_limits = ARRAY_SIZE(wl12xx_iface_limits),
+		.num_different_channels = 1,
+	},
+};
+
 static int wl12xx_setup(struct wl1271 *wl)
 {
 	struct wl12xx_priv *priv = wl->priv;
@@ -1757,7 +1780,8 @@ static int wl12xx_setup(struct wl1271 *wl)
 	wl->num_rx_desc = WL12XX_NUM_RX_DESCRIPTORS;
 	wl->num_links = WL12XX_MAX_LINKS;
 	wl->max_ap_stations = WL12XX_MAX_AP_STATIONS;
-	wl->num_channels = 1;
+	wl->iface_combinations = wl12xx_iface_combinations;
+	wl->n_iface_combinations = ARRAY_SIZE(wl12xx_iface_combinations);
 	wl->num_mac_addr = WL12XX_NUM_MAC_ADDRESSES;
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index f19e9b5..966a866 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1747,6 +1747,42 @@ static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap_2ghz = {
 		},
 };
 
+static const struct ieee80211_iface_limit wl18xx_iface_limits[] = {
+	{
+		.max = 3,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_AP) |
+			 BIT(NL80211_IFTYPE_P2P_GO) |
+			 BIT(NL80211_IFTYPE_P2P_CLIENT),
+	},
+};
+
+static const struct ieee80211_iface_limit wl18xx_iface_ap_limits[] = {
+	{
+		.max = 2,
+		.types = BIT(NL80211_IFTYPE_AP),
+	},
+};
+
+static const struct ieee80211_iface_combination
+wl18xx_iface_combinations[] = {
+	{
+		.max_interfaces = 3,
+		.limits = wl18xx_iface_limits,
+		.n_limits = ARRAY_SIZE(wl18xx_iface_limits),
+		.num_different_channels = 2,
+	},
+	{
+		.max_interfaces = 2,
+		.limits = wl18xx_iface_ap_limits,
+		.n_limits = ARRAY_SIZE(wl18xx_iface_ap_limits),
+		.num_different_channels = 1,
+	}
+};
+
 static int wl18xx_setup(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
@@ -1760,7 +1796,8 @@ static int wl18xx_setup(struct wl1271 *wl)
 	wl->num_rx_desc = WL18XX_NUM_RX_DESCRIPTORS;
 	wl->num_links = WL18XX_MAX_LINKS;
 	wl->max_ap_stations = WL18XX_MAX_AP_STATIONS;
-	wl->num_channels = 2;
+	wl->iface_combinations = wl18xx_iface_combinations;
+	wl->n_iface_combinations = ARRAY_SIZE(wl18xx_iface_combinations);
 	wl->num_mac_addr = WL18XX_NUM_MAC_ADDRESSES;
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b649726..d16fb7e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5690,28 +5690,6 @@ static void wl1271_unregister_hw(struct wl1271 *wl)
 
 }
 
-static const struct ieee80211_iface_limit wlcore_iface_limits[] = {
-	{
-		.max = 3,
-		.types = BIT(NL80211_IFTYPE_STATION),
-	},
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_AP) |
-			 BIT(NL80211_IFTYPE_P2P_GO) |
-			 BIT(NL80211_IFTYPE_P2P_CLIENT),
-	},
-};
-
-static struct ieee80211_iface_combination
-wlcore_iface_combinations[] = {
-	{
-	  .max_interfaces = 3,
-	  .limits = wlcore_iface_limits,
-	  .n_limits = ARRAY_SIZE(wlcore_iface_limits),
-	},
-};
-
 static int wl1271_init_ieee80211(struct wl1271 *wl)
 {
 	int i;
@@ -5832,10 +5810,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
 
 	/* allowed interface combinations */
-	wlcore_iface_combinations[0].num_different_channels = wl->num_channels;
-	wl->hw->wiphy->iface_combinations = wlcore_iface_combinations;
-	wl->hw->wiphy->n_iface_combinations =
-		ARRAY_SIZE(wlcore_iface_combinations);
+	wl->hw->wiphy->iface_combinations = wl->iface_combinations;
+	wl->hw->wiphy->n_iface_combinations = wl->n_iface_combinations;
 
 	SET_IEEE80211_DEV(wl->hw, wl->dev);
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 2356bdd..a1cc1c6 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -483,8 +483,9 @@ struct wl1271 {
 
 	struct completion nvs_loading_complete;
 
-	/* number of concurrent channels the HW supports */
-	u32 num_channels;
+	/* interface combinations supported by the hw */
+	const struct ieee80211_iface_combination *iface_combinations;
+	u8 n_iface_combinations;
 };
 
 int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.8.5.2.229.g4448466.dirty

