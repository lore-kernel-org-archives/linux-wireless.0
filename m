Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33014 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932413AbdDQAL2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:28 -0400
Received: by mail-oi0-f67.google.com with SMTP id a189so587476oib.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:28 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 12/27] rtlwifi: btcoex: 23b 1ant: Add power_on_setting
Date: Sun, 16 Apr 2017 19:10:56 -0500
Message-Id: <20170417001111.29384-13-Larry.Finger@lwfinger.net> (sfid-20170417_021143_468164_3472CBD0)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This change is highly related to init_hwconfig that decomposed into
two parts for better program routine.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 69 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  1 +
 2 files changed, 70 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 69be88765cab..6580af0ade39 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2186,6 +2186,75 @@ static void halbtc8723b1ant_init_hw_config(struct btc_coexist *btcoexist,
 /**************************************************************
  * extern function start with ex_halbtc8723b1ant_
  **************************************************************/
+void ex_halbtc8723b1ant_power_on_setting(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	u8 u8tmp = 0x0;
+	u16 u16tmp = 0x0;
+	u32 value;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "xxxxxxxxxxxxxxxx Execute 8723b 1-Ant PowerOn Setting xxxxxxxxxxxxxxxx!!\n");
+
+	btcoexist->stop_coex_dm = true;
+
+	btcoexist->btc_write_1byte(btcoexist, 0x67, 0x20);
+
+	/* enable BB, REG_SYS_FUNC_EN such that we can write 0x948 correctly. */
+	u16tmp = btcoexist->btc_read_2byte(btcoexist, 0x2);
+	btcoexist->btc_write_2byte(btcoexist, 0x2, u16tmp | BIT0 | BIT1);
+
+	/* set GRAN_BT = 1 */
+	btcoexist->btc_write_1byte(btcoexist, 0x765, 0x18);
+	/* set WLAN_ACT = 0 */
+	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
+
+	/* S0 or S1 setting and Local register setting(By the setting fw can get
+	 * ant number, S0/S1, ... info)
+	 *
+	 * Local setting bit define
+	 *	BIT0: "0" for no antenna inverse; "1" for antenna inverse
+	 *	BIT1: "0" for internal switch; "1" for external switch
+	 *	BIT2: "0" for one antenna; "1" for two antenna
+	 * NOTE: here default all internal switch and 1-antenna ==> BIT1=0 and
+	 * BIT2 = 0
+	 */
+	if (btcoexist->chip_interface == BTC_INTF_USB) {
+		/* fixed at S0 for USB interface */
+		btcoexist->btc_write_4byte(btcoexist, 0x948, 0x0);
+
+		u8tmp |= 0x1; /* antenna inverse */
+		btcoexist->btc_write_local_reg_1byte(btcoexist, 0xfe08, u8tmp);
+
+		board_info->btdm_ant_pos = BTC_ANTENNA_AT_AUX_PORT;
+	} else {
+		/* for PCIE and SDIO interface, we check efuse 0xc3[6] */
+		if (board_info->single_ant_path == 0) {
+			/* set to S1 */
+			btcoexist->btc_write_4byte(btcoexist, 0x948, 0x280);
+			board_info->btdm_ant_pos = BTC_ANTENNA_AT_MAIN_PORT;
+			value = 1;
+		} else if (board_info->single_ant_path == 1) {
+			/* set to S0 */
+			btcoexist->btc_write_4byte(btcoexist, 0x948, 0x0);
+			u8tmp |= 0x1; /* antenna inverse */
+			board_info->btdm_ant_pos = BTC_ANTENNA_AT_AUX_PORT;
+			value = 0;
+		}
+
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_ANTPOSREGRISTRY_CTRL,
+				   &value);
+
+		if (btcoexist->chip_interface == BTC_INTF_PCI)
+			btcoexist->btc_write_local_reg_1byte(btcoexist, 0x384,
+							     u8tmp);
+		else if (btcoexist->chip_interface == BTC_INTF_SDIO)
+			btcoexist->btc_write_local_reg_1byte(btcoexist, 0x60,
+							     u8tmp);
+	}
+}
+
 
 void ex_halbtc8723b1ant_init_hwconfig(struct btc_coexist *btcoexist,
 				      bool wifi_only)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index d51e92a2b3aa..d7c1806b094a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -190,6 +190,7 @@ struct coex_sta_8723b_1ant {
 /*************************************************************************
  * The following is interface which will notify coex module.
  *************************************************************************/
+void ex_halbtc8723b1ant_power_on_setting(struct btc_coexist *btcoexist);
 void ex_halbtc8723b1ant_init_hwconfig(struct btc_coexist *btcoexist,
 				      bool wifi_only);
 void ex_halbtc8723b1ant_init_coex_dm(struct btc_coexist *btcoexist);
-- 
2.12.0
