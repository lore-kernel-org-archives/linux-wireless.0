Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 12/16] rtl8xxxu: Fix 8188RU support
Date: Thu, 14 Apr 2016 16:37:17 -0400
Message-Id: <1460666241-5365-13-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_225529_211074_F4990191)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8188RU does not like PAPE to be enabled, while all the other gen1
parts seem to require it.

This makes the RTL8188RU able to associate for me.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 21 ++++++++++++++-------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 +
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 422e7fa..cf7832b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3145,6 +3145,7 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 		sprintf(priv->chip_name, "8188RU");
 		priv->rtl_chip = RTL8188R;
 		priv->hi_pa = 1;
+		priv->no_pape = 1;
 		priv->power_base = &rtl8188r_power_base;
 	}
 
@@ -5555,9 +5556,12 @@ static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	rtl8xxxu_write32(priv, REG_OFDM0_TR_MUX_PAR, 0x000800e4);
 	rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_SW_CTRL, 0x22204000);
 
-	val32 = rtl8xxxu_read32(priv, REG_FPGA0_XAB_RF_SW_CTRL);
-	val32 |= (FPGA0_RF_PAPE | (FPGA0_RF_PAPE << FPGA0_RF_BD_CTRL_SHIFT));
-	rtl8xxxu_write32(priv, REG_FPGA0_XAB_RF_SW_CTRL, val32);
+	if (!priv->no_pape) {
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XAB_RF_SW_CTRL);
+		val32 |= (FPGA0_RF_PAPE |
+			  (FPGA0_RF_PAPE << FPGA0_RF_BD_CTRL_SHIFT));
+		rtl8xxxu_write32(priv, REG_FPGA0_XAB_RF_SW_CTRL, val32);
+	}
 
 	val32 = rtl8xxxu_read32(priv, REG_FPGA0_XA_RF_INT_OE);
 	val32 &= ~BIT(10);
@@ -7804,11 +7808,14 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
 
 	val32 = FPGA0_RF_TRSW | FPGA0_RF_TRSWB | FPGA0_RF_ANTSW |
-		FPGA0_RF_ANTSWB | FPGA0_RF_PAPE |
-		((FPGA0_RF_ANTSW | FPGA0_RF_ANTSWB | FPGA0_RF_PAPE) <<
-		 FPGA0_RF_BD_CTRL_SHIFT);
-
+		FPGA0_RF_ANTSWB |
+		((FPGA0_RF_ANTSW | FPGA0_RF_ANTSWB) << FPGA0_RF_BD_CTRL_SHIFT);
+	if (!priv->no_pape) {
+		val32 |= (FPGA0_RF_PAPE |
+			  (FPGA0_RF_PAPE << FPGA0_RF_BD_CTRL_SHIFT));
+	}
 	rtl8xxxu_write32(priv, REG_FPGA0_XAB_RF_SW_CTRL, val32);
+
 	/* 0x860[6:5]= 00 - why? - this sets antenna B */
 	if (priv->rtl_chip != RTL8192E)
 		rtl8xxxu_write32(priv, REG_FPGA0_XA_RF_INT_OE, 0x66f60210);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index ebd1a6e..3e2643c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1287,6 +1287,7 @@ struct rtl8xxxu_priv {
 	u32 bb_recovery_backup[RTL8XXXU_BB_REGS];
 	enum rtl8xxxu_rtl_chip rtl_chip;
 	u8 pi_enabled:1;
+	u8 no_pape:1;
 	u8 int_buf[USB_INTR_CONTENT_LENGTH];
 };
 
-- 
2.5.5

