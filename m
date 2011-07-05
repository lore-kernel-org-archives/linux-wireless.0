Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1437 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 23/31] staging: brcm80211: merged bcmsdbus.h into
 sdio_host.h
Date: Wed, 6 Jul 2011 00:02:50 +0200
Message-ID: <1309903378-29021-24-git-send-email-arend@broadcom.com> (sfid-20110706_000351_678357_EC96391D)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>


Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h     |  190 ---------------------
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   51 ++++++-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    1 -
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |  117 +++++++++++++
 5 files changed, 167 insertions(+), 193 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
deleted file mode 100644
index c4c6e54..0000000
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ /dev/null
@@ -1,190 +0,0 @@
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
-#ifndef	_sdio_api_h_
-#define	_sdio_api_h_
-
-#include "sdio_host.h"
-
-#define SDIOH_READ              0	/* Read request */
-#define SDIOH_WRITE             1	/* Write request */
-
-#define SDIOH_DATA_FIX          0	/* Fixed addressing */
-#define SDIOH_DATA_INC          1	/* Incremental addressing */
-
-#define SDIOH_CMD_TYPE_NORMAL   0	/* Normal command */
-#define SDIOH_CMD_TYPE_APPEND   1	/* Append command */
-#define SDIOH_CMD_TYPE_CUTTHRU  2	/* Cut-through command */
-
-#define SDIOH_DATA_PIO          0	/* PIO mode */
-#define SDIOH_DATA_DMA          1	/* DMA mode */
-
-/* internal return code */
-#define SUCCESS	0
-#define ERROR	1
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
-struct brcmf_sdreg {
-	int func;
-	int offset;
-	int value;
-};
-
-struct sdioh_info {
-	struct osl_info *osh;		/* osh handler */
-	bool client_intr_enabled;	/* interrupt connnected flag */
-	bool intr_handler_valid;	/* client driver interrupt handler valid */
-	void (*intr_handler)(void *);	/* registered interrupt handler */
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
-struct brcmf_sdmmc_instance {
-	struct sdioh_info *sd;
-	struct sdio_func *func[SDIOD_MAX_IOFUNCS];
-	u32 host_claimed;
-};
-
-/* Allocate/init/free per-OS private data */
-extern int  brcmf_sdioh_osinit(struct sdioh_info *sd);
-extern void brcmf_sdioh_osfree(struct sdioh_info *sd);
-
-/* Core interrupt enable/disable of device interrupts */
-extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
-extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
-
-/* attach, return handler on success, NULL if failed.
- *  The handler shall be provided by all subsequent calls. No local cache
- *  cfghdl points to the starting address of pci device mapped memory
- */
-extern struct sdioh_info *brcmf_sdioh_attach(void *cfghdl, uint irq);
-extern int brcmf_sdioh_detach(struct sdioh_info *si);
-
-extern int
-brcmf_sdioh_interrupt_register(struct sdioh_info *si,
-			       void (*sdioh_cb_fn)(void *), void *argh);
-
-extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
-
-/* enable or disable SD interrupt */
-extern int
-brcmf_sdioh_interrupt_set(struct sdioh_info *si, bool enable_disable);
-
-/* read or write one byte using cmd52 */
-extern int
-brcmf_sdioh_request_byte(struct sdioh_info *si, uint rw, uint fnc, uint addr,
-			 u8 *byte);
-
-/* read or write 2/4 bytes using cmd53 */
-extern int
-brcmf_sdioh_request_word(struct sdioh_info *si, uint cmd_type,
-			 uint rw, uint fnc, uint addr,
-			 u32 *word, uint nbyte);
-
-/* read or write any buffer using cmd53 */
-extern int
-brcmf_sdioh_request_buffer(struct sdioh_info *si, uint pio_dma,
-			   uint fix_inc, uint rw, uint fnc_num,
-			   u32 addr, uint regwidth,
-			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
-
-/* get cis data */
-extern int
-brcmf_sdioh_cis_read(struct sdioh_info *si, uint fuc, u8 *cis, u32 length);
-
-extern int
-brcmf_sdioh_cfg_read(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
-extern int
-brcmf_sdioh_cfg_write(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
-
-/* handle iovars */
-extern int brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
-			  void *params, int plen, void *arg, int len, bool set);
-
-/* Issue abort to the specified function and clear controller as needed */
-extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
-
-/* Watchdog timer interface for pm ops */
-extern void brcmf_sdio_wdtmr_enable(bool enable);
-
-extern uint sd_msglevel;	/* Debug message level */
-
-extern struct brcmf_sdmmc_instance *gInstance;
-
-#endif				/* _sdio_api_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 6714af7..a527f29 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -27,7 +27,6 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include <soc.h>
-#include "bcmsdbus.h"		/* common SDIO/controller interface */
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "sdio_host.h"
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 40c93c4..6567363 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -30,7 +30,6 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
-#include "bcmsdbus.h"
 #include "dhd.h"
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
@@ -66,6 +65,56 @@
 #define SDIO_DEVICE_ID_BROADCOM_4319	0x4319
 #endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
 
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
 struct sdos_info {
 	struct sdioh_info *sd;
 	spinlock_t lock;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index f89b960..b34914e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -32,7 +32,6 @@
 #include <brcm_hw_ids.h>
 #include <soc.h>
 #include "sdio_host.h"
-#include "bcmsdbus.h"
 
 /* register access macros */
 #ifndef __BIG_ENDIAN
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 73ee785..a956339 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -298,9 +298,60 @@ extern const uint brcmf_sdio_msglevel;
 /* HW frame tag */
 #define SDPCM_FRAMETAG_LEN	4	/* 2 bytes len, 2 bytes check val */
 
+#define SDIOH_READ              0	/* Read request */
+#define SDIOH_WRITE             1	/* Write request */
+
+#define SDIOH_DATA_FIX          0	/* Fixed addressing */
+#define SDIOH_DATA_INC          1	/* Incremental addressing */
+
+#define SDIOH_CMD_TYPE_NORMAL   0	/* Normal command */
+#define SDIOH_CMD_TYPE_APPEND   1	/* Append command */
+#define SDIOH_CMD_TYPE_CUTTHRU  2	/* Cut-through command */
+
+#define SDIOH_DATA_PIO          0	/* PIO mode */
+#define SDIOH_DATA_DMA          1	/* DMA mode */
+
+/* internal return code */
+#define SUCCESS	0
+#define ERROR	1
+
 /* forward declarations */
 struct brcmf_sdio_card;
 
+struct brcmf_sdreg {
+	int func;
+	int offset;
+	int value;
+};
+
+struct sdioh_info {
+	struct osl_info *osh;		/* osh handler */
+	bool client_intr_enabled;	/* interrupt connnected flag */
+	bool intr_handler_valid;	/* client driver interrupt handler valid */
+	void (*intr_handler)(void *);	/* registered interrupt handler */
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
 
 /* Attach and build an interface to the underlying SD host driver.
  *  - Allocates resources (structs, arrays, mem, OS handles, etc) needed by
@@ -450,4 +501,70 @@ extern int brcmf_sdio_remove(struct device *dev);
 /* Function to return current window addr */
 extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card);
 
+/* Allocate/init/free per-OS private data */
+extern int  brcmf_sdioh_osinit(struct sdioh_info *sd);
+extern void brcmf_sdioh_osfree(struct sdioh_info *sd);
+
+/* Core interrupt enable/disable of device interrupts */
+extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
+extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
+
+/* attach, return handler on success, NULL if failed.
+ *  The handler shall be provided by all subsequent calls. No local cache
+ *  cfghdl points to the starting address of pci device mapped memory
+ */
+extern struct sdioh_info *brcmf_sdioh_attach(void *cfghdl, uint irq);
+extern int brcmf_sdioh_detach(struct sdioh_info *si);
+
+extern int
+brcmf_sdioh_interrupt_register(struct sdioh_info *si,
+			       void (*sdioh_cb_fn)(void *), void *argh);
+
+extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
+
+/* enable or disable SD interrupt */
+extern int
+brcmf_sdioh_interrupt_set(struct sdioh_info *si, bool enable_disable);
+
+/* read or write one byte using cmd52 */
+extern int
+brcmf_sdioh_request_byte(struct sdioh_info *si, uint rw, uint fnc, uint addr,
+			 u8 *byte);
+
+/* read or write 2/4 bytes using cmd53 */
+extern int
+brcmf_sdioh_request_word(struct sdioh_info *si, uint cmd_type,
+			 uint rw, uint fnc, uint addr,
+			 u32 *word, uint nbyte);
+
+/* read or write any buffer using cmd53 */
+extern int
+brcmf_sdioh_request_buffer(struct sdioh_info *si, uint pio_dma,
+			   uint fix_inc, uint rw, uint fnc_num,
+			   u32 addr, uint regwidth,
+			   u32 buflen, u8 *buffer, struct sk_buff *pkt);
+
+/* get cis data */
+extern int
+brcmf_sdioh_cis_read(struct sdioh_info *si, uint fuc, u8 *cis, u32 length);
+
+extern int
+brcmf_sdioh_cfg_read(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
+extern int
+brcmf_sdioh_cfg_write(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
+
+/* handle iovars */
+extern int brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
+			  void *params, int plen, void *arg, int len, bool set);
+
+/* Issue abort to the specified function and clear controller as needed */
+extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
+
+/* Watchdog timer interface for pm ops */
+extern void brcmf_sdio_wdtmr_enable(bool enable);
+
+extern uint sd_msglevel;	/* Debug message level */
+
+extern struct brcmf_sdmmc_instance *gInstance;
+
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.4.1


