Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2234 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 74/83] staging: brcm80211: renamed files in brcmsmac and
 include directories
Date: Wed, 1 Jun 2011 13:45:59 +0200
Message-ID: <1306928768-7501-74-git-send-email-rvossen@broadcom.com> (sfid-20110601_134834_308011_57C4EAB3)
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
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    8 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    6 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    6 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    2 +-
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   10 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    2 +-
 drivers/staging/brcm80211/brcmsmac/Makefile        |   38 ++++++++--------
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |   16 ++++----
 .../brcm80211/brcmsmac/{wlc_alloc.c => alloc.c}    |   26 ++++++------
 .../brcm80211/brcmsmac/{wlc_alloc.h => alloc.h}    |    0
 .../brcm80211/brcmsmac/{wlc_ampdu.c => ampdu.c}    |   27 ++++++------
 .../brcm80211/brcmsmac/{wlc_ampdu.h => ampdu.h}    |    0
 .../brcm80211/brcmsmac/{wlc_antsel.c => antsel.c}  |   26 ++++++------
 .../brcm80211/brcmsmac/{wlc_antsel.h => antsel.h}  |    0
 .../brcmsmac/{wlc_bmac.c => bottom_mac.c}          |   38 ++++++++--------
 .../brcmsmac/{wlc_bmac.h => bottom_mac.h}          |   11 -----
 .../brcm80211/brcmsmac/{wlc_bsscfg.h => bsscfg.h}  |    0
 .../brcm80211/brcmsmac/{wlc_cfg.h => cfg.h}        |    0
 .../brcmsmac/{wlc_channel.c => channel.c}          |   26 ++++++------
 .../brcmsmac/{wlc_channel.h => channel.h}          |    0
 drivers/staging/brcm80211/brcmsmac/dma.c           |   11 ++---
 .../staging/brcm80211/brcmsmac/{bcmdma.h => dma.h} |    2 +-
 .../brcm80211/brcmsmac/{wlc_key.h => key.h}        |    0
 .../brcmsmac/{brcms_mac80211.c => mac80211_if.c}   |   20 ++++----
 .../brcmsmac/{brcms_mac80211.h => mac80211_if.h}   |    0
 .../brcm80211/brcmsmac/{wlc_main.c => main.c}      |   45 ++++++++++----------
 .../brcm80211/brcmsmac/{wlc_main.h => main.h}      |    2 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |   12 +++---
 .../staging/brcm80211/brcmsmac/{bcmotp.c => otp.c} |   10 ++--
 .../staging/brcm80211/brcmsmac/{bcmotp.h => otp.h} |    0
 .../brcmsmac/phy/{wlc_phy_cmn.c => phy_cmn.c}      |   18 ++++----
 .../brcmsmac/phy/{wlc_phy_hal.h => phy_hal.h}      |    2 +-
 .../brcmsmac/phy/{wlc_phy_int.h => phy_int.h}      |    4 +-
 .../brcmsmac/phy/{wlc_phy_lcn.c => phy_lcn.c}      |   22 +++++-----
 .../brcmsmac/phy/{wlc_phy_lcn.h => phy_lcn.h}      |    0
 .../brcmsmac/phy/{wlc_phy_n.c => phy_n.c}          |   20 ++++----
 .../brcmsmac/phy/{wlc_phy_qmath.c => phy_qmath.c}  |    2 +-
 .../brcmsmac/phy/{wlc_phy_qmath.h => phy_qmath.h}  |    0
 .../brcmsmac/phy/{wlc_phy_radio.h => phy_radio.h}  |    0
 .../brcmsmac/phy/{wlc_phyreg_n.h => phyreg_n.h}    |    0
 .../phy/{wlc_phytbl_lcn.c => phytbl_lcn.c}         |    6 +-
 .../phy/{wlc_phytbl_lcn.h => phytbl_lcn.h}         |    0
 .../brcmsmac/phy/{wlc_phytbl_n.c => phytbl_n.c}    |    6 +-
 .../brcmsmac/phy/{wlc_phytbl_n.h => phytbl_n.h}    |    0
 .../brcmsmac/{wlc_phy_shim.c => phy_shim.c}        |   34 +++++++-------
 .../brcmsmac/{wlc_phy_shim.h => phy_shim.h}        |    0
 .../brcm80211/brcmsmac/{wlc_pmu.c => pmu.c}        |   10 ++--
 .../brcm80211/brcmsmac/{wlc_pmu.h => pmu.h}        |    0
 .../brcm80211/brcmsmac/{wlc_pub.h => pub.h}        |    2 +-
 .../brcm80211/brcmsmac/{wlc_rate.c => rate.c}      |   14 +++---
 .../brcm80211/brcmsmac/{wlc_rate.h => rate.h}      |    0
 .../brcm80211/brcmsmac/{wlc_scb.h => scb.h}        |    0
 .../brcm80211/brcmsmac/{bcmsrom.c => srom.c}       |   12 +++---
 .../brcm80211/brcmsmac/{wlc_stf.c => stf.c}        |   26 ++++++------
 .../brcm80211/brcmsmac/{wlc_stf.h => stf.h}        |    0
 .../brcm80211/brcmsmac/{wlc_types.h => types.h}    |    2 +-
 drivers/staging/brcm80211/brcmsmac/ucode_loader.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/ucode_loader.h  |    2 +-
 drivers/staging/brcm80211/brcmutil/utils.c         |    4 +-
 drivers/staging/brcm80211/brcmutil/wifi.c          |    2 +-
 drivers/staging/brcm80211/include/aidmp.h          |    2 +-
 .../brcm80211/include/{bcmdevs.h => brcm_hw_ids.h} |    0
 drivers/staging/brcm80211/include/chipcommon.h     |    2 +-
 .../brcm80211/include/{bcmdefs.h => defs.h}        |    0
 .../brcm80211/include/{bcmsdh.h => sdio_host.h}    |    0
 .../staging/brcm80211/include/{bcmsoc.h => soc.h}  |    0
 .../brcm80211/include/{bcmsrom.h => srom.h}        |    0
 72 files changed, 268 insertions(+), 282 deletions(-)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_alloc.c => alloc.c} (95%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_alloc.h => alloc.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_ampdu.c => ampdu.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_ampdu.h => ampdu.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_antsel.c => antsel.c} (97%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_antsel.h => antsel.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_bmac.c => bottom_mac.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_bmac.h => bottom_mac.h} (94%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_bsscfg.h => bsscfg.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_cfg.h => cfg.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_channel.c => channel.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_channel.h => channel.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{bcmdma.h => dma.h} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_key.h => key.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{brcms_mac80211.c => mac80211_if.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{brcms_mac80211.h => mac80211_if.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_main.c => main.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_main.h => main.h} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{bcmotp.c => otp.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{bcmotp.h => otp.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phy_cmn.c => phy_cmn.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phy_hal.h => phy_hal.h} (99%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phy_int.h => phy_int.h} (99%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phy_lcn.c => phy_lcn.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phy_lcn.h => phy_lcn.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phy_n.c => phy_n.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phy_qmath.c => phy_qmath.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phy_qmath.h => phy_qmath.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phy_radio.h => phy_radio.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phyreg_n.h => phyreg_n.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phytbl_lcn.c => phytbl_lcn.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phytbl_lcn.h => phytbl_lcn.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phytbl_n.c => phytbl_n.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/phy/{wlc_phytbl_n.h => phytbl_n.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_phy_shim.c => phy_shim.c} (93%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_phy_shim.h => phy_shim.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_pmu.c => pmu.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_pmu.h => pmu.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_pub.h => pub.h} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_rate.c => rate.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_rate.h => rate.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_scb.h => scb.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{bcmsrom.c => srom.c} (99%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_stf.c => stf.c} (97%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_stf.h => stf.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{wlc_types.h => types.h} (98%)
 rename drivers/staging/brcm80211/include/{bcmdevs.h => brcm_hw_ids.h} (100%)
 rename drivers/staging/brcm80211/include/{bcmdefs.h => defs.h} (100%)
 rename drivers/staging/brcm80211/include/{bcmsdh.h => sdio_host.h} (100%)
 rename drivers/staging/brcm80211/include/{bcmsoc.h => soc.h} (100%)
 rename drivers/staging/brcm80211/include/{bcmsrom.h => srom.h} (100%)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 352ba4b..d6e90d7 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -19,13 +19,13 @@
 #include <linux/netdevice.h>
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
-#include <bcmdefs.h>
-#include <bcmdevs.h>
+#include <defs.h>
+#include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-#include <bcmsoc.h>
+#include <soc.h>
 
-#include <bcmsdh.h>		/* BRCM API for SDIO
+#include <sdio_host.h>		/* BRCM API for SDIO
 			 clients (such as wl, dhd) */
 #include <bcmsdbus.h>		/* common SDIO/controller interface */
 #include <sbsdio.h>		/* BRCM sdio device core */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 5812b5b..37cf61a 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -25,10 +25,10 @@
 #include <linux/completion.h>
 #include <linux/sched.h>
 
-#include <bcmdefs.h>
-#include <bcmdevs.h>
+#include <defs.h>
+#include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
-#include <bcmsdh.h>
+#include <sdio_host.h>
 #include <brcmu_wifi.h>
 
 #if defined(OOB_INTR_ONLY)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 9abd620..03a5966 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -16,11 +16,11 @@
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/mmc/sdio.h>
-#include <bcmdefs.h>
-#include <bcmdevs.h>
+#include <defs.h>
+#include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-#include <bcmsdh.h>
+#include <sdio_host.h>
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* ioctl/iovars */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 2da07e2..85ed095 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -17,10 +17,10 @@
 #include <linux/sched.h>	/* request_irq() */
 #include <linux/netdevice.h>
 #include <net/cfg80211.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-#include <bcmsdh.h>
+#include <sdio_host.h>
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* to get msglevel bit values */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index dd872f4..2220941 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -17,7 +17,7 @@
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
-#include <bcmdefs.h>
+#include <defs.h>
 
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index a8504bb..73d8b02 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -16,7 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/sched.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_wifi.h>
 #include <linux/netdevice.h>
 #include <asm/unaligned.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index 831f324..6008888 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -17,7 +17,7 @@
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <brcmu_utils.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_wifi.h>
 
 #include <dngl_stats.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index adcf82d..b48447c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -32,7 +32,7 @@
 #include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <net/cfg80211.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 397798a..966d98d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -21,15 +21,15 @@
 #include <linux/sched.h>
 #include <linux/mmc/sdio.h>
 #include <asm/unaligned.h>
-#include <bcmdefs.h>
-#include <bcmsdh.h>
+#include <defs.h>
+#include <sdio_host.h>
 
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
-#include <bcmdevs.h>
+#include <brcm_hw_ids.h>
 
-#include <bcmsoc.h>
+#include <soc.h>
 
 /* register access macros */
 #ifndef __BIG_ENDIAN
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index bc63cdf..cbd0e83 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -19,7 +19,7 @@
 #include <linux/sched.h>
 
 #include <brcmu_utils.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_wifi.h>
 
 #include <asm/uaccess.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index f5725ec..c65affc 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -16,7 +16,7 @@
 
 #include <linux/kthread.h>
 #include <linux/semaphore.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 1b2afa9..ee5c3f0 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -28,27 +28,27 @@ ccflags-y :=				\
 	-Idrivers/staging/brcm80211/include
 
 BRCMSMAC_OFILES := \
-	brcms_mac80211.o \
+	mac80211_if.o \
 	ucode_loader.o \
-	wlc_alloc.o \
-	wlc_ampdu.o \
-	wlc_antsel.o \
-	wlc_bmac.o \
-	wlc_channel.o \
-	wlc_main.o \
-	wlc_phy_shim.o \
-	wlc_pmu.o \
-	wlc_rate.o \
-	wlc_stf.o \
+	alloc.o \
+	ampdu.o \
+	antsel.o \
+	bottom_mac.o \
+	channel.o \
+	main.o \
+	phy_shim.o \
+	pmu.o \
+	rate.o \
+	stf.o \
 	aiutils.o \
-	phy/wlc_phy_cmn.o \
-	phy/wlc_phy_lcn.o \
-	phy/wlc_phy_n.o \
-	phy/wlc_phytbl_lcn.o \
-	phy/wlc_phytbl_n.o \
-	phy/wlc_phy_qmath.o \
-	bcmotp.o \
-	bcmsrom.o \
+	phy/phy_cmn.o \
+	phy/phy_lcn.o \
+	phy/phy_n.o \
+	phy/phytbl_lcn.o \
+	phy/phytbl_n.o \
+	phy/phy_qmath.o \
+	otp.o \
+	srom.o \
 	dma.o \
 	nicpci.o
 
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 7a8bab7..1f87b32 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -17,22 +17,22 @@
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <bcmdefs.h>
-#include "wlc_types.h"
+#include <defs.h>
+#include "types.h"
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
-#include <bcmsoc.h>
+#include <soc.h>
 #include <chipcommon.h>
-#include <bcmdevs.h>
+#include <brcm_hw_ids.h>
 
 /* ********** from siutils.c *********** */
 #include <nicpci.h>
-#include <bcmsrom.h>
-#include <wlc_pmu.h>
-#include <wlc_scb.h>
-#include <wlc_pub.h>
+#include <srom.h>
+#include <pmu.h>
+#include <scb.h>
+#include <pub.h>
 
 /* slow_clk_ctl */
 #define SCC_SS_MASK		0x00000007	/* slow clock source mask */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
similarity index 95%
rename from drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
rename to drivers/staging/brcm80211/brcmsmac/alloc.c
index 77caf06..1758640 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -16,23 +16,23 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
-#include "bcmdma.h"
+#include "dma.h"
 
 #include "d11.h"
-#include "wlc_types.h"
-#include "wlc_cfg.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "wlc_key.h"
-#include "wlc_alloc.h"
-#include "wlc_rate.h"
-#include "wlc_bsscfg.h"
-#include "phy/wlc_phy_hal.h"
-#include "wlc_channel.h"
-#include "wlc_main.h"
+#include "types.h"
+#include "cfg.h"
+#include "scb.h"
+#include "pub.h"
+#include "key.h"
+#include "alloc.h"
+#include "rate.h"
+#include "bsscfg.h"
+#include "phy/phy_hal.h"
+#include "channel.h"
+#include "main.h"
 
 static struct wlc_bsscfg *wlc_bsscfg_malloc(uint unit);
 static void wlc_bsscfg_mfree(struct wlc_bsscfg *cfg);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.h b/drivers/staging/brcm80211/brcmsmac/alloc.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_alloc.h
rename to drivers/staging/brcm80211/brcmsmac/alloc.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
rename to drivers/staging/brcm80211/brcmsmac/ampdu.c
index 3668451..ab6c496 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -16,24 +16,23 @@
 #include <linux/kernel.h>
 #include <net/mac80211.h>
 
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
-#include "bcmdma.h"
-#include <bcmdma.h>
+#include "dma.h"
 #include <d11.h>
 
-#include "wlc_types.h"
-#include "wlc_cfg.h"
-#include "wlc_rate.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "wlc_key.h"
-#include "phy/wlc_phy_hal.h"
-#include "wlc_antsel.h"
-#include "wlc_channel.h"
-#include "wlc_main.h"
-#include "wlc_ampdu.h"
+#include "types.h"
+#include "cfg.h"
+#include "rate.h"
+#include "scb.h"
+#include "pub.h"
+#include "key.h"
+#include "phy/phy_hal.h"
+#include "antsel.h"
+#include "channel.h"
+#include "main.h"
+#include "ampdu.h"
 
 #define AMPDU_MAX_MPDU		32	/* max number of mpdus in an ampdu */
 #define AMPDU_NUM_MPDU_LEGACY	16	/* max number of mpdus in an ampdu to a legacy */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h b/drivers/staging/brcm80211/brcmsmac/ampdu.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h
rename to drivers/staging/brcm80211/brcmsmac/ampdu.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
similarity index 97%
rename from drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
rename to drivers/staging/brcm80211/brcmsmac/antsel.c
index 275369a..31bc7c4 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -14,28 +14,28 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <wlc_cfg.h>
+#include <cfg.h>
 
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
-#include <bcmdevs.h>
-#include "bcmdma.h"
+#include <brcm_hw_ids.h>
+#include "dma.h"
 
 #include "d11.h"
-#include "wlc_rate.h"
-#include "wlc_key.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "phy/wlc_phy_hal.h"
-#include "wlc_bmac.h"
-#include "wlc_channel.h"
-#include "wlc_main.h"
-#include "wlc_antsel.h"
+#include "rate.h"
+#include "key.h"
+#include "scb.h"
+#include "pub.h"
+#include "phy/phy_hal.h"
+#include "bottom_mac.h"
+#include "channel.h"
+#include "main.h"
+#include "antsel.h"
 
 #define ANT_SELCFG_AUTO		0x80	/* bit indicates antenna sel AUTO */
 #define ANT_SELCFG_MASK		0x33	/* antenna configuration mask */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.h b/drivers/staging/brcm80211/brcmsmac/antsel.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_antsel.h
rename to drivers/staging/brcm80211/brcmsmac/antsel.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
rename to drivers/staging/brcm80211/brcmsmac/bottom_mac.c
index 06d03b6..365cae0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
@@ -21,33 +21,33 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 
-#include <bcmdefs.h>
-#include <bcmdevs.h>
+#include <defs.h>
+#include <brcm_hw_ids.h>
 #include <brcmu_wifi.h>
 #include <aiutils.h>
-#include <bcmsrom.h>
-#include <bcmotp.h>
+#include <srom.h>
+#include "otp.h"
 #include <brcmu_utils.h>
 #include <chipcommon.h>
 #include <nicpci.h>
-#include <bcmdma.h>
+#include "dma.h"
 
-#include "wlc_types.h"
-#include "wlc_pmu.h"
+#include "types.h"
+#include "pmu.h"
 #include "d11.h"
-#include "wlc_cfg.h"
-#include "wlc_rate.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "wlc_key.h"
-#include "phy/wlc_phy_hal.h"
-#include "wlc_channel.h"
-#include "wlc_main.h"
+#include "cfg.h"
+#include "rate.h"
+#include "scb.h"
+#include "pub.h"
+#include "key.h"
+#include "phy/phy_hal.h"
+#include "channel.h"
+#include "main.h"
 #include "ucode_loader.h"
-#include "wlc_antsel.h"
-#include "wlc_alloc.h"
-#include "wlc_bmac.h"
-#include "brcms_mac80211.h"
+#include "antsel.h"
+#include "alloc.h"
+#include "bottom_mac.h"
+#include "mac80211_if.h"
 
 #define	TIMER_INTERVAL_WATCHDOG_BMAC	1000	/* watchdog timer, in unit of ms */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h b/drivers/staging/brcm80211/brcmsmac/bottom_mac.h
similarity index 94%
rename from drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
rename to drivers/staging/brcm80211/brcmsmac/bottom_mac.h
index 8a582d1..af8af69 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/bottom_mac.h
@@ -16,17 +16,6 @@
 #ifndef _BRCM_BOTTOM_MAC_H_
 #define _BRCM_BOTTOM_MAC_H_
 
-/* XXXXX this interface is under wlc.c by design
- * http://hwnbu-twiki.broadcom.com/bin/view/Mwgroup/WlBmacDesign
- *
- *        high driver files(e.g. wlc_ampdu.c etc)
- *             wlc.h/wlc.c
- *         wlc_bmac.h/wlc_bmac.c
- *
- *  So don't include this in files other than wlc.c, wlc_bmac* wl_rte.c(dongle port) and wl_phy.c
- *  create wrappers in wlc.c if needed
- */
-
 /* dup state between BMAC(struct wlc_hw_info) and HIGH(struct wlc_info)
    driver */
 typedef struct wlc_bmac_state {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h b/drivers/staging/brcm80211/brcmsmac/bsscfg.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h
rename to drivers/staging/brcm80211/brcmsmac/bsscfg.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_cfg.h b/drivers/staging/brcm80211/brcmsmac/cfg.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_cfg.h
rename to drivers/staging/brcm80211/brcmsmac/cfg.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wlc_channel.c
rename to drivers/staging/brcm80211/brcmsmac/channel.c
index 9897123..5dce267 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -19,23 +19,23 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
-#include "bcmdma.h"
+#include "dma.h"
 
-#include "wlc_types.h"
+#include "types.h"
 #include "d11.h"
-#include "wlc_cfg.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "wlc_key.h"
-#include "phy/wlc_phy_hal.h"
-#include "wlc_bmac.h"
-#include "wlc_rate.h"
-#include "wlc_channel.h"
-#include "wlc_main.h"
-#include "wlc_stf.h"
+#include "cfg.h"
+#include "scb.h"
+#include "pub.h"
+#include "key.h"
+#include "phy/phy_hal.h"
+#include "bottom_mac.h"
+#include "rate.h"
+#include "channel.h"
+#include "main.h"
+#include "stf.h"
 
 #define	VALID_CHANNEL20_DB(wlc, val) wlc_valid_channel20_db((wlc)->cmi, val)
 #define	VALID_CHANNEL20_IN_BAND(wlc, bandunit, val) \
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_channel.h
rename to drivers/staging/brcm80211/brcmsmac/channel.h
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 183baf8..ce02324 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -18,15 +18,14 @@
 #include <linux/string.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
-#include <bcmdefs.h>
-#include <bcmdevs.h>
-#include <bcmsoc.h>
+#include <defs.h>
+#include <brcm_hw_ids.h>
+#include <soc.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
 
-#include "wlc_types.h"
-#include "bcmdma.h"
-#include <bcmdma.h>
+#include "types.h"
+#include "dma.h"
 
 #if defined(__mips__)
 #include <asm/addrspace.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmdma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/bcmdma.h
rename to drivers/staging/brcm80211/brcmsmac/dma.h
index 0490803..70c9ad6 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmdma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -17,7 +17,7 @@
 #ifndef	_BRCM_DMA_H_
 #define	_BRCM_DMA_H_
 
-#include "wlc_types.h"		/* forward structure declarations */
+#include "types.h"		/* forward structure declarations */
 
 #ifndef _dma_pub_
 #define _dma_pub_
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_key.h b/drivers/staging/brcm80211/brcmsmac/key.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_key.h
rename to drivers/staging/brcm80211/brcmsmac/key.h
diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
rename to drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 6449743..1029392 100644
--- a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -25,22 +25,22 @@
 #include <linux/sched.h>
 #include <linux/firmware.h>
 #include <net/mac80211.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include <nicpci.h>
-#include "bcmdma.h"
+#include "dma.h"
 
-#include "phy/wlc_phy_int.h"
+#include "phy/phy_int.h"
 #include "d11.h"
-#include "wlc_types.h"
-#include "wlc_cfg.h"
-#include "wlc_key.h"
-#include "wlc_channel.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
+#include "types.h"
+#include "cfg.h"
+#include "key.h"
+#include "channel.h"
+#include "scb.h"
+#include "pub.h"
 #include "ucode_loader.h"
-#include "brcms_mac80211.h"
+#include "mac80211_if.h"
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h
rename to drivers/staging/brcm80211/brcmsmac/mac80211_if.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/main.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wlc_main.c
rename to drivers/staging/brcm80211/brcmsmac/main.c
index 7c86abc..759e68f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -19,34 +19,33 @@
 #include <linux/pci_ids.h>
 #include <net/mac80211.h>
 
-#include <bcmdefs.h>
-#include <bcmdevs.h>
+#include <defs.h>
+#include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include <aiutils.h>
-#include <bcmsrom.h>
-#include "bcmdma.h"
-#include <bcmdma.h>
+#include <srom.h>
+#include "dma.h"
 
-#include "wlc_pmu.h"
+#include "pmu.h"
 #include "d11.h"
-#include "wlc_types.h"
-#include "wlc_cfg.h"
-#include "wlc_rate.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "wlc_key.h"
-#include "wlc_bsscfg.h"
-#include "phy/wlc_phy_hal.h"
-#include "wlc_channel.h"
-#include "wlc_main.h"
-#include "wlc_bmac.h"
-#include "wlc_phy_hal.h"
-#include "wlc_antsel.h"
-#include "wlc_stf.h"
-#include "wlc_ampdu.h"
-#include "wlc_alloc.h"
-#include "brcms_mac80211.h"
+#include "types.h"
+#include "cfg.h"
+#include "rate.h"
+#include "scb.h"
+#include "pub.h"
+#include "key.h"
+#include "bsscfg.h"
+#include "phy/phy_hal.h"
+#include "channel.h"
+#include "main.h"
+#include "bottom_mac.h"
+#include "phy_hal.h"
+#include "antsel.h"
+#include "stf.h"
+#include "ampdu.h"
+#include "alloc.h"
+#include "mac80211_if.h"
 
 /*
  * WPA(2) definitions
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/main.h
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wlc_main.h
rename to drivers/staging/brcm80211/brcmsmac/main.h
index acba50b..f556faf 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -166,7 +166,7 @@ extern const u8 prio2fifo[];
 #define	MAXTXFRAMEBURST		8	/* vanilla xpress mode: max frames/burst */
 #define	MAXFRAMEBURST_TXOP	10000	/* Frameburst TXOP in usec */
 
-/* Per-AC retry limit register definitions; uses bcmdefs.h bitfield macros */
+/* Per-AC retry limit register definitions; uses defs.h bitfield macros */
 #define EDCF_SHORT_S            0
 #define EDCF_SFB_S              4
 #define EDCF_LONG_S             8
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 3ffad2e..ca781c4 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -17,15 +17,15 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/pci.h>
-#include <bcmdefs.h>
-#include "wlc_types.h"
+#include <defs.h>
+#include "types.h"
 #include <brcmu_utils.h>
 #include <aiutils.h>
-#include <bcmsoc.h>
-#include <bcmdevs.h>
+#include <soc.h>
+#include <brcm_hw_ids.h>
 #include <chipcommon.h>
-#include <wlc_scb.h>
-#include <wlc_pub.h>
+#include <scb.h>
+#include <pub.h>
 #include <nicpci.h>
 
 /* SPROM offsets */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/bcmotp.c
rename to drivers/staging/brcm80211/brcmsmac/otp.c
index baed204..d21d6ca 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -21,14 +21,14 @@
 #include <linux/pci.h>
 #include <linux/crc-ccitt.h>
 
-#include <bcmdefs.h>
-#include <bcmdevs.h>
-#include "wlc_types.h"
+#include <defs.h>
+#include <brcm_hw_ids.h>
+#include "types.h"
 #include <brcmu_utils.h>
 #include <aiutils.h>
-#include <bcmsoc.h>
+#include <soc.h>
 #include <chipcommon.h>
-#include <bcmotp.h>
+#include "otp.h"
 
 #define OTPS_GUP_MASK		0x00000f00
 #define OTPS_GUP_SHIFT		8
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.h b/drivers/staging/brcm80211/brcmsmac/otp.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/bcmotp.h
rename to drivers/staging/brcm80211/brcmsmac/otp.h
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
rename to drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index b2866de..c67bf8b 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -14,7 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <wlc_cfg.h>
+#include <cfg.h>
 
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -23,16 +23,16 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include <bcmdefs.h>
+#include <defs.h>
 #include <chipcommon.h>
-#include <bcmdevs.h>
-#include "bcmdma.h"
-
-#include <wlc_types.h>
-#include <wlc_phy_int.h>
-#include <wlc_phyreg_n.h>
-#include <wlc_phy_radio.h>
-#include <wlc_phy_lcn.h>
+#include <brcm_hw_ids.h>
+#include <dma.h>
+
+#include <types.h>
+#include <phy_int.h>
+#include <phyreg_n.h>
+#include <phy_radio.h>
+#include <phy_lcn.h>
 
 u32 phyhal_msg_level = PHYHAL_ERROR;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
rename to drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 4d03933..8bd0d13 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -23,7 +23,7 @@
 
 #include <aiutils.h>
 #include <d11.h>
-#include <wlc_phy_shim.h>
+#include <phy_shim.h>
 #include <net/mac80211.h>	/* struct wiphy */
 #include "brcmu_wifi.h"		/* chanspec_t */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
rename to drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index ce417e6..f3fddfc 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -18,10 +18,10 @@
 #define _BRCM_PHY_INT_H_
 
 #include <linux/kernel.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 
-#include <wlc_phy_hal.h>
+#include <phy_hal.h>
 
 #define	PHY_VERSION			{ 1, 82, 8, 0 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
rename to drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index a3655ca..de301aad 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -18,22 +18,22 @@
 #include <linux/string.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
-#include <wlc_cfg.h>
+#include <cfg.h>
 #include <linux/pci.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
-#include <wlc_pmu.h>
-#include <wlc_scb.h>
-#include <wlc_pub.h>
-
-#include <bcmdevs.h>
-#include "bcmdma.h"
-
-#include "wlc_phy_radio.h"
-#include "wlc_phy_int.h"
-#include "wlc_phy_qmath.h"
-#include "wlc_phy_lcn.h"
-#include "wlc_phytbl_lcn.h"
+#include <pmu.h>
+#include <scb.h>
+#include <pub.h>
+
+#include <brcm_hw_ids.h>
+#include <dma.h>
+
+#include "phy_radio.h"
+#include "phy_int.h"
+#include "phy_qmath.h"
+#include "phy_lcn.h"
+#include "phytbl_lcn.h"
 
 #define PLL_2064_NDIV		90
 #define PLL_2064_LOW_END_VCO 	3000
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.h
rename to drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
rename to drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index da2afbb..0dc614a 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -16,22 +16,22 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <bcmdefs.h>
-#include <wlc_cfg.h>
+#include <defs.h>
+#include <cfg.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <aiutils.h>
 #include <chipcommon.h>
-#include <wlc_pmu.h>
+#include <pmu.h>
 
-#include <bcmdevs.h>
-#include "bcmdma.h"
+#include <brcm_hw_ids.h>
+#include <dma.h>
 
-#include <wlc_types.h>
-#include <wlc_phy_radio.h>
-#include <wlc_phy_int.h>
-#include <wlc_phyreg_n.h>
-#include <wlc_phytbl_n.h>
+#include <types.h>
+#include <phy_radio.h>
+#include <phy_int.h>
+#include <phyreg_n.h>
+#include <phytbl_n.h>
 
 #define	READ_RADIO_REG2(pi, radio_type, jspace, core, reg_name) \
 	read_radio_reg(pi, radio_type##_##jspace##_##reg_name | \
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
rename to drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
index c98176f..801c7c0 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
@@ -16,7 +16,7 @@
 
 #include <linux/types.h>
 
-#include "wlc_phy_qmath.h"
+#include "phy_qmath.h"
 
 /*
 Description: This function make 16 bit unsigned multiplication. To fit the output into
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
rename to drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.h
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_radio.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_radio.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_radio.h
rename to drivers/staging/brcm80211/brcmsmac/phy/phy_radio.h
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phyreg_n.h b/drivers/staging/brcm80211/brcmsmac/phy/phyreg_n.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phyreg_n.h
rename to drivers/staging/brcm80211/brcmsmac/phy/phyreg_n.h
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c
rename to drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 679002e..4dcc691 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -15,9 +15,9 @@
  */
 
 #include <linux/types.h>
-#include "bcmdma.h"
-#include <wlc_phy_int.h>
-#include <wlc_phytbl_lcn.h>
+#include <dma.h>
+#include <phy_int.h>
+#include <phytbl_lcn.h>
 
 const u32 dot11lcn_gain_tbl_rev0[] = {
 	0x00000000,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.h
rename to drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c
rename to drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
index ad41a19..1dd613a 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
@@ -16,9 +16,9 @@
 
 #include <linux/kernel.h>
 
-#include "bcmdma.h"
-#include <wlc_phy_int.h>
-#include <wlc_phytbl_n.h>
+#include <dma.h>
+#include <phy_int.h>
+#include <phytbl_n.h>
 
 const u32 frame_struct_rev0[] = {
 	0x08004a04,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.h
rename to drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
similarity index 93%
rename from drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
rename to drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 2745743..3300015 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -24,29 +24,29 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include <aiutils.h>
 #include <chipcommon.h>
-#include "bcmdma.h"
-#include <wlc_pmu.h>
+#include "dma.h"
+#include <pmu.h>
 
-#include "wlc_types.h"
-#include "wlc_cfg.h"
+#include "types.h"
+#include "cfg.h"
 #include "d11.h"
-#include "wlc_rate.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "phy/wlc_phy_hal.h"
-#include "wlc_channel.h"
-#include "bcmsrom.h"
-#include "wlc_key.h"
-#include "wlc_bmac.h"
-#include "wlc_phy_hal.h"
-#include "wlc_main.h"
-#include "wlc_phy_shim.h"
-#include "brcms_mac80211.h"
+#include "rate.h"
+#include "scb.h"
+#include "pub.h"
+#include "phy/phy_hal.h"
+#include "channel.h"
+#include <srom.h>
+#include "key.h"
+#include "bottom_mac.h"
+#include "phy_hal.h"
+#include "main.h"
+#include "phy_shim.h"
+#include "mac80211_if.h"
 
 /* PHY SHIM module specific state */
 struct wlc_phy_shim_info {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h
rename to drivers/staging/brcm80211/brcmsmac/phy_shim.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
rename to drivers/staging/brcm80211/brcmsmac/pmu.c
index 720839b..b822d40 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -18,13 +18,13 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 
-#include <bcmdevs.h>
-#include "wlc_types.h"
+#include <brcm_hw_ids.h>
+#include "types.h"
 #include <chipcommon.h>
 #include <brcmu_utils.h>
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "wlc_pmu.h"
+#include "scb.h"
+#include "pub.h"
+#include "pmu.h"
 
 /*
  * d11 slow to fast clock transition time in slow clock cycles
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h b/drivers/staging/brcm80211/brcmsmac/pmu.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
rename to drivers/staging/brcm80211/brcmsmac/pmu.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wlc_pub.h
rename to drivers/staging/brcm80211/brcmsmac/pub.h
index 20df964..e5f24b0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -17,7 +17,7 @@
 #ifndef _BRCM_PUB_H_
 #define _BRCM_PUB_H_
 
-#include "wlc_types.h"		/* forward structure declarations */
+#include "types.h"		/* forward structure declarations */
 #include "brcmu_wifi.h"		/* for chanspec_t */
 
 #define	WLC_NUMRATES	16	/* max # of rates in a rateset */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/wlc_rate.c
rename to drivers/staging/brcm80211/brcmsmac/rate.c
index 3625c72..807c0f6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -16,17 +16,17 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
-#include "bcmdma.h"
+#include "dma.h"
 
-#include "wlc_types.h"
+#include "types.h"
 #include "d11.h"
-#include "wlc_cfg.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "wlc_rate.h"
+#include "cfg.h"
+#include "scb.h"
+#include "pub.h"
+#include "rate.h"
 
 /* Rate info per rate: It tells whether a rate is ofdm or not and its phy_rate value */
 const u8 rate_info[WLC_MAXRATE + 1] = {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_rate.h
rename to drivers/staging/brcm80211/brcmsmac/rate.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_scb.h
rename to drivers/staging/brcm80211/brcmsmac/scb.h
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/bcmsrom.c
rename to drivers/staging/brcm80211/brcmsmac/srom.c
index 8b22add..5a7b434 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -16,19 +16,19 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/etherdevice.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <stdarg.h>
-#include "wlc_types.h"
+#include "types.h"
 #include <brcmu_utils.h>
-#include <bcmsoc.h>
+#include <soc.h>
 #include <chipcommon.h>
-#include <bcmdevs.h>
+#include <brcm_hw_ids.h>
 #include <nicpci.h>
 #include <aiutils.h>
-#include <bcmsrom.h>
-#include <bcmotp.h>
+#include <srom.h>
+#include "otp.h"
 
 #define SROM_OFFSET(sih) ((sih->ccrev > 31) ? \
 	(((sih->cccaps & CC_CAP_SROM) == 0) ? NULL : \
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
similarity index 97%
rename from drivers/staging/brcm80211/brcmsmac/wlc_stf.c
rename to drivers/staging/brcm80211/brcmsmac/stf.c
index 697da28..a0abef3 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -17,24 +17,24 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
 #include <brcmu_wifi.h>
-#include "bcmdma.h"
+#include "dma.h"
 
-#include "wlc_types.h"
+#include "types.h"
 #include "d11.h"
-#include "wlc_cfg.h"
-#include "wlc_rate.h"
-#include "wlc_scb.h"
-#include "wlc_pub.h"
-#include "wlc_key.h"
-#include "phy/wlc_phy_hal.h"
-#include "wlc_channel.h"
-#include "wlc_main.h"
-#include "wlc_bmac.h"
-#include "wlc_stf.h"
+#include "cfg.h"
+#include "rate.h"
+#include "scb.h"
+#include "pub.h"
+#include "key.h"
+#include "phy/phy_hal.h"
+#include "channel.h"
+#include "main.h"
+#include "bottom_mac.h"
+#include "stf.h"
 
 #define MIN_SPATIAL_EXPANSION	0
 #define MAX_SPATIAL_EXPANSION	1
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.h b/drivers/staging/brcm80211/brcmsmac/stf.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmsmac/wlc_stf.h
rename to drivers/staging/brcm80211/brcmsmac/stf.h
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/types.h
similarity index 98%
rename from drivers/staging/brcm80211/brcmsmac/wlc_types.h
rename to drivers/staging/brcm80211/brcmsmac/types.h
index fa8d129..d15860b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -151,7 +151,7 @@ struct wlc_bsscfg;
 struct brcmu_strbuf;
 struct si_pub;
 
-/* brcm_msg_level is a bit vector with defs in bcmdefs.h */
+/* brcm_msg_level is a bit vector with defs in defs.h */
 extern u32 brcm_msg_level;
 
 #endif				/* _BRCM_TYPES_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/ucode_loader.c b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
index d38f124..32d5196 100644
--- a/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
+++ b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
@@ -15,7 +15,7 @@
  */
 
 #include <linux/types.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <ucode_loader.h>
 
 enum {
diff --git a/drivers/staging/brcm80211/brcmsmac/ucode_loader.h b/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
index 4b90121..ca53dec 100644
--- a/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
+++ b/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
@@ -14,7 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "wlc_types.h"		/* forward structure declarations */
+#include "types.h"		/* forward structure declarations */
 
 #define MIN_FW_SIZE 40000	/* minimum firmware file size in bytes */
 #define MAX_FW_SIZE 150000
diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index 59a8763..6ab842d 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -21,10 +21,10 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <stdarg.h>
 #include <brcmu_utils.h>
-#include <bcmdevs.h>
+#include <brcm_hw_ids.h>
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver utilities.");
diff --git a/drivers/staging/brcm80211/brcmutil/wifi.c b/drivers/staging/brcm80211/brcmutil/wifi.c
index 2a3db0a..bacf345 100644
--- a/drivers/staging/brcm80211/brcmutil/wifi.c
+++ b/drivers/staging/brcm80211/brcmutil/wifi.c
@@ -16,7 +16,7 @@
 #include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <bcmdefs.h>
+#include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
diff --git a/drivers/staging/brcm80211/include/aidmp.h b/drivers/staging/brcm80211/include/aidmp.h
index 2c10177..d166af4 100644
--- a/drivers/staging/brcm80211/include/aidmp.h
+++ b/drivers/staging/brcm80211/include/aidmp.h
@@ -17,7 +17,7 @@
 #ifndef	_AIDMP_H
 #define	_AIDMP_H
 
-#include "bcmdefs.h"		/* for PAD macro */
+#include "defs.h"		/* for PAD macro */
 
 /* Manufacturer Ids */
 #define	MFGID_ARM		0x43b
diff --git a/drivers/staging/brcm80211/include/bcmdevs.h b/drivers/staging/brcm80211/include/brcm_hw_ids.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmdevs.h
rename to drivers/staging/brcm80211/include/brcm_hw_ids.h
diff --git a/drivers/staging/brcm80211/include/chipcommon.h b/drivers/staging/brcm80211/include/chipcommon.h
index ee1130f..296582a 100644
--- a/drivers/staging/brcm80211/include/chipcommon.h
+++ b/drivers/staging/brcm80211/include/chipcommon.h
@@ -17,7 +17,7 @@
 #ifndef	_SBCHIPC_H
 #define	_SBCHIPC_H
 
-#include "bcmdefs.h"		/* for PAD macro */
+#include "defs.h"		/* for PAD macro */
 
 typedef volatile struct {
 	u32 chipid;		/* 0x0 */
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/defs.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmdefs.h
rename to drivers/staging/brcm80211/include/defs.h
diff --git a/drivers/staging/brcm80211/include/bcmsdh.h b/drivers/staging/brcm80211/include/sdio_host.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmsdh.h
rename to drivers/staging/brcm80211/include/sdio_host.h
diff --git a/drivers/staging/brcm80211/include/bcmsoc.h b/drivers/staging/brcm80211/include/soc.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmsoc.h
rename to drivers/staging/brcm80211/include/soc.h
diff --git a/drivers/staging/brcm80211/include/bcmsrom.h b/drivers/staging/brcm80211/include/srom.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmsrom.h
rename to drivers/staging/brcm80211/include/srom.h
-- 
1.7.4.1


