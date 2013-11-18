Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46929 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab3KRTHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 14:07:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/3] rtlwifi: rtl8192cu: Bring rtl92cu_phy_bb_config() up to date
Date: Mon, 18 Nov 2013 13:06:56 -0600
Message-Id: <1384801617-22920-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131118_200741_357094_22A1AE14)
In-Reply-To: <1384801617-22920-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1384801617-22920-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>

The latest vendor driver contains some changes not in the kernel version.

Signed-off-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index 34e5630..0c09240 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -120,6 +120,7 @@ bool rtl92cu_phy_bb_config(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u16 regval;
+	u32 regval32;
 	u8 b_reg_hwparafile = 1;
 
 	_rtl92c_phy_init_bb_rf_register_definition(hw);
@@ -135,8 +136,11 @@ bool rtl92cu_phy_bb_config(struct ieee80211_hw *hw)
 	} else if (IS_HARDWARE_TYPE_8192CU(rtlhal)) {
 		rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, FEN_USBA | FEN_USBD |
 			       FEN_BB_GLB_RSTn | FEN_BBRSTB);
-		rtl_write_byte(rtlpriv, REG_LDOHCI12_CTRL, 0x0f);
 	}
+	regval32 = rtl_read_dword(rtlpriv, 0x87c);
+	rtl_write_dword(rtlpriv, 0x87c, regval32 & (~BIT(31)));
+	if (IS_HARDWARE_TYPE_8192CU(rtlhal))
+		rtl_write_byte(rtlpriv, REG_LDOHCI12_CTRL, 0x0f);
 	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL + 1, 0x80);
 	if (b_reg_hwparafile == 1)
 		rtstatus = _rtl92c_phy_bb8192c_config_parafile(hw);
-- 
1.8.4

