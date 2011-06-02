Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34215 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab1FBKdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 06:33:25 -0400
Received: by eyx24 with SMTP id 24so230194eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 03:33:23 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Michael Buesch <mb@bu3sch.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] b43: use condition for SSB specific ops
Date: Thu,  2 Jun 2011 13:11:20 +0200
Message-Id: <1307013080-10386-1-git-send-email-zajec5@gmail.com> (sfid-20110602_123338_242416_A7C195CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Abstracting bus by b43_bus_dev works fine, but there are few places
where we calls SSB functions in uniq way. That calls happen only once
in the whole code and so there is not much sense in putting them in
bus abstraction.

In this situation I have decided to use simple switches. It does not
make code look lovely, but I do not have any better idea. If anyone
have - comments are really welcome.
---
 drivers/net/wireless/b43/b43.h   |    1 -
 drivers/net/wireless/b43/dma.c   |    7 ++-
 drivers/net/wireless/b43/main.c  |  132 ++++++++++++++++++++++++++------------
 drivers/net/wireless/b43/phy_n.c |   33 +++++++---
 5 files changed, 120 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 81d78bf..6c50734 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -709,7 +709,6 @@ enum {
 
 /* Data structure for one wireless device (802.11 core) */
 struct b43_wldev {
-	struct ssb_device *sdev; /* TODO: remove when b43_bus_dev is ready */
 	struct b43_bus_dev *dev;
 	struct b43_wl *wl;
 
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index d02cf83..a365a6c 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1055,7 +1055,12 @@ int b43_dma_init(struct b43_wldev *dev)
 	err = b43_dma_set_mask(dev, dmamask);
 	if (err)
 		return err;
-	dma->translation = ssb_dma_translation(dev->sdev);
+
+	switch (dev->dev->bus_type) {
+	case B43_BUS_SSB:
+		dma->translation = ssb_dma_translation(dev->dev->sdev);
+		break;
+	}
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index b0ccd0f..c96b86f 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1186,7 +1186,11 @@ void b43_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 {
 	u32 macctl;
 
-	b43_ssb_wireless_core_reset(dev, gmode);
+	switch (dev->dev->bus_type) {
+	case B43_BUS_SSB:
+		b43_ssb_wireless_core_reset(dev, gmode);
+		break;
+	}
 
 	/* Turn Analog ON, but only if we already know the PHY-type.
 	 * This protects against very early setup where we don't know the
@@ -2623,11 +2627,15 @@ static int b43_gpio_init(struct b43_wldev *dev)
 	if (dev->dev->core_rev >= 2)
 		mask |= 0x0010;	/* FIXME: This is redundant. */
 
-	gpiodev = b43_ssb_gpio_dev(dev);
-	if (gpiodev)
-		ssb_write32(gpiodev, B43_GPIO_CONTROL,
-			    (ssb_read32(gpiodev, B43_GPIO_CONTROL)
-			     & mask) | set);
+	switch (dev->dev->bus_type) {
+	case B43_BUS_SSB:
+		gpiodev = b43_ssb_gpio_dev(dev);
+		if (gpiodev)
+			ssb_write32(gpiodev, B43_GPIO_CONTROL,
+				    (ssb_read32(gpiodev, B43_GPIO_CONTROL)
+				     & mask) | set);
+		break;
+	}
 
 	return 0;
 }
@@ -2637,9 +2645,13 @@ static void b43_gpio_cleanup(struct b43_wldev *dev)
 {
 	struct ssb_device *gpiodev;
 
-	gpiodev = b43_ssb_gpio_dev(dev);
-	if (gpiodev)
-		ssb_write32(gpiodev, B43_GPIO_CONTROL, 0);
+	switch (dev->dev->bus_type) {
+	case B43_BUS_SSB:
+		gpiodev = b43_ssb_gpio_dev(dev);
+		if (gpiodev)
+			ssb_write32(gpiodev, B43_GPIO_CONTROL, 0);
+		break;
+	}
 }
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
@@ -2711,12 +2723,18 @@ out:
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
+	case B43_BUS_SSB:
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		if (on)
+			tmp |= B43_TMSLOW_MACPHYCLKEN;
+		else
+			tmp &= ~B43_TMSLOW_MACPHYCLKEN;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		break;
+	}
 }
 
 static void b43_adjust_opmode(struct b43_wldev *dev)
@@ -2955,8 +2973,12 @@ static int b43_chip_init(struct b43_wldev *dev)
 
 	b43_mac_phy_clock_set(dev, true);
 
-	b43_write16(dev, B43_MMIO_POWERUP_DELAY,
-		    dev->sdev->bus->chipco.fast_pwrup_delay);
+	switch (dev->dev->bus_type) {
+	case B43_BUS_SSB:
+		b43_write16(dev, B43_MMIO_POWERUP_DELAY,
+			    dev->dev->sdev->bus->chipco.fast_pwrup_delay);
+		break;
+	}
 
 	err = 0;
 	b43dbg(dev->wl, "Chip initialized\n");
@@ -3472,21 +3494,28 @@ static void b43_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 
 static void b43_put_phy_into_reset(struct b43_wldev *dev)
 {
-	struct ssb_device *sdev = dev->sdev;
-	u32 tmslow;
+	struct ssb_device *sdev;
+	u32 tmp;
 
-	tmslow = ssb_read32(sdev, SSB_TMSLOW);
-	tmslow &= ~B43_TMSLOW_GMODE;
-	tmslow |= B43_TMSLOW_PHYRESET;
-	tmslow |= SSB_TMSLOW_FGC;
-	ssb_write32(sdev, SSB_TMSLOW, tmslow);
-	msleep(1);
+	switch (dev->dev->bus_type) {
+	case B43_BUS_SSB:
+		sdev = dev->dev->sdev;
 
-	tmslow = ssb_read32(sdev, SSB_TMSLOW);
-	tmslow &= ~SSB_TMSLOW_FGC;
-	tmslow |= B43_TMSLOW_PHYRESET;
-	ssb_write32(sdev, SSB_TMSLOW, tmslow);
-	msleep(1);
+		tmp = ssb_read32(sdev, SSB_TMSLOW);
+		tmp &= ~B43_TMSLOW_GMODE;
+		tmp |= B43_TMSLOW_PHYRESET;
+		tmp |= SSB_TMSLOW_FGC;
+		ssb_write32(sdev, SSB_TMSLOW, tmp);
+		msleep(1);
+
+		tmp = ssb_read32(sdev, SSB_TMSLOW);
+		tmp &= ~SSB_TMSLOW_FGC;
+		tmp |= B43_TMSLOW_PHYRESET;
+		ssb_write32(sdev, SSB_TMSLOW, tmp);
+		msleep(1);
+
+		break;
+	}
 }
 
 static const char *band_to_string(enum ieee80211_band band)
@@ -4336,7 +4365,6 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 /* Initialize a wireless core */
 static int b43_wireless_core_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 	int err;
@@ -4355,7 +4383,12 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	phy->ops->prepare_structs(dev);
 
 	/* Enable IRQ routing to this device. */
-	ssb_pcicore_dev_irqvecs_enable(&bus->pcicore, dev->sdev);
+	switch (dev->dev->bus_type) {
+	case B43_BUS_SSB:
+		ssb_pcicore_dev_irqvecs_enable(&dev->dev->sdev->bus->pcicore,
+					       dev->dev->sdev);
+		break;
+	}
 
 	b43_imcfglo_timeouts_workaround(dev);
 	b43_bluetooth_coext_disable(dev);
@@ -4386,8 +4419,9 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
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
@@ -4753,8 +4787,7 @@ static void b43_wireless_core_detach(struct b43_wldev *dev)
 static int b43_wireless_core_attach(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
-	struct ssb_bus *bus = dev->sdev->bus;
-	struct pci_dev *pdev = (bus->bustype == SSB_BUSTYPE_PCI) ? bus->host_pci : NULL;
+	struct pci_dev *pdev = NULL;
 	int err;
 	bool have_2ghz_phy = 0, have_5ghz_phy = 0;
 
@@ -4765,6 +4798,10 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	 * that in core_init(), too.
 	 */
 
+	if (dev->dev->bus_type == B43_BUS_SSB &&
+	    dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI)
+		pdev = dev->dev->sdev->bus->host_pci;
+
 	err = b43_bus_powerup(dev, 0);
 	if (err) {
 		b43err(wl, "Bus powerup failed\n");
@@ -4774,7 +4811,7 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	if (dev->dev->core_rev >= 5) {
 		u32 tmshigh;
 
-		tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
+		tmshigh = ssb_read32(dev->dev->sdev, SSB_TMSHIGH); /* FIXME */
 		have_2ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY);
 		have_5ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_5GHZ_PHY);
 	} else
@@ -4860,19 +4897,30 @@ err_powerdown:
 
 static void b43_one_core_detach(struct b43_bus_dev *dev)
 {
-	struct b43_wldev *wldev;
+	struct b43_wldev *uninitialized_var(wldev);
 	struct b43_wl *wl;
 
 	/* Do not cancel ieee80211-workqueue based work here.
 	 * See comment in b43_remove(). */
 
-	wldev = ssb_get_drvdata(dev->sdev);
+	switch (dev->bus_type) {
+	case B43_BUS_SSB:
+		wldev = ssb_get_drvdata(dev->sdev);
+		break;
+	}
+
 	wl = wldev->wl;
 	b43_debugfs_remove_device(wldev);
 	b43_wireless_core_detach(wldev);
 	list_del(&wldev->list);
 	wl->nr_devs--;
-	ssb_set_drvdata(dev->sdev, NULL);
+
+	switch (dev->bus_type) {
+	case B43_BUS_SSB:
+		ssb_set_drvdata(dev->sdev, NULL);
+		break;
+	}
+
 	kfree(wldev);
 }
 
@@ -4887,7 +4935,6 @@ static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl)
 
 	wldev->use_pio = b43_modparam_pio;
 	wldev->dev = dev;
-	wldev->sdev = dev->sdev; /* TODO: Remove when not needed */
 	wldev->wl = wl;
 	b43_set_status(wldev, B43_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
@@ -4899,7 +4946,8 @@ static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl)
 
 	list_add(&wldev->list, &wl->devlist);
 	wl->nr_devs++;
-	ssb_set_drvdata(dev->sdev, wldev);
+	if (dev->bus_type == B43_BUS_SSB)
+		ssb_set_drvdata(dev->sdev, wldev);
 	b43_debugfs_add_device(wldev);
 
       out:
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ad14f3b..ecb2b7a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -603,17 +603,21 @@ static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
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
+	case B43_BUS_SSB:
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		if (force)
+			tmp |= SSB_TMSLOW_FGC;
+		else
+			tmp &= ~SSB_TMSLOW_FGC;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		break;
+	}
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
@@ -958,8 +962,12 @@ static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 		b43_phy_write(dev, B43_NPHY_GPIO_LOOEN, 0);
 		b43_phy_write(dev, B43_NPHY_GPIO_HIOEN, 0);
 
-		ssb_chipco_gpio_control(&dev->sdev->bus->chipco, 0xFC00,
-					0xFC00);
+		switch (dev->dev->bus_type) {
+		case B43_BUS_SSB:
+			ssb_chipco_gpio_control(&dev->dev->sdev->bus->chipco,
+						0xFC00, 0xFC00);
+			break;
+		}
 		b43_write32(dev, B43_MMIO_MACCTL,
 			b43_read32(dev, B43_MMIO_MACCTL) &
 			~B43_MACCTL_GPOUTSMSK);
@@ -3600,7 +3608,12 @@ int b43_phy_initn(struct b43_wldev *dev)
 	if ((dev->phy.rev >= 3) &&
 	   (sprom->boardflags_lo & B43_BFL_EXTLNA) &&
 	   (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)) {
-		chipco_set32(&dev->sdev->bus->chipco, SSB_CHIPCO_CHIPCTL, 0x40);
+		switch (dev->dev->bus_type) {
+		case B43_BUS_SSB:
+			chipco_set32(&dev->dev->sdev->bus->chipco,
+				     SSB_CHIPCO_CHIPCTL, 0x40);
+			break;
+		}
 	}
 	nphy->deaf_count = 0;
 	b43_nphy_tables_init(dev);
-- 
1.7.3.4

