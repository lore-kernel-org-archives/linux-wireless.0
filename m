Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34495 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756635AbdEKXZC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 19:25:02 -0400
Received: by mail-oi0-f65.google.com with SMTP id w10so6440859oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 16:25:02 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/10] rtlwifi: btcoex: 21a 1ant: coex table and tdma settings for softap mode
Date: Thu, 11 May 2017 18:24:33 -0500
Message-Id: <20170511232438.23159-6-Larry.Finger@lwfinger.net> (sfid-20170512_012516_252782_3959C956)
In-Reply-To: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
References: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Monitor if the wifi is softap mode, and set the tdma and coex table
accordingly.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 25 +++++++++++++++-------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index f5a4640577c2..6a434334a418 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1782,6 +1782,7 @@ static void btc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 	bool wifi_busy = false;
 	bool scan = false, link = false, roam = false;
 	bool under_4way = false;
+	bool ap_enable = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], CoexForWifiConnect()===>\n");
@@ -1810,17 +1811,26 @@ static void btc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 	}
 
 	/* power save state*/
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
+			   &ap_enable);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
 	if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY ==
-			coex_dm->bt_status && !btcoexist->bt_link_info.hid_only)
-		btc8821a1ant_power_save_state(btcoexist,
-					      BTC_PS_LPS_ON, 0x50, 0x4);
-	else
+	    coex_dm->bt_status && !ap_enable &&
+	    !btcoexist->bt_link_info.hid_only) {
+		if (!wifi_busy && btcoexist->bt_link_info.a2dp_only)
+			/* A2DP */
+			btc8821a1ant_power_save_state(btcoexist,
+						BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+		else
+			btc8821a1ant_power_save_state(btcoexist, BTC_PS_LPS_ON,
+						      0x50, 0x4);
+	} else {
 		btc8821a1ant_power_save_state(btcoexist,
 					      BTC_PS_WIFI_NATIVE,
 					      0x0, 0x0);
+	}
 
 	/* tdma and coex table */
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
 	if (!wifi_busy) {
 		if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
 			btc8821a1ant_act_wifi_con_bt_acl_busy(btcoexist,
@@ -1832,8 +1842,7 @@ static void btc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 			btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
 				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_IDLE);
 		} else {
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 5);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
 			btc8821a1ant_coex_table_with_type(btcoexist,
 							  NORMAL_EXEC, 2);
 		}
@@ -1848,7 +1857,7 @@ static void btc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 			btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
 				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_BUSY);
 		} else {
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
 			btc8821a1ant_coex_table_with_type(btcoexist,
 							  NORMAL_EXEC, 2);
 		}
-- 
2.12.2
