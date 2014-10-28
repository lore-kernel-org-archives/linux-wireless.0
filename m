Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbaJ1KDw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 06:03:52 -0400
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Alexandre Courbot <gnurou@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
Subject: [PATCH RESEND] net: rfkill: gpio: Add ACPI default GPIO driver mappings
Date: Tue, 28 Oct 2014 12:03:48 +0200
Message-Id: <1414490628-107823-1-git-send-email-mika.westerberg@linux.intel.com> (sfid-20141028_110414_400128_23845406)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver uses devm_gpiod_get_index(..., index) so that the index refers
directly to the GpioIo resource under the ACPI device. The problem with
this is that if the ordering changes we get wrong GPIOs.

With ACPI 5.1 _DSD we can now use names instead to reference GPIOs
analogous to Device Tree. However, we still have systems out there that do
not provide _DSD at all. These systems must be supported as well.

Luckily we now have acpi_dev_add_driver_gpios() that can be used to provide
mappings for systems where _DSD is not provided and still take advantage of
_DSD if it exists.

This patch converts the rfkill-gpio.c driver to create default GPIO
mappings to the two GPIOs in case we are running on ACPI system.

While there we can drop the indices completely.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: John W. Linville <linville@tuxdriver.com>
---
Resending with linux-acpi included. I also added ACKs from Johannes and
John. The patch itself is intact.

 net/rfkill/rfkill-gpio.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 0f62326c0f5e..2a4717967502 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -63,6 +63,15 @@ static const struct rfkill_ops rfkill_gpio_ops = {
 	.set_block = rfkill_gpio_set_power,
 };
 
+static const struct acpi_gpio_params reset_gpios = { 0, 0, false };
+static const struct acpi_gpio_params shutdown_gpios = { 1, 0, false };
+
+static const struct acpi_gpio_mapping acpi_rfkill_default_gpios[] = {
+	{ "reset-gpios", &reset_gpios, 1 },
+	{ "shutdown-gpios", &shutdown_gpios, 1 },
+	{ },
+};
+
 static int rfkill_gpio_acpi_probe(struct device *dev,
 				  struct rfkill_gpio_data *rfkill)
 {
@@ -75,7 +84,8 @@ static int rfkill_gpio_acpi_probe(struct device *dev,
 	rfkill->name = dev_name(dev);
 	rfkill->type = (unsigned)id->driver_data;
 
-	return 0;
+	return acpi_dev_add_driver_gpios(ACPI_COMPANION(dev),
+					 acpi_rfkill_default_gpios);
 }
 
 static int rfkill_gpio_probe(struct platform_device *pdev)
@@ -102,7 +112,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 
 	rfkill->clk = devm_clk_get(&pdev->dev, NULL);
 
-	gpio = devm_gpiod_get_index(&pdev->dev, "reset", 0);
+	gpio = devm_gpiod_get(&pdev->dev, "reset");
 	if (!IS_ERR(gpio)) {
 		ret = gpiod_direction_output(gpio, 0);
 		if (ret)
@@ -110,7 +120,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 		rfkill->reset_gpio = gpio;
 	}
 
-	gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 1);
+	gpio = devm_gpiod_get(&pdev->dev, "shutdown");
 	if (!IS_ERR(gpio)) {
 		ret = gpiod_direction_output(gpio, 0);
 		if (ret)
@@ -150,6 +160,8 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 	rfkill_unregister(rfkill->rfkill_dev);
 	rfkill_destroy(rfkill->rfkill_dev);
 
+	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&pdev->dev));
+
 	return 0;
 }
 
-- 
2.1.1

