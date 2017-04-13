Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36704 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755322AbdDMSHX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:23 -0400
Received: by mail-oi0-f68.google.com with SMTP id b187so13576290oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:23 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/19] rtlwifi: btcoex: 21a 2ant: check power save state before pstdma
Date: Thu, 13 Apr 2017 13:06:59 -0500
Message-Id: <20170413180710.19953-9-Larry.Finger@lwfinger.net> (sfid-20170413_200923_475612_6403BC27)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The power_save_state function checks the state of power saving.
For tdma settings, the wifi sends nullfunc to pretend enter power saving
and then bt can transmit. Hence the coex needs to check the power status
before set the pstdma function.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 119 +++++++++++++++++----
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   5 +
 2 files changed, 104 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 1a1e4136d48e..36e722a33f0f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -872,6 +872,33 @@ static void btc8821a2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoex,
 	btcoex->btc_fill_h2c(btcoex, 0x63, 1, h2c_parameter);
 }
 
+static void btc8821a2ant_set_lps_rpwm(struct btc_coexist *btcoexist, u8 lps_val,
+				      u8 rpwm_val)
+{
+	u8 lps = lps_val;
+	u8 rpwm = rpwm_val;
+
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_LPS_VAL, &lps);
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_RPWM_VAL, &rpwm);
+}
+
+static void btc8821a2ant_lps_rpwm(struct btc_coexist *btcoexist,
+				  bool force_exec, u8 lps_val, u8 rpwm_val)
+{
+	coex_dm->cur_lps = lps_val;
+	coex_dm->cur_rpwm = rpwm_val;
+
+	if (!force_exec) {
+		if ((coex_dm->pre_lps == coex_dm->cur_lps) &&
+		    (coex_dm->pre_rpwm == coex_dm->cur_rpwm))
+			return;
+	}
+	btc8821a2ant_set_lps_rpwm(btcoexist, lps_val, rpwm_val);
+
+	coex_dm->pre_lps = coex_dm->cur_lps;
+	coex_dm->pre_rpwm = coex_dm->cur_rpwm;
+}
+
 static void btc8821a2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 					 bool force_exec, bool enable)
 {
@@ -1139,9 +1166,75 @@ static void btc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
+static void
+btc8821a2ant_ps_tdma_check_for_power_save_state(struct btc_coexist *btcoexist,
+						bool new_ps_state)
+{
+	u8 lps_mode = 0x0;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_LPS_MODE, &lps_mode);
+
+	if (lps_mode) {
+		/* already under LPS state */
+		if (new_ps_state) {
+			/* keep state under LPS, do nothing */
+		} else {
+			/* will leave LPS state, turn off psTdma first */
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		}
+	} else {
+		/* NO PS state */
+		if (new_ps_state) {
+			/* will enter LPS state, turn off psTdma first */
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		} else {
+			/* keep state under NO PS state, do nothing */
+		}
+	}
+}
+
+static void btc8821a2ant_power_save_state(struct btc_coexist *btcoexist,
+					  u8 ps_type, u8 lps_val, u8 rpwm_val)
+{
+	bool low_pwr_disable = false;
+
+	switch (ps_type) {
+	case BTC_PS_WIFI_NATIVE:
+		/* recover to original 32k low power setting */
+		low_pwr_disable = false;
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
+				   &low_pwr_disable);
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_NORMAL_LPS, NULL);
+		coex_sta->force_lps_on = false;
+		break;
+	case BTC_PS_LPS_ON:
+		btc8821a2ant_ps_tdma_check_for_power_save_state(btcoexist,
+								true);
+		btc8821a2ant_lps_rpwm(btcoexist, NORMAL_EXEC, lps_val,
+				      rpwm_val);
+		/* when coex force to enter LPS, do not enter 32k low power */
+		low_pwr_disable = true;
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
+				   &low_pwr_disable);
+		/* power save must executed before psTdma */
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_ENTER_LPS, NULL);
+		coex_sta->force_lps_on = true;
+		break;
+	case BTC_PS_LPS_OFF:
+		btc8821a2ant_ps_tdma_check_for_power_save_state(btcoexist,
+								false);
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS, NULL);
+		coex_sta->force_lps_on = false;
+		break;
+	default:
+		break;
+	}
+}
+
 static void btc8821a2ant_coex_all_off(struct btc_coexist *btcoexist)
 {
 	/* fw all off */
+	btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 	btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
@@ -1166,6 +1259,7 @@ static void btc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 	btc8821a2ant_coex_table(btcoexist, FORCE_EXEC, 0x55555555,
 				0x55555555, 0xffff, 0x3);
 
+	btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 	btc8821a2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
 	btc8821a2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, 0);
@@ -1300,6 +1394,8 @@ static bool btc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi IPS + BT Busy!!\n");
 
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
 		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
@@ -1658,17 +1754,10 @@ static void btc8821a2ant_action_hid(struct btc_coexist *btcoexist)
 					0x5aea5aea, 0xffff, 0x3);
 	}
 
-	if (wifi_bw == BTC_WIFI_BW_HT40) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 9);
-		} else {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 13);
-		}
+	btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 24);
 
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
@@ -1683,16 +1772,6 @@ static void btc8821a2ant_action_hid(struct btc_coexist *btcoexist)
 						   false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 9);
-		} else {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 13);
-		}
-
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index ee5aa188af55..804b5b95cab0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -118,6 +118,10 @@ struct coex_dm_8821a_2ant {
 	u8		cur_algorithm;
 	u8		bt_status;
 	u8		wifi_chnl_info[3];
+	u8		pre_lps;
+	u8		cur_lps;
+	u8		pre_rpwm;
+	u8		cur_rpwm;
 };
 
 struct coex_sta_8821a_2ant {
@@ -151,6 +155,7 @@ struct coex_sta_8821a_2ant {
 	u32	crc_err_11g;
 	u32	crc_err_11n;
 	u32	crc_err_11n_agg;
+	bool	force_lps_on;
 };
 
 /*===========================================
-- 
2.12.0
