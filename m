Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:64695 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1GFNHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 09:07:08 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so65969fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 06:07:08 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: handle BCMA in bus switches
Date: Wed,  6 Jul 2011 15:45:27 +0200
Message-Id: <1309959928-5731-2-git-send-email-zajec5@gmail.com> (sfid-20110706_150713_552701_E4141803)
In-Reply-To: <1309959928-5731-1-git-send-email-zajec5@gmail.com>
References: <1309959928-5731-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c  |   68 ++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_n.c |   22 ++++++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index dd6d652..f80a53d 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1155,6 +1155,21 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 	}
 }
 
+#ifdef CONFIG_B43_BCMA
+static void b43_bcma_wireless_core_reset(struct b43_wldev *dev, bool gmode)
+{
+	u32 flags = 0;
+
+	if (gmode)
+		flags = B43_BCMA_IOCTL_GMODE;
+	flags |= B43_BCMA_IOCTL_PHY_CLKEN;
+	flags |= B43_BCMA_IOCTL_PHY_BW_20MHZ; /* Make 20 MHz def */
+	b43_device_enable(dev, flags);
+
+	/* TODO: reset PHY */
+}
+#endif
+
 static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 {
 	struct ssb_device *sdev = dev->dev->sdev;
@@ -1188,6 +1203,11 @@ void b43_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 	u32 macctl;
 
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		b43_bcma_wireless_core_reset(dev, gmode);
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		b43_ssb_wireless_core_reset(dev, gmode);
@@ -2631,6 +2651,13 @@ static int b43_gpio_init(struct b43_wldev *dev)
 		mask |= 0x0010;	/* FIXME: This is redundant. */
 
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		bcma_cc_write32(&dev->dev->bdev->bus->drv_cc, BCMA_CC_GPIOCTL,
+				(bcma_cc_read32(&dev->dev->bdev->bus->drv_cc,
+					BCMA_CC_GPIOCTL) & mask) | set);
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		gpiodev = b43_ssb_gpio_dev(dev);
@@ -2651,6 +2678,12 @@ static void b43_gpio_cleanup(struct b43_wldev *dev)
 	struct ssb_device *gpiodev;
 
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		bcma_cc_write32(&dev->dev->bdev->bus->drv_cc, BCMA_CC_GPIOCTL,
+				0);
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		gpiodev = b43_ssb_gpio_dev(dev);
@@ -2733,6 +2766,16 @@ void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on)
 	u32 tmp;
 
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		tmp = bcma_read32(dev->dev->bdev, BCMA_IOCTL);
+		if (on)
+			tmp |= B43_BCMA_IOCTL_MACPHYCLKEN;
+		else
+			tmp &= ~B43_BCMA_IOCTL_MACPHYCLKEN;
+		bcma_write32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
@@ -2983,6 +3026,12 @@ static int b43_chip_init(struct b43_wldev *dev)
 	b43_mac_phy_clock_set(dev, true);
 
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		/* FIXME: 0xE74 is quite common, but should be read from CC */
+		b43_write16(dev, B43_MMIO_POWERUP_DELAY, 0xE74);
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		b43_write16(dev, B43_MMIO_POWERUP_DELAY,
@@ -3508,6 +3557,12 @@ static void b43_put_phy_into_reset(struct b43_wldev *dev)
 	u32 tmp;
 
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		b43err(dev->wl,
+		       "Putting PHY into reset not supported on BCMA\n");
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
@@ -4404,6 +4459,12 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 
 	/* Enable IRQ routing to this device. */
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		bcma_core_pci_irq_ctl(&dev->dev->bdev->bus->drv_pci,
+				      dev->dev->bdev, true);
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		ssb_pcicore_dev_irqvecs_enable(&dev->dev->sdev->bus->pcicore,
@@ -4834,6 +4895,13 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 
 	/* Get the PHY type. */
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		/* FIXME */
+		have_2ghz_phy = 1;
+		have_5ghz_phy = 0;
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		if (dev->dev->core_rev >= 5) {
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 41aea6a..95c28f5 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -609,6 +609,16 @@ static void b43_nphy_bmac_clock_fgc(struct b43_wldev *dev, bool force)
 		return;
 
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		tmp = bcma_read32(dev->dev->bdev, BCMA_IOCTL);
+		if (force)
+			tmp |= BCMA_IOCTL_FGC;
+		else
+			tmp &= ~BCMA_IOCTL_FGC;
+		bcma_write32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
@@ -965,6 +975,12 @@ static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 		b43_phy_write(dev, B43_NPHY_GPIO_HIOEN, 0);
 
 		switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+		case B43_BUS_BCMA:
+			bcma_chipco_gpio_control(&dev->dev->bdev->bus->drv_cc,
+						 0xFC00, 0xFC00);
+			break;
+#endif
 #ifdef CONFIG_B43_SSB
 		case B43_BUS_SSB:
 			ssb_chipco_gpio_control(&dev->dev->sdev->bus->chipco,
@@ -3614,6 +3630,12 @@ int b43_phy_initn(struct b43_wldev *dev)
 	   (sprom->boardflags_lo & B43_BFL_EXTLNA) &&
 	   (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)) {
 		switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+		case B43_BUS_BCMA:
+			bcma_cc_set32(&dev->dev->bdev->bus->drv_cc,
+				      BCMA_CC_CHIPCTL, 0x40);
+			break;
+#endif
 #ifdef CONFIG_B43_SSB
 		case B43_BUS_SSB:
 			chipco_set32(&dev->dev->sdev->bus->chipco,
-- 
1.7.3.4

