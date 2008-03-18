Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:58061 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbYCRArn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 20:47:43 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6645297wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 17:47:43 -0700 (PDT)
Subject: [PATCH 4/5] b43: Organize cases in radio2050_rfover_val
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 17:47:30 -0700
Message-Id: <1205801250.2329.53.camel@brick> (sfid-20080318_004802_183738_B5239890)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function has three independant states that are looked at

phy_register: B43_PHY_RFOVER, B43_PHY_RFOVERVAL
lb_gain: has_loopback_gain(phy)
phy_lna: (phy->rev < 7) || !(sprom->boardflags_lo & B43_BFL_EXTLNA)

The B43_PHY_RFOVER case depends only on the phy_lna value, make this
test explicit.

The B43_PHY_RFOVERVAL case depends on both lb_gain and phy_lna.

Move the calculation of extlna before the if blocks and pull up an
adjustment that depends on phy_lna out of the switch statements.

Consolidate the switch statements using a conditional on phy_lna.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy.c |  133 ++++++++++++++--------------------------
 1 files changed, 46 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index bac54bb..0e2b065 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -3329,22 +3329,28 @@ static void radio2050_rfover_val(struct b43_wldev *dev,
 {
 	struct b43_phy *phy = &dev->phy;
 	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
+	int lb_gain;
+	int phy_lna;
 	u16 data = 0;
+	u16 extlna;
 
 	if (!phy->gmode) {
 		data = 0;
 		goto writereg;
 	}
 
-	if (has_loopback_gain(phy)) {
+	phy_lna = (phy->rev < 7) || !(sprom->boardflags_lo & B43_BFL_EXTLNA);
+
+	lb_gain = has_loopback_gain(phy);
+	if (lb_gain) {
 		int max_lb_gain = phy->max_lb_gain;
-		u16 extlna;
 		u16 i;
 
 		if (phy->radio_rev == 8)
 			max_lb_gain += 0x3E;
 		else
 			max_lb_gain += 0x26;
+
 		if (max_lb_gain >= 0x46) {
 			extlna = 0x3000;
 			max_lb_gain -= 0x46;
@@ -3365,101 +3371,54 @@ static void radio2050_rfover_val(struct b43_wldev *dev,
 				break;
 		}
 
-		if ((phy->rev < 7) ||
-		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
-			if (phy_register == B43_PHY_RFOVER) {
-				data = 0x1B3;
+		if (!phy_lna && extlna)
+			extlna |= 0x8000;
+		extlna |= (i << 8);
+	}
+
+	if (phy_register == B43_PHY_RFOVER) {
+		if (phy_lna)
+			data = 0x01B3;
+		else
+			data = 0x09B3;
+		goto writereg;
+	} else if (phy_register == B43_PHY_RFOVERVAL) {
+		if (lb_gain) {
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				data = (phy_lna ? 0x0F92 : 0x8F92);
 				goto writereg;
-			} else if (phy_register == B43_PHY_RFOVERVAL) {
-				extlna |= (i << 8);
-				switch (lpd) {
-				case LPD(0, 1, 1):
-					data = 0x0F92;
-					goto writereg;
-				case LPD(0, 0, 1):
-				case LPD(1, 0, 1):
-					data = (0x0092 | extlna);
-					goto writereg;
-				case LPD(1, 0, 0):
-					data = (0x0093 | extlna);
-					goto writereg;
-				}
-				B43_WARN_ON(1);
-			}
-			B43_WARN_ON(1);
-		} else {
-			if (phy_register == B43_PHY_RFOVER) {
-				data = 0x9B3;
+			case LPD(0, 0, 1):
+				data = (phy_lna ? 0x0092 : 0x8092) | extlna;
 				goto writereg;
-			} else if (phy_register == B43_PHY_RFOVERVAL) {
-				if (extlna)
-					extlna |= 0x8000;
-				extlna |= (i << 8);
-				switch (lpd) {
-				case LPD(0, 1, 1):
-					data = 0x8F92;
-					goto writereg;
-				case LPD(0, 0, 1):
-					data = (0x8092 | extlna);
-					goto writereg;
-				case LPD(1, 0, 1):
-					data = (0x2092 | extlna);
-					goto writereg;
-				case LPD(1, 0, 0):
-					data = (0x2093 | extlna);
-					goto writereg;
-				}
-				B43_WARN_ON(1);
-			}
-			B43_WARN_ON(1);
-		}
-	} else {
-		if ((phy->rev < 7) ||
-		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
-			if (phy_register == B43_PHY_RFOVER) {
-				data = 0x1B3;
+			case LPD(1, 0, 1):
+				data = (phy_lna ? 0x0092 : 0x2092) | extlna;
+				goto writereg;
+			case LPD(1, 0, 0):
+				data = (phy_lna ? 0x0093 : 0x2093) | extlna;
 				goto writereg;
-			} else if (phy_register == B43_PHY_RFOVERVAL) {
-				switch (lpd) {
-				case LPD(0, 1, 1):
-					data = 0x0FB2;
-					goto writereg;
-				case LPD(0, 0, 1):
-					data = 0x00B2;
-					goto writereg;
-				case LPD(1, 0, 1):
-					data = 0x30B2;
-					goto writereg;
-				case LPD(1, 0, 0):
-					data = 0x30B3;
-					goto writereg;
-				}
-				B43_WARN_ON(1);
 			}
 			B43_WARN_ON(1);
 		} else {
-			if (phy_register == B43_PHY_RFOVER) {
-				data = 0x9B3;
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				data = phy_lna ? 0x0FB2 : 0x8FB2;
+				goto writereg;
+			case LPD(0, 0, 1):
+				data = phy_lna ? 0x00B2 : 0x80B2;
+				goto writereg;
+			case LPD(1, 0, 1):
+				data = phy_lna ? 0x30B2 : 0x20B2;
+				goto writereg;
+			case LPD(1, 0, 0):
+				data = phy_lna ? 0x30B3 : 0x20B3;
 				goto writereg;
-			} else if (phy_register == B43_PHY_RFOVERVAL) {
-				switch (lpd) {
-				case LPD(0, 1, 1):
-					data = 0x8FB2;
-					goto writereg;
-				case LPD(0, 0, 1):
-					data = 0x80B2;
-					goto writereg;
-				case LPD(1, 0, 1):
-					data = 0x20B2;
-					goto writereg;
-				case LPD(1, 0, 0):
-					data = 0x20B3;
-					goto writereg;
-				}
-				B43_WARN_ON(1);
 			}
 			B43_WARN_ON(1);
 		}
+	} else {
+		/* B43_PHY_RFOVER, B43_PHY_RFOVERVAL are the only valid args */
+		B43_WARN_ON(1);
 	}
 
 writereg:
-- 
1.5.4.4.684.g0e08


