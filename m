Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36183 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdEEQRZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 12:17:25 -0400
Received: by mail-io0-f193.google.com with SMTP id x86so2437631ioe.3
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 09:17:24 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 04/10] rtlwifi: btcoex: 21a 2ant: settings before wifi firmware is ready
Date: Fri,  5 May 2017 11:17:06 -0500
Message-Id: <20170505161712.8685-5-Larry.Finger@lwfinger.net> (sfid-20170505_183118_258425_E3F1A74F)
In-Reply-To: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
References: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Before firmware is ready, set GNT_BT to high to let bt transmit.

Routine ex_btc8821a2ant_pre_load_firmware() restored.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - resubmit after removal of BT_AUTO_REPORT_XXXX symbols.
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 162d40ddf06d..9aa140a46d46 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3609,6 +3609,43 @@ void ex_btc8821a2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
 }
 
+void ex_btc8821a2ant_pre_load_firmware(struct btc_coexist *btcoexist)
+{
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	u8 u8tmp = 0x4; /* Set BIT2 by default since it's 2ant case */
+
+	/**
+	 * S0 or S1 setting and Local register setting(By the setting fw can get
+	 * ant number, S0/S1, ... info)
+	 *
+	 * Local setting bit define
+	 *	BIT0: "0" for no antenna inverse; "1" for antenna inverse
+	 *	BIT1: "0" for internal switch; "1" for external switch
+	 *	BIT2: "0" for one antenna; "1" for two antenna
+	 * NOTE: here default all internal switch and 1-antenna ==> BIT1=0 and
+	 * BIT2=0
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
 void ex_btc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-- 
2.12.2
