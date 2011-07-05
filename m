Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4295 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab1GEUGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 18/21] staging: brcm80211: removed unused definitions
 from dhd_sdio.c
Date: Tue, 5 Jul 2011 22:06:14 +0200
Message-ID: <1309896377-4425-19-git-send-email-arend@broadcom.com> (sfid-20110705_220645_173278_01D128EB)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   25 ++-----------------------
 1 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index ba57481..5e079b0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -65,11 +65,6 @@
 
 /* Trap types defined by ARM (see arminc.h) */
 
-/* Trap locations in lo memory */
-#define	TRAP_STRIDE	4
-#define FIRST_TRAP	TR_RST
-#define LAST_TRAP	(TR_FIQ * TRAP_STRIDE)
-
 #if defined(__ARM_ARCH_4T__)
 #define	MAX_TRAP_TYPE	(TR_FIQ + 1)
 #elif defined(__ARM_ARCH_7M__)
@@ -114,8 +109,6 @@ struct brcmf_trap {
 
 #define CBUF_LEN	(128)
 
-#define LOG_BUF_LEN	1024
-
 struct rte_log {
 	u32 buf;		/* Can't be pointer on (64-bit) hosts */
 	uint buf_size;
@@ -166,10 +159,6 @@ struct rte_console {
 #include "dhd_dbg.h"
 #include <bcmchip.h>
 
-#ifndef DHDSDIO_MEM_DUMP_FNAME
-#define DHDSDIO_MEM_DUMP_FNAME         "mem_dump"
-#endif
-
 #define TXQLEN		2048	/* bulk tx queue length */
 #define TXHI		(TXQLEN - 256)	/* turn on flow control above TXHI */
 #define TXLOW		(TXHI - 256)	/* turn off flow control below TXLOW */
@@ -344,7 +333,6 @@ struct rte_console {
 /* Value for ChipClockCSR during initial setup */
 #define DHD_INIT_CLKCTL1	(SBSDIO_FORCE_HW_CLKREQ_OFF |	\
 					SBSDIO_ALP_AVAIL_REQ)
-#define DHD_INIT_CLKCTL2	(SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_FORCE_ALP)
 
 /* Flags for SDH calls */
 #define F2SYNC	(SDIO_REQ_4BYTE | SDIO_REQ_FIXED)
@@ -541,11 +529,7 @@ struct brcmf_bus {
 	struct chip_info *ci;	/* Chip info struct */
 	char *vars;		/* Variables (from CIS and/or other) */
 	uint varsz;		/* Size of variables buffer */
-	u32 sbaddr;		/* Current SB window pointer (-1, invalid) */
 
-	uint sdpcmrev;		/* SDIO core revision */
-	uint armrev;		/* CPU core revision */
-	uint ramrev;		/* SOCRAM core revision */
 	u32 ramsize;		/* Size of RAM in SOCRAM (bytes) */
 	u32 orig_ramsize;	/* Size of RAM in SOCRAM (bytes) */
 
@@ -612,8 +596,6 @@ struct brcmf_bus {
 	bool sleeping;		/* Is SDIO bus sleeping? */
 	bool rxflow_mode;	/* Rx flow control mode */
 	bool rxflow;		/* Is rx flow control on */
-	uint prev_rxlim_hit;	/* Is prev rx limit exceeded
-					 (per dpc schedule) */
 	bool alp_only;		/* Don't use HT clock (ALP only) */
 /* Field to decide if rx of control frames happen in rxbuf or lb-pool */
 	bool usebufpool;
@@ -782,8 +764,6 @@ static bool retrydata;
 static const uint watermark = 8;
 static const uint firstread = BRCMF_FIRSTREAD;
 
-#define HDATLEN (firstread - (SDPCM_HDRLEN))
-
 /* Retry count for register access failures */
 static const uint retry_limit = 2;
 
@@ -5584,8 +5564,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 
 	/* Get info on the ARM and SOCRAM cores... */
 	if (!DHD_NOPMU(bus)) {
-		bus->armrev = SBCOREREV(brcmf_sdcard_reg_read(bus->card,
-			CORE_SB(bus->ci->armcorebase, sbidhigh), 4));
+		brcmf_sdcard_reg_read(bus->card,
+			  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
 		bus->orig_ramsize = bus->ci->ramsize;
 		if (!(bus->orig_ramsize)) {
 			DHD_ERROR(("%s: failed to find SOCRAM memory!\n",
@@ -5680,7 +5660,6 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 	bus->drvr->busstate = DHD_BUS_DOWN;
 	bus->sleeping = false;
 	bus->rxflow = false;
-	bus->prev_rxlim_hit = 0;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
 	brcmf_sdcard_cfg_write(card, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR, 0,
-- 
1.7.4.1


