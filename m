Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:41423 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbeBTNq2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 08:46:28 -0500
Received: by mail-wr0-f195.google.com with SMTP id f14so10100085wre.8
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 05:46:27 -0800 (PST)
From: Carlo Caione <carlo@caione.org>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        frederic.danis.oss@gmail.com, sebastian.reichel@collabora.co.uk,
        rafael.j.wysocki@intel.com, hdegoede@redhat.com, linux@endlessm.com
Cc: Carlo Caione <carlo@endlessm.com>
Subject: [RFC PATCH 2/2] net: rfkill: gpio: Convert driver to SerDev
Date: Tue, 20 Feb 2018 13:46:18 +0000
Message-Id: <20180220134618.12972-3-carlo@caione.org> (sfid-20180220_144651_265659_32E62165)
In-Reply-To: <20180220134618.12972-1-carlo@caione.org>
References: <20180220134618.12972-1-carlo@caione.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Carlo Caione <carlo@endlessm.com>

With commit e361d1f85855 ("ACPI / scan: Fix enumeration for special UART
devices") UART devices are now expected to be enumerated by
SerDev subsystem. This is breaking the enumeration of platform devices
connected to the UART without a proper SerDev support, like in the
rfkill-gpio case.

Fix this moving the driver from a platform driver to a serdev device
driver.

Signed-off-by: Carlo Caione <carlo@endlessm.com>
---
 net/rfkill/Kconfig       |  1 +
 net/rfkill/rfkill-gpio.c | 46 ++++++++++++++++++++++++----------------------
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
index 060600b03fad..14ee289328d7 100644
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -27,6 +27,7 @@ config RFKILL_GPIO
 	tristate "GPIO RFKILL driver"
 	depends on RFKILL
 	depends on GPIOLIB || COMPILE_TEST
+	depends on SERIAL_DEV_CTRL_TTYPORT
 	default n
 	help
 	  If you say yes here you get support of a generic gpio RFKILL
diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 659d2edae972..d7553f3c3ae7 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -23,11 +23,13 @@
 #include <linux/rfkill.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/serdev.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/gpio/consumer.h>
 
 struct rfkill_gpio_data {
+	struct device		*dev;
 	const char		*name;
 	enum rfkill_type	type;
 	struct gpio_desc	*reset_gpio;
@@ -84,40 +86,42 @@ static int rfkill_gpio_acpi_probe(struct device *dev,
 	return devm_acpi_dev_add_driver_gpios(dev, acpi_rfkill_default_gpios);
 }
 
-static int rfkill_gpio_probe(struct platform_device *pdev)
+static int rfkill_gpio_serdev_probe(struct serdev_device *serdev)
 {
 	struct rfkill_gpio_data *rfkill;
 	struct gpio_desc *gpio;
 	const char *type_name = NULL;
 	int ret;
 
-	rfkill = devm_kzalloc(&pdev->dev, sizeof(*rfkill), GFP_KERNEL);
+	rfkill = devm_kzalloc(&serdev->dev, sizeof(*rfkill), GFP_KERNEL);
 	if (!rfkill)
 		return -ENOMEM;
 
-	device_property_read_string(&pdev->dev, "name", &rfkill->name);
-	device_property_read_string(&pdev->dev, "type", &type_name);
+	rfkill->dev = &serdev->dev;
+
+	device_property_read_string(rfkill->dev, "name", &rfkill->name);
+	device_property_read_string(rfkill->dev, "type", &type_name);
 
 	if (!rfkill->name)
-		rfkill->name = dev_name(&pdev->dev);
+		rfkill->name = dev_name(rfkill->dev);
 
 	rfkill->type = rfkill_find_type(type_name);
 
-	if (ACPI_HANDLE(&pdev->dev)) {
-		ret = rfkill_gpio_acpi_probe(&pdev->dev, rfkill);
+	if (ACPI_HANDLE(rfkill->dev)) {
+		ret = rfkill_gpio_acpi_probe(rfkill->dev, rfkill);
 		if (ret)
 			return ret;
 	}
 
-	rfkill->clk = devm_clk_get(&pdev->dev, NULL);
+	rfkill->clk = devm_clk_get(rfkill->dev, NULL);
 
-	gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_OUT_LOW);
+	gpio = devm_gpiod_get_optional(rfkill->dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(gpio))
 		return PTR_ERR(gpio);
 
 	rfkill->reset_gpio = gpio;
 
-	gpio = devm_gpiod_get_optional(&pdev->dev, "shutdown", GPIOD_OUT_LOW);
+	gpio = devm_gpiod_get_optional(rfkill->dev, "shutdown", GPIOD_OUT_LOW);
 	if (IS_ERR(gpio))
 		return PTR_ERR(gpio);
 
@@ -125,11 +129,11 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 
 	/* Make sure at-least one GPIO is defined for this instance */
 	if (!rfkill->reset_gpio && !rfkill->shutdown_gpio) {
-		dev_err(&pdev->dev, "invalid platform data\n");
+		dev_err(rfkill->dev, "invalid platform data\n");
 		return -EINVAL;
 	}
 
-	rfkill->rfkill_dev = rfkill_alloc(rfkill->name, &pdev->dev,
+	rfkill->rfkill_dev = rfkill_alloc(rfkill->name, rfkill->dev,
 					  rfkill->type, &rfkill_gpio_ops,
 					  rfkill);
 	if (!rfkill->rfkill_dev)
@@ -139,21 +143,19 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	platform_set_drvdata(pdev, rfkill);
+	serdev_device_set_drvdata(serdev, rfkill);
 
-	dev_info(&pdev->dev, "%s device registered.\n", rfkill->name);
+	dev_info(rfkill->dev, "%s device registered.\n", rfkill->name);
 
 	return 0;
 }
 
-static int rfkill_gpio_remove(struct platform_device *pdev)
+static void rfkill_gpio_serdev_remove(struct serdev_device *serdev)
 {
-	struct rfkill_gpio_data *rfkill = platform_get_drvdata(pdev);
+	struct rfkill_gpio_data *rfkill = serdev_device_get_drvdata(serdev);
 
 	rfkill_unregister(rfkill->rfkill_dev);
 	rfkill_destroy(rfkill->rfkill_dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_ACPI
@@ -165,16 +167,16 @@ static const struct acpi_device_id rfkill_acpi_match[] = {
 MODULE_DEVICE_TABLE(acpi, rfkill_acpi_match);
 #endif
 
-static struct platform_driver rfkill_gpio_driver = {
-	.probe = rfkill_gpio_probe,
-	.remove = rfkill_gpio_remove,
+static struct serdev_device_driver rfkill_gpio_serdev_driver = {
+	.probe = rfkill_gpio_serdev_probe,
+	.remove = rfkill_gpio_serdev_remove,
 	.driver = {
 		.name = "rfkill_gpio",
 		.acpi_match_table = ACPI_PTR(rfkill_acpi_match),
 	},
 };
 
-module_platform_driver(rfkill_gpio_driver);
+module_serdev_device_driver(rfkill_gpio_serdev_driver);
 
 MODULE_DESCRIPTION("gpio rfkill");
 MODULE_AUTHOR("NVIDIA");
-- 
2.14.1
