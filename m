Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:1504 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbYIGEaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 00:30:06 -0400
Received: from [172.17.0.188] ([61.8.118.66])
 by Opus1.COM (PMDF V6.2-X27 #9830) with ESMTPSA id
 <01MZ981M7C4A8YGH3N@Opus1.COM> for linux-wireless@vger.kernel.org; Sat,
 06 Sep 2008 21:30:04 -0700 (MST)
Date: Sat, 06 Sep 2008 21:30:00 -0700
From: gavron@wetwork.net
Subject: [PATCH] b43legacy: Fix to enhance TX speed
To: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <larry.finger@lwfinger.net>
Message-id: <48C358C8.3080607@wetwork.net> (sfid-20080907_063023_482963_D98AEC5B)
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_NZLWqnidqKmz8VQwCGCoiA)"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_NZLWqnidqKmz8VQwCGCoiA)
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit


--Boundary_(ID_NZLWqnidqKmz8VQwCGCoiA)
Content-type: text/plain; CHARSET=us-ascii; name=b43legacy_speed_enhancement
Content-transfer-encoding: 7bit
Content-disposition: inline; filename=b43legacy_speed_enhancement

Recent changes in the specifications have improved the performance
of the BCM4306/2 devices that use b43legacy as the driver. These
"errors" in the specs have been present from the very first implementation
of bcm43xx.

Signed-off-by: Ehud Gavron <gavron@wetwork.net>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.28.material.

Ehud
---

Index: linux-2.6/drivers/net/wireless/b43legacy/phy.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/phy.c
+++ linux-2.6/drivers/net/wireless/b43legacy/phy.c
@@ -595,12 +595,14 @@ static void b43legacy_phy_initb5(struct
 				    0x0035) & 0xFFC0) | 0x0064);
 		b43legacy_phy_write(dev, 0x005D, (b43legacy_phy_read(dev,
 				    0x005D) & 0xFF80) | 0x000A);
+		b43legacy_phy_write(dev, 0x5B, 0x0000);
+		b43legacy_phy_write(dev, 0x5C, 0x0000);
 	}
 
 	if (dev->bad_frames_preempt)
 		b43legacy_phy_write(dev, B43legacy_PHY_RADIO_BITFIELD,
 				    b43legacy_phy_read(dev,
-				    B43legacy_PHY_RADIO_BITFIELD) | (1 << 11));
+				    B43legacy_PHY_RADIO_BITFIELD) | (1 << 12));
 
 	if (phy->analog == 1) {
 		b43legacy_phy_write(dev, 0x0026, 0xCE00);
@@ -753,7 +755,7 @@ static void b43legacy_phy_initb6(struct
 		b43legacy_radio_write16(dev, 0x0050, 0x0020);
 	}
 	if (phy->radio_rev <= 2) {
-		b43legacy_radio_write16(dev, 0x007C, 0x0020);
+		b43legacy_radio_write16(dev, 0x0050, 0x0020);
 		b43legacy_radio_write16(dev, 0x005A, 0x0070);
 		b43legacy_radio_write16(dev, 0x005B, 0x007B);
 		b43legacy_radio_write16(dev, 0x005C, 0x00B0);
@@ -771,7 +773,7 @@ static void b43legacy_phy_initb6(struct
 		b43legacy_phy_write(dev, 0x002A, 0x8AC0);
 	b43legacy_phy_write(dev, 0x0038, 0x0668);
 	b43legacy_radio_set_txpower_bg(dev, 0xFFFF, 0xFFFF, 0xFFFF);
-	if (phy->radio_rev <= 5)
+	if (phy->radio_rev == 4 || phy->radio_rev == 5)
 		b43legacy_phy_write(dev, 0x005D, (b43legacy_phy_read(dev,
 				    0x005D) & 0xFF80) | 0x0003);
 	if (phy->radio_rev <= 2)
@@ -1010,7 +1012,7 @@ static void b43legacy_phy_initg(struct b
 		b43legacy_phy_initb5(dev);
 	else
 		b43legacy_phy_initb6(dev);
-	if (phy->rev >= 2 || phy->gmode)
+	if (phy->rev >= 2 && phy->gmode)
 		b43legacy_phy_inita(dev);
 
 	if (phy->rev >= 2) {
@@ -1025,18 +1027,22 @@ static void b43legacy_phy_initg(struct b
 		b43legacy_phy_write(dev, 0x0811, 0x0400);
 		b43legacy_phy_write(dev, 0x0015, 0x00C0);
 	}
-	if (phy->rev >= 2 || phy->gmode) {
+	if (phy->gmode) {
 		tmp = b43legacy_phy_read(dev, 0x0400) & 0xFF;
-		if (tmp == 3 || tmp == 5) {
+		if (tmp == 3) {
+			b43legacy_phy_write(dev, 0x04C2, 0x1816);
+			b43legacy_phy_write(dev, 0x04C3, 0x8606);
+		}
+		if (tmp == 4 || tmp == 5) {
 			b43legacy_phy_write(dev, 0x04C2, 0x1816);
 			b43legacy_phy_write(dev, 0x04C3, 0x8006);
-			if (tmp == 5)
-				b43legacy_phy_write(dev, 0x04CC,
-						    (b43legacy_phy_read(dev,
-						     0x04CC) & 0x00FF) |
-						     0x1F00);
+			b43legacy_phy_write(dev, 0x04CC,
+					    (b43legacy_phy_read(dev,
+					     0x04CC) & 0x00FF) |
+					     0x1F00);
 		}
-		b43legacy_phy_write(dev, 0x047E, 0x0078);
+		if (phy->rev >= 2)
+			b43legacy_phy_write(dev, 0x047E, 0x0078);
 	}
 	if (phy->radio_rev == 8) {
 		b43legacy_phy_write(dev, 0x0801, b43legacy_phy_read(dev, 0x0801)
@@ -1078,7 +1084,7 @@ static void b43legacy_phy_initg(struct b
 		else
 			b43legacy_phy_write(dev, 0x002F, 0x0202);
 	}
-	if (phy->gmode || phy->rev >= 2) {
+	if (phy->gmode) {
 		b43legacy_phy_lo_adjust(dev, 0);
 		b43legacy_phy_write(dev, 0x080F, 0x8078);
 	}


--Boundary_(ID_NZLWqnidqKmz8VQwCGCoiA)--
