Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20738 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbbKROKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 09:10:25 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/1] rtlwifi: btcoexist: re-use %*ph specifier to hexdump
Date: Wed, 18 Nov 2015 16:09:18 +0200
Message-Id: <1447855758-68099-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20151118_151029_940634_ECA4CE6E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of printing each byte from the given buffer the code is converted to
use %*ph specifier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 23 ++++++----------------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 21 ++++++--------------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 22 ++++++---------------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 23 ++++++----------------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 21 ++++++--------------
 5 files changed, 30 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 53261d6..4514568 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -3356,9 +3356,8 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 		   "Dot11 channel / HsMode(HsChnl)",
 		   wifi_dot11_chnl, bt_hson, wifi_hs_chnl);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %02x %02x %02x ",
-		   "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info[0],
-		   coex_dm->wifi_chnl_info[1], coex_dm->wifi_chnl_info[2]);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %3ph ",
+		   "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifirssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
@@ -3409,17 +3408,9 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 	for (i = 0; i < BT_INFO_SRC_8192E_2ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %02x %02x %02x %02x ",
+				   "\r\n %-35s = %7ph(%d)",
 				   GLBtInfoSrc8192e2Ant[i],
-				   coex_sta->bt_info_c2h[i][0],
-				   coex_sta->bt_info_c2h[i][1],
-				   coex_sta->bt_info_c2h[i][2],
-				   coex_sta->bt_info_c2h[i][3]);
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "%02x %02x %02x(%d)",
-				   coex_sta->bt_info_c2h[i][4],
-				   coex_sta->bt_info_c2h[i][5],
-				   coex_sta->bt_info_c2h[i][6],
+				   coex_sta->bt_info_c2h[i],
 				   coex_sta->bt_info_c2h_cnt[i]);
 		}
 	}
@@ -3453,10 +3444,8 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 
 	ps_tdma_case = coex_dm->cur_ps_tdma;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %02x %02x %02x %02x %02x case-%d (auto:%d)",
-		   "PS TDMA", coex_dm->ps_tdma_para[0],
-		   coex_dm->ps_tdma_para[1], coex_dm->ps_tdma_para[2],
-		   coex_dm->ps_tdma_para[3], coex_dm->ps_tdma_para[4],
+		   "\r\n %-35s = %5ph case-%d (auto:%d)",
+		   "PS TDMA", coex_dm->ps_tdma_para,
 		   ps_tdma_case, coex_dm->auto_tdma_adjust);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d ",
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index c4acd40..7e239d3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2457,10 +2457,9 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 		   "Dot11 channel / HsChnl(HsMode)",
 		   wifi_dot11_chnl, wifi_hs_chnl, bt_hs_on);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %02x %02x %02x ",
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %3ph ",
 		   "H2C Wifi inform bt chnl Info",
-		   coex_dm->wifi_chnl_info[0], coex_dm->wifi_chnl_info[1],
-		   coex_dm->wifi_chnl_info[2]);
+		   coex_dm->wifi_chnl_info);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
@@ -2525,15 +2524,9 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 	for (i = 0; i < BT_INFO_SRC_8723B_1ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %02x %02x %02x %02x %02x %02x %02x(%d)",
+				   "\r\n %-35s = %7ph(%d)",
 				   GLBtInfoSrc8723b1Ant[i],
-				   coex_sta->bt_info_c2h[i][0],
-				   coex_sta->bt_info_c2h[i][1],
-				   coex_sta->bt_info_c2h[i][2],
-				   coex_sta->bt_info_c2h[i][3],
-				   coex_sta->bt_info_c2h[i][4],
-				   coex_sta->bt_info_c2h[i][5],
-				   coex_sta->bt_info_c2h[i][6],
+				   coex_sta->bt_info_c2h[i],
 				   coex_sta->bt_info_c2h_cnt[i]);
 		}
 	}
@@ -2569,10 +2562,8 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 
 		pstdmacase = coex_dm->cur_ps_tdma;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %02x %02x %02x %02x %02x case-%d (auto:%d)",
-			   "PS TDMA", coex_dm->ps_tdma_para[0],
-			   coex_dm->ps_tdma_para[1], coex_dm->ps_tdma_para[2],
-			   coex_dm->ps_tdma_para[3], coex_dm->ps_tdma_para[4],
+			   "\r\n %-35s = %5ph case-%d (auto:%d)",
+			   "PS TDMA", coex_dm->ps_tdma_para,
 			   pstdmacase, coex_dm->auto_tdma_adjust);
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d ",
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index f2b9d11..c43ab59 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3215,9 +3215,8 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 		   "Dot11 channel / HsChnl(HsMode)",
 		   wifi_dot11_chnl, wifi_hs_chnl, bt_hs_on);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %02x %02x %02x ",
-		   "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info[0],
-		   coex_dm->wifi_chnl_info[1], coex_dm->wifi_chnl_info[2]);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %3ph ",
+		   "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
@@ -3259,16 +3258,9 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	for (i = 0; i < BT_INFO_SRC_8723B_2ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %02x %02x %02x "
-				   "%02x %02x %02x %02x(%d)",
+				   "\r\n %-35s = %7ph(%d)",
 				   glbt_info_src_8723b_2ant[i],
-				   coex_sta->bt_info_c2h[i][0],
-				   coex_sta->bt_info_c2h[i][1],
-				   coex_sta->bt_info_c2h[i][2],
-				   coex_sta->bt_info_c2h[i][3],
-				   coex_sta->bt_info_c2h[i][4],
-				   coex_sta->bt_info_c2h[i][5],
-				   coex_sta->bt_info_c2h[i][6],
+				   coex_sta->bt_info_c2h[i],
 				   coex_sta->bt_info_c2h_cnt[i]);
 		}
 	}
@@ -3296,10 +3288,8 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 
 	ps_tdma_case = coex_dm->cur_ps_tdma;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %02x %02x %02x %02x %02x case-%d (auto:%d)",
-		   "PS TDMA", coex_dm->ps_tdma_para[0],
-		   coex_dm->ps_tdma_para[1], coex_dm->ps_tdma_para[2],
-		   coex_dm->ps_tdma_para[3], coex_dm->ps_tdma_para[4],
+		   "\r\n %-35s = %5ph case-%d (auto:%d)",
+		   "PS TDMA", coex_dm->ps_tdma_para,
 		   ps_tdma_case, coex_dm->auto_tdma_adjust);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d ",
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index b72e537..9cecf17 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2302,10 +2302,9 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 		   wifi_dot11_chnl, wifi_hs_chnl, bt_hs_on);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %02x %02x %02x ",
+		   "\r\n %-35s = %3ph ",
 		   "H2C Wifi inform bt chnl Info",
-		   coex_dm->wifi_chnl_info[0], coex_dm->wifi_chnl_info[1],
-		   coex_dm->wifi_chnl_info[2]);
+		   coex_dm->wifi_chnl_info);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
@@ -2366,15 +2365,9 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 	for (i = 0; i < BT_INFO_SRC_8821A_1ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %02x %02x %02x %02x %02x %02x %02x(%d)",
+				   "\r\n %-35s = %7ph(%d)",
 				   glbt_info_src_8821a_1ant[i],
-				   coex_sta->bt_info_c2h[i][0],
-				   coex_sta->bt_info_c2h[i][1],
-				   coex_sta->bt_info_c2h[i][2],
-				   coex_sta->bt_info_c2h[i][3],
-				   coex_sta->bt_info_c2h[i][4],
-				   coex_sta->bt_info_c2h[i][5],
-				   coex_sta->bt_info_c2h[i][6],
+				   coex_sta->bt_info_c2h[i],
 				   coex_sta->bt_info_c2h_cnt[i]);
 		}
 	}
@@ -2412,13 +2405,9 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 
 		ps_tdma_case = coex_dm->cur_ps_tdma;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %02x %02x %02x %02x %02x case-%d (auto:%d)",
+			   "\r\n %-35s = %5ph case-%d (auto:%d)",
 			   "PS TDMA",
-			   coex_dm->ps_tdma_para[0],
-			   coex_dm->ps_tdma_para[1],
-			   coex_dm->ps_tdma_para[2],
-			   coex_dm->ps_tdma_para[3],
-			   coex_dm->ps_tdma_para[4],
+			   coex_dm->ps_tdma_para,
 			   ps_tdma_case,
 			   coex_dm->auto_tdma_adjust);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index cf819f0..044d914 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3393,10 +3393,9 @@ ex_halbtc8821a2ant_display_coex_info(
 		   wifi_dot_11_chnl, bt_hs_on, wifi_hs_chnl);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %02x %02x %02x ",
+		   "\r\n %-35s = %3ph ",
 		   "H2C Wifi inform bt chnl Info",
-		   coex_dm->wifi_chnl_info[0], coex_dm->wifi_chnl_info[1],
-		   coex_dm->wifi_chnl_info[2]);
+		   coex_dm->wifi_chnl_info);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
@@ -3454,15 +3453,9 @@ ex_halbtc8821a2ant_display_coex_info(
 	for (i = 0; i < BT_INFO_SRC_8821A_2ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %02x %02x %02x %02x %02x %02x %02x(%d)",
+				   "\r\n %-35s = %7ph(%d)",
 				   glbt_info_src_8821a_2ant[i],
-				   coex_sta->bt_info_c2h[i][0],
-				   coex_sta->bt_info_c2h[i][1],
-				   coex_sta->bt_info_c2h[i][2],
-				   coex_sta->bt_info_c2h[i][3],
-				   coex_sta->bt_info_c2h[i][4],
-				   coex_sta->bt_info_c2h[i][5],
-				   coex_sta->bt_info_c2h[i][6],
+				   coex_sta->bt_info_c2h[i],
 				   coex_sta->bt_info_c2h_cnt[i]);
 		}
 	}
@@ -3494,11 +3487,9 @@ ex_halbtc8821a2ant_display_coex_info(
 	if (!btcoexist->manual_control) {
 		ps_tdma_case = coex_dm->cur_ps_tdma;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %02x %02x %02x %02x %02x case-%d",
+			   "\r\n %-35s = %5ph case-%d",
 			   "PS TDMA",
-			   coex_dm->ps_tdma_para[0], coex_dm->ps_tdma_para[1],
-			   coex_dm->ps_tdma_para[2], coex_dm->ps_tdma_para[3],
-			   coex_dm->ps_tdma_para[4], ps_tdma_case);
+			   coex_dm->ps_tdma_para, ps_tdma_case);
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 			   "\r\n %-35s = %d/ %d ", "DecBtPwr/ IgnWlanAct",
-- 
2.6.2

