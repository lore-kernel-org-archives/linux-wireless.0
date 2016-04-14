Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 16/26] rtl8xxxu: Split rtl8xxxu_init_phy_bb() into device specific functions
Date: Thu, 14 Apr 2016 14:58:57 -0400
Message-Id: <1460660347-26299-17-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205940_599982_9BDAAC88)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This reduces the if () clutter. Longer term it probably makes sense to
split this between gen1 (8723au/8188cu/8192cu) and gen2
(8192eu/8723bu) devices.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 134 +++++++++++++----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |   1 +
 2 files changed, 77 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3c45ad0..43359a3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3717,76 +3717,36 @@ static int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 	return 0;
 }
 
-/*
- * Most of this is black magic retrieved from the old rtl8723au driver
- */
-static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
+static void rtl8723au_init_phy_bb(struct rtl8xxxu_priv *priv)
 {
-	u8 val8, ldoa15, ldov12d, lpldo, ldohci12;
+	u8 val8;
 	u16 val16;
 	u32 val32;
 
-	/*
-	 * Todo: The vendor driver maintains a table of PHY register
-	 *       addresses, which is initialized here. Do we need this?
-	 */
-
-	if (priv->rtl_chip == RTL8723B) {
-		val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
-		val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB |
-			SYS_FUNC_DIO_RF;
-		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
-
-		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
-	} else if (priv->rtl_chip == RTL8192E) {
-		val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
-		val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB |
-			SYS_FUNC_DIO_RF;
-		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
-	} else {
-		val8 = rtl8xxxu_read8(priv, REG_AFE_PLL_CTRL);
-		udelay(2);
-		val8 |= AFE_PLL_320_ENABLE;
-		rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL, val8);
-		udelay(2);
+	val8 = rtl8xxxu_read8(priv, REG_AFE_PLL_CTRL);
+	udelay(2);
+	val8 |= AFE_PLL_320_ENABLE;
+	rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL, val8);
+	udelay(2);
 
-		rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL + 1, 0xff);
-		udelay(2);
+	rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL + 1, 0xff);
+	udelay(2);
 
-		val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
-		val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB;
-		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
-	}
+	val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+	val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
 
-	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E) {
-		/* AFE_XTAL_RF_GATE (bit 14) if addressing as 32 bit register */
-		val32 = rtl8xxxu_read32(priv, REG_AFE_XTAL_CTRL);
-		val32 &= ~AFE_XTAL_RF_GATE;
-		if (priv->has_bluetooth)
-			val32 &= ~AFE_XTAL_BT_GATE;
-		rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, val32);
-	}
+	val32 = rtl8xxxu_read32(priv, REG_AFE_XTAL_CTRL);
+	val32 &= ~AFE_XTAL_RF_GATE;
+	if (priv->has_bluetooth)
+		val32 &= ~AFE_XTAL_BT_GATE;
+	rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, val32);
 
 	/* 6. 0x1f[7:0] = 0x07 */
 	val8 = RF_ENABLE | RF_RSTB | RF_SDMRSTB;
 	rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
 
-	if (priv->rtl_chip == RTL8723B) {
-		/*
-		 * Why?
-		 */
-		rtl8xxxu_write8(priv, REG_SYS_FUNC, 0xe3);
-		rtl8xxxu_write8(priv, REG_AFE_XTAL_CTRL + 1, 0x80);
-		rtl8xxxu_init_phy_regs(priv, rtl8723b_phy_1t_init_table);
-	} else if (priv->rtl_chip == RTL8192E) {
-		val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
-		val16 |= (SYS_FUNC_USBA | SYS_FUNC_USBD | SYS_FUNC_DIO_RF |
-			  SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB);
-		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
-		val8 = RF_ENABLE | RF_RSTB | RF_SDMRSTB;
-		rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
-		rtl8xxxu_init_phy_regs(priv, rtl8192eu_phy_init_table);
-	} else	if (priv->hi_pa)
+	if (priv->hi_pa)
 		rtl8xxxu_init_phy_regs(priv, rtl8188ru_phy_1t_highpa_table);
 	else if (priv->tx_paths == 2)
 		rtl8xxxu_init_phy_regs(priv, rtl8192cu_phy_2t_init_table);
@@ -3796,6 +3756,60 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	if (priv->rtl_chip == RTL8188C && priv->hi_pa &&
 	    priv->vendor_umc && priv->chip_cut == 1)
 		rtl8xxxu_write8(priv, REG_OFDM0_AGC_PARM1 + 2, 0x50);
+}
+
+static void rtl8723bu_init_phy_bb(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u16 val16;
+
+	val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+	val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB | SYS_FUNC_DIO_RF;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
+
+	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
+
+	/* 6. 0x1f[7:0] = 0x07 */
+	val8 = RF_ENABLE | RF_RSTB | RF_SDMRSTB;
+	rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
+
+	/* Why? */
+	rtl8xxxu_write8(priv, REG_SYS_FUNC, 0xe3);
+	rtl8xxxu_write8(priv, REG_AFE_XTAL_CTRL + 1, 0x80);
+	rtl8xxxu_init_phy_regs(priv, rtl8723b_phy_1t_init_table);
+}
+
+static void rtl8192eu_init_phy_bb(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u16 val16;
+
+	val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+	val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB | SYS_FUNC_DIO_RF;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
+
+	/* 6. 0x1f[7:0] = 0x07 */
+	val8 = RF_ENABLE | RF_RSTB | RF_SDMRSTB;
+	rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
+
+	val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+	val16 |= (SYS_FUNC_USBA | SYS_FUNC_USBD | SYS_FUNC_DIO_RF |
+		  SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB);
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
+	val8 = RF_ENABLE | RF_RSTB | RF_SDMRSTB;
+	rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
+	rtl8xxxu_init_phy_regs(priv, rtl8192eu_phy_init_table);
+}
+
+/*
+ * Most of this is black magic retrieved from the old rtl8723au driver
+ */
+static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
+{
+	u8 val8, ldoa15, ldov12d, lpldo, ldohci12;
+	u32 val32;
+
+	priv->fops->init_phy_bb(priv);
 
 	if (priv->tx_paths == 1 && priv->rx_paths == 2) {
 		/*
@@ -9709,6 +9723,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.power_off = rtl8xxxu_power_off,
 	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_init_llt_table,
+	.init_phy_bb = rtl8723au_init_phy_bb,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
@@ -9736,6 +9751,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.power_off = rtl8723bu_power_off,
 	.reset_8051 = rtl8723bu_reset_8051,
 	.llt_init = rtl8xxxu_auto_llt_table,
+	.init_phy_bb = rtl8723bu_init_phy_bb,
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
@@ -9769,6 +9785,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.power_off = rtl8xxxu_power_off,
 	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_init_llt_table,
+	.init_phy_bb = rtl8723au_init_phy_bb,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
@@ -9798,6 +9815,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.power_off = rtl8xxxu_power_off,
 	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_auto_llt_table,
+	.init_phy_bb = rtl8192eu_init_phy_bb,
 	.phy_iq_calibrate = rtl8192eu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc24,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 2f0709e..28874fa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1284,6 +1284,7 @@ struct rtl8xxxu_fileops {
 	void (*power_off) (struct rtl8xxxu_priv *priv);
 	void (*reset_8051) (struct rtl8xxxu_priv *priv);
 	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
+	void (*init_phy_bb) (struct rtl8xxxu_priv *priv);
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
 	void (*config_channel) (struct ieee80211_hw *hw);
-- 
2.5.5

