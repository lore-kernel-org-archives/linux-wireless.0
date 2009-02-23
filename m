Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57147 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZBWVyf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 16:54:35 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Remove bogus integer truncation warnings
Date: Mon, 23 Feb 2009 22:52:26 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Message-Id: <200902232252.26991.mb@bu3sch.de> (sfid-20090223_225438_828610_140C6466)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"warning: large integer implicitly truncated to unsigned type"

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Virtual fists were already shaked, so I need to hurry up to fixup my crap. :P


Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2009-02-23 22:38:56.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2009-02-23 22:41:28.000000000 +0100
@@ -968,13 +968,13 @@ b43_radio_interference_mitigation_enable
 		b43_phy_maskset(dev, 0x04A8, 0xFFF0, 0x0006);
 		b43_phy_maskset(dev, 0x04A2, 0xF0FF, 0x0800);
 		b43_phy_maskset(dev, 0x04A0, 0xF0FF, 0x0500);
 		b43_phy_maskset(dev, 0x04A2, 0xFFF0, 0x000B);
 
 		if (phy->rev >= 3) {
-			b43_phy_mask(dev, 0x048A, ~0x8000);
+			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
 			b43_phy_maskset(dev, 0x0415, 0x8000, 0x36D8);
 			b43_phy_maskset(dev, 0x0416, 0x8000, 0x36D8);
 			b43_phy_maskset(dev, 0x0417, 0xFE00, 0x016D);
 		} else {
 			b43_phy_set(dev, 0x048A, 0x1000);
 			b43_phy_maskset(dev, 0x048A, 0x9FFF, 0x2000);
Index: wireless-testing/drivers/net/wireless/b43/wa.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/wa.c	2009-02-23 18:26:03.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/wa.c	2009-02-23 22:43:00.000000000 +0100
@@ -379,13 +379,13 @@ static void b43_wa_altagc(struct b43_wld
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 0, 254);
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 1, 13);
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 2, 19);
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 3, 25);
 	}
 
-	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, ~0xFF00, 0x5700);
+	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, (u16)~0xFF00, 0x5700);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x007F, 0x000F);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x3F80, 0x2B80);
 	b43_phy_maskset(dev, B43_PHY_ANTWRSETT, 0xF0FF, 0x0300);
 	b43_radio_set(dev, 0x7A, 0x0008);
 	b43_phy_maskset(dev, B43_PHY_N1P1GAIN, ~0x000F, 0x0008);
 	b43_phy_maskset(dev, B43_PHY_P1P2GAIN, ~0x0F00, 0x0600);
@@ -397,25 +397,25 @@ static void b43_wa_altagc(struct b43_wld
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x88), ~0x00FF, 0x001C);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x88), ~0x3F00, 0x0200);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), ~0x00FF, 0x001C);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x00FF, 0x0020);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x3F00, 0x0200);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), ~0x00FF, 0x002E);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), ~0xFF00, 0x1A00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), (u16)~0xFF00, 0x1A00);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), ~0x00FF, 0x0028);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), ~0xFF00, 0x2C00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), (u16)~0xFF00, 0x2C00);
 	if (phy->rev == 1) {
 		b43_phy_write(dev, B43_PHY_PEAK_COUNT, 0x092B);
 		b43_phy_maskset(dev, B43_PHY_OFDM(0x1B), ~0x001E, 0x0002);
 	} else {
 		b43_phy_mask(dev, B43_PHY_OFDM(0x1B), ~0x001E);
 		b43_phy_write(dev, B43_PHY_OFDM(0x1F), 0x287A);
 		b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, ~0x000F, 0x0004);
 		if (phy->rev >= 6) {
 			b43_phy_write(dev, B43_PHY_OFDM(0x22), 0x287A);
-			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, ~0xF000, 0x3000);
+			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, (u16)~0xF000, 0x3000);
 		}
 	}
 	b43_phy_maskset(dev, B43_PHY_DIVSRCHIDX, 0x8080, 0x7874);
 	b43_phy_write(dev, B43_PHY_OFDM(0x8E), 0x1C00);
 	if (phy->rev == 1) {
 		b43_phy_maskset(dev, B43_PHY_DIVP1P2GAIN, ~0x0F00, 0x0600);

-- 
Greetings, Michael.
