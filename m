Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:47450 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763751AbYESV4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 17:56:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add panic reason code that doesn't trigger restart
Date: Mon, 19 May 2008 23:51:37 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805192351.38219.mb@bu3sch.de> (sfid-20080519_235630_483142_352D8E7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a firmware panic reason code that doesn't trigger a restart.
This is useful for firmware debugging and avoiding endless
restart loops. We can use FWPANIC_DIE to halt the firmware at a
well defined point.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-05-17 23:09:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-05-18 23:57:16.000000000 +0200
@@ -419,18 +419,27 @@ enum {
 					 B43_IRQ_TXFIFO_FLUSH_OK | \
 					 B43_IRQ_NOISESAMPLE_OK | \
 					 B43_IRQ_UCODE_DEBUG | \
 					 B43_IRQ_RFKILL | \
 					 B43_IRQ_TX_OK)
 
+/* The firmware register to fetch the debug-IRQ reason from. */
+#define B43_DEBUGIRQ_REASON_REG		63
 /* Debug-IRQ reasons. */
 #define B43_DEBUGIRQ_PANIC		0	/* The firmware panic'ed */
 #define B43_DEBUGIRQ_DUMP_SHM		1	/* Dump shared SHM */
 #define B43_DEBUGIRQ_DUMP_REGS		2	/* Dump the microcode registers */
 #define B43_DEBUGIRQ_ACK		0xFFFF	/* The host writes that to ACK the IRQ */
 
+/* The firmware register to fetch the panic reason from. */
+#define B43_FWPANIC_REASON_REG		3
+/* Firmware panic reason codes */
+#define B43_FWPANIC_DIE			0 /* Firmware died. Don't auto-restart it. */
+#define B43_FWPANIC_RESTART		1 /* Firmware died. Schedule a controller reset. */
+
+
 /* Device specific rate values.
  * The actual values defined here are (rate_in_mbps * 2).
  * Some code depends on this. Don't change it. */
 #define B43_CCK_RATE_1MB		0x02
 #define B43_CCK_RATE_2MB		0x04
 #define B43_CCK_RATE_5MB		0x0B
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-05-17 23:33:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-05-19 00:02:01.000000000 +0200
@@ -1661,31 +1661,52 @@ static void b43_set_beacon_int(struct b4
 		b43_write16(dev, 0x610, beacon_int);
 	}
 	b43_time_unlock(dev);
 	b43dbg(dev->wl, "Set beacon interval to %u\n", beacon_int);
 }
 
+static void b43_handle_firmware_panic(struct b43_wldev *dev)
+{
+	u16 reason;
+
+	/* Read the register that contains the reason code for the panic. */
+	reason = b43_shm_read16(dev, B43_SHM_SCRATCH, B43_FWPANIC_REASON_REG);
+	b43err(dev->wl, "Whoopsy, firmware panic! Reason: %u\n", reason);
+
+	switch (reason) {
+	default:
+		b43dbg(dev->wl, "The panic reason is unknown.\n");
+		/* fallthrough */
+	case B43_FWPANIC_DIE:
+		/* Do not restart the controller or firmware.
+		 * The device is nonfunctional from now on.
+		 * Restarting would result in this panic to trigger again,
+		 * so we avoid that recursion. */
+		break;
+	case B43_FWPANIC_RESTART:
+		b43_controller_restart(dev, "Microcode panic");
+		break;
+	}
+}
+
 static void handle_irq_ucode_debug(struct b43_wldev *dev)
 {
 	unsigned int i, cnt;
 	u16 reason;
 	__le16 *buf;
 
 	/* The proprietary firmware doesn't have this IRQ. */
 	if (!dev->fw.opensource)
 		return;
 
-	/* Microcode register 63 contains the debug-IRQ reason. */
-	reason = b43_shm_read16(dev, B43_SHM_SCRATCH, 63);
+	/* Read the register that contains the reason code for this IRQ. */
+	reason = b43_shm_read16(dev, B43_SHM_SCRATCH, B43_DEBUGIRQ_REASON_REG);
+
 	switch (reason) {
 	case B43_DEBUGIRQ_PANIC:
-		/* The reason for the panic is in register 3. */
-		reason = b43_shm_read16(dev, B43_SHM_SCRATCH, 3);
-		b43err(dev->wl, "Whoopsy, the microcode panic'ed! Reason: %u\n",
-		       reason);
-		b43_controller_restart(dev, "Microcode panic");
+		b43_handle_firmware_panic(dev);
 		break;
 	case B43_DEBUGIRQ_DUMP_SHM:
 		if (!B43_DEBUG)
 			break; /* Only with driver debugging enabled. */
 		buf = kmalloc(4096, GFP_ATOMIC);
 		if (!buf) {
@@ -1720,13 +1741,15 @@ static void handle_irq_ucode_debug(struc
 		break;
 	default:
 		b43dbg(dev->wl, "Debug-IRQ triggered for unknown reason: %u\n",
 		       reason);
 	}
 out:
-	b43_shm_write16(dev, B43_SHM_SCRATCH, 63, B43_DEBUGIRQ_ACK);
+	/* Acknowledge the debug-IRQ, so the firmware can continue. */
+	b43_shm_write16(dev, B43_SHM_SCRATCH,
+			B43_DEBUGIRQ_REASON_REG, B43_DEBUGIRQ_ACK);
 }
 
 /* Interrupt handler bottom-half */
 static void b43_interrupt_tasklet(struct b43_wldev *dev)
 {
 	u32 reason;
