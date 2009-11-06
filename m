Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42409 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbZKFTI0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 14:08:26 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Martin Fuzzey <mfuzzey@gmail.com>
Subject: Re: b43: firmware loading problem and sleeping BUG
Date: Fri, 6 Nov 2009 20:08:04 +0100
Cc: linux-wireless@vger.kernel.org
References: <ba4215e10911060819y1175e003g695281fe084e07ab@mail.gmail.com> <200911061822.17121.mb@bu3sch.de> <ba4215e10911061027t413d2c34g8ad66a7982f7c43c@mail.gmail.com>
In-Reply-To: <ba4215e10911061027t413d2c34g8ad66a7982f7c43c@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200911062008.06159.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 November 2009 19:27:17 Martin Fuzzey wrote:
> > I think this is easy to fix, because we can replace the spinlock by a mutex, as
> > the b43 driver (which is the only user of the code) always allows sleeping now.
> > I'll send a patch for testing soon.
> >
> Great - happy to test it.

There you go. Note that I did not test it, as trying to use my pcmcia card throws
a hell of a lot oopses at me and the firmware finally force-resets the hardware
for some reason. This needs some debugging first...


Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2009-10-09 19:50:16.000000000 +0200
+++ wireless-testing/drivers/ssb/main.c	2009-11-06 19:47:18.000000000 +0100
@@ -740,7 +740,7 @@ static int ssb_bus_register(struct ssb_b
 {
 	int err;
 
-	spin_lock_init(&bus->bar_lock);
+	mutex_init(&bus->register_mutex);
 	INIT_LIST_HEAD(&bus->list);
 #ifdef CONFIG_SSB_EMBEDDED
 	spin_lock_init(&bus->gpio_lock);
Index: wireless-testing/drivers/ssb/pcmcia.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pcmcia.c	2009-07-28 22:53:08.000000000 +0200
+++ wireless-testing/drivers/ssb/pcmcia.c	2009-11-06 19:35:59.000000000 +0100
@@ -238,15 +238,14 @@ static int select_core_and_segment(struc
 static u8 ssb_pcmcia_read8(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
-	unsigned long flags;
 	int err;
 	u8 value = 0xFF;
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
+	mutex_lock(&bus->register_mutex);
 	err = select_core_and_segment(dev, &offset);
 	if (likely(!err))
 		value = readb(bus->mmio + offset);
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
+	mutex_unlock(&bus->register_mutex);
 
 	return value;
 }
@@ -254,15 +253,14 @@ static u8 ssb_pcmcia_read8(struct ssb_de
 static u16 ssb_pcmcia_read16(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
-	unsigned long flags;
 	int err;
 	u16 value = 0xFFFF;
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
+	mutex_lock(&bus->register_mutex);
 	err = select_core_and_segment(dev, &offset);
 	if (likely(!err))
 		value = readw(bus->mmio + offset);
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
+	mutex_unlock(&bus->register_mutex);
 
 	return value;
 }
@@ -270,17 +268,16 @@ static u16 ssb_pcmcia_read16(struct ssb_
 static u32 ssb_pcmcia_read32(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
-	unsigned long flags;
 	int err;
 	u32 lo = 0xFFFFFFFF, hi = 0xFFFFFFFF;
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
+	mutex_lock(&bus->register_mutex);
 	err = select_core_and_segment(dev, &offset);
 	if (likely(!err)) {
 		lo = readw(bus->mmio + offset);
 		hi = readw(bus->mmio + offset + 2);
 	}
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
+	mutex_unlock(&bus->register_mutex);
 
 	return (lo | (hi << 16));
 }
@@ -290,11 +287,10 @@ static void ssb_pcmcia_block_read(struct
 				  size_t count, u16 offset, u8 reg_width)
 {
 	struct ssb_bus *bus = dev->bus;
-	unsigned long flags;
 	void __iomem *addr = bus->mmio + offset;
 	int err;
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
+	mutex_lock(&bus->register_mutex);
 	err = select_core_and_segment(dev, &offset);
 	if (unlikely(err)) {
 		memset(buffer, 0xFF, count);
@@ -339,52 +335,49 @@ static void ssb_pcmcia_block_read(struct
 		SSB_WARN_ON(1);
 	}
 unlock:
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
+	mutex_unlock(&bus->register_mutex);
 }
 #endif /* CONFIG_SSB_BLOCKIO */
 
 static void ssb_pcmcia_write8(struct ssb_device *dev, u16 offset, u8 value)
 {
 	struct ssb_bus *bus = dev->bus;
-	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
+	mutex_lock(&bus->register_mutex);
 	err = select_core_and_segment(dev, &offset);
 	if (likely(!err))
 		writeb(value, bus->mmio + offset);
 	mmiowb();
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
+	mutex_unlock(&bus->register_mutex);
 }
 
 static void ssb_pcmcia_write16(struct ssb_device *dev, u16 offset, u16 value)
 {
 	struct ssb_bus *bus = dev->bus;
-	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
+	mutex_lock(&bus->register_mutex);
 	err = select_core_and_segment(dev, &offset);
 	if (likely(!err))
 		writew(value, bus->mmio + offset);
 	mmiowb();
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
+	mutex_unlock(&bus->register_mutex);
 }
 
 static void ssb_pcmcia_write32(struct ssb_device *dev, u16 offset, u32 value)
 {
 	struct ssb_bus *bus = dev->bus;
-	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
+	mutex_lock(&bus->register_mutex);
 	err = select_core_and_segment(dev, &offset);
 	if (likely(!err)) {
 		writew((value & 0x0000FFFF), bus->mmio + offset);
 		writew(((value & 0xFFFF0000) >> 16), bus->mmio + offset + 2);
 	}
 	mmiowb();
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
+	mutex_unlock(&bus->register_mutex);
 }
 
 #ifdef CONFIG_SSB_BLOCKIO
@@ -392,11 +385,10 @@ static void ssb_pcmcia_block_write(struc
 				   size_t count, u16 offset, u8 reg_width)
 {
 	struct ssb_bus *bus = dev->bus;
-	unsigned long flags;
 	void __iomem *addr = bus->mmio + offset;
 	int err;
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
+	mutex_lock(&bus->register_mutex);
 	err = select_core_and_segment(dev, &offset);
 	if (unlikely(err))
 		goto unlock;
@@ -440,7 +432,7 @@ static void ssb_pcmcia_block_write(struc
 	}
 unlock:
 	mmiowb();
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
+	mutex_unlock(&bus->register_mutex);
 }
 #endif /* CONFIG_SSB_BLOCKIO */
 
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2009-11-01 13:58:49.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb.h	2009-11-06 19:32:32.000000000 +0100
@@ -278,9 +278,8 @@ struct ssb_bus {
 		/* Current SSB base address window for SDIO. */
 		u32 sdio_sbaddr;
 	};
-	/* Lock for core and segment switching.
-	 * On PCMCIA-host busses this is used to protect the whole MMIO access. */
-	spinlock_t bar_lock;
+	/* Mutex to enforce one hardware register read/write is an atomic operation. */
+	struct mutex register_mutex;
 
 	/* The host-bus this backplane is running on. */
 	enum ssb_bustype bustype;
Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c	2009-10-09 19:50:16.000000000 +0200
+++ wireless-testing/drivers/ssb/pci.c	2009-11-06 20:04:11.000000000 +0100
@@ -63,7 +63,6 @@ int ssb_pci_switch_core(struct ssb_bus *
 			struct ssb_device *dev)
 {
 	int err;
-	unsigned long flags;
 
 #if SSB_VERBOSE_PCICORESWITCH_DEBUG
 	ssb_printk(KERN_INFO PFX
@@ -72,11 +71,9 @@ int ssb_pci_switch_core(struct ssb_bus *
 		   dev->core_index);
 #endif
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
 	err = ssb_pci_switch_coreidx(bus, dev->core_index);
 	if (!err)
 		bus->mapped_device = dev;
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
 
 	return err;
 }


-- 
Greetings, Michael.
