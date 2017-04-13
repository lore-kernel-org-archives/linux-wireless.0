Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36644 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755302AbdDMSHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:20 -0400
Received: by mail-oi0-f68.google.com with SMTP id b187so13575914oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:20 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/19] rtlwifi: btcoex: 21a 2ant: finer adjustment of bt power
Date: Thu, 13 Apr 2017 13:06:56 -0500
Message-Id: <20170413180710.19953-6-Larry.Finger@lwfinger.net> (sfid-20170413_200801_808505_6B54514E)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Originally we only increase/decrease bt power in a fixed power gap, this
patch makes us be able to modify bt power for multiple power gaps and we
can precisely adjust the bt power.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 51 ++++++++++------------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  4 +-
 2 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index a9ce79d7f4b4..a074d480166d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -617,45 +617,42 @@ static void btc8821a2ant_set_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 }
 
 static void btc8821a2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
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
-		 "[BTCoex], decrease Bt Power : %s, FW write 0x62 = 0x%x\n",
-		 (dec_bt_pwr ? "Yes!!" : "No!!"), h2c_parameter[0]);
+		 "[BTCoex], decrease Bt Power Level : %u, FW write 0x62 = 0x%x\n",
+		 dec_bt_pwr_lvl, h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
 }
 
 static void btc8821a2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
-				    bool force_exec, bool dec_bt_pwr)
+				    bool force_exec, u8 dec_bt_pwr_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s Dec BT power = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((dec_bt_pwr) ? "ON" : "OFF"));
-	coex_dm->cur_dec_bt_pwr = dec_bt_pwr;
+		 "[BTCoex], %s Dec BT power level = %u\n",
+		    (force_exec ? "force to" : ""), dec_bt_pwr_lvl);
+	coex_dm->cur_dec_bt_pwr_lvl = dec_bt_pwr_lvl;
 
 	if (!force_exec) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], pre_dec_bt_pwr = %d, cur_dec_bt_pwr = %d\n",
-			    coex_dm->pre_dec_bt_pwr, coex_dm->cur_dec_bt_pwr);
+			 "[BTCoex], pre_dec_bt_pwr_lvl = %d, cur_dec_bt_pwr_lvl = %d\n",
+			    coex_dm->pre_dec_bt_pwr_lvl,
+			    coex_dm->cur_dec_bt_pwr_lvl);
 
-		if (coex_dm->pre_dec_bt_pwr == coex_dm->cur_dec_bt_pwr)
+		if (coex_dm->pre_dec_bt_pwr_lvl == coex_dm->cur_dec_bt_pwr_lvl)
 			return;
 	}
-	btc8821a2ant_set_fw_dec_bt_pwr(btcoexist, coex_dm->cur_dec_bt_pwr);
+	btc8821a2ant_set_fw_dec_bt_pwr(btcoexist, coex_dm->cur_dec_bt_pwr_lvl);
 
-	coex_dm->pre_dec_bt_pwr = coex_dm->cur_dec_bt_pwr;
+	coex_dm->pre_dec_bt_pwr_lvl = coex_dm->cur_dec_bt_pwr_lvl;
 }
 
 static void btc8821a2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
@@ -1149,7 +1146,7 @@ static void btc8821a2ant_coex_all_off(struct btc_coexist *btcoexist)
 	/* fw all off */
 	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-	btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+	btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	/* sw all off */
 	btc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
@@ -1173,7 +1170,7 @@ static void btc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 
 	btc8821a2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
-	btc8821a2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, false);
+	btc8821a2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, 0);
 
 	btc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
 	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
@@ -1263,7 +1260,7 @@ static bool btc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 
 		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 		btc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
 					   false);
@@ -1792,9 +1789,9 @@ static void btc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
@@ -2007,9 +2004,9 @@ static void btc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
@@ -2162,9 +2159,9 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
@@ -2608,7 +2605,7 @@ void ex_btc8821a2ant_display_coex_info(struct btc_coexist *btcoexist)
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 			 "\r\n %-35s = %d/ %d ", "DecBtPwr/ IgnWlanAct",
-			 coex_dm->cur_dec_bt_pwr,
+			 coex_dm->cur_dec_bt_pwr_lvl,
 			 coex_dm->cur_ignore_wlan_act);
 	}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index ce8e0d719e78..ee5aa188af55 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -69,8 +69,8 @@ enum _BT_8821A_2ANT_COEX_ALGO {
 
 struct coex_dm_8821a_2ant {
 	/* fw mechanism */
-	bool		pre_dec_bt_pwr;
-	bool		cur_dec_bt_pwr;
+	bool		pre_dec_bt_pwr_lvl;
+	bool		cur_dec_bt_pwr_lvl;
 	bool		pre_bt_lna_constrain;
 	bool		cur_bt_lna_constrain;
 	u8		pre_bt_psd_mode;
-- 
2.12.0
