Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:50228 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764483AbYESWZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 18:25:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add firmware markers support
Date: Tue, 20 May 2008 00:24:36 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805200024.36914.mb@bu3sch.de> (sfid-20080520_002600_611207_9496401C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for firmware markers.
With firmware markers it's easily possible to check whether the
firmware runs some codepath or not. The driver will throw a message
when the firmware executes a MARKER(x).

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-05-18 23:57:16.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-05-20 00:16:27.000000000 +0200
@@ -425,14 +425,19 @@ enum {
 /* The firmware register to fetch the debug-IRQ reason from. */
 #define B43_DEBUGIRQ_REASON_REG		63
 /* Debug-IRQ reasons. */
 #define B43_DEBUGIRQ_PANIC		0	/* The firmware panic'ed */
 #define B43_DEBUGIRQ_DUMP_SHM		1	/* Dump shared SHM */
 #define B43_DEBUGIRQ_DUMP_REGS		2	/* Dump the microcode registers */
+#define B43_DEBUGIRQ_MARKER		3	/* A "marker" was thrown by the firmware. */
 #define B43_DEBUGIRQ_ACK		0xFFFF	/* The host writes that to ACK the IRQ */
 
+/* The firmware register that contains the "marker" line. */
+#define B43_MARKER_ID_REG		2
+#define B43_MARKER_LINE_REG		3
+
 /* The firmware register to fetch the panic reason from. */
 #define B43_FWPANIC_REASON_REG		3
 /* Firmware panic reason codes */
 #define B43_FWPANIC_DIE			0 /* Firmware died. Don't auto-restart it. */
 #define B43_FWPANIC_RESTART		1 /* Firmware died. Schedule a controller reset. */
 
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-05-19 00:02:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-05-20 00:18:53.000000000 +0200
@@ -1688,13 +1688,13 @@ static void b43_handle_firmware_panic(st
 	}
 }
 
 static void handle_irq_ucode_debug(struct b43_wldev *dev)
 {
 	unsigned int i, cnt;
-	u16 reason;
+	u16 reason, marker_id, marker_line;
 	__le16 *buf;
 
 	/* The proprietary firmware doesn't have this IRQ. */
 	if (!dev->fw.opensource)
 		return;
 
@@ -1736,12 +1736,23 @@ static void handle_irq_ucode_debug(struc
 				printk("\n");
 				cnt = 0;
 			}
 		}
 		printk("\n");
 		break;
+	case B43_DEBUGIRQ_MARKER:
+		if (!B43_DEBUG)
+			break; /* Only with driver debugging enabled. */
+		marker_id = b43_shm_read16(dev, B43_SHM_SCRATCH,
+					   B43_MARKER_ID_REG);
+		marker_line = b43_shm_read16(dev, B43_SHM_SCRATCH,
+					     B43_MARKER_LINE_REG);
+		b43info(dev->wl, "The firmware just executed the MARKER(%u) "
+			"at line number %u\n",
+			marker_id, marker_line);
+		break;
 	default:
 		b43dbg(dev->wl, "Debug-IRQ triggered for unknown reason: %u\n",
 		       reason);
 	}
 out:
 	/* Acknowledge the debug-IRQ, so the firmware can continue. */
