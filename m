Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 054/113] rtl8xxxu: Implement 8723bu power on sequence
Date: Mon, 29 Feb 2016 17:04:52 -0500
Message-Id: <1456783551-28315-55-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230842_292050_820727F0)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This implements the 8723bu specific power on sequence as it is
different from that of the 8723au chips.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 183 ++++++++++++++++++++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  11 ++
 2 files changed, 189 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 7f17e69..a8b7b75 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2933,10 +2933,6 @@ static void rtl8723bu_phy_init_antenna_selection(struct rtl8xxxu_priv *priv)
 	val32 &= 0xffffff00;
 	val32 |= 0x77;
 	rtl8xxxu_write32(priv, 0x0930, val32);
-
-	val32 = rtl8xxxu_read32(priv, REG_PWR_DATA);
-	val32 |= BIT(11);
-	rtl8xxxu_write32(priv, REG_PWR_DATA, val32);
 }
 
 static int
@@ -5359,6 +5355,127 @@ exit:
 	return ret;
 }
 
+static int rtl8723b_emu_to_active(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u32 val32;
+	int count, ret = 0;
+
+	/* 0x20[0] = 1 enable LDOA12 MACRO block for all interface */
+	val8 = rtl8xxxu_read8(priv, REG_LDOA15_CTRL);
+	val8 |= LDOA15_ENABLE;
+	rtl8xxxu_write8(priv, REG_LDOA15_CTRL, val8);
+
+	/* 0x67[0] = 0 to disable BT_GPS_SEL pins*/
+	val8 = rtl8xxxu_read8(priv, 0x0067);
+	val8 &= ~BIT(4);
+	rtl8xxxu_write8(priv, 0x0067, val8);
+
+	mdelay(1);
+
+	/* 0x00[5] = 0 release analog Ips to digital, 1:isolation */
+	val8 = rtl8xxxu_read8(priv, REG_SYS_ISO_CTRL);
+	val8 &= ~SYS_ISO_ANALOG_IPS;
+	rtl8xxxu_write8(priv, REG_SYS_ISO_CTRL, val8);
+
+	/* Disable SW LPS 0x04[10]= 0 */
+	val32 = rtl8xxxu_read8(priv, REG_APS_FSMCO);
+	val32 &= ~APS_FSMCO_SW_LPS;
+	rtl8xxxu_write32(priv, REG_APS_FSMCO, val32);
+
+	/* Wait until 0x04[17] = 1 power ready */
+	for (count = RTL8XXXU_MAX_REG_POLL; count; count--) {
+		val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
+		if (val32 & BIT(17))
+			break;
+
+		udelay(10);
+	}
+
+	if (!count) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	/* We should be able to optimize the following three entries into one */
+
+	/* Release WLON reset 0x04[16]= 1*/
+	val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
+	val32 |= APS_FSMCO_WLON_RESET;
+	rtl8xxxu_write32(priv, REG_APS_FSMCO, val32);
+
+	/* Disable HWPDN 0x04[15]= 0*/
+	val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
+	val32 &= ~APS_FSMCO_HW_POWERDOWN;
+	rtl8xxxu_write32(priv, REG_APS_FSMCO, val32);
+
+	/* Disable WL suspend*/
+	val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
+	val32 &= ~(APS_FSMCO_HW_SUSPEND | APS_FSMCO_PCIE);
+	rtl8xxxu_write32(priv, REG_APS_FSMCO, val32);
+
+	/* Set, then poll until 0 */
+	val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
+	val32 |= APS_FSMCO_MAC_ENABLE;
+	rtl8xxxu_write32(priv, REG_APS_FSMCO, val32);
+
+	for (count = RTL8XXXU_MAX_REG_POLL; count; count--) {
+		val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
+		if ((val32 & APS_FSMCO_MAC_ENABLE) == 0) {
+			ret = 0;
+			break;
+		}
+		udelay(10);
+	}
+
+	if (!count) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	/* Enable WL control XTAL setting */
+	val8 = rtl8xxxu_read8(priv, REG_AFE_MISC);
+	val8 |= AFE_MISC_WL_XTAL_CTRL;
+	rtl8xxxu_write8(priv, REG_AFE_MISC, val8);
+
+	/* Enable falling edge triggering interrupt */
+	val8 = rtl8xxxu_read8(priv, REG_GPIO_INTM + 1);
+	val8 |= BIT(1);
+	rtl8xxxu_write8(priv, REG_GPIO_INTM + 1, val8);
+
+	/* Enable GPIO9 interrupt mode */
+	val8 = rtl8xxxu_read8(priv, REG_GPIO_IO_SEL_2 + 1);
+	val8 |= BIT(1);
+	rtl8xxxu_write8(priv, REG_GPIO_IO_SEL_2 + 1, val8);
+
+	/* Enable GPIO9 input mode */
+	val8 = rtl8xxxu_read8(priv, REG_GPIO_IO_SEL_2);
+	val8 &= ~BIT(1);
+	rtl8xxxu_write8(priv, REG_GPIO_IO_SEL_2, val8);
+
+	/* Enable HSISR GPIO[C:0] interrupt */
+	val8 = rtl8xxxu_read8(priv, REG_HSIMR);
+	val8 |= BIT(0);
+	rtl8xxxu_write8(priv, REG_HSIMR, val8);
+
+	/* Enable HSISR GPIO9 interrupt */
+	val8 = rtl8xxxu_read8(priv, REG_HSIMR + 2);
+	val8 |= BIT(1);
+	rtl8xxxu_write8(priv, REG_HSIMR + 2, val8);
+
+	val8 = rtl8xxxu_read8(priv, REG_MULTI_FUNC_CTRL);
+	val8 |= MULTI_WIFI_HW_ROF_EN;
+	rtl8xxxu_write8(priv, REG_MULTI_FUNC_CTRL, val8);
+
+	/* For GPIO9 internal pull high setting BIT(14) */
+	val8 = rtl8xxxu_read8(priv, REG_MULTI_FUNC_CTRL + 1);
+	val8 |= BIT(6);
+	rtl8xxxu_write8(priv, REG_MULTI_FUNC_CTRL + 1, val8);
+
+exit:
+	return ret;
+}
+
 static int rtl8xxxu_emu_to_disabled(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -5430,6 +5547,62 @@ exit:
 	return ret;
 }
 
+static int rtl8723bu_power_on(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u16 val16;
+	u32 val32;
+	int ret;
+
+	rtl8723a_disabled_to_emu(priv);
+
+	ret = rtl8723b_emu_to_active(priv);
+	if (ret)
+		goto exit;
+
+	/*
+	 * Enable MAC DMA/WMAC/SCHEDULE/SEC block
+	 * Set CR bit10 to enable 32k calibration.
+	 */
+	val16 = rtl8xxxu_read16(priv, REG_CR);
+	val16 |= (CR_HCI_TXDMA_ENABLE | CR_HCI_RXDMA_ENABLE |
+		  CR_TXDMA_ENABLE | CR_RXDMA_ENABLE |
+		  CR_PROTOCOL_ENABLE | CR_SCHEDULE_ENABLE |
+		  CR_MAC_TX_ENABLE | CR_MAC_RX_ENABLE |
+		  CR_SECURITY_ENABLE | CR_CALTIMER_ENABLE);
+	rtl8xxxu_write16(priv, REG_CR, val16);
+
+	/*
+	 * BT coexist power on settings. This is identical for 1 and 2
+	 * antenna parts.
+	 */
+	rtl8xxxu_write8(priv, REG_PAD_CTRL1 + 3, 0x20);
+
+	val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+	val16 |= SYS_FUNC_BBRSTB | SYS_FUNC_BB_GLB_RSTN;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
+
+	rtl8xxxu_write8(priv, REG_BT_CONTROL_8723BU + 1, 0x18);
+	rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
+	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
+	/* Antenna inverse */
+	rtl8xxxu_write8(priv, 0xfe08, 0x01);
+
+	val16 = rtl8xxxu_read16(priv, REG_PWR_DATA);
+	val16 |= PWR_DATA_EEPRPAD_RFE_CTRL_EN;
+	rtl8xxxu_write16(priv, REG_PWR_DATA, val16);
+
+	val32 = rtl8xxxu_read32(priv, REG_LEDCFG0);
+	val32 |= LEDCFG0_DPDT_SELECT;
+	rtl8xxxu_write32(priv, REG_LEDCFG0, val32);
+
+	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
+	val8 &= ~PAD_CTRL1_SW_DPDT_SEL_DATA;
+	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
+exit:
+	return ret;
+}
+
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 
 static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
@@ -7707,7 +7880,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.parse_efuse = rtl8723bu_parse_efuse,
 	.load_firmware = rtl8723bu_load_firmware,
-	.power_on = rtl8723au_power_on,
+	.power_on = rtl8723bu_power_on,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index a82c0ba..5250388 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -70,6 +70,8 @@
 
 #define REG_EE_VPD			0x000c
 #define REG_AFE_MISC			0x0010
+#define  AFE_MISC_WL_XTAL_CTRL		BIT(6)
+
 #define REG_SPS0_CTRL			0x0011
 #define REG_SPS_OCP_CFG			0x0018
 #define REG_8192E_LDOV12_CTRL		0x0014
@@ -133,6 +135,8 @@
 #define  EFUSE_ACCESS_DISABLE		0x00	/* RTL8723 only */
 
 #define REG_PWR_DATA			0x0038
+#define PWR_DATA_EEPRPAD_RFE_CTRL_EN	BIT(11)
+
 #define REG_CAL_TIMER			0x003c
 #define REG_ACLK_MON			0x003e
 #define REG_GPIO_MUXCFG			0x0040
@@ -140,7 +144,10 @@
 #define REG_MAC_PINMUX_CFG		0x0043
 #define REG_GPIO_PIN_CTRL		0x0044
 #define REG_GPIO_INTM			0x0048
+#define  GPIO_INTM_EDGE_TRIG_IRQ	BIT(9)
+
 #define REG_LEDCFG0			0x004c
+#define  LEDCFG0_DPDT_SELECT		BIT(23)
 #define REG_LEDCFG1			0x004d
 #define REG_LEDCFG2			0x004e
 #define  LEDCFG2_DPDT_SELECT		BIT(7)
@@ -154,9 +161,13 @@
 #define REG_GPIO_PIN_CTRL_2		0x0060
 /*  RTL8723 WIFI/BT/GPS Multi-Function GPIO Select. */
 #define REG_GPIO_IO_SEL_2		0x0062
+#define  GPIO_IO_SEL_2_GPIO09_INPUT	BIT(1)
+#define  GPIO_IO_SEL_2_GPIO09_IRQ	BIT(9)
 
 /*  RTL8723B */
 #define REG_PAD_CTRL1			0x0064
+#define  PAD_CTRL1_SW_DPDT_SEL_DATA	BIT(0)
+
 /*  RTL8723 only WIFI/BT/GPS Multi-Function control source. */
 #define REG_MULTI_FUNC_CTRL		0x0068
 
-- 
2.5.0

