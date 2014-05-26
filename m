Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:47272 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaEZNy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:54:27 -0400
Received: by mail-vc0-f176.google.com with SMTP id id10so5848903vcb.35
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:54:27 -0700 (PDT)
Message-ID: <1401112462.22584.2.camel@phoenix> (sfid-20140526_155431_030335_8F22AD7E)
Subject: [PATCH] NFC: st21nfca: Convert to use devm_gpio_request_one
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Christophe Ricard <christophe-h.ricard@st.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Date: Mon, 26 May 2014 21:54:22 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This simplifies the code a bit.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/nfc/st21nfca/i2c.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 3f954ed..0e096ad 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -524,17 +524,13 @@ static int st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
 	}
 
 	/* GPIO request and configuration */
-	r = devm_gpio_request(&client->dev, gpio, "clf_enable");
+	r = devm_gpio_request_one(&client->dev, gpio, GPIOF_OUT_INIT_HIGH,
+				  "clf_enable");
 	if (r) {
 		nfc_err(&client->dev, "Failed to request enable pin\n");
 		return -ENODEV;
 	}
 
-	r = gpio_direction_output(gpio, 1);
-	if (r) {
-		nfc_err(&client->dev, "Failed to set enable pin direction as output\n");
-		return -ENODEV;
-	}
 	phy->gpio_ena = gpio;
 
 	/* IRQ */
@@ -575,32 +571,20 @@ static int st21nfca_hci_i2c_request_resources(struct i2c_client *client)
 	phy->gpio_ena = pdata->gpio_ena;
 	phy->irq_polarity = pdata->irq_polarity;
 
-	r = devm_gpio_request(&client->dev, phy->gpio_irq, "wake_up");
+	r = devm_gpio_request_one(&client->dev, phy->gpio_irq, GPIOF_IN,
+				  "wake_up");
 	if (r) {
 		pr_err("%s : gpio_request failed\n", __FILE__);
 		return -ENODEV;
 	}
 
-	r = gpio_direction_input(phy->gpio_irq);
-	if (r) {
-		pr_err("%s : gpio_direction_input failed\n", __FILE__);
-		return -ENODEV;
-	}
-
 	if (phy->gpio_ena > 0) {
-		r = devm_gpio_request(&client->dev,
-					phy->gpio_ena, "clf_enable");
+		r = devm_gpio_request_one(&client->dev, phy->gpio_ena,
+					  GPIOF_OUT_INIT_HIGH, "clf_enable");
 		if (r) {
 			pr_err("%s : ena gpio_request failed\n", __FILE__);
 			return -ENODEV;
 		}
-		r = gpio_direction_output(phy->gpio_ena, 1);
-
-		if (r) {
-			pr_err("%s : ena gpio_direction_output failed\n",
-			       __FILE__);
-			return -ENODEV;
-		}
 	}
 
 	/* IRQ */
-- 
1.8.3.2



