Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:49693 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0JJIgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 04:36:31 -0400
From: Kalle Valo <kvalo@adurom.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>
Subject: [PATCH 1/3] wl1251: create a copy of wl12xx_80211.h for wl1251
Date: Sun, 10 Oct 2010 11:28:31 +0300
Message-Id: <1286699313-7774-2-git-send-email-kvalo@adurom.com>
In-Reply-To: <1286699313-7774-1-git-send-email-kvalo@adurom.com>
References: <1286699313-7774-1-git-send-email-kvalo@adurom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation of moving wl1251 out from drivers/net/wireless/wl12xx
create a separate copy of wl12xx_80211.h.

This file should not even exist, we should instead use generic ieee80211
definitions. This will be fixed in the future so that the file can
be removed.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 drivers/net/wireless/wl1251/wl12xx_80211.h |  156 ++++++++++++++++++++++++++++
 1 files changed, 156 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/wl1251/wl12xx_80211.h

diff --git a/drivers/net/wireless/wl1251/wl12xx_80211.h b/drivers/net/wireless/wl1251/wl12xx_80211.h
new file mode 100644
index 0000000..1846280
--- /dev/null
+++ b/drivers/net/wireless/wl1251/wl12xx_80211.h
@@ -0,0 +1,156 @@
+#ifndef __WL12XX_80211_H__
+#define __WL12XX_80211_H__
+
+#include <linux/if_ether.h>	/* ETH_ALEN */
+
+/* RATES */
+#define IEEE80211_CCK_RATE_1MB		        0x02
+#define IEEE80211_CCK_RATE_2MB		        0x04
+#define IEEE80211_CCK_RATE_5MB		        0x0B
+#define IEEE80211_CCK_RATE_11MB		        0x16
+#define IEEE80211_OFDM_RATE_6MB		        0x0C
+#define IEEE80211_OFDM_RATE_9MB		        0x12
+#define IEEE80211_OFDM_RATE_12MB		0x18
+#define IEEE80211_OFDM_RATE_18MB		0x24
+#define IEEE80211_OFDM_RATE_24MB		0x30
+#define IEEE80211_OFDM_RATE_36MB		0x48
+#define IEEE80211_OFDM_RATE_48MB		0x60
+#define IEEE80211_OFDM_RATE_54MB		0x6C
+#define IEEE80211_BASIC_RATE_MASK		0x80
+
+#define IEEE80211_CCK_RATE_1MB_MASK		(1<<0)
+#define IEEE80211_CCK_RATE_2MB_MASK		(1<<1)
+#define IEEE80211_CCK_RATE_5MB_MASK		(1<<2)
+#define IEEE80211_CCK_RATE_11MB_MASK		(1<<3)
+#define IEEE80211_OFDM_RATE_6MB_MASK		(1<<4)
+#define IEEE80211_OFDM_RATE_9MB_MASK		(1<<5)
+#define IEEE80211_OFDM_RATE_12MB_MASK		(1<<6)
+#define IEEE80211_OFDM_RATE_18MB_MASK		(1<<7)
+#define IEEE80211_OFDM_RATE_24MB_MASK		(1<<8)
+#define IEEE80211_OFDM_RATE_36MB_MASK		(1<<9)
+#define IEEE80211_OFDM_RATE_48MB_MASK		(1<<10)
+#define IEEE80211_OFDM_RATE_54MB_MASK		(1<<11)
+
+#define IEEE80211_CCK_RATES_MASK	  0x0000000F
+#define IEEE80211_CCK_BASIC_RATES_MASK	 (IEEE80211_CCK_RATE_1MB_MASK | \
+	IEEE80211_CCK_RATE_2MB_MASK)
+#define IEEE80211_CCK_DEFAULT_RATES_MASK (IEEE80211_CCK_BASIC_RATES_MASK | \
+	IEEE80211_CCK_RATE_5MB_MASK | \
+	IEEE80211_CCK_RATE_11MB_MASK)
+
+#define IEEE80211_OFDM_RATES_MASK	  0x00000FF0
+#define IEEE80211_OFDM_BASIC_RATES_MASK	  (IEEE80211_OFDM_RATE_6MB_MASK | \
+	IEEE80211_OFDM_RATE_12MB_MASK | \
+	IEEE80211_OFDM_RATE_24MB_MASK)
+#define IEEE80211_OFDM_DEFAULT_RATES_MASK (IEEE80211_OFDM_BASIC_RATES_MASK | \
+	IEEE80211_OFDM_RATE_9MB_MASK  | \
+	IEEE80211_OFDM_RATE_18MB_MASK | \
+	IEEE80211_OFDM_RATE_36MB_MASK | \
+	IEEE80211_OFDM_RATE_48MB_MASK | \
+	IEEE80211_OFDM_RATE_54MB_MASK)
+#define IEEE80211_DEFAULT_RATES_MASK (IEEE80211_OFDM_DEFAULT_RATES_MASK | \
+				      IEEE80211_CCK_DEFAULT_RATES_MASK)
+
+
+/* This really should be 8, but not for our firmware */
+#define MAX_SUPPORTED_RATES 32
+#define COUNTRY_STRING_LEN 3
+#define MAX_COUNTRY_TRIPLETS 32
+
+/* Headers */
+struct ieee80211_header {
+	__le16 frame_ctl;
+	__le16 duration_id;
+	u8 da[ETH_ALEN];
+	u8 sa[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
+	__le16 seq_ctl;
+	u8 payload[0];
+} __packed;
+
+struct wl12xx_ie_header {
+	u8 id;
+	u8 len;
+} __packed;
+
+/* IEs */
+
+struct wl12xx_ie_ssid {
+	struct wl12xx_ie_header header;
+	char ssid[IW_ESSID_MAX_SIZE];
+} __packed;
+
+struct wl12xx_ie_rates {
+	struct wl12xx_ie_header header;
+	u8 rates[MAX_SUPPORTED_RATES];
+} __packed;
+
+struct wl12xx_ie_ds_params {
+	struct wl12xx_ie_header header;
+	u8 channel;
+} __packed;
+
+struct country_triplet {
+	u8 channel;
+	u8 num_channels;
+	u8 max_tx_power;
+} __packed;
+
+struct wl12xx_ie_country {
+	struct wl12xx_ie_header header;
+	u8 country_string[COUNTRY_STRING_LEN];
+	struct country_triplet triplets[MAX_COUNTRY_TRIPLETS];
+} __packed;
+
+
+/* Templates */
+
+struct wl12xx_beacon_template {
+	struct ieee80211_header header;
+	__le32 time_stamp[2];
+	__le16 beacon_interval;
+	__le16 capability;
+	struct wl12xx_ie_ssid ssid;
+	struct wl12xx_ie_rates rates;
+	struct wl12xx_ie_rates ext_rates;
+	struct wl12xx_ie_ds_params ds_params;
+	struct wl12xx_ie_country country;
+} __packed;
+
+struct wl12xx_null_data_template {
+	struct ieee80211_header header;
+} __packed;
+
+struct wl12xx_ps_poll_template {
+	__le16 fc;
+	__le16 aid;
+	u8 bssid[ETH_ALEN];
+	u8 ta[ETH_ALEN];
+} __packed;
+
+struct wl12xx_qos_null_data_template {
+	struct ieee80211_header header;
+	__le16 qos_ctl;
+} __packed;
+
+struct wl12xx_probe_req_template {
+	struct ieee80211_header header;
+	struct wl12xx_ie_ssid ssid;
+	struct wl12xx_ie_rates rates;
+	struct wl12xx_ie_rates ext_rates;
+} __packed;
+
+
+struct wl12xx_probe_resp_template {
+	struct ieee80211_header header;
+	__le32 time_stamp[2];
+	__le16 beacon_interval;
+	__le16 capability;
+	struct wl12xx_ie_ssid ssid;
+	struct wl12xx_ie_rates rates;
+	struct wl12xx_ie_rates ext_rates;
+	struct wl12xx_ie_ds_params ds_params;
+	struct wl12xx_ie_country country;
+} __packed;
+
+#endif
-- 
1.7.0.4

