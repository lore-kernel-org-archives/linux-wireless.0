Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:48340 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZJOUFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 16:05:04 -0400
Received: by ewy4 with SMTP id 4so930151ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2009 13:04:27 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/2] rt2x00: Add rt2x00soc bus module
Date: Thu, 15 Oct 2009 21:38:19 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
Message-Id: <200910152138.19777.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new library module for SoC drivers.
This is needed to fully support the platform
driver part of rt2800pci.

Based on original patch from Felix.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |    4 +
 drivers/net/wireless/rt2x00/Makefile    |    1 +
 drivers/net/wireless/rt2x00/rt2x00soc.c |  159 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00soc.h |   52 ++++++++++
 4 files changed, 216 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00soc.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00soc.h

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index ed1f997..e86895a 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -95,6 +95,10 @@ config RT2X00_LIB_PCI
 	tristate
 	select RT2X00_LIB
 
+config RT2X00_LIB_SOC
+	tristate
+	select RT2X00_LIB
+
 config RT2X00_LIB_USB
 	tristate
 	select RT2X00_LIB
diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
index 13043ea..5b1ee4f 100644
--- a/drivers/net/wireless/rt2x00/Makefile
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -11,6 +11,7 @@ rt2x00lib-$(CONFIG_RT2X00_LIB_HT)	+= rt2x00ht.o
 
 obj-$(CONFIG_RT2X00_LIB)		+= rt2x00lib.o
 obj-$(CONFIG_RT2X00_LIB_PCI)		+= rt2x00pci.o
+obj-$(CONFIG_RT2X00_LIB_SOC)		+= rt2x00soc.o
 obj-$(CONFIG_RT2X00_LIB_USB)		+= rt2x00usb.o
 obj-$(CONFIG_RT2400PCI)			+= rt2400pci.o
 obj-$(CONFIG_RT2500PCI)			+= rt2500pci.o
diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
new file mode 100644
index 0000000..539568c
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
@@ -0,0 +1,159 @@
+/*
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00soc
+	Abstract: rt2x00 generic soc device routines.
+ */
+
+#include <linux/bug.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include "rt2x00.h"
+#include "rt2x00soc.h"
+
+static void rt2x00soc_free_reg(struct rt2x00_dev *rt2x00dev)
+{
+	kfree(rt2x00dev->rf);
+	rt2x00dev->rf = NULL;
+
+	kfree(rt2x00dev->eeprom);
+	rt2x00dev->eeprom = NULL;
+}
+
+static int rt2x00soc_alloc_reg(struct rt2x00_dev *rt2x00dev)
+{
+	struct platform_device *pdev = to_platform_device(rt2x00dev->dev);
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	rt2x00dev->csr.base = (void __iomem *)KSEG1ADDR(res->start);
+	if (!rt2x00dev->csr.base)
+		goto exit;
+
+	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
+	if (!rt2x00dev->eeprom)
+		goto exit;
+
+	rt2x00dev->rf = kzalloc(rt2x00dev->ops->rf_size, GFP_KERNEL);
+	if (!rt2x00dev->rf)
+		goto exit;
+
+	return 0;
+
+exit:
+	ERROR_PROBE("Failed to allocate registers.\n");
+	rt2x00soc_free_reg(rt2x00dev);
+
+	return -ENOMEM;
+}
+
+int rt2x00soc_probe(struct platform_device *pdev,
+		    const unsigned short chipset,
+		    const struct rt2x00_ops *ops)
+{
+	struct ieee80211_hw *hw;
+	struct rt2x00_dev *rt2x00dev;
+	int retval;
+
+	hw = ieee80211_alloc_hw(sizeof(struct rt2x00_dev), ops->hw);
+	if (!hw) {
+		ERROR_PROBE("Failed to allocate hardware.\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, hw);
+
+	rt2x00dev = hw->priv;
+	rt2x00dev->dev = &pdev->dev;
+	rt2x00dev->ops = ops;
+	rt2x00dev->hw = hw;
+	rt2x00dev->irq = platform_get_irq(pdev, 0);
+	rt2x00dev->name = pdev->dev.driver->name;
+
+	rt2x00_set_chip_rt(rt2x00dev, chipset);
+
+	retval = rt2x00soc_alloc_reg(rt2x00dev);
+	if (retval)
+		goto exit_free_device;
+
+	retval = rt2x00lib_probe_dev(rt2x00dev);
+	if (retval)
+		goto exit_free_reg;
+
+	return 0;
+
+exit_free_reg:
+	rt2x00soc_free_reg(rt2x00dev);
+
+exit_free_device:
+	ieee80211_free_hw(hw);
+
+	return retval;
+}
+
+int rt2x00soc_remove(struct platform_device *pdev)
+{
+	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	/*
+	 * Free all allocated data.
+	 */
+	rt2x00lib_remove_dev(rt2x00dev);
+	rt2x00soc_free_reg(rt2x00dev);
+	ieee80211_free_hw(hw);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00soc_remove);
+
+#ifdef CONFIG_PM
+int rt2x00soc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	return rt2x00lib_suspend(rt2x00dev, state);
+}
+EXPORT_SYMBOL_GPL(rt2x00soc_suspend);
+
+int rt2x00soc_resume(struct platform_device *pdev)
+{
+	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	return rt2x00lib_resume(rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2x00soc_resume);
+#endif /* CONFIG_PM */
+
+/*
+ * rt2x00soc module information.
+ */
+MODULE_AUTHOR(DRV_PROJECT);
+MODULE_VERSION(DRV_VERSION);
+MODULE_DESCRIPTION("rt2x00 soc library");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.h b/drivers/net/wireless/rt2x00/rt2x00soc.h
new file mode 100644
index 0000000..5cf114a
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.h
@@ -0,0 +1,52 @@
+/*
+	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00soc
+	Abstract: Data structures for the rt2x00soc module.
+ */
+
+#ifndef RT2X00SOC_H
+#define RT2X00SOC_H
+
+#define KSEG1ADDR(__ptr) __ptr
+
+#define __rt2x00soc_probe(__chipset, __ops) \
+static int __rt2x00soc_probe(struct platform_device *pdev) \
+{ \
+	return rt2x00soc_probe(pdev, (__chipset), (__ops)); \
+}
+
+/*
+ * SoC driver handlers.
+ */
+int rt2x00soc_probe(struct platform_device *pdev,
+		    const unsigned short chipset,
+		    const struct rt2x00_ops *ops);
+int rt2x00soc_remove(struct platform_device *pdev);
+#ifdef CONFIG_PM
+int rt2x00soc_suspend(struct platform_device *pdev, pm_message_t state);
+int rt2x00soc_resume(struct platform_device *pdev);
+#else
+#define rt2x00soc_suspend	NULL
+#define rt2x00soc_resume	NULL
+#endif /* CONFIG_PM */
+
+#endif /* RT2X00SOC_H */
-- 
1.6.4.1

