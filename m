Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134AbcCCJ0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 04:26:22 -0500
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] nfc: pn544: Drop two useless checks in ACPI probe path
Date: Thu,  3 Mar 2016 11:26:18 +0200
Message-Id: <1456997178-7673-1-git-send-email-mika.westerberg@linux.intel.com> (sfid-20160303_102626_570898_2B731BF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When pn544_hci_i2c_acpi_request_resources() gets called we already know
that the entries in ->acpi_match_table have matched ACPI ID of the device.
In addition I2C client pointer cannot be NULL in any case (otherwise I2C
core would not call ->probe() for the driver in the first place).

Drop the two useless checks from the driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/nfc/pn544/i2c.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 76c318444304..45d0e667d7ae 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -877,20 +877,8 @@ exit_state_wait_secure_write_answer:
 static int pn544_hci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
-	const struct acpi_device_id *id;
 	struct gpio_desc *gpiod_en, *gpiod_fw;
-	struct device *dev;
-
-	if (!client)
-		return -EINVAL;
-
-	dev = &client->dev;
-
-	/* Match the struct device against a given list of ACPI IDs */
-	id = acpi_match_device(dev->driver->acpi_match_table, dev);
-
-	if (!id)
-		return -ENODEV;
+	struct device *dev = &client->dev;
 
 	/* Get EN GPIO from ACPI */
 	gpiod_en = devm_gpiod_get_index(dev, PN544_GPIO_NAME_EN, 1,
-- 
2.7.0

