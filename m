Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35735 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdDCBOi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Apr 2017 21:14:38 -0400
Received: by mail-oi0-f68.google.com with SMTP id d2so10059553oig.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Apr 2017 18:14:37 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 07/12] rtlwifi: btcoex: 23b 2ant: adjust wifi duration for bt a2dp
Date: Sun,  2 Apr 2017 20:14:17 -0500
Message-Id: <20170403011428.6156-7-Larry.Finger@lwfinger.net> (sfid-20170403_031459_999776_2BE48C45)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The larger the bt a2dp bit pool is, the more time bt needs to receive
them. If we do not adjust the wifi duration, the voice quality will be
low. Hence we reduce the time that wifi holds, to improve the a2dp
service.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - No changes.
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 72 +++++++++++++++++++---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  3 +
 2 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index ebf989fa3a16..65497abcf719 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1134,6 +1134,7 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	s8 wifi_duration_adjust = 0x0;
 	u8 tdma_byte4_modify = 0x0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -1156,6 +1157,36 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 			return;
 	}
 
+	if (coex_sta->scan_ap_num <= 5) {
+		if (coex_sta->a2dp_bit_pool >= 45)
+			wifi_duration_adjust = -15;
+		else if (coex_sta->a2dp_bit_pool >= 35)
+			wifi_duration_adjust = -10;
+		else
+			wifi_duration_adjust = 5;
+	} else if (coex_sta->scan_ap_num <= 20) {
+		if (coex_sta->a2dp_bit_pool >= 45)
+			wifi_duration_adjust = -15;
+		else if (coex_sta->a2dp_bit_pool >= 35)
+			wifi_duration_adjust = -10;
+		else
+			wifi_duration_adjust = 0;
+	} else if (coex_sta->scan_ap_num <= 40) {
+		if (coex_sta->a2dp_bit_pool >= 45)
+			wifi_duration_adjust = -15;
+		else if (coex_sta->a2dp_bit_pool >= 35)
+			wifi_duration_adjust = -10;
+		else
+			wifi_duration_adjust = -5;
+	} else {
+		if (coex_sta->a2dp_bit_pool >= 45)
+			wifi_duration_adjust = -15;
+		else if (coex_sta->a2dp_bit_pool >= 35)
+			wifi_duration_adjust = -10;
+		else
+			wifi_duration_adjust = -10;
+	}
+
 	if ((bt_link_info->slave_role) && (bt_link_info->a2dp_exist))
 		/* 0x778 = 0x1 at wifi slot (no blocking BT Low-Pri pkts) */
 		tdma_byte4_modify = 0x1;
@@ -1204,8 +1235,9 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 						    0x90 | tdma_byte4_modify);
 			break;
 		case 9:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe1, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xe3, 0x3c + wifi_duration_adjust,
+				0x03, 0xf1, 0x90 | tdma_byte4_modify);
 			break;
 		case 10:
 			btc8723b2ant_set_fw_ps_tdma(
@@ -1247,8 +1279,8 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 						    0x2f, 0x60, 0x90);
 			break;
 		case 18:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
-						    0x5, 0xe1, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5, 0x5,
+						    0xe1, 0x90);
 			break;
 		case 19:
 			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x25,
@@ -1263,8 +1295,25 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 						    0x03, 0x70, 0x90);
 			break;
 		case 71:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe1, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xe3, 0x3c + wifi_duration_adjust,
+				0x03, 0xf1, 0x90);
+			break;
+		case 101:
+		case 105:
+		case 113:
+		case 171:
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xd3, 0x3a + wifi_duration_adjust,
+				0x03, 0x70, 0x50 | tdma_byte4_modify);
+			break;
+		case 102:
+		case 106:
+		case 110:
+		case 114:
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xd3, 0x2d + wifi_duration_adjust,
+				0x03, 0x70, 0x50 | tdma_byte4_modify);
 			break;
 		}
 	} else {
@@ -1733,7 +1782,6 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 		/* for HID quality & wifi performance balance at 11n mode */
 		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 9);
 
-
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
@@ -2448,7 +2496,6 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 		 ((wifi_traffic_dir == BTC_WIFI_TRAFFIC_TX) ?
 		  "uplink" : "downlink")));
 
-
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d / %d / %d / %d",
 		 "SCO/HID/PAN/A2DP",
 		 bt_link_info->sco_exist, bt_link_info->hid_exist,
@@ -2636,6 +2683,8 @@ void ex_btc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	else if (BTC_SCAN_FINISH == type)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], SCAN FINISH notify\n");
+		btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM,
+				   &coex_sta->scan_ap_num);
 }
 
 void ex_btc8723b2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
@@ -2746,8 +2795,11 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->bt_rssi =
 			coex_sta->bt_info_c2h[rsp_source][3] * 2 + 10;
 
-		coex_sta->bt_info_ext =
-			coex_sta->bt_info_c2h[rsp_source][4];
+		if (coex_sta->bt_info_c2h[rsp_source][1] == 0x49)
+			coex_sta->a2dp_bit_pool =
+				coex_sta->bt_info_c2h[rsp_source][6];
+		else
+			coex_sta->a2dp_bit_pool = 0;
 
 		/* Here we need to resend some wifi info to BT
 		 * because BT is reset and loss of the info.
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index d1bfdbec82b0..e36ab4205771 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -149,6 +149,7 @@ struct coex_sta_8723b_2ant {
 	u8 bt_retry_cnt;
 	u8 bt_info_ext;
 	u32 pop_event_cnt;
+	u8 scan_ap_num;
 
 	u32 crc_ok_cck;
 	u32 crc_ok_11g;
@@ -159,6 +160,8 @@ struct coex_sta_8723b_2ant {
 	u32 crc_err_11g;
 	u32 crc_err_11n;
 	u32 crc_err_11n_agg;
+
+	u8 a2dp_bit_pool;
 };
 
 /*********************************************************************
-- 
2.12.0
