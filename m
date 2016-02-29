Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 005/113] rtl8xxxu: Implment rtl8192eu_power_on()
Date: Mon, 29 Feb 2016 17:04:03 -0500
Message-Id: <1456783551-28315-6-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231124_885714_0D55D1BB)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This implements the rtl8192eu power on sequence, and splits it off
from the rtl8192cu/rtl8723au power on sequence.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 133 ++++++++++++++++++++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   6 +
 2 files changed, 133 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 5413e35..5f30ae9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3791,7 +3791,7 @@ exit:
 	return ret;
 }
 
-static void rtl8xxxu_disabled_to_emu(struct rtl8xxxu_priv *priv)
+static void rtl8723a_disabled_to_emu(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
 
@@ -3811,7 +3811,82 @@ static void rtl8xxxu_disabled_to_emu(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
 }
 
-static int rtl8xxxu_emu_to_active(struct rtl8xxxu_priv *priv)
+static void rtl8192e_disabled_to_emu(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+
+	/* Clear suspend enable and power down enable*/
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+	val8 &= ~(BIT(3) | BIT(4));
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
+}
+
+static int rtl8192e_emu_to_active(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u32 val32;
+	int count, ret = 0;
+
+	/* disable HWPDN 0x04[15]=0*/
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+	val8 &= ~BIT(7);
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
+
+	/* disable SW LPS 0x04[10]= 0 */
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+	val8 &= ~BIT(2);
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
+
+	/* disable WL suspend*/
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+	val8 &= ~(BIT(3) | BIT(4));
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
+
+	/* wait till 0x04[17] = 1 power ready*/
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
+	/* release WLON reset 0x04[16]= 1*/
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 2);
+	val8 |= BIT(0);
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 2, val8);
+
+	/* set, then poll until 0 */
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
+exit:
+	return ret;
+}
+
+static int rtl8723a_emu_to_active(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
 	u32 val32;
@@ -3940,9 +4015,9 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
 	 */
 	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0);
 
-	rtl8xxxu_disabled_to_emu(priv);
+	rtl8723a_disabled_to_emu(priv);
 
-	ret = rtl8xxxu_emu_to_active(priv);
+	ret = rtl8723a_emu_to_active(priv);
 	if (ret)
 		goto exit;
 
@@ -4081,6 +4156,52 @@ static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
 
 #endif
 
+static int rtl8192eu_power_on(struct rtl8xxxu_priv *priv)
+{
+	u16 val16;
+	u32 val32;
+	int ret;
+
+	ret = 0;
+
+	val32 = rtl8xxxu_read32(priv, REG_SYS_CFG);
+	if (val32 & SYS_CFG_SPS_LDO_SEL) {
+		rtl8xxxu_write8(priv, REG_LDO_SW_CTRL, 0xc3);
+	} else {
+		/*
+		 * Raise 1.2V voltage
+		 */
+		val32 = rtl8xxxu_read32(priv, REG_8192E_LDOV12_CTRL);
+		val32 &= 0xff0fffff;
+		val32 |= 0x00500000;
+		rtl8xxxu_write32(priv, REG_8192E_LDOV12_CTRL, val32);
+		rtl8xxxu_write8(priv, REG_LDO_SW_CTRL, 0x83);
+	}
+
+	rtl8192e_disabled_to_emu(priv);
+
+	ret = rtl8192e_emu_to_active(priv);
+	if (ret)
+		goto exit;
+
+	rtl8xxxu_write16(priv, REG_CR, 0x0000);
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
+exit:
+	return ret;
+}
+
 static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -5975,8 +6096,8 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.parse_efuse = rtl8192eu_parse_efuse,
 	.load_firmware = rtl8192eu_load_firmware,
-	.power_on = rtl8192cu_power_on,
-	.writeN_block_size = 1024,
+	.power_on = rtl8192eu_power_on,
+	.writeN_block_size = 128,
 };
 
 static struct usb_device_id dev_table[] = {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index a934c0d..02c7d6c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -72,6 +72,7 @@
 #define REG_AFE_MISC			0x0010
 #define REG_SPS0_CTRL			0x0011
 #define REG_SPS_OCP_CFG			0x0018
+#define REG_8192E_LDOV12_CTRL		0x0014
 #define REG_RSV_CTRL			0x001c
 
 #define REG_RF_CTRL			0x001f
@@ -178,6 +179,8 @@
 						   control */
 #define  MULTI_GPS_FUNC_EN		BIT(22)	/* GPS function enable */
 
+#define REG_LDO_SW_CTRL			0x007c	/* 8192eu */
+
 #define REG_MCU_FW_DL			0x0080
 #define  MCU_FW_DL_ENABLE		BIT(0)
 #define  MCU_FW_DL_READY		BIT(1)
@@ -229,6 +232,7 @@
 #define  SYS_CFG_PAD_HWPD_IDN		BIT(22)
 #define  SYS_CFG_TRP_VAUX_EN		BIT(23)
 #define  SYS_CFG_TRP_BT_EN		BIT(24)
+#define  SYS_CFG_SPS_LDO_SEL		BIT(24)	/* 8192eu */
 #define  SYS_CFG_BD_PKG_SEL		BIT(25)
 #define  SYS_CFG_BD_HCI_SEL		BIT(26)
 #define  SYS_CFG_TYPE_ID		BIT(27)
@@ -261,6 +265,8 @@
 #define  GPIO_USB_SUSEN			BIT(23)
 #define  GPIO_RF_RL_ID			(BIT(31) | BIT(30) | BIT(29) | BIT(28))
 
+#define REG_SYS_CFG2			0x00fc	/* 8192eu */
+
 /* 0x0100 ~ 0x01FF	MACTOP General Configuration */
 #define REG_CR				0x0100
 #define  CR_HCI_TXDMA_ENABLE		BIT(0)
-- 
2.5.0

