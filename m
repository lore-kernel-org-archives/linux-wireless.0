Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34971 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdDOUcH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:07 -0400
Received: by mail-oi0-f66.google.com with SMTP id a21so5610588oic.2
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:07 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 01/14] rtlwifi: btcoex: 21a 2ant: turn on sw dac swing and check if is sco_only
Date: Sat, 15 Apr 2017 15:31:47 -0500
Message-Id: <20170415203200.22979-2-Larry.Finger@lwfinger.net> (sfid-20170415_223221_828467_544805D2)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Use software dac swing and double check if it is sco_only to set the
tdma for voice quality.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 55 ++++++++++------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 0ef83727fdf4..7b5dbc62906e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -2634,13 +2634,15 @@ static void btc8821a2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 /* SCO only or SCO+PAN(HS)*/
 static void btc8821a2ant_action_sco(struct btc_coexist *btcoexist)
 {
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	u8 wifi_rssi_state, bt_rssi_state;
 	u32 wifi_bw;
 
-	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-						       15, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+
 	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 4);
 
@@ -2656,58 +2658,49 @@ static void btc8821a2ant_action_sco(struct btc_coexist *btcoexist)
 		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	} else {
 		/* for SCO quality & wifi performance balance at 11n mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
-					0x5aea5aea, 0x5aea5aea, 0xffff, 0x3);
-	}
-
-	if (wifi_bw == BTC_WIFI_BW_HT40) {
-
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			/* for voice quality */
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     false, 0);
+		if (wifi_bw == BTC_WIFI_BW_HT40) {
+			btc8821a2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 8);
 		} else {
-			/* for voice quality */
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     false, 0);
+			if (bt_link_info->sco_only)
+				btc8821a2ant_coex_table_with_type(
+					btcoexist, NORMAL_EXEC, 17);
+			else
+				btc8821a2ant_coex_table_with_type(
+					btcoexist, NORMAL_EXEC, 12);
 		}
+	}
 
-		/* sw mechanism */
+	btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	/* for voice quality */
+	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
+
+	/* sw mechanism */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
 			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
+						   true, 0x18);
 		} else {
 			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
 						   false, false);
 			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
+						   true, 0x18);
 		}
 	} else {
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			/* for voice quality */
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
-		} else {
-			/* for voice quality */
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
 			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
-						   false, 0x18);
+						   true, 0x18);
 		} else {
 			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
 						   false, false);
 			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
-						   false, 0x18);
+						   true, 0x18);
 		}
 	}
 }
-- 
2.12.0
