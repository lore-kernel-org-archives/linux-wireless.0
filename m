Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36141 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933719AbZJMJt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:49:56 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 11/22] wl1271: Added 5 GHz parameters for wl1273
Date: Tue, 13 Oct 2009 12:47:48 +0300
Message-Id: <1255427279-1224-12-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Added data rate and frequency tables for 5 GHz band channels, 5
GHz radio configration parameters and configuration option to enable
802.11 support.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |   14 +++
 drivers/net/wireless/wl12xx/wl1271_conf.h |    7 ++-
 drivers/net/wireless/wl12xx/wl1271_main.c |  123 +++++++++++++++++++++++++----
 3 files changed, 127 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index e0ebb1f..dc9957e 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -113,6 +113,11 @@ enum {
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
 
 /*
+ * Enable/disable 802.11a support for WL1273
+ */
+#undef WL1271_80211A_ENABLED
+
+/*
  * FIXME: for the wl1271, a busy word count of 1 here will result in a more
  * optimal SPI interface. There is some SPI bug however, causing RXS time outs
  * with this mode occasionally on boot, so lets have three for now. A value of
@@ -442,4 +447,13 @@ int wl1271_plt_stop(struct wl1271 *wl);
 /* WL1271 needs a 200ms sleep after power on */
 #define WL1271_POWER_ON_SLEEP 200 /* in miliseconds */
 
+static inline bool wl1271_11a_enabled(void)
+{
+#ifdef WL1271_80211A_ENABLED
+	return true;
+#else
+	return false;
+#endif
+}
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 00ffa66..061d475 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -746,6 +746,11 @@ enum {
 	CONF_REF_CLK_52_E
 };
 
+enum single_dual_band_enum {
+	CONF_SINGLE_BAND,
+	CONF_DUAL_BAND
+};
+
 struct conf_general_parms {
 	/*
 	 * RF Reference Clock type / speed
@@ -778,7 +783,7 @@ struct conf_general_parms {
 	/*
 	 * Flag defining whether used as single or dual-band.
 	 *
-	 * Range: Unknown
+	 * Range: CONF_SINGLE_BAND, CONF_DUAL_BAND
 	 */
 	u8 single_dual_band;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 3d2e999..9b1cc8d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -260,13 +260,12 @@ static struct conf_drv_settings default_conf = {
 			.settling_time       = 5,
 			.clk_valid_on_wakeup = 0,
 			.dc2dcmode           = 0,
-			.single_dual_band    = 0,
+			.single_dual_band    = CONF_SINGLE_BAND,
 			.tx_bip_fem_autodetect = 0,
 			.tx_bip_fem_manufacturer = 1,
 			.settings = 1,
 		},
 		.radioparam = {
-			/* FIXME: 5GHz values unset! */
 			.rx_trace_loss       = 10,
 			.tx_trace_loss       = 10,
 			.rx_rssi_and_proc_compens = {
@@ -299,25 +298,29 @@ static struct conf_drv_settings default_conf = {
 			.tx_ibias            = {
 				0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x27 },
 			.rx_fem_insertion_loss = 0x14,
-			.tx_ref_pd_voltage_5 = { 0, 0, 0, 0, 0, 0, 0 },
-			.tx_ref_power_5      = { 0, 0, 0, 0, 0, 0, 0 },
-			.tx_offset_db_5      = {0, 0, 0, 0, 0, 0, 0 },
-			.tx_rate_limits_normal_5 = {
+			.tx_ref_pd_voltage_5 = {
+				0x0190, 0x01a4, 0x01c3, 0x01d8,
+				0x020a, 0x021c },
+			.tx_ref_power_5      = {
+				0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 },
+			.tx_offset_db_5      = {
 				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+			.tx_rate_limits_normal_5 = {
+				0x1b, 0x1e, 0x21, 0x23, 0x27, 0x00 },
 			.tx_rate_limits_degraded_5 = {
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+				0x1b, 0x1e, 0x21, 0x23, 0x27, 0x00 },
 			.tx_channel_limits_ofdm_5 = {
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00, 0x00, 0x00},
+				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
+				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
+				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
+				0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50,
+				0x50, 0x50, 0x50 },
 			.tx_pdv_rate_offsets_5 = {
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
+				0x01, 0x02, 0x02, 0x02, 0x02, 0x00 },
 			.tx_ibias_5          = {
-				0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
-			.rx_fem_insertion_loss_5 = { 0, 0, 0, 0, 0, 0, 0 }
+				0x10, 0x10, 0x10, 0x10, 0x10, 0x10 },
+			.rx_fem_insertion_loss_5 = {
+				0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10 }
 		}
 	}
 };
@@ -337,6 +340,9 @@ static void wl1271_conf_init(struct wl1271 *wl)
 
 	/* apply driver default configuration */
 	memcpy(&wl->conf, &default_conf, sizeof(default_conf));
+
+	if (wl1271_11a_enabled())
+		wl->conf.init.genparam.single_dual_band = CONF_DUAL_BAND;
 }
 
 
@@ -1556,6 +1562,88 @@ static struct ieee80211_supported_band wl1271_band_2ghz = {
 	.n_bitrates = ARRAY_SIZE(wl1271_rates),
 };
 
+/* 5 GHz data rates for WL1273 */
+static struct ieee80211_rate wl1271_rates_5ghz[] = {
+	{ .bitrate = 60,
+	  .hw_value = CONF_HW_BIT_RATE_6MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_6MBPS, },
+	{ .bitrate = 90,
+	  .hw_value = CONF_HW_BIT_RATE_9MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_9MBPS, },
+	{ .bitrate = 120,
+	  .hw_value = CONF_HW_BIT_RATE_12MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_12MBPS, },
+	{ .bitrate = 180,
+	  .hw_value = CONF_HW_BIT_RATE_18MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_18MBPS, },
+	{ .bitrate = 240,
+	  .hw_value = CONF_HW_BIT_RATE_24MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_24MBPS, },
+	{ .bitrate = 360,
+	 .hw_value = CONF_HW_BIT_RATE_36MBPS,
+	 .hw_value_short = CONF_HW_BIT_RATE_36MBPS, },
+	{ .bitrate = 480,
+	  .hw_value = CONF_HW_BIT_RATE_48MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_48MBPS, },
+	{ .bitrate = 540,
+	  .hw_value = CONF_HW_BIT_RATE_54MBPS,
+	  .hw_value_short = CONF_HW_BIT_RATE_54MBPS, },
+};
+
+/* 5 GHz band channels for WL1273 */
+static struct ieee80211_channel wl1271_channels_5ghz[] = {
+	{ .hw_value = 183, .center_freq = 4915},
+	{ .hw_value = 184, .center_freq = 4920},
+	{ .hw_value = 185, .center_freq = 4925},
+	{ .hw_value = 187, .center_freq = 4935},
+	{ .hw_value = 188, .center_freq = 4940},
+	{ .hw_value = 189, .center_freq = 4945},
+	{ .hw_value = 192, .center_freq = 4960},
+	{ .hw_value = 196, .center_freq = 4980},
+	{ .hw_value = 7, .center_freq = 5035},
+	{ .hw_value = 8, .center_freq = 5040},
+	{ .hw_value = 9, .center_freq = 5045},
+	{ .hw_value = 11, .center_freq = 5055},
+	{ .hw_value = 12, .center_freq = 5060},
+	{ .hw_value = 16, .center_freq = 5080},
+	{ .hw_value = 34, .center_freq = 5170},
+	{ .hw_value = 36, .center_freq = 5180},
+	{ .hw_value = 38, .center_freq = 5190},
+	{ .hw_value = 40, .center_freq = 5200},
+	{ .hw_value = 42, .center_freq = 5210},
+	{ .hw_value = 44, .center_freq = 5220},
+	{ .hw_value = 46, .center_freq = 5230},
+	{ .hw_value = 48, .center_freq = 5240},
+	{ .hw_value = 52, .center_freq = 5260},
+	{ .hw_value = 56, .center_freq = 5280},
+	{ .hw_value = 60, .center_freq = 5300},
+	{ .hw_value = 64, .center_freq = 5320},
+	{ .hw_value = 100, .center_freq = 5500},
+	{ .hw_value = 104, .center_freq = 5520},
+	{ .hw_value = 108, .center_freq = 5540},
+	{ .hw_value = 112, .center_freq = 5560},
+	{ .hw_value = 116, .center_freq = 5580},
+	{ .hw_value = 120, .center_freq = 5600},
+	{ .hw_value = 124, .center_freq = 5620},
+	{ .hw_value = 128, .center_freq = 5640},
+	{ .hw_value = 132, .center_freq = 5660},
+	{ .hw_value = 136, .center_freq = 5680},
+	{ .hw_value = 140, .center_freq = 5700},
+	{ .hw_value = 149, .center_freq = 5745},
+	{ .hw_value = 153, .center_freq = 5765},
+	{ .hw_value = 157, .center_freq = 5785},
+	{ .hw_value = 161, .center_freq = 5805},
+	{ .hw_value = 165, .center_freq = 5825},
+};
+
+
+static struct ieee80211_supported_band wl1271_band_5ghz = {
+	.channels = wl1271_channels_5ghz,
+	.n_channels = ARRAY_SIZE(wl1271_channels_5ghz),
+	.bitrates = wl1271_rates_5ghz,
+	.n_bitrates = ARRAY_SIZE(wl1271_rates_5ghz),
+};
+
 static const struct ieee80211_ops wl1271_ops = {
 	.start = wl1271_op_start,
 	.stop = wl1271_op_stop,
@@ -1612,6 +1700,9 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1271_band_2ghz;
 
+	if (wl1271_11a_enabled())
+		wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wl1271_band_5ghz;
+
 	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
 
 	return 0;
-- 
1.5.6.5

