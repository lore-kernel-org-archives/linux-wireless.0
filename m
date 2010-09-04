Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:40044 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab0IDWzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 18:55:43 -0400
Subject: [PATCH] p54spi: Add error message for eeprom failure
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 00:55:38 +0200
Message-ID: <1283640938.3538.7.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds an error message for the eeprom request failure
case. This way it's easier for the user to figure out
what went wrong.

Signed-off-by: Michael Büsch <mb@bu3sch.de>

---
 drivers/net/wireless/p54/p54spi.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/p54/p54spi.c
+++ wireless-testing/drivers/net/wireless/p54/p54spi.c
@@ -202,6 +202,8 @@ static int p54spi_request_eeprom(struct
 		dev_info(&priv->spi->dev, "loading default eeprom...\n");
 		ret = p54_parse_eeprom(dev, (void *) p54spi_eeprom,
 				       sizeof(p54spi_eeprom));
+#else
+		dev_err(&priv->spi->dev, "Failed to request user eeprom\n");
 #endif /* CONFIG_P54_SPI_DEFAULT_EEPROM */
 	} else {
 		dev_info(&priv->spi->dev, "loading user eeprom...\n");


