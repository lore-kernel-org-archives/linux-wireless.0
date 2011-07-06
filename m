Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39715 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1GFQZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 12:25:46 -0400
Received: by fxd18 with SMTP id 18so244763fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 09:25:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2 V2] b43: implement BCMA bus ops
Date: Wed,  6 Jul 2011 19:03:46 +0200
Message-Id: <1309971826-8124-2-git-send-email-zajec5@gmail.com> (sfid-20110706_182550_069042_2D834BAC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: dropped inline, thanks Michael
---
 drivers/net/wireless/b43/bus.c  |  100 +++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/bus.h  |    3 +
 drivers/net/wireless/b43/main.c |    7 +++
 3 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 4200713..c45c76d 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -23,6 +23,106 @@
 #include "b43.h"
 #include "bus.h"
 
+/* BCMA */
+#ifdef CONFIG_B43_BCMA
+static int b43_bus_bcma_bus_may_powerdown(struct b43_bus_dev *dev)
+{
+	return 0; /* bcma_bus_may_powerdown(dev->bdev->bus); */
+}
+static int b43_bus_bcma_bus_powerup(struct b43_bus_dev *dev,
+					  bool dynamic_pctl)
+{
+	return 0; /* bcma_bus_powerup(dev->sdev->bus, dynamic_pctl); */
+}
+static int b43_bus_bcma_device_is_enabled(struct b43_bus_dev *dev)
+{
+	return bcma_core_is_enabled(dev->bdev);
+}
+static void b43_bus_bcma_device_enable(struct b43_bus_dev *dev,
+					     u32 core_specific_flags)
+{
+	bcma_core_enable(dev->bdev, core_specific_flags);
+}
+static void b43_bus_bcma_device_disable(struct b43_bus_dev *dev,
+					      u32 core_specific_flags)
+{
+	bcma_core_disable(dev->bdev, core_specific_flags);
+}
+static u16 b43_bus_bcma_read16(struct b43_bus_dev *dev, u16 offset)
+{
+	return bcma_read16(dev->bdev, offset);
+}
+static u32 b43_bus_bcma_read32(struct b43_bus_dev *dev, u16 offset)
+{
+	return bcma_read32(dev->bdev, offset);
+}
+static
+void b43_bus_bcma_write16(struct b43_bus_dev *dev, u16 offset, u16 value)
+{
+	bcma_write16(dev->bdev, offset, value);
+}
+static
+void b43_bus_bcma_write32(struct b43_bus_dev *dev, u16 offset, u32 value)
+{
+	bcma_write32(dev->bdev, offset, value);
+}
+static
+void b43_bus_bcma_block_read(struct b43_bus_dev *dev, void *buffer,
+			     size_t count, u16 offset, u8 reg_width)
+{
+	bcma_block_read(dev->bdev, buffer, count, offset, reg_width);
+}
+static
+void b43_bus_bcma_block_write(struct b43_bus_dev *dev, const void *buffer,
+			      size_t count, u16 offset, u8 reg_width)
+{
+	bcma_block_write(dev->bdev, buffer, count, offset, reg_width);
+}
+
+struct b43_bus_dev *b43_bus_dev_bcma_init(struct bcma_device *core)
+{
+	struct b43_bus_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	dev->bus_type = B43_BUS_BCMA;
+	dev->bdev = core;
+
+	dev->bus_may_powerdown = b43_bus_bcma_bus_may_powerdown;
+	dev->bus_powerup = b43_bus_bcma_bus_powerup;
+	dev->device_is_enabled = b43_bus_bcma_device_is_enabled;
+	dev->device_enable = b43_bus_bcma_device_enable;
+	dev->device_disable = b43_bus_bcma_device_disable;
+
+	dev->read16 = b43_bus_bcma_read16;
+	dev->read32 = b43_bus_bcma_read32;
+	dev->write16 = b43_bus_bcma_write16;
+	dev->write32 = b43_bus_bcma_write32;
+	dev->block_read = b43_bus_bcma_block_read;
+	dev->block_write = b43_bus_bcma_block_write;
+
+	dev->dev = &core->dev;
+	dev->dma_dev = core->dma_dev;
+	dev->irq = core->irq;
+
+	/*
+	dev->board_vendor = core->bus->boardinfo.vendor;
+	dev->board_type = core->bus->boardinfo.type;
+	dev->board_rev = core->bus->boardinfo.rev;
+	*/
+
+	dev->chip_id = core->bus->chipinfo.id;
+	dev->chip_rev = core->bus->chipinfo.rev;
+	dev->chip_pkg = core->bus->chipinfo.pkg;
+
+	dev->bus_sprom = &core->bus->sprom;
+
+	dev->core_id = core->id.id;
+	dev->core_rev = core->id.rev;
+
+	return dev;
+}
+#endif /* CONFIG_B43_BCMA */
 
 /* SSB */
 #ifdef CONFIG_B43_SSB
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index 79a5ab4..a70b7b9 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -2,12 +2,14 @@
 #define B43_BUS_H_
 
 enum b43_bus_type {
+	B43_BUS_BCMA,
 	B43_BUS_SSB,
 };
 
 struct b43_bus_dev {
 	enum b43_bus_type bus_type;
 	union {
+		struct bcma_device *bdev;
 		struct ssb_device *sdev;
 	};
 
@@ -57,6 +59,7 @@ static inline bool b43_bus_host_is_sdio(struct b43_bus_dev *dev)
 		dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO);
 }
 
+struct b43_bus_dev *b43_bus_dev_bcma_init(struct bcma_device *core);
 struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev);
 
 #endif /* B43_BUS_H_ */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 410b77f..b85a973 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5010,7 +5010,14 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 #ifdef CONFIG_B43_BCMA
 static int b43_bcma_probe(struct bcma_device *core)
 {
+	struct b43_bus_dev *dev;
+
+	dev = b43_bus_dev_bcma_init(core);
+	if (!dev)
+		return -ENODEV;
+
 	b43err(NULL, "BCMA is not supported yet!");
+	kfree(dev);
 	return -EOPNOTSUPP;
 }
 
-- 
1.7.3.4

