Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3144 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab1GEUGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 06/21] staging: brcm80211: removed file sdiovar.h
Date: Tue, 5 Jul 2011 22:06:02 +0200
Message-ID: <1309896377-4425-7-git-send-email-arend@broadcom.com> (sfid-20110705_220641_056806_51DCD59F)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Contents merged into other files.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |    6 +++
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h  |   10 +++++
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/sdiovar.h       |   38 --------------------
 6 files changed, 16 insertions(+), 41 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/sdiovar.h

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 761ec20..3ba3c3f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -32,6 +32,12 @@
 #define SDIOH_DATA_PIO          0	/* PIO mode */
 #define SDIOH_DATA_DMA          1	/* DMA mode */
 
+struct brcmf_sdreg {
+	int func;
+	int offset;
+	int value;
+};
+
 /* callback function, taking one arg */
 typedef void (*sdioh_cb_fn_t) (void *);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 7da200f..7bc9d02 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -28,7 +28,6 @@
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
 #include "bcmsdbus.h"
-#include "sdiovar.h"		/* ioctl/iovars */
 #include "dngl_stats.h"
 #include "dhd.h"
 #include "bcmsdh_sdmmc.h"
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index 5eb4c65..962fa4b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -21,6 +21,16 @@
 #ifndef __BCMSDH_SDMMC_H__
 #define __BCMSDH_SDMMC_H__
 
+/* Common msglevel constants */
+#define SDH_ERROR_VAL		0x0001	/* Error */
+#define SDH_TRACE_VAL		0x0002	/* Trace */
+#define SDH_INFO_VAL		0x0004	/* Info */
+#define SDH_DEBUG_VAL		0x0008	/* Debug */
+#define SDH_DATA_VAL		0x0010	/* Data */
+#define SDH_CTRL_VAL		0x0020	/* Control Regs */
+#define SDH_LOG_VAL		0x0040	/* Enable bcmlog */
+#define SDH_DMA_VAL		0x0080	/* DMA */
+
 #ifdef BCMDBG
 #define sd_err(x)	\
 	do { \
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 145ca09..369f99e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -28,7 +28,6 @@
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
 #include "bcmsdbus.h"
-#include "sdiovar.h"		/* to get msglevel bit values */
 #include "dngl_stats.h"
 #include "dhd.h"
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4b0352f..6a53ac8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -176,7 +176,6 @@ struct rte_console {
 #include "dhd_bus.h"
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
-#include <sdiovar.h>
 #include <bcmchip.h>
 
 #ifndef DHDSDIO_MEM_DUMP_FNAME
diff --git a/drivers/staging/brcm80211/brcmfmac/sdiovar.h b/drivers/staging/brcm80211/brcmfmac/sdiovar.h
deleted file mode 100644
index 35e913b..0000000
--- a/drivers/staging/brcm80211/brcmfmac/sdiovar.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _sdiovar_h_
-#define _sdiovar_h_
-
-struct brcmf_sdreg {
-	int func;
-	int offset;
-	int value;
-};
-
-/* Common msglevel constants */
-#define SDH_ERROR_VAL		0x0001	/* Error */
-#define SDH_TRACE_VAL		0x0002	/* Trace */
-#define SDH_INFO_VAL		0x0004	/* Info */
-#define SDH_DEBUG_VAL		0x0008	/* Debug */
-#define SDH_DATA_VAL		0x0010	/* Data */
-#define SDH_CTRL_VAL		0x0020	/* Control Regs */
-#define SDH_LOG_VAL		0x0040	/* Enable bcmlog */
-#define SDH_DMA_VAL		0x0080	/* DMA */
-
-#define NUM_PREV_TRANSACTIONS	16
-
-#endif				/* _sdiovar_h_ */
-- 
1.7.4.1


