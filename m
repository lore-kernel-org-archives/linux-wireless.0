Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36543 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdDJQXR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:17 -0400
Received: by mail-oi0-f67.google.com with SMTP id b187so23324718oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/14] rtlwifi: btcoex: 21a 1ant: add function to check wifi status
Date: Mon, 10 Apr 2017 11:22:58 -0500
Message-Id: <20170410162310.7515-3-Larry.Finger@lwfinger.net> (sfid-20170410_182324_766117_8E497C03)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

This function checks if wifi has changed its statusi. It will be needed
in the future.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 5b8f4ed5ce62..65c455bfd8fb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -424,6 +424,39 @@ static void btc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
+bool btc8821a1ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
+{
+	static bool pre_wifi_busy = true;
+	static bool pre_under_4way = true;
+	static bool pre_bt_hs_on = true;
+	bool wifi_busy = false, under_4way = false, bt_hs_on = false;
+	bool wifi_connected = false;
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
+	}
+
+	return false;
+}
+
 static void btc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info	*bt_link_info = &btcoexist->bt_link_info;
-- 
2.12.0
