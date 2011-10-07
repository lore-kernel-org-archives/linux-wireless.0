Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:58652 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab1JGNAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 09:00:23 -0400
Received: by mail-bw0-f43.google.com with SMTP id s6so7026026bka.16
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 06:00:22 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, balbi@ti.com
Subject: [RFC] wl12xx: use the same plat dev name for both SPI and SDIO
Date: Fri,  7 Oct 2011 16:00:14 +0300
Message-Id: <1317992414-30197-1-git-send-email-coelho@ti.com> (sfid-20111007_150025_775849_A1470102)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to have the bus name included in the platform device
name that we create.  The core driver doesn't need to know about the
type of bus it uses.  Any differences between the buses that need to
be handled differently in the core, can be passed in the platform data
(as the pwr_in_suspend boolean does).

Use "wl12xx" for the device name in both bus drivers.  Rename the
platform driver name to "wl12xx_driver", just to differentiate from
the platform device names.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---

I'm sending this as RFC because I had a long discussion with Balbi
about this.  I want to see what others think about it too.

One advantage of doing this, is that the sysfs files that we create
are always in the same location, inside the device's kobj which now
has always the same name.  If we start supporting more than one device
at once, at any time, then we need to use "wl12xx0", "wl12xx1" and so
on.

 drivers/net/wireless/wl12xx/main.c |    5 ++---
 drivers/net/wireless/wl12xx/sdio.c |    2 +-
 drivers/net/wireless/wl12xx/spi.c  |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 320d1f4..1ebed1c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -5107,8 +5107,7 @@ static int __devexit wl12xx_remove(struct platform_device *pdev)
 }
 
 static const struct platform_device_id wl12xx_id_table[] __devinitconst = {
-	{ "wl12xx-sdio", 0 },
-	{ "wl12xx-spi", 0 },
+	{ "wl12xx", 0 },
 	{  } /* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(platform, wl12xx_id_table);
@@ -5118,7 +5117,7 @@ static struct platform_driver wl12xx_driver = {
 	.remove		= __devexit_p(wl12xx_remove),
 	.id_table	= wl12xx_id_table,
 	.driver = {
-		.name	= "wl12xx",
+		.name	= "wl12xx_driver",
 		.owner	= THIS_MODULE,
 	}
 };
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 50fdd9b..1ebf6b8 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -226,7 +226,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	/* Tell PM core that we don't need the card to be powered now */
 	pm_runtime_put_noidle(&func->dev);
 
-	glue->core = platform_device_alloc("wl12xx-sdio", -1);
+	glue->core = platform_device_alloc("wl12xx", -1);
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 976d3d5..9e6f7fa 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -351,7 +351,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 		goto out_free_glue;
 	}
 
-	glue->core = platform_device_alloc("wl12xx-spi", -1);
+	glue->core = platform_device_alloc("wl12xx", -1);
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device\n");
 		ret = -ENOMEM;
-- 
1.7.1

