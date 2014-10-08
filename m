Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbaJHIdj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 04:33:39 -0400
From: Loic Poulain <loic.poulain@intel.com>
To: johannes@sipsolutions.net, heikki.krogerus@linux.intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Loic Poulain <loic.poulain@intel.com>
Subject: [PATCH 3/5] net: rfkill: gpio: Implement host wake up support
Date: Wed,  8 Oct 2014 10:34:38 +0200
Message-Id: <1412757280-31367-3-git-send-email-loic.poulain@intel.com> (sfid-20141008_103345_481752_97850ED5)
In-Reply-To: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some GPIO based rfkill devices can wake their host up from suspend by
toggling an input (from the host perspective) GPIO.
This patch adds a generic support for that feature by registering a
threaded interrupt routine and thus setting the corresponding GPIO as a
wake up source.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
---
 net/rfkill/rfkill-gpio.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 29369d6..2f6aad1 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/gpio/consumer.h>
+#include <linux/interrupt.h>
 
 #include <linux/rfkill-gpio.h>
 
@@ -36,6 +37,8 @@ struct rfkill_gpio_data {
 	struct gpio_desc	*shutdown_gpio;
 	struct gpio_desc	*wake_gpio;
 
+	int			host_wake_irq;
+
 	struct rfkill		*rfkill_dev;
 	struct clk		*clk;
 
@@ -48,6 +51,7 @@ struct rfkill_gpio_desc {
 	int			reset_idx;
 	int			shutdown_idx;
 	int			wake_idx;
+	int			host_wake_idx;
 };
 
 static int rfkill_gpio_set_power(void *data, bool blocked)
@@ -73,6 +77,15 @@ static const struct rfkill_ops rfkill_gpio_ops = {
 	.set_block = rfkill_gpio_set_power,
 };
 
+static irqreturn_t rfkill_gpio_host_wake(int irq, void *dev)
+{
+	struct rfkill_gpio_data *rfkill = dev;
+
+	pr_info("Host wake IRQ for %s\n", rfkill->name);
+
+	return IRQ_HANDLED;
+}
+
 static int rfkill_gpio_init(struct device *dev, struct rfkill_gpio_desc *desc)
 {
 	int ret;
@@ -125,6 +138,34 @@ static int rfkill_gpio_init(struct device *dev, struct rfkill_gpio_desc *desc)
 		}
 	}
 
+	rfkill->host_wake_irq = -1;
+
+	if (desc && (desc->host_wake_idx >= 0)) {
+		gpio = devm_gpiod_get_index(dev, "host_wake",
+					    desc->host_wake_idx);
+		if (!IS_ERR(gpio)) {
+			int irqf = IRQF_TRIGGER_RISING | IRQF_NO_SUSPEND |
+				   IRQF_ONESHOT;
+
+			ret = gpiod_direction_input(gpio);
+			if (ret)
+				return ret;
+
+			rfkill->host_wake_irq = gpiod_to_irq(gpio);
+			ret = devm_request_threaded_irq(dev,
+							rfkill->host_wake_irq,
+							NULL,
+							rfkill_gpio_host_wake,
+							irqf, "host_wake",
+							rfkill);
+			if (ret)
+				return ret;
+
+			/* Wakeup IRQ, only used in suspend */
+			disable_irq(rfkill->host_wake_irq);
+		}
+	}
+
 	/* Make sure at-least one of the GPIO is defined */
 	if (!rfkill->reset_gpio && !rfkill->shutdown_gpio) {
 		dev_err(dev, "invalid platform data\n");
@@ -205,6 +246,9 @@ static int rfkill_gpio_suspend(struct device *dev)
 	if (!rfkill->clk_enabled)
 		return 0;
 
+	if (rfkill->host_wake_irq >= 0)
+		enable_irq(rfkill->host_wake_irq);
+
 	gpiod_set_value_cansleep(rfkill->wake_gpio, 0);
 
 	return 0;
@@ -219,6 +263,9 @@ static int rfkill_gpio_resume(struct device *dev)
 	if (!rfkill->clk_enabled)
 		return 0;
 
+	if (rfkill->host_wake_irq >= 0)
+		disable_irq(rfkill->host_wake_irq);
+
 	gpiod_set_value_cansleep(rfkill->wake_gpio, 1);
 
 	return 0;
@@ -243,6 +290,7 @@ static struct rfkill_gpio_desc acpi_default_bluetooth = {
 	.reset_idx = 0,
 	.shutdown_idx = 1,
 	.wake_idx = -1,
+	.host_wake_idx = -1,
 };
 
 static struct rfkill_gpio_desc acpi_default_gps = {
@@ -250,6 +298,7 @@ static struct rfkill_gpio_desc acpi_default_gps = {
 	.reset_idx = 0,
 	.shutdown_idx = 1,
 	.wake_idx = -1,
+	.host_wake_idx = -1,
 };
 
 static const struct acpi_device_id rfkill_acpi_match[] = {
-- 
1.8.3.2

