Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4305 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab1GEUGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 07/21] staging: brcm80211: further cleaned fullmac
 header files
Date: Tue, 5 Jul 2011 22:06:03 +0200
Message-ID: <1309896377-4425-8-git-send-email-arend@broadcom.com> (sfid-20110705_220709_542009_340E4493)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Deleted unused definitions. Moved locally used definitions to
.c files. Moved definitions from bcmsdh_sdmmc.h to bcmsdbus.h.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |  109 +++++++++++++++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   22 +++
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   11 ++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h  |  140 --------------------
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   90 +++++++++++++-
 drivers/staging/brcm80211/brcmfmac/sbsdio.h        |   96 -------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |   24 ----
 9 files changed, 228 insertions(+), 268 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 3ba3c3f..3dff170 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -32,6 +32,60 @@
 #define SDIOH_DATA_PIO          0	/* PIO mode */
 #define SDIOH_DATA_DMA          1	/* DMA mode */
 
+/* internal return code */
+#define SUCCESS	0
+#define ERROR	1
+
+/* Common msglevel constants */
+#define SDH_ERROR_VAL		0x0001	/* Error */
+#define SDH_TRACE_VAL		0x0002	/* Trace */
+#define SDH_INFO_VAL		0x0004	/* Info */
+#define SDH_DEBUG_VAL		0x0008	/* Debug */
+#define SDH_DATA_VAL		0x0010	/* Data */
+#define SDH_CTRL_VAL		0x0020	/* Control Regs */
+#define SDH_LOG_VAL		0x0040	/* Enable bcmlog */
+#define SDH_DMA_VAL		0x0080	/* DMA */
+
+#ifdef BCMDBG
+#define sd_err(x)	\
+	do { \
+		if ((sd_msglevel & SDH_ERROR_VAL) && net_ratelimit()) \
+			printk x; \
+	} while (0)
+#define sd_trace(x)	\
+	do { \
+		if ((sd_msglevel & SDH_TRACE_VAL) && net_ratelimit()) \
+			printk x; \
+	} while (0)
+#define sd_info(x)	\
+	do { \
+		if ((sd_msglevel & SDH_INFO_VAL) && net_ratelimit()) \
+			printk x; \
+	} while (0)
+#define sd_debug(x)	\
+	do { \
+		if ((sd_msglevel & SDH_DEBUG_VAL) && net_ratelimit()) \
+			printk x; \
+	} while (0)
+#define sd_data(x)	\
+	do { \
+		if ((sd_msglevel & SDH_DATA_VAL) && net_ratelimit()) \
+			printk x; \
+	} while (0)
+#define sd_ctrl(x)	\
+	do { \
+		if ((sd_msglevel & SDH_CTRL_VAL) && net_ratelimit()) \
+			printk x; \
+	} while (0)
+#else
+#define sd_err(x)
+#define sd_trace(x)
+#define sd_info(x)
+#define sd_debug(x)
+#define sd_data(x)
+#define sd_ctrl(x)
+#endif
+
 struct brcmf_sdreg {
 	int func;
 	int offset;
@@ -41,6 +95,54 @@ struct brcmf_sdreg {
 /* callback function, taking one arg */
 typedef void (*sdioh_cb_fn_t) (void *);
 
+struct sdioh_info {
+	struct osl_info *osh;		/* osh handler */
+	bool client_intr_enabled;	/* interrupt connnected flag */
+	bool intr_handler_valid;	/* client driver interrupt handler valid */
+	sdioh_cb_fn_t intr_handler;	/* registered interrupt handler */
+	void *intr_handler_arg;	/* argument to call interrupt handler */
+	u16 intmask;		/* Current active interrupts */
+	void *sdos_info;	/* Pointer to per-OS private data */
+
+	uint irq;		/* Client irq */
+	int intrcount;		/* Client interrupts */
+	bool sd_blockmode;	/* sd_blockmode == false => 64 Byte Cmd 53s. */
+	/*  Must be on for sd_multiblock to be effective */
+	bool use_client_ints;	/* If this is false, make sure to restore */
+	int client_block_size[SDIOD_MAX_IOFUNCS];	/* Blocksize */
+	u8 num_funcs;	/* Supported funcs on client */
+	u32 com_cis_ptr;
+	u32 func_cis_ptr[SDIOD_MAX_IOFUNCS];
+	uint max_dma_len;
+	uint max_dma_descriptors;	/* DMA Descriptors supported by this controller. */
+	/*	SDDMA_DESCRIPTOR	SGList[32]; *//* Scatter/Gather DMA List */
+};
+
+struct brcmf_sdmmc_instance {
+	struct sdioh_info *sd;
+	struct sdio_func *func[SDIOD_MAX_IOFUNCS];
+	u32 host_claimed;
+};
+
+/* Allocate/init/free per-OS private data */
+extern int  brcmf_sdioh_osinit(struct sdioh_info *sd);
+extern void brcmf_sdioh_osfree(struct sdioh_info *sd);
+
+/* OS-independent interrupt handler */
+extern bool brcmf_sdioh_check_client_intr(struct sdioh_info *sd);
+
+/* Core interrupt enable/disable of device interrupts */
+extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
+extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
+
+/* Register mapping routines */
+extern u32 *brcmf_sdioh_reg_map(s32 addr, int size);
+extern void brcmf_sdioh_reg_unmap(s32 addr, int size);
+
+/* Interrupt (de)registration routines */
+extern int  brcmf_sdioh_register_irq(struct sdioh_info *sd, uint irq);
+extern void brcmf_sdioh_free_irq(uint irq, struct sdioh_info *sd);
+
 /* attach, return handler on success, NULL if failed.
  *  The handler shall be provided by all subsequent calls. No local cache
  *  cfghdl points to the starting address of pci device mapped memory
@@ -59,9 +161,6 @@ brcmf_sdioh_interrupt_query(struct sdioh_info *si, bool *onoff);
 extern int
 brcmf_sdioh_interrupt_set(struct sdioh_info *si, bool enable_disable);
 
-extern int brcmf_sdioh_claim_host_and_lock(struct sdioh_info *si);
-extern int brcmf_sdioh_release_host_and_unlock(struct sdioh_info *si);
-
 /* read or write one byte using cmd52 */
 extern int
 brcmf_sdioh_request_byte(struct sdioh_info *si, uint rw, uint fnc, uint addr,
@@ -105,4 +204,8 @@ void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card);
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(bool enable);
 
+extern uint sd_msglevel;	/* Debug message level */
+
+extern struct brcmf_sdmmc_instance *gInstance;
+
 #endif				/* _sdio_api_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 09bad40..fd36679 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -31,6 +31,28 @@
 #include "dhd.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
+
+#define BRCMF_SD_ERROR_VAL	0x0001	/* Error */
+#define BRCMF_SD_INFO_VAL		0x0002	/* Info */
+
+#ifdef BCMDBG
+#define BRCMF_SD_ERROR(x) \
+	do { \
+		if ((brcmf_sdio_msglevel & BRCMF_SD_ERROR_VAL) && \
+		    net_ratelimit()) \
+			printk x; \
+	} while (0)
+#define BRCMF_SD_INFO(x)	\
+	do { \
+		if ((brcmf_sdio_msglevel & BRCMF_SD_INFO_VAL) && \
+		    net_ratelimit()) \
+			printk x; \
+	} while (0)
+#else				/* BCMDBG */
+#define BRCMF_SD_ERROR(x)
+#define BRCMF_SD_INFO(x)
+#endif				/* BCMDBG */
+
 const uint brcmf_sdio_msglevel = BRCMF_SD_ERROR_VAL;
 
 struct brcmf_sdio_card {
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index fe875e8..56e2435 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -34,6 +34,7 @@
 #include "dngl_stats.h"
 #include "dhd.h"
 #include "dhd_bus.h"
+#include "bcmsdbus.h"
 
 /**
  * SDIO Host Controller info
@@ -208,7 +209,6 @@ void brcmf_sdio_unregister(void)
 
 /* Module parameters specific to each host-controller driver */
 
-extern uint sd_msglevel;	/* Debug message level */
 module_param(sd_msglevel, uint, 0);
 
 extern uint sd_f2_blocksize;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 7bc9d02..4f4ec47 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -30,7 +30,16 @@
 #include "bcmsdbus.h"
 #include "dngl_stats.h"
 #include "dhd.h"
-#include "bcmsdh_sdmmc.h"
+
+#define BLOCK_SIZE_64 64
+#define BLOCK_SIZE_512 512
+#define BLOCK_SIZE_4318 64
+#define BLOCK_SIZE_4328 512
+
+/* private bus modes */
+#define SDIOH_MODE_SD4		2
+
+#define CLIENT_INTR		0x100	/* Get rid of this! */
 
 static void brcmf_sdioh_irqhandler(struct sdio_func *func);
 static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
deleted file mode 100644
index 962fa4b..0000000
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ /dev/null
@@ -1,140 +0,0 @@
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
-/*
- * BRCMF SDIO Function Driver for the native SDIO/MMC driver in the Linux Kernel
- */
-
-#ifndef __BCMSDH_SDMMC_H__
-#define __BCMSDH_SDMMC_H__
-
-/* Common msglevel constants */
-#define SDH_ERROR_VAL		0x0001	/* Error */
-#define SDH_TRACE_VAL		0x0002	/* Trace */
-#define SDH_INFO_VAL		0x0004	/* Info */
-#define SDH_DEBUG_VAL		0x0008	/* Debug */
-#define SDH_DATA_VAL		0x0010	/* Data */
-#define SDH_CTRL_VAL		0x0020	/* Control Regs */
-#define SDH_LOG_VAL		0x0040	/* Enable bcmlog */
-#define SDH_DMA_VAL		0x0080	/* DMA */
-
-#ifdef BCMDBG
-#define sd_err(x)	\
-	do { \
-		if ((sd_msglevel & SDH_ERROR_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_trace(x)	\
-	do { \
-		if ((sd_msglevel & SDH_TRACE_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_info(x)	\
-	do { \
-		if ((sd_msglevel & SDH_INFO_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_debug(x)	\
-	do { \
-		if ((sd_msglevel & SDH_DEBUG_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_data(x)	\
-	do { \
-		if ((sd_msglevel & SDH_DATA_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define sd_ctrl(x)	\
-	do { \
-		if ((sd_msglevel & SDH_CTRL_VAL) && net_ratelimit()) \
-			printk x; \
-	} while (0)
-#else
-#define sd_err(x)
-#define sd_trace(x)
-#define sd_info(x)
-#define sd_debug(x)
-#define sd_data(x)
-#define sd_ctrl(x)
-#endif
-
-#define BLOCK_SIZE_64 64
-#define BLOCK_SIZE_512 512
-#define BLOCK_SIZE_4318 64
-#define BLOCK_SIZE_4328 512
-
-/* internal return code */
-#define SUCCESS	0
-#define ERROR	1
-
-/* private bus modes */
-#define SDIOH_MODE_SD4		2
-#define CLIENT_INTR		0x100	/* Get rid of this! */
-
-struct sdioh_info {
-	struct osl_info *osh;		/* osh handler */
-	bool client_intr_enabled;	/* interrupt connnected flag */
-	bool intr_handler_valid;	/* client driver interrupt handler valid */
-	sdioh_cb_fn_t intr_handler;	/* registered interrupt handler */
-	void *intr_handler_arg;	/* argument to call interrupt handler */
-	u16 intmask;		/* Current active interrupts */
-	void *sdos_info;	/* Pointer to per-OS private data */
-
-	uint irq;		/* Client irq */
-	int intrcount;		/* Client interrupts */
-	bool sd_blockmode;	/* sd_blockmode == false => 64 Byte Cmd 53s. */
-	/*  Must be on for sd_multiblock to be effective */
-	bool use_client_ints;	/* If this is false, make sure to restore */
-	int client_block_size[SDIOD_MAX_IOFUNCS];	/* Blocksize */
-	u8 num_funcs;	/* Supported funcs on client */
-	u32 com_cis_ptr;
-	u32 func_cis_ptr[SDIOD_MAX_IOFUNCS];
-	uint max_dma_len;
-	uint max_dma_descriptors;	/* DMA Descriptors supported by this controller. */
-	/*	SDDMA_DESCRIPTOR	SGList[32]; *//* Scatter/Gather DMA List */
-};
-
-/* Global message bits */
-extern uint sd_msglevel;
-
-/* Allocate/init/free per-OS private data */
-extern int  brcmf_sdioh_osinit(struct sdioh_info *sd);
-extern void brcmf_sdioh_osfree(struct sdioh_info *sd);
-
-/* OS-independent interrupt handler */
-extern bool brcmf_sdioh_check_client_intr(struct sdioh_info *sd);
-
-/* Core interrupt enable/disable of device interrupts */
-extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
-extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
-
-/* Register mapping routines */
-extern u32 *brcmf_sdioh_reg_map(s32 addr, int size);
-extern void brcmf_sdioh_reg_unmap(s32 addr, int size);
-
-/* Interrupt (de)registration routines */
-extern int  brcmf_sdioh_register_irq(struct sdioh_info *sd, uint irq);
-extern void brcmf_sdioh_free_irq(uint irq, struct sdioh_info *sd);
-
-struct brcmf_sdmmc_instance {
-	struct sdioh_info *sd;
-	struct sdio_func *func[SDIOD_MAX_IOFUNCS];
-	u32 host_claimed;
-};
-
-extern struct brcmf_sdmmc_instance *gInstance;
-
-#endif				/* __BCMSDH_SDMMC_H__ */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 369f99e..cdaa042 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -50,8 +50,6 @@
 #define SDIO_DEVICE_ID_BROADCOM_4319	0x4319
 #endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
 
-#include <bcmsdh_sdmmc.h>
-
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 6a53ac8..c9ec69b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -33,7 +33,6 @@
 #include <soc.h>
 #include "sdio_host.h"
 #include "bcmsdbus.h"
-#include "bcmsdh_sdmmc.h"
 
 /* register access macros */
 #ifndef __BIG_ENDIAN
@@ -413,6 +412,95 @@ BRCMF_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
 #define CORE_SB(base, field) \
 		(base + SBCONFIGOFF + offsetof(sbconfig_t, field))
 
+/* core registers */
+struct sdpcmd_regs {
+	u32 corecontrol;		/* 0x00, rev8 */
+	u32 corestatus;			/* rev8 */
+	u32 PAD[1];
+	u32 biststatus;			/* rev8 */
+
+	/* PCMCIA access */
+	u16 pcmciamesportaladdr;	/* 0x010, rev8 */
+	u16 PAD[1];
+	u16 pcmciamesportalmask;	/* rev8 */
+	u16 PAD[1];
+	u16 pcmciawrframebc;		/* rev8 */
+	u16 PAD[1];
+	u16 pcmciaunderflowtimer;	/* rev8 */
+	u16 PAD[1];
+
+	/* interrupt */
+	u32 intstatus;			/* 0x020, rev8 */
+	u32 hostintmask;		/* rev8 */
+	u32 intmask;			/* rev8 */
+	u32 sbintstatus;		/* rev8 */
+	u32 sbintmask;			/* rev8 */
+	u32 funcintmask;		/* rev4 */
+	u32 PAD[2];
+	u32 tosbmailbox;		/* 0x040, rev8 */
+	u32 tohostmailbox;		/* rev8 */
+	u32 tosbmailboxdata;		/* rev8 */
+	u32 tohostmailboxdata;		/* rev8 */
+
+	/* synchronized access to registers in SDIO clock domain */
+	u32 sdioaccess;			/* 0x050, rev8 */
+	u32 PAD[3];
+
+	/* PCMCIA frame control */
+	u8 pcmciaframectrl;		/* 0x060, rev8 */
+	u8 PAD[3];
+	u8 pcmciawatermark;		/* rev8 */
+	u8 PAD[155];
+
+	/* interrupt batching control */
+	u32 intrcvlazy;			/* 0x100, rev8 */
+	u32 PAD[3];
+
+	/* counters */
+	u32 cmd52rd;			/* 0x110, rev8 */
+	u32 cmd52wr;			/* rev8 */
+	u32 cmd53rd;			/* rev8 */
+	u32 cmd53wr;			/* rev8 */
+	u32 abort;			/* rev8 */
+	u32 datacrcerror;		/* rev8 */
+	u32 rdoutofsync;		/* rev8 */
+	u32 wroutofsync;		/* rev8 */
+	u32 writebusy;			/* rev8 */
+	u32 readwait;			/* rev8 */
+	u32 readterm;			/* rev8 */
+	u32 writeterm;			/* rev8 */
+	u32 PAD[40];
+	u32 clockctlstatus;		/* rev8 */
+	u32 PAD[7];
+
+	u32 PAD[128];			/* DMA engines */
+
+	/* SDIO/PCMCIA CIS region */
+	char cis[512];			/* 0x400-0x5ff, rev6 */
+
+	/* PCMCIA function control registers */
+	char pcmciafcr[256];		/* 0x600-6ff, rev6 */
+	u16 PAD[55];
+
+	/* PCMCIA backplane access */
+	u16 backplanecsr;		/* 0x76E, rev6 */
+	u16 backplaneaddr0;		/* rev6 */
+	u16 backplaneaddr1;		/* rev6 */
+	u16 backplaneaddr2;		/* rev6 */
+	u16 backplaneaddr3;		/* rev6 */
+	u16 backplanedata0;		/* rev6 */
+	u16 backplanedata1;		/* rev6 */
+	u16 backplanedata2;		/* rev6 */
+	u16 backplanedata3;		/* rev6 */
+	u16 PAD[31];
+
+	/* sprom "size" & "blank" info */
+	u16 spromstatus;		/* 0x7BE, rev2 */
+	u32 PAD[464];
+
+	u16 PAD[0x80];
+};
+
 #ifdef BCMDBG
 /* Device console log buffer state */
 struct dhd_console {
diff --git a/drivers/staging/brcm80211/brcmfmac/sbsdio.h b/drivers/staging/brcm80211/brcmfmac/sbsdio.h
index 614a25f..db9f607 100644
--- a/drivers/staging/brcm80211/brcmfmac/sbsdio.h
+++ b/drivers/staging/brcm80211/brcmfmac/sbsdio.h
@@ -274,100 +274,4 @@
 /* HW frame tag */
 #define SDPCM_FRAMETAG_LEN	4	/* 2 bytes len, 2 bytes check val */
 
-/* cpp contortions to concatenate w/arg prescan */
-#ifndef PAD
-#define	_PADLINE(line)	pad ## line
-#define	_XSTR(line)	_PADLINE(line)
-#define	PAD		_XSTR(__LINE__)
-#endif				/* PAD */
-
-/* core registers */
-struct sdpcmd_regs {
-	u32 corecontrol;		/* 0x00, rev8 */
-	u32 corestatus;			/* rev8 */
-	u32 PAD[1];
-	u32 biststatus;			/* rev8 */
-
-	/* PCMCIA access */
-	u16 pcmciamesportaladdr;	/* 0x010, rev8 */
-	u16 PAD[1];
-	u16 pcmciamesportalmask;	/* rev8 */
-	u16 PAD[1];
-	u16 pcmciawrframebc;		/* rev8 */
-	u16 PAD[1];
-	u16 pcmciaunderflowtimer;	/* rev8 */
-	u16 PAD[1];
-
-	/* interrupt */
-	u32 intstatus;			/* 0x020, rev8 */
-	u32 hostintmask;		/* rev8 */
-	u32 intmask;			/* rev8 */
-	u32 sbintstatus;		/* rev8 */
-	u32 sbintmask;			/* rev8 */
-	u32 funcintmask;		/* rev4 */
-	u32 PAD[2];
-	u32 tosbmailbox;		/* 0x040, rev8 */
-	u32 tohostmailbox;		/* rev8 */
-	u32 tosbmailboxdata;		/* rev8 */
-	u32 tohostmailboxdata;		/* rev8 */
-
-	/* synchronized access to registers in SDIO clock domain */
-	u32 sdioaccess;			/* 0x050, rev8 */
-	u32 PAD[3];
-
-	/* PCMCIA frame control */
-	u8 pcmciaframectrl;		/* 0x060, rev8 */
-	u8 PAD[3];
-	u8 pcmciawatermark;		/* rev8 */
-	u8 PAD[155];
-
-	/* interrupt batching control */
-	u32 intrcvlazy;			/* 0x100, rev8 */
-	u32 PAD[3];
-
-	/* counters */
-	u32 cmd52rd;			/* 0x110, rev8 */
-	u32 cmd52wr;			/* rev8 */
-	u32 cmd53rd;			/* rev8 */
-	u32 cmd53wr;			/* rev8 */
-	u32 abort;			/* rev8 */
-	u32 datacrcerror;		/* rev8 */
-	u32 rdoutofsync;		/* rev8 */
-	u32 wroutofsync;		/* rev8 */
-	u32 writebusy;			/* rev8 */
-	u32 readwait;			/* rev8 */
-	u32 readterm;			/* rev8 */
-	u32 writeterm;			/* rev8 */
-	u32 PAD[40];
-	u32 clockctlstatus;		/* rev8 */
-	u32 PAD[7];
-
-	u32 PAD[128];			/* DMA engines */
-
-	/* SDIO/PCMCIA CIS region */
-	char cis[512];			/* 0x400-0x5ff, rev6 */
-
-	/* PCMCIA function control registers */
-	char pcmciafcr[256];		/* 0x600-6ff, rev6 */
-	u16 PAD[55];
-
-	/* PCMCIA backplane access */
-	u16 backplanecsr;		/* 0x76E, rev6 */
-	u16 backplaneaddr0;		/* rev6 */
-	u16 backplaneaddr1;		/* rev6 */
-	u16 backplaneaddr2;		/* rev6 */
-	u16 backplaneaddr3;		/* rev6 */
-	u16 backplanedata0;		/* rev6 */
-	u16 backplanedata1;		/* rev6 */
-	u16 backplanedata2;		/* rev6 */
-	u16 backplanedata3;		/* rev6 */
-	u16 PAD[31];
-
-	/* sprom "size" & "blank" info */
-	u16 spromstatus;		/* 0x7BE, rev2 */
-	u32 PAD[464];
-
-	u16 PAD[0x80];
-};
-
 #endif				/* _SBSDIO_H */
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 712d0df..02c820b 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -18,28 +18,8 @@
 #define	_BRCM_SDH_H_
 
 #include <linux/skbuff.h>
-#define BRCMF_SD_ERROR_VAL	0x0001	/* Error */
-#define BRCMF_SD_INFO_VAL		0x0002	/* Info */
 extern const uint brcmf_sdio_msglevel;
 
-#ifdef BCMDBG
-#define BRCMF_SD_ERROR(x) \
-	do { \
-		if ((brcmf_sdio_msglevel & BRCMF_SD_ERROR_VAL) && \
-		    net_ratelimit()) \
-			printk x; \
-	} while (0)
-#define BRCMF_SD_INFO(x)	\
-	do { \
-		if ((brcmf_sdio_msglevel & BRCMF_SD_INFO_VAL) && \
-		    net_ratelimit()) \
-			printk x; \
-	} while (0)
-#else				/* BCMDBG */
-#define BRCMF_SD_ERROR(x)
-#define BRCMF_SD_INFO(x)
-#endif				/* BCMDBG */
-
 #define SDIO_FUNC_0		0
 #define SDIO_FUNC_1		1
 #define SDIO_FUNC_2		2
@@ -221,11 +201,7 @@ extern int brcmf_sdio_function_init(void);
 extern int brcmf_sdio_register(struct brcmf_sdioh_driver *driver);
 extern void brcmf_sdio_unregister(void);
 extern bool brcmf_sdio_chipmatch(u16 vendor, u16 device);
-extern void brcmf_sdio_device_remove(void *card);
 extern void brcmf_sdio_function_cleanup(void);
-
-extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
-extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
 extern int brcmf_sdio_probe(struct device *dev);
 extern int brcmf_sdio_remove(struct device *dev);
 
-- 
1.7.4.1


