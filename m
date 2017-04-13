Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36754 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755423AbdDMSHb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:31 -0400
Received: by mail-oi0-f67.google.com with SMTP id b187so13576545oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:26 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 11/19] rtlwifi: btcoex: 21a 2ant: check if wifi status changed
Date: Thu, 13 Apr 2017 13:07:02 -0500
Message-Id: <20170413180710.19953-12-Larry.Finger@lwfinger.net> (sfid-20170413_202544_597399_69CC09C7)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Monitor wifi status and check if it is changed.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 41 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  5 +++
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 4d69955fbebc..4030b6429c1d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -359,6 +359,47 @@ static void btc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
+bool btc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
+{
+	static bool pre_wifi_busy = true;
+	static bool pre_under_4way = true;
+	static bool pre_bt_hs_on = true;
+	bool wifi_busy = false, under_4way = false, bt_hs_on = false;
+	bool wifi_connected = false;
+	u8 wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
+
+	if (wifi_connected) {
+		if (wifi_busy != pre_wifi_busy) {
+			pre_wifi_busy = wifi_busy;
+			return true;
+		}
+		if (under_4way != pre_under_4way) {
+			pre_under_4way = under_4way;
+			return true;
+		}
+		if (bt_hs_on != pre_bt_hs_on) {
+			pre_bt_hs_on = bt_hs_on;
+			return true;
+		}
+
+		wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 3, 2,
+				BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_LOW))
+			return true;
+	}
+
+	return false;
+}
+
 static void btc8821a2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index 6db96cf44034..603e446b5953 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -38,6 +38,11 @@
 
 #define	BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT	2
 
+/* WiFi RSSI Threshold for 2-Ant TDMA/1-Ant PS-TDMA translation */
+#define BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES 42
+/* BT RSSI Threshold for 2-Ant TDMA/1-Ant PS-TDMA translation */
+#define BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES	46
+
 enum _BT_INFO_SRC_8821A_2ANT {
 	BT_INFO_SRC_8821A_2ANT_WIFI_FW		= 0x0,
 	BT_INFO_SRC_8821A_2ANT_BT_RSP		= 0x1,
-- 
2.12.0
