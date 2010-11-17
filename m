Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42103 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759847Ab0KQIAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 03:00:10 -0500
Received: by bwz15 with SMTP id 15so1286360bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 00:00:09 -0800 (PST)
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 4/4] staging: brcm80211: brcmfmac: cleanup bcmsdh_(un)register
Date: Wed, 17 Nov 2010 10:00:00 +0200
Message-Id: <1289980800-28743-1-git-send-email-mike.rapoport@gmail.com>
In-Reply-To: <20101116200438.GA10803@kroah.com>
References: <20101116200438.GA10803@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index fd327e1..e3fb7ed 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -285,28 +285,17 @@ extern int sdio_function_init(void);
 
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

