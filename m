Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:9540 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbYENS4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 14:56:50 -0400
Received: by el-out-1112.google.com with SMTP id s27so27680ele.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 11:56:48 -0700 (PDT)
Subject: [PATCH 5/5] b43: move the register write into radio2050_rfover_val
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 11:56:36 -0700
Message-Id: <1210791396.6191.40.camel@brick> (sfid-20080514_205653_281668_D72A8F9B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is always called with the same dev, register value as the
b43_phy_write that wraps around it, make it return void
and move the register write into radio2050_rfover_val.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy.c |  125 ++++++++++++++++++----------------------
 1 files changed, 56 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index 4f1129b..3c5dc1d 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -3022,14 +3022,15 @@ static u16 b43_radio_core_calibration_value(struct b43_wldev *dev)
 }
 
 #define LPD(L, P, D)	(((L) << 2) | ((P) << 1) | ((D) << 0))
-static u16 radio2050_rfover_val(struct b43_wldev *dev,
+static void radio2050_rfover_val(struct b43_wldev *dev,
 				u16 phy_register, unsigned int lpd)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
+	u16 value = 0;
 
 	if (!phy->gmode)
-		return 0;
+		goto write_value;
 
 	if (has_loopback_gain(phy)) {
 		int max_lb_gain = phy->max_lb_gain;
@@ -3063,37 +3064,46 @@ static u16 radio2050_rfover_val(struct b43_wldev *dev,
 		if ((phy->rev < 7) ||
 		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 			if (phy_register == B43_PHY_RFOVER) {
-				return 0x1B3;
+				value =  0x1B3;
+				goto write_value;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
 				extlna |= (i << 8);
 				switch (lpd) {
 				case LPD(0, 1, 1):
-					return 0x0F92;
+					value = 0x0F92;
+					goto write_value;
 				case LPD(0, 0, 1):
 				case LPD(1, 0, 1):
-					return (0x0092 | extlna);
+					value = 0x0092 | extlna;
+					goto write_value;
 				case LPD(1, 0, 0):
-					return (0x0093 | extlna);
+					value = 0x0093 | extlna;
+					goto write_value;
 				}
 				B43_WARN_ON(1);
 			}
 			B43_WARN_ON(1);
 		} else {
 			if (phy_register == B43_PHY_RFOVER) {
-				return 0x9B3;
+				value = 0x9B3;
+				goto write_value;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
 				if (extlna)
 					extlna |= 0x8000;
 				extlna |= (i << 8);
 				switch (lpd) {
 				case LPD(0, 1, 1):
-					return 0x8F92;
+					value = 0x8F92;
+					goto write_value;
 				case LPD(0, 0, 1):
-					return (0x8092 | extlna);
+					value = 0x8092 | extlna;
+					goto write_value;
 				case LPD(1, 0, 1):
-					return (0x2092 | extlna);
+					value = 0x2092 | extlna;
+					goto write_value;
 				case LPD(1, 0, 0):
-					return (0x2093 | extlna);
+					value = 0x2093 | extlna;
+					goto write_value;
 				}
 				B43_WARN_ON(1);
 			}
@@ -3103,41 +3113,53 @@ static u16 radio2050_rfover_val(struct b43_wldev *dev,
 		if ((phy->rev < 7) ||
 		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 			if (phy_register == B43_PHY_RFOVER) {
-				return 0x1B3;
+				value = 0x1B3;
+				goto write_value;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
 				switch (lpd) {
 				case LPD(0, 1, 1):
-					return 0x0FB2;
+					value = 0x0FB2;
+					goto write_value;
 				case LPD(0, 0, 1):
-					return 0x00B2;
+					value = 0x00B2;
+					goto write_value;
 				case LPD(1, 0, 1):
-					return 0x30B2;
+					value = 0x30B2;
+					goto write_value;
 				case LPD(1, 0, 0):
-					return 0x30B3;
+					value = 0x30B3;
+					goto write_value;
 				}
 				B43_WARN_ON(1);
 			}
 			B43_WARN_ON(1);
 		} else {
 			if (phy_register == B43_PHY_RFOVER) {
-				return 0x9B3;
+				value = 0x9B3;
+				goto write_value;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
 				switch (lpd) {
 				case LPD(0, 1, 1):
-					return 0x8FB2;
+					value = 0x8FB2;
+					goto write_value;
 				case LPD(0, 0, 1):
-					return 0x80B2;
+					value = 0x80B2;
+					goto write_value;
 				case LPD(1, 0, 1):
-					return 0x20B2;
+					value = 0x20B2;
+					goto write_value;
 				case LPD(1, 0, 0):
-					return 0x20B3;
+					value = 0x20B3;
+					goto write_value;
 				}
 				B43_WARN_ON(1);
 			}
 			B43_WARN_ON(1);
 		}
 	}
-	return 0;
+
+write_value:
+	b43_phy_write(dev, phy_register, value);
 }
 
 struct init2050_saved_values {
@@ -3216,11 +3238,8 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
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
 
@@ -3246,16 +3265,12 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
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
@@ -3274,36 +3289,24 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
 		b43_phy_write(dev, B43_PHY_CCK(0x58), 0x000D);
 		if (phy->gmode || phy->rev >= 2) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      radio2050_rfover_val(dev,
-							   B43_PHY_RFOVERVAL,
-							   LPD(1, 0, 1)));
+			radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 		}
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xAFB0);
 		udelay(10);
 		if (phy->gmode || phy->rev >= 2) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      radio2050_rfover_val(dev,
-							   B43_PHY_RFOVERVAL,
-							   LPD(1, 0, 1)));
+			radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 		}
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xEFB0);
 		udelay(10);
 		if (phy->gmode || phy->rev >= 2) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      radio2050_rfover_val(dev,
-							   B43_PHY_RFOVERVAL,
-							   LPD(1, 0, 0)));
+			radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 0));
 		}
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xFFF0);
 		udelay(20);
 		tmp1 += b43_phy_read(dev, B43_PHY_LO_LEAKAGE);
 		b43_phy_write(dev, B43_PHY_CCK(0x58), 0);
 		if (phy->gmode || phy->rev >= 2) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      radio2050_rfover_val(dev,
-							   B43_PHY_RFOVERVAL,
-							   LPD(1, 0, 1)));
+			radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 		}
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xAFB0);
 	}
@@ -3322,40 +3325,24 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
 			b43_phy_write(dev, B43_PHY_CCK(0x58), 0x000D);
 			if (phy->gmode || phy->rev >= 2) {
-				b43_phy_write(dev, B43_PHY_RFOVERVAL,
-					      radio2050_rfover_val(dev,
-								   B43_PHY_RFOVERVAL,
-								   LPD(1, 0,
-								       1)));
+				radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 			}
 			b43_phy_write(dev, B43_PHY_PGACTL, 0xAFB0);
 			udelay(10);
 			if (phy->gmode || phy->rev >= 2) {
-				b43_phy_write(dev, B43_PHY_RFOVERVAL,
-					      radio2050_rfover_val(dev,
-								   B43_PHY_RFOVERVAL,
-								   LPD(1, 0,
-								       1)));
+				radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 			}
 			b43_phy_write(dev, B43_PHY_PGACTL, 0xEFB0);
 			udelay(10);
 			if (phy->gmode || phy->rev >= 2) {
-				b43_phy_write(dev, B43_PHY_RFOVERVAL,
-					      radio2050_rfover_val(dev,
-								   B43_PHY_RFOVERVAL,
-								   LPD(1, 0,
-								       0)));
+				radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 0));
 			}
 			b43_phy_write(dev, B43_PHY_PGACTL, 0xFFF0);
 			udelay(10);
 			tmp2 += b43_phy_read(dev, B43_PHY_LO_LEAKAGE);
 			b43_phy_write(dev, B43_PHY_CCK(0x58), 0);
 			if (phy->gmode || phy->rev >= 2) {
-				b43_phy_write(dev, B43_PHY_RFOVERVAL,
-					      radio2050_rfover_val(dev,
-								   B43_PHY_RFOVERVAL,
-								   LPD(1, 0,
-								       1)));
+				radio2050_rfover_val(dev, B43_PHY_RFOVERVAL, LPD(1, 0, 1));
 			}
 			b43_phy_write(dev, B43_PHY_PGACTL, 0xAFB0);
 		}
-- 
1.5.5.1.482.g0f174

