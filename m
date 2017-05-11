Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35163 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756635AbdEKXY7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 19:24:59 -0400
Received: by mail-oi0-f65.google.com with SMTP id m17so6445016oik.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 16:24:58 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/10] rtlwifi: btcoex: 21a 1ant: set tdma and coex table when wifi is idle
Date: Thu, 11 May 2017 18:24:29 -0500
Message-Id: <20170511232438.23159-2-Larry.Finger@lwfinger.net> (sfid-20170512_012504_172972_D0E7A604)
In-Reply-To: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
References: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is idle, bt could have more resources to transmit, so set the
tdma and coex table to achieve this.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 34 +++++++++++++++-------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index bd5f752f153d..087e3ffff2f0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1212,8 +1212,8 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						    0x1a, 0, 0x58);
 			break;
 		case 32:
-			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0xa,
-						    0x3, 0x10, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0x35,
+						    0x3, 0x11, 0x11);
 			break;
 		case 33:
 			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xa3, 0x25,
@@ -1231,6 +1231,10 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x12,
 						    0x3, 0x14, 0x50);
 			break;
+		case 43:
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x30,
+						    0x3, 0x10, 0x11);
+			break;
 		}
 	} else {
 		/* disable PS tdma */
@@ -1619,15 +1623,23 @@ static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 		return;
 	} else if (bt_link_info->a2dp_only) {
 		/* A2DP */
-		if ((bt_rssi_state != BTC_RSSI_STATE_HIGH) &&
-		    (bt_rssi_state != BTC_RSSI_STATE_STAY_HIGH)) {
+		if (wifi_status == BT_8821A_1ANT_WIFI_STATUS_CONNECTED_IDLE) {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
+			coex_dm->auto_tdma_adjust = false;
+		} else if ((bt_rssi_state != BTC_RSSI_STATE_HIGH) &&
+			   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
+		} else {
 			/* for low BT RSSI */
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 11);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
 			coex_dm->auto_tdma_adjust = false;
 		}
-
-		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	} else if (bt_link_info->hid_exist && bt_link_info->a2dp_exist) {
 		/* HID+A2DP */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -1638,7 +1650,7 @@ static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 		} else {
 			/*for low BT RSSI*/
 			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 11);
+					     true, 14);
 			coex_dm->auto_tdma_adjust = false;
 		}
 
@@ -1647,13 +1659,13 @@ static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 		(bt_link_info->hid_exist && bt_link_info->pan_exist)) {
 		/* PAN(OPP, FTP), HID+PAN(OPP, FTP) */
 		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 6);
 		coex_dm->auto_tdma_adjust = false;
 	} else if (((bt_link_info->a2dp_exist) && (bt_link_info->pan_exist)) ||
 		   (bt_link_info->hid_exist && bt_link_info->a2dp_exist &&
 		    bt_link_info->pan_exist)) {
 		/* A2DP+PAN(OPP, FTP), HID+A2DP+PAN(OPP, FTP) */
-		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 43);
 		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 		coex_dm->auto_tdma_adjust = false;
 	} else {
-- 
2.12.2
