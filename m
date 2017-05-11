Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34350 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934041AbdEKTB1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 15:01:27 -0400
Received: by mail-oi0-f65.google.com with SMTP id w10so5513073oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 12:01:27 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v3 01/10] rtlwifi: btcoex: 21a 2ant: set tdma with rssi states
Date: Thu, 11 May 2017 14:01:10 -0500
Message-Id: <20170511190119.23426-2-Larry.Finger@lwfinger.net> (sfid-20170511_210153_737027_02963961)
In-Reply-To: <20170511190119.23426-1-Larry.Finger@lwfinger.net>
References: <20170511190119.23426-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

if bt rssi is high, adjust the duration of wifi to a longer period to
let the wifi transmit under this bt profiling.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - resubmit after removal of BT_AUTO_REPORT_XXXX symbols.
v3 - no changes
---

 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 91 +++++++---------------
 1 file changed, 28 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 841b4a83ab70..a0f2eb53a011 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3220,12 +3220,16 @@ static void btc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 /* HID+A2DP+PAN(EDR) */
 static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state, bt_info_ext;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 
-	bt_info_ext = coex_sta->bt_info_ext;
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
-	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state1 = btc8821a2ant_wifi_rssi_state(btcoexist, 1, 2,
+				BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
+				2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
 	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
@@ -3235,44 +3239,32 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 	else
 		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	} else {
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 14);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
+	}
+
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
-		/* for HID at 11b/g mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5a5a5a5a, 0xffff, 0x3);
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		if (wifi_bw == BTC_WIFI_BW_HT40)
+			btc8821a2ant_tdma_duration_adjust(btcoexist, true,
+							  true, 3);
+		else
+			btc8821a2ant_tdma_duration_adjust(btcoexist, true,
+							  false, 3);
 	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5a5a5a5a, 0xffff, 0x3);
+		btc8821a2ant_tdma_duration_adjust(btcoexist, true, true, 3);
 	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							true, true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							true, true, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							true, true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							true, true, 3);
-			}
-		}
-
-		/* sw mechanism */
+	/* sw mechanism */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
@@ -3286,33 +3278,6 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 						   false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							true, false, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							true, false, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  3);
-			}
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
-- 
2.12.0
