Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33124 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdFYPnx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 11:43:53 -0400
Received: by mail-ot0-f195.google.com with SMTP id q16so9327901otb.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jun 2017 08:43:52 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 03/10] rtlwifi: Add board type for 8723be and 8192ee
Date: Sun, 25 Jun 2017 10:43:37 -0500
Message-Id: <20170625154344.19213-4-Larry.Finger@lwfinger.net> (sfid-20170625_174358_862726_ECF1E26A)
In-Reply-To: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
References: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
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
