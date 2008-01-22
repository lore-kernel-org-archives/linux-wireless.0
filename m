Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45323 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYAVTZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 14:25:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix MAC control and microcode init
Date: Tue, 22 Jan 2008 20:23:34 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Message-Id: <200801222023.35131.mb@bu3sch.de> (sfid-20080122_192602_244741_E21941C1)
Content-Type: text/plain;
  charset="us-ascii"
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

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this bugfix should go into 2.6.24.
Stefano, this must be ported to b43legacy.



Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-22 19:23:50.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-22 20:00:00.000000000 +0100
@@ -1775,15 +1775,26 @@ error:
 static int b43_upload_microcode(struct b43_wldev *dev)
 {
 	const size_t hdr_len = sizeof(struct b43_fw_header);
 	const __be32 *data;
 	unsigned int i, len;
 	u16 fwrev, fwpatch, fwdate, fwtime;
-	u32 tmp;
+	u32 tmp, macctl;
 	int err = 0;
 
+	/* Jump the microcode PSM to offset 0 */
+	macctl = b43_read32(dev, B43_MMIO_MACCTL);
+	B43_WARN_ON(macctl & B43_MACCTL_PSM_RUN);
+	macctl |= B43_MACCTL_PSM_JMP0;
+	b43_write32(dev, B43_MMIO_MACCTL, macctl);
+	/* Zero out all microcode PSM registers and shared memory. */
+	for (i = 0; i < 64; i++)
+		b43_shm_write16(dev, B43_SHM_SCRATCH, i, 0);
+	for (i = 0; i < 4096; i += 2)
+		b43_shm_write16(dev, B43_SHM_SHARED, i, 0);
+
 	/* Upload Microcode. */
 	data = (__be32 *) (dev->fw.ucode.data->data + hdr_len);
 	len = (dev->fw.ucode.data->size - hdr_len) / sizeof(__be32);
 	b43_shm_control_word(dev, B43_SHM_UCODE | B43_SHM_AUTOINC_W, 0x0000);
 	for (i = 0; i < len; i++) {
 		b43_write32(dev, B43_MMIO_SHM_DATA, be32_to_cpu(data[i]));
@@ -1802,30 +1813,37 @@ static int b43_upload_microcode(struct b
 			b43_write32(dev, B43_MMIO_SHM_DATA, be32_to_cpu(data[i]));
 			udelay(10);
 		}
 	}
 
 	b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, B43_IRQ_ALL);
-	b43_write32(dev, B43_MMIO_MACCTL,
-		    B43_MACCTL_PSM_RUN |
-		    B43_MACCTL_IHR_ENABLED | B43_MACCTL_INFRA);
+
+	/* Start the microcode PSM */
+	macctl = b43_read32(dev, B43_MMIO_MACCTL);
+	macctl &= ~B43_MACCTL_PSM_JMP0;
+	macctl |= B43_MACCTL_PSM_RUN;
+	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 
 	/* Wait for the microcode to load and respond */
 	i = 0;
 	while (1) {
 		tmp = b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);
 		if (tmp == B43_IRQ_MAC_SUSPENDED)
 			break;
 		i++;
-		if (i >= 50) {
+		if (i >= 20) {
 			b43err(dev->wl, "Microcode not responding\n");
 			b43_print_fw_helptext(dev->wl, 1);
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
 	b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);	/* dummy read */
 
 	/* Get and check the revisions. */
 	fwrev = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_UCODEREV);
 	fwpatch = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_UCODEPATCH);
@@ -1834,15 +1852,14 @@ static int b43_upload_microcode(struct b
 
 	if (fwrev <= 0x128) {
 		b43err(dev->wl, "YOUR FIRMWARE IS TOO OLD. Firmware from "
 		       "binary drivers older than version 4.x is unsupported. "
 		       "You must upgrade your firmware files.\n");
 		b43_print_fw_helptext(dev->wl, 1);
-		b43_write32(dev, B43_MMIO_MACCTL, 0);
 		err = -EOPNOTSUPP;
-		goto out;
+		goto error;
 	}
 	b43dbg(dev->wl, "Loading firmware version %u.%u "
 	       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
 	       fwrev, fwpatch,
 	       (fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
 	       (fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
@@ -1853,13 +1870,20 @@ static int b43_upload_microcode(struct b
 	if (b43_is_old_txhdr_format(dev)) {
 		b43warn(dev->wl, "You are using an old firmware image. "
 			"Support for old firmware will be removed in July 2008.\n");
 		b43_print_fw_helptext(dev->wl, 0);
 	}
 
-out:
+	return 0;
+
+error:
+	macctl = b43_read32(dev, B43_MMIO_MACCTL);
+	macctl &= ~B43_MACCTL_PSM_RUN;
+	macctl |= B43_MACCTL_PSM_JMP0;
+	b43_write32(dev, B43_MMIO_MACCTL, macctl);
+
 	return err;
 }
 
 static int b43_write_initvals(struct b43_wldev *dev,
 			      const struct b43_iv *ivals,
 			      size_t count,
@@ -2225,17 +2249,21 @@ static void b43_chip_exit(struct b43_wld
  * http://bcm-specs.sipsolutions.net/ChipInit
  */
 static int b43_chip_init(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	int err, tmp;
-	u32 value32;
+	u32 value32, macctl;
 	u16 value16;
 
-	b43_write32(dev, B43_MMIO_MACCTL,
-		    B43_MACCTL_PSM_JMP0 | B43_MACCTL_IHR_ENABLED);
+	/* Initialize the MAC control */
+	macctl = B43_MACCTL_IHR_ENABLED | B43_MACCTL_SHM_ENABLED;
+	if (dev->phy.gmode)
+		macctl |= B43_MACCTL_GMODE;
+	macctl |= B43_MACCTL_INFRA;
+	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 
 	err = b43_request_firmware(dev);
 	if (err)
 		goto out;
 	err = b43_upload_microcode(dev);
 	if (err)
@@ -3373,18 +3401,25 @@ static void b43_set_retry_limits(struct 
 
 /* Shutdown a wireless core */
 /* Locking: wl->mutex */
 static void b43_wireless_core_exit(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
+	u32 macctl;
 
 	B43_WARN_ON(b43_status(dev) > B43_STAT_INITIALIZED);
 	if (b43_status(dev) != B43_STAT_INITIALIZED)
 		return;
 	b43_set_status(dev, B43_STAT_UNINIT);
 
+	/* Stop the microcode PSM. */
+	macctl = b43_read32(dev, B43_MMIO_MACCTL);
+	macctl &= ~B43_MACCTL_PSM_RUN;
+	macctl |= B43_MACCTL_PSM_JMP0;
+	b43_write32(dev, B43_MMIO_MACCTL, macctl);
+
 	b43_leds_exit(dev);
 	b43_rng_exit(dev->wl);
 	b43_dma_free(dev);
 	b43_chip_exit(dev);
 	b43_radio_turn_off(dev, 1);
 	b43_switch_analog(dev, 0);
