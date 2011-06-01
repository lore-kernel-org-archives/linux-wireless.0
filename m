Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2226 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758883Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 60/83] staging: brcm80211: renamed files to get rid of
 wl_ file name prefix
Date: Wed, 1 Jun 2011 13:45:45 +0200
Message-ID: <1306928768-7501-60-git-send-email-rvossen@broadcom.com> (sfid-20110601_134837_096465_7F862B27)
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
 drivers/staging/brcm80211/brcmsmac/Makefile        |    4 ++--
 .../brcmsmac/{wl_mac80211.c => brcms_mac80211.c}   |    4 ++--
 .../brcmsmac/{wl_mac80211.h => brcms_mac80211.h}   |    0
 .../brcmsmac/{wl_ucode_loader.c => ucode_loader.c} |    2 +-
 .../brcmsmac/{wl_ucode.h => ucode_loader.h}        |    0
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)
 rename drivers/staging/brcm80211/brcmsmac/{wl_mac80211.c => brcms_mac80211.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wl_mac80211.h => brcms_mac80211.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wl_ucode_loader.c => ucode_loader.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wl_ucode.h => ucode_loader.h} (100%)

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 4356a29..c6b5128 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -28,8 +28,8 @@ ccflags-y :=				\
 	-Idrivers/staging/brcm80211/include
 
 BRCMSMAC_OFILES := \
-	wl_mac80211.o \
-	wl_ucode_loader.o \
+	brcms_mac80211.o \
+	ucode_loader.o \
 	wlc_alloc.o \
 	wlc_ampdu.o \
 	wlc_antsel.o \
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
rename to drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
index cc2ed78..8eadb43 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
@@ -42,8 +42,8 @@
 #include "wlc_pub.h"
 #include "wl_dbg.h"
 #include "wl_export.h"
-#include "wl_ucode.h"
-#include "wl_mac80211.h"
+#include "ucode_loader.h"
+#include "brcms_mac80211.h"
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
rename to drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_ucode_loader.c b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wl_ucode_loader.c
rename to drivers/staging/brcm80211/brcmsmac/ucode_loader.c
index cf0be6b..d38f124 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_ucode_loader.c
+++ b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
@@ -16,7 +16,7 @@
 
 #include <linux/types.h>
 #include <bcmdefs.h>
-#include <wl_ucode.h>
+#include <ucode_loader.h>
 
 enum {
 	D11UCODE_NAMETAG_START = 0,
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_ucode.h b/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wl_ucode.h
rename to drivers/staging/brcm80211/brcmsmac/ucode_loader.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index fe031f2..57c6e8a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -45,7 +45,7 @@
 #include "wlc_channel.h"
 #include "wlc_main.h"
 #include "wl_export.h"
-#include "wl_ucode.h"
+#include "ucode_loader.h"
 #include "wlc_antsel.h"
 #include "wlc_alloc.h"
 #include "wl_dbg.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 1a2108c..d5ba632 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -49,7 +49,7 @@
 #include "wl_export.h"
 #include "wlc_alloc.h"
 #include "wl_dbg.h"
-#include "wl_mac80211.h"
+#include "brcms_mac80211.h"
 
 /*
  * WPA(2) definitions
-- 
1.7.4.1


