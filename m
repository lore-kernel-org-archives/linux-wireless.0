Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 13/26] rtl8xxxu: Remove unused 8723bu path B IQ calibration code
Date: Thu, 14 Apr 2016 14:58:54 -0400
Message-Id: <1460660347-26299-14-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212529_300804_D2474F28)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8723bu is a combo WiFi/BT dongle, and path B is not used for WiFi,
so no point in calibrating it.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 76 +-----------------------
 1 file changed, 3 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 71d375c..c355d27 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4988,50 +4988,6 @@ out:
 	return result;
 }
 
-#ifdef RTL8723BU_PATH_B
-static int rtl8723bu_iqk_path_b(struct rtl8xxxu_priv *priv)
-{
-	u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, path_sel;
-	int result = 0;
-
-	path_sel = rtl8xxxu_read32(priv, REG_S0S1_PATH_SWITCH);
-
-	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
-	val32 &= 0x000000ff;
-	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
-
-	/* One shot, path B LOK & IQK */
-	rtl8xxxu_write32(priv, REG_IQK_AGC_CONT, 0x00000002);
-	rtl8xxxu_write32(priv, REG_IQK_AGC_CONT, 0x00000000);
-
-	mdelay(1);
-
-	/* Check failed */
-	reg_eac = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_A_2);
-	reg_eb4 = rtl8xxxu_read32(priv, REG_TX_POWER_BEFORE_IQK_B);
-	reg_ebc = rtl8xxxu_read32(priv, REG_TX_POWER_AFTER_IQK_B);
-	reg_ec4 = rtl8xxxu_read32(priv, REG_RX_POWER_BEFORE_IQK_B_2);
-	reg_ecc = rtl8xxxu_read32(priv, REG_RX_POWER_AFTER_IQK_B_2);
-
-	if (!(reg_eac & BIT(31)) &&
-	    ((reg_eb4 & 0x03ff0000) != 0x01420000) &&
-	    ((reg_ebc & 0x03ff0000) != 0x00420000))
-		result |= 0x01;
-	else
-		goto out;
-
-	if (!(reg_eac & BIT(30)) &&
-	    (((reg_ec4 & 0x03ff0000) >> 16) != 0x132) &&
-	    (((reg_ecc & 0x03ff0000) >> 16) != 0x36))
-		result |= 0x02;
-	else
-		dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
-			 __func__);
-out:
-	return result;
-}
-#endif
-
 static int rtl8192eu_iqk_path_a(struct rtl8xxxu_priv *priv)
 {
 	u32 reg_eac, reg_e94, reg_e9c;
@@ -5619,20 +5575,6 @@ static void rtl8723bu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	rtl8xxxu_write32(priv, REG_OFDM0_TR_MUX_PAR, 0x000800e4);
 	rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_SW_CTRL, 0x22204000);
 
-#ifdef RTL8723BU_PATH_B
-	/* Set RF mode to standby Path B */
-	if (priv->tx_paths > 1)
-		rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_AC, 0x10000);
-#endif
-
-#if 0
-	/* Page B init */
-	rtl8xxxu_write32(priv, REG_CONFIG_ANT_A, 0x0f600000);
-
-	if (priv->tx_paths > 1)
-		rtl8xxxu_write32(priv, REG_CONFIG_ANT_B, 0x0f600000);
-#endif
-
 	/*
 	 * RX IQ calibration setting for 8723B D cut large current issue
 	 * when leaving IPS
@@ -5662,12 +5604,6 @@ static void rtl8723bu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 			val32 &= 0x000000ff;
 			rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
 
-#if 0 /* Only needed in restore case, we may need this when going to suspend */
-			priv->RFCalibrateInfo.TxLOK[RF_A] =
-				rtl8xxxu_read_rfreg(priv, RF_A,
-						    RF6052_REG_TXM_IDAC);
-#endif
-
 			val32 = rtl8xxxu_read32(priv,
 						REG_TX_POWER_BEFORE_IQK_A);
 			result[t][0] = (val32 >> 16) & 0x3ff;
@@ -6209,15 +6145,9 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_ED, val32);
 	rtl8xxxu_write_rfreg(priv, RF_A, 0x43, 0x300bd);
 
-	if (priv->rf_paths > 1) {
-		dev_dbg(dev, "%s: beware 2T not yet supported\n", __func__);
-#ifdef RTL8723BU_PATH_B
-		if (RF_Path == 0x0)	//S1
-			ODM_SetIQCbyRFpath(pDM_Odm, 0);
-		else	//S0
-			ODM_SetIQCbyRFpath(pDM_Odm, 1);
-#endif
-	}
+	if (priv->rf_paths > 1)
+		dev_dbg(dev, "%s: 8723BU 2T not supported\n", __func__);
+
 	rtl8xxxu_prepare_calibrate(priv, 0);
 }
 
-- 
2.5.5

