Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3876 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758854Ab1FALqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:35 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 61/83] staging: brcm80211: removed wl_dbg.h
Date: Wed, 1 Jun 2011 13:45:46 +0200
Message-ID: <1306928768-7501-61-git-send-email-rvossen@broadcom.com> (sfid-20110601_134745_354187_7CED03DA)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Reducing number of header files. Merged into wlc_types.h.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/brcms_mac80211.c    |    1 -
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h        |   33 --------------------
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_types.h     |   11 ++++++
 12 files changed, 11 insertions(+), 43 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/wl_dbg.h

diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
index 8eadb43..2c239cf 100644
--- a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
@@ -40,7 +40,6 @@
 #include "wlc_channel.h"
 #include "wlc_scb.h"
 #include "wlc_pub.h"
-#include "wl_dbg.h"
 #include "wl_export.h"
 #include "ucode_loader.h"
 #include "brcms_mac80211.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
deleted file mode 100644
index 253c464..0000000
--- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
+++ /dev/null
@@ -1,33 +0,0 @@
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
-#ifndef _wl_dbg_h_
-#define _wl_dbg_h_
-
-#include <linux/device.h>			/* dev_err() */
-
-/* brcm_msg_level is a bit vector with defs in bcmdefs.h */
-extern u32 brcm_msg_level;
-
-#define BCMMSG(dev, fmt, args...)		\
-do {						\
-	if (brcm_msg_level & LOG_TRACE_VAL)	\
-		wiphy_err(dev, "%s: " fmt, __func__, ##args);	\
-} while (0)
-
-#define WL_ERROR_ON()		(brcm_msg_level & LOG_ERROR_VAL)
-
-#endif				/* _wl_dbg_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index 218210a..619247a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -28,7 +28,6 @@
 #include "wlc_pub.h"
 #include "wlc_key.h"
 #include "wlc_alloc.h"
-#include "wl_dbg.h"
 #include "wlc_rate.h"
 #include "wlc_bsscfg.h"
 #include "phy/wlc_phy_hal.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 0c325c7..61d4722 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -32,7 +32,6 @@
 #include "phy/wlc_phy_hal.h"
 #include "wlc_antsel.h"
 #include "wl_export.h"
-#include "wl_dbg.h"
 #include "wlc_channel.h"
 #include "wlc_main.h"
 #include "wlc_ampdu.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index fba9eaf..dcedcc2 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -32,7 +32,6 @@
 #include "wlc_key.h"
 #include "wlc_scb.h"
 #include "wlc_pub.h"
-#include "wl_dbg.h"
 #include "phy/wlc_phy_hal.h"
 #include "wlc_bmac.h"
 #include "wlc_channel.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 57c6e8a..228b02d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -48,7 +48,6 @@
 #include "ucode_loader.h"
 #include "wlc_antsel.h"
 #include "wlc_alloc.h"
-#include "wl_dbg.h"
 #include "wlc_bmac.h"
 
 #define	TIMER_INTERVAL_WATCHDOG_BMAC	1000	/* watchdog timer, in unit of ms */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index cd37971..d1e764a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -37,7 +37,6 @@
 #include "wlc_channel.h"
 #include "wlc_main.h"
 #include "wlc_stf.h"
-#include "wl_dbg.h"
 
 #define	VALID_CHANNEL20_DB(wlc, val) wlc_valid_channel20_db((wlc)->cmi, val)
 #define	VALID_CHANNEL20_IN_BAND(wlc, bandunit, val) \
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index d5ba632..f95a6d0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -48,7 +48,6 @@
 #include "wlc_ampdu.h"
 #include "wl_export.h"
 #include "wlc_alloc.h"
-#include "wl_dbg.h"
 #include "brcms_mac80211.h"
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index ba5d67e..a090ee2 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -33,7 +33,6 @@
 #include <wlc_pmu.h>
 
 #include "wlc_types.h"
-#include "wl_dbg.h"
 #include "wlc_cfg.h"
 #include "d11.h"
 #include "wlc_rate.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index d6eae1f..88aa134 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -23,7 +23,6 @@
 
 #include "wlc_types.h"
 #include "d11.h"
-#include "wl_dbg.h"
 #include "wlc_cfg.h"
 #include "wlc_scb.h"
 #include "wlc_pub.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index 8fb90d4..d4fb6e4 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -26,7 +26,6 @@
 
 #include "wlc_types.h"
 #include "d11.h"
-#include "wl_dbg.h"
 #include "wlc_cfg.h"
 #include "wlc_rate.h"
 #include "wlc_scb.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index 775d013..383a747 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -33,6 +33,14 @@
 
 #define MAX_DMA_SEGS 4
 
+#define BCMMSG(dev, fmt, args...)		\
+do {						\
+	if (brcm_msg_level & LOG_TRACE_VAL)	\
+		wiphy_err(dev, "%s: " fmt, __func__, ##args);	\
+} while (0)
+
+#define WL_ERROR_ON()		(brcm_msg_level & LOG_ERROR_VAL)
+
 /* forward declarations */
 struct sk_buff;
 struct brcms_info;
@@ -49,4 +57,7 @@ struct wlc_bsscfg;
 struct bcmstrbuf;
 struct si_pub;
 
+/* brcm_msg_level is a bit vector with defs in bcmdefs.h */
+extern u32 brcm_msg_level;
+
 #endif				/* _wlc_types_h_ */
-- 
1.7.4.1


