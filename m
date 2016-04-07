Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318AbcDGSTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:35 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 17/18] rtl8xxxu: Implement IQK calibration for 8192eu
Date: Thu,  7 Apr 2016 14:19:32 -0400
Message-Id: <1460053173-8494-18-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_201955_559534_A053021F)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

8192eu has it's own IQK calibration procedure, and notably uses
undocumented RF register 0x56 in the process.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 608 ++++++++++++++++++++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   1 +
 2 files changed, 608 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 604deb4..61c0ece 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4955,6 +4955,334 @@ out:
 }
 #endif
 
+static int rtl8192eu_iqk_path_a(struct rtl8xxxu_priv *priv)
+{
+	u32 reg_eac, reg_e94, reg_e9c;
+	int result = 0;
+
+	/*
+	 * TX IQK
+	 * PA/PAD controlled by 0x0
+	 */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x00180);
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+
+	/* Path A IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x18008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82140303);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x68160000);
+
+	/* LO calibration setting */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00462911);
+
+	/* One shot, path A LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf9000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
+
+	mdelay(10);
+
+	/* Check failed */
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_e94 = rtl8xxxu_read32(priv, REG_TX_POWER_BEFORE_IQK_A);
+	reg_e9c = rtl8xxxu_read32(priv, REG_TX_POWER_AFTER_IQK_A);
+
+	if (!(reg_eac & BIT(28)) &&
+	    ((reg_e94 & 0x03ff0000) != 0x01420000) &&
+	    ((reg_e9c & 0x03ff0000) != 0x00420000))
+		result |= 0x01;
+
+	return result;
+}
+
+static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
+{
+	u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
+	int result = 0;
+
+	/* Leave IQK mode */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00);
+
+	/* Enable path A PA in TX IQK mode */
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf117b);
+
+	/* PA/PAD control by 0x56, and set = 0x0 */
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x00980);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x51000);
+
+	/* Enter IQK mode */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+
+	/* TX IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK, 0x01007c00);
+	rtl8xxxu_write32(priv, REG_RX_IQK, 0x01004800);
+
+	/* path-A IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x18008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x68160c1f);
+
+	/* LO calibration setting */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a911);
+
+	/* One shot, path A LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
+
+	mdelay(10);
+
+	/* Check failed */
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_e94 = rtl8xxxu_read32(priv, REG_TX_POWER_BEFORE_IQK_A);
+	reg_e9c = rtl8xxxu_read32(priv, REG_TX_POWER_AFTER_IQK_A);
+
+	if (!(reg_eac & BIT(28)) &&
+	    ((reg_e94 & 0x03ff0000) != 0x01420000) &&
+	    ((reg_e9c & 0x03ff0000) != 0x00420000)) {
+		result |= 0x01;
+	} else {
+		/* PA/PAD controlled by 0x0 */
+		rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x180);
+		goto out;
+	}
+
+	val32 = 0x80007c00 |
+		(reg_e94 & 0x03ff0000) | ((reg_e9c >> 16) & 0x03ff);
+	rtl8xxxu_write32(priv, REG_TX_IQK, val32);
+
+	/* Modify RX IQK mode table */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf7ffa);
+
+	/* PA/PAD control by 0x56, and set = 0x0 */
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x00980);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x51000);
+
+	/* Enter IQK mode */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+
+	/* IQK setting */
+	rtl8xxxu_write32(priv, REG_RX_IQK, 0x01004800);
+
+	/* Path A IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x18008c1c);
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x28160c1f);
+
+	/* LO calibration setting */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a891);
+
+	/* One shot, path A LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
+
+	mdelay(10);
+
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_ea4 = rtl8xxxu_read32(priv, REG_RX_POWER_BEFORE_IQK_A_2);
+
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x180);
+
+	if (!(reg_eac & BIT(27)) &&
+	    ((reg_ea4 & 0x03ff0000) != 0x01320000) &&
+	    ((reg_eac & 0x03ff0000) != 0x00360000))
+		result |= 0x02;
+	else
+		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
+			 __func__);
+
+out:
+	return result;
+}
+
+static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
+{
+	u32 reg_eac, reg_eb4, reg_ebc;
+	int result = 0;
+
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00180);
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+
+	/* Path B IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x821403e2);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160000);
+
+	/* LO calibration setting */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00492911);
+
+	/* One shot, path A LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
+
+	mdelay(1);
+
+	/* Check failed */
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_eb4 = rtl8xxxu_read32(priv, REG_TX_POWER_BEFORE_IQK_B);
+	reg_ebc = rtl8xxxu_read32(priv, REG_TX_POWER_AFTER_IQK_B);
+
+	if (!(reg_eac & BIT(31)) &&
+	    ((reg_eb4 & 0x03ff0000) != 0x01420000) &&
+	    ((reg_ebc & 0x03ff0000) != 0x00420000))
+		result |= 0x01;
+	else
+		dev_warn(&priv->udev->dev, "%s: Path B IQK failed!\n",
+			 __func__);
+
+	return result;
+}
+
+static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
+{
+	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, val32;
+	int result = 0;
+
+	/* Leave IQK mode */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+
+	/* Enable path A PA in TX IQK mode */
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf117b);
+
+	/* PA/PAD control by 0x56, and set = 0x0 */
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00980);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x51000);
+
+	/* Enter IQK mode */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+
+	/* TX IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK, 0x01007c00);
+	rtl8xxxu_write32(priv, REG_RX_IQK, 0x01004800);
+
+	/* path-A IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82160c1f);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160c1f);
+
+	/* LO calibration setting */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a911);
+
+	/* One shot, path A LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
+
+	mdelay(10);
+
+	/* Check failed */
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_eb4 = rtl8xxxu_read32(priv, REG_TX_POWER_BEFORE_IQK_B);
+	reg_ebc = rtl8xxxu_read32(priv, REG_TX_POWER_AFTER_IQK_B);
+
+	if (!(reg_eac & BIT(31)) &&
+	    ((reg_eb4 & 0x03ff0000) != 0x01420000) &&
+	    ((reg_ebc & 0x03ff0000) != 0x00420000)) {
+		result |= 0x01;
+	} else {
+		/*
+		 * PA/PAD controlled by 0x0
+		 * Vendor driver restores RF_A here which I believe is a bug
+		 */
+		rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+		rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x180);
+		goto out;
+	}
+
+	val32 = 0x80007c00 |
+		(reg_eb4 & 0x03ff0000) | ((reg_ebc >> 16) & 0x03ff);
+	rtl8xxxu_write32(priv, REG_TX_IQK, val32);
+
+	/* Modify RX IQK mode table */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ffa);
+
+	/* PA/PAD control by 0x56, and set = 0x0 */
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00980);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x51000);
+
+	/* Enter IQK mode */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+
+	/* IQK setting */
+	rtl8xxxu_write32(priv, REG_RX_IQK, 0x01004800);
+
+	/* Path A IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x18008c1c);
+
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x28160c1f);
+
+	/* LO calibration setting */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a891);
+
+	/* One shot, path A LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
+
+	mdelay(10);
+
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_ec4 = rtl8xxxu_read32(priv, REG_RX_POWER_BEFORE_IQK_B_2);
+	reg_ecc = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_B_2);
+
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x180);
+
+	if (!(reg_eac & BIT(30)) &&
+	    ((reg_ec4 & 0x03ff0000) != 0x01320000) &&
+	    ((reg_ecc & 0x03ff0000) != 0x00360000))
+		result |= 0x02;
+	else
+		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
+			 __func__);
+
+out:
+	return result;
+}
+
 static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 				     int result[][8], int t)
 {
@@ -5385,6 +5713,194 @@ static void rtl8723bu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	}
 }
 
+static void rtl8192eu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
+				      int result[][8], int t)
+{
+	struct device *dev = &priv->udev->dev;
+	u32 i, val32;
+	int path_a_ok, path_b_ok;
+	int retry = 2;
+	const u32 adda_regs[RTL8XXXU_ADDA_REGS] = {
+		REG_FPGA0_XCD_SWITCH_CTRL, REG_BLUETOOTH,
+		REG_RX_WAIT_CCA, REG_TX_CCK_RFON,
+		REG_TX_CCK_BBON, REG_TX_OFDM_RFON,
+		REG_TX_OFDM_BBON, REG_TX_TO_RX,
+		REG_TX_TO_TX, REG_RX_CCK,
+		REG_RX_OFDM, REG_RX_WAIT_RIFS,
+		REG_RX_TO_RX, REG_STANDBY,
+		REG_SLEEP, REG_PMPD_ANAEN
+	};
+	const u32 iqk_mac_regs[RTL8XXXU_MAC_REGS] = {
+		REG_TXPAUSE, REG_BEACON_CTRL,
+		REG_BEACON_CTRL_1, REG_GPIO_MUXCFG
+	};
+	const u32 iqk_bb_regs[RTL8XXXU_BB_REGS] = {
+		REG_OFDM0_TRX_PATH_ENABLE, REG_OFDM0_TR_MUX_PAR,
+		REG_FPGA0_XCD_RF_SW_CTRL, REG_CONFIG_ANT_A, REG_CONFIG_ANT_B,
+		REG_FPGA0_XAB_RF_SW_CTRL, REG_FPGA0_XA_RF_INT_OE,
+		REG_FPGA0_XB_RF_INT_OE, REG_CCK0_AFE_SETTING
+	};
+	u8 xa_agc = rtl8xxxu_read32(priv, REG_OFDM0_XA_AGC_CORE1) & 0xff;
+	u8 xb_agc = rtl8xxxu_read32(priv, REG_OFDM0_XB_AGC_CORE1) & 0xff;
+
+	/*
+	 * Note: IQ calibration must be performed after loading
+	 *       PHY_REG.txt , and radio_a, radio_b.txt
+	 */
+
+	if (t == 0) {
+		/* Save ADDA parameters, turn Path A ADDA on */
+		rtl8xxxu_save_regs(priv, adda_regs, priv->adda_backup,
+				   RTL8XXXU_ADDA_REGS);
+		rtl8xxxu_save_mac_regs(priv, iqk_mac_regs, priv->mac_backup);
+		rtl8xxxu_save_regs(priv, iqk_bb_regs,
+				   priv->bb_backup, RTL8XXXU_BB_REGS);
+	}
+
+	rtl8xxxu_path_adda_on(priv, adda_regs, true);
+
+	/* MAC settings */
+	rtl8xxxu_mac_calibration(priv, iqk_mac_regs, priv->mac_backup);
+
+	val32 = rtl8xxxu_read32(priv, REG_CCK0_AFE_SETTING);
+	val32 |= 0x0f000000;
+	rtl8xxxu_write32(priv, REG_CCK0_AFE_SETTING, val32);
+
+	rtl8xxxu_write32(priv, REG_OFDM0_TRX_PATH_ENABLE, 0x03a05600);
+	rtl8xxxu_write32(priv, REG_OFDM0_TR_MUX_PAR, 0x000800e4);
+	rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_SW_CTRL, 0x22208200);
+
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_XAB_RF_SW_CTRL);
+	val32 |= (FPGA0_RF_PAPE | (FPGA0_RF_PAPE << FPGA0_RF_BD_CTRL_SHIFT));
+	rtl8xxxu_write32(priv, REG_FPGA0_XAB_RF_SW_CTRL, val32);
+
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_XA_RF_INT_OE);
+	val32 |= BIT(10);
+	rtl8xxxu_write32(priv, REG_FPGA0_XA_RF_INT_OE, val32);
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_XB_RF_INT_OE);
+	val32 |= BIT(10);
+	rtl8xxxu_write32(priv, REG_FPGA0_XB_RF_INT_OE, val32);
+
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+	rtl8xxxu_write32(priv, REG_TX_IQK, 0x01007c00);
+	rtl8xxxu_write32(priv, REG_RX_IQK, 0x01004800);
+
+	for (i = 0; i < retry; i++) {
+		path_a_ok = rtl8192eu_iqk_path_a(priv);
+		if (path_a_ok == 0x01) {
+			val32 = rtl8xxxu_read32(priv,
+						REG_TX_POWER_BEFORE_IQK_A);
+			result[t][0] = (val32 >> 16) & 0x3ff;
+			val32 = rtl8xxxu_read32(priv,
+						REG_TX_POWER_AFTER_IQK_A);
+			result[t][1] = (val32 >> 16) & 0x3ff;
+
+			break;
+		}
+	}
+
+	if (!path_a_ok)
+		dev_dbg(dev, "%s: Path A TX IQK failed!\n", __func__);
+
+	for (i = 0; i < retry; i++) {
+		path_a_ok = rtl8192eu_rx_iqk_path_a(priv);
+		if (path_a_ok == 0x03) {
+			val32 = rtl8xxxu_read32(priv,
+						REG_RX_POWER_BEFORE_IQK_A_2);
+			result[t][2] = (val32 >> 16) & 0x3ff;
+			val32 = rtl8xxxu_read32(priv,
+						REG_RX_POWER_AFTER_IQK_A_2);
+			result[t][3] = (val32 >> 16) & 0x3ff;
+
+			break;
+		}
+	}
+
+	if (!path_a_ok)
+		dev_dbg(dev, "%s: Path A RX IQK failed!\n", __func__);
+
+	if (priv->rf_paths > 1) {
+		dev_warn(dev, "%s: Path B ongoing\n", __func__);
+
+		/* Path A into standby */
+		rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_AC, 0x10000);
+		rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+
+		/* Turn Path B ADDA on */
+		rtl8xxxu_path_adda_on(priv, adda_regs, false);
+
+		rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+		rtl8xxxu_write32(priv, REG_TX_IQK, 0x01007c00);
+		rtl8xxxu_write32(priv, REG_RX_IQK, 0x01004800);
+
+		for (i = 0; i < retry; i++) {
+			path_b_ok = rtl8192eu_iqk_path_b(priv);
+			if (path_b_ok == 0x01) {
+				val32 = rtl8xxxu_read32(priv, REG_TX_POWER_BEFORE_IQK_B);
+				result[t][4] = (val32 >> 16) & 0x3ff;
+				val32 = rtl8xxxu_read32(priv, REG_TX_POWER_AFTER_IQK_B);
+				result[t][5] = (val32 >> 16) & 0x3ff;
+				break;
+			}
+		}
+
+		if (!path_b_ok)
+			dev_dbg(dev, "%s: Path B IQK failed!\n", __func__);
+
+		for (i = 0; i < retry; i++) {
+			path_b_ok = rtl8192eu_rx_iqk_path_b(priv);
+			if (path_a_ok == 0x03) {
+				val32 = rtl8xxxu_read32(priv,
+							REG_RX_POWER_BEFORE_IQK_B_2);
+				result[t][6] = (val32 >> 16) & 0x3ff;
+				val32 = rtl8xxxu_read32(priv,
+							REG_RX_POWER_AFTER_IQK_B_2);
+				result[t][7] = (val32 >> 16) & 0x3ff;
+				break;
+			}
+		}
+
+		if (!path_b_ok)
+			dev_dbg(dev, "%s: Path B RX IQK failed!\n", __func__);
+	}
+
+	/* Back to BB mode, load original value */
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+
+	if (t) {
+		/* Reload ADDA power saving parameters */
+		rtl8xxxu_restore_regs(priv, adda_regs, priv->adda_backup,
+				      RTL8XXXU_ADDA_REGS);
+
+		/* Reload MAC parameters */
+		rtl8xxxu_restore_mac_regs(priv, iqk_mac_regs, priv->mac_backup);
+
+		/* Reload BB parameters */
+		rtl8xxxu_restore_regs(priv, iqk_bb_regs,
+				      priv->bb_backup, RTL8XXXU_BB_REGS);
+
+		/* Restore RX initial gain */
+		val32 = rtl8xxxu_read32(priv, REG_OFDM0_XA_AGC_CORE1);
+		val32 &= 0xffffff00;
+		rtl8xxxu_write32(priv, REG_OFDM0_XA_AGC_CORE1, val32 | 0x50);
+		rtl8xxxu_write32(priv, REG_OFDM0_XA_AGC_CORE1, val32 | xa_agc);
+
+		if (priv->rf_paths > 1) {
+			val32 = rtl8xxxu_read32(priv, REG_OFDM0_XB_AGC_CORE1);
+			val32 &= 0xffffff00;
+			rtl8xxxu_write32(priv, REG_OFDM0_XB_AGC_CORE1,
+					 val32 | 0x50);
+			rtl8xxxu_write32(priv, REG_OFDM0_XB_AGC_CORE1,
+					 val32 | xb_agc);
+		}
+
+		/* Load 0xe30 IQC default value */
+		rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x01008c00);
+		rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x01008c00);
+	}
+}
+
 static void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start)
 {
 	struct h2c_cmd h2c;
@@ -5630,6 +6146,96 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_prepare_calibrate(priv, 0);
 }
 
+static void rtl8192eu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
+{
+	struct device *dev = &priv->udev->dev;
+	int result[4][8];	/* last is final result */
+	int i, candidate;
+	bool path_a_ok, path_b_ok;
+	u32 reg_e94, reg_e9c, reg_ea4, reg_eac;
+	u32 reg_eb4, reg_ebc, reg_ec4, reg_ecc;
+	bool simu;
+
+	memset(result, 0, sizeof(result));
+	candidate = -1;
+
+	path_a_ok = false;
+	path_b_ok = false;
+
+	for (i = 0; i < 3; i++) {
+		rtl8192eu_phy_iqcalibrate(priv, result, i);
+
+		if (i == 1) {
+			simu = rtl8723bu_simularity_compare(priv, result, 0, 1);
+			if (simu) {
+				candidate = 0;
+				break;
+			}
+		}
+
+		if (i == 2) {
+			simu = rtl8723bu_simularity_compare(priv, result, 0, 2);
+			if (simu) {
+				candidate = 0;
+				break;
+			}
+
+			simu = rtl8723bu_simularity_compare(priv, result, 1, 2);
+			if (simu)
+				candidate = 1;
+			else
+				candidate = 3;
+		}
+	}
+
+	for (i = 0; i < 4; i++) {
+		reg_e94 = result[i][0];
+		reg_e9c = result[i][1];
+		reg_ea4 = result[i][2];
+		reg_eac = result[i][3];
+		reg_eb4 = result[i][4];
+		reg_ebc = result[i][5];
+		reg_ec4 = result[i][6];
+		reg_ecc = result[i][7];
+	}
+
+	if (candidate >= 0) {
+		reg_e94 = result[candidate][0];
+		priv->rege94 =  reg_e94;
+		reg_e9c = result[candidate][1];
+		priv->rege9c = reg_e9c;
+		reg_ea4 = result[candidate][2];
+		reg_eac = result[candidate][3];
+		reg_eb4 = result[candidate][4];
+		priv->regeb4 = reg_eb4;
+		reg_ebc = result[candidate][5];
+		priv->regebc = reg_ebc;
+		reg_ec4 = result[candidate][6];
+		reg_ecc = result[candidate][7];
+		dev_dbg(dev, "%s: candidate is %x\n", __func__, candidate);
+		dev_dbg(dev,
+			"%s: e94 =%x e9c=%x ea4=%x eac=%x eb4=%x ebc=%x ec4=%x "
+			"ecc=%x\n ", __func__, reg_e94, reg_e9c,
+			reg_ea4, reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc);
+		path_a_ok = true;
+		path_b_ok = true;
+	} else {
+		reg_e94 = reg_eb4 = priv->rege94 = priv->regeb4 = 0x100;
+		reg_e9c = reg_ebc = priv->rege9c = priv->regebc = 0x0;
+	}
+
+	if (reg_e94 && candidate >= 0)
+		rtl8xxxu_fill_iqk_matrix_a(priv, path_a_ok, result,
+					   candidate, (reg_ea4 == 0));
+
+	if (priv->rf_paths > 1)
+		rtl8xxxu_fill_iqk_matrix_b(priv, path_b_ok, result,
+					   candidate, (reg_ec4 == 0));
+
+	rtl8xxxu_save_regs(priv, rtl8723au_iqk_phy_iq_bb_reg,
+			   priv->bb_recovery_backup, RTL8XXXU_BB_REGS);
+}
+
 static void rtl8723a_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
 {
 	u32 val32;
@@ -9080,7 +9686,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.power_off = rtl8xxxu_power_off,
 	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_auto_llt_table,
-	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
+	.phy_iq_calibrate = rtl8192eu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.enable_rf = rtl8723b_enable_rf,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index c19f234..2aa14b1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -1130,6 +1130,7 @@
 #define RF6052_REG_T_METER_8723B	0x42
 #define RF6052_REG_UNKNOWN_43		0x43
 #define RF6052_REG_UNKNOWN_55		0x55
+#define RF6052_REG_UNKNOWN_56		0x56
 #define RF6052_REG_S0S1			0xb0
 #define RF6052_REG_UNKNOWN_DF		0xdf
 #define RF6052_REG_UNKNOWN_ED		0xed
-- 
2.5.5

