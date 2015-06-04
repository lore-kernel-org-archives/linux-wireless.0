Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34442 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbbFDIns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 04:43:48 -0400
Received: by payr10 with SMTP id r10so25340513pay.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 01:43:48 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] rtlwifi: rtl8192cu: remove IS_HARDWARE_TYPE_8192CE and IS_HARDWARE_TYPE_8192CU
Date: Thu,  4 Jun 2015 17:43:34 +0900
Message-Id: <1433407416-752-1-git-send-email-ap420073@gmail.com> (sfid-20150604_104352_694189_68173990)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in the rtlwifi/rtl8192cu, IS_HARDWARE_TYPE_8192CE and IS_HARDWARE_TYPE_8192CU
is unnecessary. because rtlwifi/rtl8192cu codes aren't shared.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index 12f6d47..a750621 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -108,13 +108,8 @@ void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
 bool rtl92cu_phy_mac_config(struct ieee80211_hw *hw)
 {
 	bool rtstatus;
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	bool is92c = IS_92C_SERIAL(rtlhal->version);
 
 	rtstatus = _rtl92cu_phy_config_mac_with_headerfile(hw);
-	if (is92c && IS_HARDWARE_TYPE_8192CE(rtlhal))
-		rtl_write_byte(rtlpriv, 0x14, 0x71);
 	return rtstatus;
 }
 
@@ -122,7 +117,6 @@ bool rtl92cu_phy_bb_config(struct ieee80211_hw *hw)
 {
 	bool rtstatus = true;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u16 regval;
 	u32 regval32;
 	u8 b_reg_hwparafile = 1;
@@ -134,17 +128,11 @@ bool rtl92cu_phy_bb_config(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL, 0x83);
 	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL + 1, 0xdb);
 	rtl_write_byte(rtlpriv, REG_RF_CTRL, RF_EN | RF_RSTB | RF_SDMRSTB);
-	if (IS_HARDWARE_TYPE_8192CE(rtlhal)) {
-		rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, FEN_PPLL | FEN_PCIEA |
-			       FEN_DIO_PCIE |	FEN_BB_GLB_RSTn | FEN_BBRSTB);
-	} else if (IS_HARDWARE_TYPE_8192CU(rtlhal)) {
-		rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, FEN_USBA | FEN_USBD |
-			       FEN_BB_GLB_RSTn | FEN_BBRSTB);
-	}
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, FEN_USBA | FEN_USBD |
+		       FEN_BB_GLB_RSTn | FEN_BBRSTB);
 	regval32 = rtl_read_dword(rtlpriv, 0x87c);
 	rtl_write_dword(rtlpriv, 0x87c, regval32 & (~BIT(31)));
-	if (IS_HARDWARE_TYPE_8192CU(rtlhal))
-		rtl_write_byte(rtlpriv, REG_LDOHCI12_CTRL, 0x0f);
+	rtl_write_byte(rtlpriv, REG_LDOHCI12_CTRL, 0x0f);
 	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL + 1, 0x80);
 	if (b_reg_hwparafile == 1)
 		rtstatus = _rtl92c_phy_bb8192c_config_parafile(hw);
-- 
2.1.4

