Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33090 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932457AbdDQALk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:40 -0400
Received: by mail-oi0-f65.google.com with SMTP id a189so588035oib.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:40 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 25/27] rtlwifi: btcoex: 23b 1ant: fine tune for wifi not connected
Date: Sun, 16 Apr 2017 19:11:09 -0500
Message-Id: <20170417001111.29384-26-Larry.Finger@lwfinger.net> (sfid-20170417_021159_244115_252F2604)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Fine tune the parameters in cases of scan, assoc and auth when wifi isn't
connected.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 37 ++++++++++++++--------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index a338b72aed95..0431cb41e1d1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1887,7 +1887,9 @@ static void btc8723b1ant_action_wifi_not_conn(struct btc_coexist *btcoexist)
 					 0x0, 0x0);
 
 	/* tdma and coex table */
-	halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA, NORMAL_EXEC,
+				     false, false);
 	halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
@@ -1901,16 +1903,16 @@ btc8723b1ant_action_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 
 	/* tdma and coex table */
 	if (coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_BUSY) {
-		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
+		if (bt_link_info->a2dp_exist) {
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 22);
+						true, 32);
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
-							     NORMAL_EXEC, 1);
-		} else if (bt_link_info->pan_only) {
+							     NORMAL_EXEC, 4);
+		} else if (bt_link_info->a2dp_exist) {
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 20);
+						true, 22);
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
-							     NORMAL_EXEC, 2);
+							     NORMAL_EXEC, 4);
 		} else {
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 20);
@@ -1923,6 +1925,8 @@ btc8723b1ant_action_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 				BT_8723B_1ANT_WIFI_STATUS_CONNECTED_SCAN);
 	} else {
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+					     NORMAL_EXEC, false, false);
 		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	}
 }
@@ -1935,14 +1939,19 @@ btc8723b1ant_act_wifi_not_conn_asso_auth(struct btc_coexist *btcoexist)
 	halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 					 0x0, 0x0);
 
-	if ((BT_8723B_1ANT_BT_STATUS_CONNECTED_IDLE == coex_dm->bt_status) ||
-	    (bt_link_info->sco_exist) || (bt_link_info->hid_only) ||
-	    (bt_link_info->a2dp_only) || (bt_link_info->pan_only)) {
-		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
-		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
-	} else {
+	/* tdma and coex table */
+	if ((bt_link_info->sco_exist) || (bt_link_info->hid_exist) ||
+	    (bt_link_info->a2dp_exist)) {
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 4);
+	} else if (bt_link_info->pan_exist) {
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
-		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 4);
+	} else {
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+					     NORMAL_EXEC, false, false);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 2);
 	}
 }
 
-- 
2.12.0
