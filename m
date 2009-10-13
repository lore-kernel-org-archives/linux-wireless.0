Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36158 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933760AbZJMJuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:10 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 14/22] wl1271: Added 5 GHz support to join and rx
Date: Tue, 13 Oct 2009 12:47:51 +0300
Message-Id: <1255427279-1224-15-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Added support to assiociate and use connection on 5 GHz band (802.11a).

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   13 ++++++-
 drivers/net/wireless/wl12xx/wl1271_cmd.h |    1 +
 drivers/net/wireless/wl12xx/wl1271_rx.c  |   57 ++++++++++++++++++++++++------
 3 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 6d7a40c..fe4f1e6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -219,6 +219,7 @@ int wl1271_cmd_join(struct wl1271 *wl)
 
 	join->rx_config_options = wl->rx_config;
 	join->rx_filter_options = wl->rx_filter;
+	join->bss_type = wl->bss_type;
 
 	/*
 	 * FIXME: disable temporarily all filters because after commit
@@ -229,12 +230,20 @@ int wl1271_cmd_join(struct wl1271 *wl)
 	join->rx_config_options = 0;
 	join->rx_filter_options = WL1271_DEFAULT_RX_FILTER;
 
-	join->basic_rate_set = CONF_HW_BIT_RATE_1MBPS | CONF_HW_BIT_RATE_2MBPS |
+	if (wl->band == IEEE80211_BAND_2GHZ)
+		join->basic_rate_set =
+			CONF_HW_BIT_RATE_1MBPS | CONF_HW_BIT_RATE_2MBPS |
 		CONF_HW_BIT_RATE_5_5MBPS | CONF_HW_BIT_RATE_11MBPS;
+	else {
+		join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
+		join->basic_rate_set =
+			CONF_HW_BIT_RATE_6MBPS | CONF_HW_BIT_RATE_12MBPS |
+			CONF_HW_BIT_RATE_24MBPS;
+	}
 
 	join->beacon_interval = WL1271_DEFAULT_BEACON_INT;
 	join->dtim_interval = WL1271_DEFAULT_DTIM_PERIOD;
-	join->bss_type = wl->bss_type;
+
 	join->channel = wl->channel;
 	join->ssid_len = wl->ssid_len;
 	memcpy(join->ssid, wl->ssid, wl->ssid_len);
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 3308940..15254fa 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -198,6 +198,7 @@ enum {
 
 #define WL1271_JOIN_CMD_CTRL_TX_FLUSH     0x80 /* Firmware flushes all Tx */
 #define WL1271_JOIN_CMD_TX_SESSION_OFFSET 1
+#define WL1271_JOIN_CMD_BSS_TYPE_5GHZ 0x10
 
 struct wl1271_cmd_join {
 	struct wl1271_cmd_header header;
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 66b83e9..1dd8458 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -70,6 +70,36 @@ static u8 wl1271_rx_rate_to_idx[] = {
 	0                           /* WL1271_RATE_1    */
 };
 
+/* The values of this table must match the wl1271_rates[] array */
+static u8 wl1271_5_ghz_rx_rate_to_idx[] = {
+	/* MCS rates are used only with 11n */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS7 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS6 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS5 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS4 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS3 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS2 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS1 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS0 */
+
+	7,                          /* WL1271_RATE_54   */
+	6,                          /* WL1271_RATE_48   */
+	5,                          /* WL1271_RATE_36   */
+	4,                          /* WL1271_RATE_24   */
+
+	/* TI-specific rate */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_22   */
+
+	3,                          /* WL1271_RATE_18   */
+	2,                          /* WL1271_RATE_12   */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_11   */
+	1,                          /* WL1271_RATE_9    */
+	0,                          /* WL1271_RATE_6    */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_5_5  */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_2    */
+	WL1271_RX_RATE_UNSUPPORTED  /* WL1271_RATE_1    */
+};
+
 static void wl1271_rx_status(struct wl1271 *wl,
 			     struct wl1271_rx_descriptor *desc,
 			     struct ieee80211_rx_status *status,
@@ -77,15 +107,21 @@ static void wl1271_rx_status(struct wl1271 *wl,
 {
 	memset(status, 0, sizeof(struct ieee80211_rx_status));
 
-	if ((desc->flags & WL1271_RX_DESC_BAND_MASK) == WL1271_RX_DESC_BAND_BG)
+	if ((desc->flags & WL1271_RX_DESC_BAND_MASK) ==
+	    WL1271_RX_DESC_BAND_BG) {
 		status->band = IEEE80211_BAND_2GHZ;
-	else if ((desc->flags & WL1271_RX_DESC_BAND_MASK) ==
-		 WL1271_RX_DESC_BAND_A)
+		status->rate_idx = wl1271_rx_rate_to_idx[desc->rate];
+	} else if ((desc->flags & WL1271_RX_DESC_BAND_MASK) ==
+		 WL1271_RX_DESC_BAND_A) {
 		status->band = IEEE80211_BAND_5GHZ;
-	else
+		status->rate_idx = wl1271_5_ghz_rx_rate_to_idx[desc->rate];
+	} else
 		wl1271_warning("unsupported band 0x%x",
 			       desc->flags & WL1271_RX_DESC_BAND_MASK);
 
+	if (unlikely(status->rate_idx == WL1271_RX_RATE_UNSUPPORTED))
+		wl1271_warning("unsupported rate");
+
 	/*
 	 * FIXME: Add mactime handling.  For IBSS (ad-hoc) we need to get the
 	 * timestamp from the beacon (acx_tsf_info).  In BSS mode (infra) we
@@ -108,15 +144,14 @@ static void wl1271_rx_status(struct wl1271 *wl,
 
 		if (likely(!(desc->flags & WL1271_RX_DESC_DECRYPT_FAIL)))
 			status->flag |= RX_FLAG_DECRYPTED;
-
+		/* FIXME: Flag should be also set when using 5 GHz band.
+		 * At the moment chip reports MIC failed on all packets,
+		 * so flag is silently discarded.
+		 */
 		if (unlikely(desc->flags & WL1271_RX_DESC_MIC_FAIL))
-			status->flag |= RX_FLAG_MMIC_ERROR;
+			if (status->band != IEEE80211_BAND_5GHZ)
+				status->flag |= RX_FLAG_MMIC_ERROR;
 	}
-
-	status->rate_idx = wl1271_rx_rate_to_idx[desc->rate];
-
-	if (status->rate_idx == WL1271_RX_RATE_UNSUPPORTED)
-		wl1271_warning("unsupported rate");
 }
 
 static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
-- 
1.5.6.5

