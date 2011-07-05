Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2951 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1GEWDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 20/31] staging: brcm80211: deleted two fullmac source
 files
Date: Wed, 6 Jul 2011 00:02:47 +0200
Message-ID: <1309903378-29021-21-git-send-email-arend@broadcom.com> (sfid-20110706_000332_331874_F3DAE8F1)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Having both a 'generic' as a 'linux' specific variant of a file makes
no sense in a Linux environment. Merged bcmsdh_sdmmc_linux.c into
bcmsdh_sdmmc.c, and bcmsdh_linux.c into bcmsdh.c.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile        |    4 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |  150 +++++++++++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |  178 -------------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |  246 ++++++++++++++++++-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |  260 --------------------
 5 files changed, 394 insertions(+), 444 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index c38fa55..da3c805 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -33,9 +33,7 @@ DHDOFILES = \
 	dhd_sdio.o	\
 	dhd_linux.o \
 	bcmsdh.o \
-	bcmsdh_linux.o	\
-	bcmsdh_sdmmc.o \
-	bcmsdh_sdmmc_linux.o
+	bcmsdh_sdmmc.o
 
 obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
 brcmfmac-objs += $(DHDOFILES)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 97c0f9d..5fdeeaf 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -17,8 +17,10 @@
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
+#include <linux/completion.h>
 
 #include <defs.h>
 #include <brcm_hw_ids.h>
@@ -29,12 +31,15 @@
 #include "sbsdio.h"		/* BRCM sdio device core */
 #include "dngl_stats.h"
 #include "dhd.h"
+#include "dhd_bus.h"
+#include "sdio_host.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
 #define BRCMF_SD_ERROR_VAL	0x0001	/* Error */
 #define BRCMF_SD_INFO_VAL		0x0002	/* Info */
 
+
 #ifdef BCMDBG
 #define BRCMF_SD_ERROR(x) \
 	do { \
@@ -53,7 +58,8 @@
 #define BRCMF_SD_INFO(x)
 #endif				/* BCMDBG */
 
-const uint brcmf_sdio_msglevel = BRCMF_SD_ERROR_VAL;
+/* debugging macros */
+#define SDLX_MSG(x)
 
 struct brcmf_sdio_card {
 	bool init_success;	/* underlying driver successfully attached */
@@ -63,9 +69,46 @@ struct brcmf_sdio_card {
 				 reg_read/reg_write call */
 	u32 sbwad;		/* Save backplane window address */
 };
+
+/**
+ * SDIO Host Controller info
+ */
+struct sdio_hc {
+	struct sdio_hc *next;
+	struct device *dev;	/* platform device handle */
+	void *regs;		/* SDIO Host Controller address */
+	struct brcmf_sdio_card *card;
+	void *ch;
+	unsigned int oob_irq;
+	unsigned long oob_flags;	/* OOB Host specifiction
+					as edge and etc */
+	bool oob_irq_registered;
+};
+
 /* local copy of bcm sd handler */
 static struct brcmf_sdio_card *l_card;
 
+const uint brcmf_sdio_msglevel = BRCMF_SD_ERROR_VAL;
+
+static struct sdio_hc *sdhcinfo;
+
+/* driver info, initialized when brcmf_sdio_register is called */
+static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
+
+/* Module parameters specific to each host-controller driver */
+
+module_param(sd_msglevel, uint, 0);
+
+extern uint sd_f2_blocksize;
+module_param(sd_f2_blocksize, int, 0);
+
+/* forward declarations */
+int brcmf_sdio_probe(struct device *dev);
+EXPORT_SYMBOL(brcmf_sdio_probe);
+
+int brcmf_sdio_remove(struct device *dev);
+EXPORT_SYMBOL(brcmf_sdio_remove);
+
 struct brcmf_sdio_card*
 brcmf_sdcard_attach(void *cfghdl, u32 *regsva, uint irq)
 {
@@ -500,3 +543,108 @@ u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
 
 	return card->sbwad;
 }
+
+int brcmf_sdio_probe(struct device *dev)
+{
+	struct sdio_hc *sdhc = NULL;
+	u32 regs = 0;
+	struct brcmf_sdio_card *card = NULL;
+	int irq = 0;
+	u32 vendevid;
+	unsigned long irq_flags = 0;
+
+	/* allocate SDIO Host Controller state info */
+	sdhc = kzalloc(sizeof(struct sdio_hc), GFP_ATOMIC);
+	if (!sdhc) {
+		SDLX_MSG(("%s: out of memory\n", __func__));
+		goto err;
+	}
+	sdhc->dev = (void *)dev;
+
+	card = brcmf_sdcard_attach((void *)0, &regs, irq);
+	if (!card) {
+		SDLX_MSG(("%s: attach failed\n", __func__));
+		goto err;
+	}
+
+	sdhc->card = card;
+	sdhc->oob_irq = irq;
+	sdhc->oob_flags = irq_flags;
+	sdhc->oob_irq_registered = false;	/* to make sure.. */
+
+	/* chain SDIO Host Controller info together */
+	sdhc->next = sdhcinfo;
+	sdhcinfo = sdhc;
+	/* Read the vendor/device ID from the CIS */
+	vendevid = brcmf_sdcard_query_device(card);
+
+	/* try to attach to the target device */
+	sdhc->ch = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
+				  0, 0, 0, 0, regs, card);
+	if (!sdhc->ch) {
+		SDLX_MSG(("%s: device attach failed\n", __func__));
+		goto err;
+	}
+
+	return 0;
+
+	/* error handling */
+err:
+	if (sdhc) {
+		if (sdhc->card)
+			brcmf_sdcard_detach(sdhc->card);
+		kfree(sdhc);
+	}
+
+	return -ENODEV;
+}
+
+int brcmf_sdio_remove(struct device *dev)
+{
+	struct sdio_hc *sdhc, *prev;
+
+	sdhc = sdhcinfo;
+	drvinfo.detach(sdhc->ch);
+	brcmf_sdcard_detach(sdhc->card);
+	/* find the SDIO Host Controller state for this pdev
+		 and take it out from the list */
+	for (sdhc = sdhcinfo, prev = NULL; sdhc; sdhc = sdhc->next) {
+		if (sdhc->dev == (void *)dev) {
+			if (prev)
+				prev->next = sdhc->next;
+			else
+				sdhcinfo = NULL;
+			break;
+		}
+		prev = sdhc;
+	}
+	if (!sdhc) {
+		SDLX_MSG(("%s: failed\n", __func__));
+		return 0;
+	}
+
+	/* release SDIO Host Controller info */
+	kfree(sdhc);
+	return 0;
+}
+
+int brcmf_sdio_register(struct brcmf_sdioh_driver *driver)
+{
+	drvinfo = *driver;
+
+	SDLX_MSG(("Linux Kernel SDIO/MMC Driver\n"));
+	return brcmf_sdio_function_init();
+}
+
+void brcmf_sdio_unregister(void)
+{
+	brcmf_sdio_function_cleanup();
+}
+
+void brcmf_sdio_wdtmr_enable(bool enable)
+{
+	if (enable)
+		brcmf_sdbrcm_wd_timer(sdhcinfo->ch, brcmf_watchdog_ms);
+	else
+		brcmf_sdbrcm_wd_timer(sdhcinfo->ch, 0);
+}
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
deleted file mode 100644
index ec7d79d..0000000
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ /dev/null
@@ -1,178 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-/**
- * @file bcmsdh_linux.c
- */
-
-#define __UNDEF_NO_VERSION__
-
-#include <linux/netdevice.h>
-#include <linux/pci.h>
-#include <linux/completion.h>
-#include <linux/sched.h>
-
-#include <defs.h>
-#include <brcm_hw_ids.h>
-#include <brcmu_utils.h>
-#include <brcmu_wifi.h>
-#include "sdio_host.h"
-
-#include "dngl_stats.h"
-#include "dhd.h"
-#include "dhd_bus.h"
-#include "bcmsdbus.h"
-
-/**
- * SDIO Host Controller info
- */
-struct sdio_hc {
-	struct sdio_hc *next;
-	struct device *dev;	/* platform device handle */
-	void *regs;		/* SDIO Host Controller address */
-	struct brcmf_sdio_card *card;
-	void *ch;
-	unsigned int oob_irq;
-	unsigned long oob_flags;	/* OOB Host specifiction
-					as edge and etc */
-	bool oob_irq_registered;
-};
-static struct sdio_hc *sdhcinfo;
-
-/* driver info, initialized when brcmf_sdio_register is called */
-static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
-
-/* debugging macros */
-#define SDLX_MSG(x)
-
-/* forward declarations */
-int brcmf_sdio_probe(struct device *dev);
-EXPORT_SYMBOL(brcmf_sdio_probe);
-
-int brcmf_sdio_remove(struct device *dev);
-EXPORT_SYMBOL(brcmf_sdio_remove);
-
-int brcmf_sdio_probe(struct device *dev)
-{
-	struct sdio_hc *sdhc = NULL;
-	u32 regs = 0;
-	struct brcmf_sdio_card *card = NULL;
-	int irq = 0;
-	u32 vendevid;
-	unsigned long irq_flags = 0;
-
-	/* allocate SDIO Host Controller state info */
-	sdhc = kzalloc(sizeof(struct sdio_hc), GFP_ATOMIC);
-	if (!sdhc) {
-		SDLX_MSG(("%s: out of memory\n", __func__));
-		goto err;
-	}
-	sdhc->dev = (void *)dev;
-
-	card = brcmf_sdcard_attach((void *)0, &regs, irq);
-	if (!card) {
-		SDLX_MSG(("%s: attach failed\n", __func__));
-		goto err;
-	}
-
-	sdhc->card = card;
-	sdhc->oob_irq = irq;
-	sdhc->oob_flags = irq_flags;
-	sdhc->oob_irq_registered = false;	/* to make sure.. */
-
-	/* chain SDIO Host Controller info together */
-	sdhc->next = sdhcinfo;
-	sdhcinfo = sdhc;
-	/* Read the vendor/device ID from the CIS */
-	vendevid = brcmf_sdcard_query_device(card);
-
-	/* try to attach to the target device */
-	sdhc->ch = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
-				  0, 0, 0, 0, regs, card);
-	if (!sdhc->ch) {
-		SDLX_MSG(("%s: device attach failed\n", __func__));
-		goto err;
-	}
-
-	return 0;
-
-	/* error handling */
-err:
-	if (sdhc) {
-		if (sdhc->card)
-			brcmf_sdcard_detach(sdhc->card);
-		kfree(sdhc);
-	}
-
-	return -ENODEV;
-}
-
-int brcmf_sdio_remove(struct device *dev)
-{
-	struct sdio_hc *sdhc, *prev;
-
-	sdhc = sdhcinfo;
-	drvinfo.detach(sdhc->ch);
-	brcmf_sdcard_detach(sdhc->card);
-	/* find the SDIO Host Controller state for this pdev
-		 and take it out from the list */
-	for (sdhc = sdhcinfo, prev = NULL; sdhc; sdhc = sdhc->next) {
-		if (sdhc->dev == (void *)dev) {
-			if (prev)
-				prev->next = sdhc->next;
-			else
-				sdhcinfo = NULL;
-			break;
-		}
-		prev = sdhc;
-	}
-	if (!sdhc) {
-		SDLX_MSG(("%s: failed\n", __func__));
-		return 0;
-	}
-
-	/* release SDIO Host Controller info */
-	kfree(sdhc);
-	return 0;
-}
-
-int brcmf_sdio_register(struct brcmf_sdioh_driver *driver)
-{
-	drvinfo = *driver;
-
-	SDLX_MSG(("Linux Kernel SDIO/MMC Driver\n"));
-	return brcmf_sdio_function_init();
-}
-
-void brcmf_sdio_unregister(void)
-{
-	brcmf_sdio_function_cleanup();
-}
-
-/* Module parameters specific to each host-controller driver */
-
-module_param(sd_msglevel, uint, 0);
-
-extern uint sd_f2_blocksize;
-module_param(sd_f2_blocksize, int, 0);
-
-void brcmf_sdio_wdtmr_enable(bool enable)
-{
-	if (enable)
-		brcmf_sdbrcm_wd_timer(sdhcinfo->ch, brcmf_watchdog_ms);
-	else
-		brcmf_sdbrcm_wd_timer(sdhcinfo->ch, 0);
-}
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 76a2c8b..d4a380c 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -19,8 +19,11 @@
 #include <linux/mmc/core.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
+#include <linux/mmc/card.h>
 #include <linux/suspend.h>
 #include <linux/errno.h>
+#include <linux/sched.h>	/* request_irq() */
+#include <net/cfg80211.h>
 
 #include <defs.h>
 #include <brcm_hw_ids.h>
@@ -30,6 +33,8 @@
 #include "bcmsdbus.h"
 #include "dngl_stats.h"
 #include "dhd.h"
+#include "dhd_dbg.h"
+#include "wl_cfg80211.h"
 
 #define BLOCK_SIZE_64 64
 #define BLOCK_SIZE_512 512
@@ -41,20 +46,95 @@
 
 #define CLIENT_INTR		0x100	/* Get rid of this! */
 
+#if !defined(SDIO_VENDOR_ID_BROADCOM)
+#define SDIO_VENDOR_ID_BROADCOM		0x02d0
+#endif				/* !defined(SDIO_VENDOR_ID_BROADCOM) */
+
+#define SDIO_DEVICE_ID_BROADCOM_DEFAULT	0x0000
+
+#define DMA_ALIGN_MASK	0x03
+
+#if !defined(SDIO_DEVICE_ID_BROADCOM_4325_SDGWB)
+#define SDIO_DEVICE_ID_BROADCOM_4325_SDGWB	0x0492	/* BCM94325SDGWB */
+#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4325_SDGWB) */
+#if !defined(SDIO_DEVICE_ID_BROADCOM_4325)
+#define SDIO_DEVICE_ID_BROADCOM_4325	0x0493
+#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4325) */
+#if !defined(SDIO_DEVICE_ID_BROADCOM_4329)
+#define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
+#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
+#if !defined(SDIO_DEVICE_ID_BROADCOM_4319)
+#define SDIO_DEVICE_ID_BROADCOM_4319	0x4319
+#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
+
+struct sdos_info {
+	struct sdioh_info *sd;
+	spinlock_t lock;
+};
+
 static void brcmf_sdioh_irqhandler(struct sdio_func *func);
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
 static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr);
+static int brcmf_ops_sdio_probe(struct sdio_func *func,
+				const struct sdio_device_id *id);
+static void brcmf_ops_sdio_remove(struct sdio_func *func);
+
+#ifdef CONFIG_PM
+static int brcmf_sdio_suspend(struct device *dev);
+static int brcmf_sdio_resume(struct device *dev);
+#endif /* CONFIG_PM */
 
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
 uint sd_msglevel = 0x01;
+
+/* module param defaults */
+static int clockoverride;
+
+module_param(clockoverride, int, 0644);
+MODULE_PARM_DESC(clockoverride, "SDIO card clock override");
+
+struct brcmf_sdmmc_instance *gInstance;
+
+struct device sdmmc_dev;
+
+/* devices we support, null terminated */
+static const struct sdio_device_id brcmf_sdmmc_ids[] = {
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_DEFAULT)},
+	{SDIO_DEVICE
+	 (SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4325_SDGWB)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4325)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4319)},
+	{ /* end: all zeroes */ },
+};
+
+#ifdef CONFIG_PM
+static const struct dev_pm_ops brcmf_sdio_pm_ops = {
+	.suspend	= brcmf_sdio_suspend,
+	.resume		= brcmf_sdio_resume,
+};
+#endif	/* CONFIG_PM */
+
+static struct sdio_driver brcmf_sdmmc_driver = {
+	.probe = brcmf_ops_sdio_probe,
+	.remove = brcmf_ops_sdio_remove,
+	.name = "brcmfmac",
+	.id_table = brcmf_sdmmc_ids,
+#ifdef CONFIG_PM
+	.drv = {
+		.pm = &brcmf_sdio_pm_ops,
+	},
+#endif	/* CONFIG_PM */
+};
+
+MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
+
 BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_byte_wait);
 BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_word_wait);
 BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_packet_wait);
 BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_buffer_wait);
 
-#define DMA_ALIGN_MASK	0x03
-
 static int
 brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
 			 int regsize, u32 *data);
@@ -904,3 +984,165 @@ static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 
 	sd = gInstance->sd;
 }
+
+static int brcmf_ops_sdio_probe(struct sdio_func *func,
+			      const struct sdio_device_id *id)
+{
+	int ret = 0;
+	static struct sdio_func sdio_func_0;
+	sd_trace(("sdio_probe: %s Enter\n", __func__));
+	sd_trace(("sdio_probe: func->class=%x\n", func->class));
+	sd_trace(("sdio_vendor: 0x%04x\n", func->vendor));
+	sd_trace(("sdio_device: 0x%04x\n", func->device));
+	sd_trace(("Function#: 0x%04x\n", func->num));
+
+	if (func->num == 1) {
+		sdio_func_0.num = 0;
+		sdio_func_0.card = func->card;
+		gInstance->func[0] = &sdio_func_0;
+		if (func->device == 0x4) {	/* 4318 */
+			gInstance->func[2] = NULL;
+			sd_trace(("NIC found, calling brcmf_sdio_probe...\n"));
+			ret = brcmf_sdio_probe(&sdmmc_dev);
+		}
+	}
+
+	gInstance->func[func->num] = func;
+
+	if (func->num == 2) {
+		brcmf_cfg80211_sdio_func(func);
+		sd_trace(("F2 found, calling brcmf_sdio_probe...\n"));
+		ret = brcmf_sdio_probe(&sdmmc_dev);
+	}
+
+	return ret;
+}
+
+static void brcmf_ops_sdio_remove(struct sdio_func *func)
+{
+	sd_trace(("%s Enter\n", __func__));
+	sd_info(("func->class=%x\n", func->class));
+	sd_info(("sdio_vendor: 0x%04x\n", func->vendor));
+	sd_info(("sdio_device: 0x%04x\n", func->device));
+	sd_info(("Function#: 0x%04x\n", func->num));
+
+	if (func->num == 2) {
+		sd_trace(("F2 found, calling brcmf_sdio_remove...\n"));
+		brcmf_sdio_remove(&sdmmc_dev);
+	}
+}
+
+
+#ifdef CONFIG_PM
+static int brcmf_sdio_suspend(struct device *dev)
+{
+	mmc_pm_flag_t sdio_flags;
+	int ret = 0;
+
+	sd_trace(("%s\n", __func__));
+
+	sdio_flags = sdio_get_host_pm_caps(gInstance->func[1]);
+	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
+		sd_err(("Host can't keep power while suspended\n"));
+		return -EINVAL;
+	}
+
+	ret = sdio_set_host_pm_flags(gInstance->func[1], MMC_PM_KEEP_POWER);
+	if (ret) {
+		sd_err(("Failed to set pm_flags\n"));
+		return ret;
+	}
+
+	brcmf_sdio_wdtmr_enable(false);
+
+	return ret;
+}
+
+static int brcmf_sdio_resume(struct device *dev)
+{
+	brcmf_sdio_wdtmr_enable(true);
+	return 0;
+}
+#endif		/* CONFIG_PM */
+
+int brcmf_sdioh_osinit(struct sdioh_info *sd)
+{
+	struct sdos_info *sdos;
+
+	sdos = kmalloc(sizeof(struct sdos_info), GFP_ATOMIC);
+	sd->sdos_info = (void *)sdos;
+	if (sdos == NULL)
+		return -ENOMEM;
+
+	sdos->sd = sd;
+	spin_lock_init(&sdos->lock);
+	return 0;
+}
+
+void brcmf_sdioh_osfree(struct sdioh_info *sd)
+{
+	struct sdos_info *sdos;
+
+	sdos = (struct sdos_info *)sd->sdos_info;
+	kfree(sdos);
+}
+
+/* Interrupt enable/disable */
+int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
+{
+	unsigned long flags;
+	struct sdos_info *sdos;
+
+	sd_trace(("%s: %s\n", __func__, enable ? "Enabling" : "Disabling"));
+
+	sdos = (struct sdos_info *)sd->sdos_info;
+
+	if (enable && !(sd->intr_handler && sd->intr_handler_arg)) {
+		sd_err(("%s: no handler registered, will not enable\n",
+			__func__));
+		return -EINVAL;
+	}
+
+	/* Ensure atomicity for enable/disable calls */
+	spin_lock_irqsave(&sdos->lock, flags);
+
+	sd->client_intr_enabled = enable;
+	if (enable)
+		brcmf_sdioh_dev_intr_on(sd);
+	else
+		brcmf_sdioh_dev_intr_off(sd);
+
+	spin_unlock_irqrestore(&sdos->lock, flags);
+
+	return 0;
+}
+
+/*
+ * module init
+*/
+int brcmf_sdio_function_init(void)
+{
+	int error = 0;
+	sd_trace(("brcmf_sdio_function_init: %s Enter\n", __func__));
+
+	gInstance = kzalloc(sizeof(struct brcmf_sdmmc_instance), GFP_KERNEL);
+	if (!gInstance)
+		return -ENOMEM;
+
+	memset(&sdmmc_dev, 0, sizeof(sdmmc_dev));
+	error = sdio_register_driver(&brcmf_sdmmc_driver);
+
+	return error;
+}
+
+/*
+ * module cleanup
+*/
+void brcmf_sdio_function_cleanup(void)
+{
+	sd_trace(("%s Enter\n", __func__));
+
+	sdio_unregister_driver(&brcmf_sdmmc_driver);
+
+	kfree(gInstance);
+}
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
deleted file mode 100644
index 7d4b2e3..0000000
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ /dev/null
@@ -1,260 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-#include <linux/types.h>
-#include <linux/sched.h>	/* request_irq() */
-#include <linux/netdevice.h>
-#include <linux/mmc/core.h>
-#include <linux/mmc/card.h>
-#include <linux/mmc/sdio_func.h>
-#include <linux/mmc/sdio_ids.h>
-#include <linux/errno.h>
-#include <net/cfg80211.h>
-
-#include <defs.h>
-#include <brcmu_utils.h>
-#include <brcmu_wifi.h>
-#include "sdio_host.h"
-#include "bcmsdbus.h"
-#include "dngl_stats.h"
-#include "dhd.h"
-
-#if !defined(SDIO_VENDOR_ID_BROADCOM)
-#define SDIO_VENDOR_ID_BROADCOM		0x02d0
-#endif				/* !defined(SDIO_VENDOR_ID_BROADCOM) */
-
-#define SDIO_DEVICE_ID_BROADCOM_DEFAULT	0x0000
-
-#if !defined(SDIO_DEVICE_ID_BROADCOM_4325_SDGWB)
-#define SDIO_DEVICE_ID_BROADCOM_4325_SDGWB	0x0492	/* BCM94325SDGWB */
-#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4325_SDGWB) */
-#if !defined(SDIO_DEVICE_ID_BROADCOM_4325)
-#define SDIO_DEVICE_ID_BROADCOM_4325	0x0493
-#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4325) */
-#if !defined(SDIO_DEVICE_ID_BROADCOM_4329)
-#define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
-#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
-#if !defined(SDIO_DEVICE_ID_BROADCOM_4319)
-#define SDIO_DEVICE_ID_BROADCOM_4319	0x4319
-#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
-
-#include "dhd_dbg.h"
-#include "wl_cfg80211.h"
-
-/* module param defaults */
-static int clockoverride;
-
-module_param(clockoverride, int, 0644);
-MODULE_PARM_DESC(clockoverride, "SDIO card clock override");
-
-struct brcmf_sdmmc_instance *gInstance;
-
-struct device sdmmc_dev;
-
-static int brcmf_ops_sdio_probe(struct sdio_func *func,
-			      const struct sdio_device_id *id)
-{
-	int ret = 0;
-	static struct sdio_func sdio_func_0;
-	sd_trace(("sdio_probe: %s Enter\n", __func__));
-	sd_trace(("sdio_probe: func->class=%x\n", func->class));
-	sd_trace(("sdio_vendor: 0x%04x\n", func->vendor));
-	sd_trace(("sdio_device: 0x%04x\n", func->device));
-	sd_trace(("Function#: 0x%04x\n", func->num));
-
-	if (func->num == 1) {
-		sdio_func_0.num = 0;
-		sdio_func_0.card = func->card;
-		gInstance->func[0] = &sdio_func_0;
-		if (func->device == 0x4) {	/* 4318 */
-			gInstance->func[2] = NULL;
-			sd_trace(("NIC found, calling brcmf_sdio_probe...\n"));
-			ret = brcmf_sdio_probe(&sdmmc_dev);
-		}
-	}
-
-	gInstance->func[func->num] = func;
-
-	if (func->num == 2) {
-		brcmf_cfg80211_sdio_func(func);
-		sd_trace(("F2 found, calling brcmf_sdio_probe...\n"));
-		ret = brcmf_sdio_probe(&sdmmc_dev);
-	}
-
-	return ret;
-}
-
-static void brcmf_ops_sdio_remove(struct sdio_func *func)
-{
-	sd_trace(("%s Enter\n", __func__));
-	sd_info(("func->class=%x\n", func->class));
-	sd_info(("sdio_vendor: 0x%04x\n", func->vendor));
-	sd_info(("sdio_device: 0x%04x\n", func->device));
-	sd_info(("Function#: 0x%04x\n", func->num));
-
-	if (func->num == 2) {
-		sd_trace(("F2 found, calling brcmf_sdio_remove...\n"));
-		brcmf_sdio_remove(&sdmmc_dev);
-	}
-}
-
-/* devices we support, null terminated */
-static const struct sdio_device_id brcmf_sdmmc_ids[] = {
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_DEFAULT)},
-	{SDIO_DEVICE
-	 (SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4325_SDGWB)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4325)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4319)},
-	{ /* end: all zeroes */ },
-};
-
-MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
-
-#ifdef CONFIG_PM
-static int brcmf_sdio_suspend(struct device *dev)
-{
-	mmc_pm_flag_t sdio_flags;
-	int ret = 0;
-
-	sd_trace(("%s\n", __func__));
-
-	sdio_flags = sdio_get_host_pm_caps(gInstance->func[1]);
-	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
-		sd_err(("Host can't keep power while suspended\n"));
-		return -EINVAL;
-	}
-
-	ret = sdio_set_host_pm_flags(gInstance->func[1], MMC_PM_KEEP_POWER);
-	if (ret) {
-		sd_err(("Failed to set pm_flags\n"));
-		return ret;
-	}
-
-	brcmf_sdio_wdtmr_enable(false);
-
-	return ret;
-}
-
-static int brcmf_sdio_resume(struct device *dev)
-{
-	brcmf_sdio_wdtmr_enable(true);
-	return 0;
-}
-
-static const struct dev_pm_ops brcmf_sdio_pm_ops = {
-	.suspend	= brcmf_sdio_suspend,
-	.resume		= brcmf_sdio_resume,
-};
-#endif		/* CONFIG_PM */
-
-static struct sdio_driver brcmf_sdmmc_driver = {
-	.probe = brcmf_ops_sdio_probe,
-	.remove = brcmf_ops_sdio_remove,
-	.name = "brcmfmac",
-	.id_table = brcmf_sdmmc_ids,
-#ifdef CONFIG_PM
-	.drv = {
-		.pm = &brcmf_sdio_pm_ops,
-	},
-#endif		/* CONFIG_PM */
-};
-
-struct sdos_info {
-	struct sdioh_info *sd;
-	spinlock_t lock;
-};
-
-int brcmf_sdioh_osinit(struct sdioh_info *sd)
-{
-	struct sdos_info *sdos;
-
-	sdos = kmalloc(sizeof(struct sdos_info), GFP_ATOMIC);
-	sd->sdos_info = (void *)sdos;
-	if (sdos == NULL)
-		return -ENOMEM;
-
-	sdos->sd = sd;
-	spin_lock_init(&sdos->lock);
-	return 0;
-}
-
-void brcmf_sdioh_osfree(struct sdioh_info *sd)
-{
-	struct sdos_info *sdos;
-
-	sdos = (struct sdos_info *)sd->sdos_info;
-	kfree(sdos);
-}
-
-/* Interrupt enable/disable */
-int brcmf_sdioh_interrupt_set(struct sdioh_info *sd, bool enable)
-{
-	unsigned long flags;
-	struct sdos_info *sdos;
-
-	sd_trace(("%s: %s\n", __func__, enable ? "Enabling" : "Disabling"));
-
-	sdos = (struct sdos_info *)sd->sdos_info;
-
-	if (enable && !(sd->intr_handler && sd->intr_handler_arg)) {
-		sd_err(("%s: no handler registered, will not enable\n",
-			__func__));
-		return -EINVAL;
-	}
-
-	/* Ensure atomicity for enable/disable calls */
-	spin_lock_irqsave(&sdos->lock, flags);
-
-	sd->client_intr_enabled = enable;
-	if (enable)
-		brcmf_sdioh_dev_intr_on(sd);
-	else
-		brcmf_sdioh_dev_intr_off(sd);
-
-	spin_unlock_irqrestore(&sdos->lock, flags);
-
-	return 0;
-}
-
-/*
- * module init
-*/
-int brcmf_sdio_function_init(void)
-{
-	int error = 0;
-	sd_trace(("brcmf_sdio_function_init: %s Enter\n", __func__));
-
-	gInstance = kzalloc(sizeof(struct brcmf_sdmmc_instance), GFP_KERNEL);
-	if (!gInstance)
-		return -ENOMEM;
-
-	memset(&sdmmc_dev, 0, sizeof(sdmmc_dev));
-	error = sdio_register_driver(&brcmf_sdmmc_driver);
-
-	return error;
-}
-
-/*
- * module cleanup
-*/
-void brcmf_sdio_function_cleanup(void)
-{
-	sd_trace(("%s Enter\n", __func__));
-
-	sdio_unregister_driver(&brcmf_sdmmc_driver);
-
-	kfree(gInstance);
-}
-- 
1.7.4.1


