Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57200 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYAMNOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 08:14:39 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix radio ID register reading
Date: Sun, 13 Jan 2008 14:12:44 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801131412.44830.mb@bu3sch.de> (sfid-20080113_131441_967894_42E6C8C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes reading of the high 16 bits of the radio ID
on new devices. 2055 radios want lo16 to be read first.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.25

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-13 13:26:18.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-13 13:59:27.000000000 +0100
@@ -3136,16 +3136,15 @@ static int b43_phy_versioning(struct b43
 		else if (dev->dev->bus->chip_rev == 1)
 			tmp = 0x4205017F;
 		else
 			tmp = 0x5205017F;
 	} else {
 		b43_write16(dev, B43_MMIO_RADIO_CONTROL, B43_RADIOCTL_ID);
-		tmp = b43_read16(dev, B43_MMIO_RADIO_DATA_HIGH);
-		tmp <<= 16;
+		tmp = b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
 		b43_write16(dev, B43_MMIO_RADIO_CONTROL, B43_RADIOCTL_ID);
-		tmp |= b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
+		tmp |= (u32)b43_read16(dev, B43_MMIO_RADIO_DATA_HIGH) << 16;
 	}
 	radio_manuf = (tmp & 0x00000FFF);
 	radio_ver = (tmp & 0x0FFFF000) >> 12;
 	radio_rev = (tmp & 0xF0000000) >> 28;
 	if (radio_manuf != 0x17F /* Broadcom */)
 		unsupported = 1;
@@ -3164,13 +3163,13 @@ static int b43_phy_versioning(struct b43
 		break;
 	case B43_PHYTYPE_G:
 		if (radio_ver != 0x2050)
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_N:
-		if (radio_ver != 5)
+		if (radio_ver != 0x2055)
 			unsupported = 1;
 		break;
 	default:
 		B43_WARN_ON(1);
 	}
 	if (unsupported) {
