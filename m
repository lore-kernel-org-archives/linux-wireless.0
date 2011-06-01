Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2406 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758860Ab1FALqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:40 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 77/83] staging: brcm80211: moved /include/sdio_host.h to
 /brcmfmac dir
Date: Wed, 1 Jun 2011 13:46:02 +0200
Message-ID: <1306928768-7501-77-git-send-email-rvossen@broadcom.com> (sfid-20110601_134740_980345_5413435E)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |    2 ++
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    2 --
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    2 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    4 +---
 .../brcm80211/{include => brcmfmac}/sdio_host.h    |    0
 7 files changed, 6 insertions(+), 8 deletions(-)
 rename drivers/staging/brcm80211/{include => brcmfmac}/sdio_host.h (100%)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 53c3291..e9da1ce 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -17,6 +17,8 @@
 #ifndef	_sdio_api_h_
 #define	_sdio_api_h_
 
+#include "sdio_host.h"
+
 #define SDIOH_API_RC_SUCCESS                          (0x00)
 #define SDIOH_API_RC_FAIL	                      (0x01)
 #define SDIOH_API_SUCCESS(status) (status == 0)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index d6e90d7..b3bdd48 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -25,8 +25,6 @@
 #include <brcmu_wifi.h>
 #include <soc.h>
 
-#include <sdio_host.h>		/* BRCM API for SDIO
-			 clients (such as wl, dhd) */
 #include <bcmsdbus.h>		/* common SDIO/controller interface */
 #include <sbsdio.h>		/* BRCM sdio device core */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 37cf61a..71ef23a 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -28,8 +28,8 @@
 #include <defs.h>
 #include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
-#include <sdio_host.h>
 #include <brcmu_wifi.h>
+#include "sdio_host.h"
 
 #if defined(OOB_INTR_ONLY)
 #include <linux/irq.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 03a5966..66e204b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -20,7 +20,7 @@
 #include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-#include <sdio_host.h>
+#include "sdio_host.h"
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* ioctl/iovars */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 85ed095..9fc491d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -20,7 +20,7 @@
 #include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-#include <sdio_host.h>
+#include "sdio_host.h"
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* to get msglevel bit values */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 966d98d..899890f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -22,9 +22,7 @@
 #include <linux/mmc/sdio.h>
 #include <asm/unaligned.h>
 #include <defs.h>
-#include <sdio_host.h>
-
-#include <defs.h>
+#include "sdio_host.h"
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include <brcm_hw_ids.h>
diff --git a/drivers/staging/brcm80211/include/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
similarity index 100%
rename from drivers/staging/brcm80211/include/sdio_host.h
rename to drivers/staging/brcm80211/brcmfmac/sdio_host.h
-- 
1.7.4.1


