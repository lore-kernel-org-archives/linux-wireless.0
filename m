Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4582 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213Ab1F2Xtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:35 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 093/119] staging: brcm80211: removed global function
 declarations from .c files
Date: Wed, 29 Jun 2011 16:47:57 -0700
Message-ID: <1309391303-22741-94-git-send-email-frankyl@broadcom.com> (sfid-20110630_015258_240051_79775C46)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Function declarations were moved to .h files.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    6 ------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    9 +++------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h  |   10 +++++-----
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    8 --------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    1 -
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |    9 +++++++++
 6 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index ce8323c..1198ee6 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -31,8 +31,6 @@
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
 
-extern void brcmf_sdbrcm_isr(void *args);
-
 #include "dngl_stats.h"
 #include "dhd.h"
 #include "dhd_bus.h"
@@ -195,8 +193,6 @@ int brcmf_sdio_remove(struct device *dev)
 	return 0;
 }
 
-extern int brcmf_sdio_function_init(void);
-
 int brcmf_sdio_register(struct brcmf_sdioh_driver *driver)
 {
 	drvinfo = *driver;
@@ -205,8 +201,6 @@ int brcmf_sdio_register(struct brcmf_sdioh_driver *driver)
 	return brcmf_sdio_function_init();
 }
 
-extern void brcmf_sdio_function_cleanup(void);
-
 void brcmf_sdio_unregister(void)
 {
 	brcmf_sdio_function_cleanup();
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 0413a59..b7726f2 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -33,13 +33,9 @@
 #include "dhd.h"
 #include "bcmsdh_sdmmc.h"
 
-extern int brcmf_sdio_function_init(void);
-extern void brcmf_sdio_function_cleanup(void);
-
 static void brcmf_sdioh_irqhandler(struct sdio_func *func);
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
 static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr);
-extern int brcmf_sdioh_reset_comm(struct mmc_card *card);
 
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
@@ -51,8 +47,9 @@ BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_buffer_wait);
 
 #define DMA_ALIGN_MASK	0x03
 
-int brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
-			     int regsize, u32 *data);
+static int
+brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
+			 int regsize, u32 *data);
 
 static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index 9c5eee0..a0f985c 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -61,10 +61,6 @@
 #define sd_ctrl(x)
 #endif
 
-/* Allocate/init/free per-OS private data */
-extern int brcmf_sdioh_osinit(struct sdioh_info *sd);
-extern void brcmf_sdioh_osfree(struct sdioh_info *sd);
-
 #define BLOCK_SIZE_64 64
 #define BLOCK_SIZE_512 512
 #define BLOCK_SIZE_4318 64
@@ -108,6 +104,10 @@ struct sdioh_info {
 /* Global message bits */
 extern uint sd_msglevel;
 
+/* Allocate/init/free per-OS private data */
+extern int  brcmf_sdioh_osinit(struct sdioh_info *sd);
+extern void brcmf_sdioh_osfree(struct sdioh_info *sd);
+
 /* OS-independent interrupt handler */
 extern bool brcmf_sdioh_check_client_intr(struct sdioh_info *sd);
 
@@ -124,7 +124,7 @@ extern u32 *brcmf_sdioh_reg_map(s32 addr, int size);
 extern void brcmf_sdioh_reg_unmap(s32 addr, int size);
 
 /* Interrupt (de)registration routines */
-extern int brcmf_sdioh_register_irq(struct sdioh_info *sd, uint irq);
+extern int  brcmf_sdioh_register_irq(struct sdioh_info *sd, uint irq);
 extern void brcmf_sdioh_free_irq(uint irq, struct sdioh_info *sd);
 
 typedef struct _BCMSDH_SDMMC_INSTANCE {
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index f10cddd..e5c3b25 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -56,12 +56,6 @@
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 
-extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
-extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
-
-int brcmf_sdio_function_init(void);
-void brcmf_sdio_function_cleanup(void);
-
 /* module param defaults */
 static int clockoverride;
 
@@ -73,8 +67,6 @@ PBCMSDH_SDMMC_INSTANCE gInstance;
 /* Maximum number of bcmsdh_sdmmc devices supported by driver */
 #define BCMSDH_SDMMC_MAX_DEVICES 1
 
-extern int brcmf_sdio_probe(struct device *dev);
-extern int brcmf_sdio_remove(struct device *dev);
 struct device sdmmc_dev;
 
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 15c2904..e28b727 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -273,7 +273,6 @@ done:
 	return ret;
 }
 
-extern int dhd_bus_interface(struct dhd_bus *bus, uint arg, void *arg2);
 int
 brcmf_proto_ioctl(struct brcmf_pub *dhd, int ifidx, struct brcmf_ioctl *ioc,
 		  void *buf, int len)
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 6938abc..85e3d6a 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -209,11 +209,20 @@ struct brcmf_sdioh_driver {
 	void (*detach) (void *ch);
 };
 
+struct sdioh_info;
+
 /* platform specific/high level functions */
+extern int brcmf_sdio_function_init(void);
 extern int brcmf_sdio_register(struct brcmf_sdioh_driver *driver);
 extern void brcmf_sdio_unregister(void);
 extern bool brcmf_sdio_chipmatch(u16 vendor, u16 device);
 extern void brcmf_sdio_device_remove(void *sdh);
+extern void brcmf_sdio_function_cleanup(void);
+
+extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
+extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
+extern int brcmf_sdio_probe(struct device *dev);
+extern int brcmf_sdio_remove(struct device *dev);
 
 /* Function to pass device-status bits to DHD. */
 extern u32 brcmf_sdcard_get_dstatus(void *sdh);
-- 
1.7.1


