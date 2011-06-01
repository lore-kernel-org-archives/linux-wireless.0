Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4949 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 45/83] staging: brcm80211: deleted sbconfig.h, renamed
 sbcc.h
Date: Wed, 1 Jun 2011 13:45:30 +0200
Message-ID: <1306928768-7501-45-git-send-email-rvossen@broadcom.com> (sfid-20110601_134719_420161_D4FBA143)
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
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |    2 +-
 drivers/staging/brcm80211/brcmsmac/bcmotp.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c       |    2 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/nvram.c         |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |    2 +-
 drivers/staging/brcm80211/include/bcmdefs.h        |   12 +++++++
 drivers/staging/brcm80211/include/bcmsoc.h         |    1 -
 .../brcm80211/include/{sbchipc.h => chipcommon.h}  |    0
 drivers/staging/brcm80211/include/sbconfig.h       |   32 --------------------
 15 files changed, 23 insertions(+), 44 deletions(-)
 rename drivers/staging/brcm80211/include/{sbchipc.h => chipcommon.h} (100%)
 delete mode 100644 drivers/staging/brcm80211/include/sbconfig.h

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 275fa7c..67768bb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -130,7 +130,7 @@ typedef struct {
 } rte_cons_t;
 
 #endif				/* DHD_DEBUG */
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <sbdma.h>
 
 #include <sdio.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index e065895..2de6cfb 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -23,7 +23,7 @@
 #include <bcmutils.h>
 #include <aiutils.h>
 #include <bcmsoc.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <bcmdevs.h>
 
 /* ********** from siutils.c *********** */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
index dab71fb..2b7f061 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
@@ -26,7 +26,7 @@
 #include <bcmutils.h>
 #include <aiutils.h>
 #include <bcmsoc.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <bcmotp.h>
 
 #define OTPS_GUP_MASK		0x00000f00
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index c776a76..2946d06 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -23,7 +23,7 @@
 #include "wlc_types.h"
 #include <bcmutils.h>
 #include <bcmsoc.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <bcmdevs.h>
 #include <nicpci.h>
 #include <aiutils.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 8bc65e0..6b9cb6b 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -23,7 +23,7 @@
 #include <aiutils.h>
 #include <bcmsoc.h>
 #include <bcmdevs.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <nicpci.h>
 
 /* SPROM offsets */
diff --git a/drivers/staging/brcm80211/brcmsmac/nvram.c b/drivers/staging/brcm80211/brcmsmac/nvram.c
index 65fee2f..5cef837 100644
--- a/drivers/staging/brcm80211/brcmsmac/nvram.c
+++ b/drivers/staging/brcm80211/brcmsmac/nvram.c
@@ -19,7 +19,7 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmnvram.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <bcmdevs.h>
 #include <bcmsoc.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 1e9865f..d54e264 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -25,7 +25,7 @@
 
 #include <bcmdefs.h>
 #include <bcmnvram.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <bcmdevs.h>
 #include <sbdma.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index 78d8cbe..bc362f3 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -21,7 +21,7 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <aiutils.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <wlc_pmu.h>
 
 #include <bcmdevs.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index d069ebe..0f876a7 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -29,7 +29,7 @@
 #include <bcmotp.h>
 #include <bcmutils.h>
 #include <bcmnvram.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <nicpci.h>
 #include <sbdma.h>
 #include <bcmdma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index c94b459..b97fa3e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -28,7 +28,7 @@
 #include <bcmutils.h>
 #include <bcmwifi.h>
 #include <aiutils.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <sbdma.h>
 #include <bcmdma.h>
 #include <wlc_pmu.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index ab2c0b7..047cd1a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -19,7 +19,7 @@
 #include <linux/io.h>
 
 #include <bcmdevs.h>
-#include <sbchipc.h>
+#include <chipcommon.h>
 #include <bcmutils.h>
 #include <bcmnvram.h>
 #include "wlc_pmu.h"
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/bcmdefs.h
index cf9dc0e..304d8ed 100644
--- a/drivers/staging/brcm80211/include/bcmdefs.h
+++ b/drivers/staging/brcm80211/include/bcmdefs.h
@@ -95,4 +95,16 @@ typedef struct wl_rateset {
 #define PM_MAX	1
 #define PM_FAST 2
 
+/*
+ * Sonics Configuration Space Registers.
+ */
+#define	SBCONFIGOFF		0xf00	/* core sbconfig regs are top 256bytes of regs */
+
+/* cpp contortions to concatenate w/arg prescan */
+#ifndef	PAD
+#define	_PADLINE(line)	pad ## line
+#define	_XSTR(line)	_PADLINE(line)
+#define	PAD		_XSTR(__LINE__)
+#endif
+
 #endif				/* _bcmdefs_h_ */
diff --git a/drivers/staging/brcm80211/include/bcmsoc.h b/drivers/staging/brcm80211/include/bcmsoc.h
index 6435686..012e465 100644
--- a/drivers/staging/brcm80211/include/bcmsoc.h
+++ b/drivers/staging/brcm80211/include/bcmsoc.h
@@ -18,7 +18,6 @@
 #define	_HNDSOC_H
 
 /* Include the soci specific files */
-#include <sbconfig.h>
 #include <aidmp.h>
 
 /*
diff --git a/drivers/staging/brcm80211/include/sbchipc.h b/drivers/staging/brcm80211/include/chipcommon.h
similarity index 100%
rename from drivers/staging/brcm80211/include/sbchipc.h
rename to drivers/staging/brcm80211/include/chipcommon.h
diff --git a/drivers/staging/brcm80211/include/sbconfig.h b/drivers/staging/brcm80211/include/sbconfig.h
deleted file mode 100644
index 68e4b54..0000000
--- a/drivers/staging/brcm80211/include/sbconfig.h
+++ /dev/null
@@ -1,32 +0,0 @@
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
-#ifndef	_SBCONFIG_H
-#define	_SBCONFIG_H
-
-/* cpp contortions to concatenate w/arg prescan */
-#ifndef PAD
-#define	_PADLINE(line)	pad ## line
-#define	_XSTR(line)	_PADLINE(line)
-#define	PAD		_XSTR(__LINE__)
-#endif
-
-/*
- * Sonics Configuration Space Registers.
- */
-#define	SBCONFIGOFF		0xf00	/* core sbconfig regs are top 256bytes of regs */
-
-#endif				/* _SBCONFIG_H */
-- 
1.7.4.1


