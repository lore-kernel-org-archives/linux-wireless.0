Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:60074 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZGOGiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 02:38:54 -0400
Received: by ewy26 with SMTP id 26so3802003ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2009 23:38:52 -0700 (PDT)
Subject: [PATCH] sdio: do not ignore MMC_VDD_165_195
From: Ohad Ben-Cohen <ohad@bencohen.org>
To: Pierre Ossman <pierre@ossman.eu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 15 Jul 2009 09:42:20 +0300
Message-Id: <1247640140.10247.10.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ohad Ben-Cohen <ohad@bencohen.org>

This is needed for 1.8V embedded SDIO devices and supporting host controllers

Signed-off-by: Ohad Ben-Cohen <ohad@bencohen.org>
---

Hi Pierre,

Please consider merging this patch -
it is required to support combinations like TI WLAN 127x device and ZOOM2 boards.

If you prefer me to implement this differently please let me know.

Thanks and Regards,
Ohad.

 drivers/mmc/core/sdio.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index fb99ccf..6f221dc 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -275,13 +275,6 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
 		ocr &= ~0x7F;
 	}
 
-	if (ocr & MMC_VDD_165_195) {
-		printk(KERN_WARNING "%s: SDIO card claims to support the "
-		       "incompletely defined 'low voltage range'. This "
-		       "will be ignored.\n", mmc_hostname(host));
-		ocr &= ~MMC_VDD_165_195;
-	}
-
 	host->ocr = mmc_select_voltage(host, ocr);
 
 	/*
-- 
1.5.4.3



