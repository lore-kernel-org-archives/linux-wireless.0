Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35248 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbbJYScw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 14:32:52 -0400
Received: by lfbn126 with SMTP id n126so91914418lfb.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2015 11:32:50 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: move functions specific to SoC hosted bus to separated file
Date: Sun, 25 Oct 2015 19:32:42 +0100
Message-Id: <1445797963-5968-1-git-send-email-zajec5@gmail.com> (sfid-20151025_193322_304468_CD8C7A13)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans main.c a bit and will allow us to compile SoC related code
conditionally in the future.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/Makefile      |   1 +
 drivers/ssb/host_soc.c    | 173 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ssb/main.c        | 162 +------------------------------------------
 drivers/ssb/ssb_private.h |   5 ++
 4 files changed, 180 insertions(+), 161 deletions(-)
 create mode 100644 drivers/ssb/host_soc.c

diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index 7daa03e..30194c5 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -7,6 +7,7 @@ ssb-$(CONFIG_SSB_SPROM)			+= sprom.o
 ssb-$(CONFIG_SSB_PCIHOST)		+= pci.o pcihost_wrapper.o
 ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o bridge_pcmcia_80211.o
 ssb-$(CONFIG_SSB_SDIOHOST)		+= sdio.o
+ssb-y					+= host_soc.o
 
 # built-in drivers
 ssb-y					+= driver_chipcommon.o
diff --git a/drivers/ssb/host_soc.c b/drivers/ssb/host_soc.c
new file mode 100644
index 0000000..c809f25
--- /dev/null
+++ b/drivers/ssb/host_soc.c
@@ -0,0 +1,173 @@
+/*
+ * Sonics Silicon Backplane SoC host related functions.
+ * Subsystem core
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, 2007, Michael Buesch <m@bues.ch>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/ssb/ssb.h>
+
+#include "ssb_private.h"
+
+static u8 ssb_host_soc_read8(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	return readb(bus->mmio + offset);
+}
+
+static u16 ssb_host_soc_read16(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	return readw(bus->mmio + offset);
+}
+
+static u32 ssb_host_soc_read32(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	return readl(bus->mmio + offset);
+}
+
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_host_soc_block_read(struct ssb_device *dev, void *buffer,
+				    size_t count, u16 offset, u8 reg_width)
+{
+	struct ssb_bus *bus = dev->bus;
+	void __iomem *addr;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	addr = bus->mmio + offset;
+
+	switch (reg_width) {
+	case sizeof(u8): {
+		u8 *buf = buffer;
+
+		while (count) {
+			*buf = __raw_readb(addr);
+			buf++;
+			count--;
+		}
+		break;
+	}
+	case sizeof(u16): {
+		__le16 *buf = buffer;
+
+		SSB_WARN_ON(count & 1);
+		while (count) {
+			*buf = (__force __le16)__raw_readw(addr);
+			buf++;
+			count -= 2;
+		}
+		break;
+	}
+	case sizeof(u32): {
+		__le32 *buf = buffer;
+
+		SSB_WARN_ON(count & 3);
+		while (count) {
+			*buf = (__force __le32)__raw_readl(addr);
+			buf++;
+			count -= 4;
+		}
+		break;
+	}
+	default:
+		SSB_WARN_ON(1);
+	}
+}
+#endif /* CONFIG_SSB_BLOCKIO */
+
+static void ssb_host_soc_write8(struct ssb_device *dev, u16 offset, u8 value)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	writeb(value, bus->mmio + offset);
+}
+
+static void ssb_host_soc_write16(struct ssb_device *dev, u16 offset, u16 value)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	writew(value, bus->mmio + offset);
+}
+
+static void ssb_host_soc_write32(struct ssb_device *dev, u16 offset, u32 value)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	writel(value, bus->mmio + offset);
+}
+
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_host_soc_block_write(struct ssb_device *dev, const void *buffer,
+				     size_t count, u16 offset, u8 reg_width)
+{
+	struct ssb_bus *bus = dev->bus;
+	void __iomem *addr;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	addr = bus->mmio + offset;
+
+	switch (reg_width) {
+	case sizeof(u8): {
+		const u8 *buf = buffer;
+
+		while (count) {
+			__raw_writeb(*buf, addr);
+			buf++;
+			count--;
+		}
+		break;
+	}
+	case sizeof(u16): {
+		const __le16 *buf = buffer;
+
+		SSB_WARN_ON(count & 1);
+		while (count) {
+			__raw_writew((__force u16)(*buf), addr);
+			buf++;
+			count -= 2;
+		}
+		break;
+	}
+	case sizeof(u32): {
+		const __le32 *buf = buffer;
+
+		SSB_WARN_ON(count & 3);
+		while (count) {
+			__raw_writel((__force u32)(*buf), addr);
+			buf++;
+			count -= 4;
+		}
+		break;
+	}
+	default:
+		SSB_WARN_ON(1);
+	}
+}
+#endif /* CONFIG_SSB_BLOCKIO */
+
+/* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA). */
+const struct ssb_bus_ops ssb_host_soc_ops = {
+	.read8		= ssb_host_soc_read8,
+	.read16		= ssb_host_soc_read16,
+	.read32		= ssb_host_soc_read32,
+	.write8		= ssb_host_soc_write8,
+	.write16	= ssb_host_soc_write16,
+	.write32	= ssb_host_soc_write32,
+#ifdef CONFIG_SSB_BLOCKIO
+	.block_read	= ssb_host_soc_block_read,
+	.block_write	= ssb_host_soc_block_write,
+#endif
+};
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 90ec6a0..bea823e 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -596,166 +596,6 @@ error:
 	return err;
 }
 
-static u8 ssb_ssb_read8(struct ssb_device *dev, u16 offset)
-{
-	struct ssb_bus *bus = dev->bus;
-
-	offset += dev->core_index * SSB_CORE_SIZE;
-	return readb(bus->mmio + offset);
-}
-
-static u16 ssb_ssb_read16(struct ssb_device *dev, u16 offset)
-{
-	struct ssb_bus *bus = dev->bus;
-
-	offset += dev->core_index * SSB_CORE_SIZE;
-	return readw(bus->mmio + offset);
-}
-
-static u32 ssb_ssb_read32(struct ssb_device *dev, u16 offset)
-{
-	struct ssb_bus *bus = dev->bus;
-
-	offset += dev->core_index * SSB_CORE_SIZE;
-	return readl(bus->mmio + offset);
-}
-
-#ifdef CONFIG_SSB_BLOCKIO
-static void ssb_ssb_block_read(struct ssb_device *dev, void *buffer,
-			       size_t count, u16 offset, u8 reg_width)
-{
-	struct ssb_bus *bus = dev->bus;
-	void __iomem *addr;
-
-	offset += dev->core_index * SSB_CORE_SIZE;
-	addr = bus->mmio + offset;
-
-	switch (reg_width) {
-	case sizeof(u8): {
-		u8 *buf = buffer;
-
-		while (count) {
-			*buf = __raw_readb(addr);
-			buf++;
-			count--;
-		}
-		break;
-	}
-	case sizeof(u16): {
-		__le16 *buf = buffer;
-
-		SSB_WARN_ON(count & 1);
-		while (count) {
-			*buf = (__force __le16)__raw_readw(addr);
-			buf++;
-			count -= 2;
-		}
-		break;
-	}
-	case sizeof(u32): {
-		__le32 *buf = buffer;
-
-		SSB_WARN_ON(count & 3);
-		while (count) {
-			*buf = (__force __le32)__raw_readl(addr);
-			buf++;
-			count -= 4;
-		}
-		break;
-	}
-	default:
-		SSB_WARN_ON(1);
-	}
-}
-#endif /* CONFIG_SSB_BLOCKIO */
-
-static void ssb_ssb_write8(struct ssb_device *dev, u16 offset, u8 value)
-{
-	struct ssb_bus *bus = dev->bus;
-
-	offset += dev->core_index * SSB_CORE_SIZE;
-	writeb(value, bus->mmio + offset);
-}
-
-static void ssb_ssb_write16(struct ssb_device *dev, u16 offset, u16 value)
-{
-	struct ssb_bus *bus = dev->bus;
-
-	offset += dev->core_index * SSB_CORE_SIZE;
-	writew(value, bus->mmio + offset);
-}
-
-static void ssb_ssb_write32(struct ssb_device *dev, u16 offset, u32 value)
-{
-	struct ssb_bus *bus = dev->bus;
-
-	offset += dev->core_index * SSB_CORE_SIZE;
-	writel(value, bus->mmio + offset);
-}
-
-#ifdef CONFIG_SSB_BLOCKIO
-static void ssb_ssb_block_write(struct ssb_device *dev, const void *buffer,
-				size_t count, u16 offset, u8 reg_width)
-{
-	struct ssb_bus *bus = dev->bus;
-	void __iomem *addr;
-
-	offset += dev->core_index * SSB_CORE_SIZE;
-	addr = bus->mmio + offset;
-
-	switch (reg_width) {
-	case sizeof(u8): {
-		const u8 *buf = buffer;
-
-		while (count) {
-			__raw_writeb(*buf, addr);
-			buf++;
-			count--;
-		}
-		break;
-	}
-	case sizeof(u16): {
-		const __le16 *buf = buffer;
-
-		SSB_WARN_ON(count & 1);
-		while (count) {
-			__raw_writew((__force u16)(*buf), addr);
-			buf++;
-			count -= 2;
-		}
-		break;
-	}
-	case sizeof(u32): {
-		const __le32 *buf = buffer;
-
-		SSB_WARN_ON(count & 3);
-		while (count) {
-			__raw_writel((__force u32)(*buf), addr);
-			buf++;
-			count -= 4;
-		}
-		break;
-	}
-	default:
-		SSB_WARN_ON(1);
-	}
-}
-#endif /* CONFIG_SSB_BLOCKIO */
-
-/* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA). */
-static const struct ssb_bus_ops ssb_ssb_ops = {
-	.read8		= ssb_ssb_read8,
-	.read16		= ssb_ssb_read16,
-	.read32		= ssb_ssb_read32,
-	.write8		= ssb_ssb_write8,
-	.write16	= ssb_ssb_write16,
-	.write32	= ssb_ssb_write32,
-#ifdef CONFIG_SSB_BLOCKIO
-	.block_read	= ssb_ssb_block_read,
-	.block_write	= ssb_ssb_block_write,
-#endif
-};
-
 static int ssb_fetch_invariants(struct ssb_bus *bus,
 				ssb_invariants_func_t get_invariants)
 {
@@ -927,7 +767,7 @@ int ssb_bus_ssbbus_register(struct ssb_bus *bus, unsigned long baseaddr,
 	int err;
 
 	bus->bustype = SSB_BUSTYPE_SSB;
-	bus->ops = &ssb_ssb_ops;
+	bus->ops = &ssb_host_soc_ops;
 
 	err = ssb_bus_register(bus, get_invariants, baseaddr);
 	if (!err) {
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 93bb8f0..0a756c2 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -157,6 +157,11 @@ static inline int ssb_sdio_init(struct ssb_bus *bus)
 }
 #endif /* CONFIG_SSB_SDIOHOST */
 
+/**************************************************
+ * host_soc.c
+ **************************************************/
+
+extern const struct ssb_bus_ops ssb_host_soc_ops;
 
 /* scan.c */
 extern const char *ssb_core_name(u16 coreid);
-- 
1.8.4.5

