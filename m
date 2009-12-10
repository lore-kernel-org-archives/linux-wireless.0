Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760969AbZLJQ1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 11:27:52 -0500
Date: Thu, 10 Dec 2009 10:27:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC/RFT] b43: Allow PIO mode to be selected at module load
Message-ID: <4b21218d.wt8w3J8GbcDHhv31%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a user encounters the "Fatal DMA Problem" with a BCM43XX device, and
still wishes to use b43 as the driver, their only option is to rebuild
the kernel with CONFIG_B43_FORCE_PIO. This patch removes this option and
allows PIO mode to be selected with a load-time option for the module.

Once the DMA problem with the BCM4312 devices is solved, this patch will
likely be reverted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-testing/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig
+++ wireless-testing/drivers/net/wireless/b43/Kconfig
@@ -79,10 +79,11 @@ config B43_SDIO
 	  If unsure, say N.
 
 # Data transfers to the device via PIO
-# This is only needed on PCMCIA and SDIO devices. All others can do DMA properly.
+# Technically, this is only needed on PCMCIA and SDIO devices; but some LP PHYs
+# cannot do DMA properly.
 config B43_PIO
 	bool
-	depends on B43 && (B43_SDIO || B43_PCMCIA || B43_FORCE_PIO)
+	depends on B43
 	select SSB_BLOCKIO
 	default y
 
@@ -137,12 +138,4 @@ config B43_DEBUG
 	  for production use.
 	  Only say Y, if you are debugging a problem in the b43 driver sourcecode.
 
-config B43_FORCE_PIO
-	bool "Force usage of PIO instead of DMA"
-	depends on B43 && B43_DEBUG
-	---help---
-	  This will disable DMA and always enable PIO instead.
 
-	  Say N!
-	  This is only for debugging the PIO engine code. You do
-	  _NOT_ want to enable this.
Index: wireless-testing/drivers/net/wireless/b43/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Makefile
+++ wireless-testing/drivers/net/wireless/b43/Makefile
@@ -12,7 +12,7 @@ b43-y				+= xmit.o
 b43-y				+= lo.o
 b43-y				+= wa.o
 b43-y				+= dma.o
-b43-$(CONFIG_B43_PIO)		+= pio.o
+b43-y				+= pio.o
 b43-y				+= rfkill.o
 b43-$(CONFIG_B43_LEDS)		+= leds.o
 b43-$(CONFIG_B43_PCMCIA)	+= pcmcia.o
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h
+++ wireless-testing/drivers/net/wireless/b43/b43.h
@@ -821,11 +821,9 @@ struct b43_wl {
 	/* The device LEDs. */
 	struct b43_leds leds;
 
-#ifdef CONFIG_B43_PIO
 	/* Kmalloc'ed scratch space for PIO TX/RX. Protected by wl->mutex. */
 	u8 pio_scratchspace[110] __attribute__((__aligned__(8)));
 	u8 pio_tailspace[4] __attribute__((__aligned__(8)));
-#endif /* CONFIG_B43_PIO */
 };
 
 static inline struct b43_wl *hw_to_b43_wl(struct ieee80211_hw *hw)
@@ -876,20 +874,9 @@ static inline void b43_write32(struct b4
 
 static inline bool b43_using_pio_transfers(struct b43_wldev *dev)
 {
-#ifdef CONFIG_B43_PIO
 	return dev->__using_pio_transfers;
-#else
-	return 0;
-#endif
 }
 
-#ifdef CONFIG_B43_FORCE_PIO
-# define B43_FORCE_PIO	1
-#else
-# define B43_FORCE_PIO	0
-#endif
-
-
 /* Message printing */
 void b43info(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -102,6 +102,9 @@ int b43_modparam_verbose = B43_VERBOSITY
 module_param_named(verbose, b43_modparam_verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "Log message verbosity: 0=error, 1=warn, 2=info(default), 3=debug");
 
+static int modparam_pio;
+module_param_named(pio, modparam_pio, int, 0444);
+MODULE_PARM_DESC(pio, "enable(1) / disable(0) PIO mode");
 
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
@@ -1786,8 +1789,8 @@ static void b43_do_interrupt_thread(stru
 			       dma_reason[4], dma_reason[5]);
 			b43err(dev->wl, "This device does not support DMA "
 			       "on your system. Please use PIO instead.\n");
-			b43err(dev->wl, "CONFIG_B43_FORCE_PIO must be set in "
-			       "your kernel configuration.\n");
+			b43err(dev->wl, "Unload the b43 module and reload "
+			       "with 'pio=1'\n");
 			return;
 		}
 		if (merged_dma_reason & B43_DMAIRQ_NONFATALMASK) {
@@ -4353,11 +4356,9 @@ static int b43_wireless_core_init(struct
 
 	if ((dev->dev->bus->bustype == SSB_BUSTYPE_PCMCIA) ||
 	    (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) ||
-	    B43_FORCE_PIO) {
-		dev->__using_pio_transfers = 1;
+	    dev->__using_pio_transfers) {
 		err = b43_pio_init(dev);
 	} else {
-		dev->__using_pio_transfers = 0;
 		err = b43_dma_init(dev);
 	}
 	if (err)
@@ -4827,6 +4828,8 @@ static int b43_one_core_attach(struct ss
 	wldev->wl = wl;
 	b43_set_status(wldev, B43_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
+	if (modparam_pio)
+		wldev->__using_pio_transfers = 1;
 	INIT_LIST_HEAD(&wldev->list);
 
 	err = b43_wireless_core_attach(wldev);
