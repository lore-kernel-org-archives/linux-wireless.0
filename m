Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbcDNS7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:14 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 24/26] rtl8xxxu: Remove unneeded 8192eu hack
Date: Thu, 14 Apr 2016 14:59:05 -0400
Message-Id: <1460660347-26299-25-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205917_874902_0E8A02A9)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This removes an unneeded hack for 8192eu, and allows for initializing
REG_FPGA0_XAB_RF_SW_CTRL at the same point as it is done for all other
parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 821be87..5c56a4f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7680,15 +7680,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/* RFSW Control - clear bit 14 ?? */
 	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E)
 		rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
-	/* 0x07000760 */
-	if (priv->rtl_chip == RTL8192E) {
-		val32 = 0;
-	} else {
-		val32 = FPGA0_RF_TRSW | FPGA0_RF_TRSWB | FPGA0_RF_ANTSW |
-			FPGA0_RF_ANTSWB | FPGA0_RF_PAPE |
-			((FPGA0_RF_ANTSW | FPGA0_RF_ANTSWB | FPGA0_RF_PAPE) <<
-			 FPGA0_RF_BD_CTRL_SHIFT);
-	}
+
+	val32 = FPGA0_RF_TRSW | FPGA0_RF_TRSWB | FPGA0_RF_ANTSW |
+		FPGA0_RF_ANTSWB | FPGA0_RF_PAPE |
+		((FPGA0_RF_ANTSW | FPGA0_RF_ANTSWB | FPGA0_RF_PAPE) <<
+		 FPGA0_RF_BD_CTRL_SHIFT);
+
 	rtl8xxxu_write32(priv, REG_FPGA0_XAB_RF_SW_CTRL, val32);
 	/* 0x860[6:5]= 00 - why? - this sets antenna B */
 	if (priv->rtl_chip != RTL8192E)
-- 
2.5.5

