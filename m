Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34567 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755302AbdDMSH2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:28 -0400
Received: by mail-oi0-f67.google.com with SMTP id t14so4185428oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:28 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 13/19] rtlwifi: btcoex: 21a 2ant: set coex table and tdma when bt inquiry
Date: Thu, 13 Apr 2017 13:07:04 -0500
Message-Id: <20170413180710.19953-14-Larry.Finger@lwfinger.net> (sfid-20170413_200922_925115_CF6EB57B)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Instead of just setting the coex table directly, we check if the
wifi is under some important activity (scanning|roaming|linking) and
mark the packets as high priority in that case.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 51 +++++++++++++++++++---
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index bb609f078a01..7b2fb62947da 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1381,16 +1381,54 @@ static void btc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
-static void btc8821a2ant_bt_inquiry_page(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	bool wifi_connected = false;
 	bool low_pwr_disable = true;
+	bool scan = false, link = false, roam = false;
+
+	wifi_rssi_state =
+		btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8821a2ant_wifi_rssi_state(btcoexist, 1, 2,
+				BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 			   &low_pwr_disable);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
 
-	btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				0x5afa5afa, 0xffff, 0x3);
-	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
+
+	btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+
+	if (scan || link || roam) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi link process + BT Inq/Page!!\n");
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 15);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+	} else if (wifi_connected) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi connected + BT Inq/Page!!\n");
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 15);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi no-link + BT Inq/Page!!\n");
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+	}
+
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
+	btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	btc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
 static bool btc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
@@ -1779,8 +1817,7 @@ static void btc8821a2ant_action_sco(struct btc_coexist *btcoexist)
 
 	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
 		/* for SCO quality at 11b/g mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
-					0x5a5a5a5a, 0x5a5a5a5a, 0xffff, 0x3);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	} else {
 		/* for SCO quality & wifi performance balance at 11n mode */
 		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
@@ -2511,7 +2548,7 @@ static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	    (BT_8821A_2ANT_COEX_ALGO_PANHS != algorithm)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BT is under inquiry/page scan !!\n");
-		btc8821a2ant_bt_inquiry_page(btcoexist);
+		btc8821a2ant_action_bt_inquiry(btcoexist);
 		return;
 	}
 
-- 
2.12.0
