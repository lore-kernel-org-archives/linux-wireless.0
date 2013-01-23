Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51997 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab3AWOli (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 09:41:38 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id r0NEfbOB018117
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:37 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r0NEfbZt025993
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:37 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 4/5] wlcore: use PLATFORM_DEVID_AUTO for plat dev creation to avoid conflicts
Date: Wed, 23 Jan 2013 16:40:37 +0200
Message-ID: <1358952038-5982-5-git-send-email-coelho@ti.com> (sfid-20130123_154144_508611_D12E5E69)
In-Reply-To: <1358952038-5982-1-git-send-email-coelho@ti.com>
References: <1358952038-5982-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The platform devices can be created by both wlcore_sdio and
wlcore_spi.  Theoretically, if both are connected to the same board,
there will be a conflict.

Reported-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c |    2 +-
 drivers/net/wireless/ti/wlcore/spi.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 6d2884f..198028d 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -280,7 +280,7 @@ static int wl1271_probe(struct sdio_func *func,
 	else
 		chip_family = "wl12xx";
 
-	glue->core = platform_device_alloc(chip_family, -1);
+	glue->core = platform_device_alloc(chip_family, PLATFORM_DEVID_AUTO);
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index d62a20b..5ad2e10 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -366,7 +366,7 @@ static int wl1271_probe(struct spi_device *spi)
 		goto out_free_glue;
 	}
 
-	glue->core = platform_device_alloc("wl12xx", -1);
+	glue->core = platform_device_alloc("wl12xx", PLATFORM_DEVID_AUTO);
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device\n");
 		ret = -ENOMEM;
-- 
1.7.10.4

