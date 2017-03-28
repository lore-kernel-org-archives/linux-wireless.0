Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:39893 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754217AbdC1Jhd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 05:37:33 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 3/5] NFC: pn544: Convert to use devm_request_threaded_irq()
Date: Tue, 28 Mar 2017 12:36:37 +0300
Message-Id: <20170328093639.53481-3-andriy.shevchenko@linux.intel.com> (sfid-20170328_113942_638391_27F28D3C)
In-Reply-To: <20170328093639.53481-1-andriy.shevchenko@linux.intel.com>
References: <20170328093639.53481-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The error handling will be neat and short when using managed resources.

Convert the driver to use devm_request_threaded_irq().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 v3: no change

 drivers/nfc/pn544/i2c.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index b4001306aff8..5e780e7a28e5 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -963,9 +963,10 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 
 	pn544_hci_i2c_platform_init(phy);
 
-	r = request_threaded_irq(client->irq, NULL, pn544_hci_i2c_irq_thread_fn,
-				 IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-				 PN544_HCI_I2C_DRIVER_NAME, phy);
+	r = devm_request_threaded_irq(&client->dev, client->irq, NULL,
+				      pn544_hci_i2c_irq_thread_fn,
+				      IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				      PN544_HCI_I2C_DRIVER_NAME, phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
 		return r;
@@ -976,14 +977,9 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 			    PN544_HCI_I2C_LLC_MAX_PAYLOAD,
 			    pn544_hci_i2c_fw_download, &phy->hdev);
 	if (r < 0)
-		goto err_hci;
+		return r;
 
 	return 0;
-
-err_hci:
-	free_irq(client->irq, phy);
-
-	return r;
 }
 
 static int pn544_hci_i2c_remove(struct i2c_client *client)
@@ -1001,8 +997,6 @@ static int pn544_hci_i2c_remove(struct i2c_client *client)
 	if (phy->powered)
 		pn544_hci_i2c_disable(phy);
 
-	free_irq(client->irq, phy);
-
 	return 0;
 }
 
-- 
2.11.0
