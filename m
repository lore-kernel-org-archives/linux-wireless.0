Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbcB2WGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:05 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 109/113] rtl8xxxu: Implement device specific power_off function
Date: Mon, 29 Feb 2016 17:05:47 -0500
Message-Id: <1456783551-28315-110-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230631_818302_D0CE5129)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Implment 8723bu specific device power down, and make power_off() a
fileops function.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 98 +++++++++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  2 +
 3 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 1095c18..7f68b61 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5240,6 +5240,64 @@ exit:
 	return ret;
 }
 
+static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u16 val16;
+	u32 val32;
+	int count, ret;
+
+	/* Turn off RF */
+	rtl8xxxu_write8(priv, REG_RF_CTRL, 0);
+
+	/* Enable rising edge triggering interrupt */
+	val16 = rtl8xxxu_read16(priv, REG_GPIO_INTM);
+	val16 &= ~GPIO_INTM_EDGE_TRIG_IRQ;
+	rtl8xxxu_write16(priv, REG_GPIO_INTM, val16);
+
+	/* Release WLON reset 0x04[16]= 1*/
+	val32 = rtl8xxxu_read32(priv, REG_GPIO_INTM);
+	val32 |= APS_FSMCO_WLON_RESET;
+	rtl8xxxu_write32(priv, REG_GPIO_INTM, val32);
+
+	/* 0x0005[1] = 1 turn off MAC by HW state machine*/
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+	val8 |= BIT(1);
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
+
+	for (count = RTL8XXXU_MAX_REG_POLL; count; count--) {
+		val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+		if ((val8 & BIT(1)) == 0)
+			break;
+		udelay(10);
+	}
+
+	if (!count) {
+		dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n",
+			 __func__);
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	/* Enable BT control XTAL setting */
+	val8 = rtl8xxxu_read8(priv, REG_AFE_MISC);
+	val8 &= ~AFE_MISC_WL_XTAL_CTRL;
+	rtl8xxxu_write8(priv, REG_AFE_MISC, val8);
+
+	/* 0x0000[5] = 1 analog Ips to digital, 1:isolation */
+	val8 = rtl8xxxu_read8(priv, REG_SYS_ISO_CTRL);
+	val8 |= SYS_ISO_ANALOG_IPS;
+	rtl8xxxu_write8(priv, REG_SYS_ISO_CTRL, val8);
+
+	/* 0x0020[0] = 0 disable LDOA12 MACRO block*/
+	val8 = rtl8xxxu_read8(priv, REG_LDOA15_CTRL);
+	val8 &= ~LDOA15_ENABLE;
+	rtl8xxxu_write8(priv, REG_LDOA15_CTRL, val8);
+
+exit:
+	return ret;
+}
+
 static int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -5932,6 +5990,38 @@ static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0e);
 }
 
+static void rtl8723bu_power_off(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u16 val16;
+
+	/*
+	 * Disable TX report timer
+	 */
+	val8 = rtl8xxxu_read8(priv, REG_TX_REPORT_CTRL);
+	val8 &= ~TX_REPORT_CTRL_TIMER_ENABLE;
+	rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL, val8);
+
+	rtl8xxxu_write16(priv, REG_CR, 0x0000);
+
+	rtl8xxxu_active_to_lps(priv);
+
+	/* Reset Firmware if running in RAM */
+	if (rtl8xxxu_read8(priv, REG_MCU_FW_DL) & MCU_FW_RAM_SEL)
+		rtl8xxxu_firmware_self_reset(priv);
+
+	/* Reset MCU */
+	val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+	val16 &= ~SYS_FUNC_CPU_ENABLE;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
+
+	/* Reset MCU ready status */
+	rtl8xxxu_write8(priv, REG_MCU_FW_DL, 0x00);
+
+	rtl8723bu_active_to_emu(priv);
+	rtl8xxxu_emu_to_disabled(priv);
+}
+
 #ifdef NEED_PS_TDMA
 static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
 				  u8 arg1, u8 arg2, u8 arg3, u8 arg4, u8 arg5)
@@ -6152,7 +6242,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		 */
 		if (priv->rtlchip == 0x8723bu) {
 			val8 = rtl8xxxu_read8(priv, REG_TX_REPORT_CTRL);
-			val8 |= BIT(1);
+			val8 |= TX_REPORT_CTRL_TIMER_ENABLE;
 			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL, val8);
 			/* Set MAX RPT MACID */
 			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL + 1, 0x02);
@@ -6545,7 +6635,7 @@ static void rtl8xxxu_disable_device(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 
-	rtl8xxxu_power_off(priv);
+	priv->fops->power_off(priv);
 }
 
 static void rtl8xxxu_cam_write(struct rtl8xxxu_priv *priv,
@@ -8277,6 +8367,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.parse_efuse = rtl8723au_parse_efuse,
 	.load_firmware = rtl8723au_load_firmware,
 	.power_on = rtl8723au_power_on,
+	.power_off = rtl8xxxu_power_off,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
@@ -8300,6 +8391,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.parse_efuse = rtl8723bu_parse_efuse,
 	.load_firmware = rtl8723bu_load_firmware,
 	.power_on = rtl8723bu_power_on,
+	.power_off = rtl8723bu_power_off,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
@@ -8329,6 +8421,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.parse_efuse = rtl8192cu_parse_efuse,
 	.load_firmware = rtl8192cu_load_firmware,
 	.power_on = rtl8192cu_power_on,
+	.power_off = rtl8xxxu_power_off,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
@@ -8354,6 +8447,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.parse_efuse = rtl8192eu_parse_efuse,
 	.load_firmware = rtl8192eu_load_firmware,
 	.power_on = rtl8192eu_power_on,
+	.power_off = rtl8xxxu_power_off,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 9c535e8..bfa9d6c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1257,6 +1257,7 @@ struct rtl8xxxu_fileops {
 	int (*parse_efuse) (struct rtl8xxxu_priv *priv);
 	int (*load_firmware) (struct rtl8xxxu_priv *priv);
 	int (*power_on) (struct rtl8xxxu_priv *priv);
+	void (*power_off) (struct rtl8xxxu_priv *priv);
 	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index e0b9ea3..a8d5c9f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -512,6 +512,8 @@
 #define REG_PKT_LOSE_RPT		0x04e1
 #define REG_PTCL_ERR_STATUS		0x04e2
 #define REG_TX_REPORT_CTRL		0x04ec
+#define  TX_REPORT_CTRL_TIMER_ENABLE	BIT(1)
+
 #define REG_TX_REPORT_TIME		0x04f0
 #define REG_DUMMY			0x04fc
 
-- 
2.5.0

