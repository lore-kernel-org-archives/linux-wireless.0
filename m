Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32913 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752596AbdEPNUH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 09:20:07 -0400
Received: by mail-oi0-f67.google.com with SMTP id h4so3309909oib.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 06:20:07 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/10] rtlwifi: btcoex: 23b 1ant: TDMA duration for ACL busy
Date: Tue, 16 May 2017 08:19:53 -0500
Message-Id: <20170516131957.9513-7-Larry.Finger@lwfinger.net> (sfid-20170516_152033_705423_A8500736)
In-Reply-To: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
References: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

BT ACL is a special case, so we create a routine to deal this case.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 54 +++++++++++++---------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 2e1ba8fed982..523e1acfe1cf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1124,6 +1124,11 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 		/* acquire the BT TRx retry count from BT_Info byte2 */
 		retry_count = coex_sta->bt_retry_cnt;
 		bt_info_ext = coex_sta->bt_info_ext;
+
+		if ((coex_sta->low_priority_tx) > 1050 ||
+		    (coex_sta->low_priority_rx) > 1250)
+			retry_count++;
+
 		result = 0;
 		wait_count++;
 		/* no retry in the last 2-second duration */
@@ -1135,6 +1140,9 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 				dn = 0;
 
 			if (up >= n) {
+				/* if retry count during continuous n*2 seconds
+				 * is 0, enlarge WiFi duration
+				 */
 				wait_count = 0;
 				n = 3;
 				up = 0;
@@ -1144,6 +1152,7 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 					 "[BTCoex], Increase wifi duration!!\n");
 			}
 		} else if (retry_count <= 3) {
+			/* <=3 retry in the last 2-second duration */
 			up--;
 			dn++;
 
@@ -1151,12 +1160,20 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 				up = 0;
 
 			if (dn == 2) {
+				/* if continuous 2 retry count(every 2 seconds)
+				 * >0 and < 3, reduce WiFi duration
+				 */
 				if (wait_count <= 2)
+					/* avoid loop between the two levels */
 					m++;
 				else
 					m = 1;
 
 				if (m >= 20)
+					/* maximum of m = 20 ' will recheck if
+					 * need to adjust wifi duration in
+					 * maximum time interval 120 seconds
+					 */
 					m = 20;
 
 				n = 3 * m;
@@ -1168,12 +1185,20 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 					 "[BTCoex], Decrease wifi duration for retryCounter<3!!\n");
 			}
 		} else {
+			/* retry count > 3, once retry count > 3, to reduce
+			 * WiFi duration
+			 */
 			if (wait_count == 1)
+				/* to avoid loop between the two levels */
 				m++;
 			else
 				m = 1;
 
 			if (m >= 20)
+				/* maximum of m = 20 ' will recheck if need to
+				 * adjust wifi duration in maximum time interval
+				 * 120 seconds
+				 */
 				m = 20;
 
 			n = 3 * m;
@@ -1186,13 +1211,7 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 		}
 
 		if (result == -1) {
-			if ((BT_INFO_8723B_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
-			    ((coex_dm->cur_ps_tdma == 1) ||
-			     (coex_dm->cur_ps_tdma == 2))) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->ps_tdma_du_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 1) {
+			if (coex_dm->cur_ps_tdma == 1) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 2);
 				coex_dm->ps_tdma_du_adj_type = 2;
@@ -1206,13 +1225,7 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 				coex_dm->ps_tdma_du_adj_type = 11;
 			}
 		} else if (result == 1) {
-			if ((BT_INFO_8723B_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
-			    ((coex_dm->cur_ps_tdma == 1) ||
-			     (coex_dm->cur_ps_tdma == 2))) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->ps_tdma_du_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 11) {
+			if (coex_dm->cur_ps_tdma == 11) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 9);
 				coex_dm->ps_tdma_du_adj_type = 9;
@@ -1225,11 +1238,6 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 							true, 1);
 				coex_dm->ps_tdma_du_adj_type = 1;
 			}
-		} else {
-			/* if busy / idle change */
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex],********* TDMA(on, %d) ********\n",
-				 coex_dm->cur_ps_tdma);
 		}
 
 		if (coex_dm->cur_ps_tdma != 1 && coex_dm->cur_ps_tdma != 2 &&
@@ -1448,12 +1456,12 @@ static void halbtc8723b1ant_action_wifi_connected_bt_acl_busy(
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 2);
 			coex_dm->auto_tdma_adjust = false;
-		} else { /* for low BT RSSI */
-			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
+		} else {
+			btc8723b1ant_tdma_dur_adj_for_acl(btcoexist,
+							  wifi_status);
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 1);
-			coex_dm->auto_tdma_adjust = false;
+			coex_dm->auto_tdma_adjust = true;
 		}
 	} else if (bt_link_info->hid_exist &&
 		bt_link_info->a2dp_exist) { /* HID + A2DP */
-- 
2.12.0
