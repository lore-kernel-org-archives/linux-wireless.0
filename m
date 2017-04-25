Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33015 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1953164AbdDYWn6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 18:43:58 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v5 3/9] NFC: trf7970a: Fix inaccurate comment in trf7970a_probe()
Date: Tue, 25 Apr 2017 15:43:50 -0700
Message-Id: <20170425224356.11498-4-mgreer@animalcreek.com> (sfid-20170426_004410_430793_E3378C3A)
In-Reply-To: <20170425224356.11498-1-mgreer@animalcreek.com>
References: <20170425224356.11498-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As of commit ce69b95ca4e4 ("NFC: Make EN2 pin optional in the
TRF7970A driver"), only the GPIO for the 'EN' enable pin needs
to be specified in the device tree so update the comments that
says both 'EN' and 'EN2' must be specified.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 drivers/nfc/trf7970a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 1a87525a88cd..5d5a8b0e57d4 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2046,7 +2046,7 @@ static int trf7970a_probe(struct spi_device *spi)
 	if (of_property_read_bool(np, "irq-status-read-quirk"))
 		trf->quirks |= TRF7970A_QUIRK_IRQ_STATUS_READ;
 
-	/* There are two enable pins - both must be present */
+	/* There are two enable pins - only EN must be present in the DT */
 	trf->en_gpio = of_get_named_gpio(np, "ti,enable-gpios", 0);
 	if (!gpio_is_valid(trf->en_gpio)) {
 		dev_err(trf->dev, "No EN GPIO property\n");
-- 
2.12.0
