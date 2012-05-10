Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab2EJJOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:34 -0400
Received: by wgbdr13 with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:33 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/78] wlcore_sdio/wl18xx: use SDIO revision number to identify wl18xx chips
Date: Thu, 10 May 2012 12:13:07 +0300
Message-Id: <1336641263-5761-3-git-send-email-arik@wizery.com> (sfid-20120510_111439_416592_3D0243B1)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

At least in PG1, the wl18xx chips use the same SDIO vendor/device ID,
so it's not possible to figure out which driver is to be used.  As a
workaround, we can check the SDIO revision number, because wl18xx uses
3.00 and wl12xx does not.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 0a72347..1082e39 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/platform_device.h>
+#include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
@@ -196,6 +197,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	struct resource res[1];
 	mmc_pm_flag_t mmcflags;
 	int ret = -ENOMEM;
+	const char *chip_family;
 
 	/* We are only able to handle the wlan function */
 	if (func->num != 0x02)
@@ -236,7 +238,18 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	/* Tell PM core that we don't need the card to be powered now */
 	pm_runtime_put_noidle(&func->dev);
 
-	glue->core = platform_device_alloc("wl12xx", -1);
+	/*
+	 * Due to a hardware bug, we can't differentiate wl18xx from
+	 * wl12xx, because both report the same device ID.  The only
+	 * way to differentiate is by checking the SDIO revision,
+	 * which is 3.00 on the wl18xx chips.
+	 */
+	if (func->card->cccr.sdio_vsn == SDIO_SDIO_REV_3_00)
+		chip_family = "wl18xx";
+	else
+		chip_family = "wl12xx";
+
+	glue->core = platform_device_alloc(chip_family, -1);
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
-- 
1.7.9.5

