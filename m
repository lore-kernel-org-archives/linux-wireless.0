Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35198 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756803AbdDQAcM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:32:12 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Maxim Samoylov <max7255@gmail.com>,
        Stable <stable@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH] rtlwifi: rtl8821ae: setup 8812ae RFE according to device type
Date: Sun, 16 Apr 2017 19:32:07 -0500
Message-Id: <20170417003207.32347-1-Larry.Finger@lwfinger.net> (sfid-20170417_023218_735940_C3952831)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current channel switch implementation sets 8812ae RFE reg value assuming
that device always has type 2.

Extend possible RFE types set and write corresponding reg values.

Source for new code is
http://dlcdnet.asus.com/pub/ASUS/wireless/PCE-AC51/DR_PCE_AC51_20232801152016.zip

Signed-off-by: Maxim Samoylov <max7255@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 122 ++++++++++++++++++---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/reg.h   |   1 +
 2 files changed, 107 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 94a5e587a1cd..aa3ccc740521 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -358,6 +358,107 @@ bool rtl8821ae_phy_rf_config(struct ieee80211_hw *hw)
 	return rtl8821ae_phy_rf6052_config(hw);
 }
 
+static void _rtl8812ae_phy_set_rfe_reg_24g(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u8 tmp;
+
+	switch (rtlhal->rfe_type) {
+	case 3:
+		rtl_set_bbreg(hw, RA_RFE_PINMUX, BMASKDWORD, 0x54337770);
+		rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD, 0x54337770);
+		rtl_set_bbreg(hw, RA_RFE_INV, BMASKRFEINV, 0x010);
+		rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x010);
+		rtl_set_bbreg(hw, 0x900, 0x00000303, 0x1);
+		break;
+	case 4:
+		rtl_set_bbreg(hw, RA_RFE_PINMUX, BMASKDWORD, 0x77777777);
+		rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD, 0x77777777);
+		rtl_set_bbreg(hw, RA_RFE_INV, BMASKRFEINV, 0x001);
+		rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x001);
+		break;
+	case 5:
+		rtl_write_byte(rtlpriv, RA_RFE_PINMUX + 2, 0x77);
+		rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD, 0x77777777);
+		tmp = rtl_read_byte(rtlpriv, RA_RFE_INV + 3);
+		rtl_write_byte(rtlpriv, RA_RFE_INV + 3, tmp & ~0x1);
+		rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x000);
+		break;
+	case 1:
+		if (rtlpriv->btcoexist.bt_coexistence) {
+			rtl_set_bbreg(hw, RA_RFE_PINMUX, 0xffffff, 0x777777);
+			rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD,
+				      0x77777777);
+			rtl_set_bbreg(hw, RA_RFE_INV, 0x33f00000, 0x000);
+			rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x000);
+			break;
+		}
+	case 0:
+	case 2:
+	default:
+		rtl_set_bbreg(hw, RA_RFE_PINMUX, BMASKDWORD, 0x77777777);
+		rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD, 0x77777777);
+		rtl_set_bbreg(hw, RA_RFE_INV, BMASKRFEINV, 0x000);
+		rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x000);
+		break;
+	}
+}
+
+static void _rtl8812ae_phy_set_rfe_reg_5g(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u8 tmp;
+
+	switch (rtlhal->rfe_type) {
+	case 0:
+		rtl_set_bbreg(hw, RA_RFE_PINMUX, BMASKDWORD, 0x77337717);
+		rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD, 0x77337717);
+		rtl_set_bbreg(hw, RA_RFE_INV, BMASKRFEINV, 0x010);
+		rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x010);
+		break;
+	case 1:
+		if (rtlpriv->btcoexist.bt_coexistence) {
+			rtl_set_bbreg(hw, RA_RFE_PINMUX, 0xffffff, 0x337717);
+			rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD,
+				      0x77337717);
+			rtl_set_bbreg(hw, RA_RFE_INV, 0x33f00000, 0x000);
+			rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x000);
+		} else {
+			rtl_set_bbreg(hw, RA_RFE_PINMUX, BMASKDWORD,
+				      0x77337717);
+			rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD,
+				      0x77337717);
+			rtl_set_bbreg(hw, RA_RFE_INV, BMASKRFEINV, 0x000);
+			rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x000);
+		}
+		break;
+	case 3:
+		rtl_set_bbreg(hw, RA_RFE_PINMUX, BMASKDWORD, 0x54337717);
+		rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD, 0x54337717);
+		rtl_set_bbreg(hw, RA_RFE_INV, BMASKRFEINV, 0x010);
+		rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x010);
+		rtl_set_bbreg(hw, 0x900, 0x00000303, 0x1);
+		break;
+	case 5:
+		rtl_write_byte(rtlpriv, RA_RFE_PINMUX + 2, 0x33);
+		rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD, 0x77337777);
+		tmp = rtl_read_byte(rtlpriv, RA_RFE_INV + 3);
+		rtl_write_byte(rtlpriv, RA_RFE_INV + 3, tmp | 0x1);
+		rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x010);
+		break;
+	case 2:
+	case 4:
+	default:
+		rtl_set_bbreg(hw, RA_RFE_PINMUX, BMASKDWORD, 0x77337777);
+		rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD, 0x77337777);
+		rtl_set_bbreg(hw, RA_RFE_INV, BMASKRFEINV, 0x010);
+		rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x010);
+		break;
+	}
+}
+
 u32 phy_get_tx_swing_8812A(struct ieee80211_hw *hw, u8	band,
 			   u8 rf_path)
 {
@@ -552,14 +653,9 @@ void rtl8821ae_phy_switch_wirelessband(struct ieee80211_hw *hw, u8 band)
 			/* 0x82C[1:0] = 2b'00 */
 			rtl_set_bbreg(hw, 0x82c, 0x3, 0);
 		}
-		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
-			rtl_set_bbreg(hw, RA_RFE_PINMUX, BMASKDWORD,
-				      0x77777777);
-			rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD,
-				      0x77777777);
-			rtl_set_bbreg(hw, RA_RFE_INV, 0x3ff00000, 0x000);
-			rtl_set_bbreg(hw, RB_RFE_INV, 0x3ff00000, 0x000);
-		}
+
+		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE)
+			_rtl8812ae_phy_set_rfe_reg_24g(hw);
 
 		rtl_set_bbreg(hw, RTXPATH, 0xf0, 0x1);
 		rtl_set_bbreg(hw, RCCK_RX, 0x0f000000, 0x1);
@@ -614,14 +710,8 @@ void rtl8821ae_phy_switch_wirelessband(struct ieee80211_hw *hw, u8 band)
 			/* 0x82C[1:0] = 2'b00 */
 			rtl_set_bbreg(hw, 0x82c, 0x3, 1);
 
-		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
-			rtl_set_bbreg(hw, RA_RFE_PINMUX, BMASKDWORD,
-				      0x77337777);
-			rtl_set_bbreg(hw, RB_RFE_PINMUX, BMASKDWORD,
-				      0x77337777);
-			rtl_set_bbreg(hw, RA_RFE_INV, 0x3ff00000, 0x010);
-			rtl_set_bbreg(hw, RB_RFE_INV, 0x3ff00000, 0x010);
-		}
+		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE)
+			_rtl8812ae_phy_set_rfe_reg_5g(hw);
 
 		rtl_set_bbreg(hw, RTXPATH, 0xf0, 0);
 		rtl_set_bbreg(hw, RCCK_RX, 0x0f000000, 0xf);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
index 1d6110f9c1fb..ed69dbe178ff 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
@@ -2424,6 +2424,7 @@
 #define	BMASKH4BITS			0xf0000000
 #define BMASKOFDM_D			0xffc00000
 #define	BMASKCCK			0x3f3f3f3f
+#define BMASKRFEINV			0x3ff00000
 
 #define BRFREGOFFSETMASK		0xfffff
 
-- 
2.12.0
