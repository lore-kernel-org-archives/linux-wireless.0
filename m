Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60437 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZH1ThA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 15:37:00 -0400
Received: by fxm17 with SMTP id 17so1758032fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2009 12:37:01 -0700 (PDT)
Message-ID: <4A9831DC.4050802@gmail.com>
Date: Fri, 28 Aug 2009 21:37:00 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: Refactor and update antenna diversity for A/G-PHY
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-Make use of the b43_phy_set/mask/maskset helpers.
-Fix a few errors in the code.
-Make the code more readable.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
The "phy->analog == 3" to "phy->rev == 3" change in A-PHY is intentional,
it's a bugfix/spec conformance fix.

 drivers/net/wireless/b43/phy_a.c |   48 ++++++++++----------------------
 drivers/net/wireless/b43/phy_g.c |   55 +++++++++++++++----------------------
 2 files changed, 37 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index 809ec97..d90217c 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -518,58 +518,40 @@ static unsigned int b43_aphy_op_get_default_chan(struct b43_wldev *dev)
 static void b43_aphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
 {//TODO
 	struct b43_phy *phy = &dev->phy;
-	u64 hf;
 	u16 tmp;
 	int autodiv = 0;
 
 	if (antenna == B43_ANTENNA_AUTO0 || antenna == B43_ANTENNA_AUTO1)
 		autodiv = 1;
 
-	hf = b43_hf_read(dev);
-	hf &= ~B43_HF_ANTDIVHELP;
-	b43_hf_write(dev, hf);
+	b43_hf_write(dev, b43_hf_read(dev) & ~B43_HF_ANTDIVHELP);
 
-	tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
-	tmp &= ~B43_PHY_BBANDCFG_RXANT;
-	tmp |= (autodiv ? B43_ANTENNA_AUTO1 : antenna)
-	    << B43_PHY_BBANDCFG_RXANT_SHIFT;
-	b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
+	b43_phy_maskset(dev, B43_PHY_BBANDCFG, ~B43_PHY_BBANDCFG_RXANT,
+			(autodiv ? B43_ANTENNA_AUTO1 : antenna) <<
+			B43_PHY_BBANDCFG_RXANT_SHIFT);
 
 	if (autodiv) {
 		tmp = b43_phy_read(dev, B43_PHY_ANTDWELL);
-		if (antenna == B43_ANTENNA_AUTO0)
+		if (antenna == B43_ANTENNA_AUTO1)
 			tmp &= ~B43_PHY_ANTDWELL_AUTODIV1;
 		else
 			tmp |= B43_PHY_ANTDWELL_AUTODIV1;
 		b43_phy_write(dev, B43_PHY_ANTDWELL, tmp);
 	}
-	if (phy->rev < 3) {
-		tmp = b43_phy_read(dev, B43_PHY_ANTDWELL);
-		tmp = (tmp & 0xFF00) | 0x24;
-		b43_phy_write(dev, B43_PHY_ANTDWELL, tmp);
-	} else {
-		tmp = b43_phy_read(dev, B43_PHY_OFDM61);
-		tmp |= 0x10;
-		b43_phy_write(dev, B43_PHY_OFDM61, tmp);
-		if (phy->analog == 3) {
-			b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT,
-				      0x1D);
-			b43_phy_write(dev, B43_PHY_ADIVRELATED,
-				      8);
+	if (phy->rev < 3)
+		b43_phy_maskset(dev, B43_PHY_ANTDWELL, 0xFF00, 0x24);
+	else {
+		b43_phy_set(dev, B43_PHY_OFDM61, 0x10);
+		if (phy->rev == 3) {
+			b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT, 0x1D);
+			b43_phy_write(dev, B43_PHY_ADIVRELATED, 8);
 		} else {
-			b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT,
-				      0x3A);
-			tmp =
-			    b43_phy_read(dev,
-					 B43_PHY_ADIVRELATED);
-			tmp = (tmp & 0xFF00) | 8;
-			b43_phy_write(dev, B43_PHY_ADIVRELATED,
-				      tmp);
+			b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT, 0x3A);
+			b43_phy_maskset(dev, B43_PHY_ADIVRELATED, 0xFF00, 8);
 		}
 	}
 
-	hf |= B43_HF_ANTDIVHELP;
-	b43_hf_write(dev, hf);
+	b43_hf_write(dev, b43_hf_read(dev) | B43_HF_ANTDIVHELP);
 }
 
 static void b43_aphy_op_adjust_txpower(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index c6d639d..4b6154b 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -2638,65 +2638,54 @@ static unsigned int b43_gphy_op_get_default_chan(struct b43_wldev *dev)
 static void b43_gphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
 {
 	struct b43_phy *phy = &dev->phy;
-	u64 hf;
 	u16 tmp;
 	int autodiv = 0;
 
 	if (antenna == B43_ANTENNA_AUTO0 || antenna == B43_ANTENNA_AUTO1)
 		autodiv = 1;
 
-	hf = b43_hf_read(dev);
-	hf &= ~B43_HF_ANTDIVHELP;
-	b43_hf_write(dev, hf);
-
-	tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
-	tmp &= ~B43_PHY_BBANDCFG_RXANT;
-	tmp |= (autodiv ? B43_ANTENNA_AUTO1 : antenna)
-			<< B43_PHY_BBANDCFG_RXANT_SHIFT;
-	b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
+	b43_hf_write(dev, b43_hf_read(dev) & ~B43_HF_ANTDIVHELP);
 
+	b43_phy_maskset(dev, B43_PHY_BBANDCFG, ~B43_PHY_BBANDCFG_RXANT,
+			(autodiv ? B43_ANTENNA_AUTO1 : antenna) <<
+			B43_PHY_BBANDCFG_RXANT_SHIFT);
+			
 	if (autodiv) {
 		tmp = b43_phy_read(dev, B43_PHY_ANTDWELL);
-		if (antenna == B43_ANTENNA_AUTO0)
+		if (antenna == B43_ANTENNA_AUTO1)
 			tmp &= ~B43_PHY_ANTDWELL_AUTODIV1;
 		else
 			tmp |= B43_PHY_ANTDWELL_AUTODIV1;
 		b43_phy_write(dev, B43_PHY_ANTDWELL, tmp);
 	}
+
 	tmp = b43_phy_read(dev, B43_PHY_ANTWRSETT);
 	if (autodiv)
 		tmp |= B43_PHY_ANTWRSETT_ARXDIV;
 	else
 		tmp &= ~B43_PHY_ANTWRSETT_ARXDIV;
 	b43_phy_write(dev, B43_PHY_ANTWRSETT, tmp);
-	if (phy->rev >= 2) {
-		tmp = b43_phy_read(dev, B43_PHY_OFDM61);
-		tmp |= B43_PHY_OFDM61_10;
-		b43_phy_write(dev, B43_PHY_OFDM61, tmp);
 
-		tmp =
-		    b43_phy_read(dev, B43_PHY_DIVSRCHGAINBACK);
-		tmp = (tmp & 0xFF00) | 0x15;
-		b43_phy_write(dev, B43_PHY_DIVSRCHGAINBACK,
-			      tmp);
+	if (autodiv)
+		b43_phy_set(dev, B43_PHY_ANTWRSETT, B43_PHY_ANTWRSETT_ARXDIV);
+	else {
+		b43_phy_mask(dev, B43_PHY_ANTWRSETT,
+			     B43_PHY_ANTWRSETT_ARXDIV);
+	}
 
-		if (phy->rev == 2) {
-			b43_phy_write(dev, B43_PHY_ADIVRELATED,
-				      8);
-		} else {
-			tmp =
-			    b43_phy_read(dev,
-					 B43_PHY_ADIVRELATED);
-			tmp = (tmp & 0xFF00) | 8;
-			b43_phy_write(dev, B43_PHY_ADIVRELATED,
-				      tmp);
-		}
+	if (phy->rev >= 2) {
+		b43_phy_set(dev, B43_PHY_OFDM61, B43_PHY_OFDM61_10);
+		b43_phy_maskset(dev, B43_PHY_DIVSRCHGAINBACK, 0xFF00, 0x15);
+
+		if (phy->rev == 2)
+			b43_phy_write(dev, B43_PHY_ADIVRELATED, 8);
+		else
+			b43_phy_maskset(dev, B43_PHY_ADIVRELATED, 0xFF00, 8);
 	}
 	if (phy->rev >= 6)
 		b43_phy_write(dev, B43_PHY_OFDM9B, 0xDC);
 
-	hf |= B43_HF_ANTDIVHELP;
-	b43_hf_write(dev, hf);
+	b43_hf_write(dev, b43_hf_read(dev) | B43_HF_ANTDIVHELP);
 }
 
 static int b43_gphy_op_interf_mitigation(struct b43_wldev *dev,
-- 
1.6.2.4



