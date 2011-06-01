Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2410 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758862Ab1FALqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:40 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 82/83] staging: brcm80211: renamed file
Date: Wed, 1 Jun 2011 13:46:07 +0200
Message-ID: <1306928768-7501-82-git-send-email-rvossen@broadcom.com> (sfid-20110601_134741_563476_0FC5DEFE)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile        |    2 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |    2 +-
 .../brcm80211/brcmsmac/{bottom_mac.c => bmac.c}    |    2 +-
 .../brcm80211/brcmsmac/{bottom_mac.h => bmac.h}    |    0
 drivers/staging/brcm80211/brcmsmac/channel.c       |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |    2 +-
 8 files changed, 7 insertions(+), 7 deletions(-)
 rename drivers/staging/brcm80211/brcmsmac/{bottom_mac.c => bmac.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{bottom_mac.h => bmac.h} (100%)

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index ee5c3f0..1ea3e0c 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -33,7 +33,7 @@ BRCMSMAC_OFILES := \
 	alloc.o \
 	ampdu.o \
 	antsel.o \
-	bottom_mac.o \
+	bmac.o \
 	channel.o \
 	main.o \
 	phy_shim.o \
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index fdac211..f967c59 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -29,7 +29,7 @@
 #include "scb.h"
 #include "pub.h"
 #include "phy/phy_hal.h"
-#include "bottom_mac.h"
+#include "bmac.h"
 #include "channel.h"
 #include "main.h"
 #include "antsel.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/bottom_mac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/bottom_mac.c
rename to drivers/staging/brcm80211/brcmsmac/bmac.c
index 8a99bb1..417cf54 100644
--- a/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -44,7 +44,7 @@
 #include "ucode_loader.h"
 #include "antsel.h"
 #include "alloc.h"
-#include "bottom_mac.h"
+#include "bmac.h"
 #include "mac80211_if.h"
 
 #define	TIMER_INTERVAL_WATCHDOG_BMAC	1000	/* watchdog timer, in unit of ms */
diff --git a/drivers/staging/brcm80211/brcmsmac/bottom_mac.h b/drivers/staging/brcm80211/brcmsmac/bmac.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/bottom_mac.h
rename to drivers/staging/brcm80211/brcmsmac/bmac.h
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index b172320..9583140 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -29,7 +29,7 @@
 #include "scb.h"
 #include "pub.h"
 #include "phy/phy_hal.h"
-#include "bottom_mac.h"
+#include "bmac.h"
 #include "rate.h"
 #include "channel.h"
 #include "main.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index cfd04ca..3613900 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -36,7 +36,7 @@
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "main.h"
-#include "bottom_mac.h"
+#include "bmac.h"
 #include "phy_hal.h"
 #include "antsel.h"
 #include "stf.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 925edeb..d497573 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -40,7 +40,7 @@
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "srom.h"
-#include "bottom_mac.h"
+#include "bmac.h"
 #include "phy_hal.h"
 #include "main.h"
 #include "phy_shim.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 561aba8..5f98804 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -31,7 +31,7 @@
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "main.h"
-#include "bottom_mac.h"
+#include "bmac.h"
 #include "stf.h"
 
 #define MIN_SPATIAL_EXPANSION	0
-- 
1.7.4.1


