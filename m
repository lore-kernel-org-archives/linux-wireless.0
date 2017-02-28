Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:18598 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751431AbdB1OIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 09:08:14 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/2] NFC: pn544: Request GPIOs with proper connection IDs
Date: Tue, 28 Feb 2017 16:08:08 +0200
Message-Id: <20170228140809.84921-1-andriy.shevchenko@linux.intel.com> (sfid-20170228_150820_836321_FC97E4F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since ACPI does support _DSD we might have a firmware that provides a
GPIO mapping in DSDT. When GPIO is requested the core will check for
property with given name. That's why we have to follow the standard
names which are already in use in DT case.

Request GPIOs with proper connection IDs, i.e. use same names as used
for DT case.

In the future ACPI and DT cases might be unified.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/pn544/i2c.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index f837c39a8017..2df3176205c4 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -881,8 +881,7 @@ static int pn544_hci_i2c_acpi_request_resources(struct i2c_client *client)
 	struct device *dev = &client->dev;
 
 	/* Get EN GPIO from ACPI */
-	gpiod_en = devm_gpiod_get_index(dev, PN544_GPIO_NAME_EN, 1,
-					GPIOD_OUT_LOW);
+	gpiod_en = devm_gpiod_get_index(dev, "enable", 1, GPIOD_OUT_LOW);
 	if (IS_ERR(gpiod_en)) {
 		nfc_err(dev, "Unable to get EN GPIO\n");
 		return -ENODEV;
@@ -891,8 +890,7 @@ static int pn544_hci_i2c_acpi_request_resources(struct i2c_client *client)
 	phy->gpio_en = desc_to_gpio(gpiod_en);
 
 	/* Get FW GPIO from ACPI */
-	gpiod_fw = devm_gpiod_get_index(dev, PN544_GPIO_NAME_FW, 2,
-					GPIOD_OUT_LOW);
+	gpiod_fw = devm_gpiod_get_index(dev, "firmware", 2, GPIOD_OUT_LOW);
 	if (IS_ERR(gpiod_fw)) {
 		nfc_err(dev, "Unable to get FW GPIO\n");
 		return -ENODEV;
-- 
2.11.0
