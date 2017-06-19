Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:33142 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753997AbdFSKJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:09:34 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 04/13] NFC: fdp: Convert I2C driver to ->probe_new()
Date: Mon, 19 Jun 2017 13:08:49 +0300
Message-Id: <20170619100858.2655-5-andriy.shevchenko@linux.intel.com> (sfid-20170619_121009_083430_7F7CAAF5)
In-Reply-To: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
References: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no platform code that uses i2c module table.
Remove it altogether and adjust ->probe() to be ->probe_new().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/fdp/i2c.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index e0baec848ff2..8a66b1845f27 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -281,8 +281,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
 }
 
-static int fdp_nci_i2c_probe(struct i2c_client *client,
-			     const struct i2c_device_id *id)
+static int fdp_nci_i2c_probe(struct i2c_client *client)
 {
 	struct fdp_i2c_phy *phy;
 	struct device *dev = &client->dev;
@@ -360,12 +359,6 @@ static int fdp_nci_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct i2c_device_id fdp_nci_i2c_id_table[] = {
-	{"int339a", 0},
-	{}
-};
-MODULE_DEVICE_TABLE(i2c, fdp_nci_i2c_id_table);
-
 static const struct acpi_device_id fdp_nci_i2c_acpi_match[] = {
 	{"INT339A", 0},
 	{}
@@ -377,8 +370,7 @@ static struct i2c_driver fdp_nci_i2c_driver = {
 		   .name = FDP_I2C_DRIVER_NAME,
 		   .acpi_match_table = ACPI_PTR(fdp_nci_i2c_acpi_match),
 		  },
-	.id_table = fdp_nci_i2c_id_table,
-	.probe = fdp_nci_i2c_probe,
+	.probe_new = fdp_nci_i2c_probe,
 	.remove = fdp_nci_i2c_remove,
 };
 module_i2c_driver(fdp_nci_i2c_driver);
-- 
2.11.0
