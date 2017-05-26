Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35491 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754119AbdEZSl5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 14:41:57 -0400
Received: by mail-oi0-f67.google.com with SMTP id v80so2985798oie.2
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 11:41:57 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 2/7] rtlwifi: btcoex: fix compiler warnings for unused functions
Date: Fri, 26 May 2017 13:41:42 -0500
Message-Id: <20170526184147.31239-3-Larry.Finger@lwfinger.net> (sfid-20170526_204332_898612_8837B08F)
In-Reply-To: <20170526184147.31239-1-Larry.Finger@lwfinger.net>
References: <20170526184147.31239-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Delete unused is_wifi_status_changed for 21a 1 ant

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - no changes
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 33 ----------------------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |  2 +-
 2 files changed, 1 insertion(+), 34 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 4efac5fe9982..2740129a86cd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -426,39 +426,6 @@ static void btc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-bool btc8821a1ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
-{
-	static bool pre_wifi_busy = true;
-	static bool pre_under_4way = true;
-	static bool pre_bt_hs_on = true;
-	bool wifi_busy = false, under_4way = false, bt_hs_on = false;
-	bool wifi_connected = false;
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
-			   &wifi_connected);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
-			   &under_4way);
-
-	if (wifi_connected) {
-		if (wifi_busy != pre_wifi_busy) {
-			pre_wifi_busy = wifi_busy;
-			return true;
-		}
-		if (under_4way != pre_under_4way) {
-			pre_under_4way = under_4way;
-			return true;
-		}
-		if (bt_hs_on != pre_bt_hs_on) {
-			pre_bt_hs_on = bt_hs_on;
-			return true;
-		}
-	}
-
-	return false;
-}
-
 static void btc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info	*bt_link_info = &btcoexist->bt_link_info;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 41943c34edff..c27488f77573 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -359,7 +359,7 @@ static void btc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-bool btc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
+static bool btc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 {
 	static bool pre_wifi_busy = true;
 	static bool pre_under_4way = true;
-- 
2.12.0
