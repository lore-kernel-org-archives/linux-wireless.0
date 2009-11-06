Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51951 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759758AbZKFUWc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 15:22:32 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ssb-pcmcia: Fix 32bit register access in early bus scanning
Date: Fri, 6 Nov 2009 21:21:27 +0100
Cc: Martin Fuzzey <mfuzzey@gmail.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911062121.28881.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From:	Martin Fuzzey <mfuzzey@gmail.com>

The scan function was using 32 bit access which does not
work on 16bit CF cards.

This patch corrects this by doing two 16 bit reads like
ssb_pcmcia_read32 already does.

mb -- Removed locking. That early in init there's no need for locking.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/ssb/scan.c
===================================================================
--- wireless-testing.orig/drivers/ssb/scan.c	2009-10-09 19:50:16.000000000 +0200
+++ wireless-testing/drivers/ssb/scan.c	2009-11-06 19:24:13.000000000 +0100
@@ -162,6 +162,8 @@ static u8 chipid_to_nrcores(u16 chipid)
 static u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx,
 		       u16 offset)
 {
+	u32 lo, hi;
+
 	switch (bus->bustype) {
 	case SSB_BUSTYPE_SSB:
 		offset += current_coreidx * SSB_CORE_SIZE;
@@ -174,7 +176,9 @@ static u32 scan_read32(struct ssb_bus *b
 			offset -= 0x800;
 		} else
 			ssb_pcmcia_switch_segment(bus, 0);
-		break;
+		lo = readw(bus->mmio + offset);
+		hi = readw(bus->mmio + offset + 2);
+		return lo | (hi << 16);
 	case SSB_BUSTYPE_SDIO:
 		offset += current_coreidx * SSB_CORE_SIZE;
 		return ssb_sdio_scan_read32(bus, offset);

-- 
Greetings, Michael.
