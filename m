Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42495 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1ETAtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 20:49:15 -0400
Received: by eyx24 with SMTP id 24so1025772eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 17:49:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: host pci: implement block R/W operations
Date: Fri, 20 May 2011 03:27:06 +0200
Message-Id: <1305854826-14717-1-git-send-email-zajec5@gmail.com> (sfid-20110520_024918_904536_C33A302F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Kconfig      |    5 ++++
 drivers/bcma/host_pci.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bcma/bcma.h |   18 +++++++++++++++
 3 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 353781b..83e9adf 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -13,6 +13,11 @@ config BCMA
 	  Bus driver for Broadcom specific Advanced Microcontroller Bus
 	  Architecture.
 
+# Support for Block-I/O. SELECT this from the driver that needs it.
+config BCMA_BLOCKIO
+	bool
+	depends on BCMA
+
 config BCMA_HOST_PCI_POSSIBLE
 	bool
 	depends on BCMA && PCI = y
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index ffd8797..279bf50 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -64,6 +64,54 @@ static void bcma_host_pci_write32(struct bcma_device *core, u16 offset,
 	iowrite32(value, core->bus->mmio + offset);
 }
 
+#ifdef CONFIG_BCMA_BLOCKIO
+void bcma_host_pci_block_read(struct bcma_device *core, void *buffer,
+			      size_t count, u16 offset, u8 reg_width)
+{
+	void __iomem *addr = core->bus->mmio + offset;
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	switch (reg_width) {
+	case sizeof(u8):
+		ioread8_rep(addr, buffer, count);
+		break;
+	case sizeof(u16):
+		WARN_ON(count & 1);
+		ioread16_rep(addr, buffer, count >> 1);
+		break;
+	case sizeof(u32):
+		WARN_ON(count & 3);
+		ioread32_rep(addr, buffer, count >> 2);
+		break;
+	default:
+		WARN_ON(1);
+	}
+}
+
+void bcma_host_pci_block_write(struct bcma_device *core, const void *buffer,
+			       size_t count, u16 offset, u8 reg_width)
+{
+	void __iomem *addr = core->bus->mmio + offset;
+	if (core->bus->mapped_core != core)
+		bcma_host_pci_switch_core(core);
+	switch (reg_width) {
+	case sizeof(u8):
+		iowrite8_rep(addr, buffer, count);
+		break;
+	case sizeof(u16):
+		WARN_ON(count & 1);
+		iowrite16_rep(addr, buffer, count >> 1);
+		break;
+	case sizeof(u32):
+		WARN_ON(count & 3);
+		iowrite32_rep(addr, buffer, count >> 2);
+		break;
+	default:
+		WARN_ON(1);
+	}
+}
+#endif
+
 static u32 bcma_host_pci_aread32(struct bcma_device *core, u16 offset)
 {
 	if (core->bus->mapped_core != core)
@@ -86,6 +134,10 @@ const struct bcma_host_ops bcma_host_pci_ops = {
 	.write8		= bcma_host_pci_write8,
 	.write16	= bcma_host_pci_write16,
 	.write32	= bcma_host_pci_write32,
+#ifdef CONFIG_BCMA_BLOCKIO
+	.block_read	= bcma_host_pci_block_read,
+	.block_write	= bcma_host_pci_block_write,
+#endif
 	.aread32	= bcma_host_pci_aread32,
 	.awrite32	= bcma_host_pci_awrite32,
 };
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 8b0cef9..27a27a7 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -31,6 +31,12 @@ struct bcma_host_ops {
 	void (*write8)(struct bcma_device *core, u16 offset, u8 value);
 	void (*write16)(struct bcma_device *core, u16 offset, u16 value);
 	void (*write32)(struct bcma_device *core, u16 offset, u32 value);
+#ifdef CONFIG_BCMA_BLOCKIO
+	void (*block_read)(struct bcma_device *core, void *buffer,
+			   size_t count, u16 offset, u8 reg_width);
+	void (*block_write)(struct bcma_device *core, const void *buffer,
+			    size_t count, u16 offset, u8 reg_width);
+#endif
 	/* Agent ops */
 	u32 (*aread32)(struct bcma_device *core, u16 offset);
 	void (*awrite32)(struct bcma_device *core, u16 offset, u32 value);
@@ -210,6 +216,18 @@ void bcma_write32(struct bcma_device *core, u16 offset, u32 value)
 {
 	core->bus->ops->write32(core, offset, value);
 }
+#ifdef CONFIG_BCMA_BLOCKIO
+extern inline void bcma_block_read(struct bcma_device *core, void *buffer,
+				   size_t count, u16 offset, u8 reg_width)
+{
+	core->bus->ops->block_read(core, buffer, count, offset, reg_width);
+}
+extern inline void bcma_block_write(struct bcma_device *core, const void *buffer,
+				    size_t count, u16 offset, u8 reg_width)
+{
+	core->bus->ops->block_write(core, buffer, count, offset, reg_width);
+}
+#endif
 extern inline u32 bcma_aread32(struct bcma_device *core, u16 offset)
 {
 	return core->bus->ops->aread32(core, offset);
-- 
1.7.3.4

