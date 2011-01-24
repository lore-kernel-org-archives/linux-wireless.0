Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11730 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AXLML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 06:12:11 -0500
From: aidapalapati@nvidia.com
To: olofj@chromium.org, linville@tuxdriver.com, uraval@nvidia.com,
	krakesh@nvidia.com
Cc: linux-wireless@vger.kernel.org,
	Anantha Idapalapati <aidapalapati@nvidia.com>
Subject: [PATCH 1/1] CHROMIUM: config: bluetooth: rfkill driver
Date: Mon, 24 Jan 2011 16:36:49 +0530
Message-Id: <1295867209-6156-1-git-send-email-aidapalapati@nvidia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anantha Idapalapati <aidapalapati@nvidia.com>

A new "rfkill" driver is added to control BT radio.
A new kernel config variable CONFIG_BT_RFKILL needs to
be configured to include this driver in the kernel.

Three resources are expected by the driver.
One Shutdown GPIO, One Reset Gpio and One reference Clock.
if any/all of the resources can be defined by a platform.

BUG=none
TEST= tested on board that used BCM4329 (ventana)

Change-Id: Ie893e2ba204197b82ec2c5339b830b05cb180170
Signed-off-by: Anantha Idapalapati <aidapalapati@nvidia.com>

Review URL:http://codereview.chromium.org/6295009/
---
 drivers/misc/Kconfig     |    8 ++
 drivers/misc/Makefile    |    1 +
 drivers/misc/bt_rfkill.c |  194 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 203 insertions(+), 0 deletions(-)
 create mode 100755 drivers/misc/bt_rfkill.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b743312..c84ec51 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -390,6 +390,14 @@ config BMP085
 	  To compile this driver as a module, choose M here: the
 	  module will be called bmp085.
 
+config BT_RFKILL
+	bool "Bluetooth RFKILL driver"
+	depends on BT && RFKILL
+	help
+	  If you say yes here you get support of a generic bluetooth RFKILL
+	  driver for BT chipset. Platform needs to define the resources
+	  required.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 42eab95..2621dff 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -34,4 +34,5 @@ obj-$(CONFIG_HMC6352)		+= hmc6352.o
 obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
+obj-$(CONFIG_BT_RFKILL)  	+= bt_rfkill.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
diff --git a/drivers/misc/bt_rfkill.c b/drivers/misc/bt_rfkill.c
new file mode 100755
index 0000000..2d62882
--- /dev/null
+++ b/drivers/misc/bt_rfkill.c
@@ -0,0 +1,194 @@
+/*
+ * Copyright (c) 2010, NVIDIA Corporation.
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
+		tegra_gpio_enable(bt_rfkill->gpio_reset);
+		ret = gpio_request(bt_rfkill->gpio_reset,
+						"bt_nreset_gpio");
+	} else {
+		pr_warn("%s : can't find reset gpio.\n", __func__);
+		bt_rfkill->gpio_reset = 0;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_IO,
+						"bt_nshutdown_gpio");
+	if (res) {
+		bt_rfkill->gpio_shutdown = res->start;
+		tegra_gpio_enable(bt_rfkill->gpio_shutdown);
+		ret = gpio_request(bt_rfkill->gpio_shutdown,
+						"bt_nshutdown_gpio");
+	} else {
+		pr_warn("%s : can't find shutdown gpio.\n", __func__);
+		bt_rfkill->gpio_shutdown = 0;
+	}
+
+	/* make sure at-least one of the GPIO is defined */
+	if (!bt_rfkill->gpio_reset && !bt_rfkill->gpio_shutdown)
+		goto free_bcm_res;
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
1.7.3.5


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
