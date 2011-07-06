Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:64695 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1GFNHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 09:07:04 -0400
Received: by fxd18 with SMTP id 18so65969fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 06:07:03 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: use switches for SSB specific code
Date: Wed,  6 Jul 2011 15:45:26 +0200
Message-Id: <1309959928-5731-1-git-send-email-zajec5@gmail.com> (sfid-20110706_150710_122191_583303D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h   |    1 -
 drivers/net/wireless/b43/bus.h   |    2 +
 drivers/net/wireless/b43/dma.c   |    9 ++-
 drivers/net/wireless/b43/main.c  |  144 ++++++++++++++++++++++++++------------
 drivers/net/wireless/b43/phy_n.c |   40 ++++++++---
 5 files changed, 139 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 666515e..08a2827 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -726,7 +726,6 @@ enum {
 
 /* Data structure for one wireless device (802.11 core) */
 struct b43_wldev {
-	struct ssb_device *sdev; /* TODO: remove when b43_bus_dev is ready */
 	struct b43_bus_dev *dev;
 	struct b43_wl *wl;
 
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index a70b7b9..f3c30eb 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -2,7 +2,9 @@
 #define B43_BUS_H_
 
 enum b43_bus_type {
+#ifdef CONFIG_B43_BCMA
 	B43_BUS_BCMA,
+#endif
 	B43_BUS_SSB,
 };
 
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index d02cf83..58ad3ad 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1055,7 +1055,14 @@ int b43_dma_init(struct b43_wldev *dev)
 	err = b43_dma_set_mask(dev, dmamask);
 	if (err)
 		return err;
-	dma->translation = ssb_dma_translation(dev->sdev);
+
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		dma->translation = ssb_dma_translation(dev->dev->sdev);
+		break;
+#endif
+	}
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index b85a973..dd6d652 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1187,7 +1187,13 @@ void b43_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 {
 	u32 macctl;
 
-	b43_ssb_wireless_core_reset(dev, gmode);
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		b43_ssb_wireless_core_reset(dev, gmode);
+		break;
+#endif
+	}
 
 	/* Turn Analog ON, but only if we already know the PHY-type.
 	 * This protects against very early setup where we don't know the
@@ -2624,11 +2630,17 @@ static int b43_gpio_init(struct b43_wldev *dev)
 	if (dev->dev->core_rev >= 2)
 		mask |= 0x0010;	/* FIXME: This is redundant. */
 
-	gpiodev = b43_ssb_gpio_dev(dev);
-	if (gpiodev)
-		ssb_write32(gpiodev, B43_GPIO_CONTROL,
-			    (ssb_read32(gpiodev, B43_GPIO_CONTROL)
-			     & mask) | set);
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		gpiodev = b43_ssb_gpio_dev(dev);
+		if (gpiodev)
+			ssb_write32(gpiodev, B43_GPIO_CONTROL,
+				    (ssb_read32(gpiodev, B43_GPIO_CONTROL)
+				    & mask) | set);
+		break;
+#endif
+	}
 
 	return 0;
 }
@@ -2638,9 +2650,15 @@ static void b43_gpio_cleanup(struct b43_wldev *dev)
 {
 	struct ssb_device *gpiodev;
 
-	gpiodev = b43_ssb_gpio_dev(dev);
-	if (gpiodev)
-		ssb_write32(gpiodev, B43_GPIO_CONTROL, 0);
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		gpiodev = b43_ssb_gpio_dev(dev);
+		if (gpiodev)
+			ssb_write32(gpiodev, B43_GPIO_CONTROL, 0);
+		break;
+#endif
+	}
 }
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
@@ -2712,12 +2730,20 @@ out:
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MacPhyClkSet */
 void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on)
 {
-	u32 tmslow = ssb_read32(dev->sdev, SSB_TMSLOW);
-	if (on)
-		tmslow |= B43_TMSLOW_MACPHYCLKEN;
-	else
-		tmslow &= ~B43_TMSLOW_MACPHYCLKEN;
-	ssb_write32(dev->sdev, SSB_TMSLOW, tmslow);
+	u32 tmp;
+
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		if (on)
+			tmp |= B43_TMSLOW_MACPHYCLKEN;
+		else
+			tmp &= ~B43_TMSLOW_MACPHYCLKEN;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		break;
+#endif
+	}
 }
 
 static void b43_adjust_opmode(struct b43_wldev *dev)
@@ -2956,8 +2982,14 @@ static int b43_chip_init(struct b43_wldev *dev)
 
 	b43_mac_phy_clock_set(dev, true);
 
-	b43_write16(dev, B43_MMIO_POWERUP_DELAY,
-		    dev->sdev->bus->chipco.fast_pwrup_delay);
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		b43_write16(dev, B43_MMIO_POWERUP_DELAY,
+			    dev->dev->sdev->bus->chipco.fast_pwrup_delay);
+		break;
+#endif
+	}
 
 	err = 0;
 	b43dbg(dev->wl, "Chip initialized\n");
@@ -3473,21 +3505,27 @@ static void b43_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 
 static void b43_put_phy_into_reset(struct b43_wldev *dev)
 {
-	struct ssb_device *sdev = dev->sdev;
-	u32 tmslow;
+	u32 tmp;
 
-	tmslow = ssb_read32(sdev, SSB_TMSLOW);
-	tmslow &= ~B43_TMSLOW_GMODE;
-	tmslow |= B43_TMSLOW_PHYRESET;
-	tmslow |= SSB_TMSLOW_FGC;
-	ssb_write32(sdev, SSB_TMSLOW, tmslow);
-	msleep(1);
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		tmp &= ~B43_TMSLOW_GMODE;
+		tmp |= B43_TMSLOW_PHYRESET;
+		tmp |= SSB_TMSLOW_FGC;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		msleep(1);
+
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		tmp &= ~SSB_TMSLOW_FGC;
+		tmp |= B43_TMSLOW_PHYRESET;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		msleep(1);
 
-	tmslow = ssb_read32(sdev, SSB_TMSLOW);
-	tmslow &= ~SSB_TMSLOW_FGC;
-	tmslow |= B43_TMSLOW_PHYRESET;
-	ssb_write32(sdev, SSB_TMSLOW, tmslow);
-	msleep(1);
+		break;
+#endif
+	}
 }
 
 static const char *band_to_string(enum ieee80211_band band)
@@ -4347,7 +4385,6 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 /* Initialize a wireless core */
 static int b43_wireless_core_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 	int err;
@@ -4366,7 +4403,14 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	phy->ops->prepare_structs(dev);
 
 	/* Enable IRQ routing to this device. */
-	ssb_pcicore_dev_irqvecs_enable(&bus->pcicore, dev->sdev);
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		ssb_pcicore_dev_irqvecs_enable(&dev->dev->sdev->bus->pcicore,
+					       dev->dev->sdev);
+		break;
+#endif
+	}
 
 	b43_imcfglo_timeouts_workaround(dev);
 	b43_bluetooth_coext_disable(dev);
@@ -4397,8 +4441,9 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	if (sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW)
 		hf |= B43_HF_DSCRQ; /* Disable slowclock requests from ucode. */
 #ifdef CONFIG_SSB_DRIVER_PCICORE
-	if ((bus->bustype == SSB_BUSTYPE_PCI) &&
-	    (bus->pcicore.dev->id.revision <= 10))
+	if (dev->dev->bus_type == B43_BUS_SSB &&
+	    dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI &&
+	    dev->dev->sdev->bus->pcicore.dev->id.revision <= 10)
 		hf |= B43_HF_PCISCW; /* PCI slow clock workaround. */
 #endif
 	hf &= ~B43_HF_SKCFPUP;
@@ -4764,8 +4809,7 @@ static void b43_wireless_core_detach(struct b43_wldev *dev)
 static int b43_wireless_core_attach(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
-	struct ssb_bus *bus = dev->sdev->bus;
-	struct pci_dev *pdev = (bus->bustype == SSB_BUSTYPE_PCI) ? bus->host_pci : NULL;
+	struct pci_dev *pdev = NULL;
 	int err;
 	bool have_2ghz_phy = 0, have_5ghz_phy = 0;
 
@@ -4776,20 +4820,31 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	 * that in core_init(), too.
 	 */
 
+#ifdef CONFIG_B43_SSB
+	if (dev->dev->bus_type == B43_BUS_SSB &&
+	    dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI)
+		pdev = dev->dev->sdev->bus->host_pci;
+#endif
+
 	err = b43_bus_powerup(dev, 0);
 	if (err) {
 		b43err(wl, "Bus powerup failed\n");
 		goto out;
 	}
-	/* Get the PHY type. */
-	if (dev->dev->core_rev >= 5) {
-		u32 tmshigh;
 
-		tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
-		have_2ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY);
-		have_5ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_5GHZ_PHY);
-	} else
-		B43_WARN_ON(1);
+	/* Get the PHY type. */
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		if (dev->dev->core_rev >= 5) {
+			u32 tmshigh = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
+			have_2ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY);
+			have_5ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_5GHZ_PHY);
+		} else
+			B43_WARN_ON(1);
+		break;
+#endif
+	}
 
 	dev->phy.gmode = have_2ghz_phy;
 	dev->phy.radio_on = 1;
@@ -4898,7 +4953,6 @@ static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl)
 
 	wldev->use_pio = b43_modparam_pio;
 	wldev->dev = dev;
-	wldev->sdev = dev->sdev; /* TODO: Remove when not needed */
 	wldev->wl = wl;
 	b43_set_status(wldev, B43_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e7dfdac..41aea6a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -603,17 +603,23 @@ static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BmacPhyClkFgc */
 static void b43_nphy_bmac_clock_fgc(struct b43_wldev *dev, bool force)
 {
-	u32 tmslow;
+	u32 tmp;
 
 	if (dev->phy.type != B43_PHYTYPE_N)
 		return;
 
-	tmslow = ssb_read32(dev->sdev, SSB_TMSLOW);
-	if (force)
-		tmslow |= SSB_TMSLOW_FGC;
-	else
-		tmslow &= ~SSB_TMSLOW_FGC;
-	ssb_write32(dev->sdev, SSB_TMSLOW, tmslow);
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		if (force)
+			tmp |= SSB_TMSLOW_FGC;
+		else
+			tmp &= ~SSB_TMSLOW_FGC;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		break;
+#endif
+	}
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
@@ -958,8 +964,15 @@ static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 		b43_phy_write(dev, B43_NPHY_GPIO_LOOEN, 0);
 		b43_phy_write(dev, B43_NPHY_GPIO_HIOEN, 0);
 
-		ssb_chipco_gpio_control(&dev->sdev->bus->chipco, 0xFC00,
-					0xFC00);
+		switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+		case B43_BUS_SSB:
+			ssb_chipco_gpio_control(&dev->dev->sdev->bus->chipco,
+						0xFC00, 0xFC00);
+			break;
+#endif
+		}
+
 		b43_write32(dev, B43_MMIO_MACCTL,
 			b43_read32(dev, B43_MMIO_MACCTL) &
 			~B43_MACCTL_GPOUTSMSK);
@@ -3600,7 +3613,14 @@ int b43_phy_initn(struct b43_wldev *dev)
 	if ((dev->phy.rev >= 3) &&
 	   (sprom->boardflags_lo & B43_BFL_EXTLNA) &&
 	   (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)) {
-		chipco_set32(&dev->sdev->bus->chipco, SSB_CHIPCO_CHIPCTL, 0x40);
+		switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_SSB
+		case B43_BUS_SSB:
+			chipco_set32(&dev->dev->sdev->bus->chipco,
+				     SSB_CHIPCO_CHIPCTL, 0x40);
+			break;
+#endif
+		}
 	}
 	nphy->deaf_count = 0;
 	b43_nphy_tables_init(dev);
-- 
1.7.3.4

