Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33333 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0HUWA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 18:00:26 -0400
Received: by bwz11 with SMTP id 11so2995400bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Aug 2010 15:00:21 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54spi: Kconfig option for config blob
Date: Sun, 22 Aug 2010 00:00:14 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008220000.15280.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds an Kconfig option, which allows the user
to select, whenever he/she wants to include a 4k blob for
generic calibration and interface values into the driver,
or cut the module size by about 15 to 20%.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index 60a930e..0a963d5 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -49,6 +49,23 @@ config P54_SPI
 
 	  If you choose to build a module, it'll be called p54spi.
 
+config P54_SPI_DEFAULT_EEPROM
+	bool "Include fallback EEPROM blob"
+	depends on P54_SPI
+	default n
+	---help---
+	 Unlike the PCI or USB devices, the SPI variants don't have
+	 a dedicated EEPROM chip to store all device specific values
+	 for calibration, country and interface settings.
+
+	 The driver will try to load the image "3826.eeprom", if the
+	 file is put at the right place. (usually /lib/firmware.)
+
+	 Only if this request fails, this option will provide a
+	 backup set of generic values to get the device working.
+
+	 Enabling this option adds about 4k to p54spi.
+
 config P54_LEDS
 	bool
 	depends on P54_COMMON && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = P54_COMMON)
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 087bf06..156e57d 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -32,11 +32,14 @@
 #include <linux/slab.h>
 
 #include "p54spi.h"
-#include "p54spi_eeprom.h"
 #include "p54.h"
 
 #include "lmac.h"
 
+#ifdef CONFIG_P54_SPI_DEFAULT_EEPROM
+#include "p54spi_eeprom.h"
+#endif /* CONFIG_P54_SPI_DEFAULT_EEPROM */
+
 MODULE_FIRMWARE("3826.arm");
 MODULE_ALIAS("stlc45xx");
 
@@ -195,9 +198,11 @@ static int p54spi_request_eeprom(struct ieee80211_hw *dev)
 
 	ret = request_firmware(&eeprom, "3826.eeprom", &priv->spi->dev);
 	if (ret < 0) {
+#ifdef CONFIG_P54_SPI_DEFAULT_EEPROM
 		dev_info(&priv->spi->dev, "loading default eeprom...\n");
 		ret = p54_parse_eeprom(dev, (void *) p54spi_eeprom,
 				       sizeof(p54spi_eeprom));
+#endif /* CONFIG_P54_SPI_DEFAULT_EEPROM */
 	} else {
 		dev_info(&priv->spi->dev, "loading user eeprom...\n");
 		ret = p54_parse_eeprom(dev, (void *) eeprom->data,
