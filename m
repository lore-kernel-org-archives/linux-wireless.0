Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38477 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1GPPtW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:49:22 -0400
Received: by fxd18 with SMTP id 18so4255511fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 08:49:21 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: use agent R/W ops for BCMA_IOCTL
Date: Sat, 16 Jul 2011 18:27:55 +0200
Message-Id: <1310833675-3103-1-git-send-email-zajec5@gmail.com> (sfid-20110716_174930_087167_92F0A782)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BCMA_IOCTL is register in agent (AKA wrapper) core, we need to use
special R/W ops for it.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c  |    4 ++--
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index b7c7b85..22f20e1 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2814,12 +2814,12 @@ void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on)
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		tmp = bcma_read32(dev->dev->bdev, BCMA_IOCTL);
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
 		if (on)
 			tmp |= B43_BCMA_IOCTL_MACPHYCLKEN;
 		else
 			tmp &= ~B43_BCMA_IOCTL_MACPHYCLKEN;
-		bcma_write32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 95c28f5..1ae1e84 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -611,12 +611,12 @@ static void b43_nphy_bmac_clock_fgc(struct b43_wldev *dev, bool force)
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		tmp = bcma_read32(dev->dev->bdev, BCMA_IOCTL);
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
 		if (force)
 			tmp |= BCMA_IOCTL_FGC;
 		else
 			tmp &= ~BCMA_IOCTL_FGC;
-		bcma_write32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
-- 
1.7.3.4

