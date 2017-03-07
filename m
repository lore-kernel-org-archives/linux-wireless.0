Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:45093 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755088AbdCGKOH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:14:07 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 6/6] NFC: st21nfca: Use unified device property API meaningfully
Date: Tue,  7 Mar 2017 12:14:01 +0200
Message-Id: <20170307101401.23182-6-andriy.shevchenko@linux.intel.com> (sfid-20170307_111805_095348_EE88DD4A)
In-Reply-To: <20170307101401.23182-1-andriy.shevchenko@linux.intel.com>
References: <20170307101401.23182-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another place in the code that unveils non-tested at all ACPI case.

Use unified device property API in meaningful way.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st21nfca/i2c.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 429ecdfd6e37..9a31d3cec92b 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -505,7 +505,6 @@ static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
-	u8 tmp;
 
 	/* Get EN GPIO from ACPI */
 	phy->gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN, 1,
@@ -515,19 +514,6 @@ static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
 		return PTR_ERR(phy->gpiod_ena);
 	}
 
-	phy->se_status.is_ese_present = false;
-	phy->se_status.is_uicc_present = false;
-
-	if (device_property_present(dev, "ese-present")) {
-		device_property_read_u8(dev, "ese-present", &tmp);
-		phy->se_status.is_ese_present = tmp;
-	}
-
-	if (device_property_present(dev, "uicc-present")) {
-		device_property_read_u8(dev, "uicc-present", &tmp);
-		phy->se_status.is_uicc_present = tmp;
-	}
-
 	return 0;
 }
 
@@ -535,11 +521,6 @@ static int st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
 {
 	struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
-	struct device_node *pp;
-
-	pp = client->dev.of_node;
-	if (!pp)
-		return -ENODEV;
 
 	/* Get GPIO from device tree */
 	phy->gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN, 0,
@@ -549,11 +530,6 @@ static int st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
 		return PTR_ERR(phy->gpiod_ena);
 	}
 
-	phy->se_status.is_ese_present =
-				of_property_read_bool(pp, "ese-present");
-	phy->se_status.is_uicc_present =
-				of_property_read_bool(pp, "uicc-present");
-
 	return 0;
 }
 
@@ -603,6 +579,11 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
+	phy->se_status.is_ese_present =
+			device_property_read_bool(&client->dev, "ese-present");
+	phy->se_status.is_uicc_present =
+			device_property_read_bool(&client->dev, "uicc-present");
+
 	r = st21nfca_hci_platform_init(phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to reboot st21nfca\n");
-- 
2.11.0
