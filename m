Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32790 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754865AbdDFUUK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:10 -0400
Received: by mail-oi0-f66.google.com with SMTP id f193so8896774oib.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/11] rtlwifi: btcoex: 23b 2ant: before firmware ready settings
Date: Thu,  6 Apr 2017 15:19:54 -0500
Message-Id: <20170406201958.25642-8-Larry.Finger@lwfinger.net> (sfid-20170406_222056_941420_8F363E8C)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Before firmware is ready, set GNT_BT to high to let bt transmit

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 38 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 0f3d04529ff2..06f70944bdac 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3700,6 +3700,44 @@ void ex_btc8723b2ant_power_on_setting(struct btc_coexist *btcoexist)
 	}
 }
 
+void ex_btc8723b2ant_pre_load_firmware(struct btc_coexist *btcoexist)
+{
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	u8 u8tmp = 0x4; /* Set BIT2 by default since it's 2ant case */
+
+	/**
+	 * S0 or S1 setting and Local register setting(By this fw can get
+	 * ant number, S0/S1, ... info)
+	 *
+	 * Local setting bit define
+	 *	BIT0: "0" : no antenna inverse; "1" : antenna inverse
+	 *	BIT1: "0" : internal switch; "1" : external switch
+	 *	BIT2: "0" : one antenna; "1" : two antennas
+	 *
+	 * NOTE: here default all internal switch and 1-antenna ==> BIT1=0 and
+	 * BIT2 = 0
+	 */
+	if (btcoexist->chip_interface == BTC_INTF_USB) {
+		/* fixed at S0 for USB interface */
+		u8tmp |= 0x1; /* antenna inverse */
+		btcoexist->btc_write_local_reg_1byte(btcoexist, 0xfe08, u8tmp);
+	} else {
+		/* for PCIE and SDIO interface, we check efuse 0xc3[6] */
+		if (board_info->single_ant_path == 0) {
+		} else if (board_info->single_ant_path == 1) {
+			/* set to S0 */
+			u8tmp |= 0x1; /* antenna inverse */
+		}
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
 void ex_btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 5a34cd895e44..d31e6df5b1bf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -369,6 +369,7 @@ typedef void (*bfp_btc_w2)(void *btc_context, u32 reg_addr, u16 data);
 
 typedef void (*bfp_btc_w4)(void *btc_context, u32 reg_addr, u32 data);
 
+typedef void (*bfp_btc_local_reg_w1)(void *btc_context, u32 reg_addr, u8 data);
 typedef void (*bfp_btc_wr_1byte_bit_mask)(void *btc_context, u32 reg_addr,
 					  u8 bit_mask, u8 data);
 
@@ -496,6 +497,7 @@ struct btc_coexist {
 	bfp_btc_w2 btc_write_2byte;
 	bfp_btc_r4 btc_read_4byte;
 	bfp_btc_w4 btc_write_4byte;
+	bfp_btc_local_reg_w1 btc_write_local_reg_1byte;
 
 	bfp_btc_set_bb_reg btc_set_bb_reg;
 	bfp_btc_get_bb_reg btc_get_bb_reg;
-- 
2.12.0
