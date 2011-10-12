Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64830 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1JLC32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 22:29:28 -0400
Received: by mail-yw0-f46.google.com with SMTP id 5so226869ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 19:29:28 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/5 V2] rtlwifi: rtl8192de: Updates from latest Reaktek driver - Part III
Date: Tue, 11 Oct 2011 21:28:51 -0500
Message-Id: <1318386531-5859-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111012_042934_728364_F3B8573F)
In-Reply-To: <1318386531-5859-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1318386531-5859-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

This patch incorporate the differences between the 06/20/2011 and
08/16/2011 Realtek releases of the rtl8192de driver.

The changes include:

1. Update for new chip versions

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/def.h |  124 ++++++++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |   19 ++---
 2 files changed, 84 insertions(+), 59 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/def.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/def.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/def.h
@@ -122,60 +122,99 @@
 #define	GET_C2H_CMD_FEEDBACK_CCX_SEQ(__pcmdfbhdr)	\
 	LE_BITS_TO_4BYTE(((__pcmdfbhdr) + 4), 20, 12)
 
-/*
- * 92D chip ver:
- * BIT8: IS 92D
- * BIT9: single phy
- * BIT10: C-cut
- * BIT11: D-cut
- */
-
-/* Chip specific */
-#define CHIP_92C			BIT(0)
-#define CHIP_92C_1T2R			BIT(1)
-#define CHIP_8723			BIT(2) /* RTL8723 With BT feature */
-#define CHIP_8723_DRV_REV		BIT(3) /* RTL8723 Driver Revised */
-#define NORMAL_CHIP			BIT(4)
-#define CHIP_VENDOR_UMC			BIT(5)
-#define CHIP_VENDOR_UMC_B_CUT		BIT(6) /* Chip version for ECO */
+enum version_8192d {
+	VERSION_TEST_CHIP_88C = 0x0000,
+	VERSION_TEST_CHIP_92C = 0x0020,
+	VERSION_TEST_UMC_CHIP_8723 = 0x0081,
+	VERSION_NORMAL_TSMC_CHIP_88C = 0x0008,
+	VERSION_NORMAL_TSMC_CHIP_92C = 0x0028,
+	VERSION_NORMAL_TSMC_CHIP_92C_1T2R = 0x0018,
+	VERSION_NORMAL_UMC_CHIP_88C_A_CUT = 0x0088,
+	VERSION_NORMAL_UMC_CHIP_92C_A_CUT = 0x00a8,
+	VERSION_NORMAL_UMC_CHIP_92C_1T2R_A_CUT = 0x0098,
+	VERSION_NORMAL_UMC_CHIP_8723_1T1R_A_CUT = 0x0089,
+	VERSION_NORMAL_UMC_CHIP_8723_1T1R_B_CUT = 0x1089,
+	VERSION_NORMAL_UMC_CHIP_88C_B_CUT = 0x1088,
+	VERSION_NORMAL_UMC_CHIP_92C_B_CUT = 0x10a8,
+	VERSION_NORMAL_UMC_CHIP_92C_1T2R_B_CUT = 0x1090,
+	VERSION_TEST_CHIP_92D_SINGLEPHY = 0x0022,
+	VERSION_TEST_CHIP_92D_DUALPHY = 0x0002,
+	VERSION_NORMAL_CHIP_92D_SINGLEPHY = 0x002a,
+	VERSION_NORMAL_CHIP_92D_DUALPHY = 0x000a,
+	VERSION_NORMAL_CHIP_92D_C_CUT_SINGLEPHY = 0x202a,
+	VERSION_NORMAL_CHIP_92D_C_CUT_DUALPHY = 0x200a,
+	VERSION_NORMAL_CHIP_92D_D_CUT_SINGLEPHY = 0x302a,
+	VERSION_NORMAL_CHIP_92D_D_CUT_DUALPHY = 0x300a,
+	VERSION_NORMAL_CHIP_92D_E_CUT_SINGLEPHY = 0x402a,
+	VERSION_NORMAL_CHIP_92D_E_CUT_DUALPHY = 0x400a,
+};
 
 /* for 92D */
-#define CHIP_92D			BIT(8)
 #define CHIP_92D_SINGLEPHY		BIT(9)
+#define C_CUT_VERSION			BIT(13)
+#define D_CUT_VERSION			((BIT(12)|BIT(13)))
+#define E_CUT_VERSION			BIT(14)
+
+/* Chip specific */
+#define CHIP_BONDING_IDENTIFIER(_value)	(((_value)>>22)&0x3)
+#define CHIP_BONDING_92C_1T2R			0x1
+#define CHIP_BONDING_88C_USB_MCARD		0x2
+#define CHIP_BONDING_88C_USB_HP			0x1
+
+/* [15:12] IC version(CUT): A-cut=0, B-cut=1, C-cut=2, D-cut=3 */
+/* [7] Manufacturer: TSMC=0, UMC=1 */
+/* [6:4] RF type: 1T1R=0, 1T2R=1, 2T2R=2 */
+/* [3] Chip type: TEST=0, NORMAL=1 */
+/* [2:0] IC type: 81xxC=0, 8723=1, 92D=2 */
+#define CHIP_8723			BIT(0)
+#define CHIP_92D			BIT(1)
+#define NORMAL_CHIP			BIT(3)
+#define RF_TYPE_1T1R			(~(BIT(4)|BIT(5)|BIT(6)))
+#define RF_TYPE_1T2R			BIT(4)
+#define RF_TYPE_2T2R			BIT(5)
+#define CHIP_VENDOR_UMC			BIT(7)
+#define B_CUT_VERSION			BIT(12)
+
+/* MASK */
+#define IC_TYPE_MASK			(BIT(0)|BIT(1)|BIT(2))
+#define CHIP_TYPE_MASK			BIT(3)
+#define RF_TYPE_MASK			(BIT(4)|BIT(5)|BIT(6))
+#define MANUFACTUER_MASK		BIT(7)
+#define ROM_VERSION_MASK		(BIT(11)|BIT(10)|BIT(9)|BIT(8))
+#define CUT_VERSION_MASK		(BIT(15)|BIT(14)|BIT(13)|BIT(12))
+
+
+/* Get element */
+#define GET_CVID_IC_TYPE(version)	((version) & IC_TYPE_MASK)
+#define GET_CVID_CHIP_TYPE(version)	((version) & CHIP_TYPE_MASK)
+#define GET_CVID_RF_TYPE(version)	((version) & RF_TYPE_MASK)
+#define GET_CVID_MANUFACTUER(version)	((version) & MANUFACTUER_MASK)
+#define GET_CVID_ROM_VERSION(version)	((version) & ROM_VERSION_MASK)
+#define GET_CVID_CUT_VERSION(version)	((version) & CUT_VERSION_MASK)
+
+#define IS_1T1R(version)		((GET_CVID_RF_TYPE(version)) ?	\
+					 false : true)
+#define IS_1T2R(version)		((GET_CVID_RF_TYPE(version) ==	\
+					 RF_TYPE_1T2R) ? true : false)
+#define IS_2T2R(version)		((GET_CVID_RF_TYPE(version) ==	\
+					 RF_TYPE_2T2R) ? true : false)
+
+#define IS_92D_SINGLEPHY(version)	((IS_92D(version)) ?		\
+				 (IS_2T2R(version) ? true : false) : false)
+#define IS_92D(version)			((GET_CVID_IC_TYPE(version) ==	\
+					 CHIP_92D) ? true : false)
+#define IS_92D_C_CUT(version)		((IS_92D(version)) ?		\
+				 ((GET_CVID_CUT_VERSION(version) ==	\
+				 0x2000) ? true : false) : false)
+#define IS_92D_D_CUT(version)			((IS_92D(version)) ?	\
+				 ((GET_CVID_CUT_VERSION(version) ==	\
+				 0x3000) ? true : false) : false)
+#define IS_92D_E_CUT(version)		((IS_92D(version)) ?		\
+				 ((GET_CVID_CUT_VERSION(version) ==	\
+				 0x4000) ? true : false) : false)
 #define CHIP_92D_C_CUT			BIT(10)
 #define CHIP_92D_D_CUT			BIT(11)
 
-enum version_8192d {
-	VERSION_TEST_CHIP_88C = 0x00,
-	VERSION_TEST_CHIP_92C = 0x01,
-	VERSION_NORMAL_TSMC_CHIP_88C = 0x10,
-	VERSION_NORMAL_TSMC_CHIP_92C = 0x11,
-	VERSION_NORMAL_TSMC_CHIP_92C_1T2R = 0x13,
-	VERSION_NORMAL_UMC_CHIP_88C_A_CUT = 0x30,
-	VERSION_NORMAL_UMC_CHIP_92C_A_CUT = 0x31,
-	VERSION_NORMAL_UMC_CHIP_92C_1T2R_A_CUT = 0x33,
-	VERSION_NORMA_UMC_CHIP_8723_1T1R_A_CUT = 0x34,
-	VERSION_NORMA_UMC_CHIP_8723_1T1R_B_CUT = 0x3c,
-	VERSION_NORMAL_UMC_CHIP_88C_B_CUT = 0x70,
-	VERSION_NORMAL_UMC_CHIP_92C_B_CUT = 0x71,
-	VERSION_NORMAL_UMC_CHIP_92C_1T2R_B_CUT = 0x73,
-	VERSION_TEST_CHIP_92D_SINGLEPHY = 0x300,
-	VERSION_TEST_CHIP_92D_DUALPHY = 0x100,
-	VERSION_NORMAL_CHIP_92D_SINGLEPHY = 0x310,
-	VERSION_NORMAL_CHIP_92D_DUALPHY = 0x110,
-	VERSION_NORMAL_CHIP_92D_C_CUT_SINGLEPHY = 0x710,
-	VERSION_NORMAL_CHIP_92D_C_CUT_DUALPHY = 0x510,
-	VERSION_NORMAL_CHIP_92D_D_CUT_SINGLEPHY = 0xB10,
-	VERSION_NORMAL_CHIP_92D_D_CUT_DUALPHY = 0x910,
-};
-
-#define IS_92D_SINGLEPHY(version)		\
-	((version & CHIP_92D_SINGLEPHY) ? true : false)
-#define IS_92D_C_CUT(version)			\
-	((version & CHIP_92D_C_CUT) ? true : false)
-#define IS_92D_D_CUT(version)			\
-	((version & CHIP_92D_D_CUT) ? true : false)
-
 enum rf_optype {
 	RF_OP_BY_SW_3WIRE = 0,
 	RF_OP_BY_FW,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1608,17 +1608,16 @@ static void _rtl92de_read_txpower_info(s
 		tempval[0] = hwinfo[EEPROM_IQK_DELTA] & 0x03;
 		tempval[1] = (hwinfo[EEPROM_LCK_DELTA] & 0x0C) >> 2;
 		rtlefuse->txpwr_fromeprom = true;
-		if (IS_92D_D_CUT(rtlpriv->rtlhal.version)) {
+		if (IS_92D_D_CUT(rtlpriv->rtlhal.version) ||
+		    IS_92D_E_CUT(rtlpriv->rtlhal.version)) {
 			rtlefuse->internal_pa_5g[0] =
-				 !((hwinfo[EEPROM_TSSI_A_5G] &
-				 BIT(6)) >> 6);
+				!((hwinfo[EEPROM_TSSI_A_5G] & BIT(6)) >> 6);
 			rtlefuse->internal_pa_5g[1] =
-				 !((hwinfo[EEPROM_TSSI_B_5G] &
-				 BIT(6)) >> 6);
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+				!((hwinfo[EEPROM_TSSI_B_5G] & BIT(6)) >> 6);
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 				 ("Is D cut,Internal PA0 %d Internal PA1 %d\n",
-				  rtlefuse->internal_pa_5g[0],
-				  rtlefuse->internal_pa_5g[1]))
+				 rtlefuse->internal_pa_5g[0],
+				 rtlefuse->internal_pa_5g[1]))
 		}
 		rtlefuse->eeprom_c9 = hwinfo[EEPROM_RF_OPT6];
 		rtlefuse->eeprom_cc = hwinfo[EEPROM_RF_OPT7];
