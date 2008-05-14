Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:33834 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbYENS4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 14:56:45 -0400
Received: by wf-out-1314.google.com with SMTP id 27so20423wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 11:56:45 -0700 (PDT)
Subject: [PATCH 4/5] b43: phy.c eliminate some tmp variable usage
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 11:56:36 -0700
Message-Id: <1210791396.6191.39.camel@brick> (sfid-20080514_205649_530373_7CE4D55F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with exlicit b43_phy_masksets, also change a
few places that missed places that b43_phy_set could be used.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy.c |   86 +++++++++++++++-------------------------
 1 files changed, 32 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index 0ddb5d8..4f1129b 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -1137,8 +1137,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
 	b43_phy_write(dev, B43_PHY_CCK(0x58), 0x000D);
 
-	b43_phy_write(dev, B43_PHY_CCK(0x0A),
-		      b43_phy_read(dev, B43_PHY_CCK(0x0A)) | 0x2000);
+	b43_phy_set(dev, B43_PHY_CCK(0x0A), 0x2000);
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
 		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0004);
 		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFB);
@@ -1782,61 +1781,48 @@ void b43_set_rx_antenna(struct b43_wldev *dev, int antenna)
 	switch (phy->type) {
 	case B43_PHYTYPE_A:
 	case B43_PHYTYPE_G:
-		tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
-		tmp &= ~B43_PHY_BBANDCFG_RXANT;
-		tmp |= (autodiv ? B43_ANTENNA_AUTO0 : antenna)
-		    << B43_PHY_BBANDCFG_RXANT_SHIFT;
-		b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
+		if (autodiv)
+			tmp = B43_ANTENNA_AUTO0 << B43_PHY_BBANDCFG_RXANT_SHIFT;
+		else
+			tmp = antenna << B43_PHY_BBANDCFG_RXANT_SHIFT;
+
+		b43_phy_maskset(dev, B43_PHY_BBANDCFG,
+		    ~B43_PHY_BBANDCFG_RXANT, tmp);
 
 		if (autodiv) {
-			tmp = b43_phy_read(dev, B43_PHY_ANTDWELL);
 			if (antenna == B43_ANTENNA_AUTO0)
-				tmp &= ~B43_PHY_ANTDWELL_AUTODIV1;
+				b43_phy_mask(dev, B43_PHY_ANTDWELL,
+				    ~B43_PHY_ANTDWELL_AUTODIV1);
 			else
-				tmp |= B43_PHY_ANTDWELL_AUTODIV1;
-			b43_phy_write(dev, B43_PHY_ANTDWELL, tmp);
+				b43_phy_set(dev, B43_PHY_ANTDWELL,
+				    B43_PHY_ANTDWELL_AUTODIV1);
 		}
 		if (phy->type == B43_PHYTYPE_G) {
-			tmp = b43_phy_read(dev, B43_PHY_ANTWRSETT);
 			if (autodiv)
-				tmp |= B43_PHY_ANTWRSETT_ARXDIV;
+				b43_phy_set(dev, B43_PHY_ANTWRSETT, B43_PHY_ANTWRSETT_ARXDIV);
 			else
-				tmp &= ~B43_PHY_ANTWRSETT_ARXDIV;
-			b43_phy_write(dev, B43_PHY_ANTWRSETT, tmp);
-			if (phy->rev >= 2) {
-				tmp = b43_phy_read(dev, B43_PHY_OFDM61);
-				tmp |= B43_PHY_OFDM61_10;
-				b43_phy_write(dev, B43_PHY_OFDM61, tmp);
+				b43_phy_mask(dev, B43_PHY_ANTWRSETT, ~B43_PHY_ANTWRSETT_ARXDIV);
 
-				tmp =
-				    b43_phy_read(dev, B43_PHY_DIVSRCHGAINBACK);
-				tmp = (tmp & 0xFF00) | 0x15;
-				b43_phy_write(dev, B43_PHY_DIVSRCHGAINBACK,
-					      tmp);
+			if (phy->rev >= 2) {
+				b43_phy_set(dev, B43_PHY_OFDM61,
+					    B43_PHY_OFDM61_10);
+				b43_phy_maskset(dev, B43_PHY_DIVSRCHGAINBACK,
+						0xFF00, 0x0015);
 
-				if (phy->rev == 2) {
-					b43_phy_write(dev, B43_PHY_ADIVRELATED,
-						      8);
-				} else {
-					tmp =
-					    b43_phy_read(dev,
-							 B43_PHY_ADIVRELATED);
-					tmp = (tmp & 0xFF00) | 8;
-					b43_phy_write(dev, B43_PHY_ADIVRELATED,
-						      tmp);
-				}
+				if (phy->rev == 2)
+					b43_phy_write(dev, B43_PHY_ADIVRELATED, 0x0008);
+				else
+					b43_phy_maskset(dev, B43_PHY_ADIVRELATED,
+							0xFF00, 0x0008);
 			}
 			if (phy->rev >= 6)
 				b43_phy_write(dev, B43_PHY_OFDM9B, 0xDC);
 		} else {
 			if (phy->rev < 3) {
-				tmp = b43_phy_read(dev, B43_PHY_ANTDWELL);
-				tmp = (tmp & 0xFF00) | 0x24;
-				b43_phy_write(dev, B43_PHY_ANTDWELL, tmp);
+				b43_phy_maskset(dev, B43_PHY_ANTDWELL,
+						0xFF00, 0x0024);
 			} else {
-				tmp = b43_phy_read(dev, B43_PHY_OFDM61);
-				tmp |= 0x10;
-				b43_phy_write(dev, B43_PHY_OFDM61, tmp);
+				b43_phy_set(dev, B43_PHY_OFDM61, 0x0010);
 				if (phy->analog == 3) {
 					b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT,
 						      0x1D);
@@ -1845,12 +1831,8 @@ void b43_set_rx_antenna(struct b43_wldev *dev, int antenna)
 				} else {
 					b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT,
 						      0x3A);
-					tmp =
-					    b43_phy_read(dev,
-							 B43_PHY_ADIVRELATED);
-					tmp = (tmp & 0xFF00) | 8;
-					b43_phy_write(dev, B43_PHY_ADIVRELATED,
-						      tmp);
+					b43_phy_maskset(dev, B43_PHY_ADIVRELATED,
+							0xFF00, 0x0008);
 				}
 			}
 		}
@@ -2125,8 +2107,7 @@ u8 b43_radio_aci_scan(struct b43_wldev * dev)
 	b43_radio_selectchannel(dev, channel, 0);
 	b43_phy_maskset(dev, 0x0802, 0xFFFC, 0x0003);
 	b43_phy_mask(dev, 0x0403, 0xFFF8);
-	b43_phy_write(dev, B43_PHY_G_CRS,
-		      b43_phy_read(dev, B43_PHY_G_CRS) | 0x8000);
+	b43_phy_set(dev, B43_PHY_G_CRS, 0x8000);
 	b43_set_original_gains(dev);
 	for (i = 0; i < 13; i++) {
 		if (!ret[i])
@@ -2574,7 +2555,6 @@ void b43_calc_nrssi_threshold(struct b43_wldev *dev)
 	s32 threshold;
 	s32 a, b;
 	s16 tmp16;
-	u16 tmp_u16;
 
 	switch (phy->type) {
 	case B43_PHYTYPE_B:{
@@ -2650,10 +2630,8 @@ void b43_calc_nrssi_threshold(struct b43_wldev *dev)
 			b = b >> 6;
 			b = limit_value(b, -31, 31);
 
-			tmp_u16 = b43_phy_read(dev, 0x048A) & 0xF000;
-			tmp_u16 |= ((u32) b & 0x0000003F);
-			tmp_u16 |= (((u32) a & 0x0000003F) << 6);
-			b43_phy_write(dev, 0x048A, tmp_u16);
+			b43_phy_maskset(dev, 0x048A, 0xF000,
+			    ((u32)a & 0x3F) << 6 | ((u32)b & 0x3F));
 		}
 		break;
 	default:
-- 
1.5.5.1.482.g0f174


