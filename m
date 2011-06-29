Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4627 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758124Ab1F2XtE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:04 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 108/119] staging: brcm80211: fullmac register access
 macro's take u32 instead of pointers
Date: Wed, 29 Jun 2011 16:48:12 -0700
Message-ID: <1309391303-22741-109-git-send-email-frankyl@broadcom.com> (sfid-20110630_015144_778896_F3D37107)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Fullmac contains macro's that access registers on the 32 bits
backplane bus. These registers should not be declared as pointers since
pointers can be 64 bits. The following patch series gets rid of these pointers
and ultimately of all compiler warning when compiling for amd64.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   77 ++++++++++++-------------
 1 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 25c5e90..5a15002 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -37,38 +37,36 @@
 /* register access macros */
 #ifndef __BIG_ENDIAN
 #ifndef __mips__
-#define R_REG(r) \
-	brcmf_sdcard_reg_read(NULL, (unsigned long)(r), sizeof(*(r)))
+#define R_REG(r, typ) \
+	brcmf_sdcard_reg_read(NULL, (r), sizeof(typ))
 #else				/* __mips__ */
-#define R_REG(r) \
+#define R_REG(r, typ) \
 	({ \
 		__typeof(*(r)) __osl_v; \
 		__asm__ __volatile__("sync"); \
-		__osl_v = brcmf_sdcard_reg_read(NULL, (unsigned long)(r),\
-					  sizeof(*(r))); \
+		__osl_v = brcmf_sdcard_reg_read(NULL, (r),\
+					  sizeof(typ)); \
 		__asm__ __volatile__("sync"); \
 		__osl_v; \
 	})
 #endif				/* __mips__ */
 
-#define W_REG(r, v) do { \
-		brcmf_sdcard_reg_write(NULL, (unsigned long)(r), sizeof(*(r)), \
-				       (v)); \
+#define W_REG(r, v, typ) do { \
+		brcmf_sdcard_reg_write(NULL, (r), sizeof(typ), (v)); \
 	} while (0)
 #else				/* __BIG_ENDIAN */
-#define R_REG(r) \
-	brcmf_sdcard_reg_read(NULL, (unsigned long)(r), sizeof(*(r)))
-#define W_REG(r, v) do { \
-		brcmf_sdcard_reg_write(NULL, (unsigned long)(r), sizeof(*(r)), \
-				       (v)); \
+#define R_REG(r, typ) \
+	brcmf_sdcard_reg_read(NULL, (r), sizeof(typ))
+#define W_REG(r, v, typ) do { \
+		brcmf_sdcard_reg_write(NULL, (r), sizeof(typ), (v)); \
 	} while (0)
 #endif				/* __BIG_ENDIAN */
 
-#define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
-#define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
+#define AND_REG(r, v, typ)	W_REG((r), R_REG(r, typ) & (v), typ)
+#define OR_REG(r, v, typ)	W_REG((r), R_REG(r, typ) | (v), typ)
 
-#define SET_REG(r, mask, val) \
-		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
+#define SET_REG(r, mask, val, typ) \
+		W_REG((r), ((R_REG(r) & ~(mask)) | (val)), typ)
 
 #ifdef BCMDBG
 
@@ -826,11 +824,11 @@ static bool brcmf_readahead;
 
 /* Macros to get register read/write status */
 /* NOTE: these assume a local dhdsdio_bus_t *bus! */
-#define R_SDREG(regvar, regaddr, retryvar) \
+#define R_SDREG(regvar, regaddr, retryvar, typ) \
 do { \
 	retryvar = 0; \
 	do { \
-		regvar = R_REG(regaddr); \
+		regvar = R_REG((u32)(regaddr), typ); \
 	} while (brcmf_sdcard_regfail(bus->card) && \
 		 (++retryvar <= retry_limit)); \
 	if (retryvar) { \
@@ -843,11 +841,11 @@ do { \
 	} \
 } while (0)
 
-#define W_SDREG(regval, regaddr, retryvar) \
+#define W_SDREG(regval, regaddr, retryvar, typ) \
 do { \
 	retryvar = 0; \
 	do { \
-		W_REG(regaddr, regval); \
+		W_REG((u32)(regaddr), regval, typ); \
 	} while (brcmf_sdcard_regfail(bus->card) && \
 		 (++retryvar <= retry_limit)); \
 	if (retryvar) { \
@@ -994,7 +992,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		if (pendok && ((bus->ci->buscoretype == PCMCIA_CORE_ID)
 			       && (bus->ci->buscorerev == 9))) {
 			u32 dummy, retries;
-			R_SDREG(dummy, &bus->regs->clockctlstatus, retries);
+			R_SDREG(dummy, &bus->regs->clockctlstatus, retries,
+				u32);
 		}
 
 		/* Check current status */
@@ -1191,7 +1190,7 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 		/* Tell device to start using OOB wakeup */
-		W_SDREG(SMB_USE_OOB, &regs->tosbmailbox, retries);
+		W_SDREG(SMB_USE_OOB, &regs->tosbmailbox, retries, u32);
 		if (retries > retry_limit)
 			DHD_ERROR(("CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n"));
 
@@ -1230,9 +1229,9 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 		/* Send misc interrupt to indicate OOB not needed */
-		W_SDREG(0, &regs->tosbmailboxdata, retries);
+		W_SDREG(0, &regs->tosbmailboxdata, retries, u32);
 		if (retries <= retry_limit)
-			W_SDREG(SMB_DEV_INT, &regs->tosbmailbox, retries);
+			W_SDREG(SMB_DEV_INT, &regs->tosbmailbox, retries, u32);
 
 		if (retries > retry_limit)
 			DHD_ERROR(("CANNOT SIGNAL CHIP TO CLEAR OOB!!\n"));
@@ -1554,7 +1553,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
 			/* Check device status, signal pending interrupt */
-			R_SDREG(intstatus, &regs->intstatus, retries);
+			R_SDREG(intstatus, &regs->intstatus, retries, u32);
 			bus->f2txdata++;
 			if (brcmf_sdcard_regfail(bus->card))
 				break;
@@ -3029,7 +3028,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 			bcmerror = 0;
 		}
 
-		W_SDREG(0xFFFFFFFF, &bus->regs->intstatus, retries);
+		W_SDREG(0xFFFFFFFF, &bus->regs->intstatus, retries, u32);
 
 		brcmf_sdbrcm_chip_resetcore(bus->card, bus->ci->armcorebase);
 
@@ -3162,7 +3161,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 		tasklet_kill(&bus->tasklet);
 
 	/* Disable and clear interrupts at the chip level also */
-	W_SDREG(0, &bus->regs->hostintmask, retries);
+	W_SDREG(0, &bus->regs->hostintmask, retries, u32);
 	local_hostintmask = bus->hostintmask;
 	bus->hostintmask = 0;
 
@@ -3189,7 +3188,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 			 SDIO_FUNC_ENABLE_1, NULL);
 
 	/* Clear any pending interrupts now that F2 is disabled */
-	W_SDREG(local_hostintmask, &bus->regs->intstatus, retries);
+	W_SDREG(local_hostintmask, &bus->regs->intstatus, retries, u32);
 
 	/* Turn off the backplane clock (only) */
 	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
@@ -3268,7 +3267,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 
 	/* Enable function 2 (frame transfers) */
 	W_SDREG((SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT),
-		&bus->regs->tosbmailboxdata, retries);
+		&bus->regs->tosbmailboxdata, retries, u32);
 	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
 
 	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable,
@@ -3291,7 +3290,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 		bus->hostintmask = HOSTINTMASK;
 		W_SDREG(bus->hostintmask,
 			(unsigned int *)CORE_BUS_REG(bus->ci->buscorebase,
-			hostintmask), retries);
+			hostintmask), retries, u32);
 
 		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_WATERMARK,
 				 (u8) watermark, &err);
@@ -3395,7 +3394,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 
 	if (rtx) {
 		bus->rxrtx++;
-		W_SDREG(SMB_NAK, &regs->tosbmailbox, retries);
+		W_SDREG(SMB_NAK, &regs->tosbmailbox, retries, u32);
 		bus->f1regdata++;
 		if (retries <= retry_limit)
 			bus->rxskip = true;
@@ -4525,9 +4524,9 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	/* Read mailbox data and ack that we did so */
-	R_SDREG(hmb_data, &regs->tohostmailboxdata, retries);
+	R_SDREG(hmb_data, &regs->tohostmailboxdata, retries, u32);
 	if (retries <= retry_limit)
-		W_SDREG(SMB_INT_ACK, &regs->tosbmailbox, retries);
+		W_SDREG(SMB_INT_ACK, &regs->tosbmailbox, retries, u32);
 	bus->f1regdata += 2;
 
 	/* Dongle recomposed rx frames, accept them again */
@@ -4669,14 +4668,14 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	/* Pending interrupt indicates new device status */
 	if (bus->ipend) {
 		bus->ipend = false;
-		R_SDREG(newstatus, &regs->intstatus, retries);
+		R_SDREG(newstatus, &regs->intstatus, retries, u32);
 		bus->f1regdata++;
 		if (brcmf_sdcard_regfail(bus->card))
 			newstatus = 0;
 		newstatus &= bus->hostintmask;
 		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
 		if (newstatus) {
-			W_SDREG(newstatus, &regs->intstatus, retries);
+			W_SDREG(newstatus, &regs->intstatus, retries, u32);
 			bus->f1regdata++;
 		}
 	}
@@ -4691,8 +4690,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	 */
 	if (intstatus & I_HMB_FC_CHANGE) {
 		intstatus &= ~I_HMB_FC_CHANGE;
-		W_SDREG(I_HMB_FC_CHANGE, &regs->intstatus, retries);
-		R_SDREG(newstatus, &regs->intstatus, retries);
+		W_SDREG(I_HMB_FC_CHANGE, &regs->intstatus, retries, u32);
+		R_SDREG(newstatus, &regs->intstatus, retries, u32);
 		bus->f1regdata += 2;
 		bus->fcstate =
 		    !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE));
@@ -5594,7 +5593,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, void *regsva,
 	bus->regs = (void *)bus->ci->buscorebase;
 
 	/* Set core control so an SDIO reset does a backplane reset */
-	OR_REG(&bus->regs->corecontrol, CC_BPRESEN);
+	OR_REG((u32)&bus->regs->corecontrol, CC_BPRESEN, u32);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
-- 
1.7.1


