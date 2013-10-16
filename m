Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35004 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973Ab3JPKyA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 06:54:00 -0400
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Rhyland Klein <rklein@nvidia.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 5/5] net: rfkill: gpio: add ACPI support
Date: Wed, 16 Oct 2013 13:53:43 +0300
Message-Id: <1381920823-15403-6-git-send-email-heikki.krogerus@linux.intel.com> (sfid-20131016_125409_814254_1E371DCE)
In-Reply-To: <1381920823-15403-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1381920823-15403-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Including ACPI ID for Broadcom GPS receiver BCM4752.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 2dd78c6..5620d3c 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -24,6 +24,8 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
+#include <linux/acpi_gpio.h>
 
 #include <linux/rfkill-gpio.h>
 
@@ -70,6 +72,23 @@ static const struct rfkill_ops rfkill_gpio_ops = {
 	.set_block = rfkill_gpio_set_power,
 };
 
+static int rfkill_gpio_acpi_probe(struct device *dev,
+				  struct rfkill_gpio_data *rfkill)
+{
+	const struct acpi_device_id *id;
+
+	id = acpi_match_device(dev->driver->acpi_match_table, dev);
+	if (!id)
+		return -ENODEV;
+
+	rfkill->name = dev_name(dev);
+	rfkill->type = (unsigned)id->driver_data;
+	rfkill->reset_gpio = acpi_get_gpio_by_index(dev, 0, NULL);
+	rfkill->shutdown_gpio = acpi_get_gpio_by_index(dev, 1, NULL);
+
+	return 0;
+}
+
 static int rfkill_gpio_probe(struct platform_device *pdev)
 {
 	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
@@ -82,7 +101,11 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	if (!rfkill)
 		return -ENOMEM;
 
-	if (pdata) {
+	if (ACPI_HANDLE(&pdev->dev)) {
+		ret = rfkill_gpio_acpi_probe(&pdev->dev, rfkill);
+		if (ret)
+			return ret;
+	} else if (pdata) {
 		clk_name = pdata->power_clk_name;
 		rfkill->name = pdata->name;
 		rfkill->type = pdata->type;
@@ -170,12 +193,18 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct acpi_device_id rfkill_acpi_match[] = {
+	{ "BCM4752", RFKILL_TYPE_GPS },
+	{ },
+};
+
 static struct platform_driver rfkill_gpio_driver = {
 	.probe = rfkill_gpio_probe,
 	.remove = rfkill_gpio_remove,
 	.driver = {
 		.name = "rfkill_gpio",
 		.owner = THIS_MODULE,
+		.acpi_match_table = ACPI_PTR(rfkill_acpi_match),
 	},
 };
 
-- 
1.8.4.rc3

