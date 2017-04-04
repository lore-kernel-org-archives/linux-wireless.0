Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33726 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932072AbdDDQuW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:22 -0400
Received: by mail-oi0-f65.google.com with SMTP id f193so25703306oib.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/13] rtlwifi: btcoex: 23b 2ant: check PS state before setting tdma duration
Date: Tue,  4 Apr 2017 11:49:54 -0500
Message-Id: <20170404165006.14329-2-Larry.Finger@lwfinger.net> (sfid-20170404_185025_895378_13456068)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For time division multiple access, the wifi and bt take turns to
transmit, but we need to let AP know that wifi is under standby mode by
sending null data to "pretend" entering power saving state using lps
rpwm.

But, the fw does not know if it is the actual power saving mode or just a
fake one to cheat to the AP. Hence, before fw setting the tdma duration,
the fw needs the driver to check the power saving state first.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 95 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  6 ++
 2 files changed, 101 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 3b3bdeb..6f00b7e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -978,6 +978,33 @@ static void btc8723b2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
 }
 
+static void btc8723b2ant_set_lps_rpwm(struct btc_coexist *btcoexist,
+				      u8 lps_val, u8 rpwm_val)
+{
+	u8 lps = lps_val;
+	u8 rpwm = rpwm_val;
+
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_LPS_VAL, &lps);
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_RPWM_VAL, &rpwm);
+}
+
+static void btc8723b2ant_lps_rpwm(struct btc_coexist *btcoexist,
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
+	btc8723b2ant_set_lps_rpwm(btcoexist, lps_val, rpwm_val);
+
+	coex_dm->pre_lps = coex_dm->cur_lps;
+	coex_dm->pre_rpwm = coex_dm->cur_rpwm;
+}
+
 static void btc8723b2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 					 bool force_exec, bool enable)
 {
@@ -1341,9 +1368,74 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
+static void btc8723b2ant_ps_tdma_check_for_power_save_state(
+		struct btc_coexist *btcoexist, bool new_ps_state)
+{
+	u8 lps_mode = 0x0;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_LPS_MODE, &lps_mode);
+
+	if (lps_mode) {
+		/* already under LPS state */
+		if (new_ps_state) {
+			/* keep state under LPS, do nothing. */
+		} else {
+			/* will leave LPS state, turn off psTdma first */
+			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		}
+	} else {
+		/* NO PS state */
+		if (new_ps_state) {
+			/* will enter LPS state, turn off psTdma first */
+			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		} else {
+			/* keep state under NO PS state, do nothing. */
+		}
+	}
+}
+
+static void btc8723b2ant_power_save_state(struct btc_coexist *btcoexist,
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
+		btc8723b2ant_ps_tdma_check_for_power_save_state(btcoexist,
+								true);
+		btc8723b2ant_lps_rpwm(btcoexist, NORMAL_EXEC, lps_val,
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
+		btc8723b2ant_ps_tdma_check_for_power_save_state(btcoexist,
+								false);
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS, NULL);
+		coex_sta->force_lps_on = false;
+		break;
+	default:
+		break;
+	}
+}
+
 static void btc8723b2ant_coex_alloff(struct btc_coexist *btcoexist)
 {
 	/* fw all off */
+	btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 	btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 	btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
@@ -1359,6 +1451,7 @@ static void btc8723b2ant_coex_alloff(struct btc_coexist *btcoexist)
 static void btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	/* force to reset coex mechanism*/
+	btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 
 	btc8723b2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
@@ -1801,6 +1894,8 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 		/* for HID quality & wifi performance balance at 11n mode */
 		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 9);
 
+	btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 746930d..5bcaece 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -122,6 +122,11 @@ struct coex_dm_8723b_2ant {
 	u8 bt_status;
 	u8 wifi_chnl_info[3];
 
+	u8 pre_lps;
+	u8 cur_lps;
+	u8 pre_rpwm;
+	u8 cur_rpwm;
+
 	bool need_recover_0x948;
 	u16 backup_0x948;
 };
@@ -160,6 +165,7 @@ struct coex_sta_8723b_2ant {
 	u32 crc_err_11g;
 	u32 crc_err_11n;
 	u32 crc_err_11n_agg;
+	bool force_lps_on;
 
 	u8 a2dp_bit_pool;
 };
-- 
2.10.2
