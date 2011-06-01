Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2414 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758863Ab1FALqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:40 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 79/83] staging: brcm80211: moved /include/srom.h into
 /brcmsmac dir
Date: Wed, 1 Jun 2011 13:46:04 +0200
Message-ID: <1306928768-7501-79-git-send-email-rvossen@broadcom.com> (sfid-20110601_134743_311812_2C7741E2)
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
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |    2 +-
 drivers/staging/brcm80211/brcmsmac/bottom_mac.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |    2 +-
 .../staging/brcm80211/{include => brcmsmac}/srom.h |    0
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename drivers/staging/brcm80211/{include => brcmsmac}/srom.h (100%)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 7eabe90..fee8966 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -29,7 +29,7 @@
 
 /* ********** from siutils.c *********** */
 #include <nicpci.h>
-#include <srom.h>
+#include "srom.h"
 #include <pmu.h>
 #include <scb.h>
 #include <pub.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/bottom_mac.c b/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
index 365cae0..719df41 100644
--- a/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
@@ -25,7 +25,7 @@
 #include <brcm_hw_ids.h>
 #include <brcmu_wifi.h>
 #include <aiutils.h>
-#include <srom.h>
+#include "srom.h"
 #include "otp.h"
 #include <brcmu_utils.h>
 #include <chipcommon.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 759e68f..fc3d71d 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -24,7 +24,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include <aiutils.h>
-#include <srom.h>
+#include "srom.h"
 #include "dma.h"
 
 #include "pmu.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 3300015..8b891f4 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -40,7 +40,7 @@
 #include "pub.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
-#include <srom.h>
+#include "srom.h"
 #include "key.h"
 #include "bottom_mac.h"
 #include "phy_hal.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 5a7b434..17e0f2a 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -27,7 +27,7 @@
 #include <brcm_hw_ids.h>
 #include <nicpci.h>
 #include <aiutils.h>
-#include <srom.h>
+#include "srom.h"
 #include "otp.h"
 
 #define SROM_OFFSET(sih) ((sih->ccrev > 31) ? \
diff --git a/drivers/staging/brcm80211/include/srom.h b/drivers/staging/brcm80211/brcmsmac/srom.h
similarity index 100%
rename from drivers/staging/brcm80211/include/srom.h
rename to drivers/staging/brcm80211/brcmsmac/srom.h
-- 
1.7.4.1


