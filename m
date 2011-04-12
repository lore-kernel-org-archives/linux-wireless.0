Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10870 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1DLL3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:29:00 -0400
From: aidapalapati@nvidia.com
To: olofj@chromium.org, linville@tuxdriver.com, uraval@nvidia.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	aidapalapati@nvidia.com, aritger@nvidia.com, krakesh@nvidia.com
Subject: [PATCH] CHROMIUM: config: bluetooth: rfkill driver
Date: Tue, 12 Apr 2011 16:55:28 +0530
Message-Id: <1302607528-8773-1-git-send-email-aidapalapati@nvidia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anantha Idapalapati <aidapalapati@nvidia.com>

Initial version of new "rfkill" driver to control BT radio.
A new kernel config variable CONFIG_BT_RFKILL is defined and
need to be used to include this driver in the kernel.

Three Platform resources are expected by the driver.
 - Shutdown GPIO
 - Reset GPIO and
 - Reference Clock.
Any/All of the resources can be defined by a platform.

BUG=none
TEST= tested on board using BCM4329 (ventana)

Change-Id: I38e6ad3a772180b7cab5cf2d59b459b21051817e

Signed-off-by: Anantha Idapalapati <aidapalapati@nvidia.com>
---
 drivers/bluetooth/Kconfig     |    8 ++
 drivers/bluetooth/Makefile    |    1 +
 drivers/bluetooth/bt_rfkill.c |  194 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 203 insertions(+), 0 deletions(-)
 create mode 100644 drivers/bluetooth/bt_rfkill.c

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 02deef4..4858583 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -219,4 +219,12 @@ config BT_ATH3K
 	  Say Y here to compile support for "Atheros firmware download driver"
 	  into the kernel or say M to compile it as module (ath3k).
 
+config BT_RFKILL
+	bool "Bluetooth RFKILL driver"
+	depends on BT && RFKILL
+	help
+	  If you say yes here you get support of a generic bluetooth RFKILL
+	  driver for BT chipset. Platform needs to define the resources
+	  required.
+
 endmenu
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index 71bdf13..edce746 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_BT_HCIBTUART)	+= btuart_cs.o
 
 obj-$(CONFIG_BT_HCIBTUSB)	+= btusb.o
 obj-$(CONFIG_BT_HCIBTSDIO)	+= btsdio.o
+obj-$(CONFIG_BT_RFKILL) 	+= bt_rfkill.o
 
 obj-$(CONFIG_BT_ATH3K)		+= ath3k.o
 obj-$(CONFIG_BT_MRVL)		+= btmrvl.o
diff --git a/drivers/bluetooth/bt_rfkill.c b/drivers/bluetooth/bt_rfkill.c
new file mode 100644
index 0000000..1e48c1c
--- /dev/null
+++ b/drivers/bluetooth/bt_rfkill.c
@@ -0,0 +1,194 @@
+/*
+ * Copyright (c) 2011, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/err.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/rfkill.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+
+struct bt_rfkill_data {
+	int gpio_reset;
+	int gpio_shutdown;
+	int delay;
+	struct clk *bt_clk;
+};
+
+static struct bt_rfkill_data *bt_rfkill;
+
+static int bt_rfkill_set_power(void *data, bool blocked)
+{
+	if (blocked) {
+		if (bt_rfkill->gpio_shutdown)
+			gpio_direction_output(bt_rfkill->gpio_shutdown, 0);
+		if (bt_rfkill->gpio_reset)
+			gpio_direction_output(bt_rfkill->gpio_reset, 0);
+		if (bt_rfkill->bt_clk)
+			clk_disable(bt_rfkill->bt_clk);
+	} else {
+		if (bt_rfkill->bt_clk)
+			clk_enable(bt_rfkill->bt_clk);
+		if (bt_rfkill->gpio_shutdown)
+			gpio_direction_output(bt_rfkill->gpio_shutdown, 1);
+		if (bt_rfkill->gpio_reset)
+			gpio_direction_output(bt_rfkill->gpio_reset, 1);
+	}
+
+	return 0;
+}
+
+static const struct rfkill_ops bt_rfkill_ops = {
+	.set_block = bt_rfkill_set_power,
+};
+
+static int bt_rfkill_probe(struct platform_device *pdev)
+{
+	struct rfkill *bt_rfkill_dev;
+	struct resource *res;
+	int ret;
+	bool enable = false;  /* off */
+	bool default_sw_block_state;
+
+	bt_rfkill = kzalloc(sizeof(*bt_rfkill), GFP_KERNEL);
+	if (!bt_rfkill)
+		return -ENOMEM;
+
+	bt_rfkill->bt_clk = clk_get(&pdev->dev, "bt_clk");
+	if (IS_ERR(bt_rfkill->bt_clk)) {
+		pr_warn("%s: can't find bt_clk.\
+				assuming clock to chip\n", __func__);
+		bt_rfkill->bt_clk = NULL;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_IO,
+						"bt_nreset_gpio");
+	if (res) {
+		bt_rfkill->gpio_reset = res->start;
+		ret = gpio_request(bt_rfkill->gpio_reset,
+						"bt_nreset_gpio");
+	} else {
+		pr_warn("%s : can't find reset gpio\n", __func__);
+		bt_rfkill->gpio_reset = 0;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_IO,
+						"bt_nshutdown_gpio");
+	if (res) {
+		bt_rfkill->gpio_shutdown = res->start;
+		ret = gpio_request(bt_rfkill->gpio_shutdown,
+						"bt_nshutdown_gpio");
+	} else {
+		pr_warn("%s : can't find shutdown gpio\n", __func__);
+		bt_rfkill->gpio_shutdown = 0;
+	}
+
+	/* make sure at-least one of the GPIO is defined */
+	if (!bt_rfkill->gpio_reset && !bt_rfkill->gpio_shutdown) {
+		pr_err("%s:neither reset nor shutdown gpio defined\n", __func__);
+		goto free_bcm_res;
+	}
+
+	if (bt_rfkill->bt_clk && enable)
+		clk_enable(bt_rfkill->bt_clk);
+	if (bt_rfkill->gpio_shutdown)
+		gpio_direction_output(bt_rfkill->gpio_shutdown, enable);
+	if (bt_rfkill->gpio_reset)
+		gpio_direction_output(bt_rfkill->gpio_reset, enable);
+
+	bt_rfkill_dev = rfkill_alloc("bt dev rfkill", &pdev->dev,
+				RFKILL_TYPE_BLUETOOTH, &bt_rfkill_ops,
+				NULL);
+
+	if (unlikely(!bt_rfkill_dev))
+		goto free_bcm_res;
+
+	default_sw_block_state = !enable;
+	rfkill_set_states(bt_rfkill_dev, default_sw_block_state, false);
+
+	ret = rfkill_register(bt_rfkill_dev);
+
+	if (unlikely(ret)) {
+		rfkill_destroy(bt_rfkill_dev);
+		goto free_bcm_res;
+	}
+
+	return 0;
+
+free_bcm_res:
+	if (bt_rfkill->gpio_shutdown)
+		gpio_free(bt_rfkill->gpio_shutdown);
+	if (bt_rfkill->gpio_reset)
+		gpio_free(bt_rfkill->gpio_reset);
+	if (bt_rfkill->bt_clk && enable)
+		clk_disable(bt_rfkill->bt_clk);
+	if (bt_rfkill->bt_clk)
+		clk_put(bt_rfkill->bt_clk);
+	kfree(bt_rfkill);
+	return -ENODEV;
+}
+
+static int bt_rfkill_remove(struct platform_device *pdev)
+{
+	struct rfkill *bt_rfkill_dev = platform_get_drvdata(pdev);
+
+	rfkill_unregister(bt_rfkill_dev);
+	rfkill_destroy(bt_rfkill_dev);
+	if (bt_rfkill->bt_clk)
+		clk_put(bt_rfkill->bt_clk);
+	if (bt_rfkill->gpio_shutdown)
+		gpio_free(bt_rfkill->gpio_shutdown);
+	if (bt_rfkill->gpio_reset)
+		gpio_free(bt_rfkill->gpio_reset);
+	kfree(bt_rfkill);
+
+	return 0;
+}
+
+static struct platform_driver bt_rfkill_driver = {
+	.probe = bt_rfkill_probe,
+	.remove = bt_rfkill_remove,
+	.driver = {
+		   .name = "bt_rfkill",
+		   .owner = THIS_MODULE,
+	},
+};
+
+static int __init bt_rfkill_init(void)
+{
+	return platform_driver_register(&bt_rfkill_driver);
+}
+
+static void __exit bt_rfkill_exit(void)
+{
+	platform_driver_unregister(&bt_rfkill_driver);
+}
+
+module_init(bt_rfkill_init);
+module_exit(bt_rfkill_exit);
+
+MODULE_DESCRIPTION("bt rfkill");
+MODULE_AUTHOR("NVIDIA");
+MODULE_LICENSE("GPL");
-- 
1.7.4.3


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
