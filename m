Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42180 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaEQVZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 17:25:11 -0400
Received: by mail-ee0-f51.google.com with SMTP id e51so2471398eek.10
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 14:25:10 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [next][PATCH 3/4] b43: complete PHY reset
Date: Sat, 17 May 2014 23:24:55 +0200
Message-Id: <1400361896-7345-3-git-send-email-zajec5@gmail.com> (sfid-20140517_232520_596976_47E3F0FC)
In-Reply-To: <1400361896-7345-1-git-send-email-zajec5@gmail.com>
References: <1400361896-7345-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use separated function for taking PHY out of reset and implement reset
for BCMA.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c       | 27 ++-------------
 drivers/net/wireless/b43/phy_common.c | 65 +++++++++++++++++++++++++++++++----
 drivers/net/wireless/b43/phy_common.h |  1 +
 3 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 43fbb88..46212d4 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1175,18 +1175,7 @@ static void b43_bcma_phy_reset(struct b43_wldev *dev)
 	bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, flags);
 	udelay(2);
 
-	/* Take PHY out of reset */
-	flags = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
-	flags &= ~B43_BCMA_IOCTL_PHY_RESET;
-	flags |= BCMA_IOCTL_FGC;
-	bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, flags);
-	udelay(1);
-
-	/* Do not force clock anymore */
-	flags = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
-	flags &= ~BCMA_IOCTL_FGC;
-	bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, flags);
-	udelay(1);
+	b43_phy_take_out_of_reset(dev);
 }
 
 static void b43_bcma_wireless_core_reset(struct b43_wldev *dev, bool gmode)
@@ -1211,8 +1200,6 @@ static void b43_bcma_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 #ifdef CONFIG_B43_SSB
 static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 {
-	struct ssb_device *sdev = dev->dev->sdev;
-	u32 tmslow;
 	u32 flags = 0;
 
 	if (gmode)
@@ -1224,17 +1211,7 @@ static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 	b43_device_enable(dev, flags);
 	msleep(2);		/* Wait for the PLL to turn on. */
 
-	/* Now take the PHY out of Reset again */
-	tmslow = ssb_read32(sdev, SSB_TMSLOW);
-	tmslow |= SSB_TMSLOW_FGC;
-	tmslow &= ~B43_TMSLOW_PHYRESET;
-	ssb_write32(sdev, SSB_TMSLOW, tmslow);
-	ssb_read32(sdev, SSB_TMSLOW);	/* flush */
-	msleep(1);
-	tmslow &= ~SSB_TMSLOW_FGC;
-	ssb_write32(sdev, SSB_TMSLOW, tmslow);
-	ssb_read32(sdev, SSB_TMSLOW);	/* flush */
-	msleep(1);
+	b43_phy_take_out_of_reset(dev);
 }
 #endif
 
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 85773a4..26e390f 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -314,15 +314,22 @@ void b43_phy_maskset(struct b43_wldev *dev, u16 offset, u16 mask, u16 set)
 
 void b43_phy_put_into_reset(struct b43_wldev *dev)
 {
-#ifdef CONFIG_B43_SSB
 	u32 tmp;
-#endif
 
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		b43err(dev->wl,
-		       "Putting PHY into reset not supported on BCMA\n");
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
+		tmp &= ~B43_BCMA_IOCTL_GMODE;
+		tmp |= B43_BCMA_IOCTL_PHY_RESET;
+		tmp |= BCMA_IOCTL_FGC;
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		udelay(1);
+
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
+		tmp &= ~BCMA_IOCTL_FGC;
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		udelay(1);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
@@ -332,14 +339,58 @@ void b43_phy_put_into_reset(struct b43_wldev *dev)
 		tmp |= B43_TMSLOW_PHYRESET;
 		tmp |= SSB_TMSLOW_FGC;
 		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
-		msleep(1);
+		usleep_range(1000, 2000);
 
 		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
 		tmp &= ~SSB_TMSLOW_FGC;
-		tmp |= B43_TMSLOW_PHYRESET;
 		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
-		msleep(1);
+		usleep_range(1000, 2000);
+
+		break;
+#endif
+	}
+}
 
+void b43_phy_take_out_of_reset(struct b43_wldev *dev)
+{
+	u32 tmp;
+
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		/* Unset reset bit (with forcing clock) */
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
+		tmp &= ~B43_BCMA_IOCTL_PHY_RESET;
+		tmp &= ~B43_BCMA_IOCTL_PHY_CLKEN;
+		tmp |= BCMA_IOCTL_FGC;
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		udelay(1);
+
+		/* Do not force clock anymore */
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
+		tmp &= ~BCMA_IOCTL_FGC;
+		tmp |= B43_BCMA_IOCTL_PHY_CLKEN;
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		udelay(1);
+		break;
+#endif
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		/* Unset reset bit (with forcing clock) */
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		tmp &= ~B43_TMSLOW_PHYRESET;
+		tmp &= ~B43_TMSLOW_PHYCLKEN;
+		tmp |= SSB_TMSLOW_FGC;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		ssb_read32(dev->dev->sdev, SSB_TMSLOW); /* flush */
+		usleep_range(1000, 2000);
+
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		tmp &= ~SSB_TMSLOW_FGC;
+		tmp |= B43_TMSLOW_PHYCLKEN;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		ssb_read32(dev->dev->sdev, SSB_TMSLOW); /* flush */
+		usleep_range(1000, 2000);
 		break;
 #endif
 	}
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 4f0fcec..4c80b09 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -391,6 +391,7 @@ void b43_phy_lock(struct b43_wldev *dev);
 void b43_phy_unlock(struct b43_wldev *dev);
 
 void b43_phy_put_into_reset(struct b43_wldev *dev);
+void b43_phy_take_out_of_reset(struct b43_wldev *dev);
 
 /**
  * b43_switch_channel - Switch to another channel
-- 
1.8.4.5

