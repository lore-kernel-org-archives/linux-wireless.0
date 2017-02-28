Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:12996 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751986AbdB1OJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 09:09:37 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/2] NFC: pn544: Add GPIO ACPI mapping table
Date: Tue, 28 Feb 2017 16:08:09 +0200
Message-Id: <20170228140809.84921-2-andriy.shevchenko@linux.intel.com> (sfid-20170228_151024_386829_BA21906D)
In-Reply-To: <20170228140809.84921-1-andriy.shevchenko@linux.intel.com>
References: <20170228140809.84921-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to make GPIO ACPI library stricter prepare users of
gpiod_get_index() to correctly behave when there no mapping is
provided by firmware.

Here we add explicit mapping between _CRS GpioIo() resources and
their names used in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/pn544/i2c.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 2df3176205c4..5364bbd5ce55 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -874,6 +874,15 @@ static void pn544_hci_i2c_fw_work(struct work_struct *work)
 	}
 }
 
+static const struct acpi_gpio_params enable_gpios = { 1, 0, false };
+static const struct acpi_gpio_params firmware_gpios = { 2, 0, false };
+
+static const struct acpi_gpio_mapping acpi_pn544_default_gpios[] = {
+	{ "enable-gpios", &enable_gpios, 1 },
+	{ "firmware-gpios", &firmware_gpios, 1 },
+	{ },
+};
+
 static int pn544_hci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
@@ -982,6 +991,11 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
+	r = acpi_dev_add_driver_gpios(ACPI_COMPANION(&client->dev),
+				      acpi_pn544_default_gpios);
+	if (r)
+		return r;
+
 	phy = devm_kzalloc(&client->dev, sizeof(struct pn544_i2c_phy),
 			   GFP_KERNEL);
 	if (!phy)
@@ -1092,6 +1106,7 @@ static int pn544_hci_i2c_remove(struct i2c_client *client)
 		pdata->free_resources();
 	}
 
+	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&client->dev));
 	return 0;
 }
 
-- 
2.11.0
