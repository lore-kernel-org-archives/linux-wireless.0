Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28397 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755466AbdCGLFt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 06:05:49 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 3/5] NFC: st21nfca: Get rid of "interesting" use of interrupt polarity
Date: Tue,  7 Mar 2017 12:25:44 +0200
Message-Id: <20170307102546.32224-3-andriy.shevchenko@linux.intel.com> (sfid-20170307_120624_522281_C44A657B)
In-Reply-To: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
References: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I2C framework followed by IRQ framework does set interrupt polarity
correctly if it's properly specified in firmware (ACPI or DT).

Get rid of the redundant trick when requesting interrupt.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st21nfca/i2c.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 1eb558f00290..30ef330c9030 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -69,7 +69,6 @@ struct st21nfca_i2c_phy {
 	struct nfc_hci_dev *hdev;
 
 	unsigned int gpio_ena;
-	unsigned int irq_polarity;
 
 	struct st21nfca_se_status se_status;
 
@@ -521,8 +520,6 @@ static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
 
 	phy->gpio_ena = desc_to_gpio(gpiod_ena);
 
-	phy->irq_polarity = irq_get_trigger_type(client->irq);
-
 	phy->se_status.is_ese_present = false;
 	phy->se_status.is_uicc_present = false;
 
@@ -567,8 +564,6 @@ static int st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
 
 	phy->gpio_ena = gpio;
 
-	phy->irq_polarity = irq_get_trigger_type(client->irq);
-
 	phy->se_status.is_ese_present =
 				of_property_read_bool(pp, "ese-present");
 	phy->se_status.is_uicc_present =
@@ -631,7 +626,7 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 
 	r = devm_request_threaded_irq(&client->dev, client->irq, NULL,
 				st21nfca_hci_irq_thread_fn,
-				phy->irq_polarity | IRQF_ONESHOT,
+				IRQF_ONESHOT,
 				ST21NFCA_HCI_DRIVER_NAME, phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-- 
2.11.0
