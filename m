Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:37856 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751998AbYAWN7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 08:59:16 -0500
Date: Wed, 23 Jan 2008 14:48:50 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: b43legacy: fix MAC control and microcode init
Message-ID: <20080123144850.19a0545b@morte> (sfid-20080123_135919_083898_DFAC910E)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This zeros out all microcode related memory before loading
the microcode.

This also fixes initialization of the MAC control register.
The _only_ place where we overwrite the contents of the MAC control
register is at the beginning of b43_chip_init().
All other places must do read() -> mask/set -> write() to not
overwrite existing bits.

This also adds a longer delay for waiting for the microcode
to initialize itself. It seems that the current timeout is sufficient
on all available devices, but there's no real reason why we shouldn't
wait for up to one second. Slow embedded devices might exist.
Better safe than sorry.

While at it, fix naming of MACCTL values.

This patch by Michael Buesch has been ported to b43legacy.

Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
John, this bugfix should go into 2.6.24, if possible.

Index: wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
@@ -23,7 +23,7 @@
 #include "phy.h"
 
 
-#define B43legacy_IRQWAIT_MAX_RETRIES	100
+#define B43legacy_IRQWAIT_MAX_RETRIES	20
 
 #define B43legacy_RX_MAX_SSI		60 /* best guess at max ssi */
 
@@ -40,9 +40,8 @@
 #define B43legacy_MMIO_DMA4_IRQ_MASK	0x44
 #define B43legacy_MMIO_DMA5_REASON	0x48
 #define B43legacy_MMIO_DMA5_IRQ_MASK	0x4C
-#define B43legacy_MMIO_MACCTL		0x120
-#define B43legacy_MMIO_STATUS_BITFIELD	0x120
-#define B43legacy_MMIO_STATUS2_BITFIELD	0x124
+#define B43legacy_MMIO_MACCTL		0x120	/* MAC control */
+#define B43legacy_MMIO_MACCMD		0x124	/* MAC command */
 #define B43legacy_MMIO_GEN_IRQ_REASON	0x128
 #define B43legacy_MMIO_GEN_IRQ_MASK	0x12C
 #define B43legacy_MMIO_RAM_CONTROL	0x130
@@ -177,31 +176,25 @@
 #define B43legacy_RADIOCTL_ID		0x01
 
 /* MAC Control bitfield */
+#define B43legacy_MACCTL_ENABLED	0x00000001 /* MAC Enabled */
+#define B43legacy_MACCTL_PSM_RUN	0x00000002 /* Run Microcode */
+#define B43legacy_MACCTL_PSM_JMP0	0x00000004 /* Microcode jump to 0 */
+#define B43legacy_MACCTL_SHM_ENABLED	0x00000100 /* SHM Enabled */
 #define B43legacy_MACCTL_IHR_ENABLED	0x00000400 /* IHR Region Enabled */
+#define B43legacy_MACCTL_BE		0x00010000 /* Big Endian mode */
 #define B43legacy_MACCTL_INFRA		0x00020000 /* Infrastructure mode */
 #define B43legacy_MACCTL_AP		0x00040000 /* AccessPoint mode */
+#define B43legacy_MACCTL_RADIOLOCK	0x00080000 /* Radio lock */
 #define B43legacy_MACCTL_BEACPROMISC	0x00100000 /* Beacon Promiscuous */
 #define B43legacy_MACCTL_KEEP_BADPLCP	0x00200000 /* Keep bad PLCP frames */
 #define B43legacy_MACCTL_KEEP_CTL	0x00400000 /* Keep control frames */
 #define B43legacy_MACCTL_KEEP_BAD	0x00800000 /* Keep bad frames (FCS) */
 #define B43legacy_MACCTL_PROMISC	0x01000000 /* Promiscuous mode */
+#define B43legacy_MACCTL_HWPS		0x02000000 /* Hardware Power Saving */
+#define B43legacy_MACCTL_AWAKE		0x04000000 /* Device is awake */
+#define B43legacy_MACCTL_TBTTHOLD	0x10000000 /* TBTT Hold */
 #define B43legacy_MACCTL_GMODE		0x80000000 /* G Mode */
 
-/* StatusBitField */
-#define B43legacy_SBF_MAC_ENABLED	0x00000001
-#define B43legacy_SBF_CORE_READY	0x00000004
-#define B43legacy_SBF_400		0x00000400 /*FIXME: fix name*/
-#define B43legacy_SBF_XFER_REG_BYTESWAP	0x00010000
-#define B43legacy_SBF_MODE_NOTADHOC	0x00020000
-#define B43legacy_SBF_MODE_AP		0x00040000
-#define B43legacy_SBF_RADIOREG_LOCK	0x00080000
-#define B43legacy_SBF_MODE_MONITOR	0x00400000
-#define B43legacy_SBF_MODE_PROMISC	0x01000000
-#define B43legacy_SBF_PS1		0x02000000
-#define B43legacy_SBF_PS2		0x04000000
-#define B43legacy_SBF_NO_SSID_BCAST	0x08000000
-#define B43legacy_SBF_TIME_UPDATE	0x10000000
-
 /* 802.11 core specific TM State Low flags */
 #define B43legacy_TMSLOW_GMODE		0x20000000 /* G Mode Enable */
 #define B43legacy_TMSLOW_PLLREFSEL	0x00200000 /* PLL Freq Ref Select */
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -225,8 +225,8 @@ static void b43legacy_ram_write(struct b
 
 	B43legacy_WARN_ON(offset % 4 != 0);
 
-	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
-	if (status & B43legacy_SBF_XFER_REG_BYTESWAP)
+	status = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	if (status & B43legacy_MACCTL_BE)
 		val = swab32(val);
 
 	b43legacy_write32(dev, B43legacy_MMIO_RAM_CONTROL, offset);
@@ -434,9 +434,9 @@ static void b43legacy_time_lock(struct b
 {
 	u32 status;
 
-	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
-	status |= B43legacy_SBF_TIME_UPDATE;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, status);
+	status = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	status |= B43legacy_MACCTL_TBTTHOLD;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, status);
 	mmiowb();
 }
 
@@ -444,9 +444,9 @@ static void b43legacy_time_unlock(struct
 {
 	u32 status;
 
-	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
-	status &= ~B43legacy_SBF_TIME_UPDATE;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, status);
+	status = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	status &= ~B43legacy_MACCTL_TBTTHOLD;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, status);
 }
 
 static void b43legacy_tsf_write_locked(struct b43legacy_wldev *dev, u64 tsf)
@@ -647,7 +647,7 @@ void b43legacy_dummy_transmission(struct
 		b43legacy_ram_write(dev, i * 4, buffer[i]);
 
 	/* dummy read follows */
-	b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
+	b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
 
 	b43legacy_write16(dev, 0x0568, 0x0000);
 	b43legacy_write16(dev, 0x07C0, 0x0000);
@@ -794,9 +794,9 @@ static void b43legacy_jssi_write(struct 
 static void b43legacy_generate_noise_sample(struct b43legacy_wldev *dev)
 {
 	b43legacy_jssi_write(dev, 0x7F7F7F7F);
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS2_BITFIELD,
+	b43legacy_write32(dev, B43legacy_MMIO_MACCMD,
 			  b43legacy_read32(dev,
-			  B43legacy_MMIO_STATUS2_BITFIELD)
+			  B43legacy_MMIO_MACCMD)
 			  | (1 << 4));
 	B43legacy_WARN_ON(dev->noisecalc.channel_at_start !=
 			    dev->phy.channel);
@@ -895,8 +895,8 @@ static void handle_irq_atim_end(struct b
 {
 	if (!dev->reg124_set_0x4) /*FIXME rename this variable*/
 		return;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS2_BITFIELD,
-			  b43legacy_read32(dev, B43legacy_MMIO_STATUS2_BITFIELD)
+	b43legacy_write32(dev, B43legacy_MMIO_MACCMD,
+			  b43legacy_read32(dev, B43legacy_MMIO_MACCMD)
 			  | 0x4);
 }
 
@@ -1106,9 +1106,9 @@ static void b43legacy_update_templates(s
 	b43legacy_write_probe_resp_template(dev, 0x268, 0x4A,
 					    B43legacy_CCK_RATE_11MB);
 
-	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS2_BITFIELD);
+	status = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
 	status |= 0x03;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS2_BITFIELD, status);
+	b43legacy_write32(dev, B43legacy_MMIO_MACCMD, status);
 }
 
 static void b43legacy_refresh_templates(struct b43legacy_wldev *dev,
@@ -1166,7 +1166,7 @@ static void handle_irq_beacon(struct b43
 		return;
 
 	dev->irq_savedstate &= ~B43legacy_IRQ_BEACON;
-	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS2_BITFIELD);
+	status = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
 
 	if (!dev->cached_beacon || ((status & 0x1) && (status & 0x2))) {
 		/* ACK beacon IRQ. */
@@ -1182,14 +1182,14 @@ static void handle_irq_beacon(struct b43
 		b43legacy_write_beacon_template(dev, 0x68, 0x18,
 						B43legacy_CCK_RATE_1MB);
 		status |= 0x1;
-		b43legacy_write32(dev, B43legacy_MMIO_STATUS2_BITFIELD,
+		b43legacy_write32(dev, B43legacy_MMIO_MACCMD,
 				  status);
 	}
 	if (!(status & 0x2)) {
 		b43legacy_write_beacon_template(dev, 0x468, 0x1A,
 						B43legacy_CCK_RATE_1MB);
 		status |= 0x2;
-		b43legacy_write32(dev, B43legacy_MMIO_STATUS2_BITFIELD,
+		b43legacy_write32(dev, B43legacy_MMIO_MACCMD,
 				  status);
 	}
 }
@@ -1548,9 +1548,20 @@ static int b43legacy_upload_microcode(st
 	u16 fwpatch;
 	u16 fwdate;
 	u16 fwtime;
-	u32 tmp;
+	u32 tmp, macctl;
 	int err = 0;
 
+	/* Jump the microcode PSM to offset 0 */
+	macctl = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	B43legacy_WARN_ON(macctl & B43legacy_MACCTL_PSM_RUN);
+	macctl |= B43legacy_MACCTL_PSM_JMP0;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
+	/* Zero out all microcode PSM registers and shared memory. */
+	for (i = 0; i < 64; i++)
+		b43legacy_shm_write16(dev, B43legacy_SHM_WIRELESS, i, 0);
+	for (i = 0; i < 4096; i += 2)
+		b43legacy_shm_write16(dev, B43legacy_SHM_SHARED, i, 0);
+
 	/* Upload Microcode. */
 	data = (__be32 *) (dev->fw.ucode->data + hdr_len);
 	len = (dev->fw.ucode->size - hdr_len) / sizeof(__be32);
@@ -1581,7 +1592,12 @@ static int b43legacy_upload_microcode(st
 
 	b43legacy_write32(dev, B43legacy_MMIO_GEN_IRQ_REASON,
 			  B43legacy_IRQ_ALL);
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, 0x00020402);
+
+	/* Start the microcode PSM */
+	macctl = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	macctl &= ~B43legacy_MACCTL_PSM_JMP0;
+	macctl |= B43legacy_MACCTL_PSM_RUN;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
 
 	/* Wait for the microcode to load and respond */
 	i = 0;
@@ -1594,9 +1610,13 @@ static int b43legacy_upload_microcode(st
 			b43legacyerr(dev->wl, "Microcode not responding\n");
 			b43legacy_print_fw_helptext(dev->wl);
 			err = -ENODEV;
-			goto out;
+			goto error;
+		}
+		msleep_interruptible(50);
+		if (signal_pending(current)) {
+			err = -EINTR;
+			goto error;
 		}
-		udelay(10);
 	}
 	/* dummy read follows */
 	b43legacy_read32(dev, B43legacy_MMIO_GEN_IRQ_REASON);
@@ -1617,9 +1637,8 @@ static int b43legacy_upload_microcode(st
 			     " is supported. You must change your firmware"
 			     " files.\n");
 		b43legacy_print_fw_helptext(dev->wl);
-		b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, 0);
 		err = -EOPNOTSUPP;
-		goto out;
+		goto error;
 	}
 	b43legacydbg(dev->wl, "Loading firmware version 0x%X, patch level %u "
 	       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n", fwrev, fwpatch,
@@ -1629,7 +1648,14 @@ static int b43legacy_upload_microcode(st
 	dev->fw.rev = fwrev;
 	dev->fw.patch = fwpatch;
 
-out:
+	return 0;
+
+error:
+	macctl = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	macctl &= ~B43legacy_MACCTL_PSM_RUN;
+	macctl |= B43legacy_MACCTL_PSM_JMP0;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
+
 	return err;
 }
 
@@ -1736,9 +1762,9 @@ static int b43legacy_gpio_init(struct b4
 	u32 mask;
 	u32 set;
 
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD,
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL,
 			  b43legacy_read32(dev,
-			  B43legacy_MMIO_STATUS_BITFIELD)
+			  B43legacy_MMIO_MACCTL)
 			  & 0xFFFF3FFF);
 
 	b43legacy_write16(dev, B43legacy_MMIO_GPIO_MASK,
@@ -1798,14 +1824,14 @@ void b43legacy_mac_enable(struct b43lega
 	B43legacy_WARN_ON(dev->mac_suspended < 0);
 	B43legacy_WARN_ON(irqs_disabled());
 	if (dev->mac_suspended == 0) {
-		b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD,
+		b43legacy_write32(dev, B43legacy_MMIO_MACCTL,
 				  b43legacy_read32(dev,
-				  B43legacy_MMIO_STATUS_BITFIELD)
-				  | B43legacy_SBF_MAC_ENABLED);
+				  B43legacy_MMIO_MACCTL)
+				  | B43legacy_MACCTL_ENABLED);
 		b43legacy_write32(dev, B43legacy_MMIO_GEN_IRQ_REASON,
 				  B43legacy_IRQ_MAC_SUSPENDED);
 		/* the next two are dummy reads */
-		b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
+		b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
 		b43legacy_read32(dev, B43legacy_MMIO_GEN_IRQ_REASON);
 		b43legacy_power_saving_ctl_bits(dev, -1, -1);
 
@@ -1836,10 +1862,10 @@ void b43legacy_mac_suspend(struct b43leg
 		dev->irq_savedstate = tmp;
 
 		b43legacy_power_saving_ctl_bits(dev, -1, 1);
-		b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD,
+		b43legacy_write32(dev, B43legacy_MMIO_MACCTL,
 				  b43legacy_read32(dev,
-				  B43legacy_MMIO_STATUS_BITFIELD)
-				  & ~B43legacy_SBF_MAC_ENABLED);
+				  B43legacy_MMIO_MACCTL)
+				  & ~B43legacy_MACCTL_ENABLED);
 		b43legacy_read32(dev, B43legacy_MMIO_GEN_IRQ_REASON);
 		for (i = 40; i; i--) {
 			tmp = b43legacy_read32(dev,
@@ -2007,12 +2033,15 @@ static int b43legacy_chip_init(struct b4
 	struct b43legacy_phy *phy = &dev->phy;
 	int err;
 	int tmp;
-	u32 value32;
+	u32 value32, macctl;
 	u16 value16;
 
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD,
-			  B43legacy_SBF_CORE_READY
-			  | B43legacy_SBF_400);
+	/* Initialize the MAC control */
+	macctl = B43legacy_MACCTL_IHR_ENABLED | B43legacy_MACCTL_SHM_ENABLED;
+	if (dev->phy.gmode)
+		macctl |= B43legacy_MACCTL_GMODE;
+	macctl |= B43legacy_MACCTL_INFRA;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
 
 	err = b43legacy_request_firmware(dev);
 	if (err)
@@ -2052,12 +2081,12 @@ static int b43legacy_chip_init(struct b4
 	if (dev->dev->id.revision < 5)
 		b43legacy_write32(dev, 0x010C, 0x01000000);
 
-	value32 = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
-	value32 &= ~B43legacy_SBF_MODE_NOTADHOC;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, value32);
-	value32 = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
-	value32 |= B43legacy_SBF_MODE_NOTADHOC;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, value32);
+	value32 = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	value32 &= ~B43legacy_MACCTL_INFRA;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, value32);
+	value32 = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	value32 |= B43legacy_MACCTL_INFRA;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, value32);
 
 	if (b43legacy_using_pio(dev)) {
 		b43legacy_write32(dev, 0x0210, 0x00000100);
@@ -2954,12 +2983,19 @@ static void b43legacy_wireless_core_exit
 {
 	struct b43legacy_wl *wl = dev->wl;
 	struct b43legacy_phy *phy = &dev->phy;
+	u32 macctl;
 
 	B43legacy_WARN_ON(b43legacy_status(dev) > B43legacy_STAT_INITIALIZED);
 	if (b43legacy_status(dev) != B43legacy_STAT_INITIALIZED)
 		return;
 	b43legacy_set_status(dev, B43legacy_STAT_UNINIT);
 
+	/* Stop the microcode PSM. */
+	macctl = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	macctl &= ~B43legacy_MACCTL_PSM_RUN;
+	macctl |= B43legacy_MACCTL_PSM_JMP0;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
+
 	mutex_unlock(&wl->mutex);
 	/* Must unlock as it would otherwise deadlock. No races here.
 	 * Cancel possibly pending workqueues. */
Index: wireless-2.6/drivers/net/wireless/b43legacy/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/phy.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/phy.c
@@ -96,7 +96,7 @@ void b43legacy_raw_phy_lock(struct b43le
 	struct b43legacy_phy *phy = &dev->phy;
 
 	B43legacy_WARN_ON(!irqs_disabled());
-	if (b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD) == 0) {
+	if (b43legacy_read32(dev, B43legacy_MMIO_MACCTL) == 0) {
 		phy->locked = 0;
 		return;
 	}
@@ -144,7 +144,7 @@ void b43legacy_phy_calibrate(struct b43l
 {
 	struct b43legacy_phy *phy = &dev->phy;
 
-	b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD); /* Dummy read. */
+	b43legacy_read32(dev, B43legacy_MMIO_MACCTL); /* Dummy read. */
 	if (phy->calibrated)
 		return;
 	if (phy->type == B43legacy_PHYTYPE_G && phy->rev == 1) {
@@ -2236,16 +2236,16 @@ bit26 = 1;
 		 *	or the latest PS-Poll packet sent was successful,
 		 *	set bit26  */
 	}
-	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
+	status = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
 	if (bit25)
-		status |= B43legacy_SBF_PS1;
+		status |= B43legacy_MACCTL_HWPS;
 	else
-		status &= ~B43legacy_SBF_PS1;
+		status &= ~B43legacy_MACCTL_HWPS;
 	if (bit26)
-		status |= B43legacy_SBF_PS2;
+		status |= B43legacy_MACCTL_AWAKE;
 	else
-		status &= ~B43legacy_SBF_PS2;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, status);
+		status &= ~B43legacy_MACCTL_AWAKE;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, status);
 	if (bit26 && dev->dev->id.revision >= 5) {
 		for (i = 0; i < 100; i++) {
 			if (b43legacy_shm_read32(dev, B43legacy_SHM_SHARED,
Index: wireless-2.6/drivers/net/wireless/b43legacy/pio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/pio.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/pio.c
@@ -334,9 +334,9 @@ struct b43legacy_pioqueue *b43legacy_set
 	tasklet_init(&queue->txtask, tx_tasklet,
 		     (unsigned long)queue);
 
-	value = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
-	value &= ~B43legacy_SBF_XFER_REG_BYTESWAP;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, value);
+	value = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	value &= ~B43legacy_MACCTL_BE;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, value);
 
 	qsize = b43legacy_read16(dev, queue->mmio_base
 				 + B43legacy_PIO_TXQBUFSIZE);
Index: wireless-2.6/drivers/net/wireless/b43legacy/radio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/radio.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/radio.c
@@ -91,9 +91,9 @@ void b43legacy_radio_lock(struct b43lega
 {
 	u32 status;
 
-	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
-	status |= B43legacy_SBF_RADIOREG_LOCK;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, status);
+	status = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	status |= B43legacy_MACCTL_RADIOLOCK;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, status);
 	mmiowb();
 	udelay(10);
 }
@@ -103,9 +103,9 @@ void b43legacy_radio_unlock(struct b43le
 	u32 status;
 
 	b43legacy_read16(dev, B43legacy_MMIO_PHY_VER); /* dummy read */
-	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
-	status &= ~B43legacy_SBF_RADIOREG_LOCK;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, status);
+	status = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
+	status &= ~B43legacy_MACCTL_RADIOLOCK;
+	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, status);
 	mmiowb();
 }
 


--
Ciao
Stefano
