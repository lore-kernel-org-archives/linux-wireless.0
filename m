Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54589 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab1KHOoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:44:08 -0500
Received: by bkat8 with SMTP id t8so595856bka.24
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:43:53 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: add chip_family to platform data struct
Date: Tue,  8 Nov 2011 16:43:44 +0200
Message-Id: <1320763424-466-1-git-send-email-coelho@ti.com> (sfid-20111108_154412_774784_B4CCBAE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To abstract the bus modules from the actual driver that handles the
chip, we can pass the chip_family struct in the platform data.  This
string is used by the bus modules to name the platform device they
create.  The same string is used by the platform driver to get probed.

If not specified, we use "wl12xx" as default for backwards
compatibility.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/sdio.c   |    6 +++++-
 drivers/net/wireless/wl12xx/spi.c    |    6 +++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 ++
 include/linux/wl12xx.h               |    3 +++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 468a505..e266a20 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -226,7 +226,11 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	/* Tell PM core that we don't need the card to be powered now */
 	pm_runtime_put_noidle(&func->dev);
 
-	glue->core = platform_device_alloc("wl12xx", -1);
+	/* get the chip family from pdata, if not available use default */
+	glue->core = platform_device_alloc(wlan_data->chip_family?
+					   wlan_data->chip_family:
+					   DEFAULT_CHIP_FAMILY,
+					   -1);
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 9e6f7fa..6a83d9e 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -351,7 +351,11 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 		goto out_free_glue;
 	}
 
-	glue->core = platform_device_alloc("wl12xx", -1);
+	/* get the chip family from pdata, if not available use default */
+	glue->core = platform_device_alloc(wlan_data->chip_family?
+					   wlan_data->chip_family:
+					   DEFAULT_CHIP_FAMILY,
+					   -1);
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device\n");
 		ret = -ENOMEM;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index e58e801..2f35960 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -45,6 +45,8 @@
 #define WL127X_FW_NAME "ti-connectivity/wl127x-fw-3.bin"
 #define WL128X_FW_NAME "ti-connectivity/wl128x-fw-3.bin"
 
+#define DEFAULT_CHIP_FAMILY "wl12xx"
+
 /*
  * wl127x and wl128x are using the same NVS file name. However, the
  * ini parameters between them are different.  The driver validates
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 0d63731..adea8f8 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -53,6 +53,9 @@ struct wl12xx_platform_data {
 	bool use_eeprom;
 	int board_ref_clock;
 	int board_tcxo_clock;
+	const char *chip_family;
+
+	/* internal use */
 	unsigned long platform_quirks;
 	bool pwr_in_suspend;
 
-- 
1.7.4.1

