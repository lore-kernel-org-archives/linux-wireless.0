Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 01/26] rtl8xxxu: Reorder parts of init code to match the 8192eu vendor code flow
Date: Thu, 14 Apr 2016 14:58:42 -0400
Message-Id: <1460660347-26299-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205929_870288_EE8C7104)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

In order to debug 8192eu support, reorder some init code to match the
flow of the vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 35 ++++++++++++++----------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index e36fda8..d67b886 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7592,6 +7592,26 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
+	/* RFSW Control - clear bit 14 ?? */
+	if (priv->rtl_chip != RTL8723B)
+		rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
+	/* 0x07000760 */
+	if (priv->rtl_chip == RTL8192E) {
+		val32 = 0;
+	} else {
+		val32 = FPGA0_RF_TRSW | FPGA0_RF_TRSWB | FPGA0_RF_ANTSW |
+			FPGA0_RF_ANTSWB | FPGA0_RF_PAPE |
+			((FPGA0_RF_ANTSW | FPGA0_RF_ANTSWB | FPGA0_RF_PAPE) <<
+			 FPGA0_RF_BD_CTRL_SHIFT);
+	}
+	rtl8xxxu_write32(priv, REG_FPGA0_XAB_RF_SW_CTRL, val32);
+	/* 0x860[6:5]= 00 - why? - this sets antenna B */
+	if (priv->rtl_chip != RTL8192E)
+		rtl8xxxu_write32(priv, REG_FPGA0_XA_RF_INT_OE, 0x66f60210);
+
+	priv->rf_mode_ag[0] = rtl8xxxu_read_rfreg(priv, RF_A,
+						  RF6052_REG_MODE_AG);
+
 	/*
 	 * Chip specific quirks
 	 */
@@ -7653,21 +7673,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	/* RFSW Control - clear bit 14 ?? */
-	if (priv->rtl_chip != RTL8723B)
-		rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
-	/* 0x07000760 */
-	val32 = FPGA0_RF_TRSW | FPGA0_RF_TRSWB | FPGA0_RF_ANTSW |
-		FPGA0_RF_ANTSWB | FPGA0_RF_PAPE |
-		((FPGA0_RF_ANTSW | FPGA0_RF_ANTSWB | FPGA0_RF_PAPE) <<
-		 FPGA0_RF_BD_CTRL_SHIFT);
-	rtl8xxxu_write32(priv, REG_FPGA0_XAB_RF_SW_CTRL, val32);
-	/* 0x860[6:5]= 00 - why? - this sets antenna B */
-	rtl8xxxu_write32(priv, REG_FPGA0_XA_RF_INT_OE, 0x66F60210);
-
-	priv->rf_mode_ag[0] = rtl8xxxu_read_rfreg(priv, RF_A,
-						  RF6052_REG_MODE_AG);
-
 	/*
 	 * Set RX page boundary
 	 */
-- 
2.5.5

