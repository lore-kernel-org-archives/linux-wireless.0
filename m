Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50387 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1953168AbdDYWn7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 18:43:59 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v5 2/9] NFC: trf7970a: Don't de-assert EN2 unless it was asserted
Date: Tue, 25 Apr 2017 15:43:49 -0700
Message-Id: <20170425224356.11498-3-mgreer@animalcreek.com> (sfid-20170426_004427_182244_8478D251)
In-Reply-To: <20170425224356.11498-1-mgreer@animalcreek.com>
References: <20170425224356.11498-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the trf7970a part has the bug related to 'en2-rf-quirk',
the GPIO connected to the EN2 pin will not be asserted by the
driver when powering up so it shouldn't be de-asserted when
powering down.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 drivers/nfc/trf7970a.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 2d1c8ca6e679..1a87525a88cd 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -1940,8 +1940,10 @@ static int trf7970a_power_down(struct trf7970a *trf)
 	}
 
 	gpio_set_value(trf->en_gpio, 0);
-	if (gpio_is_valid(trf->en2_gpio))
-		gpio_set_value(trf->en2_gpio, 0);
+
+	if (!(trf->quirks & TRF7970A_QUIRK_EN2_MUST_STAY_LOW))
+		if (gpio_is_valid(trf->en2_gpio))
+			gpio_set_value(trf->en2_gpio, 0);
 
 	ret = regulator_disable(trf->regulator);
 	if (ret)
-- 
2.12.0
