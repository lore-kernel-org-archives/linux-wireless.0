Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43968 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1HVVuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 17:50:46 -0400
Received: by mail-gy0-f174.google.com with SMTP id 6so3903756gya.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 14:50:46 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH 1/5] rtlwifi: Install updated rate-mapping routine
Date: Mon, 22 Aug 2011 16:50:14 -0500
Message-Id: <1314049818-21839-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110822_235057_700730_E5B311B6)
In-Reply-To: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for fixing the rate-mapping situation, place a driver-agnostic
version in rtlwifi. This one contains the updated rate incormation.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
---
 drivers/net/wireless/rtlwifi/base.c |  161 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/base.h |    2 +
 drivers/net/wireless/rtlwifi/wifi.h |   35 ++++++++
 3 files changed, 198 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 0b598db..098fc55 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -664,6 +664,167 @@ static u8 _rtl_get_highest_n_rate(struct ieee80211_hw *hw)
 	return hw_rate;
 }
 
+/* mac80211's rate_idx is like this:
+ *
+ * 2.4G band:rx_status->band == IEEE80211_BAND_2GHZ
+ *
+ * B/G rate:
+ * (rx_status->flag & RX_FLAG_HT) = 0,
+ * DESC92_RATE1M-->DESC92_RATE54M ==> idx is 0-->11,
+ *
+ * N rate:
+ * (rx_status->flag & RX_FLAG_HT) = 1,
+ * DESC92_RATEMCS0-->DESC92_RATEMCS15 ==> idx is 0-->15
+ *
+ * 5G band:rx_status->band == IEEE80211_BAND_5GHZ
+ * A rate:
+ * (rx_status->flag & RX_FLAG_HT) = 0,
+ * DESC92_RATE6M-->DESC92_RATE54M ==> idx is 0-->7,
+ *
+ * N rate:
+ * (rx_status->flag & RX_FLAG_HT) = 1,
+ * DESC92_RATEMCS0-->DESC92_RATEMCS15 ==> idx is 0-->15
+ */
+int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
+			 bool isht, u8 desc_rate, bool first_ampdu)
+{
+	int rate_idx;
+
+	if (false == isht) {
+		if (IEEE80211_BAND_2GHZ == hw->conf.channel->band) {
+			switch (desc_rate) {
+			case DESC92_RATE1M:
+				rate_idx = 0;
+				break;
+			case DESC92_RATE2M:
+				rate_idx = 1;
+				break;
+			case DESC92_RATE5_5M:
+				rate_idx = 2;
+				break;
+			case DESC92_RATE11M:
+				rate_idx = 3;
+				break;
+			case DESC92_RATE6M:
+				rate_idx = 4;
+				break;
+			case DESC92_RATE9M:
+				rate_idx = 5;
+				break;
+			case DESC92_RATE12M:
+				rate_idx = 6;
+				break;
+			case DESC92_RATE18M:
+				rate_idx = 7;
+				break;
+			case DESC92_RATE24M:
+				rate_idx = 8;
+				break;
+			case DESC92_RATE36M:
+				rate_idx = 9;
+				break;
+			case DESC92_RATE48M:
+				rate_idx = 10;
+				break;
+			case DESC92_RATE54M:
+				rate_idx = 11;
+				break;
+			default:
+				rate_idx = 0;
+				break;
+			}
+		} else {
+			switch (desc_rate) {
+			case DESC92_RATE6M:
+				rate_idx = 0;
+				break;
+			case DESC92_RATE9M:
+				rate_idx = 1;
+				break;
+			case DESC92_RATE12M:
+				rate_idx = 2;
+				break;
+			case DESC92_RATE18M:
+				rate_idx = 3;
+				break;
+			case DESC92_RATE24M:
+				rate_idx = 4;
+				break;
+			case DESC92_RATE36M:
+				rate_idx = 5;
+				break;
+			case DESC92_RATE48M:
+				rate_idx = 6;
+				break;
+			case DESC92_RATE54M:
+				rate_idx = 7;
+				break;
+			default:
+				rate_idx = 0;
+				break;
+			}
+		}
+
+	} else {
+
+		switch (desc_rate) {
+		case DESC92_RATEMCS0:
+			rate_idx = 0;
+			break;
+		case DESC92_RATEMCS1:
+			rate_idx = 1;
+			break;
+		case DESC92_RATEMCS2:
+			rate_idx = 2;
+			break;
+		case DESC92_RATEMCS3:
+			rate_idx = 3;
+			break;
+		case DESC92_RATEMCS4:
+			rate_idx = 4;
+			break;
+		case DESC92_RATEMCS5:
+			rate_idx = 5;
+			break;
+		case DESC92_RATEMCS6:
+			rate_idx = 6;
+			break;
+		case DESC92_RATEMCS7:
+			rate_idx = 7;
+			break;
+		case DESC92_RATEMCS8:
+			rate_idx = 8;
+			break;
+		case DESC92_RATEMCS9:
+			rate_idx = 9;
+			break;
+		case DESC92_RATEMCS10:
+			rate_idx = 10;
+			break;
+		case DESC92_RATEMCS11:
+			rate_idx = 11;
+			break;
+		case DESC92_RATEMCS12:
+			rate_idx = 12;
+			break;
+		case DESC92_RATEMCS13:
+			rate_idx = 13;
+			break;
+		case DESC92_RATEMCS14:
+			rate_idx = 14;
+			break;
+		case DESC92_RATEMCS15:
+			rate_idx = 15;
+			break;
+		default:
+			rate_idx = 0;
+			break;
+		}
+	}
+	return rate_idx;
+}
+EXPORT_SYMBOL(rtlwifi_rate_mapping);
+
 void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		      struct ieee80211_tx_info *info,
 		      struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index a91f3ee..4ae9059 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -140,4 +140,6 @@ u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie);
 void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len);
 u8 rtl_tid_to_ac(struct ieee80211_hw *hw, u8 tid);
 extern struct attribute_group rtl_attribute_group;
+int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
+			 bool isht, u8 desc_rate, bool first_ampdu);
 #endif
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index d3c3ffd..8a90919 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -386,6 +386,41 @@ enum rtl_hal_state {
 	_HAL_STATE_START = 1,
 };
 
+enum rtl_desc92_rate {
+	DESC92_RATE1M = 0x00,
+	DESC92_RATE2M = 0x01,
+	DESC92_RATE5_5M = 0x02,
+	DESC92_RATE11M = 0x03,
+
+	DESC92_RATE6M = 0x04,
+	DESC92_RATE9M = 0x05,
+	DESC92_RATE12M = 0x06,
+	DESC92_RATE18M = 0x07,
+	DESC92_RATE24M = 0x08,
+	DESC92_RATE36M = 0x09,
+	DESC92_RATE48M = 0x0a,
+	DESC92_RATE54M = 0x0b,
+
+	DESC92_RATEMCS0 = 0x0c,
+	DESC92_RATEMCS1 = 0x0d,
+	DESC92_RATEMCS2 = 0x0e,
+	DESC92_RATEMCS3 = 0x0f,
+	DESC92_RATEMCS4 = 0x10,
+	DESC92_RATEMCS5 = 0x11,
+	DESC92_RATEMCS6 = 0x12,
+	DESC92_RATEMCS7 = 0x13,
+	DESC92_RATEMCS8 = 0x14,
+	DESC92_RATEMCS9 = 0x15,
+	DESC92_RATEMCS10 = 0x16,
+	DESC92_RATEMCS11 = 0x17,
+	DESC92_RATEMCS12 = 0x18,
+	DESC92_RATEMCS13 = 0x19,
+	DESC92_RATEMCS14 = 0x1a,
+	DESC92_RATEMCS15 = 0x1b,
+	DESC92_RATEMCS15_SG = 0x1c,
+	DESC92_RATEMCS32 = 0x20,
+};
+
 enum rtl_var_map {
 	/*reg map */
 	SYS_ISO_CTRL = 0,
-- 
1.7.3.4

