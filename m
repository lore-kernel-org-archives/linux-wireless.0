Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:38177 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755087AbdCGKOh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:14:37 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 5/6] NFC: st21nfca: Covert to use GPIO descriptor
Date: Tue,  7 Mar 2017 12:14:00 +0200
Message-Id: <20170307101401.23182-5-andriy.shevchenko@linux.intel.com> (sfid-20170307_111807_378560_B3D27C1F)
In-Reply-To: <20170307101401.23182-1-andriy.shevchenko@linux.intel.com>
References: <20170307101401.23182-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we got rid of platform data, the driver may use GPIO descriptor
directly.

Looking deeply to the use of the GPIO pin it looks like it should be
a fixed voltage regulator rather than custom GPIO handling. But this
is out of scope of the change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st21nfca/i2c.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index c98199c2b8a0..429ecdfd6e37 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -67,8 +67,7 @@ struct st21nfca_i2c_phy {
 	struct i2c_client *i2c_dev;
 	struct nfc_hci_dev *hdev;
 
-	unsigned int gpio_ena;
-
+	struct gpio_desc *gpiod_ena;
 	struct st21nfca_se_status se_status;
 
 	struct sk_buff *pending_skb;
@@ -149,7 +148,7 @@ static int st21nfca_hci_i2c_enable(void *phy_id)
 {
 	struct st21nfca_i2c_phy *phy = phy_id;
 
-	gpio_set_value(phy->gpio_ena, 1);
+	gpiod_set_value(phy->gpiod_ena, 1);
 	phy->powered = 1;
 	phy->run_mode = ST21NFCA_HCI_MODE;
 
@@ -162,7 +161,7 @@ static void st21nfca_hci_i2c_disable(void *phy_id)
 {
 	struct st21nfca_i2c_phy *phy = phy_id;
 
-	gpio_set_value(phy->gpio_ena, 0);
+	gpiod_set_value(phy->gpiod_ena, 0);
 
 	phy->powered = 0;
 }
@@ -505,20 +504,17 @@ static struct nfc_phy_ops i2c_phy_ops = {
 static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
-	struct gpio_desc *gpiod_ena;
 	struct device *dev = &client->dev;
 	u8 tmp;
 
 	/* Get EN GPIO from ACPI */
-	gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN, 1,
-					 GPIOD_OUT_LOW);
-	if (IS_ERR(gpiod_ena)) {
+	phy->gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN, 1,
+					      GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_ena)) {
 		nfc_err(dev, "Unable to get ENABLE GPIO\n");
-		return PTR_ERR(gpiod_ena);
+		return PTR_ERR(phy->gpiod_ena);
 	}
 
-	phy->gpio_ena = desc_to_gpio(gpiod_ena);
-
 	phy->se_status.is_ese_present = false;
 	phy->se_status.is_uicc_present = false;
 
@@ -538,31 +534,21 @@ static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
 static int st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
 {
 	struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
+	struct device *dev = &client->dev;
 	struct device_node *pp;
-	int gpio;
-	int r;
 
 	pp = client->dev.of_node;
 	if (!pp)
 		return -ENODEV;
 
 	/* Get GPIO from device tree */
-	gpio = of_get_named_gpio(pp, "enable-gpios", 0);
-	if (gpio < 0) {
-		nfc_err(&client->dev, "Failed to retrieve enable-gpios from device tree\n");
-		return gpio;
+	phy->gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN, 0,
+					      GPIOD_OUT_HIGH);
+	if (IS_ERR(phy->gpiod_ena)) {
+		nfc_err(dev, "Failed to request enable pin\n");
+		return PTR_ERR(phy->gpiod_ena);
 	}
 
-	/* GPIO request and configuration */
-	r = devm_gpio_request_one(&client->dev, gpio, GPIOF_OUT_INIT_HIGH,
-				  ST21NFCA_GPIO_NAME_EN);
-	if (r) {
-		nfc_err(&client->dev, "Failed to request enable pin\n");
-		return r;
-	}
-
-	phy->gpio_ena = gpio;
-
 	phy->se_status.is_ese_present =
 				of_property_read_bool(pp, "ese-present");
 	phy->se_status.is_uicc_present =
-- 
2.11.0
