Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34769 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753146AbdDJQXZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:25 -0400
Received: by mail-oi0-f67.google.com with SMTP id o83so460049oik.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:25 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 11/14] rtlwifi: btcoex: 21a 1ant: consider more cases when bt inquiry
Date: Mon, 10 Apr 2017 11:23:07 -0500
Message-Id: <20170410162310.7515-12-Larry.Finger@lwfinger.net> (sfid-20170410_182353_831146_880F5F9F)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

With bt inquiry, the wifi may start as a softap or the wifi and bt are
busy, we take these scenarios into consider to avoid bt inquiry to
degrade the performance of the network

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 75 +++++++++++++++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  1 +
 2 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index c6114b32c0ca..6b08051614eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1139,8 +1139,8 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						    0x18, 0x0, 0x10);
 			break;
 		case 14:
-			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x21,
-						    0x3, 0x10, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x1e,
+						    0x3, 0x10, 0x14);
 			break;
 		case 15:
 			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x13, 0xa,
@@ -1519,27 +1519,46 @@ static void btc8821a1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false;
+	bool ap_enable = false;
+	bool wifi_busy = false, bt_busy = false;
 
-	btcoexist->btc_get(btcoexist,
-		 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
+			   &ap_enable);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
 
-	if (!wifi_connected) {
+	if (!wifi_connected && !coex_sta->wifi_is_high_pri_task) {
 		btc8821a1ant_power_save_state(btcoexist,
 					      BTC_PS_WIFI_NATIVE, 0x0, 0x0);
-		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
-	} else if ((bt_link_info->sco_exist) ||
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+	} else if ((bt_link_info->sco_exist) || (bt_link_info->a2dp_exist) ||
 		   (bt_link_info->hid_only)) {
 		/* SCO/HID-only busy */
 		btc8821a1ant_power_save_state(btcoexist,
 					      BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	} else if ((bt_link_info->a2dp_exist) && (bt_link_info->hid_exist)) {
+		/* A2DP+HID busy */
+		btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+
 		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	} else if ((bt_link_info->pan_exist) || (wifi_busy)) {
+		btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
 	} else {
-		btc8821a1ant_power_save_state(btcoexist, BTC_PS_LPS_ON,
-					      0x50, 0x4);
-		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 30);
-		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 	}
 }
 
@@ -1629,11 +1648,35 @@ void btc8821a1ant_action_wifi_not_connected(struct btc_coexist *btcoexist)
 
 static void btc8821a1ant_act_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 {
-	btc8821a1ant_power_save_state(btcoexist,
-				      BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+
+	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 
-	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
-	btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	/* tdma and coex table */
+	if (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) {
+		if (bt_link_info->a2dp_exist) {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
+		} else if (bt_link_info->a2dp_exist &&
+			   bt_link_info->pan_exist) {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 4);
+		} else {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 4);
+		}
+	} else if ((coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_SCO_BUSY) ||
+		   (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY ==
+		    coex_dm->bt_status)) {
+		btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
+				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN);
+	} else {
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	}
 }
 
 static
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index 2dec38ab7746..1bd1ebe3364e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -161,6 +161,7 @@ struct coex_sta_8821a_1ant {
 	u8	bt_info_c2h[BT_INFO_SRC_8821A_1ANT_MAX][10];
 	u32	bt_info_c2h_cnt[BT_INFO_SRC_8821A_1ANT_MAX];
 	bool	c2h_bt_inquiry_page;
+	bool	wifi_is_high_pri_task;
 	u8	bt_retry_cnt;
 	u8	bt_info_ext;
 };
-- 
2.12.0
