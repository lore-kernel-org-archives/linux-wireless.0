Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55746 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab1EMV7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 17:59:18 -0400
Received: by fxm17 with SMTP id 17so2037132fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 14:59:17 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: rename b43_wldev's field with ssb_device to sdev
Date: Fri, 13 May 2011 23:59:10 +0200
Message-Id: <1305323950-13021-1-git-send-email-zajec5@gmail.com> (sfid-20110513_235924_597425_5742A456)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We free name "dev" for something generic (like dev abstraction layer).
Additionaly code is cleaner now, especially magic dev->dev-dev chains.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h          |   10 +-
 drivers/net/wireless/b43/dma.c          |   36 +++++-----
 drivers/net/wireless/b43/leds.c         |    4 +-
 drivers/net/wireless/b43/lo.c           |    4 +-
 drivers/net/wireless/b43/main.c         |  123 ++++++++++++++++---------------
 drivers/net/wireless/b43/phy_a.c        |   16 ++--
 drivers/net/wireless/b43/phy_common.c   |    8 +-
 drivers/net/wireless/b43/phy_g.c        |   48 ++++++------
 drivers/net/wireless/b43/phy_lp.c       |   22 +++---
 drivers/net/wireless/b43/phy_n.c        |   24 +++---
 drivers/net/wireless/b43/pio.c          |   30 ++++----
 drivers/net/wireless/b43/rfkill.c       |    6 +-
 drivers/net/wireless/b43/sysfs.c        |    4 +-
 drivers/net/wireless/b43/tables_lpphy.c |    4 +-
 drivers/net/wireless/b43/wa.c           |    4 +-
 drivers/net/wireless/b43/xmit.c         |    2 +-
 16 files changed, 173 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 229f438..1be9420 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -705,7 +705,7 @@ enum {
 
 /* Data structure for one wireless device (802.11 core) */
 struct b43_wldev {
-	struct ssb_device *dev;
+	struct ssb_device *sdev;
 	struct b43_wl *wl;
 
 	/* The device initialization status.
@@ -879,22 +879,22 @@ static inline enum ieee80211_band b43_current_band(struct b43_wl *wl)
 
 static inline u16 b43_read16(struct b43_wldev *dev, u16 offset)
 {
-	return ssb_read16(dev->dev, offset);
+	return ssb_read16(dev->sdev, offset);
 }
 
 static inline void b43_write16(struct b43_wldev *dev, u16 offset, u16 value)
 {
-	ssb_write16(dev->dev, offset, value);
+	ssb_write16(dev->sdev, offset, value);
 }
 
 static inline u32 b43_read32(struct b43_wldev *dev, u16 offset)
 {
-	return ssb_read32(dev->dev, offset);
+	return ssb_read32(dev->sdev, offset);
 }
 
 static inline void b43_write32(struct b43_wldev *dev, u16 offset, u32 value)
 {
-	ssb_write32(dev->dev, offset, value);
+	ssb_write32(dev->sdev, offset, value);
 }
 
 static inline bool b43_using_pio_transfers(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index ff0f5ba..10cfba3 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -80,7 +80,7 @@ static void op32_fill_descriptor(struct b43_dmaring *ring,
 	addr = (u32) (dmaaddr & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (u32) (dmaaddr & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addr |= ssb_dma_translation(ring->dev->dev);
+	addr |= ssb_dma_translation(ring->dev->sdev);
 	ctl = bufsize & B43_DMA32_DCTL_BYTECNT;
 	if (slot == ring->nr_slots - 1)
 		ctl |= B43_DMA32_DCTL_DTABLEEND;
@@ -174,7 +174,7 @@ static void op64_fill_descriptor(struct b43_dmaring *ring,
 	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= (ssb_dma_translation(ring->dev->dev) << 1);
+	addrhi |= (ssb_dma_translation(ring->dev->sdev) << 1);
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -333,10 +333,10 @@ static inline
 	dma_addr_t dmaaddr;
 
 	if (tx) {
-		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
+		dmaaddr = dma_map_single(ring->dev->sdev->dma_dev,
 					 buf, len, DMA_TO_DEVICE);
 	} else {
-		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
+		dmaaddr = dma_map_single(ring->dev->sdev->dma_dev,
 					 buf, len, DMA_FROM_DEVICE);
 	}
 
@@ -348,10 +348,10 @@ static inline
 			  dma_addr_t addr, size_t len, int tx)
 {
 	if (tx) {
-		dma_unmap_single(ring->dev->dev->dma_dev,
+		dma_unmap_single(ring->dev->sdev->dma_dev,
 				 addr, len, DMA_TO_DEVICE);
 	} else {
-		dma_unmap_single(ring->dev->dev->dma_dev,
+		dma_unmap_single(ring->dev->sdev->dma_dev,
 				 addr, len, DMA_FROM_DEVICE);
 	}
 }
@@ -361,7 +361,7 @@ static inline
 				 dma_addr_t addr, size_t len)
 {
 	B43_WARN_ON(ring->tx);
-	dma_sync_single_for_cpu(ring->dev->dev->dma_dev,
+	dma_sync_single_for_cpu(ring->dev->sdev->dma_dev,
 				    addr, len, DMA_FROM_DEVICE);
 }
 
@@ -370,7 +370,7 @@ static inline
 				    dma_addr_t addr, size_t len)
 {
 	B43_WARN_ON(ring->tx);
-	dma_sync_single_for_device(ring->dev->dev->dma_dev,
+	dma_sync_single_for_device(ring->dev->sdev->dma_dev,
 				   addr, len, DMA_FROM_DEVICE);
 }
 
@@ -401,7 +401,7 @@ static int alloc_ringmemory(struct b43_dmaring *ring)
 	 */
 	if (ring->type == B43_DMA_64BIT)
 		flags |= GFP_DMA;
-	ring->descbase = dma_alloc_coherent(ring->dev->dev->dma_dev,
+	ring->descbase = dma_alloc_coherent(ring->dev->sdev->dma_dev,
 					    B43_DMA_RINGMEMSIZE,
 					    &(ring->dmabase), flags);
 	if (!ring->descbase) {
@@ -415,7 +415,7 @@ static int alloc_ringmemory(struct b43_dmaring *ring)
 
 static void free_ringmemory(struct b43_dmaring *ring)
 {
-	dma_free_coherent(ring->dev->dev->dma_dev, B43_DMA_RINGMEMSIZE,
+	dma_free_coherent(ring->dev->sdev->dma_dev, B43_DMA_RINGMEMSIZE,
 			  ring->descbase, ring->dmabase);
 }
 
@@ -523,7 +523,7 @@ static bool b43_dma_mapping_error(struct b43_dmaring *ring,
 				  dma_addr_t addr,
 				  size_t buffersize, bool dma_to_device)
 {
-	if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
+	if (unlikely(dma_mapping_error(ring->dev->sdev->dma_dev, addr)))
 		return 1;
 
 	switch (ring->type) {
@@ -658,7 +658,7 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 	int err = 0;
 	u32 value;
 	u32 addrext;
-	u32 trans = ssb_dma_translation(ring->dev->dev);
+	u32 trans = ssb_dma_translation(ring->dev->sdev);
 
 	if (ring->tx) {
 		if (ring->type == B43_DMA_64BIT) {
@@ -869,7 +869,7 @@ struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
-		dma_test = dma_map_single(dev->dev->dma_dev,
+		dma_test = dma_map_single(dev->sdev->dma_dev,
 					  ring->txhdr_cache,
 					  b43_txhdr_size(dev),
 					  DMA_TO_DEVICE);
@@ -884,7 +884,7 @@ struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
-			dma_test = dma_map_single(dev->dev->dma_dev,
+			dma_test = dma_map_single(dev->sdev->dma_dev,
 						  ring->txhdr_cache,
 						  b43_txhdr_size(dev),
 						  DMA_TO_DEVICE);
@@ -898,7 +898,7 @@ struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
 			}
 		}
 
-		dma_unmap_single(dev->dev->dma_dev,
+		dma_unmap_single(dev->sdev->dma_dev,
 				 dma_test, b43_txhdr_size(dev),
 				 DMA_TO_DEVICE);
 	}
@@ -1013,9 +1013,9 @@ static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
 	/* Try to set the DMA mask. If it fails, try falling back to a
 	 * lower mask, as we can always also support a lower one. */
 	while (1) {
-		err = dma_set_mask(dev->dev->dma_dev, mask);
+		err = dma_set_mask(dev->sdev->dma_dev, mask);
 		if (!err) {
-			err = dma_set_coherent_mask(dev->dev->dma_dev, mask);
+			err = dma_set_coherent_mask(dev->sdev->dma_dev, mask);
 			if (!err)
 				break;
 		}
@@ -1084,7 +1084,7 @@ int b43_dma_init(struct b43_wldev *dev)
 		goto err_destroy_mcast;
 
 	/* No support for the TX status DMA ring. */
-	B43_WARN_ON(dev->dev->id.revision < 5);
+	B43_WARN_ON(dev->sdev->id.revision < 5);
 
 	b43dbg(dev->wl, "%u-bit DMA initialized\n",
 	       (unsigned int)type);
diff --git a/drivers/net/wireless/b43/leds.c b/drivers/net/wireless/b43/leds.c
index c587115..0cafafe 100644
--- a/drivers/net/wireless/b43/leds.c
+++ b/drivers/net/wireless/b43/leds.c
@@ -138,7 +138,7 @@ static int b43_register_led(struct b43_wldev *dev, struct b43_led *led,
 	led->led_dev.default_trigger = default_trigger;
 	led->led_dev.brightness_set = b43_led_brightness_set;
 
-	err = led_classdev_register(dev->dev->dev, &led->led_dev);
+	err = led_classdev_register(dev->sdev->dev, &led->led_dev);
 	if (err) {
 		b43warn(dev->wl, "LEDs: Failed to register %s\n", name);
 		led->wl = NULL;
@@ -215,7 +215,7 @@ static void b43_led_get_sprominfo(struct b43_wldev *dev,
 				  enum b43_led_behaviour *behaviour,
 				  bool *activelow)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	u8 sprom[4];
 
 	sprom[0] = bus->sprom.gpio0;
diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 94e4f13..2ef7d4b 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -98,7 +98,7 @@ static u16 lo_measure_feedthrough(struct b43_wldev *dev,
 		rfover |= pga;
 		rfover |= lna;
 		rfover |= trsw_rx;
-		if ((dev->dev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA)
+		if ((dev->sdev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA)
 		    && phy->rev > 6)
 			rfover |= B43_PHY_RFOVERVAL_EXTLNA;
 
@@ -387,7 +387,7 @@ struct lo_g_saved_values {
 static void lo_measure_setup(struct b43_wldev *dev,
 			     struct lo_g_saved_values *sav)
 {
-	struct ssb_sprom *sprom = &dev->dev->bus->sprom;
+	struct ssb_sprom *sprom = &dev->sdev->bus->sprom;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	struct b43_txpower_lo_control *lo = gphy->lo_control;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5a43984..38b6578 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -548,7 +548,7 @@ void b43_tsf_read(struct b43_wldev *dev, u64 *tsf)
 {
 	u32 low, high;
 
-	B43_WARN_ON(dev->dev->id.revision < 3);
+	B43_WARN_ON(dev->sdev->id.revision < 3);
 
 	/* The hardware guarantees us an atomic read, if we
 	 * read the low register first. */
@@ -586,7 +586,7 @@ static void b43_tsf_write_locked(struct b43_wldev *dev, u64 tsf)
 {
 	u32 low, high;
 
-	B43_WARN_ON(dev->dev->id.revision < 3);
+	B43_WARN_ON(dev->sdev->id.revision < 3);
 
 	low = tsf;
 	high = (tsf >> 32);
@@ -714,7 +714,7 @@ void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 		b43_ram_write(dev, i * 4, buffer[i]);
 
 	b43_write16(dev, 0x0568, 0x0000);
-	if (dev->dev->id.revision < 11)
+	if (dev->sdev->id.revision < 11)
 		b43_write16(dev, 0x07C0, 0x0000);
 	else
 		b43_write16(dev, 0x07C0, 0x0100);
@@ -1132,7 +1132,7 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 	/* Commit write */
 	b43_read32(dev, B43_MMIO_MACCTL);
-	if (awake && dev->dev->id.revision >= 5) {
+	if (awake && dev->sdev->id.revision >= 5) {
 		/* Wait for the microcode to wake up. */
 		for (i = 0; i < 100; i++) {
 			ucstat = b43_shm_read16(dev, B43_SHM_SHARED,
@@ -1153,19 +1153,19 @@ void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 	flags |= B43_TMSLOW_PHYRESET;
 	if (dev->phy.type == B43_PHYTYPE_N)
 		flags |= B43_TMSLOW_PHY_BANDWIDTH_20MHZ; /* Make 20 MHz def */
-	ssb_device_enable(dev->dev, flags);
+	ssb_device_enable(dev->sdev, flags);
 	msleep(2);		/* Wait for the PLL to turn on. */
 
 	/* Now take the PHY out of Reset again */
-	tmslow = ssb_read32(dev->dev, SSB_TMSLOW);
+	tmslow = ssb_read32(dev->sdev, SSB_TMSLOW);
 	tmslow |= SSB_TMSLOW_FGC;
 	tmslow &= ~B43_TMSLOW_PHYRESET;
-	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
-	ssb_read32(dev->dev, SSB_TMSLOW);	/* flush */
+	ssb_write32(dev->sdev, SSB_TMSLOW, tmslow);
+	ssb_read32(dev->sdev, SSB_TMSLOW);	/* flush */
 	msleep(1);
 	tmslow &= ~SSB_TMSLOW_FGC;
-	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
-	ssb_read32(dev->dev, SSB_TMSLOW);	/* flush */
+	ssb_write32(dev->sdev, SSB_TMSLOW, tmslow);
+	ssb_read32(dev->sdev, SSB_TMSLOW);	/* flush */
 	msleep(1);
 
 	/* Turn Analog ON, but only if we already know the PHY-type.
@@ -1215,7 +1215,7 @@ static void drain_txstatus_queue(struct b43_wldev *dev)
 {
 	u32 dummy;
 
-	if (dev->dev->id.revision < 5)
+	if (dev->sdev->id.revision < 5)
 		return;
 	/* Read all entries from the microcode TXstatus FIFO
 	 * and throw them away.
@@ -1421,9 +1421,9 @@ u8 b43_ieee80211_antenna_sanitize(struct b43_wldev *dev,
 
 	/* Get the mask of available antennas. */
 	if (dev->phy.gmode)
-		antenna_mask = dev->dev->bus->sprom.ant_available_bg;
+		antenna_mask = dev->sdev->bus->sprom.ant_available_bg;
 	else
-		antenna_mask = dev->dev->bus->sprom.ant_available_a;
+		antenna_mask = dev->sdev->bus->sprom.ant_available_a;
 
 	if (!(antenna_mask & (1 << (antenna_nr - 1)))) {
 		/* This antenna is not available. Fall back to default. */
@@ -1638,7 +1638,7 @@ static void b43_beacon_update_trigger_work(struct work_struct *work)
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (likely(dev && (b43_status(dev) >= B43_STAT_INITIALIZED))) {
-		if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) {
+		if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
 			/* wl->mutex is enough. */
 			b43_do_beacon_update_trigger_work(dev);
 			mmiowb();
@@ -1683,7 +1683,7 @@ static void b43_update_templates(struct b43_wl *wl)
 static void b43_set_beacon_int(struct b43_wldev *dev, u16 beacon_int)
 {
 	b43_time_lock(dev);
-	if (dev->dev->id.revision >= 3) {
+	if (dev->sdev->id.revision >= 3) {
 		b43_write32(dev, B43_MMIO_TSF_CFP_REP, (beacon_int << 16));
 		b43_write32(dev, B43_MMIO_TSF_CFP_START, (beacon_int << 10));
 	} else {
@@ -2057,7 +2057,7 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 		B43_WARN_ON(1);
 		return -ENOSYS;
 	}
-	err = request_firmware(&blob, ctx->fwname, ctx->dev->dev->dev);
+	err = request_firmware(&blob, ctx->fwname, ctx->dev->sdev->dev);
 	if (err == -ENOENT) {
 		snprintf(ctx->errors[ctx->req_type],
 			 sizeof(ctx->errors[ctx->req_type]),
@@ -2107,13 +2107,13 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 {
 	struct b43_wldev *dev = ctx->dev;
 	struct b43_firmware *fw = &ctx->dev->fw;
-	const u8 rev = ctx->dev->dev->id.revision;
+	const u8 rev = ctx->dev->sdev->id.revision;
 	const char *filename;
 	u32 tmshigh;
 	int err;
 
 	/* Get microcode */
-	tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
+	tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
 	if ((rev >= 5) && (rev <= 10))
 		filename = "ucode5";
 	else if ((rev >= 11) && (rev <= 12))
@@ -2441,7 +2441,7 @@ static int b43_upload_microcode(struct b43_wldev *dev)
 
 	snprintf(wiphy->fw_version, sizeof(wiphy->fw_version), "%u.%u",
 			dev->fw.rev, dev->fw.patch);
-	wiphy->hw_version = dev->dev->id.coreid;
+	wiphy->hw_version = dev->sdev->id.coreid;
 
 	if (b43_is_old_txhdr_format(dev)) {
 		/* We're over the deadline, but we keep support for old fw
@@ -2559,7 +2559,7 @@ out:
  */
 static int b43_gpio_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct ssb_device *gpiodev, *pcidev = NULL;
 	u32 mask, set;
 
@@ -2571,7 +2571,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
 
 	mask = 0x0000001F;
 	set = 0x0000000F;
-	if (dev->dev->bus->chip_id == 0x4301) {
+	if (dev->sdev->bus->chip_id == 0x4301) {
 		mask |= 0x0060;
 		set |= 0x0060;
 	}
@@ -2582,14 +2582,14 @@ static int b43_gpio_init(struct b43_wldev *dev)
 		mask |= 0x0180;
 		set |= 0x0180;
 	}
-	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL) {
+	if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_PACTRL) {
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
 			    b43_read16(dev, B43_MMIO_GPIO_MASK)
 			    | 0x0200);
 		mask |= 0x0200;
 		set |= 0x0200;
 	}
-	if (dev->dev->id.revision >= 2)
+	if (dev->sdev->id.revision >= 2)
 		mask |= 0x0010;	/* FIXME: This is redundant. */
 
 #ifdef CONFIG_SSB_DRIVER_PCICORE
@@ -2608,7 +2608,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
 /* Turn off all GPIO stuff. Call this on module unload, for example. */
 static void b43_gpio_cleanup(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct ssb_device *gpiodev, *pcidev = NULL;
 
 #ifdef CONFIG_SSB_DRIVER_PCICORE
@@ -2689,12 +2689,12 @@ out:
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MacPhyClkSet */
 void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on)
 {
-	u32 tmslow = ssb_read32(dev->dev, SSB_TMSLOW);
+	u32 tmslow = ssb_read32(dev->sdev, SSB_TMSLOW);
 	if (on)
 		tmslow |= B43_TMSLOW_MACPHYCLKEN;
 	else
 		tmslow &= ~B43_TMSLOW_MACPHYCLKEN;
-	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
+	ssb_write32(dev->sdev, SSB_TMSLOW, tmslow);
 }
 
 static void b43_adjust_opmode(struct b43_wldev *dev)
@@ -2733,15 +2733,15 @@ static void b43_adjust_opmode(struct b43_wldev *dev)
 	/* Workaround: On old hardware the HW-MAC-address-filter
 	 * doesn't work properly, so always run promisc in filter
 	 * it in software. */
-	if (dev->dev->id.revision <= 4)
+	if (dev->sdev->id.revision <= 4)
 		ctl |= B43_MACCTL_PROMISC;
 
 	b43_write32(dev, B43_MMIO_MACCTL, ctl);
 
 	cfp_pretbtt = 2;
 	if ((ctl & B43_MACCTL_INFRA) && !(ctl & B43_MACCTL_AP)) {
-		if (dev->dev->bus->chip_id == 0x4306 &&
-		    dev->dev->bus->chip_rev == 3)
+		if (dev->sdev->bus->chip_id == 0x4306 &&
+		    dev->sdev->bus->chip_rev == 3)
 			cfp_pretbtt = 100;
 		else
 			cfp_pretbtt = 50;
@@ -2899,7 +2899,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 		b43_write16(dev, 0x005E, value16);
 	}
 	b43_write32(dev, 0x0100, 0x01000000);
-	if (dev->dev->id.revision < 5)
+	if (dev->sdev->id.revision < 5)
 		b43_write32(dev, 0x010C, 0x01000000);
 
 	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
@@ -2914,7 +2914,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 	/* Initially set the wireless operation mode. */
 	b43_adjust_opmode(dev);
 
-	if (dev->dev->id.revision < 3) {
+	if (dev->sdev->id.revision < 3) {
 		b43_write16(dev, 0x060E, 0x0000);
 		b43_write16(dev, 0x0610, 0x8000);
 		b43_write16(dev, 0x0604, 0x0000);
@@ -2934,7 +2934,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 	b43_mac_phy_clock_set(dev, true);
 
 	b43_write16(dev, B43_MMIO_POWERUP_DELAY,
-		    dev->dev->bus->chipco.fast_pwrup_delay);
+		    dev->sdev->bus->chipco.fast_pwrup_delay);
 
 	err = 0;
 	b43dbg(dev->wl, "Chip initialized\n");
@@ -3097,7 +3097,7 @@ static int b43_validate_chipaccess(struct b43_wldev *dev)
 	b43_shm_write32(dev, B43_SHM_SHARED, 0, backup0);
 	b43_shm_write32(dev, B43_SHM_SHARED, 4, backup4);
 
-	if ((dev->dev->id.revision >= 3) && (dev->dev->id.revision <= 10)) {
+	if ((dev->sdev->id.revision >= 3) && (dev->sdev->id.revision <= 10)) {
 		/* The 32bit register shadows the two 16bit registers
 		 * with update sideeffects. Validate this. */
 		b43_write16(dev, B43_MMIO_TSF_CFP_START, 0xAAAA);
@@ -3450,7 +3450,7 @@ static void b43_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 
 static void b43_put_phy_into_reset(struct b43_wldev *dev)
 {
-	struct ssb_device *sdev = dev->dev;
+	struct ssb_device *sdev = dev->sdev;
 	u32 tmslow;
 
 	tmslow = ssb_read32(sdev, SSB_TMSLOW);
@@ -3946,7 +3946,7 @@ redo:
 
 	/* Disable interrupts on the device. */
 	b43_set_status(dev, B43_STAT_INITIALIZED);
-	if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) {
+	if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
 		/* wl->mutex is locked. That is enough. */
 		b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, 0);
 		b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* Flush */
@@ -3959,11 +3959,11 @@ redo:
 	/* Synchronize and free the interrupt handlers. Unlock to avoid deadlocks. */
 	orig_dev = dev;
 	mutex_unlock(&wl->mutex);
-	if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) {
+	if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
 		b43_sdio_free_irq(dev);
 	} else {
-		synchronize_irq(dev->dev->irq);
-		free_irq(dev->dev->irq, dev);
+		synchronize_irq(dev->sdev->irq);
+		free_irq(dev->sdev->irq, dev);
 	}
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
@@ -3996,18 +3996,19 @@ static int b43_wireless_core_start(struct b43_wldev *dev)
 	B43_WARN_ON(b43_status(dev) != B43_STAT_INITIALIZED);
 
 	drain_txstatus_queue(dev);
-	if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) {
+	if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
 		err = b43_sdio_request_irq(dev, b43_sdio_interrupt_handler);
 		if (err) {
 			b43err(dev->wl, "Cannot request SDIO IRQ\n");
 			goto out;
 		}
 	} else {
-		err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
+		err = request_threaded_irq(dev->sdev->irq, b43_interrupt_handler,
 					   b43_interrupt_thread_handler,
 					   IRQF_SHARED, KBUILD_MODNAME, dev);
 		if (err) {
-			b43err(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
+			b43err(dev->wl, "Cannot request IRQ-%d\n",
+			       dev->sdev->irq);
 			goto out;
 		}
 	}
@@ -4087,10 +4088,10 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 	       analog_type, phy_type, phy_rev);
 
 	/* Get RADIO versioning */
-	if (dev->dev->bus->chip_id == 0x4317) {
-		if (dev->dev->bus->chip_rev == 0)
+	if (dev->sdev->bus->chip_id == 0x4317) {
+		if (dev->sdev->bus->chip_rev == 0)
 			tmp = 0x3205017F;
-		else if (dev->dev->bus->chip_rev == 1)
+		else if (dev->sdev->bus->chip_rev == 1)
 			tmp = 0x4205017F;
 		else
 			tmp = 0x5205017F;
@@ -4195,7 +4196,7 @@ static void setup_struct_wldev_for_init(struct b43_wldev *dev)
 
 static void b43_bluetooth_coext_enable(struct b43_wldev *dev)
 {
-	struct ssb_sprom *sprom = &dev->dev->bus->sprom;
+	struct ssb_sprom *sprom = &dev->sdev->bus->sprom;
 	u64 hf;
 
 	if (!modparam_btcoex)
@@ -4222,16 +4223,16 @@ static void b43_bluetooth_coext_disable(struct b43_wldev *dev)
 
 static void b43_imcfglo_timeouts_workaround(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	u32 tmp;
 
 	if ((bus->chip_id == 0x4311 && bus->chip_rev == 2) ||
 	    (bus->chip_id == 0x4312)) {
-		tmp = ssb_read32(dev->dev, SSB_IMCFGLO);
+		tmp = ssb_read32(dev->sdev, SSB_IMCFGLO);
 		tmp &= ~SSB_IMCFGLO_REQTO;
 		tmp &= ~SSB_IMCFGLO_SERTO;
 		tmp |= 0x3;
-		ssb_write32(dev->dev, SSB_IMCFGLO, tmp);
+		ssb_write32(dev->sdev, SSB_IMCFGLO, tmp);
 		ssb_commit_settings(bus);
 	}
 }
@@ -4301,14 +4302,14 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 		dev->wl->current_beacon = NULL;
 	}
 
-	ssb_device_disable(dev->dev, 0);
-	ssb_bus_may_powerdown(dev->dev->bus);
+	ssb_device_disable(dev->sdev, 0);
+	ssb_bus_may_powerdown(dev->sdev->bus);
 }
 
 /* Initialize a wireless core */
 static int b43_wireless_core_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct ssb_sprom *sprom = &bus->sprom;
 	struct b43_phy *phy = &dev->phy;
 	int err;
@@ -4320,7 +4321,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	err = ssb_bus_powerup(bus, 0);
 	if (err)
 		goto out;
-	if (!ssb_device_is_enabled(dev->dev)) {
+	if (!ssb_device_is_enabled(dev->sdev)) {
 		tmp = phy->gmode ? B43_TMSLOW_GMODE : 0;
 		b43_wireless_core_reset(dev, tmp);
 	}
@@ -4330,7 +4331,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	phy->ops->prepare_structs(dev);
 
 	/* Enable IRQ routing to this device. */
-	ssb_pcicore_dev_irqvecs_enable(&bus->pcicore, dev->dev);
+	ssb_pcicore_dev_irqvecs_enable(&bus->pcicore, dev->sdev);
 
 	b43_imcfglo_timeouts_workaround(dev);
 	b43_bluetooth_coext_disable(dev);
@@ -4343,7 +4344,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	if (err)
 		goto err_busdown;
 	b43_shm_write16(dev, B43_SHM_SHARED,
-			B43_SHM_SH_WLCOREREV, dev->dev->id.revision);
+			B43_SHM_SH_WLCOREREV, dev->sdev->id.revision);
 	hf = b43_hf_read(dev);
 	if (phy->type == B43_PHYTYPE_G) {
 		hf |= B43_HF_SYMW;
@@ -4390,8 +4391,8 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	/* Maximum Contention Window */
 	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MAXCONT, 0x3FF);
 
-	if ((dev->dev->bus->bustype == SSB_BUSTYPE_PCMCIA) ||
-	    (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) ||
+	if ((dev->sdev->bus->bustype == SSB_BUSTYPE_PCMCIA) ||
+	    (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) ||
 	    dev->use_pio) {
 		dev->__using_pio_transfers = 1;
 		err = b43_pio_init(dev);
@@ -4728,7 +4729,7 @@ static void b43_wireless_core_detach(struct b43_wldev *dev)
 static int b43_wireless_core_attach(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct pci_dev *pdev = (bus->bustype == SSB_BUSTYPE_PCI) ? bus->host_pci : NULL;
 	int err;
 	bool have_2ghz_phy = 0, have_5ghz_phy = 0;
@@ -4747,10 +4748,10 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 		goto out;
 	}
 	/* Get the PHY type. */
-	if (dev->dev->id.revision >= 5) {
+	if (dev->sdev->id.revision >= 5) {
 		u32 tmshigh;
 
-		tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
+		tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
 		have_2ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY);
 		have_5ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_5GHZ_PHY);
 	} else
@@ -4823,7 +4824,7 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	INIT_WORK(&dev->restart_work, b43_chip_reset);
 
 	dev->phy.ops->switch_analog(dev, 0);
-	ssb_device_disable(dev->dev, 0);
+	ssb_device_disable(dev->sdev, 0);
 	ssb_bus_may_powerdown(bus);
 
 out:
@@ -4864,7 +4865,7 @@ static int b43_one_core_attach(struct ssb_device *dev, struct b43_wl *wl)
 		goto out;
 
 	wldev->use_pio = b43_modparam_pio;
-	wldev->dev = dev;
+	wldev->sdev = dev;
 	wldev->wl = wl;
 	b43_set_status(wldev, B43_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index b6428ec..b01c8ce 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -265,7 +265,7 @@ static void hardware_pctl_init_aphy(struct b43_wldev *dev)
 
 void b43_phy_inita(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 
 	/* This lowlevel A-PHY init is also called from G-PHY init.
@@ -311,7 +311,7 @@ void b43_phy_inita(struct b43_wldev *dev)
 	}
 
 	if ((phy->type == B43_PHYTYPE_G) &&
-	    (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)) {
+	    (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)) {
 		b43_phy_maskset(dev, B43_PHY_OFDM(0x6E), 0xE000, 0x3CF);
 	}
 }
@@ -323,17 +323,17 @@ static int b43_aphy_init_tssi2dbm_table(struct b43_wldev *dev)
 	struct b43_phy_a *aphy = phy->a;
 	s16 pab0, pab1, pab2;
 
-	pab0 = (s16) (dev->dev->bus->sprom.pa1b0);
-	pab1 = (s16) (dev->dev->bus->sprom.pa1b1);
-	pab2 = (s16) (dev->dev->bus->sprom.pa1b2);
+	pab0 = (s16) (dev->sdev->bus->sprom.pa1b0);
+	pab1 = (s16) (dev->sdev->bus->sprom.pa1b1);
+	pab2 = (s16) (dev->sdev->bus->sprom.pa1b2);
 
 	if (pab0 != 0 && pab1 != 0 && pab2 != 0 &&
 	    pab0 != -1 && pab1 != -1 && pab2 != -1) {
 		/* The pabX values are set in SPROM. Use them. */
-		if ((s8) dev->dev->bus->sprom.itssi_a != 0 &&
-		    (s8) dev->dev->bus->sprom.itssi_a != -1)
+		if ((s8) dev->sdev->bus->sprom.itssi_a != 0 &&
+		    (s8) dev->sdev->bus->sprom.itssi_a != -1)
 			aphy->tgt_idle_tssi =
-			    (s8) (dev->dev->bus->sprom.itssi_a);
+			    (s8) (dev->sdev->bus->sprom.itssi_a);
 		else
 			aphy->tgt_idle_tssi = 62;
 		aphy->tssi2dbm = b43_generate_dyn_tssi2dbm_tab(dev, pab0,
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index b5c5ce9..e46b2f4 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -168,7 +168,7 @@ void b43_phy_lock(struct b43_wldev *dev)
 	B43_WARN_ON(dev->phy.phy_locked);
 	dev->phy.phy_locked = 1;
 #endif
-	B43_WARN_ON(dev->dev->id.revision < 3);
+	B43_WARN_ON(dev->sdev->id.revision < 3);
 
 	if (!b43_is_mode(dev->wl, NL80211_IFTYPE_AP))
 		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
@@ -180,7 +180,7 @@ void b43_phy_unlock(struct b43_wldev *dev)
 	B43_WARN_ON(!dev->phy.phy_locked);
 	dev->phy.phy_locked = 0;
 #endif
-	B43_WARN_ON(dev->dev->id.revision < 3);
+	B43_WARN_ON(dev->sdev->id.revision < 3);
 
 	if (!b43_is_mode(dev->wl, NL80211_IFTYPE_AP))
 		b43_power_saving_ctl_bits(dev, 0);
@@ -368,8 +368,8 @@ void b43_phy_txpower_check(struct b43_wldev *dev, unsigned int flags)
 	/* The next check will be needed in two seconds, or later. */
 	phy->next_txpwr_check_time = round_jiffies(now + (HZ * 2));
 
-	if ((dev->dev->bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM) &&
-	    (dev->dev->bus->boardinfo.type == SSB_BOARD_BU4306))
+	if ((dev->sdev->bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM) &&
+	    (dev->sdev->bus->boardinfo.type == SSB_BOARD_BU4306))
 		return; /* No software txpower adjustment needed */
 
 	result = phy->ops->recalc_txpower(dev, !!(flags & B43_TXPWR_IGNORE_TSSI));
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index be48281..1758a28 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -718,7 +718,7 @@ static void b43_calc_nrssi_threshold(struct b43_wldev *dev)
 	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
 
 	if (!phy->gmode ||
-	    !(dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
+	    !(dev->sdev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
 		tmp16 = b43_nrssi_hw_read(dev, 0x20);
 		if (tmp16 >= 0x20)
 			tmp16 -= 0x40;
@@ -1114,7 +1114,7 @@ static u16 radio2050_rfover_val(struct b43_wldev *dev,
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
-	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
+	struct ssb_sprom *sprom = &(dev->sdev->bus->sprom);
 
 	if (!phy->gmode)
 		return 0;
@@ -1491,7 +1491,7 @@ static u16 b43_radio_init2050(struct b43_wldev *dev)
 
 static void b43_phy_initb5(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	u16 offset, value;
@@ -1620,7 +1620,7 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 		b43_radio_write16(dev, 0x5A, 0x88);
 		b43_radio_write16(dev, 0x5B, 0x6B);
 		b43_radio_write16(dev, 0x5C, 0x0F);
-		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_ALTIQ) {
+		if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_ALTIQ) {
 			b43_radio_write16(dev, 0x5D, 0xFA);
 			b43_radio_write16(dev, 0x5E, 0xD8);
 		} else {
@@ -1787,7 +1787,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	b43_phy_set(dev, B43_PHY_RFOVER, 0x0100);
 	b43_phy_mask(dev, B43_PHY_RFOVERVAL, 0xCFFF);
 
-	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA) {
+	if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA) {
 		if (phy->rev >= 7) {
 			b43_phy_set(dev, B43_PHY_RFOVER, 0x0800);
 			b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x8000);
@@ -1922,7 +1922,7 @@ static void b43_hardware_pctl_init_gphy(struct b43_wldev *dev)
 /* Initialize B/G PHY power control */
 static void b43_phy_init_pctl(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	struct b43_rfatt old_rfatt;
@@ -2053,7 +2053,7 @@ static void b43_phy_initg(struct b43_wldev *dev)
 	if (phy->rev >= 6) {
 		b43_phy_maskset(dev, B43_PHY_CCK(0x36), 0x0FFF, (gphy->lo_control->tx_bias << 12));
 	}
-	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
+	if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
 		b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x8075);
 	else
 		b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x807F);
@@ -2066,7 +2066,7 @@ static void b43_phy_initg(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0x8078);
 	}
 
-	if (!(dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
+	if (!(dev->sdev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
 		/* The specs state to update the NRSSI LT with
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
@@ -2088,8 +2088,8 @@ static void b43_phy_initg(struct b43_wldev *dev)
 	/* FIXME: The spec says in the following if, the 0 should be replaced
 	   'if OFDM may not be used in the current locale'
 	   but OFDM is legal everywhere */
-	if ((dev->dev->bus->chip_id == 0x4306
-	     && dev->dev->bus->chip_package == 2) || 0) {
+	if ((dev->sdev->bus->chip_id == 0x4306
+	     && dev->sdev->bus->chip_package == 2) || 0) {
 		b43_phy_mask(dev, B43_PHY_CRS0, 0xBFFF);
 		b43_phy_mask(dev, B43_PHY_OFDM(0xC3), 0x7FFF);
 	}
@@ -2105,7 +2105,7 @@ void b43_gphy_channel_switch(struct b43_wldev *dev,
 	b43_write16(dev, B43_MMIO_CHANNEL, channel2freq_bg(channel));
 
 	if (channel == 14) {
-		if (dev->dev->bus->sprom.country_code ==
+		if (dev->sdev->bus->sprom.country_code ==
 		    SSB_SPROM1CCODE_JAPAN)
 			b43_hf_write(dev,
 				     b43_hf_read(dev) & ~B43_HF_ACPR);
@@ -2136,7 +2136,7 @@ static void default_baseband_attenuation(struct b43_wldev *dev,
 static void default_radio_attenuation(struct b43_wldev *dev,
 				      struct b43_rfatt *rf)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 
 	rf->with_padmix = 0;
@@ -2384,11 +2384,11 @@ static int b43_gphy_init_tssi2dbm_table(struct b43_wldev *dev)
 	struct b43_phy_g *gphy = phy->g;
 	s16 pab0, pab1, pab2;
 
-	pab0 = (s16) (dev->dev->bus->sprom.pa0b0);
-	pab1 = (s16) (dev->dev->bus->sprom.pa0b1);
-	pab2 = (s16) (dev->dev->bus->sprom.pa0b2);
+	pab0 = (s16) (dev->sdev->bus->sprom.pa0b0);
+	pab1 = (s16) (dev->sdev->bus->sprom.pa0b1);
+	pab2 = (s16) (dev->sdev->bus->sprom.pa0b2);
 
-	B43_WARN_ON((dev->dev->bus->chip_id == 0x4301) &&
+	B43_WARN_ON((dev->sdev->bus->chip_id == 0x4301) &&
 		    (phy->radio_ver != 0x2050)); /* Not supported anymore */
 
 	gphy->dyn_tssi_tbl = 0;
@@ -2396,10 +2396,10 @@ static int b43_gphy_init_tssi2dbm_table(struct b43_wldev *dev)
 	if (pab0 != 0 && pab1 != 0 && pab2 != 0 &&
 	    pab0 != -1 && pab1 != -1 && pab2 != -1) {
 		/* The pabX values are set in SPROM. Use them. */
-		if ((s8) dev->dev->bus->sprom.itssi_bg != 0 &&
-		    (s8) dev->dev->bus->sprom.itssi_bg != -1) {
+		if ((s8) dev->sdev->bus->sprom.itssi_bg != 0 &&
+		    (s8) dev->sdev->bus->sprom.itssi_bg != -1) {
 			gphy->tgt_idle_tssi =
-				(s8) (dev->dev->bus->sprom.itssi_bg);
+				(s8) (dev->sdev->bus->sprom.itssi_bg);
 		} else
 			gphy->tgt_idle_tssi = 62;
 		gphy->tssi2dbm = b43_generate_dyn_tssi2dbm_tab(dev, pab0,
@@ -2840,7 +2840,7 @@ static void b43_gphy_op_adjust_txpower(struct b43_wldev *dev)
 				    B43_TXCTL_TXMIX;
 				rfatt += 2;
 				bbatt += 2;
-			} else if (dev->dev->bus->sprom.
+			} else if (dev->sdev->bus->sprom.
 				   boardflags_lo &
 				   B43_BFL_PACTRL) {
 				bbatt += 4 * (rfatt - 2);
@@ -2914,14 +2914,14 @@ static enum b43_txpwr_result b43_gphy_op_recalc_txpower(struct b43_wldev *dev,
 	estimated_pwr = b43_gphy_estimate_power_out(dev, average_tssi);
 
 	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
-	max_pwr = dev->dev->bus->sprom.maxpwr_bg;
-	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
+	max_pwr = dev->sdev->bus->sprom.maxpwr_bg;
+	if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
 		max_pwr -= 3; /* minus 0.75 */
 	if (unlikely(max_pwr >= INT_TO_Q52(30/*dBm*/))) {
 		b43warn(dev->wl,
 			"Invalid max-TX-power value in SPROM.\n");
 		max_pwr = INT_TO_Q52(20); /* fake it */
-		dev->dev->bus->sprom.maxpwr_bg = max_pwr;
+		dev->sdev->bus->sprom.maxpwr_bg = max_pwr;
 	}
 
 	/* Get desired power (in Q5.2) */
@@ -3014,7 +3014,7 @@ static void b43_gphy_op_pwork_60sec(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 
-	if (!(dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI))
+	if (!(dev->sdev->bus->sprom.boardflags_lo & B43_BFL_RSSI))
 		return;
 
 	b43_mac_suspend(dev);
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index fd50eb1..012c8da 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -86,7 +86,7 @@ static void b43_lpphy_op_free(struct b43_wldev *dev)
 static void lpphy_read_band_sprom(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	u16 cckpo, maxpwr;
 	u32 ofdmpo;
 	int i;
@@ -214,7 +214,7 @@ static void lpphy_table_init(struct b43_wldev *dev)
 
 static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	u16 tmp, tmp2;
 
@@ -412,7 +412,7 @@ static void lpphy_restore_dig_flt_state(struct b43_wldev *dev)
 
 static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 
 	b43_phy_write(dev, B43_LPPHY_AFE_DAC_CTL, 0x50);
@@ -519,7 +519,7 @@ struct b2062_freqdata {
 static void lpphy_2062_init(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	u32 crystalfreq, tmp, ref;
 	unsigned int i;
 	const struct b2062_freqdata *fd = NULL;
@@ -697,7 +697,7 @@ static void lpphy_radio_init(struct b43_wldev *dev)
 		lpphy_sync_stx(dev);
 		b43_phy_write(dev, B43_PHY_OFDM(0xF0), 0x5F80);
 		b43_phy_write(dev, B43_PHY_OFDM(0xF1), 0);
-		if (dev->dev->bus->chip_id == 0x4325) {
+		if (dev->sdev->bus->chip_id == 0x4325) {
 			// TODO SSB PMU recalibration
 		}
 	}
@@ -1289,7 +1289,7 @@ finish:
 
 static void lpphy_rev2plus_rc_calib(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
 	u8 tmp = b43_radio_read(dev, B2063_RX_BB_SP8) & 0xFF;
 	int i;
@@ -1840,7 +1840,7 @@ static void lpphy_papd_cal(struct b43_wldev *dev, struct lpphy_tx_gains gains,
 static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct lpphy_tx_gains gains, oldgains;
 	int old_txpctl, old_afe_ovr, old_rf, old_bbmult;
 
@@ -1870,7 +1870,7 @@ static int lpphy_rx_iq_cal(struct b43_wldev *dev, bool noise, bool tx,
 			    bool rx, bool pa, struct lpphy_tx_gains *gains)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	const struct lpphy_rx_iq_comp *iqcomp = NULL;
 	struct lpphy_tx_gains nogains, oldgains;
 	u16 tmp;
@@ -2408,7 +2408,7 @@ static const struct b206x_channel b2063_chantbl[] = {
 
 static void lpphy_b2062_reset_pll_bias(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 
 	b43_radio_write(dev, B2062_S_RFPLL_CTL2, 0xFF);
 	udelay(20);
@@ -2432,7 +2432,7 @@ static int lpphy_b2062_tune(struct b43_wldev *dev,
 			    unsigned int channel)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	const struct b206x_channel *chandata = NULL;
 	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
 	u32 tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9;
@@ -2522,7 +2522,7 @@ static void lpphy_b2063_vco_calib(struct b43_wldev *dev)
 static int lpphy_b2063_tune(struct b43_wldev *dev,
 			    unsigned int channel)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 
 	static const struct b206x_channel *chandata = NULL;
 	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index b075a3f..9ed6515 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -299,7 +299,7 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
-	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
+	struct ssb_sprom *sprom = &(dev->sdev->bus->sprom);
 
 	u8 txpi[2], bbmult, i;
 	u16 tmp, radio_gain, dac_gain;
@@ -423,8 +423,8 @@ static void b43_radio_init2055_pre(struct b43_wldev *dev)
 static void b43_radio_init2055_post(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
-	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
-	struct ssb_boardinfo *binfo = &(dev->dev->bus->boardinfo);
+	struct ssb_sprom *sprom = &(dev->sdev->bus->sprom);
+	struct ssb_boardinfo *binfo = &(dev->sdev->bus->boardinfo);
 	int i;
 	u16 val;
 	bool workaround = false;
@@ -609,12 +609,12 @@ static void b43_nphy_bmac_clock_fgc(struct b43_wldev *dev, bool force)
 	if (dev->phy.type != B43_PHYTYPE_N)
 		return;
 
-	tmslow = ssb_read32(dev->dev, SSB_TMSLOW);
+	tmslow = ssb_read32(dev->sdev, SSB_TMSLOW);
 	if (force)
 		tmslow |= SSB_TMSLOW_FGC;
 	else
 		tmslow &= ~SSB_TMSLOW_FGC;
-	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
+	ssb_write32(dev->sdev, SSB_TMSLOW, tmslow);
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
@@ -959,7 +959,7 @@ static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 		b43_phy_write(dev, B43_NPHY_GPIO_LOOEN, 0);
 		b43_phy_write(dev, B43_NPHY_GPIO_HIOEN, 0);
 
-		ssb_chipco_gpio_control(&dev->dev->bus->chipco, 0xFC00,
+		ssb_chipco_gpio_control(&dev->sdev->bus->chipco, 0xFC00,
 					0xFC00);
 		b43_write32(dev, B43_MMIO_MACCTL,
 			b43_read32(dev, B43_MMIO_MACCTL) &
@@ -983,7 +983,7 @@ static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
 {
 	u16 tmp;
 
-	if (dev->dev->id.revision == 16)
+	if (dev->sdev->id.revision == 16)
 		b43_mac_suspend(dev);
 
 	tmp = b43_phy_read(dev, B43_NPHY_CLASSCTL);
@@ -993,7 +993,7 @@ static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
 	tmp |= (val & mask);
 	b43_phy_maskset(dev, B43_NPHY_CLASSCTL, 0xFFF8, tmp);
 
-	if (dev->dev->id.revision == 16)
+	if (dev->sdev->id.revision == 16)
 		b43_mac_enable(dev);
 
 	return tmp;
@@ -1168,7 +1168,7 @@ static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
-	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
+	struct ssb_sprom *sprom = &(dev->sdev->bus->sprom);
 
 	/* PHY rev 0, 1, 2 */
 	u8 i, j;
@@ -1373,7 +1373,7 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
 static void b43_nphy_workarounds(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
 
@@ -3586,7 +3586,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
  */
 int b43_phy_initn(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
 	u8 tx_pwr_state;
@@ -3601,7 +3601,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	if ((dev->phy.rev >= 3) &&
 	   (bus->sprom.boardflags_lo & B43_BFL_EXTLNA) &&
 	   (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)) {
-		chipco_set32(&dev->dev->bus->chipco, SSB_CHIPCO_CHIPCTL, 0x40);
+		chipco_set32(&dev->sdev->bus->chipco, SSB_CHIPCO_CHIPCTL, 0x40);
 	}
 	nphy->deaf_count = 0;
 	b43_nphy_tables_init(dev);
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index aa12273..af0596d 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -111,7 +111,7 @@ static u16 index_to_pioqueue_base(struct b43_wldev *dev,
 		B43_MMIO_PIO11_BASE5,
 	};
 
-	if (dev->dev->id.revision >= 11) {
+	if (dev->sdev->id.revision >= 11) {
 		B43_WARN_ON(index >= ARRAY_SIZE(bases_rev11));
 		return bases_rev11[index];
 	}
@@ -121,14 +121,14 @@ static u16 index_to_pioqueue_base(struct b43_wldev *dev,
 
 static u16 pio_txqueue_offset(struct b43_wldev *dev)
 {
-	if (dev->dev->id.revision >= 11)
+	if (dev->sdev->id.revision >= 11)
 		return 0x18;
 	return 0;
 }
 
 static u16 pio_rxqueue_offset(struct b43_wldev *dev)
 {
-	if (dev->dev->id.revision >= 11)
+	if (dev->sdev->id.revision >= 11)
 		return 0x38;
 	return 8;
 }
@@ -144,7 +144,7 @@ static struct b43_pio_txqueue *b43_setup_pioqueue_tx(struct b43_wldev *dev,
 	if (!q)
 		return NULL;
 	q->dev = dev;
-	q->rev = dev->dev->id.revision;
+	q->rev = dev->sdev->id.revision;
 	q->mmio_base = index_to_pioqueue_base(dev, index) +
 		       pio_txqueue_offset(dev);
 	q->index = index;
@@ -178,7 +178,7 @@ static struct b43_pio_rxqueue *b43_setup_pioqueue_rx(struct b43_wldev *dev,
 	if (!q)
 		return NULL;
 	q->dev = dev;
-	q->rev = dev->dev->id.revision;
+	q->rev = dev->sdev->id.revision;
 	q->mmio_base = index_to_pioqueue_base(dev, index) +
 		       pio_rxqueue_offset(dev);
 
@@ -339,7 +339,7 @@ static u16 tx_write_2byte_queue(struct b43_pio_txqueue *q,
 	ctl |= B43_PIO_TXCTL_WRITELO | B43_PIO_TXCTL_WRITEHI;
 	b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
 
-	ssb_block_write(dev->dev, data, (data_len & ~1),
+	ssb_block_write(dev->sdev, data, (data_len & ~1),
 			q->mmio_base + B43_PIO_TXDATA,
 			sizeof(u16));
 	if (data_len & 1) {
@@ -351,7 +351,7 @@ static u16 tx_write_2byte_queue(struct b43_pio_txqueue *q,
 		b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
 		tail[0] = data[data_len - 1];
 		tail[1] = 0;
-		ssb_block_write(dev->dev, tail, 2,
+		ssb_block_write(dev->sdev, tail, 2,
 				q->mmio_base + B43_PIO_TXDATA,
 				sizeof(u16));
 	}
@@ -393,7 +393,7 @@ static u32 tx_write_4byte_queue(struct b43_pio_txqueue *q,
 	       B43_PIO8_TXCTL_16_23 | B43_PIO8_TXCTL_24_31;
 	b43_piotx_write32(q, B43_PIO8_TXCTL, ctl);
 
-	ssb_block_write(dev->dev, data, (data_len & ~3),
+	ssb_block_write(dev->sdev, data, (data_len & ~3),
 			q->mmio_base + B43_PIO8_TXDATA,
 			sizeof(u32));
 	if (data_len & 3) {
@@ -421,7 +421,7 @@ static u32 tx_write_4byte_queue(struct b43_pio_txqueue *q,
 			break;
 		}
 		b43_piotx_write32(q, B43_PIO8_TXCTL, ctl);
-		ssb_block_write(dev->dev, tail, 4,
+		ssb_block_write(dev->sdev, tail, 4,
 				q->mmio_base + B43_PIO8_TXDATA,
 				sizeof(u32));
 	}
@@ -657,11 +657,11 @@ data_ready:
 
 	/* Get the preamble (RX header) */
 	if (q->rev >= 8) {
-		ssb_block_read(dev->dev, rxhdr, sizeof(*rxhdr),
+		ssb_block_read(dev->sdev, rxhdr, sizeof(*rxhdr),
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 	} else {
-		ssb_block_read(dev->dev, rxhdr, sizeof(*rxhdr),
+		ssb_block_read(dev->sdev, rxhdr, sizeof(*rxhdr),
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 	}
@@ -697,7 +697,7 @@ data_ready:
 	skb_reserve(skb, 2);
 	skb_put(skb, len + padding);
 	if (q->rev >= 8) {
-		ssb_block_read(dev->dev, skb->data + padding, (len & ~3),
+		ssb_block_read(dev->sdev, skb->data + padding, (len & ~3),
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 		if (len & 3) {
@@ -705,7 +705,7 @@ data_ready:
 			BUILD_BUG_ON(sizeof(wl->pio_tailspace) < 4);
 
 			/* Read the last few bytes. */
-			ssb_block_read(dev->dev, tail, 4,
+			ssb_block_read(dev->sdev, tail, 4,
 				       q->mmio_base + B43_PIO8_RXDATA,
 				       sizeof(u32));
 			switch (len & 3) {
@@ -724,7 +724,7 @@ data_ready:
 			}
 		}
 	} else {
-		ssb_block_read(dev->dev, skb->data + padding, (len & ~1),
+		ssb_block_read(dev->sdev, skb->data + padding, (len & ~1),
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 		if (len & 1) {
@@ -732,7 +732,7 @@ data_ready:
 			BUILD_BUG_ON(sizeof(wl->pio_tailspace) < 2);
 
 			/* Read the last byte. */
-			ssb_block_read(dev->dev, tail, 2,
+			ssb_block_read(dev->sdev, tail, 2,
 				       q->mmio_base + B43_PIO_RXDATA,
 				       sizeof(u16));
 			skb->data[len + padding - 1] = tail[0];
diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index 86bc0a0..a617efe 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -37,7 +37,7 @@ void b43_rfkill_poll(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	bool enabled;
 	bool brought_up = false;
 
@@ -47,7 +47,7 @@ void b43_rfkill_poll(struct ieee80211_hw *hw)
 			mutex_unlock(&wl->mutex);
 			return;
 		}
-		ssb_device_enable(dev->dev, 0);
+		ssb_device_enable(dev->sdev, 0);
 		brought_up = true;
 	}
 
@@ -63,7 +63,7 @@ void b43_rfkill_poll(struct ieee80211_hw *hw)
 	}
 
 	if (brought_up) {
-		ssb_device_disable(dev->dev, 0);
+		ssb_device_disable(dev->sdev, 0);
 		ssb_bus_may_powerdown(bus);
 	}
 
diff --git a/drivers/net/wireless/b43/sysfs.c b/drivers/net/wireless/b43/sysfs.c
index f1ae4e0..57af619 100644
--- a/drivers/net/wireless/b43/sysfs.c
+++ b/drivers/net/wireless/b43/sysfs.c
@@ -140,7 +140,7 @@ static DEVICE_ATTR(interference, 0644,
 
 int b43_sysfs_register(struct b43_wldev *wldev)
 {
-	struct device *dev = wldev->dev->dev;
+	struct device *dev = wldev->sdev->dev;
 
 	B43_WARN_ON(b43_status(wldev) != B43_STAT_INITIALIZED);
 
@@ -149,7 +149,7 @@ int b43_sysfs_register(struct b43_wldev *wldev)
 
 void b43_sysfs_unregister(struct b43_wldev *wldev)
 {
-	struct device *dev = wldev->dev->dev;
+	struct device *dev = wldev->sdev->dev;
 
 	device_remove_file(dev, &dev_attr_interference);
 }
diff --git a/drivers/net/wireless/b43/tables_lpphy.c b/drivers/net/wireless/b43/tables_lpphy.c
index 61027ee..59df3c6 100644
--- a/drivers/net/wireless/b43/tables_lpphy.c
+++ b/drivers/net/wireless/b43/tables_lpphy.c
@@ -2304,7 +2304,7 @@ void lpphy_rev0_1_table_init(struct b43_wldev *dev)
 
 void lpphy_rev2plus_table_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	int i;
 
 	B43_WARN_ON(dev->phy.rev < 2);
@@ -2416,7 +2416,7 @@ void lpphy_write_gain_table_bulk(struct b43_wldev *dev, int offset, int count,
 
 void lpphy_init_tx_gain_table(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 
 	switch (dev->phy.rev) {
 	case 0:
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index 9a335da..8f4db44 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -458,7 +458,7 @@ static void b43_wa_rssi_adc(struct b43_wldev *dev)
 
 static void b43_wa_boards_a(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 
 	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM &&
 	    bus->boardinfo.type == SSB_BOARD_BU4306 &&
@@ -486,7 +486,7 @@ static void b43_wa_boards_a(struct b43_wldev *dev)
 
 static void b43_wa_boards_g(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 
 	if (bus->boardinfo.vendor != SSB_BOARDVENDOR_BCM ||
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index e5be381..c8f99ae 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -547,7 +547,7 @@ static s8 b43_rssi_postprocess(struct b43_wldev *dev,
 			else
 				tmp -= 3;
 		} else {
-			if (dev->dev->bus->sprom.
+			if (dev->sdev->bus->sprom.
 			    boardflags_lo & B43_BFL_RSSI) {
 				if (in_rssi > 63)
 					in_rssi = 63;
-- 
1.7.1

