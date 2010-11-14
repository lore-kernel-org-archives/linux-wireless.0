Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0KNLgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 06:36:51 -0500
Received: by mail-ww0-f44.google.com with SMTP id 29so387874wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 03:36:51 -0800 (PST)
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 3/4] staging: brcm80211: brcmfmac: remove PXA SDIO controller binding
Date: Sun, 14 Nov 2010 13:36:23 +0200
Message-Id: <278e5e9b131b56af0d0951f863782b5c1aff0ecd.1289734125.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1289734125.git.mike.rapoport@gmail.com>
References: <cover.1289734125.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 523034b..388cbd3 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -139,17 +139,6 @@ static int __devexit bcmsdh_remove(struct device *dev);
 #endif				/* BCMLXSDMMC */
 
 #ifndef BCMLXSDMMC
-static struct device_driver bcmsdh_driver = {
-	.name = "pxa2xx-mci",
-	.bus = &platform_bus_type,
-	.probe = bcmsdh_probe,
-	.remove = bcmsdh_remove,
-	.suspend = NULL,
-	.resume = NULL,
-};
-#endif				/* BCMLXSDMMC */
-
-#ifndef BCMLXSDMMC
 static
 #endif				/* BCMLXSDMMC */
 int bcmsdh_probe(struct device *dev)
@@ -305,9 +294,6 @@ int bcmsdh_register(bcmsdh_driver_t *driver)
 #if defined(BCMLXSDMMC)
 	SDLX_MSG(("Linux Kernel SDIO/MMC Driver\n"));
 	error = sdio_function_init();
-#else
-	SDLX_MSG(("Intel PXA270 SDIO Driver\n"));
-	error = driver_register(&bcmsdh_driver);
 #endif				/* defined(BCMLXSDMMC) */
 	return error;
 #endif				/* defined(BCMPLATFORM_BUS) */
@@ -319,9 +305,6 @@ extern void sdio_function_cleanup(void);
 
 void bcmsdh_unregister(void)
 {
-#if defined(BCMPLATFORM_BUS) && !defined(BCMLXSDMMC)
-		driver_unregister(&bcmsdh_driver);
-#endif
 #if defined(BCMLXSDMMC)
 	sdio_function_cleanup();
 #endif				/* BCMLXSDMMC */
-- 
1.6.4.4

