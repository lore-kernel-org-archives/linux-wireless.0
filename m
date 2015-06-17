Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58459 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbbFQJLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:11:08 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Charles Gorand <charles.gorand@effinnov.com>
Cc: kernel@pengutronix.de, linux-nfc@ml01.01.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] NFC: nxp-nci_i2c: use flags argument of devm_gpiod_get_index
Date: Wed, 17 Jun 2015 11:10:52 +0200
Message-Id: <1434532252-29485-1-git-send-email-u.kleine-koenig@pengutronix.de> (sfid-20150617_111132_759445_8A0FBC7C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
which appeared in v3.17-rc1, the gpiod_get* functions take an additional
parameter that allows to specify direction and initial value for output.

Simplify driver accordingly which even make error checking more correct
because gpiod_direction_{in,out}put might fail. Furthermore this is one
caller less that stops us making the flags argument to gpiod_get*()
mandatory.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

I intend to make the flags parameter to gpiod_get* mandatory once
4.2-rc1 arrives. So unless this patch makes it in, I'd like to get an
Ack to take it via the gpio tree together with the change to gpiod_get.

Note this patch depends on 
551e306905ef (NFC: nxp-nci_i2c: Add support for enumerating through ACPI)
which only appeared in today's next.

Best regards
Uwe

 drivers/nfc/nxp-nci/i2c.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 2f77f1d03638..fac80c691914 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -318,19 +318,15 @@ static int nxp_nci_i2c_acpi_config(struct nxp_nci_i2c_phy *phy)
 	struct i2c_client *client = phy->i2c_dev;
 	struct gpio_desc *gpiod_en, *gpiod_fw, *gpiod_irq;
 
-	gpiod_en = devm_gpiod_get_index(&client->dev, NULL, 2);
-	gpiod_fw = devm_gpiod_get_index(&client->dev, NULL, 1);
-	gpiod_irq = devm_gpiod_get_index(&client->dev, NULL, 0);
+	gpiod_en = devm_gpiod_get_index(&client->dev, NULL, 2, GPIOD_OUT_LOW);
+	gpiod_fw = devm_gpiod_get_index(&client->dev, NULL, 1, GPIOD_OUT_LOW);
+	gpiod_irq = devm_gpiod_get_index(&client->dev, NULL, 0, GPIOD_IN);
 
 	if (IS_ERR(gpiod_en) || IS_ERR(gpiod_fw) || IS_ERR(gpiod_irq)) {
 		nfc_err(&client->dev, "No GPIOs\n");
 		return -EINVAL;
 	}
 
-	gpiod_direction_output(gpiod_en, 0);
-	gpiod_direction_output(gpiod_fw, 0);
-	gpiod_direction_input(gpiod_irq);
-
 	client->irq = gpiod_to_irq(gpiod_irq);
 	if (client->irq < 0) {
 		nfc_err(&client->dev, "No IRQ\n");
-- 
2.1.4

