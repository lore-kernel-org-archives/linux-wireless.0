Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2303 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758817Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 55/83] staging: brmc80211: remove sdio.h from fullmac
Date: Wed, 1 Jun 2011 13:45:40 +0200
Message-ID: <1306928768-7501-55-git-send-email-rvossen@broadcom.com> (sfid-20110601_134935_599566_73BB39B6)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use standard sdio.h from mmc core instead of private one

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   16 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   95 +---
 drivers/staging/brcm80211/brcmfmac/sdio.h          |  552 --------------------
 drivers/staging/brcm80211/include/bcmsdh.h         |   21 +
 6 files changed, 37 insertions(+), 649 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/sdio.h

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index b8af4ed..14c07e6 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -30,7 +30,6 @@
 #include <bcmsdbus.h>		/* common SDIO/controller interface */
 #include <sbsdio.h>		/* BRCM sdio device core */
 
-#include <sdio.h>		/* sdio spec */
 #include "dngl_stats.h"
 #include "dhd.h"
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 067404b..6b2a450 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -15,11 +15,11 @@
  */
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <linux/mmc/sdio.h>
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
-#include <sdio.h>		/* SDIO Device and Protocol Specs */
 #include <sdioh.h>		/* SDIO Host Controller Specification */
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* ioctl/iovars */
@@ -75,16 +75,16 @@ static int sdioh_sdmmc_card_enablefuncs(sdioh_info_t *sd)
 	sd_trace(("%s\n", __func__));
 
 	/* Get the Card's common CIS address */
-	sd->com_cis_ptr = sdioh_sdmmc_get_cisaddr(sd, SDIOD_CCCR_CISPTR_0);
+	sd->com_cis_ptr = sdioh_sdmmc_get_cisaddr(sd, SDIO_CCCR_CIS);
 	sd->func_cis_ptr[0] = sd->com_cis_ptr;
 	sd_info(("%s: Card's Common CIS Ptr = 0x%x\n", __func__,
 		 sd->com_cis_ptr));
 
 	/* Get the Card's function CIS (for each function) */
-	for (fbraddr = SDIOD_FBR_STARTADDR, func = 1;
+	for (fbraddr = SDIO_FBR_BASE(1), func = 1;
 	     func <= sd->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
 		sd->func_cis_ptr[func] =
-		    sdioh_sdmmc_get_cisaddr(sd, SDIOD_FBR_CISPTR_0 + fbraddr);
+		    sdioh_sdmmc_get_cisaddr(sd, SDIO_FBR_CIS + fbraddr);
 		sd_info(("%s: Function %d CIS Ptr = 0x%x\n", __func__, func,
 			 sd->func_cis_ptr[func]));
 	}
@@ -642,7 +642,7 @@ sdioh_request_byte(sdioh_info_t *sd, uint rw, uint func, uint regaddr,
 			 * Handle F2 enable
 			 * as a special case.
 			 */
-			if (regaddr == SDIOD_CCCR_IOEN) {
+			if (regaddr == SDIO_CCCR_IOEx) {
 				if (gInstance->func[2]) {
 					sdio_claim_host(gInstance->func[2]);
 					if (*byte & SDIO_FUNC_ENABLE_2) {
@@ -667,7 +667,7 @@ sdioh_request_byte(sdioh_info_t *sd, uint rw, uint func, uint regaddr,
 			}
 #if defined(MMC_SDIO_ABORT)
 			/* to allow abort command through F1 */
-			else if (regaddr == SDIOD_CCCR_IOABORT) {
+			else if (regaddr == SDIO_CCCR_ABORT) {
 				sdio_claim_host(gInstance->func[func]);
 				/*
 				 * this sdio_f0_writeb() can be replaced
@@ -955,8 +955,8 @@ extern int sdioh_abort(sdioh_info_t *sd, uint func)
 	sd_trace(("%s: Enter\n", __func__));
 
 #if defined(MMC_SDIO_ABORT)
-	/* issue abort cmd52 command through F1 */
-	sdioh_request_byte(sd, SD_IO_OP_WRITE, SDIO_FUNC_0, SDIOD_CCCR_IOABORT,
+	/* issue abort cmd52 command through F0 */
+	sdioh_request_byte(sd, SDIOH_WRITE, SDIO_FUNC_0, SDIO_CCCR_ABORT,
 			   &t_func);
 #endif				/* defined(MMC_SDIO_ABORT) */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 196b15e..f495d4b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -19,7 +19,6 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
-#include <sdio.h>		/* SDIO Specs */
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* to get msglevel bit values */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 6653655..4a14688 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -19,6 +19,7 @@
 #include <linux/pci_ids.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
+#include <linux/mmc/sdio.h>
 #include <asm/unaligned.h>
 #include <bcmdefs.h>
 #include <bcmsdh.h>
@@ -127,7 +128,6 @@ typedef struct {
 #endif				/* DHD_DEBUG */
 #include <chipcommon.h>
 
-#include <sdio.h>
 #include <sbsdio.h>
 
 #include <dngl_stats.h>
@@ -3015,7 +3015,7 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	/* Turn off the bus (F2), free any pending packets */
 	DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
 	bcmsdh_intr_disable(bus->sdh);
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIOD_CCCR_IOEN,
+	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			 SDIO_FUNC_ENABLE_1, NULL);
 
 	/* Clear any pending interrupts now that F2 is disabled */
@@ -3090,7 +3090,7 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 		&bus->regs->tosbmailboxdata, retries);
 	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
 
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIOD_CCCR_IOEN, enable, NULL);
+	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable, NULL);
 
 	/* Give the dongle some time to do its thing and set IOR2 */
 	dhd_timeout_start(&tmo, DHD_WAIT_F2RDY * 1000);
@@ -3098,7 +3098,7 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 	ready = 0;
 	while (ready != enable && !dhd_timeout_expired(&tmo))
 		ready =
-		    bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_0, SDIOD_CCCR_IORDY,
+		    bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IORx,
 				    NULL);
 
 	DHD_INFO(("%s: enable 0x%02x, ready 0x%02x (waited %uus)\n",
@@ -3135,7 +3135,7 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 	else {
 		/* Disable F2 again */
 		enable = SDIO_FUNC_ENABLE_1;
-		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIOD_CCCR_IOEN, enable,
+		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable,
 				 NULL);
 	}
 
@@ -5017,7 +5017,7 @@ extern bool dhd_bus_watchdog(dhd_pub_t *dhdp)
 			if (!bus->dpc_sched) {
 				u8 devpend;
 				devpend = bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_0,
-							  SDIOD_CCCR_INTPEND,
+							  SDIO_CCCR_INTx,
 							  NULL);
 				intstatus =
 				    devpend & (INTR_STATUS_FUNC1 |
@@ -5149,35 +5149,6 @@ done:
 }
 #endif				/* DHD_DEBUG */
 
-#ifdef DHD_DEBUG
-static void dhd_dump_cis(uint fn, u8 *cis)
-{
-	uint byte, tag, tdata;
-	DHD_INFO(("Function %d CIS:\n", fn));
-
-	for (tdata = byte = 0; byte < SBSDIO_CIS_SIZE_LIMIT; byte++) {
-		if ((byte % 16) == 0)
-			DHD_INFO(("    "));
-		DHD_INFO(("%02x ", cis[byte]));
-		if ((byte % 16) == 15)
-			DHD_INFO(("\n"));
-		if (!tdata--) {
-			tag = cis[byte];
-			if (tag == 0xff)
-				break;
-			else if (!tag)
-				tdata = 0;
-			else if ((byte + 1) < SBSDIO_CIS_SIZE_LIMIT)
-				tdata = cis[byte + 1] + 1;
-			else
-				DHD_INFO(("]"));
-		}
-	}
-	if ((byte % 16) != 15)
-		DHD_INFO(("\n"));
-}
-#endif				/* DHD_DEBUG */
-
 static bool dhdsdio_chipmatch(u16 chipid)
 {
 	if (chipid == BCM4325_CHIP_ID)
@@ -5375,56 +5346,6 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 			err, DHD_INIT_CLKCTL1, clkctl));
 		goto fail;
 	}
-#ifdef DHD_DEBUG
-	if (DHD_INFO_ON()) {
-		uint fn, numfn;
-		u8 *cis[SDIOD_MAX_IOFUNCS];
-		int err = 0;
-
-		numfn = bcmsdh_query_iofnum(sdh);
-		ASSERT(numfn <= SDIOD_MAX_IOFUNCS);
-
-		/* Make sure ALP is available before trying to read CIS */
-		SPINWAIT(((clkctl = bcmsdh_cfg_read(sdh, SDIO_FUNC_1,
-						    SBSDIO_FUNC1_CHIPCLKCSR,
-						    NULL)),
-			  !SBSDIO_ALPAV(clkctl)), PMU_MAX_TRANSITION_DLY);
-
-		/* Now request ALP be put on the bus */
-		bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
-				 DHD_INIT_CLKCTL2, &err);
-		udelay(65);
-
-		for (fn = 0; fn <= numfn; fn++) {
-			cis[fn] = kzalloc(SBSDIO_CIS_SIZE_LIMIT, GFP_ATOMIC);
-			if (!cis[fn]) {
-				DHD_INFO(("dhdsdio_probe: fn %d cis malloc "
-					"failed\n", fn));
-				break;
-			}
-
-			err = bcmsdh_cis_read(sdh, fn, cis[fn],
-						SBSDIO_CIS_SIZE_LIMIT);
-			if (err) {
-				DHD_INFO(("dhdsdio_probe: fn %d cis read "
-					"err %d\n", fn, err));
-				kfree(cis[fn]);
-				break;
-			}
-			dhd_dump_cis(fn, cis[fn]);
-		}
-
-		while (fn-- > 0) {
-			ASSERT(cis[fn]);
-			kfree(cis[fn]);
-		}
-
-		if (err) {
-			DHD_ERROR(("dhdsdio_probe: error read/parsing CIS\n"));
-			goto fail;
-		}
-	}
-#endif				/* DHD_DEBUG */
 
 	if (dhdsdio_chip_attach(bus, regsva)) {
 		DHD_ERROR(("%s: dhdsdio_chip_attach failed!\n", __func__));
@@ -5533,7 +5454,7 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 #endif				/* SDTEST */
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	bcmsdh_cfg_write(sdh, SDIO_FUNC_0, SDIOD_CCCR_IOEN, SDIO_FUNC_ENABLE_1,
+	bcmsdh_cfg_write(sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx, SDIO_FUNC_ENABLE_1,
 			 NULL);
 
 	bus->dhd->busstate = DHD_BUS_DOWN;
@@ -6261,7 +6182,7 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 		CORE_CC_REG(ci->cccorebase, gpiopulldown), 4, 0);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIOD_CCCR_IOEN,
+	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 		SDIO_FUNC_ENABLE_1, NULL);
 
 	/* WAR: cmd52 backplane read so core HW will drop ALPReq */
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio.h b/drivers/staging/brcm80211/brcmfmac/sdio.h
deleted file mode 100644
index 670e379..0000000
--- a/drivers/staging/brcm80211/brcmfmac/sdio.h
+++ /dev/null
@@ -1,552 +0,0 @@
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
-#ifndef	_SDIO_H
-#define	_SDIO_H
-
-#ifdef BCMSDIO
-
-/* CCCR structure for function 0 */
-typedef volatile struct {
-	u8 cccr_sdio_rev;	/* RO, cccr and sdio revision */
-	u8 sd_rev;		/* RO, sd spec revision */
-	u8 io_en;		/* I/O enable */
-	u8 io_rdy;		/* I/O ready reg */
-	u8 intr_ctl;		/* Master and per function interrupt enable control */
-	u8 intr_status;	/* RO, interrupt pending status */
-	u8 io_abort;		/* read/write abort or reset all functions */
-	u8 bus_inter;	/* bus interface control */
-	u8 capability;	/* RO, card capability */
-
-	u8 cis_base_low;	/* 0x9 RO, common CIS base address, LSB */
-	u8 cis_base_mid;
-	u8 cis_base_high;	/* 0xB RO, common CIS base address, MSB */
-
-	/* suspend/resume registers */
-	u8 bus_suspend;	/* 0xC */
-	u8 func_select;	/* 0xD */
-	u8 exec_flag;	/* 0xE */
-	u8 ready_flag;	/* 0xF */
-
-	u8 fn0_blk_size[2];	/* 0x10(LSB), 0x11(MSB) */
-
-	u8 power_control;	/* 0x12 (SDIO version 1.10) */
-
-	u8 speed_control;	/* 0x13 */
-} sdio_regs_t;
-
-/* SDIO Device CCCR offsets */
-#define SDIOD_CCCR_REV			0x00
-#define SDIOD_CCCR_SDREV		0x01
-#define SDIOD_CCCR_IOEN			0x02
-#define SDIOD_CCCR_IORDY		0x03
-#define SDIOD_CCCR_INTEN		0x04
-#define SDIOD_CCCR_INTPEND		0x05
-#define SDIOD_CCCR_IOABORT		0x06
-#define SDIOD_CCCR_BICTRL		0x07
-#define SDIOD_CCCR_CAPABLITIES		0x08
-#define SDIOD_CCCR_CISPTR_0		0x09
-#define SDIOD_CCCR_CISPTR_1		0x0A
-#define SDIOD_CCCR_CISPTR_2		0x0B
-#define SDIOD_CCCR_BUSSUSP		0x0C
-#define SDIOD_CCCR_FUNCSEL		0x0D
-#define SDIOD_CCCR_EXECFLAGS		0x0E
-#define SDIOD_CCCR_RDYFLAGS		0x0F
-#define SDIOD_CCCR_BLKSIZE_0		0x10
-#define SDIOD_CCCR_BLKSIZE_1		0x11
-#define SDIOD_CCCR_POWER_CONTROL	0x12
-#define SDIOD_CCCR_SPEED_CONTROL	0x13
-
-/* Broadcom extensions (corerev >= 1) */
-#define SDIOD_CCCR_BRCM_SEPINT		0xf2
-
-/* cccr_sdio_rev */
-#define SDIO_REV_SDIOID_MASK	0xf0	/* SDIO spec revision number */
-#define SDIO_REV_CCCRID_MASK	0x0f	/* CCCR format version number */
-
-/* sd_rev */
-#define SD_REV_PHY_MASK		0x0f	/* SD format version number */
-
-/* io_en */
-#define SDIO_FUNC_ENABLE_1	0x02	/* function 1 I/O enable */
-#define SDIO_FUNC_ENABLE_2	0x04	/* function 2 I/O enable */
-
-/* io_rdys */
-#define SDIO_FUNC_READY_1	0x02	/* function 1 I/O ready */
-#define SDIO_FUNC_READY_2	0x04	/* function 2 I/O ready */
-
-/* intr_ctl */
-#define INTR_CTL_MASTER_EN	0x1	/* interrupt enable master */
-#define INTR_CTL_FUNC1_EN	0x2	/* interrupt enable for function 1 */
-#define INTR_CTL_FUNC2_EN	0x4	/* interrupt enable for function 2 */
-
-/* intr_status */
-#define INTR_STATUS_FUNC1	0x2	/* interrupt pending for function 1 */
-#define INTR_STATUS_FUNC2	0x4	/* interrupt pending for function 2 */
-
-/* io_abort */
-#define IO_ABORT_RESET_ALL	0x08	/* I/O card reset */
-#define IO_ABORT_FUNC_MASK	0x07	/* abort selction: function x */
-
-/* bus_inter */
-#define BUS_CARD_DETECT_DIS	0x80	/* Card Detect disable */
-#define BUS_SPI_CONT_INTR_CAP	0x40	/* support continuous SPI interrupt */
-#define BUS_SPI_CONT_INTR_EN	0x20	/* continuous SPI interrupt enable */
-#define BUS_SD_DATA_WIDTH_MASK	0x03	/* bus width mask */
-#define BUS_SD_DATA_WIDTH_4BIT	0x02	/* bus width 4-bit mode */
-#define BUS_SD_DATA_WIDTH_1BIT	0x00	/* bus width 1-bit mode */
-
-/* capability */
-#define SDIO_CAP_4BLS		0x80	/* 4-bit support for low speed card */
-#define SDIO_CAP_LSC		0x40	/* low speed card */
-#define SDIO_CAP_E4MI		0x20	/* enable interrupt between block of data in 4-bit mode */
-#define SDIO_CAP_S4MI		0x10	/* support interrupt between block of data in 4-bit mode */
-#define SDIO_CAP_SBS		0x08	/* support suspend/resume */
-#define SDIO_CAP_SRW		0x04	/* support read wait */
-#define SDIO_CAP_SMB		0x02	/* support multi-block transfer */
-#define SDIO_CAP_SDC		0x01	/* Support Direct commands during multi-byte transfer */
-
-/* power_control */
-#define SDIO_POWER_SMPC		0x01	/* supports master power control (RO) */
-#define SDIO_POWER_EMPC		0x02	/* enable master power control (allow > 200mA) (RW) */
-
-/* speed_control (control device entry into high-speed clocking mode) */
-#define SDIO_SPEED_SHS		0x01	/* supports high-speed [clocking] mode (RO) */
-#define SDIO_SPEED_EHS		0x02	/* enable high-speed [clocking] mode (RW) */
-
-/* brcm sepint */
-#define SDIO_SEPINT_MASK	0x01	/* route sdpcmdev intr onto separate pad (chip-specific) */
-#define SDIO_SEPINT_OE		0x02	/* 1 asserts output enable for above pad */
-#define SDIO_SEPINT_ACT_HI	0x04	/* use active high interrupt level instead of active low */
-
-/* FBR structure for function 1-7, FBR addresses and register offsets */
-typedef volatile struct {
-	u8 devctr;		/* device interface, CSA control */
-	u8 ext_dev;		/* extended standard I/O device type code */
-	u8 pwr_sel;		/* power selection support */
-	u8 PAD[6];		/* reserved */
-
-	u8 cis_low;		/* CIS LSB */
-	u8 cis_mid;
-	u8 cis_high;		/* CIS MSB */
-	u8 csa_low;		/* code storage area, LSB */
-	u8 csa_mid;
-	u8 csa_high;		/* code storage area, MSB */
-	u8 csa_dat_win;	/* data access window to function */
-
-	u8 fnx_blk_size[2];	/* block size, little endian */
-} sdio_fbr_t;
-
-/* Maximum number of I/O funcs */
-#define SDIOD_MAX_IOFUNCS		7
-
-/* SDIO Device FBR Start Address  */
-#define SDIOD_FBR_STARTADDR		0x100
-
-/* SDIO Device FBR Size */
-#define SDIOD_FBR_SIZE			0x100
-
-/* Macro to calculate FBR register base */
-#define SDIOD_FBR_BASE(n)		((n) * 0x100)
-
-/* Function register offsets */
-#define SDIOD_FBR_DEVCTR		0x00	/* basic info for function */
-#define SDIOD_FBR_EXT_DEV		0x01	/* extended I/O device code */
-#define SDIOD_FBR_PWR_SEL		0x02	/* power selection bits */
-
-/* SDIO Function CIS ptr offset */
-#define SDIOD_FBR_CISPTR_0		0x09
-#define SDIOD_FBR_CISPTR_1		0x0A
-#define SDIOD_FBR_CISPTR_2		0x0B
-
-/* Code Storage Area pointer */
-#define SDIOD_FBR_CSA_ADDR_0		0x0C
-#define SDIOD_FBR_CSA_ADDR_1		0x0D
-#define SDIOD_FBR_CSA_ADDR_2		0x0E
-#define SDIOD_FBR_CSA_DATA		0x0F
-
-/* SDIO Function I/O Block Size */
-#define SDIOD_FBR_BLKSIZE_0		0x10
-#define SDIOD_FBR_BLKSIZE_1		0x11
-
-/* devctr */
-#define SDIOD_FBR_DEVCTR_DIC	0x0f	/* device interface code */
-#define SDIOD_FBR_DECVTR_CSA	0x40	/* CSA support flag */
-#define SDIOD_FBR_DEVCTR_CSA_EN	0x80	/* CSA enabled */
-/* interface codes */
-#define SDIOD_DIC_NONE		0	/* SDIO standard interface is not supported */
-#define SDIOD_DIC_UART		1
-#define SDIOD_DIC_BLUETOOTH_A	2
-#define SDIOD_DIC_BLUETOOTH_B	3
-#define SDIOD_DIC_GPS		4
-#define SDIOD_DIC_CAMERA	5
-#define SDIOD_DIC_PHS		6
-#define SDIOD_DIC_WLAN		7
-#define SDIOD_DIC_EXT		0xf	/* extended device interface, read ext_dev register */
-
-/* pwr_sel */
-#define SDIOD_PWR_SEL_SPS	0x01	/* supports power selection */
-#define SDIOD_PWR_SEL_EPS	0x02	/* enable power selection (low-current mode) */
-
-/* misc defines */
-#define SDIO_FUNC_0		0
-#define SDIO_FUNC_1		1
-#define SDIO_FUNC_2		2
-#define SDIO_FUNC_3		3
-#define SDIO_FUNC_4		4
-#define SDIO_FUNC_5		5
-#define SDIO_FUNC_6		6
-#define SDIO_FUNC_7		7
-
-#define SD_CARD_TYPE_UNKNOWN	0	/* bad type or unrecognized */
-#define SD_CARD_TYPE_IO		1	/* IO only card */
-#define SD_CARD_TYPE_MEMORY	2	/* memory only card */
-#define SD_CARD_TYPE_COMBO	3	/* IO and memory combo card */
-
-#define SDIO_MAX_BLOCK_SIZE	2048	/* maximum block size for block mode operation */
-#define SDIO_MIN_BLOCK_SIZE	1	/* minimum block size for block mode operation */
-
-/* Card registers: status bit position */
-#define CARDREG_STATUS_BIT_OUTOFRANGE		31
-#define CARDREG_STATUS_BIT_COMCRCERROR		23
-#define CARDREG_STATUS_BIT_ILLEGALCOMMAND	22
-#define CARDREG_STATUS_BIT_ERROR		19
-#define CARDREG_STATUS_BIT_IOCURRENTSTATE3	12
-#define CARDREG_STATUS_BIT_IOCURRENTSTATE2	11
-#define CARDREG_STATUS_BIT_IOCURRENTSTATE1	10
-#define CARDREG_STATUS_BIT_IOCURRENTSTATE0	9
-#define CARDREG_STATUS_BIT_FUN_NUM_ERROR	4
-
-#define SD_CMD_GO_IDLE_STATE		0	/* mandatory for SDIO */
-#define SD_CMD_SEND_OPCOND		1
-#define SD_CMD_MMC_SET_RCA		3
-#define SD_CMD_IO_SEND_OP_COND		5	/* mandatory for SDIO */
-#define SD_CMD_SELECT_DESELECT_CARD	7
-#define SD_CMD_SEND_CSD			9
-#define SD_CMD_SEND_CID			10
-#define SD_CMD_STOP_TRANSMISSION	12
-#define SD_CMD_SEND_STATUS		13
-#define SD_CMD_GO_INACTIVE_STATE	15
-#define SD_CMD_SET_BLOCKLEN		16
-#define SD_CMD_READ_SINGLE_BLOCK	17
-#define SD_CMD_READ_MULTIPLE_BLOCK	18
-#define SD_CMD_WRITE_BLOCK		24
-#define SD_CMD_WRITE_MULTIPLE_BLOCK	25
-#define SD_CMD_PROGRAM_CSD		27
-#define SD_CMD_SET_WRITE_PROT		28
-#define SD_CMD_CLR_WRITE_PROT		29
-#define SD_CMD_SEND_WRITE_PROT		30
-#define SD_CMD_ERASE_WR_BLK_START	32
-#define SD_CMD_ERASE_WR_BLK_END		33
-#define SD_CMD_ERASE			38
-#define SD_CMD_LOCK_UNLOCK		42
-#define SD_CMD_IO_RW_DIRECT		52	/* mandatory for SDIO */
-#define SD_CMD_IO_RW_EXTENDED		53	/* mandatory for SDIO */
-#define SD_CMD_APP_CMD			55
-#define SD_CMD_GEN_CMD			56
-#define SD_CMD_READ_OCR			58
-#define SD_CMD_CRC_ON_OFF		59	/* mandatory for SDIO */
-#define SD_ACMD_SD_STATUS		13
-#define SD_ACMD_SEND_NUM_WR_BLOCKS	22
-#define SD_ACMD_SET_WR_BLOCK_ERASE_CNT	23
-#define SD_ACMD_SD_SEND_OP_COND		41
-#define SD_ACMD_SET_CLR_CARD_DETECT	42
-#define SD_ACMD_SEND_SCR		51
-
-/* argument for SD_CMD_IO_RW_DIRECT and SD_CMD_IO_RW_EXTENDED */
-#define SD_IO_OP_READ		0	/* Read_Write: Read */
-#define SD_IO_OP_WRITE		1	/* Read_Write: Write */
-#define SD_IO_RW_NORMAL		0	/* no RAW */
-#define SD_IO_RW_RAW		1	/* RAW */
-#define SD_IO_BYTE_MODE		0	/* Byte Mode */
-#define SD_IO_BLOCK_MODE	1	/* BlockMode */
-#define SD_IO_FIXED_ADDRESS	0	/* fix Address */
-#define SD_IO_INCREMENT_ADDRESS	1	/* IncrementAddress */
-
-/* build SD_CMD_IO_RW_DIRECT Argument */
-#define SDIO_IO_RW_DIRECT_ARG(rw, raw, func, addr, data) \
-	((((rw) & 1) << 31) | (((func) & 0x7) << 28) | (((raw) & 1) << 27) | \
-	 (((addr) & 0x1FFFF) << 9) | ((data) & 0xFF))
-
-/* build SD_CMD_IO_RW_EXTENDED Argument */
-#define SDIO_IO_RW_EXTENDED_ARG(rw, blk, func, addr, inc_addr, count) \
-	((((rw) & 1) << 31) | (((func) & 0x7) << 28) | (((blk) & 1) << 27) | \
-	 (((inc_addr) & 1) << 26) | (((addr) & 0x1FFFF) << 9) | ((count) & 0x1FF))
-
-/* SDIO response parameters */
-#define SD_RSP_NO_NONE			0
-#define SD_RSP_NO_1			1
-#define SD_RSP_NO_2			2
-#define SD_RSP_NO_3			3
-#define SD_RSP_NO_4			4
-#define SD_RSP_NO_5			5
-#define SD_RSP_NO_6			6
-
-	/* Modified R6 response (to CMD3) */
-#define SD_RSP_MR6_COM_CRC_ERROR	0x8000
-#define SD_RSP_MR6_ILLEGAL_COMMAND	0x4000
-#define SD_RSP_MR6_ERROR		0x2000
-
-	/* Modified R1 in R4 Response (to CMD5) */
-#define SD_RSP_MR1_SBIT			0x80
-#define SD_RSP_MR1_PARAMETER_ERROR	0x40
-#define SD_RSP_MR1_RFU5			0x20
-#define SD_RSP_MR1_FUNC_NUM_ERROR	0x10
-#define SD_RSP_MR1_COM_CRC_ERROR	0x08
-#define SD_RSP_MR1_ILLEGAL_COMMAND	0x04
-#define SD_RSP_MR1_RFU1			0x02
-#define SD_RSP_MR1_IDLE_STATE		0x01
-
-	/* R5 response (to CMD52 and CMD53) */
-#define SD_RSP_R5_COM_CRC_ERROR		0x80
-#define SD_RSP_R5_ILLEGAL_COMMAND	0x40
-#define SD_RSP_R5_IO_CURRENTSTATE1	0x20
-#define SD_RSP_R5_IO_CURRENTSTATE0	0x10
-#define SD_RSP_R5_ERROR			0x08
-#define SD_RSP_R5_RFU			0x04
-#define SD_RSP_R5_FUNC_NUM_ERROR	0x02
-#define SD_RSP_R5_OUT_OF_RANGE		0x01
-
-#define SD_RSP_R5_ERRBITS		0xCB
-
-/* ------------------------------------------------
- *  SDIO Commands and responses
- *
- *  I/O only commands are:
- *      CMD0, CMD3, CMD5, CMD7, CMD15, CMD52, CMD53
- * ------------------------------------------------
- */
-
-/* SDIO Commands */
-#define SDIOH_CMD_0		0
-#define SDIOH_CMD_3		3
-#define SDIOH_CMD_5		5
-#define SDIOH_CMD_7		7
-#define SDIOH_CMD_15		15
-#define SDIOH_CMD_52		52
-#define SDIOH_CMD_53		53
-#define SDIOH_CMD_59		59
-
-/* SDIO Command Responses */
-#define SDIOH_RSP_NONE		0
-#define SDIOH_RSP_R1		1
-#define SDIOH_RSP_R2		2
-#define SDIOH_RSP_R3		3
-#define SDIOH_RSP_R4		4
-#define SDIOH_RSP_R5		5
-#define SDIOH_RSP_R6		6
-
-/*
- *  SDIO Response Error flags
- */
-#define SDIOH_RSP5_ERROR_FLAGS	0xCB
-
-/* ------------------------------------------------
- * SDIO Command structures. I/O only commands are:
- *
- * 	CMD0, CMD3, CMD5, CMD7, CMD15, CMD52, CMD53
- * ------------------------------------------------
- */
-
-#define CMD5_OCR_M		BITFIELD_MASK(24)
-#define CMD5_OCR_S		0
-
-#define CMD7_RCA_M		BITFIELD_MASK(16)
-#define CMD7_RCA_S		16
-
-#define CMD_15_RCA_M		BITFIELD_MASK(16)
-#define CMD_15_RCA_S		16
-
-#define CMD52_DATA_M		BITFIELD_MASK(8)	/* Bits [7:0]    - Write Data/Stuff bits of CMD52
-							 */
-#define CMD52_DATA_S		0
-#define CMD52_REG_ADDR_M	BITFIELD_MASK(17)	/* Bits [25:9]   - register address */
-#define CMD52_REG_ADDR_S	9
-#define CMD52_RAW_M		BITFIELD_MASK(1)	/* Bit  27       - Read after Write flag */
-#define CMD52_RAW_S		27
-#define CMD52_FUNCTION_M	BITFIELD_MASK(3)	/* Bits [30:28]  - Function number */
-#define CMD52_FUNCTION_S	28
-#define CMD52_RW_FLAG_M		BITFIELD_MASK(1)	/* Bit  31       - R/W flag */
-#define CMD52_RW_FLAG_S		31
-
-#define CMD53_BYTE_BLK_CNT_M	BITFIELD_MASK(9)	/* Bits [8:0]     - Byte/Block Count of CMD53 */
-#define CMD53_BYTE_BLK_CNT_S	0
-#define CMD53_REG_ADDR_M	BITFIELD_MASK(17)	/* Bits [25:9]   - register address */
-#define CMD53_REG_ADDR_S	9
-#define CMD53_OP_CODE_M		BITFIELD_MASK(1)	/* Bit  26       - R/W Operation Code */
-#define CMD53_OP_CODE_S		26
-#define CMD53_BLK_MODE_M	BITFIELD_MASK(1)	/* Bit  27       - Block Mode */
-#define CMD53_BLK_MODE_S	27
-#define CMD53_FUNCTION_M	BITFIELD_MASK(3)	/* Bits [30:28]  - Function number */
-#define CMD53_FUNCTION_S	28
-#define CMD53_RW_FLAG_M		BITFIELD_MASK(1)	/* Bit  31       - R/W flag */
-#define CMD53_RW_FLAG_S		31
-
-/* ------------------------------------------------------
- * SDIO Command Response structures for SD1 and SD4 modes
- *  -----------------------------------------------------
- */
-#define RSP4_IO_OCR_M		BITFIELD_MASK(24)	/* Bits [23:0]  - Card's OCR Bits [23:0] */
-#define RSP4_IO_OCR_S		0
-#define RSP4_STUFF_M		BITFIELD_MASK(3)	/* Bits [26:24] - Stuff bits */
-#define RSP4_STUFF_S		24
-#define RSP4_MEM_PRESENT_M	BITFIELD_MASK(1)	/* Bit  27      - Memory present */
-#define RSP4_MEM_PRESENT_S	27
-#define RSP4_NUM_FUNCS_M	BITFIELD_MASK(3)	/* Bits [30:28] - Number of I/O funcs */
-#define RSP4_NUM_FUNCS_S	28
-#define RSP4_CARD_READY_M	BITFIELD_MASK(1)	/* Bit  31      - SDIO card ready */
-#define RSP4_CARD_READY_S	31
-
-#define RSP6_STATUS_M		BITFIELD_MASK(16)	/* Bits [15:0]  - Card status bits [19,22,23,12:0]
-							 */
-#define RSP6_STATUS_S		0
-#define RSP6_IO_RCA_M		BITFIELD_MASK(16)	/* Bits [31:16] - RCA bits[31-16] */
-#define RSP6_IO_RCA_S		16
-
-#define RSP1_AKE_SEQ_ERROR_M	BITFIELD_MASK(1)	/* Bit 3       - Authentication seq error */
-#define RSP1_AKE_SEQ_ERROR_S	3
-#define RSP1_APP_CMD_M		BITFIELD_MASK(1)	/* Bit 5       - Card expects ACMD */
-#define RSP1_APP_CMD_S		5
-#define RSP1_READY_FOR_DATA_M	BITFIELD_MASK(1)	/* Bit 8       - Ready for data (buff empty) */
-#define RSP1_READY_FOR_DATA_S	8
-#define RSP1_CURR_STATE_M	BITFIELD_MASK(4)	/* Bits [12:9] - State of card
-							 * when Cmd was received
-							 */
-#define RSP1_CURR_STATE_S	9
-#define RSP1_EARSE_RESET_M	BITFIELD_MASK(1)	/* Bit 13   - Erase seq cleared */
-#define RSP1_EARSE_RESET_S	13
-#define RSP1_CARD_ECC_DISABLE_M	BITFIELD_MASK(1)	/* Bit 14   - Card ECC disabled */
-#define RSP1_CARD_ECC_DISABLE_S	14
-#define RSP1_WP_ERASE_SKIP_M	BITFIELD_MASK(1)	/* Bit 15   - Partial blocks erased due to W/P */
-#define RSP1_WP_ERASE_SKIP_S	15
-#define RSP1_CID_CSD_OVERW_M	BITFIELD_MASK(1)	/* Bit 16   - Illegal write to CID or R/O bits
-							 * of CSD
-							 */
-#define RSP1_CID_CSD_OVERW_S	16
-#define RSP1_ERROR_M		BITFIELD_MASK(1)	/* Bit 19   - General/Unknown error */
-#define RSP1_ERROR_S		19
-#define RSP1_CC_ERROR_M		BITFIELD_MASK(1)	/* Bit 20   - Internal Card Control error */
-#define RSP1_CC_ERROR_S		20
-#define RSP1_CARD_ECC_FAILED_M	BITFIELD_MASK(1)	/* Bit 21   - Card internal ECC failed
-							 * to correct data
-							 */
-#define RSP1_CARD_ECC_FAILED_S	21
-#define RSP1_ILLEGAL_CMD_M	BITFIELD_MASK(1)	/* Bit 22   - Cmd not legal for the card state */
-#define RSP1_ILLEGAL_CMD_S	22
-#define RSP1_COM_CRC_ERROR_M	BITFIELD_MASK(1)	/* Bit 23   - CRC check of previous command failed
-							 */
-#define RSP1_COM_CRC_ERROR_S	23
-#define RSP1_LOCK_UNLOCK_FAIL_M	BITFIELD_MASK(1)	/* Bit 24   - Card lock-unlock Cmd Seq error */
-#define RSP1_LOCK_UNLOCK_FAIL_S	24
-#define RSP1_CARD_LOCKED_M	BITFIELD_MASK(1)	/* Bit 25   - Card locked by the host */
-#define RSP1_CARD_LOCKED_S	25
-#define RSP1_WP_VIOLATION_M	BITFIELD_MASK(1)	/* Bit 26   - Attempt to program
-							 * write-protected blocks
-							 */
-#define RSP1_WP_VIOLATION_S	26
-#define RSP1_ERASE_PARAM_M	BITFIELD_MASK(1)	/* Bit 27   - Invalid erase blocks */
-#define RSP1_ERASE_PARAM_S	27
-#define RSP1_ERASE_SEQ_ERR_M	BITFIELD_MASK(1)	/* Bit 28   - Erase Cmd seq error */
-#define RSP1_ERASE_SEQ_ERR_S	28
-#define RSP1_BLK_LEN_ERR_M	BITFIELD_MASK(1)	/* Bit 29   - Block length error */
-#define RSP1_BLK_LEN_ERR_S	29
-#define RSP1_ADDR_ERR_M		BITFIELD_MASK(1)	/* Bit 30   - Misaligned address */
-#define RSP1_ADDR_ERR_S		30
-#define RSP1_OUT_OF_RANGE_M	BITFIELD_MASK(1)	/* Bit 31   - Cmd arg was out of range */
-#define RSP1_OUT_OF_RANGE_S	31
-
-#define RSP5_DATA_M		BITFIELD_MASK(8)	/* Bits [0:7]   - data */
-#define RSP5_DATA_S		0
-#define RSP5_FLAGS_M		BITFIELD_MASK(8)	/* Bit  [15:8]  - Rsp flags */
-#define RSP5_FLAGS_S		8
-#define RSP5_STUFF_M		BITFIELD_MASK(16)	/* Bits [31:16] - Stuff bits */
-#define RSP5_STUFF_S		16
-
-/* ----------------------------------------------
- * SDIO Command Response structures for SPI mode
- * ----------------------------------------------
- */
-#define SPIRSP4_IO_OCR_M	BITFIELD_MASK(16)	/* Bits [15:0]    - Card's OCR Bits [23:8] */
-#define SPIRSP4_IO_OCR_S	0
-#define SPIRSP4_STUFF_M		BITFIELD_MASK(3)	/* Bits [18:16]   - Stuff bits */
-#define SPIRSP4_STUFF_S		16
-#define SPIRSP4_MEM_PRESENT_M	BITFIELD_MASK(1)	/* Bit  19        - Memory present */
-#define SPIRSP4_MEM_PRESENT_S	19
-#define SPIRSP4_NUM_FUNCS_M	BITFIELD_MASK(3)	/* Bits [22:20]   - Number of I/O funcs */
-#define SPIRSP4_NUM_FUNCS_S	20
-#define SPIRSP4_CARD_READY_M	BITFIELD_MASK(1)	/* Bit  23        - SDIO card ready */
-#define SPIRSP4_CARD_READY_S	23
-#define SPIRSP4_IDLE_STATE_M	BITFIELD_MASK(1)	/* Bit  24        - idle state */
-#define SPIRSP4_IDLE_STATE_S	24
-#define SPIRSP4_ILLEGAL_CMD_M	BITFIELD_MASK(1)	/* Bit  26        - Illegal Cmd error */
-#define SPIRSP4_ILLEGAL_CMD_S	26
-#define SPIRSP4_COM_CRC_ERROR_M	BITFIELD_MASK(1)	/* Bit  27        - COM CRC error */
-#define SPIRSP4_COM_CRC_ERROR_S	27
-#define SPIRSP4_FUNC_NUM_ERROR_M	BITFIELD_MASK(1)	/* Bit  28        - Function number error
-								 */
-#define SPIRSP4_FUNC_NUM_ERROR_S	28
-#define SPIRSP4_PARAM_ERROR_M	BITFIELD_MASK(1)	/* Bit  30        - Parameter Error Bit */
-#define SPIRSP4_PARAM_ERROR_S	30
-#define SPIRSP4_START_BIT_M	BITFIELD_MASK(1)	/* Bit  31        - Start Bit */
-#define SPIRSP4_START_BIT_S	31
-
-#define SPIRSP5_DATA_M			BITFIELD_MASK(8)	/* Bits [23:16]   - R/W Data */
-#define SPIRSP5_DATA_S			16
-#define SPIRSP5_IDLE_STATE_M		BITFIELD_MASK(1)	/* Bit  24        - Idle state */
-#define SPIRSP5_IDLE_STATE_S		24
-#define SPIRSP5_ILLEGAL_CMD_M		BITFIELD_MASK(1)	/* Bit  26        - Illegal Cmd error */
-#define SPIRSP5_ILLEGAL_CMD_S		26
-#define SPIRSP5_COM_CRC_ERROR_M		BITFIELD_MASK(1)	/* Bit  27        - COM CRC error */
-#define SPIRSP5_COM_CRC_ERROR_S		27
-#define SPIRSP5_FUNC_NUM_ERROR_M	BITFIELD_MASK(1)	/* Bit  28        - Function number error
-								 */
-#define SPIRSP5_FUNC_NUM_ERROR_S	28
-#define SPIRSP5_PARAM_ERROR_M		BITFIELD_MASK(1)	/* Bit  30        - Parameter Error Bit */
-#define SPIRSP5_PARAM_ERROR_S		30
-#define SPIRSP5_START_BIT_M		BITFIELD_MASK(1)	/* Bit  31        - Start Bit */
-#define SPIRSP5_START_BIT_S		31
-
-/* RSP6 card status format; Pg 68 Physical Layer spec v 1.10 */
-#define RSP6STAT_AKE_SEQ_ERROR_M	BITFIELD_MASK(1)	/* Bit 3      - Authentication seq error
-								 */
-#define RSP6STAT_AKE_SEQ_ERROR_S	3
-#define RSP6STAT_APP_CMD_M		BITFIELD_MASK(1)	/* Bit 5      - Card expects ACMD */
-#define RSP6STAT_APP_CMD_S		5
-#define RSP6STAT_READY_FOR_DATA_M	BITFIELD_MASK(1)	/* Bit 8      - Ready for data
-								 * (buff empty)
-								 */
-#define RSP6STAT_READY_FOR_DATA_S	8
-#define RSP6STAT_CURR_STATE_M		BITFIELD_MASK(4)	/* Bits [12:9] - Card state at
-								 * Cmd reception
-								 */
-#define RSP6STAT_CURR_STATE_S		9
-#define RSP6STAT_ERROR_M		BITFIELD_MASK(1)	/* Bit 13  - General/Unknown error Bit 19
-								 */
-#define RSP6STAT_ERROR_S		13
-#define RSP6STAT_ILLEGAL_CMD_M		BITFIELD_MASK(1)	/* Bit 14  - Illegal cmd for
-								 * card state Bit 22
-								 */
-#define RSP6STAT_ILLEGAL_CMD_S		14
-#define RSP6STAT_COM_CRC_ERROR_M	BITFIELD_MASK(1)	/* Bit 15  - CRC previous command
-								 * failed Bit 23
-								 */
-#define RSP6STAT_COM_CRC_ERROR_S	15
-
-#define SDIOH_XFER_TYPE_READ    SD_IO_OP_READ
-#define SDIOH_XFER_TYPE_WRITE   SD_IO_OP_WRITE
-
-#endif				/* def BCMSDIO */
-#endif				/* _SDIO_H */
diff --git a/drivers/staging/brcm80211/include/bcmsdh.h b/drivers/staging/brcm80211/include/bcmsdh.h
index 3b57dc1..ba3fd62 100644
--- a/drivers/staging/brcm80211/include/bcmsdh.h
+++ b/drivers/staging/brcm80211/include/bcmsdh.h
@@ -38,6 +38,27 @@ extern const uint bcmsdh_msglevel;
 #define BCMSDH_INFO(x)
 #endif				/* BCMDBG */
 
+#define SDIO_FUNC_0		0
+#define SDIO_FUNC_1		1
+#define SDIO_FUNC_2		2
+
+#define SDIOD_FBR_SIZE  	0x100
+
+/* io_en */
+#define SDIO_FUNC_ENABLE_1	0x02
+#define SDIO_FUNC_ENABLE_2	0x04
+
+/* io_rdys */
+#define SDIO_FUNC_READY_1	0x02
+#define SDIO_FUNC_READY_2	0x04
+
+/* intr_status */
+#define INTR_STATUS_FUNC1	0x2
+#define INTR_STATUS_FUNC2	0x4
+
+/* Maximum number of I/O funcs */
+#define SDIOD_MAX_IOFUNCS	7
+
 /* forward declarations */
 typedef struct bcmsdh_info bcmsdh_info_t;
 typedef void (*bcmsdh_cb_fn_t) (void *);
-- 
1.7.4.1


