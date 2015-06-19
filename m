Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33166 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbbFSS2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2015 14:28:25 -0400
Received: by pdjn11 with SMTP id n11so95858230pdj.0
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2015 11:28:24 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Remove rtl8723 code
Date: Sat, 20 Jun 2015 03:28:15 +0900
Message-Id: <1434738495-29498-1-git-send-email-ap420073@gmail.com> (sfid-20150619_202829_425059_27FC5970)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the rtlwifi/rtl8192cu, rtl8723 code is dead code.
So I remove it.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h |  9 ---------
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  | 16 +---------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 12 ------------
 3 files changed, 1 insertion(+), 36 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
index c940a87..74a479a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
@@ -32,24 +32,15 @@
 /*-------------------------------------------------------------------------
  *	Chip specific
  *-------------------------------------------------------------------------*/
-#define CHIP_8723			BIT(2) /* RTL8723 With BT feature */
-#define CHIP_8723_DRV_REV		BIT(3) /* RTL8723 Driver Revised */
 #define NORMAL_CHIP			BIT(4)
 #define CHIP_VENDOR_UMC			BIT(5)
 #define CHIP_VENDOR_UMC_B_CUT		BIT(6)
 
-#define IS_8723_SERIES(version)		\
-	(((version) & CHIP_8723) ? true : false)
-
 #define IS_92C_1T2R(version)		\
 	(((version) & CHIP_92C) && ((version) & CHIP_92C_1T2R))
 
 #define IS_VENDOR_UMC(version)		\
 	(((version) & CHIP_VENDOR_UMC) ? true : false)
 
-#define IS_VENDOR_8723_A_CUT(version)	\
-	(((version) & CHIP_VENDOR_UMC) ? (((version) & (BIT(6))) ? \
-	false : true) : false)
-
 #define CHIP_BONDING_92C_1T2R	0x1
 #define CHIP_BONDING_IDENTIFIER(_value)	(((_value) >> 22) & 0x3)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 767358a..7cf3661 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -2280,7 +2280,6 @@ bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	enum rf_pwrstate e_rfpowerstate_toset, cur_rfstate;
 	u8 u1tmp = 0;
 	bool actuallyset = false;
@@ -2357,20 +2356,7 @@ bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid)
 		if (ppsc->pwrdown_mode && e_rfpowerstate_toset == ERFOFF) {
 			/* Enable register area 0x0-0xc. */
 			rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x0);
-			if (IS_HARDWARE_TYPE_8723U(rtlhal)) {
-				/*
-				 * We should configure HW PDn source for WiFi
-				 * ONLY, and then our HW will be set in
-				 * power-down mode if PDn source from all
-				 * functions are configured.
-				 */
-				u1tmp = rtl_read_byte(rtlpriv,
-						      REG_MULTI_FUNC_CTRL);
-				rtl_write_byte(rtlpriv, REG_MULTI_FUNC_CTRL,
-					       (u1tmp|WL_HWPDN_EN));
-			} else {
-				rtl_write_word(rtlpriv, REG_APS_FSMCO, 0x8812);
-			}
+			rtl_write_word(rtlpriv, REG_APS_FSMCO, 0x8812);
 		}
 		if (e_rfpowerstate_toset == ERFOFF) {
 			if (ppsc->reg_rfps_level  & RT_RF_OFF_LEVL_ASPM)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 490a7cf..1c55a00 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -69,8 +69,6 @@ void rtl92c_read_chip_version(struct ieee80211_hw *hw)
 		chip_version = NORMAL_CHIP;
 		chip_version |= ((value32 & TYPE_ID) ? CHIP_92C : 0);
 		chip_version |= ((value32 & VENDOR_ID) ? CHIP_VENDOR_UMC : 0);
-		/* RTL8723 with BT function. */
-		chip_version |= ((value32 & BT_FUNC) ? CHIP_8723 : 0);
 		if (IS_VENDOR_UMC(chip_version))
 			chip_version |= ((value32 & CHIP_VER_RTL_MASK) ?
 					 CHIP_VENDOR_UMC_B_CUT : 0);
@@ -78,10 +76,6 @@ void rtl92c_read_chip_version(struct ieee80211_hw *hw)
 			value32 = rtl_read_dword(rtlpriv, REG_HPON_FSM);
 			chip_version |= ((CHIP_BONDING_IDENTIFIER(value32) ==
 				 CHIP_BONDING_92C_1T2R) ? CHIP_92C_1T2R : 0);
-		} else if (IS_8723_SERIES(chip_version)) {
-			value32 = rtl_read_dword(rtlpriv, REG_GPIO_OUTSTS);
-			chip_version |= ((value32 & RF_RL_ID) ?
-					  CHIP_8723_DRV_REV : 0);
 		}
 	}
 	rtlhal->version  = (enum version_8192c)chip_version;
@@ -114,12 +108,6 @@ void rtl92c_read_chip_version(struct ieee80211_hw *hw)
 	case VERSION_NORMAL_UMC_CHIP_88C_B_CUT:
 		versionid = "NORMAL_UMC_CHIP_88C_B_CUT";
 		break;
-	case VERSION_NORMA_UMC_CHIP_8723_1T1R_A_CUT:
-		versionid = "NORMAL_UMC_CHIP_8723_1T1R_A_CUT";
-		break;
-	case VERSION_NORMA_UMC_CHIP_8723_1T1R_B_CUT:
-		versionid = "NORMAL_UMC_CHIP_8723_1T1R_B_CUT";
-		break;
 	case VERSION_TEST_CHIP_92C:
 		versionid = "TEST_CHIP_92C";
 		break;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
