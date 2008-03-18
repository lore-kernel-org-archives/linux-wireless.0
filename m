Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:5105 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbYCRAri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 20:47:38 -0400
Received: by wr-out-0506.google.com with SMTP id c48so4253173wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 17:47:36 -0700 (PDT)
Subject: [PATCH 2/5] b43: remove bitwise negation of constants
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 17:47:29 -0700
Message-Id: <1205801249.2329.50.camel@brick> (sfid-20080318_004801_263758_CE23327B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Where the mask argument  to b43_phy_maskset was a negated constant,
remove the negation as is the style everywhere else.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/wa.c |   46 ++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index e7e532b..b92e496 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -329,7 +329,7 @@ static void b43_wa_crs_ed(struct b43_wldev *dev)
 
 static void b43_wa_crs_thr(struct b43_wldev *dev)
 {
-	b43_phy_maskset(dev, B43_PHY_CRS0, ~0x03C0, 0xD000);
+	b43_phy_maskset(dev, B43_PHY_CRS0, 0xFC3F, 0xD000);
 }
 
 static void b43_wa_crs_blank(struct b43_wldev *dev)
@@ -386,47 +386,47 @@ static void b43_wa_altagc(struct b43_wldev *dev)
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 3, 25);
 	}
 
-	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, ~0xFF00, 0x5700);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x007F, 0x000F);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x3F80, 0x2B80);
+	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, 0x00FF, 0x5700);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), 0xFF80, 0x000F);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), 0xC07F, 0x2B80);
 	b43_phy_maskset(dev, B43_PHY_ANTWRSETT, 0xF0FF, 0x0300);
 	b43_radio_write16(dev, 0x7A,
 		b43_radio_read16(dev, 0x7A) | 0x0008);
-	b43_phy_maskset(dev, B43_PHY_N1P1GAIN, ~0x000F, 0x0008);
-	b43_phy_maskset(dev, B43_PHY_P1P2GAIN, ~0x0F00, 0x0600);
-	b43_phy_maskset(dev, B43_PHY_N1N2GAIN, ~0x0F00, 0x0700);
-	b43_phy_maskset(dev, B43_PHY_N1P1GAIN, ~0x0F00, 0x0100);
+	b43_phy_maskset(dev, B43_PHY_N1P1GAIN, 0xFFF0, 0x0008);
+	b43_phy_maskset(dev, B43_PHY_P1P2GAIN, 0xF0FF, 0x0600);
+	b43_phy_maskset(dev, B43_PHY_N1N2GAIN, 0xF0FF, 0x0700);
+	b43_phy_maskset(dev, B43_PHY_N1P1GAIN, 0xF0FF, 0x0100);
 	if (phy->rev == 1) {
-		b43_phy_maskset(dev, B43_PHY_N1N2GAIN, ~0x000F, 0x0007);
+		b43_phy_maskset(dev, B43_PHY_N1N2GAIN, 0xFFF0, 0x0007);
 	}
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x88), ~0x00FF, 0x001C);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x88), ~0x3F00, 0x0200);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), ~0x00FF, 0x001C);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x00FF, 0x0020);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x3F00, 0x0200);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), ~0x00FF, 0x002E);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), ~0xFF00, 0x1A00);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), ~0x00FF, 0x0028);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), ~0xFF00, 0x2C00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x88), 0xFF00, 0x001C);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x88), 0xC0FF, 0x0200);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), 0xFF00, 0x001C);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), 0xFF00, 0x0020);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), 0xC0FF, 0x0200);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), 0xFF00, 0x002E);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), 0x00FF, 0x1A00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), 0xFF00, 0x0028);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), 0x00FF, 0x2C00);
 	if (phy->rev == 1) {
 		b43_phy_write(dev, B43_PHY_PEAK_COUNT, 0x092B);
-		b43_phy_maskset(dev, B43_PHY_OFDM(0x1B), ~0x001E, 0x0002);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0x1B), 0xFFE1, 0x0002);
 	} else {
 		b43_phy_write(dev, B43_PHY_OFDM(0x1B),
 			b43_phy_read(dev, B43_PHY_OFDM(0x1B)) & ~0x001E);
 		b43_phy_write(dev, B43_PHY_OFDM(0x1F), 0x287A);
-		b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, ~0x000F, 0x0004);
+		b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, 0xFFF0, 0x0004);
 		if (phy->rev >= 6) {
 			b43_phy_write(dev, B43_PHY_OFDM(0x22), 0x287A);
-			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, ~0xF000, 0x3000);
+			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, 0x0FFF, 0x3000);
 		}
 	}
 	b43_phy_maskset(dev, B43_PHY_DIVSRCHIDX, 0x8080, 0x7874);
 	b43_phy_write(dev, B43_PHY_OFDM(0x8E), 0x1C00);
 	if (phy->rev == 1) {
-		b43_phy_maskset(dev, B43_PHY_DIVP1P2GAIN, ~0x0F00, 0x0600);
+		b43_phy_maskset(dev, B43_PHY_DIVP1P2GAIN, 0xF0FF, 0x0600);
 		b43_phy_write(dev, B43_PHY_OFDM(0x8B), 0x005E);
-		b43_phy_maskset(dev, B43_PHY_ANTWRSETT, ~0x00FF, 0x001E);
+		b43_phy_maskset(dev, B43_PHY_ANTWRSETT, 0xFF00, 0x001E);
 		b43_phy_write(dev, B43_PHY_OFDM(0x8D), 0x0002);
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC3_R1, 0, 0);
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC3_R1, 1, 7);
-- 
1.5.4.4.684.g0e08


