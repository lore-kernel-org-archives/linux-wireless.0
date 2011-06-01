Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3783 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850Ab1FALqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:35 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 51/83] staging: brcm80211: clean up dhd.h in fullmac
Date: Wed, 1 Jun 2011 13:45:36 +0200
Message-ID: <1306928768-7501-51-git-send-email-rvossen@broadcom.com> (sfid-20110601_134901_901705_7DF70DEF)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove #include lines in dhd.h

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    2 ++
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    4 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    1 +
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    1 +
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   17 -----------------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    2 ++
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    3 +++
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    3 +++
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    1 +
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    3 +++
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    3 +++
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    2 ++
 12 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index e11c615..b8af4ed 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -18,9 +18,11 @@
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/pci_ids.h>
+#include <linux/sched.h>
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmutils.h>
+#include <bcmwifi.h>
 #include <bcmsoc.h>
 
 #include <bcmsdh.h>		/* BRCM API for SDIO
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index d441500..c0b9330 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -23,16 +23,16 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/completion.h>
+#include <linux/sched.h>
 
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmutils.h>
+#include <bcmwifi.h>
 
 #if defined(OOB_INTR_ONLY)
 #include <linux/irq.h>
 extern void dhdsdio_isr(void *args);
-#include <dngl_stats.h>
-#include <dhd.h>
 #endif				/* defined(OOB_INTR_ONLY) */
 #if defined(CONFIG_MACH_SANDGATE2G) || defined(CONFIG_MACH_LOGICPD_PXA270)
 #if !defined(BCMPLATFORM_BUS)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index cc4738a..067404b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -18,6 +18,7 @@
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmutils.h>
+#include <bcmwifi.h>
 #include <sdio.h>		/* SDIO Device and Protocol Specs */
 #include <sdioh.h>		/* SDIO Host Controller Specification */
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 2792a4d..196b15e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -18,6 +18,7 @@
 #include <linux/netdevice.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
+#include <bcmwifi.h>
 #include <sdio.h>		/* SDIO Specs */
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* to get msglevel bit values */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 081cda0..1fc5202 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -21,23 +21,6 @@
 #ifndef _dhd_h_
 #define _dhd_h_
 
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/random.h>
-#include <linux/spinlock.h>
-#include <linux/ethtool.h>
-#include <linux/suspend.h>
-#include <asm/uaccess.h>
-#include <asm/unaligned.h>
-#include "bcmdefs.h"
-/* The kernel threading is sdio-specific */
-#include "bcmwifi.h"
-
 /* Forward decls */
 struct dhd_bus;
 struct dhd_prot;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 424eacb..f655322 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -16,9 +16,11 @@
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <linux/sched.h>
 #include <bcmdefs.h>
 
 #include <bcmutils.h>
+#include <bcmwifi.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 85d87db..79df125 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -15,8 +15,11 @@
  */
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/sched.h>
 #include <bcmdefs.h>
+#include <bcmwifi.h>
 #include <linux/netdevice.h>
+#include <asm/unaligned.h>
 #include <bcmutils.h>
 #include <dngl_stats.h>
 #include <dhd.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index abd41e3..a3ea415 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -15,7 +15,10 @@
  */
 
 #include <linux/netdevice.h>
+#include <linux/sched.h>
 #include <bcmutils.h>
+#include <bcmdefs.h>
+#include <bcmwifi.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index f356c56..b023fc8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -33,6 +33,7 @@
 #include <linux/uaccess.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
+#include <bcmwifi.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index ad3f0e6..cd0ea4b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -18,10 +18,13 @@
 #include <linux/kernel.h>
 #include <linux/pci_ids.h>
 #include <linux/netdevice.h>
+#include <linux/sched.h>
+#include <asm/unaligned.h>
 #include <bcmdefs.h>
 #include <bcmsdh.h>
 
 #include <bcmdefs.h>
+#include <bcmwifi.h>
 #include <bcmutils.h>
 #include <bcmdevs.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 6aa186e..2e5e996 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -16,8 +16,11 @@
 
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
+#include <linux/sched.h>
 
 #include <bcmutils.h>
+#include <bcmdefs.h>
+#include <bcmwifi.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 9819a35..da052e7e 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -18,8 +18,10 @@
 #include <linux/semaphore.h>
 #include <bcmdefs.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 
 #include <bcmutils.h>
+#include <bcmwifi.h>
 
 #include <linux/if_arp.h>
 #include <asm/uaccess.h>
-- 
1.7.4.1


