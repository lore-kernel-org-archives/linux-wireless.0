Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:59135 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753775AbdFSKJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:09:22 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 01/13] NFC: pn544: Switch to devm_acpi_dev_add_driver_gpios()
Date: Mon, 19 Jun 2017 13:08:46 +0300
Message-Id: <20170619100858.2655-2-andriy.shevchenko@linux.intel.com> (sfid-20170619_120928_616871_38F5D748)
In-Reply-To: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
References: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Switch to use managed variant of acpi_dev_add_driver_gpios() to simplify
error path and fix potentially wrong assignment if ->probe() fails.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/pn544/i2c.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index fedde9d46ab6..4b14740edb67 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -904,7 +904,7 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
-	r = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_pn544_gpios);
+	r = devm_acpi_dev_add_driver_gpios(dev, acpi_pn544_gpios);
 	if (r)
 		dev_dbg(dev, "Unable to add GPIO mapping table\n");
 
@@ -958,7 +958,6 @@ static int pn544_hci_i2c_remove(struct i2c_client *client)
 	if (phy->powered)
 		pn544_hci_i2c_disable(phy);
 
-	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&client->dev));
 	return 0;
 }
 
-- 
2.11.0
