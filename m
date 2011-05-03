Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2394 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab1ECJga (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 56/61] staging: brcm80211: move qmath sources to phy
 directory
Date: Tue, 3 May 2011 11:35:56 +0200
Message-ID: <1304415361-7813-57-git-send-email-arend@broadcom.com> (sfid-20110503_113654_363998_F7724F2E)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions provided by qmath sources are only used by the
phy source code so qmath sources have been moved there.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile        |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |   10 +++++-----
 .../{util/qmath.c => brcmsmac/phy/wlc_phy_qmath.c} |    3 ++-
 .../qmath.h => brcmsmac/phy/wlc_phy_qmath.h}       |    0
 4 files changed, 8 insertions(+), 7 deletions(-)
 rename drivers/staging/brcm80211/{util/qmath.c => brcmsmac/phy/wlc_phy_qmath.c} (99%)
 rename drivers/staging/brcm80211/{include/qmath.h => brcmsmac/phy/wlc_phy_qmath.h} (100%)

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 8dc234d..2179774 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -47,13 +47,13 @@ BRCMSMAC_OFILES := \
 	phy/wlc_phy_n.o \
 	phy/wlc_phytbl_lcn.o \
 	phy/wlc_phytbl_n.o \
+	phy/wlc_phy_qmath.o \
 	../util/bcmutils.o \
 	../util/bcmwifi.o \
 	../util/bcmotp.o \
 	../util/bcmsrom.o \
 	../util/hnddma.o \
 	../util/nicpci.o \
-	../util/qmath.o \
 	../util/nvram/nvram_ro.o
 
 MODULEPFX := brcmsmac
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index 0722097..8fc1bef 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -19,7 +19,6 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <wlc_cfg.h>
-#include <qmath.h>
 #include <linux/pci.h>
 #include <aiutils.h>
 #include <wlc_pmu.h>
@@ -27,10 +26,11 @@
 #include <bcmdevs.h>
 #include <sbhnddma.h>
 
-#include <wlc_phy_radio.h>
-#include <wlc_phy_int.h>
-#include <wlc_phy_lcn.h>
-#include <wlc_phytbl_lcn.h>
+#include "wlc_phy_radio.h"
+#include "wlc_phy_int.h"
+#include "wlc_phy_qmath.h"
+#include "wlc_phy_lcn.h"
+#include "wlc_phytbl_lcn.h"
 
 #define PLL_2064_NDIV		90
 #define PLL_2064_LOW_END_VCO 	3000
diff --git a/drivers/staging/brcm80211/util/qmath.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
similarity index 99%
rename from drivers/staging/brcm80211/util/qmath.c
rename to drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
index 8b4a5b1..0617292 100644
--- a/drivers/staging/brcm80211/util/qmath.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
@@ -15,7 +15,8 @@
  */
 
 #include <linux/types.h>
-#include "qmath.h"
+
+#include "wlc_phy_qmath.h"
 
 /*
 Description: This function saturate input 32 bit number into a 16 bit number.
diff --git a/drivers/staging/brcm80211/include/qmath.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
similarity index 100%
rename from drivers/staging/brcm80211/include/qmath.h
rename to drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
-- 
1.7.4.1


