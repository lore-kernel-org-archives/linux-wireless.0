Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3DKOPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 10:15:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, brcm80211-dev-list@broadcom.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] brcm80211: simplify makefiles
Date: Thu, 11 Apr 2013 16:15:28 +0200
Message-Id: <1365689728-24873-1-git-send-email-johannes@sipsolutions.net> (sfid-20130411_161541_243183_A0AF61C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This came up during my backporting work but it seems
perfectly appropriate for the kernel as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/Makefile | 11 +++--------
 drivers/net/wireless/brcm80211/brcmutil/Makefile |  9 ++-------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
index cba19d8..32464ac 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
@@ -21,7 +21,7 @@ ccflags-y := \
 	-Idrivers/net/wireless/brcm80211/brcmsmac/phy \
 	-Idrivers/net/wireless/brcm80211/include
 
-BRCMSMAC_OFILES := \
+brcmsmac-y := \
 	mac80211_if.o \
 	ucode_loader.o \
 	ampdu.o \
@@ -43,11 +43,6 @@ BRCMSMAC_OFILES := \
 	brcms_trace_events.o \
 	debug.o
 
-ifdef CONFIG_BCMA_DRIVER_GPIO
-BRCMSMAC_OFILES += led.o
-endif
+brcmsmac-$(CONFIG_BCMA_DRIVER_GPIO) += led.o
 
-MODULEPFX := brcmsmac
-
-obj-$(CONFIG_BRCMSMAC)	+= $(MODULEPFX).o
-$(MODULEPFX)-objs	= $(BRCMSMAC_OFILES)
+obj-$(CONFIG_BRCMSMAC)	+= brcmsmac.o
diff --git a/drivers/net/wireless/brcm80211/brcmutil/Makefile b/drivers/net/wireless/brcm80211/brcmutil/Makefile
index 6281c41..8bf7500 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmutil/Makefile
@@ -19,10 +19,5 @@ ccflags-y :=				\
 	-Idrivers/net/wireless/brcm80211/brcmutil \
 	-Idrivers/net/wireless/brcm80211/include
 
-BRCMUTIL_OFILES := \
-	utils.o
-
-MODULEPFX := brcmutil
-
-obj-$(CONFIG_BRCMUTIL)	+= $(MODULEPFX).o
-$(MODULEPFX)-objs	= $(BRCMUTIL_OFILES)
+obj-$(CONFIG_BRCMUTIL)	+= brcmutil.o
+brcmutil-objs	= utils.o
-- 
1.8.0

