Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35730 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdGBSMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Jul 2017 14:12:50 -0400
Received: by mail-oi0-f68.google.com with SMTP id l130so17397546oib.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Jul 2017 11:12:50 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v4 03/10] rtlwifi: Add board type for 8723be and 8192ee
Date: Sun,  2 Jul 2017 13:12:32 -0500
Message-Id: <20170702181239.17911-4-Larry.Finger@lwfinger.net> (sfid-20170702_201255_178458_99D32E36)
In-Reply-To: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

With correct board_type, the phy praser can choose correct parameters.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - no changes
v3 - no changes
v4 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c | 5 +++++
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index d84ac7adfd82..ef9394be7016 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -2133,7 +2133,12 @@ static void _rtl92ee_read_adapter_info(struct ieee80211_hw *hw)
 	if ((*(u8 *)&hwinfo[EEPROM_RF_BOARD_OPTION_92E]) == 0xFF)
 		rtlefuse->board_type = 0;
 
+	if (rtlpriv->btcoexist.btc_info.btcoexist == 1)
+		rtlefuse->board_type |= BIT(2); /* ODM_BOARD_BT */
+
 	rtlhal->board_type = rtlefuse->board_type;
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "board_type = 0x%x\n", rtlefuse->board_type);
 	/*parse xtal*/
 	rtlefuse->crystalcap = hwinfo[EEPROM_XTAL_92E];
 	if (hwinfo[EEPROM_XTAL_92E] == 0xFF)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 2a7ad5ffe997..0b9366e7acbd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2114,6 +2114,13 @@ static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 						 rtlefuse->autoload_failflag,
 						 hwinfo);
 
+	if (rtlpriv->btcoexist.btc_info.btcoexist == 1)
+		rtlefuse->board_type |= BIT(2); /* ODM_BOARD_BT */
+
+	rtlhal->board_type = rtlefuse->board_type;
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 "board_type = 0x%x\n", rtlefuse->board_type);
+
 	rtlhal->package_type = _rtl8723be_read_package_type(hw);
 
 	/* set channel plan from efuse */
-- 
2.12.3
