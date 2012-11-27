Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38812 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab2K0Gpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:33 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so2666942wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:32 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Victor Goldenshtein <victorg@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 14/20] wlcore: restore default channel configuration
Date: Tue, 27 Nov 2012 08:44:55 +0200
Message-Id: <1353998701-18171-15-git-send-email-arik@wizery.com> (sfid-20121127_074558_461377_11A9DDC8)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

wlcore allocates two static structs wl1271_band_2ghz & wl1271_band_5ghz
which are used/modified by Reg-Domain e.g. some channel might be marked
as passive at some point. Make sure we don't keep stale settings around
if the HW is unregistered/registered during operation.

[Arik - use Tx-power constant and tweak commit message]

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c   |  113 ++++++++++++++++++-------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +
 2 files changed, 68 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e68cd3f..3ced59b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5086,20 +5086,20 @@ static struct ieee80211_rate wl1271_rates[] = {
 
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_channel wl1271_channels[] = {
-	{ .hw_value = 1, .center_freq = 2412, .max_power = 25 },
-	{ .hw_value = 2, .center_freq = 2417, .max_power = 25 },
-	{ .hw_value = 3, .center_freq = 2422, .max_power = 25 },
-	{ .hw_value = 4, .center_freq = 2427, .max_power = 25 },
-	{ .hw_value = 5, .center_freq = 2432, .max_power = 25 },
-	{ .hw_value = 6, .center_freq = 2437, .max_power = 25 },
-	{ .hw_value = 7, .center_freq = 2442, .max_power = 25 },
-	{ .hw_value = 8, .center_freq = 2447, .max_power = 25 },
-	{ .hw_value = 9, .center_freq = 2452, .max_power = 25 },
-	{ .hw_value = 10, .center_freq = 2457, .max_power = 25 },
-	{ .hw_value = 11, .center_freq = 2462, .max_power = 25 },
-	{ .hw_value = 12, .center_freq = 2467, .max_power = 25 },
-	{ .hw_value = 13, .center_freq = 2472, .max_power = 25 },
-	{ .hw_value = 14, .center_freq = 2484, .max_power = 25 },
+	{ .hw_value = 1, .center_freq = 2412, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 2, .center_freq = 2417, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 3, .center_freq = 2422, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 4, .center_freq = 2427, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 5, .center_freq = 2432, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 6, .center_freq = 2437, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 7, .center_freq = 2442, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 8, .center_freq = 2447, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 9, .center_freq = 2452, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 10, .center_freq = 2457, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 11, .center_freq = 2462, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 12, .center_freq = 2467, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 13, .center_freq = 2472, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 14, .center_freq = 2484, .max_power = WLCORE_MAX_TXPWR },
 };
 
 /* can't be const, mac80211 writes to this */
@@ -5140,40 +5140,40 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
 
 /* 5 GHz band channels for WL1273 */
 static struct ieee80211_channel wl1271_channels_5ghz[] = {
-	{ .hw_value = 7, .center_freq = 5035, .max_power = 25 },
-	{ .hw_value = 8, .center_freq = 5040, .max_power = 25 },
-	{ .hw_value = 9, .center_freq = 5045, .max_power = 25 },
-	{ .hw_value = 11, .center_freq = 5055, .max_power = 25 },
-	{ .hw_value = 12, .center_freq = 5060, .max_power = 25 },
-	{ .hw_value = 16, .center_freq = 5080, .max_power = 25 },
-	{ .hw_value = 34, .center_freq = 5170, .max_power = 25 },
-	{ .hw_value = 36, .center_freq = 5180, .max_power = 25 },
-	{ .hw_value = 38, .center_freq = 5190, .max_power = 25 },
-	{ .hw_value = 40, .center_freq = 5200, .max_power = 25 },
-	{ .hw_value = 42, .center_freq = 5210, .max_power = 25 },
-	{ .hw_value = 44, .center_freq = 5220, .max_power = 25 },
-	{ .hw_value = 46, .center_freq = 5230, .max_power = 25 },
-	{ .hw_value = 48, .center_freq = 5240, .max_power = 25 },
-	{ .hw_value = 52, .center_freq = 5260, .max_power = 25 },
-	{ .hw_value = 56, .center_freq = 5280, .max_power = 25 },
-	{ .hw_value = 60, .center_freq = 5300, .max_power = 25 },
-	{ .hw_value = 64, .center_freq = 5320, .max_power = 25 },
-	{ .hw_value = 100, .center_freq = 5500, .max_power = 25 },
-	{ .hw_value = 104, .center_freq = 5520, .max_power = 25 },
-	{ .hw_value = 108, .center_freq = 5540, .max_power = 25 },
-	{ .hw_value = 112, .center_freq = 5560, .max_power = 25 },
-	{ .hw_value = 116, .center_freq = 5580, .max_power = 25 },
-	{ .hw_value = 120, .center_freq = 5600, .max_power = 25 },
-	{ .hw_value = 124, .center_freq = 5620, .max_power = 25 },
-	{ .hw_value = 128, .center_freq = 5640, .max_power = 25 },
-	{ .hw_value = 132, .center_freq = 5660, .max_power = 25 },
-	{ .hw_value = 136, .center_freq = 5680, .max_power = 25 },
-	{ .hw_value = 140, .center_freq = 5700, .max_power = 25 },
-	{ .hw_value = 149, .center_freq = 5745, .max_power = 25 },
-	{ .hw_value = 153, .center_freq = 5765, .max_power = 25 },
-	{ .hw_value = 157, .center_freq = 5785, .max_power = 25 },
-	{ .hw_value = 161, .center_freq = 5805, .max_power = 25 },
-	{ .hw_value = 165, .center_freq = 5825, .max_power = 25 },
+	{ .hw_value = 7, .center_freq = 5035, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 8, .center_freq = 5040, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 9, .center_freq = 5045, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 11, .center_freq = 5055, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 12, .center_freq = 5060, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 16, .center_freq = 5080, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 34, .center_freq = 5170, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 36, .center_freq = 5180, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 38, .center_freq = 5190, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 40, .center_freq = 5200, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 42, .center_freq = 5210, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 44, .center_freq = 5220, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 46, .center_freq = 5230, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 48, .center_freq = 5240, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 52, .center_freq = 5260, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 56, .center_freq = 5280, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 60, .center_freq = 5300, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 64, .center_freq = 5320, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 100, .center_freq = 5500, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 104, .center_freq = 5520, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 108, .center_freq = 5540, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 112, .center_freq = 5560, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 116, .center_freq = 5580, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 120, .center_freq = 5600, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 124, .center_freq = 5620, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 128, .center_freq = 5640, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 132, .center_freq = 5660, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 136, .center_freq = 5680, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 140, .center_freq = 5700, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 149, .center_freq = 5745, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 153, .center_freq = 5765, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 157, .center_freq = 5785, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 161, .center_freq = 5805, .max_power = WLCORE_MAX_TXPWR },
+	{ .hw_value = 165, .center_freq = 5825, .max_power = WLCORE_MAX_TXPWR },
 };
 
 static struct ieee80211_supported_band wl1271_band_5ghz = {
@@ -5537,6 +5537,7 @@ wlcore_iface_combinations[] = {
 
 static int wl1271_init_ieee80211(struct wl1271 *wl)
 {
+	int i;
 	static const u32 cipher_suites[] = {
 		WLAN_CIPHER_SUITE_WEP40,
 		WLAN_CIPHER_SUITE_WEP104,
@@ -5599,6 +5600,22 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		     ARRAY_SIZE(wl1271_channels_5ghz) >
 		     WL1271_MAX_CHANNELS);
 	/*
+	* clear channel flags from the previous usage
+	* and restore max_power & max_antenna_gain values.
+	*/
+	for (i = 0; i < ARRAY_SIZE(wl1271_channels); i++) {
+		wl1271_band_2ghz.channels[i].flags = 0;
+		wl1271_band_2ghz.channels[i].max_power = WLCORE_MAX_TXPWR;
+		wl1271_band_2ghz.channels[i].max_antenna_gain = 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(wl1271_channels_5ghz); i++) {
+		wl1271_band_5ghz.channels[i].flags = 0;
+		wl1271_band_5ghz.channels[i].max_power = WLCORE_MAX_TXPWR;
+		wl1271_band_5ghz.channels[i].max_antenna_gain = 0;
+	}
+
+	/*
 	 * We keep local copies of the band structs because we need to
 	 * modify them on a per-device basis.
 	 */
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 07898de..8417ee2 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -37,6 +37,9 @@
  */
 #define WLCORE_NUM_MAC_ADDRESSES 3
 
+/* wl12xx/wl18xx maximum transmission power (in dBm) */
+#define WLCORE_MAX_TXPWR        25
+
 /* forward declaration */
 struct wl1271_tx_hw_descr;
 enum wl_rx_buf_align;
-- 
1.7.9.5

