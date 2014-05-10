Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62584 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbaEJOko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2014 10:40:44 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so3394168eek.6
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2014 07:40:43 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] b43: adjust code to compile without SSB
Date: Sat, 10 May 2014 16:40:34 +0200
Message-Id: <1399732834-26509-1-git-send-email-zajec5@gmail.com> (sfid-20140510_164048_223529_0785192D)
In-Reply-To: <1399731244-18743-1-git-send-email-zajec5@gmail.com>
References: <1399731244-18743-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Users of new (BCMA based) wireless chipsets may not want to enable SSB.
This is hopefully the last code patch for dropping SSB dependency.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Replace
#ifdef CONFIG_SSB_DRIVER_PCICORE
with
#if defined(CONFIG_B43_SSB) && defined(CONFIG_SSB_DRIVER_PCICORE)
---
 drivers/net/wireless/b43/Kconfig |  2 +-
 drivers/net/wireless/b43/bus.h   | 10 ++++++++++
 drivers/net/wireless/b43/main.c  | 17 ++++++++++++++++-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 088d544..ce937a9 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -116,7 +116,7 @@ config B43_PHY_N
 
 config B43_PHY_LP
 	bool "Support for low-power (LP-PHY) devices"
-	depends on B43
+	depends on B43 && B43_SSB
 	default y
 	---help---
 	  Support for the LP-PHY.
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index 184c956..f3205c6 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -5,7 +5,9 @@ enum b43_bus_type {
 #ifdef CONFIG_B43_BCMA
 	B43_BUS_BCMA,
 #endif
+#ifdef CONFIG_B43_SSB
 	B43_BUS_SSB,
+#endif
 };
 
 struct b43_bus_dev {
@@ -52,13 +54,21 @@ struct b43_bus_dev {
 
 static inline bool b43_bus_host_is_pcmcia(struct b43_bus_dev *dev)
 {
+#ifdef CONFIG_B43_SSB
 	return (dev->bus_type == B43_BUS_SSB &&
 		dev->sdev->bus->bustype == SSB_BUSTYPE_PCMCIA);
+#else
+	return false;
+#endif
 }
 static inline bool b43_bus_host_is_sdio(struct b43_bus_dev *dev)
 {
+#ifdef CONFIG_B43_SSB
 	return (dev->bus_type == B43_BUS_SSB &&
 		dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO);
+#else
+	return false;
+#endif
 }
 
 struct b43_bus_dev *b43_bus_dev_bcma_init(struct bcma_device *core);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 4439d25..be46439 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1197,6 +1197,7 @@ static void b43_bcma_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 }
 #endif
 
+#ifdef CONFIG_B43_SSB
 static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 {
 	u32 flags = 0;
@@ -1212,6 +1213,7 @@ static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 
 	b43_phy_take_out_of_reset(dev);
 }
+#endif
 
 void b43_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 {
@@ -2715,6 +2717,8 @@ static int b43_upload_initvals_band(struct b43_wldev *dev)
 /* Initialize the GPIOs
  * http://bcm-specs.sipsolutions.net/GPIO
  */
+
+#ifdef CONFIG_B43_SSB
 static struct ssb_device *b43_ssb_gpio_dev(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->dev->sdev->bus;
@@ -2725,10 +2729,13 @@ static struct ssb_device *b43_ssb_gpio_dev(struct b43_wldev *dev)
 	return bus->chipco.dev;
 #endif
 }
+#endif
 
 static int b43_gpio_init(struct b43_wldev *dev)
 {
+#ifdef CONFIG_B43_SSB
 	struct ssb_device *gpiodev;
+#endif
 	u32 mask, set;
 
 	b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_GPOUTSMSK, 0);
@@ -2787,7 +2794,9 @@ static int b43_gpio_init(struct b43_wldev *dev)
 /* Turn off all GPIO stuff. Call this on module unload, for example. */
 static void b43_gpio_cleanup(struct b43_wldev *dev)
 {
+#ifdef CONFIG_B43_SSB
 	struct ssb_device *gpiodev;
+#endif
 
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
@@ -4519,8 +4528,12 @@ static void b43_imcfglo_timeouts_workaround(struct b43_wldev *dev)
 	struct ssb_bus *bus;
 	u32 tmp;
 
+#ifdef CONFIG_B43_SSB
 	if (dev->dev->bus_type != B43_BUS_SSB)
 		return;
+#else
+	return;
+#endif
 
 	bus = dev->dev->sdev->bus;
 
@@ -4675,7 +4688,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	}
 	if (sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW)
 		hf |= B43_HF_DSCRQ; /* Disable slowclock requests from ucode. */
-#ifdef CONFIG_SSB_DRIVER_PCICORE
+#if defined(CONFIG_B43_SSB) && defined(CONFIG_SSB_DRIVER_PCICORE)
 	if (dev->dev->bus_type == B43_BUS_SSB &&
 	    dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI &&
 	    dev->dev->sdev->bus->pcicore.dev->id.revision <= 10)
@@ -5247,6 +5260,7 @@ static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl)
 	(pdev->subsystem_vendor == PCI_VENDOR_ID_##_subvendor) &&	\
 	(pdev->subsystem_device == _subdevice)				)
 
+#ifdef CONFIG_B43_SSB
 static void b43_sprom_fixup(struct ssb_bus *bus)
 {
 	struct pci_dev *pdev;
@@ -5278,6 +5292,7 @@ static void b43_wireless_exit(struct b43_bus_dev *dev, struct b43_wl *wl)
 	ssb_set_devtypedata(dev->sdev, NULL);
 	ieee80211_free_hw(hw);
 }
+#endif
 
 static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 {
-- 
1.8.4.5

