Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48323 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759936AbYEQUtW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 16:49:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add hooks for firmware debugging
Date: Sat, 17 May 2008 22:44:35 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805172244.35966.mb@bu3sch.de> (sfid-20080517_224929_837338_4AC751BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds some hooks for firmware debugging.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-05-15 23:31:37.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-05-17 20:22:56.000000000 +0200
@@ -419,12 +419,18 @@ enum {
 					 B43_IRQ_TXFIFO_FLUSH_OK | \
 					 B43_IRQ_NOISESAMPLE_OK | \
 					 B43_IRQ_UCODE_DEBUG | \
 					 B43_IRQ_RFKILL | \
 					 B43_IRQ_TX_OK)
 
+/* Debug-IRQ reasons. */
+#define B43_DEBUGIRQ_PANIC		0	/* The firmware panic'ed */
+#define B43_DEBUGIRQ_DUMP_SHM		1	/* Dump shared SHM */
+#define B43_DEBUGIRQ_DUMP_REGS		2	/* Dump the microcode registers */
+#define B43_DEBUGIRQ_ACK		0xFFFF	/* The host writes that to ACK the IRQ */
+
 /* Device specific rate values.
  * The actual values defined here are (rate_in_mbps * 2).
  * Some code depends on this. Don't change it. */
 #define B43_CCK_RATE_1MB		0x02
 #define B43_CCK_RATE_2MB		0x04
 #define B43_CCK_RATE_5MB		0x0B
@@ -763,12 +769,15 @@ struct b43_firmware {
 	struct b43_firmware_file initvals_band;
 
 	/* Firmware revision */
 	u16 rev;
 	/* Firmware patchlevel */
 	u16 patch;
+
+	/* Set to true, if we are using an opensource firmware. */
+	bool opensource;
 };
 
 /* Device (802.11 core) initialization status. */
 enum {
 	B43_STAT_UNINIT = 0,	/* Uninitialized. */
 	B43_STAT_INITIALIZED = 1,	/* Initialized, but not started, yet. */
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-05-15 23:31:37.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-05-17 22:35:00.000000000 +0200
@@ -1663,13 +1663,70 @@ static void b43_set_beacon_int(struct b4
 	b43_time_unlock(dev);
 	b43dbg(dev->wl, "Set beacon interval to %u\n", beacon_int);
 }
 
 static void handle_irq_ucode_debug(struct b43_wldev *dev)
 {
-	//TODO
+	unsigned int i, cnt;
+	u16 reason;
+	__le16 *buf;
+
+	/* The proprietary firmware doesn't have this IRQ. */
+	if (!dev->fw.opensource)
+		return;
+
+	/* Microcode register 63 contains the debug-IRQ reason. */
+	reason = b43_shm_read16(dev, B43_SHM_SCRATCH, 63);
+	switch (reason) {
+	case B43_DEBUGIRQ_PANIC:
+		/* The reason for the panic is in register 3. */
+		reason = b43_shm_read16(dev, B43_SHM_SCRATCH, 3);
+		b43err(dev->wl, "Whoopsy, the microcode panic'ed! Reason: %u\n",
+		       reason);
+		b43_controller_restart(dev, "Microcode panic");
+		break;
+	case B43_DEBUGIRQ_DUMP_SHM:
+		if (!B43_DEBUG)
+			break; /* Only with driver debugging enabled. */
+		buf = kmalloc(4096, GFP_ATOMIC);
+		if (!buf) {
+			b43dbg(dev->wl, "SHM-dump: Failed to allocate memory\n");
+			goto out;
+		}
+		for (i = 0; i < 4096; i += 2) {
+			u16 tmp = b43_shm_read16(dev, B43_SHM_SHARED, i);
+			buf[i / 2] = cpu_to_le16(tmp);
+		}
+		b43info(dev->wl, "Shared memory dump:\n");
+		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET,
+			       16, 2, buf, 4096, 1);
+		kfree(buf);
+		break;
+	case B43_DEBUGIRQ_DUMP_REGS:
+		if (!B43_DEBUG)
+			break; /* Only with driver debugging enabled. */
+		b43info(dev->wl, "Microcode register dump:\n");
+		for (i = 0, cnt = 0; i < 64; i++) {
+			u16 tmp = b43_shm_read16(dev, B43_SHM_SCRATCH, i);
+			if (cnt == 0)
+				printk(KERN_INFO);
+			printk("r%02u: 0x%04X  ", i, tmp);
+			cnt++;
+			if (cnt == 6) {
+				printk("\n");
+				cnt = 0;
+			}
+		}
+		printk("\n");
+		break;
+	default:
+		b43dbg(dev->wl, "Debug-IRQ triggered for unknown reason: %u\n",
+		       reason);
+	}
+out:
+	b43_shm_write16(dev, B43_SHM_SCRATCH, 63, B43_DEBUGIRQ_ACK);
 }
 
 /* Interrupt handler bottom-half */
 static void b43_interrupt_tasklet(struct b43_wldev *dev)
 {
 	u32 reason;
@@ -2121,20 +2178,28 @@ static int b43_upload_microcode(struct b
 		       "binary drivers older than version 4.x is unsupported. "
 		       "You must upgrade your firmware files.\n");
 		b43_print_fw_helptext(dev->wl, 1);
 		err = -EOPNOTSUPP;
 		goto error;
 	}
-	b43info(dev->wl, "Loading firmware version %u.%u "
-		"(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
-		fwrev, fwpatch,
-		(fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
-		(fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
-
 	dev->fw.rev = fwrev;
 	dev->fw.patch = fwpatch;
+	dev->fw.opensource = (fwdate == 0xFFFF);
+
+	if (dev->fw.opensource) {
+		/* Patchlevel info is encoded in the "time" field. */
+		dev->fw.patch = fwtime;
+		b43info(dev->wl, "Loading OpenSource firmware version %u.%u\n",
+			dev->fw.rev, dev->fw.patch);
+	} else {
+		b43info(dev->wl, "Loading firmware version %u.%u "
+			"(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
+			fwrev, fwpatch,
+			(fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
+			(fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
+	}
 
 	if (b43_is_old_txhdr_format(dev)) {
 		b43warn(dev->wl, "You are using an old firmware image. "
 			"Support for old firmware will be removed in July 2008.\n");
 		b43_print_fw_helptext(dev->wl, 0);
 	}
