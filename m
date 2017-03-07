Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:31179 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754909AbdCGKcJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:32:09 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/5] NFC: st21nfca: Fix obvious typo when check error code
Date: Tue,  7 Mar 2017 12:25:42 +0200
Message-Id: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com> (sfid-20170307_113257_706735_FCBF0198)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We return -ENODEV if ACPI provides a GPIO resource. Looks really wrong.
If it has even been tested?

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st21nfca/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 5a82f553906c..737384d287aa 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -514,9 +514,9 @@ static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
 	/* Get EN GPIO from ACPI */
 	gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN, 1,
 					 GPIOD_OUT_LOW);
-	if (!IS_ERR(gpiod_ena)) {
+	if (IS_ERR(gpiod_ena)) {
 		nfc_err(dev, "Unable to get ENABLE GPIO\n");
-		return -ENODEV;
+		return PTR_ERR(gpiod_ena);
 	}
 
 	phy->gpio_ena = desc_to_gpio(gpiod_ena);
-- 
2.11.0
