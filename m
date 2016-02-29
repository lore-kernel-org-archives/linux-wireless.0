Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 037/113] rtl8xxxu: First stab at adding IQK calibration for 8723bu parts
Date: Mon, 29 Feb 2016 17:04:35 -0500
Message-Id: <1456783551-28315-38-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_658887_3CB052AB)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8723bu also has it's own IQK calibration process. This is similar
in flow, but still different enough to warrent it's own
implementation, at least for now.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 811 ++++++++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  17 +
 3 files changed, 827 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index e543a26..b2aa723 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3510,6 +3510,91 @@ static bool rtl8xxxu_simularity_compare(struct rtl8xxxu_priv *priv,
 	return false;
 }
 
+static bool rtl8723bu_simularity_compare(struct rtl8xxxu_priv *priv,
+					 int result[][8], int c1, int c2)
+{
+	u32 i, j, diff, simubitmap, bound = 0;
+	int candidate[2] = {-1, -1};	/* for path A and path B */
+	int tmp1, tmp2;
+	bool retval = true;
+
+	if (priv->tx_paths > 1)
+		bound = 8;
+	else
+		bound = 4;
+
+	simubitmap = 0;
+
+	for (i = 0; i < bound; i++) {
+		if (i & 1) {
+			if ((result[c1][i] & 0x00000200))
+				tmp1 = result[c1][i] | 0xfffffc00;
+			else
+				tmp1 = result[c1][i];
+
+			if ((result[c2][i]& 0x00000200))
+				tmp2 = result[c2][i] | 0xfffffc00;
+			else
+				tmp2 = result[c2][i];
+		} else {
+			tmp1 = result[c1][i];
+			tmp2 = result[c2][i];
+		}
+
+		diff = (tmp1 > tmp2) ? (tmp1 - tmp2) : (tmp2 - tmp1);
+
+		if (diff > MAX_TOLERANCE) {
+			if ((i == 2 || i == 6) && !simubitmap) {
+				if (result[c1][i] + result[c1][i + 1] == 0)
+					candidate[(i / 4)] = c2;
+				else if (result[c2][i] + result[c2][i + 1] == 0)
+					candidate[(i / 4)] = c1;
+				else
+					simubitmap = simubitmap | (1 << i);
+			} else {
+				simubitmap = simubitmap | (1 << i);
+			}
+		}
+	}
+
+	if (simubitmap == 0) {
+		for (i = 0; i < (bound / 4); i++) {
+			if (candidate[i] >= 0) {
+				for (j = i * 4; j < (i + 1) * 4 - 2; j++)
+					result[3][j] = result[candidate[i]][j];
+				retval = false;
+			}
+		}
+		return retval;
+	} else {
+		if (!(simubitmap & 0x03)) {
+			/* path A TX OK */
+			for (i = 0; i < 2; i++)
+				result[3][i] = result[c1][i];
+		}
+
+		if (!(simubitmap & 0x0c)) {
+			/* path A RX OK */
+			for (i = 2; i < 4; i++)
+				result[3][i] = result[c1][i];
+		}
+
+		if (!(simubitmap & 0x30) && priv->tx_paths > 1) {
+			/* path B RX OK */
+			for (i = 4; i < 6; i++)
+				result[3][i] = result[c1][i];
+		}
+
+		if (!(simubitmap & 0x30) && priv->tx_paths > 1) {
+			/* path B RX OK */
+			for (i = 6; i < 8; i++)
+				result[3][i] = result[c1][i];
+		}
+	}
+
+	return false;
+}
+
 static void
 rtl8xxxu_save_mac_regs(struct rtl8xxxu_priv *priv, const u32 *reg, u32 *backup)
 {
@@ -3677,6 +3762,369 @@ out:
 	return result;
 }
 
+static int rtl8723bu_iqk_path_a(struct rtl8xxxu_priv *priv)
+{
+	u32 reg_eac, reg_e94, reg_e9c, path_sel, val32;
+	int result = 0;
+
+	path_sel = rtl8xxxu_read32(priv, REG_S0S1_PATH_SWITCH);
+
+	/*
+	 * Leave IQK mode
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	/*
+	 * Enable path A PA in TX IQK mode
+	 */
+	val32 = rtl8xxxu_read_rfreg(priv, RF_A, RF6052_REG_WE_LUT);
+	val32 |= 0x80000;
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, val32);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x20000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0003f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xc7f87);
+
+	/*
+	 * Tx IQK setting
+	 */
+	rtl8xxxu_write32(priv, REG_TX_IQK, 0x01007c00);
+	rtl8xxxu_write32(priv, REG_RX_IQK, 0x01004800);
+
+	/* path-A IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x18008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x821403ea);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x28110000);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82110000);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x28110000);
+
+	/* LO calibration setting */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00462911);
+
+	/*
+	 * Enter IQK mode
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	val32 |= 0x80800000;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	/*
+	 * The vendor driver indicates the USB module is always using
+	 * S0S1 path 1 for the 8723bu. This may be different for 8192eu
+	 */
+	if (priv->rf_paths > 1)
+		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00000000);
+	else
+		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00000280);
+
+	/*
+	 * Bit 12 seems to be BT_GRANT, and is only found in the 8723bu.
+	 * No trace of this in the 8192eu or 8188eu vendor drivers.
+	 */
+	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, 0x00000800);
+
+	/* One shot, path A LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf9000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
+
+	mdelay(1);
+
+	/* Restore Ant Path */
+	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, path_sel);
+#ifdef RTL8723BU_BT
+	/* GNT_BT = 1 */
+	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, 0x00001800);
+#endif
+
+	/*
+	 * Leave IQK mode
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	/* Check failed */
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_e94 = rtl8xxxu_read32(priv, REG_TX_POWER_BEFORE_IQK_A);
+	reg_e9c = rtl8xxxu_read32(priv, REG_TX_POWER_AFTER_IQK_A);
+
+	val32 = (reg_e9c >> 16) & 0x3ff;
+	if (val32 & 0x200)
+		val32 = 0x400 - val32;
+
+	if (!(reg_eac & BIT(28)) &&
+	    ((reg_e94 & 0x03ff0000) != 0x01420000) &&
+	    ((reg_e9c & 0x03ff0000) != 0x00420000) &&
+	    ((reg_e94 & 0x03ff0000)  < 0x01100000) &&
+	    ((reg_e94 & 0x03ff0000)  > 0x00f00000) &&
+	    val32 < 0xf)
+		result |= 0x01;
+	else	/* If TX not OK, ignore RX */
+		goto out;
+
+out:
+	return result;
+}
+
+static int rtl8723bu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
+{
+	u32 reg_ea4, reg_eac, reg_e94, reg_e9c, path_sel, val32;
+	int result = 0;
+
+	path_sel = rtl8xxxu_read32(priv, REG_S0S1_PATH_SWITCH);
+
+	/*
+	 * Leave IQK mode
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	/*
+	 * Enable path A PA in TX IQK mode
+	 */
+	val32 = rtl8xxxu_read_rfreg(priv, RF_A, RF6052_REG_WE_LUT);
+	val32 |= 0x80000;
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, val32);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0001f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf7fb7);
+
+	/*
+	 * Tx IQK setting
+	 */
+	rtl8xxxu_write32(priv, REG_TX_IQK, 0x01007c00);
+	rtl8xxxu_write32(priv, REG_RX_IQK, 0x01004800);
+
+	/* path-A IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x18008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160ff0);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x28110000);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82110000);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x28110000);
+
+	/* LO calibration setting */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a911);
+
+	/*
+	 * Enter IQK mode
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	val32 |= 0x80800000;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	/*
+	 * The vendor driver indicates the USB module is always using
+	 * S0S1 path 1 for the 8723bu. This may be different for 8192eu
+	 */
+	if (priv->rf_paths > 1)
+		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00000000);
+	else
+		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00000280);
+
+	/*
+	 * Bit 12 seems to be BT_GRANT, and is only found in the 8723bu.
+	 * No trace of this in the 8192eu or 8188eu vendor drivers.
+	 */
+	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, 0x00000800);
+
+	/* One shot, path A LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf9000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
+
+	mdelay(1);
+
+	/* Restore Ant Path */
+	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, path_sel);
+#ifdef RTL8723BU_BT
+	/* GNT_BT = 1 */
+	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, 0x00001800);
+#endif
+
+	/*
+	 * Leave IQK mode
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	/* Check failed */
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_e94 = rtl8xxxu_read32(priv, REG_TX_POWER_BEFORE_IQK_A);
+	reg_e9c = rtl8xxxu_read32(priv, REG_TX_POWER_AFTER_IQK_A);
+
+	val32 = (reg_e9c >> 16) & 0x3ff;
+	if (val32 & 0x200)
+		val32 = 0x400 - val32;
+
+	if (!(reg_eac & BIT(28)) &&
+	    ((reg_e94 & 0x03ff0000) != 0x01420000) &&
+	    ((reg_e9c & 0x03ff0000) != 0x00420000) &&
+	    ((reg_e94 & 0x03ff0000)  < 0x01100000) &&
+	    ((reg_e94 & 0x03ff0000)  > 0x00f00000) &&
+	    val32 < 0xf)
+		result |= 0x01;
+	else	/* If TX not OK, ignore RX */
+		goto out;
+
+	val32 = 0x80007c00 | (reg_e94 &0x3ff0000) |
+		((reg_e9c & 0x3ff0000) >> 16);
+	rtl8xxxu_write32(priv, REG_TX_IQK, val32);
+
+	/*
+	 * Modify RX IQK mode
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+	val32 = rtl8xxxu_read_rfreg(priv, RF_A, RF6052_REG_WE_LUT);
+	val32 |= 0x80000;
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, val32);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0001f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf7d77);
+
+	/*
+	 * PA, PAD setting
+	 */
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0xf80);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_55, 0x4021f);
+
+	/*
+	 * RX IQK setting
+	 */
+	rtl8xxxu_write32(priv, REG_RX_IQK, 0x01004800);
+
+	/* path-A IQK setting */
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x18008c1c);
+	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82110000);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x2816001f);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82110000);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x28110000);
+
+	/* LO calibration setting */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a8d1);
+
+	/*
+	 * Enter IQK mode
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	val32 |= 0x80800000;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	if (priv->rf_paths > 1)
+		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00000000);
+	else
+		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00000280);
+
+	/*
+	 * Disable BT
+	 */
+	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, 0x00000800);
+
+	/* One shot, path A LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf9000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
+
+	mdelay(1);
+
+	/* Restore Ant Path */
+	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, path_sel);
+#ifdef RTL8723BU_BT
+	/* GNT_BT = 1 */
+	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, 0x00001800);
+#endif
+
+	/*
+	 * Leave IQK mode
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	/* Check failed */
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_ea4 = rtl8xxxu_read32(priv, REG_RX_POWER_BEFORE_IQK_A_2);
+
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x780);
+
+	val32 = (reg_eac >> 16) & 0x3ff;
+	if (val32 & 0x200)
+		val32 = 0x400 - val32;
+
+	if (!(reg_eac & BIT(27)) &&
+	    ((reg_ea4 & 0x03ff0000) != 0x01320000) &&
+	    ((reg_eac & 0x03ff0000) != 0x00360000) &&
+	    ((reg_ea4 & 0x03ff0000)  < 0x01100000) &&
+	    ((reg_ea4 & 0x03ff0000)  > 0x00f00000) &&
+	    val32 < 0xf)
+		result |= 0x02;
+	else	/* If TX not OK, ignore RX */
+		goto out;
+out:
+	return result;
+}
+
+#ifdef RTL8723BU_PATH_B
+static int rtl8723bu_iqk_path_b(struct rtl8xxxu_priv *priv)
+{
+	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, path_sel;
+	int result = 0;
+
+	path_sel = rtl8xxxu_read32(priv, REG_S0S1_PATH_SWITCH);
+
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	/* One shot, path B LOK & IQK */
+	rtl8xxxu_write32(priv, REG_IQK_AGC_CONT, 0x00000002);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_CONT, 0x00000000);
+
+	mdelay(1);
+
+	/* Check failed */
+	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
+	reg_eb4 = rtl8xxxu_read32(priv, REG_TX_POWER_BEFORE_IQK_B);
+	reg_ebc = rtl8xxxu_read32(priv, REG_TX_POWER_AFTER_IQK_B);
+	reg_ec4 = rtl8xxxu_read32(priv, REG_RX_POWER_BEFORE_IQK_B_2);
+	reg_ecc = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_B_2);
+
+	if (!(reg_eac & BIT(31)) &&
+	    ((reg_eb4 & 0x03ff0000) != 0x01420000) &&
+	    ((reg_ebc & 0x03ff0000) != 0x00420000))
+		result |= 0x01;
+	else
+		goto out;
+
+	if (!(reg_eac & BIT(30)) &&
+	    (((reg_ec4 & 0x03ff0000) >> 16) != 0x132) &&
+	    (((reg_ecc & 0x03ff0000) >> 16) != 0x36))
+		result |= 0x02;
+	else
+		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
+			 __func__);
+out:
+	return result;
+}
+#endif
+
 static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 				     int result[][8], int t)
 {
@@ -3879,6 +4327,234 @@ static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	}
 }
 
+static void rtl8723bu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
+				      int result[][8], int t)
+{
+	struct device *dev = &priv->udev->dev;
+	u32 i, val32;
+	int path_a_ok /*, path_b_ok */;
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
+		REG_FPGA0_XB_RF_INT_OE, REG_FPGA0_RF_MODE
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
+	rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_SW_CTRL, 0x22204000);
+
+#ifdef RTL8723BU_PATH_B
+	/* Set RF mode to standby Path B */
+	if (priv->tx_paths > 1)
+		rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_AC, 0x10000);
+#endif
+
+#if 0
+	/* Page B init */
+	rtl8xxxu_write32(priv, REG_CONFIG_ANT_A, 0x0f600000);
+
+	if (priv->tx_paths > 1)
+		rtl8xxxu_write32(priv, REG_CONFIG_ANT_B, 0x0f600000);
+#endif
+
+	/*
+	 * RX IQ calibration setting for 8723B D cut large current issue
+	 * when leaving IPS
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+	val32 = rtl8xxxu_read_rfreg(priv, RF_A, RF6052_REG_WE_LUT);
+	val32 |= 0x80000;
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, val32);
+
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0001f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf7fb7);
+
+	val32 = rtl8xxxu_read_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_ED);
+	val32 |= 0x20;
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_ED, val32);
+
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_43, 0x60fbd);
+
+	for (i = 0; i < retry; i++) {
+		path_a_ok = rtl8723bu_iqk_path_a(priv);
+		if (path_a_ok == 0x01) {
+			val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+			val32 &= 0x000000ff;
+			rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+#if 0 /* Only needed in restore case, we may need this when going to suspend */
+			priv->RFCalibrateInfo.TxLOK[RF_A] =
+				rtl8xxxu_read_rfreg(priv, RF_A,
+						    RF6052_REG_TXM_IDAC);
+#endif
+
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
+		path_a_ok = rtl8723bu_rx_iqk_path_a(priv);
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
+	if (priv->tx_paths > 1) {
+#if 1
+		dev_warn(dev, "%s: Path B not supported\n", __func__);
+#else
+
+		/*
+		 * Path A into standby
+		 */
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+		val32 &= 0x000000ff;
+		rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_AC, 0x10000);
+
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+		val32 &= 0x000000ff;
+		val32 |= 0x80800000;
+		rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+
+		/* Turn Path B ADDA on */
+		rtl8xxxu_path_adda_on(priv, adda_regs, false);
+
+		for (i = 0; i < retry; i++) {
+			path_b_ok = rtl8xxxu_iqk_path_b(priv);
+			if (path_b_ok == 0x03) {
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
+			path_b_ok = rtl8723bu_rx_iqk_path_b(priv);
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
+#endif
+	}
+
+	/* Back to BB mode, load original value */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 &= 0x000000ff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
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
+		if (priv->tx_paths > 1) {
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
@@ -3893,7 +4569,7 @@ static void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start)
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_wlan_calibration));
 }
 
-static void rtl8723a_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
+static void rtl8723au_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
 	int result[4][8];	/* last is final result */
@@ -3997,6 +4673,133 @@ static void rtl8723a_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_prepare_calibrate(priv, 0);
 }
 
+static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
+{
+	struct device *dev = &priv->udev->dev;
+	int result[4][8];	/* last is final result */
+	int i, candidate;
+	bool path_a_ok, path_b_ok;
+	u32 reg_e94, reg_e9c, reg_ea4, reg_eac;
+	u32 reg_eb4, reg_ebc, reg_ec4, reg_ecc;
+	u32 val32, bt_control;
+	s32 reg_tmp = 0;
+	bool simu;
+
+	rtl8xxxu_prepare_calibrate(priv, 1);
+
+	memset(result, 0, sizeof(result));
+	candidate = -1;
+
+	path_a_ok = false;
+	path_b_ok = false;
+
+	bt_control = rtl8xxxu_read32(priv, REG_BT_CONTROL_8723BU);
+
+	for (i = 0; i < 3; i++) {
+		rtl8723bu_phy_iqcalibrate(priv, result, i);
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
+			if (simu) {
+				candidate = 1;
+			} else {
+				for (i = 0; i < 8; i++)
+					reg_tmp += result[3][i];
+
+				if (reg_tmp)
+					candidate = 3;
+				else
+					candidate = -1;
+			}
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
+	if (priv->tx_paths > 1 && reg_eb4)
+		rtl8xxxu_fill_iqk_matrix_b(priv, path_b_ok, result,
+					   candidate, (reg_ec4 == 0));
+
+	rtl8xxxu_save_regs(priv, rtl8723au_iqk_phy_iq_bb_reg,
+			   priv->bb_recovery_backup, RTL8XXXU_BB_REGS);
+
+	rtl8xxxu_write32(priv, REG_BT_CONTROL_8723BU, bt_control);
+
+	val32 = rtl8xxxu_read_rfreg(priv, RF_A, RF6052_REG_WE_LUT);
+	val32 |= 0x80000;
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, val32);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x18000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0001f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xe6177);
+	val32 = rtl8xxxu_read_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_ED);
+	val32 |= 0x20;
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_ED, val32);
+	rtl8xxxu_write_rfreg(priv, RF_A, 0x43, 0x300bd);
+
+	if (priv->rf_paths > 1) {
+		dev_dbg(dev, "%s: beware 2T not yet supported\n", __func__);
+#ifdef RTL8723BU_PATH_B
+		if (RF_Path == 0x0)	//S1
+			ODM_SetIQCbyRFpath(pDM_Odm, 0);
+		else	//S0
+			ODM_SetIQCbyRFpath(pDM_Odm, 1);
+#endif
+	}
+	rtl8xxxu_prepare_calibrate(priv, 0);
+}
+
 static void rtl8723a_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
 {
 	u32 val32;
@@ -4995,7 +5798,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	rtl8xxxu_write16(priv, REG_FAST_EDCA_CTRL, 0);
 
-	rtl8723a_phy_iq_calibrate(priv);
+	priv->fops->phy_iq_calibrate(priv);
 
 	/*
 	 * This should enable thermal meter
@@ -6536,6 +7339,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.load_firmware = rtl8723au_load_firmware,
 	.power_on = rtl8723au_power_on,
 	.llt_init = rtl8xxxu_init_llt_table,
+	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -6551,6 +7355,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.power_on = rtl8723au_power_on,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
+	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
@@ -6567,6 +7372,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.load_firmware = rtl8192cu_load_firmware,
 	.power_on = rtl8192cu_power_on,
 	.llt_init = rtl8xxxu_init_llt_table,
+	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -6583,6 +7389,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.load_firmware = rtl8192eu_load_firmware,
 	.power_on = rtl8192eu_power_on,
 	.llt_init = rtl8xxxu_auto_llt_table,
+	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 4b8431d..76398de 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -851,6 +851,7 @@ struct rtl8xxxu_fileops {
 	int (*power_on) (struct rtl8xxxu_priv *priv);
 	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
+	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 162a9e8..499210f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -708,6 +708,12 @@
 #define REG_MACID1			0x0700
 #define REG_BSSID1			0x0708
 
+/*
+ * This seems to be 8723bu specific
+ */
+#define REG_BT_CONTROL_8723BU		0x0764
+#define  BT_CONTROL_BT_GRANT		BIT(12)
+
 #define REG_FPGA0_RF_MODE		0x0800
 #define  FPGA_RF_MODE			BIT(0)
 #define  FPGA_RF_MODE_JAPAN		BIT(1)
@@ -810,6 +816,7 @@
 #define REG_RFE_CTRL_ANTA_SRC		0x0930	/* 8723BU */
 #define REG_RFE_PATH_SELECT		0x0940	/* 8723BU */
 #define REG_RFE_BUFFER			0x0944	/* 8723BU */
+#define REG_S0S1_PATH_SWITCH		0x0948	/* 8723BU */
 
 #define REG_CCK0_SYSTEM			0x0a00
 #define  CCK0_SIDEBAND			BIT(4)
@@ -1050,3 +1057,13 @@
 #define RF6052_REG_TXPA_G1		0x31	/* RF TX PA control */
 #define RF6052_REG_TXPA_G2		0x32	/* RF TX PA control */
 #define RF6052_REG_TXPA_G3		0x33	/* RF TX PA control */
+
+/*
+ * NextGen regs: 8723BU
+ */
+#define	RF6052_REG_UNKNOWN_43		0x43
+#define	RF6052_REG_UNKNOWN_55		0x55
+#define	RF6052_REG_S0S1			0xb0
+#define	RF6052_REG_UNKNOWN_DF		0xdf
+#define	RF6052_REG_UNKNOWN_ED		0xed
+#define	RF6052_REG_WE_LUT		0xef
-- 
2.5.0

