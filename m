Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35415 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1953167AbdDYWn7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 18:43:59 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v5 4/9] NFC: trf7970a: Only check 'en2-rf-quirk' if EN2 is specified
Date: Tue, 25 Apr 2017 15:43:51 -0700
Message-Id: <20170425224356.11498-5-mgreer@animalcreek.com> (sfid-20170426_004426_099778_47FC7AD3)
In-Reply-To: <20170425224356.11498-1-mgreer@animalcreek.com>
References: <20170425224356.11498-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The quirk indicated by the 'en2-rf-quirk' device tree property
is only relevant when there is a GPIO connected to the EN2 pin
of the trf7970a. This means we should only check for 'en2-rf-quirk'
when EN2 is specified in the 'ti,enable-gpios' property of the
device tree.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 drivers/nfc/trf7970a.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 5d5a8b0e57d4..4655680b0e7b 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2070,6 +2070,9 @@ static int trf7970a_probe(struct spi_device *spi)
 			dev_err(trf->dev, "Can't request EN2 GPIO: %d\n", ret);
 			return ret;
 		}
+
+		if (of_property_read_bool(np, "en2-rf-quirk"))
+			trf->quirks |= TRF7970A_QUIRK_EN2_MUST_STAY_LOW;
 	}
 
 	of_property_read_u32(np, "clock-frequency", &clk_freq);
@@ -2081,9 +2084,6 @@ static int trf7970a_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	if (of_property_read_bool(np, "en2-rf-quirk"))
-		trf->quirks |= TRF7970A_QUIRK_EN2_MUST_STAY_LOW;
-
 	ret = devm_request_threaded_irq(trf->dev, spi->irq, NULL,
 			trf7970a_irq, IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 			"trf7970a", trf);
-- 
2.12.0
