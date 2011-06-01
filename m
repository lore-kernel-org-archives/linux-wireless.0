Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3881 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758853Ab1FALqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:35 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 67/83] staging: brcm80211: renamed utility module
 related files
Date: Wed, 1 Jun 2011 13:45:52 +0200
Message-ID: <1306928768-7501-67-git-send-email-rvossen@broadcom.com> (sfid-20110601_134737_921936_85E0F355)
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
 drivers/staging/brcm80211/Makefile                 |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    4 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    4 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    4 ++--
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    4 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    4 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    4 ++--
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    4 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    4 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    4 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    4 ++--
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    4 ++--
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |    2 +-
 drivers/staging/brcm80211/brcmsmac/bcmotp.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c       |    2 +-
 .../staging/brcm80211/brcmsmac/brcms_mac80211.c    |    4 ++--
 drivers/staging/brcm80211/brcmsmac/dma.c           |    2 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/nvram.c         |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |    4 ++--
 .../staging/brcm80211/{util => brcmutil}/Makefile  |    6 +++---
 .../{util/bcmutils.c => brcmutil/utils.c}          |    2 +-
 .../brcm80211/{util/bcmwifi.c => brcmutil/wifi.c}  |    4 ++--
 .../include/{bcmutils.h => brcmu_utils.h}          |    0
 .../brcm80211/include/{bcmwifi.h => brcmu_wifi.h}  |    0
 37 files changed, 54 insertions(+), 54 deletions(-)
 rename drivers/staging/brcm80211/{util => brcmutil}/Makefile (94%)
 rename drivers/staging/brcm80211/{util/bcmutils.c => brcmutil/utils.c} (99%)
 rename drivers/staging/brcm80211/{util/bcmwifi.c => brcmutil/wifi.c} (98%)
 rename drivers/staging/brcm80211/include/{bcmutils.h => brcmu_utils.h} (100%)
 rename drivers/staging/brcm80211/include/{bcmwifi.h => brcmu_wifi.h} (100%)

diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
index e7b3f27..db9a57e 100644
--- a/drivers/staging/brcm80211/Makefile
+++ b/drivers/staging/brcm80211/Makefile
@@ -19,6 +19,6 @@
 subdir-ccflags-y					:= -DBCMDMA32
 subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DBCMDBG -DBCMDBG_ASSERT
 
-obj-$(CONFIG_BRCMUTIL)	+= util/
+obj-$(CONFIG_BRCMUTIL)	+= brcmutil/
 obj-$(CONFIG_BRCMFMAC)	+= brcmfmac/
 obj-$(CONFIG_BRCMSMAC)	+= brcmsmac/
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 14c07e6..352ba4b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -21,8 +21,8 @@
 #include <linux/sched.h>
 #include <bcmdefs.h>
 #include <bcmdevs.h>
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 #include <bcmsoc.h>
 
 #include <bcmsdh.h>		/* BRCM API for SDIO
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index c0b9330..e7638f4 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -27,8 +27,8 @@
 
 #include <bcmdefs.h>
 #include <bcmdevs.h>
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 
 #if defined(OOB_INTR_ONLY)
 #include <linux/irq.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 1b15704..8dadfb6 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -18,8 +18,8 @@
 #include <linux/mmc/sdio.h>
 #include <bcmdefs.h>
 #include <bcmdevs.h>
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* ioctl/iovars */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index fbc9abd..e1b2592 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -18,8 +18,8 @@
 #include <linux/netdevice.h>
 #include <net/cfg80211.h>
 #include <bcmdefs.h>
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* to get msglevel bit values */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 759e899..dd872f4 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -19,8 +19,8 @@
 #include <linux/sched.h>
 #include <bcmdefs.h>
 
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 5b0554d..a8504bb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -17,10 +17,10 @@
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <bcmdefs.h>
-#include <bcmwifi.h>
+#include <brcmu_wifi.h>
 #include <linux/netdevice.h>
 #include <asm/unaligned.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <dngl_stats.h>
 #include <dhd.h>
 #include <dhd_bus.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index a942333..831f324 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -16,9 +16,9 @@
 
 #include <linux/netdevice.h>
 #include <linux/sched.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmdefs.h>
-#include <bcmwifi.h>
+#include <brcmu_wifi.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 7f1cf8b..adcf82d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -33,8 +33,8 @@
 #include <linux/uaccess.h>
 #include <net/cfg80211.h>
 #include <bcmdefs.h>
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 44839e0..0bff0ed 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -25,8 +25,8 @@
 #include <bcmsdh.h>
 
 #include <bcmdefs.h>
-#include <bcmwifi.h>
-#include <bcmutils.h>
+#include <brcmu_wifi.h>
+#include <brcmu_utils.h>
 #include <bcmdevs.h>
 
 #include <bcmsoc.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 260d12c..bc63cdf 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -18,9 +18,9 @@
 #include <linux/if_arp.h>
 #include <linux/sched.h>
 
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmdefs.h>
-#include <bcmwifi.h>
+#include <brcmu_wifi.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 99a49f9..f5725ec 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -21,8 +21,8 @@
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
 
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 
 #include <linux/if_arp.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index d57908b..b00cda9 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -20,7 +20,7 @@
 #include <bcmdefs.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <aiutils.h>
 #include <bcmsoc.h>
 #include <chipcommon.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
index cca64e4..4a0deec 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
@@ -23,7 +23,7 @@
 
 #include <bcmdefs.h>
 #include <bcmdevs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <aiutils.h>
 #include <bcmsoc.h>
 #include <chipcommon.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index 59098b0..70b7ab7 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -21,7 +21,7 @@
 #include <linux/pci.h>
 #include <stdarg.h>
 #include "wlc_types.h"
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmsoc.h>
 #include <chipcommon.h>
 #include <bcmdevs.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
index 71acc4e..509cf2b 100644
--- a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
@@ -26,8 +26,8 @@
 #include <linux/firmware.h>
 #include <net/mac80211.h>
 #include <bcmdefs.h>
-#include <bcmwifi.h>
-#include <bcmutils.h>
+#include <brcmu_wifi.h>
+#include <brcmu_utils.h>
 #include <bcmnvram.h>
 #include <nicpci.h>
 #include "bcmdma.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index ad389bc..183baf8 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -21,7 +21,7 @@
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmsoc.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <aiutils.h>
 
 #include "wlc_types.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 8a956f5..868fba2 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -18,7 +18,7 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <bcmdefs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmsoc.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/nvram.c b/drivers/staging/brcm80211/brcmsmac/nvram.c
index 5cef837..3509469 100644
--- a/drivers/staging/brcm80211/brcmsmac/nvram.c
+++ b/drivers/staging/brcm80211/brcmsmac/nvram.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <bcmdefs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmnvram.h>
 #include <chipcommon.h>
 #include <bcmdevs.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
index 6d4473c..6488cdf 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
@@ -25,7 +25,7 @@
 #include <d11.h>
 #include <wlc_phy_shim.h>
 #include <net/mac80211.h>	/* struct wiphy */
-#include "bcmwifi.h"		/* chanspec_t */
+#include "brcmu_wifi.h"		/* chanspec_t */
 
 #define	IDCODE_VER_MASK		0x0000000f
 #define	IDCODE_VER_SHIFT	0
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
index 43d0fe1..3ee29f0 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
@@ -19,7 +19,7 @@
 
 #include <linux/kernel.h>
 #include <bcmdefs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 
 #include <wlc_phy_hal.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index 619247a..77caf06 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -17,7 +17,7 @@
 #include <linux/types.h>
 
 #include <bcmdefs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <aiutils.h>
 #include "bcmdma.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index e1920ae..3668451 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -17,7 +17,7 @@
 #include <net/mac80211.h>
 
 #include <bcmdefs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <aiutils.h>
 #include "bcmdma.h"
 #include <bcmdma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index ea27b66..10b9b79 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -21,7 +21,7 @@
 #include <linux/pci.h>
 
 #include <bcmdefs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmdevs.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index fdd10ef..d23dd11 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -23,11 +23,11 @@
 
 #include <bcmdefs.h>
 #include <bcmdevs.h>
-#include <bcmwifi.h>
+#include <brcmu_wifi.h>
 #include <aiutils.h>
 #include <bcmsrom.h>
 #include <bcmotp.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmnvram.h>
 #include <chipcommon.h>
 #include <nicpci.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index ac84ddc..c4fcb44 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -20,7 +20,7 @@
 #include <linux/pci.h>
 
 #include <bcmdefs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmnvram.h>
 #include <aiutils.h>
 #include "bcmdma.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 1e79031..752f0d1 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -21,8 +21,8 @@
 
 #include <bcmdefs.h>
 #include <bcmdevs.h>
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 #include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmsrom.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index d33f720..2745743 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -25,8 +25,8 @@
 #include <linux/module.h>
 
 #include <bcmdefs.h>
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 #include <aiutils.h>
 #include <chipcommon.h>
 #include "bcmdma.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 047cd1a..9a99186 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -20,7 +20,7 @@
 
 #include <bcmdevs.h>
 #include <chipcommon.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmnvram.h>
 #include "wlc_pmu.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index de32440..8536efe 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -18,7 +18,7 @@
 #define _wlc_pub_h_
 
 #include "wlc_types.h"		/* forward structure declarations */
-#include "bcmwifi.h"		/* for chanspec_t */
+#include "brcmu_wifi.h"		/* for chanspec_t */
 
 #define	WLC_NUMRATES	16	/* max # of rates in a rateset */
 #define	MAXMULTILIST	32	/* max # multicast addresses */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index 88aa134..3625c72 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -17,7 +17,7 @@
 #include <linux/module.h>
 
 #include <bcmdefs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <aiutils.h>
 #include "bcmdma.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index b7191af..41c1f96 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -18,9 +18,9 @@
 #include <linux/module.h>
 
 #include <bcmdefs.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <aiutils.h>
-#include <bcmwifi.h>
+#include <brcmu_wifi.h>
 #include <bcmnvram.h>
 #include "bcmdma.h"
 
diff --git a/drivers/staging/brcm80211/util/Makefile b/drivers/staging/brcm80211/brcmutil/Makefile
similarity index 94%
rename from drivers/staging/brcm80211/util/Makefile
rename to drivers/staging/brcm80211/brcmutil/Makefile
index f9b36ca..6403423 100644
--- a/drivers/staging/brcm80211/util/Makefile
+++ b/drivers/staging/brcm80211/brcmutil/Makefile
@@ -16,12 +16,12 @@
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 ccflags-y :=				\
-	-Idrivers/staging/brcm80211/util \
+	-Idrivers/staging/brcm80211/brcmutil \
 	-Idrivers/staging/brcm80211/include
 
 BRCMUTIL_OFILES := \
-	bcmutils.o \
-	bcmwifi.o
+	utils.o \
+	wifi.o
 
 MODULEPFX := brcmutil
 
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/brcmutil/utils.c
similarity index 99%
rename from drivers/staging/brcm80211/util/bcmutils.c
rename to drivers/staging/brcm80211/brcmutil/utils.c
index 63e536a..59a8763 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -23,7 +23,7 @@
 #include <linux/sched.h>
 #include <bcmdefs.h>
 #include <stdarg.h>
-#include <bcmutils.h>
+#include <brcmu_utils.h>
 #include <bcmdevs.h>
 
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/drivers/staging/brcm80211/util/bcmwifi.c b/drivers/staging/brcm80211/brcmutil/wifi.c
similarity index 98%
rename from drivers/staging/brcm80211/util/bcmwifi.c
rename to drivers/staging/brcm80211/brcmutil/wifi.c
index 207cb8b..2a3db0a 100644
--- a/drivers/staging/brcm80211/util/bcmwifi.c
+++ b/drivers/staging/brcm80211/brcmutil/wifi.c
@@ -17,8 +17,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <bcmdefs.h>
-#include <bcmutils.h>
-#include <bcmwifi.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 
 /*
  * Verify the chanspec is using a legal set of parameters, i.e. that the
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmutils.h
rename to drivers/staging/brcm80211/include/brcmu_utils.h
diff --git a/drivers/staging/brcm80211/include/bcmwifi.h b/drivers/staging/brcm80211/include/brcmu_wifi.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmwifi.h
rename to drivers/staging/brcm80211/include/brcmu_wifi.h
-- 
1.7.4.1


