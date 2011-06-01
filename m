Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1146 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758897Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/83] staging: brcm80211: removed wlioctl.h and
 dhdioctl.h
Date: Wed, 1 Jun 2011 13:44:55 +0200
Message-ID: <1306928768-7501-10-git-send-email-rvossen@broadcom.com> (sfid-20110601_134758_572806_A02ADA92)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. These header files were emptied by the previous patch.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h     |    3 ---
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h   |    2 --
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |    1 -
 drivers/staging/brcm80211/brcmfmac/dhdioctl.h    |   20 --------------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_iw.c       |    1 -
 drivers/staging/brcm80211/include/wlioctl.h      |   20 --------------------
 7 files changed, 0 insertions(+), 48 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/dhdioctl.h
 delete mode 100644 drivers/staging/brcm80211/include/wlioctl.h

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
index 0817f13..d0fa231 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
@@ -97,7 +97,4 @@
 #define DHD_NONE(args)
 extern int dhd_msg_level;
 
-/* Defines msg bits */
-#include <dhdioctl.h>
-
 #endif				/* _dhd_dbg_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index 16b8942..d0c8321 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -17,8 +17,6 @@
 #ifndef _dhd_proto_h_
 #define _dhd_proto_h_
 
-#include <dhdioctl.h>
-
 #ifndef IOCTL_RESP_TIMEOUT
 #define IOCTL_RESP_TIMEOUT  2000	/* In milli second */
 #endif
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index b00029a..19a12b9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -49,7 +49,6 @@
 #include <dhd_bus.h>
 #include <dhd_proto.h>
 #include <dhd_dbg.h>
-#include <dhdioctl.h>
 #include <sdiovar.h>
 #include <bcmchip.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhdioctl.h b/drivers/staging/brcm80211/brcmfmac/dhdioctl.h
deleted file mode 100644
index db0b9e8..0000000
--- a/drivers/staging/brcm80211/brcmfmac/dhdioctl.h
+++ /dev/null
@@ -1,20 +0,0 @@
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
-#ifndef _dhdioctl_h_
-#define	_dhdioctl_h_
-
-#endif				/* _dhdioctl_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index fa005d3..6aa186e 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -23,7 +23,6 @@
 
 #include <dngl_stats.h>
 #include <dhd.h>
-#include <dhdioctl.h>
 
 #include <linux/kthread.h>
 #include <linux/netdevice.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index b284b12..b5cb897 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -26,7 +26,6 @@
 
 #include <dngl_stats.h>
 #include <dhd.h>
-#include <dhdioctl.h>
 #include <linux/ieee80211.h>
 typedef const struct si_pub si_t;
 
diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
deleted file mode 100644
index 281ca70..0000000
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ /dev/null
@@ -1,20 +0,0 @@
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
-#ifndef _wlioctl_h_
-#define	_wlioctl_h_
-
-#endif				/* _wlioctl_h_ */
-- 
1.7.4.1


