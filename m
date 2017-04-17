Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36072 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932428AbdDQALf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:35 -0400
Received: by mail-oi0-f67.google.com with SMTP id b187so25356769oif.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:35 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 20/27] rtlwifi: btcoex: 23b 1ant: check more cases when bt is queing
Date: Sun, 16 Apr 2017 19:11:04 -0500
Message-Id: <20170417001111.29384-21-Larry.Finger@lwfinger.net> (sfid-20170417_021157_497228_C42F0BA8)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

If bt is queing, we need to set the packet priority properly.
Originally we only consider if wifi was connected or not, but now we
also consider if bt is under abnormal scan or wifi is scanning, roaming
or linking, and set the coex table.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 57 +++++++++++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  1 +
 2 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 5377f55b162a..b3e043e8fec3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1705,35 +1705,56 @@ static void halbtc8723b1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false, ap_enable = false;
+	bool wifi_busy = false, bt_busy = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
 			   &ap_enable);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
 
-	if (!wifi_connected) {
-		halbtc8723b1ant_power_save_state(btcoexist,
-						 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	if (coex_sta->bt_abnormal_scan) {
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 33);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+	} else if (!wifi_connected && !coex_sta->wifi_is_high_pri_task) {
+		halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
-		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
-	} else if (bt_link_info->sco_exist || bt_link_info->hid_only) {
-		/* SCO/HID-only busy */
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+					     NORMAL_EXEC, false, false);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+	} else if (bt_link_info->sco_exist || bt_link_info->hid_exist ||
+		   bt_link_info->a2dp_exist) {
+		/* SCO/HID/A2DP busy */
 		halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 						 0x0, 0x0);
-		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
-		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
-	} else {
-		if (ap_enable)
-			halbtc8723b1ant_power_save_state(btcoexist,
-							 BTC_PS_WIFI_NATIVE,
-							 0x0, 0x0);
+		if (coex_sta->c2h_bt_remote_name_req)
+			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						33);
 		else
-			halbtc8723b1ant_power_save_state(btcoexist,
-							 BTC_PS_LPS_ON,
-							 0x50, 0x4);
+			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						32);
 
-		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 30);
-		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	} else if (bt_link_info->pan_exist || wifi_busy) {
+		halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+		if (coex_sta->c2h_bt_remote_name_req)
+			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						33);
+		else
+			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						32);
+
+		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	} else {
+		halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+					     NORMAL_EXEC, false, false);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index beeed22aa3dc..fca78bc7a945 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -150,6 +150,7 @@ struct coex_sta_8723b_1ant {
 	bool pan_exist;
 	bool bt_hi_pri_link_exist;
 	u8 num_of_profile;
+	bool bt_abnormal_scan;
 
 	bool under_lps;
 	bool under_ips;
-- 
2.12.0
