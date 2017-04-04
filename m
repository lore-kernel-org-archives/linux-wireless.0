Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34460 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932278AbdDDQud (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:33 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Stable <stable@vger.kernel.org>, Pkshih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 10/13] rtlwifi: btcoex: 23b 2ant: let bt transmit when hw initialisation done
Date: Tue,  4 Apr 2017 11:50:03 -0500
Message-Id: <20170404165006.14329-11-Larry.Finger@lwfinger.net> (sfid-20170404_185055_966649_F7945F48)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

During hw initialisation, wifi may be ready after bt has already been
ready, which causes bt to act abnormally. To avoid this, set GNT_BT to
high during hw init.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Stable <stable@vger.kernel.org>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 45 +++++++++++++++-------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 2cdcf82..31f8a59 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1083,12 +1083,7 @@ static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 		use_ext_switch = true;
 
 	if (init_hwcfg) {
-		/* 0x4c[23] = 0, 0x4c[24] = 1  Antenna control by WL/BT */
-		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
-		u32tmp &= ~BIT23;
-		u32tmp |= BIT24;
-		btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
-
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x39, 0x8, 0x1);
 		btcoexist->btc_write_1byte(btcoexist, 0x974, 0xff);
 		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x944, 0x3, 0x3);
 		btcoexist->btc_write_1byte(btcoexist, 0x930, 0x77);
@@ -1103,6 +1098,12 @@ static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 			btcoexist->btc_write_1byte(btcoexist, 0x765, 0x18);
 		}
 
+		btcoexist->btc_write_4byte(btcoexist, 0x948, 0x0);
+
+		/* WiFi TRx Mask off */
+		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A,
+					  0x1, 0xfffff, 0x0);
+
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
 			/* tell firmware "no antenna inverse" */
 			h2c_parameter[0] = 0;
@@ -1125,17 +1126,23 @@ static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 			h2c_parameter[0] = 0;
 			btcoexist->btc_fill_h2c(btcoexist, 0x6E, 1,
 						h2c_parameter);
-			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x280);
+		} else {
+			btcoexist->btc_write_1byte(btcoexist, 0x765, 0x0);
 		}
 	}
 
 	/* ext switch setting */
 	if (use_ext_switch) {
+		if (init_hwcfg) {
+			/* 0x4c[23] = 0, 0x4c[24] = 1 Ant controlled by WL/BT */
+			u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+			u32tmp &= ~BIT23;
+			u32tmp |= BIT24;
+			btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
+		}
+
 		/* fixed internal switch S1->WiFi, S0->BT */
-		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
-			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x0);
-		else
-			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x280);
+		btcoexist->btc_write_4byte(btcoexist, 0x948, 0x0);
 
 		switch (antpos_type) {
 		case BTC_ANT_WIFI_AT_MAIN:
@@ -1149,9 +1156,18 @@ static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 							   0x92c, 0x3, 0x2);
 			break;
 		}
-	} else {	/* internal switch */
-		/* fixed ext switch */
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x92c, 0x3, 0x1);
+	} else {
+		/* internal switch */
+		if (init_hwcfg) {
+			/* 0x4c[23] = 0, 0x4c[24] = 1 Ant controlled by WL/BT */
+			u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+			u32tmp |= BIT23;
+			u32tmp &= ~BIT24;
+			btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
+		}
+
+		/* fixed ext switch, S1->Main, S0->Aux */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64, 0x1, 0x0);
 		switch (antpos_type) {
 		case BTC_ANT_WIFI_AT_MAIN:
 			/* fixed internal switch S1->WiFi, S0->BT */
@@ -1458,6 +1474,7 @@ static void btc8723b2ant_coex_alloff(struct btc_coexist *btcoexist)
 static void btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	/* force to reset coex mechanism*/
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 	btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 
 	btc8723b2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
-- 
2.10.2
