Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64721 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbZHMWPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 18:15:10 -0400
Date: Thu, 13 Aug 2009 17:15:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix sparse warnings
Message-ID: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The b43 driver generates the following sparse warnings:

  CHECK   drivers/net/wireless/b43/phy_g.c
drivers/net/wireless/b43/phy_g.c:974:35: warning: cast truncates bits from constant value (ffff7fff becomes 7fff)
  CHECK   drivers/net/wireless/b43/wa.c
drivers/net/wireless/b43/wa.c:385:53: warning: cast truncates bits from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:403:48: warning: cast truncates bits from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:405:48: warning: cast truncates bits from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:415:50: warning: cast truncates bits from constant value (ffff0fff becomes fff)

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

There is no hurry for this material.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c
@@ -971,7 +971,7 @@ b43_radio_interference_mitigation_enable
 		b43_phy_maskset(dev, 0x04A2, 0xFFF0, 0x000B);
 
 		if (phy->rev >= 3) {
-			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
+			b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));
 			b43_phy_maskset(dev, 0x0415, 0x8000, 0x36D8);
 			b43_phy_maskset(dev, 0x0416, 0x8000, 0x36D8);
 			b43_phy_maskset(dev, 0x0417, 0xFE00, 0x016D);
Index: wireless-testing/drivers/net/wireless/b43/wa.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/wa.c
+++ wireless-testing/drivers/net/wireless/b43/wa.c
@@ -382,7 +382,8 @@ static void b43_wa_altagc(struct b43_wld
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 3, 25);
 	}
 
-	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, (u16)~0xFF00, 0x5700);
+	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, (u16)(~0xFF00 & 0xFFFF),
+			0x5700);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x007F, 0x000F);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x3F80, 0x2B80);
 	b43_phy_maskset(dev, B43_PHY_ANTWRSETT, 0xF0FF, 0x0300);
@@ -400,9 +401,9 @@ static void b43_wa_altagc(struct b43_wld
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x00FF, 0x0020);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x3F00, 0x0200);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), ~0x00FF, 0x002E);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), (u16)~0xFF00, 0x1A00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), (u16)(~0xFF00 & 0xFFFF), 0x1A00);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), ~0x00FF, 0x0028);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), (u16)~0xFF00, 0x2C00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), (u16)(~0xFF00 & 0xFFFF), 0x2C00);
 	if (phy->rev == 1) {
 		b43_phy_write(dev, B43_PHY_PEAK_COUNT, 0x092B);
 		b43_phy_maskset(dev, B43_PHY_OFDM(0x1B), ~0x001E, 0x0002);
@@ -412,7 +413,8 @@ static void b43_wa_altagc(struct b43_wld
 		b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, ~0x000F, 0x0004);
 		if (phy->rev >= 6) {
 			b43_phy_write(dev, B43_PHY_OFDM(0x22), 0x287A);
-			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, (u16)~0xF000, 0x3000);
+			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, (u16)(~0xF000 &
+					0xFFFF), 0x3000);
 		}
 	}
 	b43_phy_maskset(dev, B43_PHY_DIVSRCHIDX, 0x8080, 0x7874);
