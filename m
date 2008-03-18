Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:5105 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbYCRArm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 20:47:42 -0400
Received: by wr-out-0506.google.com with SMTP id c48so4253173wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 17:47:41 -0700 (PDT)
Subject: [PATCH 3/5] b43: fold register write into radio2050_rfover_val
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 17:47:30 -0700
Message-Id: <1205801250.2329.51.camel@brick> (sfid-20080318_004801_833780_2A86B580)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

radio2050_rfover_val was always nested within a b43_phy_write
to the same register.  Fold the b43_phy_write into radio_rfover_val
and change all of the returns to gotos.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy.c |  153 +++++++++++++++++----------------------
 1 files changed, 67 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index b3e369c..bac54bb 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -3324,14 +3324,17 @@ static u16 b43_radio_core_calibration_value(struct b43_wldev *dev)
 }
 
 #define LPD(L, P, D)	(((L) << 2) | ((P) << 1) | ((D) << 0))
-static u16 radio2050_rfover_val(struct b43_wldev *dev,
+static void radio2050_rfover_val(struct b43_wldev *dev,
 				u16 phy_register, unsigned int lpd)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
+	u16 data = 0;
 
-	if (!phy->gmode)
-		return 0;
+	if (!phy->gmode) {
+		data = 0;
+		goto writereg;
+	}
 
 	if (has_loopback_gain(phy)) {
 		int max_lb_gain = phy->max_lb_gain;
@@ -3365,37 +3368,46 @@ static u16 radio2050_rfover_val(struct b43_wldev *dev,
 		if ((phy->rev < 7) ||
 		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 			if (phy_register == B43_PHY_RFOVER) {
-				return 0x1B3;
+				data = 0x1B3;
+				goto writereg;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
 				extlna |= (i << 8);
 				switch (lpd) {
 				case LPD(0, 1, 1):
-					return 0x0F92;
+					data = 0x0F92;
+					goto writereg;
 				case LPD(0, 0, 1):
 				case LPD(1, 0, 1):
-					return (0x0092 | extlna);
+					data = (0x0092 | extlna);
+					goto writereg;
 				case LPD(1, 0, 0):
-					return (0x0093 | extlna);
+					data = (0x0093 | extlna);
+					goto writereg;
 				}
 				B43_WARN_ON(1);
 			}
 			B43_WARN_ON(1);
 		} else {
 			if (phy_register == B43_PHY_RFOVER) {
-				return 0x9B3;
+				data = 0x9B3;
+				goto writereg;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
 				if (extlna)
 					extlna |= 0x8000;
 				extlna |= (i << 8);
 				switch (lpd) {
 				case LPD(0, 1, 1):
-					return 0x8F92;
+					data = 0x8F92;
+					goto writereg;
 				case LPD(0, 0, 1):
-					return (0x8092 | extlna);
+					data = (0x8092 | extlna);
+					goto writereg;
 				case LPD(1, 0, 1):
-					return (0x2092 | extlna);
+					data = (0x2092 | extlna);
+					goto writereg;
 				case LPD(1, 0, 0):
-					return (0x2093 | extlna);
+					data = (0x2093 | extlna);
+					goto writereg;
 				}
 				B43_WARN_ON(1);
 			}
@@ -3405,41 +3417,53 @@ static u16 radio2050_rfover_val(struct b43_wldev *dev,
 		if ((phy->rev < 7) ||
 		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 			if (phy_register == B43_PHY_RFOVER) {
-				return 0x1B3;
+				data = 0x1B3;
+				goto writereg;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
 				switch (lpd) {
 				case LPD(0, 1, 1):
-					return 0x0FB2;
+					data = 0x0FB2;
+					goto writereg;
 				case LPD(0, 0, 1):
-					return 0x00B2;
+					data = 0x00B2;
+					goto writereg;
 				case LPD(1, 0, 1):
-					return 0x30B2;
+					data = 0x30B2;
+					goto writereg;
 				case LPD(1, 0, 0):
-					return 0x30B3;
+					data = 0x30B3;
+					goto writereg;
 				}
 				B43_WARN_ON(1);
 			}
 			B43_WARN_ON(1);
 		} else {
 			if (phy_register == B43_PHY_RFOVER) {
-				return 0x9B3;
+				data = 0x9B3;
+				goto writereg;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
 				switch (lpd) {
 				case LPD(0, 1, 1):
-					return 0x8FB2;
+					data = 0x8FB2;
+					goto writereg;
 				case LPD(0, 0, 1):
-					return 0x80B2;
+					data = 0x80B2;
+					goto writereg;
 				case LPD(1, 0, 1):
-					return 0x20B2;
+					data = 0x20B2;
+					goto writereg;
 				case LPD(1, 0, 0):
-					return 0x20B3;
+					data = 0x20B3;
+					goto writereg;
 				}
 				B43_WARN_ON(1);
 			}
 			B43_WARN_ON(1);
 		}
 	}
-	return 0;
+
+writereg:
+	b43_phy_write(dev, phy_register, data);
 }
 
 struct init2050_saved_values {
@@ -3525,11 +3549,8 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_PHY_LO_CTL, 0);
 		}
 
-		b43_phy_write(dev, B43_PHY_RFOVERVAL,
-			      radio2050_rfover_val(dev, B43_PHY_RFOVERVAL,
-						   LPD(0, 1, 1)));
-		b43_phy_write(dev, B43_PHY_RFOVER,
-			      radio2050_rfover_val(dev, B43_PHY_RFOVER, 0));
+		radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(0, 1, 1));
+		radio2050_rfover_val(dev, B43_PHY_RFOVER, 0);
 	}
 	b43_write16(dev, 0x3E2, b43_read16(dev, 0x3E2) | 0x8000);
 
@@ -3554,16 +3575,12 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 	if (phy->type == B43_PHYTYPE_B)
 		b43_radio_write16(dev, 0x78, 0x26);
 	if (phy->gmode || phy->rev >= 2) {
-		b43_phy_write(dev, B43_PHY_RFOVERVAL,
-			      radio2050_rfover_val(dev, B43_PHY_RFOVERVAL,
-						   LPD(0, 1, 1)));
+		radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(0, 1, 1));
 	}
 	b43_phy_write(dev, B43_PHY_PGACTL, 0xBFAF);
 	b43_phy_write(dev, B43_PHY_CCK(0x2B), 0x1403);
 	if (phy->gmode || phy->rev >= 2) {
-		b43_phy_write(dev, B43_PHY_RFOVERVAL,
-			      radio2050_rfover_val(dev, B43_PHY_RFOVERVAL,
-						   LPD(0, 0, 1)));
+		radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(0, 0, 1));
 	}
 	b43_phy_write(dev, B43_PHY_PGACTL, 0xBFA0);
 	b43_radio_write16(dev, 0x51, b43_radio_read16(dev, 0x51)
@@ -3581,38 +3598,22 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_PHY_CCK(0x5A), 0x0480);
 		b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
 		b43_phy_write(dev, B43_PHY_CCK(0x58), 0x000D);
-		if (phy->gmode || phy->rev >= 2) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      radio2050_rfover_val(dev,
-							   B43_PHY_RFOVERVAL,
-							   LPD(1, 0, 1)));
-		}
+		if (phy->gmode || phy->rev >= 2) 
+			radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xAFB0);
 		udelay(10);
-		if (phy->gmode || phy->rev >= 2) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      radio2050_rfover_val(dev,
-							   B43_PHY_RFOVERVAL,
-							   LPD(1, 0, 1)));
-		}
+		if (phy->gmode || phy->rev >= 2)
+			radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xEFB0);
 		udelay(10);
-		if (phy->gmode || phy->rev >= 2) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      radio2050_rfover_val(dev,
-							   B43_PHY_RFOVERVAL,
-							   LPD(1, 0, 0)));
-		}
+		if (phy->gmode || phy->rev >= 2)
+			radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 0));
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xFFF0);
 		udelay(20);
 		tmp1 += b43_phy_read(dev, B43_PHY_LO_LEAKAGE);
 		b43_phy_write(dev, B43_PHY_CCK(0x58), 0);
-		if (phy->gmode || phy->rev >= 2) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      radio2050_rfover_val(dev,
-							   B43_PHY_RFOVERVAL,
-							   LPD(1, 0, 1)));
-		}
+		if (phy->gmode || phy->rev >= 2)
+			radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xAFB0);
 	}
 	udelay(10);
@@ -3629,42 +3630,22 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_PHY_CCK(0x5A), 0x0D80);
 			b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
 			b43_phy_write(dev, B43_PHY_CCK(0x58), 0x000D);
-			if (phy->gmode || phy->rev >= 2) {
-				b43_phy_write(dev, B43_PHY_RFOVERVAL,
-					      radio2050_rfover_val(dev,
-								   B43_PHY_RFOVERVAL,
-								   LPD(1, 0,
-								       1)));
-			}
+			if (phy->gmode || phy->rev >= 2)
+				radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 			b43_phy_write(dev, B43_PHY_PGACTL, 0xAFB0);
 			udelay(10);
-			if (phy->gmode || phy->rev >= 2) {
-				b43_phy_write(dev, B43_PHY_RFOVERVAL,
-					      radio2050_rfover_val(dev,
-								   B43_PHY_RFOVERVAL,
-								   LPD(1, 0,
-								       1)));
-			}
+			if (phy->gmode || phy->rev >= 2)
+				radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 			b43_phy_write(dev, B43_PHY_PGACTL, 0xEFB0);
 			udelay(10);
-			if (phy->gmode || phy->rev >= 2) {
-				b43_phy_write(dev, B43_PHY_RFOVERVAL,
-					      radio2050_rfover_val(dev,
-								   B43_PHY_RFOVERVAL,
-								   LPD(1, 0,
-								       0)));
-			}
+			if (phy->gmode || phy->rev >= 2)
+				radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 0));
 			b43_phy_write(dev, B43_PHY_PGACTL, 0xFFF0);
 			udelay(10);
 			tmp2 += b43_phy_read(dev, B43_PHY_LO_LEAKAGE);
 			b43_phy_write(dev, B43_PHY_CCK(0x58), 0);
-			if (phy->gmode || phy->rev >= 2) {
-				b43_phy_write(dev, B43_PHY_RFOVERVAL,
-					      radio2050_rfover_val(dev,
-								   B43_PHY_RFOVERVAL,
-								   LPD(1, 0,
-								       1)));
-			}
+			if (phy->gmode || phy->rev >= 2)
+				radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 			b43_phy_write(dev, B43_PHY_PGACTL, 0xAFB0);
 		}
 		tmp2++;
-- 
1.5.4.4.684.g0e08


