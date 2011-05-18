Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57019 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1EQX3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:29:23 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so286932eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 16:29:23 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 6/9] b43: bus: abstract device structs and irq
Date: Wed, 18 May 2011 02:06:40 +0200
Message-Id: <1305677203-16660-6-git-send-email-zajec5@gmail.com> (sfid-20110518_012927_220419_AA503028)
In-Reply-To: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/bus.c   |    4 ++++
 drivers/net/wireless/b43/bus.h   |    4 ++++
 drivers/net/wireless/b43/dma.c   |   28 ++++++++++++++--------------
 drivers/net/wireless/b43/leds.c  |    2 +-
 drivers/net/wireless/b43/main.c  |   10 +++++-----
 drivers/net/wireless/b43/sysfs.c |    4 ++--
 6 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index c116f12..ec59a12 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -70,6 +70,10 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 	dev->block_read = b43_bus_ssb_block_read;
 	dev->block_write = b43_bus_ssb_block_write;
 
+	dev->dev = sdev->dev;
+	dev->dma_dev = sdev->dma_dev;
+	dev->irq = sdev->irq;
+
 	dev->bus_sprom = &sdev->bus->sprom;
 
 	dev->core_id = sdev->id.coreid;
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index 6d575d6..d432f5c 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -20,6 +20,10 @@ struct b43_bus_dev {
 	void (*block_write)(struct b43_bus_dev *dev, const void *buffer,
 			    size_t count, u16 offset, u8 reg_width);
 
+	struct device *dev;
+	struct device *dma_dev;
+	unsigned int irq;
+
 	struct ssb_sprom *bus_sprom;
 
 	u16 core_id;
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index ee45ab9..11e66cd 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -333,10 +333,10 @@ static inline
 	dma_addr_t dmaaddr;
 
 	if (tx) {
-		dmaaddr = dma_map_single(ring->dev->sdev->dma_dev,
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
 					 buf, len, DMA_TO_DEVICE);
 	} else {
-		dmaaddr = dma_map_single(ring->dev->sdev->dma_dev,
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
 					 buf, len, DMA_FROM_DEVICE);
 	}
 
@@ -348,10 +348,10 @@ static inline
 			  dma_addr_t addr, size_t len, int tx)
 {
 	if (tx) {
-		dma_unmap_single(ring->dev->sdev->dma_dev,
+		dma_unmap_single(ring->dev->dev->dma_dev,
 				 addr, len, DMA_TO_DEVICE);
 	} else {
-		dma_unmap_single(ring->dev->sdev->dma_dev,
+		dma_unmap_single(ring->dev->dev->dma_dev,
 				 addr, len, DMA_FROM_DEVICE);
 	}
 }
@@ -361,7 +361,7 @@ static inline
 				 dma_addr_t addr, size_t len)
 {
 	B43_WARN_ON(ring->tx);
-	dma_sync_single_for_cpu(ring->dev->sdev->dma_dev,
+	dma_sync_single_for_cpu(ring->dev->dev->dma_dev,
 				    addr, len, DMA_FROM_DEVICE);
 }
 
@@ -370,7 +370,7 @@ static inline
 				    dma_addr_t addr, size_t len)
 {
 	B43_WARN_ON(ring->tx);
-	dma_sync_single_for_device(ring->dev->sdev->dma_dev,
+	dma_sync_single_for_device(ring->dev->dev->dma_dev,
 				   addr, len, DMA_FROM_DEVICE);
 }
 
@@ -401,7 +401,7 @@ static int alloc_ringmemory(struct b43_dmaring *ring)
 	 */
 	if (ring->type == B43_DMA_64BIT)
 		flags |= GFP_DMA;
-	ring->descbase = dma_alloc_coherent(ring->dev->sdev->dma_dev,
+	ring->descbase = dma_alloc_coherent(ring->dev->dev->dma_dev,
 					    B43_DMA_RINGMEMSIZE,
 					    &(ring->dmabase), flags);
 	if (!ring->descbase) {
@@ -415,7 +415,7 @@ static int alloc_ringmemory(struct b43_dmaring *ring)
 
 static void free_ringmemory(struct b43_dmaring *ring)
 {
-	dma_free_coherent(ring->dev->sdev->dma_dev, B43_DMA_RINGMEMSIZE,
+	dma_free_coherent(ring->dev->dev->dma_dev, B43_DMA_RINGMEMSIZE,
 			  ring->descbase, ring->dmabase);
 }
 
@@ -523,7 +523,7 @@ static bool b43_dma_mapping_error(struct b43_dmaring *ring,
 				  dma_addr_t addr,
 				  size_t buffersize, bool dma_to_device)
 {
-	if (unlikely(dma_mapping_error(ring->dev->sdev->dma_dev, addr)))
+	if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
 		return 1;
 
 	switch (ring->type) {
@@ -869,7 +869,7 @@ struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
-		dma_test = dma_map_single(dev->sdev->dma_dev,
+		dma_test = dma_map_single(dev->dev->dma_dev,
 					  ring->txhdr_cache,
 					  b43_txhdr_size(dev),
 					  DMA_TO_DEVICE);
@@ -884,7 +884,7 @@ struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
-			dma_test = dma_map_single(dev->sdev->dma_dev,
+			dma_test = dma_map_single(dev->dev->dma_dev,
 						  ring->txhdr_cache,
 						  b43_txhdr_size(dev),
 						  DMA_TO_DEVICE);
@@ -898,7 +898,7 @@ struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
 			}
 		}
 
-		dma_unmap_single(dev->sdev->dma_dev,
+		dma_unmap_single(dev->dev->dma_dev,
 				 dma_test, b43_txhdr_size(dev),
 				 DMA_TO_DEVICE);
 	}
@@ -1013,9 +1013,9 @@ static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
 	/* Try to set the DMA mask. If it fails, try falling back to a
 	 * lower mask, as we can always also support a lower one. */
 	while (1) {
-		err = dma_set_mask(dev->sdev->dma_dev, mask);
+		err = dma_set_mask(dev->dev->dma_dev, mask);
 		if (!err) {
-			err = dma_set_coherent_mask(dev->sdev->dma_dev, mask);
+			err = dma_set_coherent_mask(dev->dev->dma_dev, mask);
 			if (!err)
 				break;
 		}
diff --git a/drivers/net/wireless/b43/leds.c b/drivers/net/wireless/b43/leds.c
index 26d37ef..70bcf42 100644
--- a/drivers/net/wireless/b43/leds.c
+++ b/drivers/net/wireless/b43/leds.c
@@ -138,7 +138,7 @@ static int b43_register_led(struct b43_wldev *dev, struct b43_led *led,
 	led->led_dev.default_trigger = default_trigger;
 	led->led_dev.brightness_set = b43_led_brightness_set;
 
-	err = led_classdev_register(dev->sdev->dev, &led->led_dev);
+	err = led_classdev_register(dev->dev->dev, &led->led_dev);
 	if (err) {
 		b43warn(dev->wl, "LEDs: Failed to register %s\n", name);
 		led->wl = NULL;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 0f3a104..fd1e74c 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2063,7 +2063,7 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 		B43_WARN_ON(1);
 		return -ENOSYS;
 	}
-	err = request_firmware(&blob, ctx->fwname, ctx->dev->sdev->dev);
+	err = request_firmware(&blob, ctx->fwname, ctx->dev->dev->dev);
 	if (err == -ENOENT) {
 		snprintf(ctx->errors[ctx->req_type],
 			 sizeof(ctx->errors[ctx->req_type]),
@@ -3970,8 +3970,8 @@ redo:
 	if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
 		b43_sdio_free_irq(dev);
 	} else {
-		synchronize_irq(dev->sdev->irq);
-		free_irq(dev->sdev->irq, dev);
+		synchronize_irq(dev->dev->irq);
+		free_irq(dev->dev->irq, dev);
 	}
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
@@ -4011,12 +4011,12 @@ static int b43_wireless_core_start(struct b43_wldev *dev)
 			goto out;
 		}
 	} else {
-		err = request_threaded_irq(dev->sdev->irq, b43_interrupt_handler,
+		err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
 					   b43_interrupt_thread_handler,
 					   IRQF_SHARED, KBUILD_MODNAME, dev);
 		if (err) {
 			b43err(dev->wl, "Cannot request IRQ-%d\n",
-			       dev->sdev->irq);
+			       dev->dev->irq);
 			goto out;
 		}
 	}
diff --git a/drivers/net/wireless/b43/sysfs.c b/drivers/net/wireless/b43/sysfs.c
index 57af619..f1ae4e0 100644
--- a/drivers/net/wireless/b43/sysfs.c
+++ b/drivers/net/wireless/b43/sysfs.c
@@ -140,7 +140,7 @@ static DEVICE_ATTR(interference, 0644,
 
 int b43_sysfs_register(struct b43_wldev *wldev)
 {
-	struct device *dev = wldev->sdev->dev;
+	struct device *dev = wldev->dev->dev;
 
 	B43_WARN_ON(b43_status(wldev) != B43_STAT_INITIALIZED);
 
@@ -149,7 +149,7 @@ int b43_sysfs_register(struct b43_wldev *wldev)
 
 void b43_sysfs_unregister(struct b43_wldev *wldev)
 {
-	struct device *dev = wldev->sdev->dev;
+	struct device *dev = wldev->dev->dev;
 
 	device_remove_file(dev, &dev_attr_interference);
 }
-- 
1.7.3.4

