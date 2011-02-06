Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1BFSnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 13:43:43 -0500
Date: Sun, 06 Feb 2011 12:44:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sgruszka@redhat.com, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] rtlwifi: rtl8192ce: Add definitions to
 rtl8192cu/def.h
Message-ID: <4d4eec19.MdpH+6Xn9RUOgSAJ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the definitions needed for rtl8192cu.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -63,7 +63,15 @@
 #define REG_LEDCFG3				0x004F
 #define REG_FSIMR				0x0050
 #define REG_FSISR				0x0054
+#define REG_HSIMR				0x0058
+#define REG_HSISR				0x005c
 
+/* RTL8723 WIFI/BT/GPS Multi-Function GPIO Pin Control. */
+#define REG_GPIO_PIN_CTRL_2			0x0060
+/* RTL8723 WIFI/BT/GPS Multi-Function GPIO Select. */
+#define REG_GPIO_IO_SEL_2			0x0062
+/* RTL8723 WIFI/BT/GPS Multi-Function control source. */
+#define REG_MULTI_FUNC_CTRL			0x0068
 #define REG_MCUFWDL				0x0080
 
 #define REG_HMEBOX_EXT_0			0x0088
@@ -79,6 +87,7 @@
 #define REG_PCIE_MIO_INTD			0x00E8
 #define REG_HPON_FSM				0x00EC
 #define REG_SYS_CFG				0x00F0
+#define REG_GPIO_OUTSTS				0x00F4	/* For RTL8723 only.*/
 
 #define REG_CR					0x0100
 #define REG_PBP					0x0104
@@ -209,6 +218,8 @@
 #define REG_RDG_PIFS				0x0513
 #define REG_SIFS_CTX				0x0514
 #define REG_SIFS_TRX				0x0516
+#define REG_SIFS_CCK				0x0514
+#define REG_SIFS_OFDM				0x0516
 #define REG_AGGR_BREAK_TIME			0x051A
 #define REG_SLOT				0x051B
 #define REG_TX_PTCL_CTRL			0x0520
@@ -261,6 +272,10 @@
 #define REG_MAC_SPEC_SIFS			0x063A
 #define REG_RESP_SIFS_CCK			0x063C
 #define REG_RESP_SIFS_OFDM			0x063E
+/* [15:8]SIFS_R2T_OFDM, [7:0]SIFS_R2T_CCK */
+#define REG_R2T_SIFS				0x063C
+/* [15:8]SIFS_T2T_OFDM, [7:0]SIFS_T2T_CCK */
+#define REG_T2T_SIFS				0x063E
 #define REG_ACKTO				0x0640
 #define REG_CTS2TO				0x0641
 #define REG_EIFS				0x0642
@@ -641,9 +656,10 @@
 #define	STOPBE					BIT(1)
 #define	STOPBK					BIT(0)
 
-#define	RCR_APPFCS				BIT(31)
+#define	RCR_APP_FCS				BIT(31)
 #define	RCR_APP_MIC				BIT(30)
 #define	RCR_APP_ICV				BIT(29)
+#define	RCR_APP_PHYSTS				BIT(28)
 #define	RCR_APP_PHYST_RXFF			BIT(28)
 #define	RCR_APP_BA_SSN				BIT(27)
 #define	RCR_ENMBID				BIT(24)
@@ -759,6 +775,7 @@
 
 #define	BOOT_FROM_EEPROM			BIT(4)
 #define	EEPROM_EN				BIT(5)
+#define	EEPROMSEL				BOOT_FROM_EEPROM
 
 #define AFE_BGEN				BIT(0)
 #define AFE_MBEN				BIT(1)
@@ -876,6 +893,8 @@
 #define BD_MAC2					BIT(9)
 #define BD_MAC1					BIT(10)
 #define IC_MACPHY_MODE				BIT(11)
+#define BT_FUNC					BIT(16)
+#define VENDOR_ID				BIT(19)
 #define PAD_HWPD_IDN				BIT(22)
 #define TRP_VAUX_EN				BIT(23)
 #define TRP_BT_EN				BIT(24)
@@ -883,6 +902,28 @@
 #define BD_HCI_SEL				BIT(26)
 #define TYPE_ID					BIT(27)
 
+/* REG_GPIO_OUTSTS (For RTL8723 only) */
+#define	EFS_HCI_SEL				(BIT(0)|BIT(1))
+#define	PAD_HCI_SEL				(BIT(2)|BIT(3))
+#define	HCI_SEL					(BIT(4)|BIT(5))
+#define	PKG_SEL_HCI				BIT(6)
+#define	FEN_GPS					BIT(7)
+#define	FEN_BT					BIT(8)
+#define	FEN_WL					BIT(9)
+#define	FEN_PCI					BIT(10)
+#define	FEN_USB					BIT(11)
+#define	BTRF_HWPDN_N				BIT(12)
+#define	WLRF_HWPDN_N				BIT(13)
+#define	PDN_BT_N				BIT(14)
+#define	PDN_GPS_N				BIT(15)
+#define	BT_CTL_HWPDN				BIT(16)
+#define	GPS_CTL_HWPDN				BIT(17)
+#define	PPHY_SUSB				BIT(20)
+#define	UPHY_SUSB				BIT(21)
+#define	PCI_SUSEN				BIT(22)
+#define	USB_SUSEN				BIT(23)
+#define	RF_RL_ID			(BIT(31) | BIT(30) | BIT(29) | BIT(28))
+
 #define CHIP_VER_RTL_MASK			0xF000
 #define CHIP_VER_RTL_SHIFT			12
 
@@ -1184,6 +1225,30 @@
 
 #define	HAL_8192C_HW_GPIO_WPS_BIT		BIT(2)
 
+/* REG_MULTI_FUNC_CTRL(For RTL8723 Only) */
+/* Enable GPIO[9] as WiFi HW PDn source */
+#define	WL_HWPDN_EN				BIT(0)
+/* WiFi HW PDn polarity control */
+#define	WL_HWPDN_SL				BIT(1)
+/* WiFi function enable */
+#define	WL_FUNC_EN				BIT(2)
+/* Enable GPIO[9] as WiFi RF HW PDn source */
+#define	WL_HWROF_EN				BIT(3)
+/* Enable GPIO[11] as BT HW PDn source */
+#define	BT_HWPDN_EN				BIT(16)
+/* BT HW PDn polarity control */
+#define	BT_HWPDN_SL				BIT(17)
+/* BT function enable */
+#define	BT_FUNC_EN				BIT(18)
+/* Enable GPIO[11] as BT/GPS RF HW PDn source */
+#define	BT_HWROF_EN				BIT(19)
+/* Enable GPIO[10] as GPS HW PDn source */
+#define	GPS_HWPDN_EN				BIT(20)
+/* GPS HW PDn polarity control */
+#define	GPS_HWPDN_SL				BIT(21)
+/* GPS function enable */
+#define	GPS_FUNC_EN				BIT(22)
+
 #define	RPMAC_RESET				0x100
 #define	RPMAC_TXSTART				0x104
 #define	RPMAC_TXLEGACYSIG			0x108
@@ -1496,7 +1561,7 @@
 #define	BTXHTSTBC				0x30
 #define	BTXHTADVANCECODING			0x40
 #define	BTXHTSHORTGI				0x80
-#define	BTXHTNUMBERHT_LT	F		0x300
+#define	BTXHTNUMBERHT_LTF			0x300
 #define	BTXHTCRC8				0x3fc00
 #define	BCOUNTERRESET				0x10000
 #define	BNUMOFOFDMTX				0xffff
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -52,7 +52,7 @@ int rtl92c_init_sw_vars(struct ieee80211
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpci->transmit_config = CFENDFORM | BIT(12) | BIT(13);
 
-	rtlpci->receive_config = (RCR_APPFCS |
+	rtlpci->receive_config = (RCR_APP_FCS |
 				  RCR_AMF |
 				  RCR_ADF |
 				  RCR_APP_MIC |
