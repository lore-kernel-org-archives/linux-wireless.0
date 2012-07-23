Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58707 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2GWUM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 16:12:57 -0400
Received: by weyx8 with SMTP id x8so4536657wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 13:12:56 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: fix logic in GPIO init
Date: Mon, 23 Jul 2012 22:57:01 +0200
Message-Id: <1343077021-14020-1-git-send-email-zajec5@gmail.com> (sfid-20120723_221301_290234_ECBF05FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some comments by the way

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index a56f182..f6f8ccd 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2719,32 +2719,37 @@ static int b43_gpio_init(struct b43_wldev *dev)
 	if (dev->dev->chip_id == 0x4301) {
 		mask |= 0x0060;
 		set |= 0x0060;
+	} else if (dev->dev->chip_id == 0x5354) {
+		/* Don't allow overtaking buttons GPIOs */
+		set &= 0x2; /* 0x2 is LED GPIO on BCM5354 */
 	}
-	if (dev->dev->chip_id == 0x5354)
-		set &= 0xff02;
+
 	if (0 /* FIXME: conditional unknown */ ) {
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
 			    b43_read16(dev, B43_MMIO_GPIO_MASK)
 			    | 0x0100);
-		mask |= 0x0180;
-		set |= 0x0180;
+		/* BT Coexistance Input */
+		mask |= 0x0080;
+		set |= 0x0080;
+		/* BT Coexistance Out */
+		mask |= 0x0100;
+		set |= 0x0100;
 	}
 	if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_PACTRL) {
+		/* PA is controlled by gpio 9, let ucode handle it */
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
 			    b43_read16(dev, B43_MMIO_GPIO_MASK)
 			    | 0x0200);
 		mask |= 0x0200;
 		set |= 0x0200;
 	}
-	if (dev->dev->core_rev >= 2)
-		mask |= 0x0010;	/* FIXME: This is redundant. */
 
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
 		bcma_cc_write32(&dev->dev->bdev->bus->drv_cc, BCMA_CC_GPIOCTL,
 				(bcma_cc_read32(&dev->dev->bdev->bus->drv_cc,
-					BCMA_CC_GPIOCTL) & mask) | set);
+					BCMA_CC_GPIOCTL) & ~mask) | set);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
@@ -2753,7 +2758,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
 		if (gpiodev)
 			ssb_write32(gpiodev, B43_GPIO_CONTROL,
 				    (ssb_read32(gpiodev, B43_GPIO_CONTROL)
-				    & mask) | set);
+				    & ~mask) | set);
 		break;
 #endif
 	}
-- 
1.7.7

