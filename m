Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4198 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab1GROaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 10:30:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Franky Lin" <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/19] staging: brcm80211: remove SDLX_MSG from brcmfmac
Date: Mon, 18 Jul 2011 16:30:01 +0200
Message-ID: <1310999405-10062-16-git-send-email-arend@broadcom.com> (sfid-20110718_163045_882492_C7DC6A78)
In-Reply-To: <1310999405-10062-1-git-send-email-arend@broadcom.com>
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use unified debug macros in fullmac

Cc: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 7b66787..0953160 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -29,6 +29,7 @@
 #include <soc.h>
 #include "dhd.h"
 #include "dhd_bus.h"
+#include "dhd_dbg.h"
 #include "sdio_host.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
@@ -55,9 +56,6 @@
 #define BRCMF_SD_INFO(x)
 #endif				/* BCMDBG */
 
-/* debugging macros */
-#define SDLX_MSG(x)
-
 #define SDIOH_CMD_TYPE_NORMAL   0	/* Normal command */
 #define SDIOH_CMD_TYPE_APPEND   1	/* Append command */
 #define SDIOH_CMD_TYPE_CUTTHRU  2	/* Cut-through command */
@@ -486,7 +484,7 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 
 	card = brcmf_sdcard_attach((void *)0, &regs);
 	if (!card) {
-		SDLX_MSG(("%s: attach failed\n", __func__));
+		BRCMF_ERROR(("%s: attach failed\n", __func__));
 		goto err;
 	}
 	sdiodev->card = card;
@@ -498,7 +496,7 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->bus = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
 				  0, 0, 0, 0, regs, card);
 	if (!sdiodev->bus) {
-		SDLX_MSG(("%s: device attach failed\n", __func__));
+		BRCMF_ERROR(("%s: device attach failed\n", __func__));
 		goto err;
 	}
 
@@ -525,7 +523,6 @@ int brcmf_sdio_register(struct brcmf_sdioh_driver *driver)
 {
 	drvinfo = *driver;
 
-	SDLX_MSG(("Linux Kernel SDIO/MMC Driver\n"));
 	return brcmf_sdio_function_init();
 }
 
-- 
1.7.4.1


