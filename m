Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49206
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbXHRXxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 19:53:20 -0400
Message-Id: <20070818234835.034817000@bu3sch.de>
References: <20070818234833.623623000@bu3sch.de>
Date: Sun, 19 Aug 2007 01:48:36 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 3/6] b43: Rename print functions to b43foobar
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid namespace pollution.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/b43.h	2007-08-14 17:01:07.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/b43.h	2007-08-15 19:15:03.000000000 +0200
@@ -773,17 +773,17 @@ static inline void b43_write32(struct b4
 }
 
 /* Message printing */
-void bcminfo(struct b43_wl *wl, const char *fmt, ...)
+void b43info(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
-void bcmerr(struct b43_wl *wl, const char *fmt, ...)
+void b43err(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
-void bcmwarn(struct b43_wl *wl, const char *fmt, ...)
+void b43warn(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 #if B43_DEBUG
-void bcmdbg(struct b43_wl *wl, const char *fmt, ...)
+void b43dbg(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 #else /* DEBUG */
-# define bcmdbg(wl, fmt...) do { /* nothing */ } while (0)
+# define b43dbg(wl, fmt...) do { /* nothing */ } while (0)
 #endif /* DEBUG */
 
 /* A WARN_ON variant that vanishes when b43 debugging is disabled.
Index: wireless-dev-new/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/debugfs.c	2007-08-15 15:08:39.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/debugfs.c	2007-08-15 19:15:03.000000000 +0200
@@ -126,12 +126,12 @@ static ssize_t tsf_write_file(struct fil
 	mutex_lock(&dev->wl->mutex);
 	spin_lock_irqsave(&dev->wl->irq_lock, flags);
 	if (b43_status(dev) < B43_STAT_STARTED) {
-		bcmerr(dev->wl, "debugfs: Board not initialized.\n");
+		b43err(dev->wl, "debugfs: Board not initialized.\n");
 		res = -EFAULT;
 		goto out_unlock;
 	}
 	if (sscanf(buf, "%llu", (unsigned long long *)(&tsf)) != 1) {
-		bcmerr(dev->wl, "debugfs: invalid values for \"tsf\"\n");
+		b43err(dev->wl, "debugfs: invalid values for \"tsf\"\n");
 		res = -EINVAL;
 		goto out_unlock;
 	}
@@ -234,7 +234,7 @@ static ssize_t restart_write_file(struct
 	mutex_lock(&dev->wl->mutex);
 	spin_lock_irqsave(&dev->wl->irq_lock, flags);
 	if (b43_status(dev) < B43_STAT_INITIALIZED) {
-		bcmerr(dev->wl, "debugfs: Board not initialized.\n");
+		b43err(dev->wl, "debugfs: Board not initialized.\n");
 		res = -EFAULT;
 		goto out_unlock;
 	}
@@ -323,12 +323,12 @@ static ssize_t txpower_g_write_file(stru
 	mutex_lock(&dev->wl->mutex);
 	spin_lock_irqsave(&dev->wl->irq_lock, flags);
 	if (b43_status(dev) < B43_STAT_STARTED) {
-		bcmerr(dev->wl, "debugfs: Board not initialized.\n");
+		b43err(dev->wl, "debugfs: Board not initialized.\n");
 		res = -ENODEV;
 		goto out_unlock;
 	}
 	if (dev->phy.type != B43_PHYTYPE_G) {
-		bcmerr(dev->wl, "debugfs: Device is not a G-PHY\n");
+		b43err(dev->wl, "debugfs: Device is not a G-PHY\n");
 		res = -ENODEV;
 		goto out_unlock;
 	}
@@ -341,7 +341,7 @@ static ssize_t txpower_g_write_file(stru
 		/* Manual control */
 		if (sscanf(buf, "%d %d %d %d %d", &bbatt, &rfatt,
 			   &txmix, &pa2db, &pa3db) != 5) {
-			bcmerr(dev->wl,
+			b43err(dev->wl,
 			       "debugfs: invalid value for \"tx_power_g\"\n");
 			res = -EINVAL;
 			goto out_unlock;
@@ -450,7 +450,7 @@ void b43_debugfs_add_device(struct b43_w
 	B43_WARN_ON(!dev);
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (!e) {
-		bcmerr(dev->wl, "debugfs: add device OOM\n");
+		b43err(dev->wl, "debugfs: add device OOM\n");
 		return;
 	}
 	e->dev = dev;
@@ -458,7 +458,7 @@ void b43_debugfs_add_device(struct b43_w
 	log->log = kcalloc(B43_NR_LOGGED_TXSTATUS,
 			   sizeof(struct b43_txstatus), GFP_KERNEL);
 	if (!log->log) {
-		bcmerr(dev->wl, "debugfs: add device txstatus OOM\n");
+		b43err(dev->wl, "debugfs: add device txstatus OOM\n");
 		kfree(e);
 		return;
 	}
@@ -471,10 +471,10 @@ void b43_debugfs_add_device(struct b43_w
 	e->subdir = debugfs_create_dir(devdir, fs.root);
 	if (!e->subdir || IS_ERR(e->subdir)) {
 		if (e->subdir == ERR_PTR(-ENODEV)) {
-			bcmdbg(dev->wl, "DebugFS (CONFIG_DEBUG_FS) not "
+			b43dbg(dev->wl, "DebugFS (CONFIG_DEBUG_FS) not "
 			       "enabled in kernel config\n");
 		} else {
-			bcmerr(dev->wl, "debugfs: cannot create %s directory\n",
+			b43err(dev->wl, "debugfs: cannot create %s directory\n",
 			       devdir);
 		}
 		dev->dfsentry = NULL;
Index: wireless-dev-new/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/debugfs.h	2007-08-14 17:01:07.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/debugfs.h	2007-08-15 19:15:03.000000000 +0200
@@ -92,7 +92,7 @@ static inline
 #endif
 #define TODO()  \
 	do {									\
-		bcminfo(NULL, "TODO: Incomplete code in %s() at %s:%d\n",	\
+		b43info(NULL, "TODO: Incomplete code in %s() at %s:%d\n",	\
 			__FUNCTION__, __FILE__, __LINE__);			\
 	} while (0)
 
@@ -101,7 +101,7 @@ static inline
 #endif
 #define FIXME()  \
 	do {									\
-		bcminfo(NULL, "FIXME: Possibly broken code in %s() at %s:%d\n",	\
+		b43info(NULL, "FIXME: Possibly broken code in %s() at %s:%d\n",	\
 			__FUNCTION__, __FILE__, __LINE__);			\
 	} while (0)
 
Index: wireless-dev-new/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/dma.c	2007-08-15 15:08:39.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/dma.c	2007-08-15 19:15:03.000000000 +0200
@@ -258,7 +258,7 @@ static void update_max_used_slots(struct
 		return;
 	ring->max_used_slots = current_used_slots;
 	if (b43_debug(ring->dev, B43_DBG_DMAVERBOSE)) {
-		bcmdbg(ring->dev->wl,
+		b43dbg(ring->dev->wl,
 		       "max_used_slots increased to %d on %s ring %d\n",
 		       ring->max_used_slots,
 		       ring->tx ? "TX" : "RX", ring->index);
@@ -430,7 +430,7 @@ static int alloc_ringmemory(struct b43_d
 	ring->descbase = dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
 					    &(ring->dmabase), GFP_KERNEL);
 	if (!ring->descbase) {
-		bcmerr(ring->dev->wl, "DMA ringmemory allocation failed\n");
+		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
 	}
 	memset(ring->descbase, 0, B43_DMA_RINGMEMSIZE);
@@ -476,7 +476,7 @@ int b43_dmacontroller_rx_reset(struct b4
 		msleep(1);
 	}
 	if (i != -1) {
-		bcmerr(dev->wl, "DMA RX reset timed out\n");
+		b43err(dev->wl, "DMA RX reset timed out\n");
 		return -ENODEV;
 	}
 
@@ -531,7 +531,7 @@ int b43_dmacontroller_tx_reset(struct b4
 		msleep(1);
 	}
 	if (i != -1) {
-		bcmerr(dev->wl, "DMA TX reset timed out\n");
+		b43err(dev->wl, "DMA TX reset timed out\n");
 		return -ENODEV;
 	}
 	/* ensure the reset is completed. */
@@ -600,7 +600,7 @@ static int alloc_initial_descbuffers(str
 
 		err = setup_rx_descbuffer(ring, desc, meta, GFP_KERNEL);
 		if (err) {
-			bcmerr(ring->dev->wl,
+			b43err(ring->dev->wl,
 			       "Failed to allocate initial descbuffers\n");
 			goto err_unwind;
 		}
@@ -883,7 +883,7 @@ static void b43_destroy_dmaring(struct b
 	if (!ring)
 		return;
 
-	bcmdbg(ring->dev->wl, "DMA-%s 0x%04X (%s) max used slots: %d/%d\n",
+	b43dbg(ring->dev->wl, "DMA-%s 0x%04X (%s) max used slots: %d/%d\n",
 	       (ring->dma64) ? "64" : "32",
 	       ring->mmio_base,
 	       (ring->tx) ? "TX" : "RX", ring->max_used_slots, ring->nr_slots);
@@ -941,12 +941,12 @@ int b43_dma_init(struct b43_wldev *dev)
 	err = ssb_dma_set_mask(dev->dev, dmamask);
 	if (err) {
 #ifdef B43_PIO
-		bcmwarn(dev->wl, "DMA for this device not supported. "
+		b43warn(dev->wl, "DMA for this device not supported. "
 			"Falling back to PIO\n");
 		dev->__using_pio = 1;
 		return -EAGAIN;
 #else
-		bcmerr(dev->wl, "DMA for this device not supported and "
+		b43err(dev->wl, "DMA for this device not supported and "
 		       "no PIO support compiled in\n");
 		return -EOPNOTSUPP;
 #endif
@@ -997,7 +997,7 @@ int b43_dma_init(struct b43_wldev *dev)
 		dma->rx_ring3 = ring;
 	}
 
-	bcmdbg(dev->wl, "%d-bit DMA initialized\n",
+	b43dbg(dev->wl, "%d-bit DMA initialized\n",
 	       (dmamask == DMA_64BIT_MASK) ? 64 :
 	       (dmamask == DMA_32BIT_MASK) ? 32 : 30);
 	err = 0;
@@ -1188,7 +1188,7 @@ static inline int should_inject_overflow
 		next_overflow = ring->last_injected_overflow + HZ;
 		if (time_after(jiffies, next_overflow)) {
 			ring->last_injected_overflow = jiffies;
-			bcmdbg(ring->dev->wl,
+			b43dbg(ring->dev->wl,
 			       "Injecting TX ring overflow on "
 			       "DMA controller %d\n", ring->index);
 			return 1;
@@ -1209,7 +1209,7 @@ int b43_dma_tx(struct b43_wldev *dev,
 	spin_lock_irqsave(&ring->lock, flags);
 	B43_WARN_ON(!ring->tx);
 	if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
-		bcmwarn(dev->wl, "DMA queue overflow\n");
+		b43warn(dev->wl, "DMA queue overflow\n");
 		err = -ENOSPC;
 		goto out_unlock;
 	}
@@ -1220,7 +1220,7 @@ int b43_dma_tx(struct b43_wldev *dev,
 
 	err = dma_tx_fragment(ring, skb, ctl);
 	if (unlikely(err)) {
-		bcmerr(dev->wl, "DMA tx mapping failure\n");
+		b43err(dev->wl, "DMA tx mapping failure\n");
 		goto out_unlock;
 	}
 	ring->nr_tx_packets++;
@@ -1230,7 +1230,7 @@ int b43_dma_tx(struct b43_wldev *dev,
 		ieee80211_stop_queue(dev->wl->hw, txring_to_priority(ring));
 		ring->stopped = 1;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
-			bcmdbg(dev->wl, "Stopped TX ring %d\n", ring->index);
+			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
 		}
 	}
       out_unlock:
@@ -1309,7 +1309,7 @@ void b43_dma_handle_txstatus(struct b43_
 		ieee80211_wake_queue(dev->wl->hw, txring_to_priority(ring));
 		ring->stopped = 0;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
-			bcmdbg(dev->wl, "Woke up TX ring %d\n", ring->index);
+			b43dbg(dev->wl, "Woke up TX ring %d\n", ring->index);
 		}
 	}
 
@@ -1409,7 +1409,7 @@ static void dma_rx(struct b43_dmaring *r
 			if (tmp <= 0)
 				break;
 		}
-		bcmerr(ring->dev->wl, "DMA RX buffer too small "
+		b43err(ring->dev->wl, "DMA RX buffer too small "
 		       "(len: %u, buffer: %u, nr-dropped: %d)\n",
 		       len, ring->rx_buffersize, cnt);
 		goto drop;
@@ -1418,7 +1418,7 @@ static void dma_rx(struct b43_dmaring *r
 	dmaaddr = meta->dmaaddr;
 	err = setup_rx_descbuffer(ring, desc, meta, GFP_ATOMIC);
 	if (unlikely(err)) {
-		bcmdbg(ring->dev->wl, "DMA RX: setup_rx_descbuffer() failed\n");
+		b43dbg(ring->dev->wl, "DMA RX: setup_rx_descbuffer() failed\n");
 		sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
 		goto drop;
 	}
Index: wireless-dev-new/drivers/net/wireless/b43/lo.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/lo.c	2007-08-15 15:08:39.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/lo.c	2007-08-15 19:15:03.000000000 +0200
@@ -44,7 +44,7 @@ static void b43_lo_write(struct b43_wlde
 
 	if (B43_DEBUG) {
 		if (unlikely(abs(control->i) > 16 || abs(control->q) > 16)) {
-			bcmdbg(dev->wl, "Invalid LO control pair "
+			b43dbg(dev->wl, "Invalid LO control pair "
 			       "(I: %d, Q: %d)\n", control->i, control->q);
 			dump_stack();
 			return;
@@ -66,11 +66,11 @@ static int assert_rfatt_and_bbatt(const 
 
 	/* Check the attenuation values against the LO control array sizes. */
 	if (unlikely(rfatt->att >= B43_NR_RF)) {
-		bcmerr(dev->wl, "rfatt(%u) >= size of LO array\n", rfatt->att);
+		b43err(dev->wl, "rfatt(%u) >= size of LO array\n", rfatt->att);
 		err = -EINVAL;
 	}
 	if (unlikely(bbatt->att >= B43_NR_BB)) {
-		bcmerr(dev->wl, "bbatt(%u) >= size of LO array\n", bbatt->att);
+		b43err(dev->wl, "bbatt(%u) >= size of LO array\n", bbatt->att);
 		err = -EINVAL;
 	}
 
@@ -1038,7 +1038,7 @@ static void do_validate_loctl(struct b43
 
 	return;
 error:
-	bcmerr(dev->wl, "LO control pair validation failed "
+	b43err(dev->wl, "LO control pair validation failed "
 	       "(I: %d, Q: %d, used %u, calib: %u, initing: %d)\n",
 	       i, q, control->used,
 	       b43_loctl_is_calibrated(control),
@@ -1103,7 +1103,7 @@ static void validate_loctl_calibration(s
 		 * calibrated the LO. I guess that's OK. */
 		return;
 	}
-	bcmerr(dev->wl, "Adjusting Local Oscillator to an uncalibrated "
+	b43err(dev->wl, "Adjusting Local Oscillator to an uncalibrated "
 	       "control pair: rfatt=%u,%spadmix bbatt=%u\n",
 	       rfatt->att,
 	       (rfatt->with_padmix) ? "" : "no-",
Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-15 15:09:33.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-15 19:15:03.000000000 +0200
@@ -210,7 +210,7 @@ static int b43_ratelimit(struct b43_wl *
 	return net_ratelimit();
 }
 
-void bcminfo(struct b43_wl *wl, const char *fmt, ...)
+void b43info(struct b43_wl *wl, const char *fmt, ...)
 {
 	va_list args;
 
@@ -223,7 +223,7 @@ void bcminfo(struct b43_wl *wl, const ch
 	va_end(args);
 }
 
-void bcmerr(struct b43_wl *wl, const char *fmt, ...)
+void b43err(struct b43_wl *wl, const char *fmt, ...)
 {
 	va_list args;
 
@@ -236,7 +236,7 @@ void bcmerr(struct b43_wl *wl, const cha
 	va_end(args);
 }
 
-void bcmwarn(struct b43_wl *wl, const char *fmt, ...)
+void b43warn(struct b43_wl *wl, const char *fmt, ...)
 {
 	va_list args;
 
@@ -250,7 +250,7 @@ void bcmwarn(struct b43_wl *wl, const ch
 }
 
 #if B43_DEBUG
-void bcmdbg(struct b43_wl *wl, const char *fmt, ...)
+void b43dbg(struct b43_wl *wl, const char *fmt, ...)
 {
 	va_list args;
 
@@ -823,7 +823,7 @@ static int b43_key_write(struct b43_wlde
 			}
 		}
 		if (index < 0) {
-			bcmerr(dev->wl, "Out of hardware key memory\n");
+			b43err(dev->wl, "Out of hardware key memory\n");
 			return -ENOBUFS;
 		}
 	} else
@@ -1219,7 +1219,7 @@ static u8 *b43_generate_probe_resp(struc
 	src_data = (const u8 *)dev->cached_beacon->data;
 
 	if (unlikely(src_size < 0x24)) {
-		bcmdbg(dev->wl, "b43_generate_probe_resp: " "invalid beacon\n");
+		b43dbg(dev->wl, "b43_generate_probe_resp: " "invalid beacon\n");
 		return NULL;
 	}
 
@@ -1403,15 +1403,15 @@ static void b43_interrupt_tasklet(struct
 	}
 
 	if (unlikely(reason & B43_IRQ_MAC_TXERR))
-		bcmerr(dev->wl, "MAC transmission error\n");
+		b43err(dev->wl, "MAC transmission error\n");
 
 	if (unlikely(reason & B43_IRQ_PHY_TXERR))
-		bcmerr(dev->wl, "PHY transmission error\n");
+		b43err(dev->wl, "PHY transmission error\n");
 
 	if (unlikely(merged_dma_reason & (B43_DMAIRQ_FATALMASK |
 					  B43_DMAIRQ_NONFATALMASK))) {
 		if (merged_dma_reason & B43_DMAIRQ_FATALMASK) {
-			bcmerr(dev->wl, "Fatal DMA error: "
+			b43err(dev->wl, "Fatal DMA error: "
 			       "0x%08X, 0x%08X, 0x%08X, "
 			       "0x%08X, 0x%08X, 0x%08X\n",
 			       dma_reason[0], dma_reason[1],
@@ -1423,7 +1423,7 @@ static void b43_interrupt_tasklet(struct
 			return;
 		}
 		if (merged_dma_reason & B43_DMAIRQ_NONFATALMASK) {
-			bcmerr(dev->wl, "DMA error: "
+			b43err(dev->wl, "DMA error: "
 			       "0x%08X, 0x%08X, 0x%08X, "
 			       "0x%08X, 0x%08X, 0x%08X\n",
 			       dma_reason[0], dma_reason[1],
@@ -1584,7 +1584,7 @@ static int b43_request_firmware(struct b
 			 (rev >= 5 ? 5 : rev), modparam_fwpostfix);
 		err = request_firmware(&dev->fw.ucode, buf, dev->dev->dev);
 		if (err) {
-			bcmerr(dev->wl, "Microcode \"%s\" not "
+			b43err(dev->wl, "Microcode \"%s\" not "
 			       "available or load failed.\n", buf);
 			goto error;
 		}
@@ -1596,7 +1596,7 @@ static int b43_request_firmware(struct b
 			 (rev < 5 ? 4 : 5), modparam_fwpostfix);
 		err = request_firmware(&dev->fw.pcm, buf, dev->dev->dev);
 		if (err) {
-			bcmerr(dev->wl, "PCM \"%s\" not available "
+			b43err(dev->wl, "PCM \"%s\" not available "
 			       "or load failed.\n", buf);
 			goto error;
 		}
@@ -1635,12 +1635,12 @@ static int b43_request_firmware(struct b
 
 		err = request_firmware(&dev->fw.initvals0, buf, dev->dev->dev);
 		if (err) {
-			bcmerr(dev->wl, "InitVals \"%s\" not available "
+			b43err(dev->wl, "InitVals \"%s\" not available "
 			       "or load failed.\n", buf);
 			goto error;
 		}
 		if (dev->fw.initvals0->size % sizeof(struct b43_initval)) {
-			bcmerr(dev->wl, "InitVals fileformat error.\n");
+			b43err(dev->wl, "InitVals fileformat error.\n");
 			goto error;
 		}
 	}
@@ -1672,13 +1672,13 @@ static int b43_request_firmware(struct b
 			    request_firmware(&dev->fw.initvals1, buf,
 					     dev->dev->dev);
 			if (err) {
-				bcmerr(dev->wl, "InitVals \"%s\" not available "
+				b43err(dev->wl, "InitVals \"%s\" not available "
 				       "or load failed.\n", buf);
 				goto error;
 			}
 			if (dev->fw.initvals1->size %
 			    sizeof(struct b43_initval)) {
-				bcmerr(dev->wl, "InitVals fileformat error.\n");
+				b43err(dev->wl, "InitVals fileformat error.\n");
 				goto error;
 			}
 		}
@@ -1687,13 +1687,13 @@ static int b43_request_firmware(struct b
       out:
 	return err;
       error:
-	bcmerr(dev->wl, "You must go to "
+	b43err(dev->wl, "You must go to "
 	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
 	       "and download the correct firmware (version 4)\n");
 	b43_release_firmware(dev);
 	goto out;
       err_noinitval:
-	bcmerr(dev->wl, "No InitVals available\n");
+	b43err(dev->wl, "No InitVals available\n");
 	err = -ENOENT;
 	goto error;
 }
@@ -1740,7 +1740,7 @@ static int b43_upload_microcode(struct b
 			break;
 		i++;
 		if (i >= 50) {
-			bcmerr(dev->wl, "Microcode not responding\n");
+			b43err(dev->wl, "Microcode not responding\n");
 			err = -ENODEV;
 			goto out;
 		}
@@ -1755,14 +1755,14 @@ static int b43_upload_microcode(struct b
 	fwtime = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_UCODETIME);
 
 	if (fwrev <= 0x128) {
-		bcmerr(dev->wl, "YOUR FIRMWARE IS TOO OLD. Firmware from "
+		b43err(dev->wl, "YOUR FIRMWARE IS TOO OLD. Firmware from "
 		       "binary drivers older than version 4.x is unsupported. "
 		       "You must upgrade your firmware files.\n");
 		b43_write32(dev, B43_MMIO_MACCTL, 0);
 		err = -EOPNOTSUPP;
 		goto out;
 	}
-	bcmdbg(dev->wl, "Loading firmware version %u.%u "
+	b43dbg(dev->wl, "Loading firmware version %u.%u "
 	       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
 	       fwrev, fwpatch,
 	       (fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
@@ -1803,7 +1803,7 @@ static int b43_write_initvals(struct b43
 	return 0;
 
       err_format:
-	bcmerr(dev->wl, "InitVals (b43_initvalXX.fw) file-format error. "
+	b43err(dev->wl, "InitVals (b43_initvalXX.fw) file-format error. "
 	       "Please fix your b43 firmware files.\n");
 	return -EPROTO;
 }
@@ -1938,7 +1938,7 @@ void b43_mac_suspend(struct b43_wldev *d
 				goto out;
 			udelay(1);
 		}
-		bcmerr(dev->wl, "MAC suspend failed\n");
+		b43err(dev->wl, "MAC suspend failed\n");
 	}
       out:
 	dev->mac_suspended++;
@@ -2118,7 +2118,7 @@ static int b43_chip_init(struct b43_wlde
 		goto err_gpio_cleanup;
 	b43_radio_turn_on(dev);
 	dev->radio_hw_enable = b43_is_hw_radio_enabled(dev);
-	bcmdbg(dev->wl, "Radio %s by hardware\n",
+	b43dbg(dev->wl, "Radio %s by hardware\n",
 	       (dev->radio_hw_enable == 0) ? "disabled" : "enabled");
 
 	b43_write16(dev, 0x03E6, 0x0000);
@@ -2191,7 +2191,7 @@ static int b43_chip_init(struct b43_wlde
 		    dev->dev->bus->chipco.fast_pwrup_delay);
 
 	err = 0;
-	bcmdbg(dev->wl, "Chip initialized\n");
+	b43dbg(dev->wl, "Chip initialized\n");
       out:
 	return err;
 
@@ -2269,7 +2269,7 @@ static void b43_periodic_every1sec(struc
 	radio_hw_enable = b43_is_hw_radio_enabled(dev);
 	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
 		dev->radio_hw_enable = radio_hw_enable;
-		bcmdbg(dev->wl, "Radio hardware status changed to %s\n",
+		b43dbg(dev->wl, "Radio hardware status changed to %s\n",
 		       (radio_hw_enable == 0) ? "disabled" : "enabled");
 		b43_leds_update(dev, 0);
 	}
@@ -2406,7 +2406,7 @@ static int b43_validate_chipaccess(struc
 
 	return 0;
       error:
-	bcmerr(dev->wl, "Failed to validate the chipaccess\n");
+	b43err(dev->wl, "Failed to validate the chipaccess\n");
 	return -ENODEV;
 }
 
@@ -2461,7 +2461,7 @@ static int b43_rng_init(struct b43_wl *w
 	err = hwrng_register(&wl->rng);
 	if (err) {
 		wl->rng_initialized = 0;
-		bcmerr(wl, "Failed to register the random "
+		b43err(wl, "Failed to register the random "
 		       "number generator (%d)\n", err);
 	}
 
@@ -2622,7 +2622,7 @@ static int b43_switch_phymode(struct b43
 
 	err = find_wldev_for_phymode(wl, new_mode, &up_dev, &gmode);
 	if (err) {
-		bcmerr(wl, "Could not find a device for %s-PHY mode\n",
+		b43err(wl, "Could not find a device for %s-PHY mode\n",
 		       phymode_to_string(new_mode));
 		return err;
 	}
@@ -2631,7 +2631,7 @@ static int b43_switch_phymode(struct b43
 		/* This device is already running. */
 		return 0;
 	}
-	bcmdbg(wl, "Reconfiguring PHYmode to %s-PHY\n",
+	b43dbg(wl, "Reconfiguring PHYmode to %s-PHY\n",
 	       phymode_to_string(new_mode));
 	down_dev = wl->current_dev;
 
@@ -2653,7 +2653,7 @@ static int b43_switch_phymode(struct b43
 	if (prev_status >= B43_STAT_INITIALIZED) {
 		err = b43_wireless_core_init(up_dev);
 		if (err) {
-			bcmerr(wl, "Fatal: Could not initialize device for "
+			b43err(wl, "Fatal: Could not initialize device for "
 			       "newly selected %s-PHY mode\n",
 			       phymode_to_string(new_mode));
 			goto init_failure;
@@ -2662,7 +2662,7 @@ static int b43_switch_phymode(struct b43
 	if (prev_status >= B43_STAT_STARTED) {
 		err = b43_wireless_core_start(up_dev);
 		if (err) {
-			bcmerr(wl, "Fatal: Coult not start device for "
+			b43err(wl, "Fatal: Coult not start device for "
 			       "newly selected %s-PHY mode\n",
 			       phymode_to_string(new_mode));
 			b43_wireless_core_exit(up_dev);
@@ -2902,7 +2902,7 @@ out_unlock:
 	mutex_unlock(&wl->mutex);
 out:
 	if (!err) {
-		bcmdbg(wl, "Using %s based encryption for keyidx: %d, "
+		b43dbg(wl, "Using %s based encryption for keyidx: %d, "
 		       "mac: " MAC_FMT "\n",
 		       (key->flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) ?
 		       "software" : "hardware", key->keyidx, MAC_ARG(addr));
@@ -2985,7 +2985,7 @@ static void b43_wireless_core_stop(struc
 
 	b43_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
-	bcmdbg(wl, "Wireless interface stopped\n");
+	b43dbg(wl, "Wireless interface stopped\n");
 }
 
 /* Locking: wl->mutex */
@@ -2999,7 +2999,7 @@ static int b43_wireless_core_start(struc
 	err = request_irq(dev->dev->irq, b43_interrupt_handler,
 			  IRQF_SHARED, KBUILD_MODNAME, dev);
 	if (err) {
-		bcmerr(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
+		b43err(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
 		goto out;
 	}
 
@@ -3014,7 +3014,7 @@ static int b43_wireless_core_start(struc
 	/* Start maintainance work */
 	b43_periodic_tasks_setup(dev);
 
-	bcmdbg(dev->wl, "Wireless interface started\n");
+	b43dbg(dev->wl, "Wireless interface started\n");
       out:
 	return err;
 }
@@ -3055,12 +3055,12 @@ static int b43_phy_versioning(struct b43
 		unsupported = 1;
 	};
 	if (unsupported) {
-		bcmerr(dev->wl, "FOUND UNSUPPORTED PHY "
+		b43err(dev->wl, "FOUND UNSUPPORTED PHY "
 		       "(Analog %u, Type %u, Revision %u)\n",
 		       analog_type, phy_type, phy_rev);
 		return -EOPNOTSUPP;
 	}
-	bcmdbg(dev->wl, "Found PHY: Analog %u, Type %u, Revision %u\n",
+	b43dbg(dev->wl, "Found PHY: Analog %u, Type %u, Revision %u\n",
 	       analog_type, phy_type, phy_rev);
 
 	/* Get RADIO versioning */
@@ -3102,12 +3102,12 @@ static int b43_phy_versioning(struct b43
 		B43_WARN_ON(1);
 	}
 	if (unsupported) {
-		bcmerr(dev->wl, "FOUND UNSUPPORTED RADIO "
+		b43err(dev->wl, "FOUND UNSUPPORTED RADIO "
 		       "(Manuf 0x%X, Version 0x%X, Revision %u)\n",
 		       radio_manuf, radio_ver, radio_rev);
 		return -EOPNOTSUPP;
 	}
-	bcmdbg(dev->wl, "Found Radio: Manuf 0x%X, Version 0x%X, Revision %u\n",
+	b43dbg(dev->wl, "Found Radio: Manuf 0x%X, Version 0x%X, Revision %u\n",
 	       radio_manuf, radio_ver, radio_rev);
 
 	phy->radio_manuf = radio_manuf;
@@ -3406,7 +3406,7 @@ static int b43_add_interface(struct ieee
 	if ((conf->type != IEEE80211_IF_TYPE_MNTR) && wl->operating)
 		goto out_mutex_unlock;
 
-	bcmdbg(wl, "Adding Interface type %d\n", conf->type);
+	b43dbg(wl, "Adding Interface type %d\n", conf->type);
 
 	dev = wl->current_dev;
 	if (b43_status(dev) < B43_STAT_INITIALIZED) {
@@ -3452,7 +3452,7 @@ static void b43_remove_interface(struct 
 	struct b43_wldev *dev;
 	unsigned long flags;
 
-	bcmdbg(wl, "Removing Interface type %d\n", conf->type);
+	b43dbg(wl, "Removing Interface type %d\n", conf->type);
 
 	mutex_lock(&wl->mutex);
 	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
@@ -3530,9 +3530,9 @@ static void b43_chip_reset(struct work_s
       out:
 	mutex_unlock(&wl->mutex);
 	if (err)
-		bcmerr(wl, "Controller restart FAILED\n");
+		b43err(wl, "Controller restart FAILED\n");
 	else
-		bcminfo(wl, "Controller restarted\n");
+		b43info(wl, "Controller restarted\n");
 }
 
 static int b43_setup_modes(struct b43_wldev *dev,
@@ -3631,7 +3631,7 @@ static int b43_wireless_core_attach(stru
 
 	err = ssb_bus_powerup(bus, 0);
 	if (err) {
-		bcmerr(wl, "Bus powerup failed\n");
+		b43err(wl, "Bus powerup failed\n");
 		goto out;
 	}
 	/* Get the PHY type. */
@@ -3746,7 +3746,7 @@ static int b43_one_core_attach(struct ss
 		if (!pdev ||
 		    ((pdev->device != 0x4321) &&
 		     (pdev->device != 0x4313) && (pdev->device != 0x431A))) {
-			bcmdbg(wl, "Ignoring unconnected 802.11 core\n");
+			b43dbg(wl, "Ignoring unconnected 802.11 core\n");
 			return -ENODEV;
 		}
 	}
@@ -3823,7 +3823,7 @@ static int b43_wireless_init(struct ssb_
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &b43_hw_ops);
 	if (!hw) {
-		bcmerr(NULL, "Could not allocate ieee80211 device\n");
+		b43err(NULL, "Could not allocate ieee80211 device\n");
 		goto out;
 	}
 
@@ -3851,7 +3851,7 @@ static int b43_wireless_init(struct ssb_
 	INIT_LIST_HEAD(&wl->devlist);
 
 	ssb_set_devtypedata(dev, wl);
-	bcminfo(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
+	b43info(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
 	err = 0;
       out:
 	return err;
@@ -3916,7 +3916,7 @@ static void b43_remove(struct ssb_device
 /* Perform a hardware reset. This can be called from any context. */
 void b43_controller_restart(struct b43_wldev *dev, const char *reason)
 {
-	bcminfo(dev->wl, "Controller RESET (%s) ...\n", reason);
+	b43info(dev->wl, "Controller RESET (%s) ...\n", reason);
 	queue_work(dev->wl->hw->workqueue, &dev->restart_work);
 }
 
@@ -3927,7 +3927,7 @@ static int b43_suspend(struct ssb_device
 	struct b43_wldev *wldev = ssb_get_drvdata(dev);
 	struct b43_wl *wl = wldev->wl;
 
-	bcmdbg(wl, "Suspending...\n");
+	b43dbg(wl, "Suspending...\n");
 
 	mutex_lock(&wl->mutex);
 	wldev->suspend_init_status = b43_status(wldev);
@@ -3937,7 +3937,7 @@ static int b43_suspend(struct ssb_device
 		b43_wireless_core_exit(wldev);
 	mutex_unlock(&wl->mutex);
 
-	bcmdbg(wl, "Device suspended.\n");
+	b43dbg(wl, "Device suspended.\n");
 
 	return 0;
 }
@@ -3948,13 +3948,13 @@ static int b43_resume(struct ssb_device 
 	struct b43_wl *wl = wldev->wl;
 	int err = 0;
 
-	bcmdbg(wl, "Resuming...\n");
+	b43dbg(wl, "Resuming...\n");
 
 	mutex_lock(&wl->mutex);
 	if (wldev->suspend_init_status >= B43_STAT_INITIALIZED) {
 		err = b43_wireless_core_init(wldev);
 		if (err) {
-			bcmerr(wl, "Resume failed at core init\n");
+			b43err(wl, "Resume failed at core init\n");
 			goto out;
 		}
 	}
@@ -3962,13 +3962,13 @@ static int b43_resume(struct ssb_device 
 		err = b43_wireless_core_start(wldev);
 		if (err) {
 			b43_wireless_core_exit(wldev);
-			bcmerr(wl, "Resume failed at core start\n");
+			b43err(wl, "Resume failed at core start\n");
 			goto out;
 		}
 	}
 	mutex_unlock(&wl->mutex);
 
-	bcmdbg(wl, "Device resumed.\n");
+	b43dbg(wl, "Device resumed.\n");
       out:
 	return err;
 }
Index: wireless-dev-new/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/phy.c	2007-08-14 17:01:07.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/phy.c	2007-08-15 19:15:03.000000000 +0200
@@ -275,7 +275,7 @@ static inline u16 adjust_phyreg_for_phyt
 	if (offset & B43_PHYROUTE_EXT_GPHY) {
 		/* Ext-G registers are only available on G-PHYs */
 		if (phy->type != B43_PHYTYPE_G) {
-			bcmdbg(dev->wl, "EXT-G PHY access at "
+			b43dbg(dev->wl, "EXT-G PHY access at "
 			       "0x%04X on %u type PHY\n", offset, phy->type);
 		}
 	}
@@ -327,7 +327,7 @@ void b43_set_txpower_g(struct b43_wldev 
 	memcpy(&phy->bbatt, bbatt, sizeof(*bbatt));
 
 	if (b43_debug(dev, B43_DBG_XMITPOWER)) {
-		bcmdbg(dev->wl, "Tuning TX-power to bbatt(%u), "
+		b43dbg(dev->wl, "Tuning TX-power to bbatt(%u), "
 		       "rfatt(%u), tx_control(0x%02X), "
 		       "tx_bias(0x%02X), tx_magn(0x%02X)\n",
 		       bb, rf, tx_control, tx_bias, tx_magn);
@@ -741,7 +741,7 @@ static void b43_phy_init_pctl(struct b43
 		if (B43_DEBUG) {
 			/* Current-Idle-TSSI sanity check. */
 			if (abs(phy->cur_idle_tssi - phy->tgt_idle_tssi) >= 20) {
-				bcmdbg(dev->wl,
+				b43dbg(dev->wl,
 				       "!WARNING! Idle-TSSI phy->cur_idle_tssi "
 				       "measuring failed. (cur=%d, tgt=%d). Disabling TX power "
 				       "adjustment.\n", phy->cur_idle_tssi,
@@ -2047,7 +2047,7 @@ void b43_phy_xmitpower(struct b43_wldev 
 			    && (phy->type == B43_PHYTYPE_G))
 				max_pwr -= 0x3;
 			if (unlikely(max_pwr <= 0)) {
-				bcmwarn(dev->wl,
+				b43warn(dev->wl,
 					"Invalid max-TX-power value in SPROM.\n");
 				max_pwr = 60;	/* fake it */
 				dev->dev->bus->sprom.r1.maxpwr_bg = max_pwr;
@@ -2063,7 +2063,7 @@ void b43_phy_xmitpower(struct b43_wldev 
 			/* And limit it. max_pwr already is Q5.2 */
 			desired_pwr = limit_value(desired_pwr, 0, max_pwr);
 			if (b43_debug(dev, B43_DBG_XMITPOWER)) {
-				bcmdbg(dev->wl,
+				b43dbg(dev->wl,
 				       "Current TX power output: " Q52_FMT
 				       " dBm, " "Desired TX power output: "
 				       Q52_FMT " dBm\n", Q52_ARG(estimated_pwr),
@@ -2219,7 +2219,7 @@ int b43_phy_init_tssi2dbm_table(struct b
 		}
 		dyn_tssi2dbm = kmalloc(64, GFP_KERNEL);
 		if (dyn_tssi2dbm == NULL) {
-			bcmerr(dev->wl, "Could not allocate memory"
+			b43err(dev->wl, "Could not allocate memory"
 			       "for tssi2dbm table\n");
 			return -ENOMEM;
 		}
@@ -2227,7 +2227,7 @@ int b43_phy_init_tssi2dbm_table(struct b
 			if (b43_tssi2dbm_entry
 			    (dyn_tssi2dbm, idx, pab0, pab1, pab2)) {
 				phy->tssi2dbm = NULL;
-				bcmerr(dev->wl, "Could not generate "
+				b43err(dev->wl, "Could not generate "
 				       "tssi2dBm table\n");
 				kfree(dyn_tssi2dbm);
 				return -ENODEV;
@@ -2240,7 +2240,7 @@ int b43_phy_init_tssi2dbm_table(struct b
 		case B43_PHYTYPE_A:
 			/* APHY needs a generated table. */
 			phy->tssi2dbm = NULL;
-			bcmerr(dev->wl, "Could not generate tssi2dBm "
+			b43err(dev->wl, "Could not generate tssi2dBm "
 			       "table (wrong SPROM info)!\n");
 			return -ENODEV;
 		case B43_PHYTYPE_B:
@@ -2295,7 +2295,7 @@ int b43_phy_init(struct b43_wldev *dev)
 		break;
 	}
 	if (err)
-		bcmerr(dev->wl, "Unknown PHYTYPE found\n");
+		b43err(dev->wl, "Unknown PHYTYPE found\n");
 
 	return err;
 }
@@ -4329,7 +4329,7 @@ void b43_radio_turn_on(struct b43_wldev 
 		B43_WARN_ON(1);
 	}
 	phy->radio_on = 1;
-	bcmdbg(dev->wl, "Radio turned on\n");
+	b43dbg(dev->wl, "Radio turned on\n");
 }
 
 void b43_radio_turn_off(struct b43_wldev *dev)
@@ -4348,5 +4348,5 @@ void b43_radio_turn_off(struct b43_wldev
 	} else
 		b43_phy_write(dev, 0x0015, 0xAA00);
 	phy->radio_on = 0;
-	bcmdbg(dev->wl, "Radio turned off\n");
+	b43dbg(dev->wl, "Radio turned off\n");
 }
Index: wireless-dev-new/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/pio.c	2007-08-15 15:08:39.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/pio.c	2007-08-15 19:15:03.000000000 +0200
@@ -210,7 +210,7 @@ static int pio_tx_packet(struct b43_pio_
 
 	octets = (u16) skb->len + sizeof(struct b43_txhdr_fw4);
 	if (queue->tx_devq_size < octets) {
-		bcmwarn(queue->dev->wl, "PIO queue too small. "
+		b43warn(queue->dev->wl, "PIO queue too small. "
 			"Dropping packet.\n");
 		/* Drop it silently (return success) */
 		free_txpacket(packet);
@@ -316,13 +316,13 @@ struct b43_pioqueue *b43_setup_pioqueue(
 
 	qsize = b43_read16(dev, queue->mmio_base + B43_PIO_TXQBUFSIZE);
 	if (qsize == 0) {
-		bcmerr(dev->wl, "This card does not support PIO "
+		b43err(dev->wl, "This card does not support PIO "
 		       "operation mode. Please use DMA mode "
 		       "(module parameter pio=0).\n");
 		goto err_freequeue;
 	}
 	if (qsize <= B43_PIO_TXQADJUST) {
-		bcmerr(dev->wl, "PIO tx device-queue too small (%u)\n", qsize);
+		b43err(dev->wl, "PIO tx device-queue too small (%u)\n", qsize);
 		goto err_freequeue;
 	}
 	qsize -= B43_PIO_TXQADJUST;
@@ -407,7 +407,7 @@ int b43_pio_init(struct b43_wldev *dev)
 	if (dev->dev->id.revision < 3)
 		dev->irq_savedstate |= B43_IRQ_PIO_WORKAROUND;
 
-	bcmdbg(dev->wl, "PIO initialized\n");
+	b43dbg(dev->wl, "PIO initialized\n");
 	err = 0;
       out:
 	return err;
@@ -505,7 +505,7 @@ static void pio_rx_error(struct b43_pioq
 {
 	int i;
 
-	bcmerr(queue->dev->wl, "PIO RX error: %s\n", error);
+	b43err(queue->dev->wl, "PIO RX error: %s\n", error);
 	b43_pio_write(queue, B43_PIO_RXCTL, B43_PIO_RXCTL_READY);
 	if (clear_buffers) {
 		B43_WARN_ON(queue->mmio_base != B43_MMIO_PIO1_BASE);
@@ -535,7 +535,7 @@ void b43_pio_rx(struct b43_pioqueue *que
 			goto data_ready;
 		udelay(10);
 	}
-	bcmdbg(queue->dev->wl, "PIO RX timed out\n");
+	b43dbg(queue->dev->wl, "PIO RX timed out\n");
 	return;
       data_ready:
 
Index: wireless-dev-new/drivers/net/wireless/b43/sysfs.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/sysfs.c	2007-08-14 17:01:07.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/sysfs.c	2007-08-15 19:15:03.000000000 +0200
@@ -141,7 +141,7 @@ static ssize_t b43_attr_interfmode_store
 
 	err = b43_radio_set_interference_mitigation(wldev, mode);
 	if (err) {
-		bcmerr(wldev->wl, "Interference Mitigation not "
+		b43err(wldev->wl, "Interference Mitigation not "
 		       "supported by device\n");
 	}
 	mmiowb();
Index: wireless-dev-new/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/xmit.c	2007-08-14 17:01:07.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/xmit.c	2007-08-15 19:15:03.000000000 +0200
@@ -472,14 +472,14 @@ void b43_rx(struct b43_wldev *dev, struc
 	/* Skip PLCP and padding */
 	padding = (macstat & B43_RX_MAC_PADDING) ? 2 : 0;
 	if (unlikely(skb->len < (sizeof(struct b43_plcp_hdr6) + padding))) {
-		bcmdbg(dev->wl, "RX: Packet size underrun (1)\n");
+		b43dbg(dev->wl, "RX: Packet size underrun (1)\n");
 		goto drop;
 	}
 	plcp = (struct b43_plcp_hdr6 *)(skb->data + padding);
 	skb_pull(skb, sizeof(struct b43_plcp_hdr6) + padding);
 	/* The skb contains the Wireless Header + payload data now */
 	if (unlikely(skb->len < (2 + 2 + 6 /*minimum hdr */  + FCS_LEN))) {
-		bcmdbg(dev->wl, "RX: Packet size underrun (2)\n");
+		b43dbg(dev->wl, "RX: Packet size underrun (2)\n");
 		goto drop;
 	}
 	wlhdr = (struct ieee80211_hdr *)(skb->data);
@@ -508,7 +508,7 @@ void b43_rx(struct b43_wldev *dev, struc
 
 			wlhdr_len = ieee80211_get_hdrlen(fctl);
 			if (unlikely(skb->len < (wlhdr_len + 3))) {
-				bcmdbg(dev->wl,
+				b43dbg(dev->wl,
 				       "RX: Packet size underrun (3)\n");
 				goto drop;
 			}
@@ -523,7 +523,7 @@ void b43_rx(struct b43_wldev *dev, struc
 				icv_len = 4;
 			}
 			if (unlikely(skb->len < (wlhdr_len + iv_len + icv_len))) {
-				bcmdbg(dev->wl,
+				b43dbg(dev->wl,
 				       "RX: Packet size underrun (4)\n");
 				goto drop;
 			}
@@ -577,7 +577,7 @@ void b43_rx(struct b43_wldev *dev, struc
 
 	return;
       drop:
-	bcmdbg(dev->wl, "RX: Packet dropped\n");
+	b43dbg(dev->wl, "RX: Packet dropped\n");
 	dev_kfree_skb_any(skb);
 }
 

-- 

