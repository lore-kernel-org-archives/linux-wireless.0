Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34269 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdDCBOm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Apr 2017 21:14:42 -0400
Received: by mail-oi0-f67.google.com with SMTP id s11so1229381oie.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Apr 2017 18:14:42 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 12/12] rtlwifi: btcoex: 23b 2ant: new fw use h2c to control GNT_BT
Date: Sun,  2 Apr 2017 20:14:22 -0500
Message-Id: <20170403011428.6156-12-Larry.Finger@lwfinger.net> (sfid-20170403_031446_947851_5E3DAD17)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Earlier versions of the FW did not support h2c to set GNT_BT, but later
versions have that capability. Hence we check the FW version and decide
whether to use h2c or just write to the register.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - No changes.
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 37 +++++++++++++++++-----
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index c349675d971a..3b3bdeb58da6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1065,8 +1065,14 @@ static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_1byte(btcoexist, 0x930, 0x77);
 		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x67, 0x20, 0x1);
 
-		/* Force GNT_BT to low */
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x0);
+		if (fw_ver >= 0x180000) {
+			/* Use H2C to set GNT_BT to High to avoid A2DP click */
+			h2c_parameter[0] = 1;
+			btcoexist->btc_fill_h2c(btcoexist, 0x6E, 1,
+						h2c_parameter);
+		} else {
+			btcoexist->btc_write_1byte(btcoexist, 0x765, 0x18);
+		}
 
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
 			/* tell firmware "no antenna inverse" */
@@ -1078,8 +1084,12 @@ static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 		} else {
 			/* tell firmware "antenna inverse" */
 			h2c_parameter[0] = 1;
-			h2c_parameter[1] = 1;  /* ext switch type */
-			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
+		}
+	} else {
+		if (fw_ver >= 0x180000) {
+			/* Use H2C to set GNT_BT to "Control by PTA"*/
+			h2c_parameter[0] = 0;
+			btcoexist->btc_fill_h2c(btcoexist, 0x6E, 1,
 						h2c_parameter);
 			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x280);
 		}
@@ -2370,12 +2380,23 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_wifioff_hwcfg(struct btc_coexist *btcoexist)
 {
+	u8 h2c_parameter[2] = {0};
+	u32 fw_ver = 0;
+
 	/* set wlan_act to low */
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
-	/* Force GNT_BT to High */
-	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x3);
-	/* BT select s0/s1 is controlled by BT */
-	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x67, 0x20, 0x0);
+
+	/* WiFi standby while GNT_BT 0 -> 1 */
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x780);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
+	if (fw_ver >= 0x180000) {
+		/* Use H2C to set GNT_BT to HIGH */
+		h2c_parameter[0] = 1;
+		btcoexist->btc_fill_h2c(btcoexist, 0x6E, 1, h2c_parameter);
+	} else {
+		btcoexist->btc_write_1byte(btcoexist, 0x765, 0x18);
+	}
 }
 
 /*********************************************************************
-- 
2.12.0
