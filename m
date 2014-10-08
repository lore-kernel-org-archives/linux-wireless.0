Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbaJHIdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 04:33:37 -0400
From: Loic Poulain <loic.poulain@intel.com>
To: johannes@sipsolutions.net, heikki.krogerus@linux.intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Loic Poulain <loic.poulain@intel.com>
Subject: [PATCH 2/5] net: rfkill: gpio: Implement PM hooks
Date: Wed,  8 Oct 2014 10:34:37 +0200
Message-Id: <1412757280-31367-2-git-send-email-loic.poulain@intel.com> (sfid-20141008_103341_494244_C50B4113)
In-Reply-To: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GPIO based rfkill devices should also be put to sleep mode when the
system enters suspend. This patch introduces a wake gpio.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
---
 net/rfkill/rfkill-gpio.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 7982841..29369d6 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -34,6 +34,7 @@ struct rfkill_gpio_data {
 	enum rfkill_type	type;
 	struct gpio_desc	*reset_gpio;
 	struct gpio_desc	*shutdown_gpio;
+	struct gpio_desc	*wake_gpio;
 
 	struct rfkill		*rfkill_dev;
 	struct clk		*clk;
@@ -46,6 +47,7 @@ struct rfkill_gpio_desc {
 
 	int			reset_idx;
 	int			shutdown_idx;
+	int			wake_idx;
 };
 
 static int rfkill_gpio_set_power(void *data, bool blocked)
@@ -57,6 +59,7 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 
 	gpiod_set_value_cansleep(rfkill->shutdown_gpio, !blocked);
 	gpiod_set_value_cansleep(rfkill->reset_gpio, !blocked);
+	gpiod_set_value_cansleep(rfkill->wake_gpio, !blocked);
 
 	if (blocked && !IS_ERR(rfkill->clk) && rfkill->clk_enabled)
 		clk_disable(rfkill->clk);
@@ -112,6 +115,16 @@ static int rfkill_gpio_init(struct device *dev, struct rfkill_gpio_desc *desc)
 		rfkill->shutdown_gpio = gpio;
 	}
 
+	if (desc && (desc->wake_idx >= 0)) {
+		gpio = devm_gpiod_get_index(dev, "wake", desc->wake_idx);
+		if (!IS_ERR(gpio)) {
+			ret = gpiod_direction_output(gpio, 0);
+			if (ret)
+				return ret;
+			rfkill->wake_gpio = gpio;
+		}
+	}
+
 	/* Make sure at-least one of the GPIO is defined */
 	if (!rfkill->reset_gpio && !rfkill->shutdown_gpio) {
 		dev_err(dev, "invalid platform data\n");
@@ -182,6 +195,38 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int rfkill_gpio_suspend(struct device *dev)
+{
+	struct rfkill_gpio_data *rfkill = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "Suspend\n");
+
+	if (!rfkill->clk_enabled)
+		return 0;
+
+	gpiod_set_value_cansleep(rfkill->wake_gpio, 0);
+
+	return 0;
+}
+
+static int rfkill_gpio_resume(struct device *dev)
+{
+	struct rfkill_gpio_data *rfkill = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "Resume\n");
+
+	if (!rfkill->clk_enabled)
+		return 0;
+
+	gpiod_set_value_cansleep(rfkill->wake_gpio, 1);
+
+	return 0;
+}
+#endif
+static SIMPLE_DEV_PM_OPS(rfkill_gpio_pm, rfkill_gpio_suspend,
+			 rfkill_gpio_resume);
+
 static int rfkill_gpio_remove(struct platform_device *pdev)
 {
 	struct rfkill_gpio_data *rfkill = platform_get_drvdata(pdev);
@@ -197,12 +242,14 @@ static struct rfkill_gpio_desc acpi_default_bluetooth = {
 	.type = RFKILL_TYPE_BLUETOOTH,
 	.reset_idx = 0,
 	.shutdown_idx = 1,
+	.wake_idx = -1,
 };
 
 static struct rfkill_gpio_desc acpi_default_gps = {
 	.type = RFKILL_TYPE_GPS,
 	.reset_idx = 0,
 	.shutdown_idx = 1,
+	.wake_idx = -1,
 };
 
 static const struct acpi_device_id rfkill_acpi_match[] = {
@@ -223,6 +270,7 @@ static struct platform_driver rfkill_gpio_driver = {
 	.driver = {
 		.name = "rfkill_gpio",
 		.owner = THIS_MODULE,
+		.pm = &rfkill_gpio_pm,
 		.acpi_match_table = ACPI_PTR(rfkill_acpi_match),
 	},
 };
-- 
1.8.3.2

