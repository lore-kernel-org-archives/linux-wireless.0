Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab0KNLgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 06:36:53 -0500
Received: by mail-ww0-f44.google.com with SMTP id 29so387874wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 03:36:52 -0800 (PST)
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 4/4] staging: brcm80211: brcmfmac: cleanup bcmsdh_(un)register
Date: Sun, 14 Nov 2010 13:36:24 +0200
Message-Id: <7f8498393cedc3c8079ea71455a4b5696adeaecc.1289734125.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1289734125.git.mike.rapoport@gmail.com>
References: <cover.1289734125.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 388cbd3..bd50565 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -286,28 +286,17 @@ extern int sdio_function_init(void);
 
 int bcmsdh_register(bcmsdh_driver_t *driver)
 {
-	int error = 0;
-
 	drvinfo = *driver;
 
-#if defined(BCMPLATFORM_BUS)
-#if defined(BCMLXSDMMC)
 	SDLX_MSG(("Linux Kernel SDIO/MMC Driver\n"));
-	error = sdio_function_init();
-#endif				/* defined(BCMLXSDMMC) */
-	return error;
-#endif				/* defined(BCMPLATFORM_BUS) */
-
-	return error;
+	return sdio_function_init();
 }
 
 extern void sdio_function_cleanup(void);
 
 void bcmsdh_unregister(void)
 {
-#if defined(BCMLXSDMMC)
 	sdio_function_cleanup();
-#endif				/* BCMLXSDMMC */
 }
 
 #if defined(OOB_INTR_ONLY)
-- 
1.6.4.4

