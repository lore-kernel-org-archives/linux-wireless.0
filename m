Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2410 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 37/61] staging: brcm80211: separate hndpmu functionality
 for brcmsmac driver
Date: Tue, 3 May 2011 11:35:37 +0200
Message-ID: <1304415361-7813-38-git-send-email-arend@broadcom.com> (sfid-20110503_113837_179500_084E39C9)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hndpmu source file has functions for brcmfmac and brcmsmac driver
but it turns out that on function level there is no reuse so for
the brcmsmac its set of functions now reside in wlc_pmu.c.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile        |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    2 +-
 .../{util/hndpmu.c => brcmsmac/wlc_pmu.c}          |    2 +-
 .../{include/hndpmu.h => brcmsmac/wlc_pmu.h}       |    0
 drivers/staging/brcm80211/util/siutils.c           |    2 +-
 9 files changed, 8 insertions(+), 8 deletions(-)
 rename drivers/staging/brcm80211/{util/hndpmu.c => brcmsmac/wlc_pmu.c} (99%)
 rename drivers/staging/brcm80211/{include/hndpmu.h => brcmsmac/wlc_pmu.h} (100%)

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index c4aafe5..65a1a25 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -38,6 +38,7 @@ BRCMSMAC_OFILES := \
 	wlc_channel.o \
 	wlc_main.o \
 	wlc_phy_shim.o \
+	wlc_pmu.o \
 	wlc_rate.o \
 	wlc_stf.o \
 	phy/wlc_phy_cmn.o \
@@ -52,7 +53,6 @@ BRCMSMAC_OFILES := \
 	../util/bcmotp.o \
 	../util/bcmsrom.o \
 	../util/hnddma.o \
-	../util/hndpmu.o \
 	../util/nicpci.o \
 	../util/qmath.o \
 	../util/nvram/nvram_ro.o
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index 4e7a20a..d9f6254 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -22,7 +22,7 @@
 #include <qmath.h>
 #include <linux/pci.h>
 #include <siutils.h>
-#include <hndpmu.h>
+#include <wlc_pmu.h>
 
 #include <bcmdevs.h>
 #include <sbhnddma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index 34a7b4e..111b8e9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -22,7 +22,7 @@
 #include <linux/pci.h>
 #include <siutils.h>
 #include <sbchipc.h>
-#include <hndpmu.h>
+#include <wlc_pmu.h>
 
 #include <bcmdevs.h>
 #include <sbhnddma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index daeb363..e9867ea 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -35,9 +35,9 @@
 #include <pcicfg.h>
 #include <sbhnddma.h>
 #include <hnddma.h>
-#include <hndpmu.h>
 
 #include "wlc_types.h"
+#include "wlc_pmu.h"
 #include "d11.h"
 #include "wlc_cfg.h"
 #include "wlc_rate.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index b56d613..ea12749 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -29,8 +29,8 @@
 #include <wlioctl.h>
 #include <sbhnddma.h>
 #include <hnddma.h>
-#include <hndpmu.h>
 
+#include "wlc_pmu.h"
 #include "d11.h"
 #include "wlc_types.h"
 #include "wlc_cfg.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index 0c4780d..b008582 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -36,7 +36,7 @@
 #include <pcicfg.h>
 #include <sbhnddma.h>
 #include <hnddma.h>
-#include <hndpmu.h>
+#include <wlc_pmu.h>
 
 #include "wlc_types.h"
 #include "wl_dbg.h"
diff --git a/drivers/staging/brcm80211/util/hndpmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
similarity index 99%
rename from drivers/staging/brcm80211/util/hndpmu.c
rename to drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 566e030..98ba874 100644
--- a/drivers/staging/brcm80211/util/hndpmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -24,7 +24,7 @@
 #include <bcmdevs.h>
 #include <hndsoc.h>
 #include <sbchipc.h>
-#include <hndpmu.h>
+#include <wlc_pmu.h>
 #include "siutils_priv.h"
 
 #define	PMU_ERROR(args)
diff --git a/drivers/staging/brcm80211/include/hndpmu.h b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
similarity index 100%
rename from drivers/staging/brcm80211/include/hndpmu.h
rename to drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
diff --git a/drivers/staging/brcm80211/util/siutils.c b/drivers/staging/brcm80211/util/siutils.c
index 202a8cff..2097482 100644
--- a/drivers/staging/brcm80211/util/siutils.c
+++ b/drivers/staging/brcm80211/util/siutils.c
@@ -40,7 +40,7 @@
 #include <sbsdpcmdev.h>
 #include <bcmsdpcm.h>
 #endif				/* BCMSDIO */
-#include <hndpmu.h>
+#include <wlc_pmu.h>
 
 /* this file now contains only definitions for sb functions, only necessary
 *for devices using Sonics backplanes (bcm4329)
-- 
1.7.4.1


