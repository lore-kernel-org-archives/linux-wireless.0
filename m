Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4933 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758831Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 62/83] staging: brcm80211: removed wl_export.h
Date: Wed, 1 Jun 2011 13:45:47 +0200
Message-ID: <1306928768-7501-62-git-send-email-rvossen@broadcom.com> (sfid-20110601_134722_255117_C242B366)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup, reducing number of header files. Merged into brcmsmac_80211.h.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/brcms_mac80211.c    |    1 -
 .../staging/brcm80211/brcmsmac/brcms_mac80211.h    |   28 ++++++++++++
 drivers/staging/brcm80211/brcmsmac/wl_export.h     |   47 --------------------
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |    1 -
 9 files changed, 30 insertions(+), 54 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/wl_export.h

diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
index 2c239cf..e80e12c 100644
--- a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
@@ -40,7 +40,6 @@
 #include "wlc_channel.h"
 #include "wlc_scb.h"
 #include "wlc_pub.h"
-#include "wl_export.h"
 #include "ucode_loader.h"
 #include "brcms_mac80211.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h
index 48ec6b0..8ef89ad 100644
--- a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h
@@ -78,4 +78,32 @@ struct brcms_info {
 	struct brcms_firmware fw;
 	struct wiphy *wiphy;
 };
+
+/* misc callbacks */
+struct brcms_info;
+struct brcms_if;
+struct wlc_if;
+extern void brcms_init(struct brcms_info *wl);
+extern uint brcms_reset(struct brcms_info *wl);
+extern void brcms_intrson(struct brcms_info *wl);
+extern u32 brcms_intrsoff(struct brcms_info *wl);
+extern void brcms_intrsrestore(struct brcms_info *wl, u32 macintmask);
+extern int brcms_up(struct brcms_info *wl);
+extern void brcms_down(struct brcms_info *wl);
+extern void brcms_txflowcontrol(struct brcms_info *wl, struct brcms_if *wlif,
+				bool state, int prio);
+extern bool wl_alloc_dma_resources(struct brcms_info *wl, uint dmaddrwidth);
+extern bool brcms_rfkill_set_hw_state(struct brcms_info *wl);
+
+/* timer functions */
+struct brcms_timer;
+extern struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
+				      void (*fn) (void *arg), void *arg,
+				      const char *name);
+extern void brcms_free_timer(struct brcms_info *wl, struct brcms_timer *timer);
+extern void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *timer,
+			    uint ms, int periodic);
+extern bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *timer);
+extern void brcms_msleep(struct brcms_info *wl, uint ms);
+
 #endif				/* _wl_mac80211_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_export.h b/drivers/staging/brcm80211/brcmsmac/wl_export.h
deleted file mode 100644
index 01d3696..0000000
--- a/drivers/staging/brcm80211/brcmsmac/wl_export.h
+++ /dev/null
@@ -1,47 +0,0 @@
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
-#ifndef _wl_export_h_
-#define _wl_export_h_
-
-/* misc callbacks */
-struct brcms_info;
-struct brcms_if;
-struct wlc_if;
-extern void brcms_init(struct brcms_info *wl);
-extern uint brcms_reset(struct brcms_info *wl);
-extern void brcms_intrson(struct brcms_info *wl);
-extern u32 brcms_intrsoff(struct brcms_info *wl);
-extern void brcms_intrsrestore(struct brcms_info *wl, u32 macintmask);
-extern int brcms_up(struct brcms_info *wl);
-extern void brcms_down(struct brcms_info *wl);
-extern void brcms_txflowcontrol(struct brcms_info *wl, struct brcms_if *wlif,
-				bool state, int prio);
-extern bool wl_alloc_dma_resources(struct brcms_info *wl, uint dmaddrwidth);
-extern bool brcms_rfkill_set_hw_state(struct brcms_info *wl);
-
-/* timer functions */
-struct brcms_timer;
-extern struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
-				      void (*fn) (void *arg), void *arg,
-				      const char *name);
-extern void brcms_free_timer(struct brcms_info *wl, struct brcms_timer *timer);
-extern void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *timer,
-			    uint ms, int periodic);
-extern bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *timer);
-extern void brcms_msleep(struct brcms_info *wl, uint ms);
-
-#endif				/* _wl_export_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 61d4722..7a00cac 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -31,7 +31,6 @@
 #include "wlc_key.h"
 #include "phy/wlc_phy_hal.h"
 #include "wlc_antsel.h"
-#include "wl_export.h"
 #include "wlc_channel.h"
 #include "wlc_main.h"
 #include "wlc_ampdu.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index dcedcc2..ea27b66 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -36,7 +36,6 @@
 #include "wlc_bmac.h"
 #include "wlc_channel.h"
 #include "wlc_main.h"
-#include "wl_export.h"
 #include "wlc_antsel.h"
 
 #define ANT_SELCFG_AUTO		0x80	/* bit indicates antenna sel AUTO */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 228b02d..6b02ebe 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -44,11 +44,11 @@
 #include "phy/wlc_phy_hal.h"
 #include "wlc_channel.h"
 #include "wlc_main.h"
-#include "wl_export.h"
 #include "ucode_loader.h"
 #include "wlc_antsel.h"
 #include "wlc_alloc.h"
 #include "wlc_bmac.h"
+#include "brcms_mac80211.h"
 
 #define	TIMER_INTERVAL_WATCHDOG_BMAC	1000	/* watchdog timer, in unit of ms */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index f95a6d0..1a3af67 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -46,7 +46,6 @@
 #include "wlc_antsel.h"
 #include "wlc_stf.h"
 #include "wlc_ampdu.h"
-#include "wl_export.h"
 #include "wlc_alloc.h"
 #include "brcms_mac80211.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index a090ee2..d33f720 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -44,9 +44,9 @@
 #include "wlc_key.h"
 #include "wlc_bmac.h"
 #include "wlc_phy_hal.h"
-#include "wl_export.h"
 #include "wlc_main.h"
 #include "wlc_phy_shim.h"
+#include "brcms_mac80211.h"
 
 /* PHY SHIM module specific state */
 struct wlc_phy_shim_info {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index d4fb6e4..b7191af 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -34,7 +34,6 @@
 #include "phy/wlc_phy_hal.h"
 #include "wlc_channel.h"
 #include "wlc_main.h"
-#include "wl_export.h"
 #include "wlc_bmac.h"
 #include "wlc_stf.h"
 
-- 
1.7.4.1


