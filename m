Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36302 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751841AbdDCSmA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 14:42:00 -0400
Received: by mail-oi0-f68.google.com with SMTP id b187so21137776oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 11:42:00 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v3 10/12] rtlwifi: btcoex: 23b 2ant: finer bt power adjustment
Date: Mon,  3 Apr 2017 13:41:40 -0500
Message-Id: <20170403184147.18409-10-Larry.Finger@lwfinger.net> (sfid-20170403_204222_581664_7277405E)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The bt can specify a power level to decrease. Rather than decreasing by a
fixed value (usually 2), this change makes the driver fit to the
environment more quickly.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - No changes.
v3 - No changes.
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 52 ++++++++++------------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  4 +-
 2 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index e72baa00b42f..b1a4c8466bc6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -660,44 +660,40 @@ static void btc8723b2ant_set_fw_dac_swing_level(struct btc_coexist *btcoexist,
 }
 
 static void btc8723b2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
-					   bool dec_bt_pwr)
+					   u8 dec_bt_pwr_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
-	h2c_parameter[0] = 0;
-
-	if (dec_bt_pwr)
-		h2c_parameter[0] |= BIT1;
+	h2c_parameter[0] = dec_bt_pwr_lvl;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], decrease Bt Power : %s, FW write 0x62=0x%x\n",
-		    (dec_bt_pwr ? "Yes!!" : "No!!"), h2c_parameter[0]);
+		 "[BTCoex], decrease Bt Power Level : %u\n", dec_bt_pwr_lvl);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
 }
 
 static void btc8723b2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
-				    bool force_exec, bool dec_bt_pwr)
+				    bool force_exec, u8 dec_bt_pwr_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s Dec BT power = %s\n",
-		    force_exec ? "force to" : "", dec_bt_pwr ? "ON" : "OFF");
-	coex_dm->cur_dec_bt_pwr = dec_bt_pwr;
+		 "[BTCoex], Dec BT power level = %u\n", dec_bt_pwr_lvl);
+	coex_dm->cur_dec_bt_pwr_lvl = dec_bt_pwr_lvl;
 
 	if (!force_exec) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], bPreDecBtPwr=%d, bCurDecBtPwr=%d\n",
-			    coex_dm->pre_dec_bt_pwr, coex_dm->cur_dec_bt_pwr);
+			 "[BTCoex], PreDecBtPwrLvl=%d, CurDecBtPwrLvl=%d\n",
+			    coex_dm->pre_dec_bt_pwr_lvl,
+			    coex_dm->cur_dec_bt_pwr_lvl);
 
-		if (coex_dm->pre_dec_bt_pwr == coex_dm->cur_dec_bt_pwr)
+		if (coex_dm->pre_dec_bt_pwr_lvl == coex_dm->cur_dec_bt_pwr_lvl)
 			return;
 	}
-	btc8723b2ant_set_fw_dec_bt_pwr(btcoexist, coex_dm->cur_dec_bt_pwr);
+	btc8723b2ant_set_fw_dec_bt_pwr(btcoexist, coex_dm->cur_dec_bt_pwr_lvl);
 
-	coex_dm->pre_dec_bt_pwr = coex_dm->cur_dec_bt_pwr;
+	coex_dm->pre_dec_bt_pwr_lvl = coex_dm->cur_dec_bt_pwr_lvl;
 }
 
 static void btc8723b2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
@@ -1340,7 +1336,7 @@ static void btc8723b2ant_coex_alloff(struct btc_coexist *btcoexist)
 	/* fw all off */
 	btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-	btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+	btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	/* sw all off */
 	btc8723b2ant_sw_mechanism(btcoexist, false, false, false, false);
@@ -1356,7 +1352,7 @@ static void btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
-	btc8723b2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, false);
+	btc8723b2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, 0);
 
 	btc8723b2ant_sw_mechanism(btcoexist, false, false, false, false);
 
@@ -1381,7 +1377,7 @@ static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 	}
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
-	btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+	btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btc8723b2ant_sw_mechanism(btcoexist, false, false, false, false);
 }
@@ -1413,7 +1409,7 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 		btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 		btc8723b2ant_sw_mechanism(btcoexist, false, false, false,
 					  false);
@@ -1439,8 +1435,7 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 			btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
 						      0xb);
-			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC,
-						false);
+			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 			btc8723b2ant_sw_mechanism(btcoexist, false, false,
 						  false, false);
@@ -1467,8 +1462,7 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 			btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
 						      0xb);
-			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC,
-						false);
+			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 			btc8723b2ant_sw_mechanism(btcoexist, true, false,
 						  false, false);
@@ -1988,7 +1982,7 @@ static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 	    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 	btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
@@ -2033,7 +2027,7 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 	if (BTC_RSSI_HIGH(bt_rssi_state))
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
@@ -2088,7 +2082,7 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 	if (BTC_RSSI_HIGH(bt_rssi_state))
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
@@ -2156,7 +2150,7 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 	if (BTC_RSSI_HIGH(bt_rssi_state))
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
@@ -2541,7 +2535,7 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 		 ps_tdma_case, coex_dm->auto_tdma_adjust);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d ",
-		 "DecBtPwr/ IgnWlanAct", coex_dm->cur_dec_bt_pwr,
+		 "DecBtPwr/ IgnWlanAct", coex_dm->cur_dec_bt_pwr_lvl,
 		 coex_dm->cur_ignore_wlan_act);
 
 	/* Hw setting */
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index e36ab4205771..746930d0d244 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -75,8 +75,8 @@ enum BT_8723B_2ANT_COEX_ALGO {
 
 struct coex_dm_8723b_2ant {
 	/* fw mechanism */
-	bool pre_dec_bt_pwr;
-	bool cur_dec_bt_pwr;
+	bool pre_dec_bt_pwr_lvl;
+	bool cur_dec_bt_pwr_lvl;
 	u8 pre_fw_dac_swing_lvl;
 	u8 cur_fw_dac_swing_lvl;
 	bool cur_ignore_wlan_act;
-- 
2.12.0
