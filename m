Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:33411 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXLZOop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2007 09:44:45 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: [PATCH, RFT] b43: Fix wakeup times
Date: Wed, 26 Dec 2007 15:41:56 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Joseph Jezak <josejx@gentoo.org>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200712261541.56807.mb@bu3sch.de> (sfid-20071226_144455_429338_E4E5FC7A)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix writing of some wakeup times.
The MMIO write does not change in functionality.
But I think the SHM writes are wrong. I think they are the old v3 firmware
API. It seems that this stuff moved in the v4 firmware API.
I guess that the old 0x416 offset is the PRETBTT offset in the new API.
That would make most sense to me. (We first write the PRETBTT MMIO register and
then a SHM location with the same value. So it would make sense so me if this
was the PRETBTT location).
The use of the new SH_SPUWKUP is also only a guess by me. It is SH_PRETBTT-2.
But this seems to make some sense to me.

Johannes, Joseph: Does this patch make sense? Can you probably check what
a recent vendor driver does?

Everybody, please test this patch for regressions.

NOT-signed-off-yet

Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2007-12-26 14:32:49.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2007-12-26 15:24:53.000000000 +0100
@@ -88,6 +88,7 @@
 #define B43_MMIO_GPIO_MASK		0x49E
 #define B43_MMIO_TSF_CFP_START_LOW	0x604
 #define B43_MMIO_TSF_CFP_START_HIGH	0x606
+#define B43_MMIO_TSF_CFP_PRETBTT	0x612
 #define B43_MMIO_TSF_0			0x632	/* core rev < 3 only */
 #define B43_MMIO_TSF_1			0x634	/* core rev < 3 only */
 #define B43_MMIO_TSF_2			0x636	/* core rev < 3 only */
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-26 14:32:49.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-26 15:33:22.000000000 +0100
@@ -3376,12 +3376,11 @@ static int b43_wireless_core_init(struct
 		goto err_chip_exit;
 	b43_qos_init(dev);
 
-//FIXME
-#if 1
-	b43_write16(dev, 0x0612, 0x0050);
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x0416, 0x0050);
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x0414, 0x01F4);
-#endif
+	/* Set the TSF CFP pre-TargetBeaconTransmissionTime (in microseconds). */
+	b43_write16(dev, B43_MMIO_TSF_CFP_PRETBTT, 80);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRETBTT, 80);
+	/* Set the pre-wakeup for synthetic PU (in microseconds). */
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SPUWKUP, 500);
 
 	b43_bluetooth_coext_enable(dev);
 
