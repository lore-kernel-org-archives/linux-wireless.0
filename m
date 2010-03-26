Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30707 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0CZKyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:10 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 02/24] wl1271: Clean up RX rate reporting
Date: Fri, 26 Mar 2010 12:53:11 +0200
Message-Id: <1269600813-32145-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Clean up the code to convert a firmware rate class index into an index
for the rate configuration table.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_conf.h |   26 +++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |   85 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_rx.c   |   76 +-------------------------
 drivers/net/wireless/wl12xx/wl1271_rx.h   |    2 +-
 4 files changed, 114 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 7fcfe06..f63dd5e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -66,6 +66,32 @@ enum {
 };
 
 enum {
+	CONF_HW_RXTX_RATE_MCS7 = 0,
+	CONF_HW_RXTX_RATE_MCS6,
+	CONF_HW_RXTX_RATE_MCS5,
+	CONF_HW_RXTX_RATE_MCS4,
+	CONF_HW_RXTX_RATE_MCS3,
+	CONF_HW_RXTX_RATE_MCS2,
+	CONF_HW_RXTX_RATE_MCS1,
+	CONF_HW_RXTX_RATE_MCS0,
+	CONF_HW_RXTX_RATE_54,
+	CONF_HW_RXTX_RATE_48,
+	CONF_HW_RXTX_RATE_36,
+	CONF_HW_RXTX_RATE_24,
+	CONF_HW_RXTX_RATE_22,
+	CONF_HW_RXTX_RATE_18,
+	CONF_HW_RXTX_RATE_12,
+	CONF_HW_RXTX_RATE_11,
+	CONF_HW_RXTX_RATE_9,
+	CONF_HW_RXTX_RATE_6,
+	CONF_HW_RXTX_RATE_5_5,
+	CONF_HW_RXTX_RATE_2,
+	CONF_HW_RXTX_RATE_1,
+	CONF_HW_RXTX_RATE_MAX,
+	CONF_HW_RXTX_RATE_UNSUPPORTED = 0xff
+};
+
+enum {
 	CONF_SG_DISABLE = 0,
 	CONF_SG_PROTECTIVE,
 	CONF_SG_OPPORTUNISTIC
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 3daba6c..49779e5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1816,6 +1816,36 @@ static struct ieee80211_channel wl1271_channels[] = {
 	{ .hw_value = 13, .center_freq = 2472, .max_power = 25 },
 };
 
+/* mapping to indexes for wl1271_rates */
+const static u8 wl1271_rate_to_idx_2ghz[] = {
+	/* MCS rates are used only with 11n */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS7 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS6 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS5 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS4 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS3 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS2 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS1 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS0 */
+
+	11,                            /* CONF_HW_RXTX_RATE_54   */
+	10,                            /* CONF_HW_RXTX_RATE_48   */
+	9,                             /* CONF_HW_RXTX_RATE_36   */
+	8,                             /* CONF_HW_RXTX_RATE_24   */
+
+	/* TI-specific rate */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_22   */
+
+	7,                             /* CONF_HW_RXTX_RATE_18   */
+	6,                             /* CONF_HW_RXTX_RATE_12   */
+	3,                             /* CONF_HW_RXTX_RATE_11   */
+	5,                             /* CONF_HW_RXTX_RATE_9    */
+	4,                             /* CONF_HW_RXTX_RATE_6    */
+	2,                             /* CONF_HW_RXTX_RATE_5_5  */
+	1,                             /* CONF_HW_RXTX_RATE_2    */
+	0                              /* CONF_HW_RXTX_RATE_1    */
+};
+
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_supported_band wl1271_band_2ghz = {
 	.channels = wl1271_channels,
@@ -1898,6 +1928,35 @@ static struct ieee80211_channel wl1271_channels_5ghz[] = {
 	{ .hw_value = 165, .center_freq = 5825},
 };
 
+/* mapping to indexes for wl1271_rates_5ghz */
+const static u8 wl1271_rate_to_idx_5ghz[] = {
+	/* MCS rates are used only with 11n */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS7 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS6 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS5 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS4 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS3 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS2 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS1 */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS0 */
+
+	7,                             /* CONF_HW_RXTX_RATE_54   */
+	6,                             /* CONF_HW_RXTX_RATE_48   */
+	5,                             /* CONF_HW_RXTX_RATE_36   */
+	4,                             /* CONF_HW_RXTX_RATE_24   */
+
+	/* TI-specific rate */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_22   */
+
+	3,                             /* CONF_HW_RXTX_RATE_18   */
+	2,                             /* CONF_HW_RXTX_RATE_12   */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_11   */
+	1,                             /* CONF_HW_RXTX_RATE_9    */
+	0,                             /* CONF_HW_RXTX_RATE_6    */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_5_5  */
+	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_2    */
+	CONF_HW_RXTX_RATE_UNSUPPORTED  /* CONF_HW_RXTX_RATE_1    */
+};
 
 static struct ieee80211_supported_band wl1271_band_5ghz = {
 	.channels = wl1271_channels_5ghz,
@@ -1906,6 +1965,11 @@ static struct ieee80211_supported_band wl1271_band_5ghz = {
 	.n_bitrates = ARRAY_SIZE(wl1271_rates_5ghz),
 };
 
+const static u8 *wl1271_band_rate_to_idx[] = {
+	[IEEE80211_BAND_2GHZ] = wl1271_rate_to_idx_2ghz,
+	[IEEE80211_BAND_5GHZ] = wl1271_rate_to_idx_5ghz
+};
+
 static const struct ieee80211_ops wl1271_ops = {
 	.start = wl1271_op_start,
 	.stop = wl1271_op_stop,
@@ -1923,6 +1987,27 @@ static const struct ieee80211_ops wl1271_ops = {
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
+
+u8 wl1271_rate_to_idx(struct wl1271 *wl, int rate)
+{
+	u8 idx;
+
+	BUG_ON(wl->band >= sizeof(wl1271_band_rate_to_idx)/sizeof(u8 *));
+
+	if (unlikely(rate >= CONF_HW_RXTX_RATE_MAX)) {
+		wl1271_error("Illegal RX rate from HW: %d", rate);
+		return 0;
+	}
+
+	idx = wl1271_band_rate_to_idx[wl->band][rate];
+	if (unlikely(idx == CONF_HW_RXTX_RATE_UNSUPPORTED)) {
+		wl1271_error("Unsupported RX rate from HW: %d", rate);
+		return 0;
+	}
+
+	return idx;
+}
+
 static ssize_t wl1271_sysfs_show_bt_coex_state(struct device *dev,
 					       struct device_attribute *attr,
 					       char *buf)
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index b824c6c..a1a7953 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -41,66 +41,6 @@ static u32 wl1271_rx_get_buf_size(struct wl1271_fw_status *status,
 		RX_BUF_SIZE_MASK) >> RX_BUF_SIZE_SHIFT_DIV;
 }
 
-/* The values of this table must match the wl1271_rates[] array */
-static u8 wl1271_rx_rate_to_idx[] = {
-	/* MCS rates are used only with 11n */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS7 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS6 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS5 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS4 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS3 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS2 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS1 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS0 */
-
-	11,                         /* WL1271_RATE_54   */
-	10,                         /* WL1271_RATE_48   */
-	9,                          /* WL1271_RATE_36   */
-	8,                          /* WL1271_RATE_24   */
-
-	/* TI-specific rate */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_22   */
-
-	7,                          /* WL1271_RATE_18   */
-	6,                          /* WL1271_RATE_12   */
-	3,                          /* WL1271_RATE_11   */
-	5,                          /* WL1271_RATE_9    */
-	4,                          /* WL1271_RATE_6    */
-	2,                          /* WL1271_RATE_5_5  */
-	1,                          /* WL1271_RATE_2    */
-	0                           /* WL1271_RATE_1    */
-};
-
-/* The values of this table must match the wl1271_rates[] array */
-static u8 wl1271_5_ghz_rx_rate_to_idx[] = {
-	/* MCS rates are used only with 11n */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS7 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS6 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS5 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS4 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS3 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS2 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS1 */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS0 */
-
-	7,                          /* WL1271_RATE_54   */
-	6,                          /* WL1271_RATE_48   */
-	5,                          /* WL1271_RATE_36   */
-	4,                          /* WL1271_RATE_24   */
-
-	/* TI-specific rate */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_22   */
-
-	3,                          /* WL1271_RATE_18   */
-	2,                          /* WL1271_RATE_12   */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_11   */
-	1,                          /* WL1271_RATE_9    */
-	0,                          /* WL1271_RATE_6    */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_5_5  */
-	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_2    */
-	WL1271_RX_RATE_UNSUPPORTED  /* WL1271_RATE_1    */
-};
-
 static void wl1271_rx_status(struct wl1271 *wl,
 			     struct wl1271_rx_descriptor *desc,
 			     struct ieee80211_rx_status *status,
@@ -108,20 +48,8 @@ static void wl1271_rx_status(struct wl1271 *wl,
 {
 	memset(status, 0, sizeof(struct ieee80211_rx_status));
 
-	if ((desc->flags & WL1271_RX_DESC_BAND_MASK) ==
-	    WL1271_RX_DESC_BAND_BG) {
-		status->band = IEEE80211_BAND_2GHZ;
-		status->rate_idx = wl1271_rx_rate_to_idx[desc->rate];
-	} else if ((desc->flags & WL1271_RX_DESC_BAND_MASK) ==
-		 WL1271_RX_DESC_BAND_A) {
-		status->band = IEEE80211_BAND_5GHZ;
-		status->rate_idx = wl1271_5_ghz_rx_rate_to_idx[desc->rate];
-	} else
-		wl1271_warning("unsupported band 0x%x",
-			       desc->flags & WL1271_RX_DESC_BAND_MASK);
-
-	if (unlikely(status->rate_idx == WL1271_RX_RATE_UNSUPPORTED))
-		wl1271_warning("unsupported rate");
+	status->band = wl->band;
+	status->rate_idx = wl1271_rate_to_idx(wl, desc->rate);
 
 	/*
 	 * FIXME: Add mactime handling.  For IBSS (ad-hoc) we need to get the
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.h b/drivers/net/wireless/wl12xx/wl1271_rx.h
index 1ae6d17..b89be47 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.h
@@ -43,7 +43,6 @@
 #define RX_MAX_PACKET_ID 3
 
 #define NUM_RX_PKT_DESC_MOD_MASK   7
-#define WL1271_RX_RATE_UNSUPPORTED 0xFF
 
 #define RX_DESC_VALID_FCS         0x0001
 #define RX_DESC_MATCH_RXADDR1     0x0002
@@ -117,5 +116,6 @@ struct wl1271_rx_descriptor {
 } __attribute__ ((packed));
 
 void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status);
+u8 wl1271_rate_to_idx(struct wl1271 *wl, int rate);
 
 #endif
-- 
1.6.3.3

