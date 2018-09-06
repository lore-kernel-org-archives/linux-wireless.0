Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728211AbeIFNzG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:55:06 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 37/42] mt76x0: inital split between pci and usb
Date: Thu,  6 Sep 2018 11:18:53 +0200
Message-Id: <1536225538-16454-38-git-send-email-sgruszka@redhat.com> (sfid-20180906_112037_280417_DA76488F)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For now pci driver can read ASIC version from the device :-)

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig         | 23 ++++--
 drivers/net/wireless/mediatek/mt76/Makefile        |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile | 11 ++-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  6 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  7 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    | 81 ++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  6 --
 9 files changed, 121 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 6a270e759006..e460a3a5e763 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -7,25 +7,35 @@ config MT76_USB
 
 config MT76x02_LIB
 	tristate
-	depends on MT76_CORE
+	select MT76_CORE
+
+config MT76x0_COMMON
+	tristate
+	select MT76x02_LIB
 
 config MT76x2_COMMON
 	tristate
 	select MT76x02_LIB
-	depends on MT76_CORE
 
 config MT76x0U
 	tristate "MediaTek MT76x0U (USB) support"
-	select MT76_CORE
+	select MT76x0_COMMON
+	select MT76_USB
 	depends on MAC80211
 	depends on USB
-	select MT76x02_LIB
 	help
 	  This adds support for MT7610U-based wireless USB dongles.
 
+config MT76x0E
+	tristate "MediaTek MT76x0E (PCIe) support"
+	select MT76x0_COMMON
+	depends on MAC80211
+	depends on PCI
+	help
+	  This adds support for MT7610/MT7630-based wireless PCIe devices.
+
 config MT76x2E
 	tristate "MediaTek MT76x2E (PCIe) support"
-	select MT76_CORE
 	select MT76x2_COMMON
 	depends on MAC80211
 	depends on PCI
@@ -34,9 +44,8 @@ config MT76x2E
 
 config MT76x2U
 	tristate "MediaTek MT76x2U (USB) support"
-	select MT76_CORE
-	select MT76_USB
 	select MT76x2_COMMON
+	select MT76_USB
 	depends on MAC80211
 	depends on USB
 	help
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index a7fe5d6da857..129ac71446d6 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_MT76_CORE) += mt76.o
 obj-$(CONFIG_MT76_USB) += mt76-usb.o
-obj-$(CONFIG_MT76x0U) += mt76x0/
+obj-$(CONFIG_MT76x0_COMMON) += mt76x0/
 obj-$(CONFIG_MT76x02_LIB) += mt76x02-lib.o
 obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index df70690e3aff..644c867c107a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -1,7 +1,12 @@
-obj-$(CONFIG_MT76x0U)    += mt76x0.o
+obj-$(CONFIG_MT76x0U) += mt76x0u.o
+obj-$(CONFIG_MT76x0E) += mt76x0e.o
+obj-$(CONFIG_MT76x0_COMMON) += mt76x0-common.o
 
-mt76x0-objs	= \
-	usb.o init.o main.o mcu.o trace.o eeprom.o phy.o \
+mt76x0-common-y := \
+	init.o main.o mcu.o trace.o eeprom.o phy.o \
 	mac.o debugfs.o tx.o
+mt76x0u-y := usb.o
+mt76x0e-y := pci.o
+
 # ccflags-y := -DDEBUG
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 2ce27de511f5..79856bde1632 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -445,3 +445,5 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	kfree(eeprom);
 	return ret;
 }
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 44fcad2315a7..0e4a13fa42cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -111,6 +111,7 @@ void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset)
 
 	mutex_unlock(&dev->hw_atomic_mutex);
 }
+EXPORT_SYMBOL_GPL(mt76x0_chip_onoff);
 
 static void mt76x0_reset_csr_bbp(struct mt76x0_dev *dev)
 {
@@ -384,6 +385,7 @@ void mt76x0_mac_stop(struct mt76x0_dev *dev)
 	mt76u_stop_stat_wk(&dev->mt76);
 	mt76x0_mac_stop_hw(dev);
 }
+EXPORT_SYMBOL_GPL(mt76x0_mac_stop);
 
 int mt76x0_init_hardware(struct mt76x0_dev *dev)
 {
@@ -469,6 +471,7 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt76x0_init_hardware);
 
 void mt76x0_cleanup(struct mt76x0_dev *dev)
 {
@@ -477,6 +480,7 @@ void mt76x0_cleanup(struct mt76x0_dev *dev)
 	mt76u_queues_deinit(&dev->mt76);
 	mt76u_mcu_deinit(&dev->mt76);
 }
+EXPORT_SYMBOL_GPL(mt76x0_cleanup);
 
 struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 {
@@ -505,6 +509,7 @@ struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 
 	return dev;
 }
+EXPORT_SYMBOL_GPL(mt76x0_alloc_device);
 
 int mt76x0_register_device(struct mt76x0_dev *dev)
 {
@@ -569,3 +574,4 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt76x0_register_device);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 0d3c7accb4f8..c84e00abfac9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -72,6 +72,13 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 }
 
 static void
+mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr)
+{
+	mt76_wr(dev, offset, get_unaligned_le32(addr));
+	mt76_wr(dev, offset + 4, addr[4] | addr[5] << 8);
+}
+
+static void
 mt76x0_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_bss_conf *info, u32 changed)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 2918abc95c71..d775d9951695 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -141,7 +141,6 @@ int mt76x0_read_reg_pairs(struct mt76x0_dev *dev, u32 base,
 			  struct mt76_reg_pair *data, int len);
 int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 			     const u32 *data, int n);
-void mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr);
 
 /* Init */
 struct mt76x0_dev *mt76x0_alloc_device(struct device *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
new file mode 100644
index 000000000000..244ab64560a6
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "mt76x0.h"
+
+static int
+mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct mt76x0_dev *dev;
+	int ret = -ENODEV;
+
+	ret = pcim_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
+	if (ret)
+		return ret;
+
+	pci_set_master(pdev);
+
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
+	dev = mt76x0_alloc_device(&pdev->dev);
+	if (!dev)
+		return -ENOMEM;
+
+	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
+
+	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
+	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
+
+/* error: */
+	ieee80211_free_hw(mt76_hw(dev));
+	return ret;
+}
+
+static void
+mt76x0e_remove(struct pci_dev *pdev)
+{
+	struct mt76_dev *mdev = pci_get_drvdata(pdev);
+
+	mt76_unregister_device(mdev);
+	ieee80211_free_hw(mdev->hw);
+}
+
+static const struct pci_device_id mt76x0e_device_table[] = {
+	{ PCI_DEVICE(0x14c3, 0x7630) },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(pci, mt76x0e_device_table);
+MODULE_LICENSE("Dual BSD/GPL");
+
+static struct pci_driver mt76x0e_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= mt76x0e_device_table,
+	.probe		= mt76x0e_probe,
+	.remove		= mt76x0e_remove,
+};
+
+module_pci_driver(mt76x0e_driver);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index fc8884c38f7e..b9382092f47f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -46,12 +46,6 @@ static struct usb_device_id mt76x0_device_table[] = {
 	{ 0, }
 };
 
-void mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr)
-{
-	mt76_wr(dev, offset, get_unaligned_le32(addr));
-	mt76_wr(dev, offset + 4, addr[4] | addr[5] << 8);
-}
-
 static int mt76x0_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
-- 
2.7.5
