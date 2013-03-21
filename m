Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49492 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab3CUPTx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 11:19:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] b43: use bcma_chipco_gpio_control()
Date: Thu, 21 Mar 2013 16:19:45 +0100
Message-Id: <1363879185-23809-1-git-send-email-hauke@hauke-m.de> (sfid-20130321_161956_758347_F5E4F524)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this patch the same registers are written, but this access is now
protected by a lock.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/main.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c4d0cc5..ae4eeb3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2780,9 +2780,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		bcma_cc_write32(&dev->dev->bdev->bus->drv_cc, BCMA_CC_GPIOCTL,
-				(bcma_cc_read32(&dev->dev->bdev->bus->drv_cc,
-					BCMA_CC_GPIOCTL) & ~mask) | set);
+		bcma_chipco_gpio_control(&dev->dev->bdev->bus->drv_cc, mask, set);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
@@ -2807,8 +2805,7 @@ static void b43_gpio_cleanup(struct b43_wldev *dev)
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		bcma_cc_write32(&dev->dev->bdev->bus->drv_cc, BCMA_CC_GPIOCTL,
-				0);
+		bcma_chipco_gpio_control(&dev->dev->bdev->bus->drv_cc, ~0, 0);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
-- 
1.7.10.4

