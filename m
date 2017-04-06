Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36298 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754828AbdDFUUK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:10 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so8910278oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/11] rtlwifi: btcoex: 23b 2ant: power on settings for coex
Date: Thu,  6 Apr 2017 15:19:53 -0500
Message-Id: <20170406201958.25642-7-Larry.Finger@lwfinger.net> (sfid-20170406_222057_464074_54FBF2BB)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When power on, the wifi could be initiating, force the antenna to
transmit bt packets to avoid bt unstable problems

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 31 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  1 +
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 70f21059ddc3..0f3d04529ff2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3669,6 +3669,37 @@ void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
 }
 
+void ex_btc8723b2ant_power_on_setting(struct btc_coexist *btcoexist)
+{
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	u16 u16tmp = 0x0;
+	u32 value = 0;
+
+	btcoexist->btc_write_1byte(btcoexist, 0x67, 0x20);
+
+	/* enable BB, REG_SYS_FUNC_EN such that we can write 0x948 correctly */
+	u16tmp = btcoexist->btc_read_2byte(btcoexist, 0x2);
+	btcoexist->btc_write_2byte(btcoexist, 0x2, u16tmp | BIT0 | BIT1);
+
+	btcoexist->btc_write_4byte(btcoexist, 0x948, 0x0);
+
+	if (btcoexist->chip_interface == BTC_INTF_USB) {
+		/* fixed at S0 for USB interface */
+		board_info->btdm_ant_pos = BTC_ANTENNA_AT_AUX_PORT;
+	} else {
+		/* for PCIE and SDIO interface, we check efuse 0xc3[6] */
+		if (board_info->single_ant_path == 0) {
+			/* set to S1 */
+			board_info->btdm_ant_pos = BTC_ANTENNA_AT_MAIN_PORT;
+		} else if (board_info->single_ant_path == 1) {
+			/* set to S0 */
+			board_info->btdm_ant_pos = BTC_ANTENNA_AT_AUX_PORT;
+		}
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_ANTPOSREGRISTRY_CTRL,
+				   &value);
+	}
+}
+
 void ex_btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 0b90e7f0b722..5a34cd895e44 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -139,6 +139,7 @@ struct btc_board_info {
 	u8 pg_ant_num;	/* pg ant number */
 	u8 btdm_ant_num;	/* ant number for btdm */
 	u8 btdm_ant_pos;
+	u8 single_ant_path; /* current used for 8723b only, 1=>s0,  0=>s1 */
 	bool bt_exist;
 };
 
-- 
2.12.0
