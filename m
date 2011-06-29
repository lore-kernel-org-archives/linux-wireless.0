Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4452 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab1F2XtS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:18 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 110/119] staging: brcm80211: replaced macro W_SDREG by
 function w_sdreg()
Date: Wed, 29 Jun 2011 16:48:14 -0700
Message-ID: <1309391303-22741-111-git-send-email-frankyl@broadcom.com> (sfid-20110630_015209_965230_E05AD0A1)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Leads to more readable code and better type checking.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   74 ++++++++++++++-----------
 1 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 13a319d..9ac256e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -847,20 +847,20 @@ r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 	}
 }
 
-#define W_SDREG(regval, regaddr, retryvar, typ) \
-do { \
-	retryvar = 0; \
-	do { \
-		W_REG((u32)(regaddr), regval, typ); \
-	} while (brcmf_sdcard_regfail(bus->card) && \
-		 (++retryvar <= retry_limit)); \
-	if (retryvar) { \
-		bus->regfails += (retryvar-1); \
-		if (retryvar > retry_limit) \
-			DHD_ERROR(("%s: FAILED REGISTER WRITE, LINE %d\n", \
-			__func__, __LINE__)); \
-	} \
-} while (0)
+static void
+w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
+{
+	*retryvar = 0;
+	do {
+		W_REG(bus->ci->buscorebase + reg_offset, regval, u32);
+	} while (brcmf_sdcard_regfail(bus->card) &&
+		 (++(*retryvar) <= retry_limit));
+	if (*retryvar) {
+		bus->regfails += (*retryvar-1);
+		if (*retryvar > retry_limit)
+			DHD_ERROR(("FAILED REGISTER WRITE %Xh\n", reg_offset));
+	}
+}
 
 #define DHD_BUS			SDIO_BUS
 
@@ -1173,7 +1173,6 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 {
 	struct brcmf_sdio_card *card = bus->card;
-	struct sdpcmd_regs *regs = bus->regs;
 	uint retries = 0;
 
 	DHD_INFO(("brcmf_sdbrcm_bussleep: request %s (currently %s)\n",
@@ -1197,7 +1196,8 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 		/* Tell device to start using OOB wakeup */
-		W_SDREG(SMB_USE_OOB, &regs->tosbmailbox, retries, u32);
+		w_sdreg32(bus, SMB_USE_OOB,
+			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
 		if (retries > retry_limit)
 			DHD_ERROR(("CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n"));
 
@@ -1236,9 +1236,12 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 		/* Send misc interrupt to indicate OOB not needed */
-		W_SDREG(0, &regs->tosbmailboxdata, retries, u32);
+		w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, tosbmailboxdata),
+			  &retries);
 		if (retries <= retry_limit)
-			W_SDREG(SMB_DEV_INT, &regs->tosbmailbox, retries, u32);
+			w_sdreg32(bus, SMB_DEV_INT,
+				  offsetof(struct sdpcmd_regs, tosbmailbox),
+				  &retries);
 
 		if (retries > retry_limit)
 			DHD_ERROR(("CANNOT SIGNAL CHIP TO CLEAR OOB!!\n"));
@@ -3036,7 +3039,8 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 			bcmerror = 0;
 		}
 
-		W_SDREG(0xFFFFFFFF, &bus->regs->intstatus, retries, u32);
+		w_sdreg32(bus, 0xFFFFFFFF,
+			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 
 		brcmf_sdbrcm_chip_resetcore(bus->card, bus->ci->armcorebase);
 
@@ -3169,7 +3173,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 		tasklet_kill(&bus->tasklet);
 
 	/* Disable and clear interrupts at the chip level also */
-	W_SDREG(0, &bus->regs->hostintmask, retries, u32);
+	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask), &retries);
 	local_hostintmask = bus->hostintmask;
 	bus->hostintmask = 0;
 
@@ -3196,7 +3200,8 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 			 SDIO_FUNC_ENABLE_1, NULL);
 
 	/* Clear any pending interrupts now that F2 is disabled */
-	W_SDREG(local_hostintmask, &bus->regs->intstatus, retries, u32);
+	w_sdreg32(bus, local_hostintmask,
+		  offsetof(struct sdpcmd_regs, intstatus), &retries);
 
 	/* Turn off the backplane clock (only) */
 	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
@@ -3274,8 +3279,8 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	}
 
 	/* Enable function 2 (frame transfers) */
-	W_SDREG((SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT),
-		&bus->regs->tosbmailboxdata, retries, u32);
+	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
+		  offsetof(struct sdpcmd_regs, tosbmailboxdata), &retries);
 	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
 
 	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_0, SDIO_CCCR_IOEx, enable,
@@ -3296,9 +3301,8 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	if (ready == enable) {
 		/* Set up the interrupt mask and enable interrupts */
 		bus->hostintmask = HOSTINTMASK;
-		W_SDREG(bus->hostintmask,
-			(unsigned int *)CORE_BUS_REG(bus->ci->buscorebase,
-			hostintmask), retries, u32);
+		w_sdreg32(bus, bus->hostintmask,
+			  offsetof(struct sdpcmd_regs, hostintmask), &retries);
 
 		brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_WATERMARK,
 				 (u8) watermark, &err);
@@ -3356,7 +3360,6 @@ exit:
 static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 {
 	struct brcmf_sdio_card *card = bus->card;
-	struct sdpcmd_regs *regs = bus->regs;
 	uint retries = 0;
 	u16 lastrbc;
 	u8 hi, lo;
@@ -3402,7 +3405,9 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 
 	if (rtx) {
 		bus->rxrtx++;
-		W_SDREG(SMB_NAK, &regs->tosbmailbox, retries, u32);
+		w_sdreg32(bus, SMB_NAK,
+			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
+
 		bus->f1regdata++;
 		if (retries <= retry_limit)
 			bus->rxskip = true;
@@ -4523,7 +4528,6 @@ deliver:
 
 static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 {
-	struct sdpcmd_regs *regs = bus->regs;
 	u32 intstatus = 0;
 	u32 hmb_data;
 	u8 fcbits;
@@ -4536,7 +4540,8 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 		  offsetof(struct sdpcmd_regs, tohostmailboxdata), &retries);
 
 	if (retries <= retry_limit)
-		W_SDREG(SMB_INT_ACK, &regs->tosbmailbox, retries, u32);
+		w_sdreg32(bus, SMB_INT_ACK,
+			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
 	bus->f1regdata += 2;
 
 	/* Dongle recomposed rx frames, accept them again */
@@ -4600,7 +4605,6 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 {
 	struct brcmf_sdio_card *card = bus->card;
-	struct sdpcmd_regs *regs = bus->regs;
 	u32 intstatus, newstatus = 0;
 	uint retries = 0;
 	uint rxlimit = brcmf_rxbound;	/* Rx frames to read before resched */
@@ -4686,7 +4690,9 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 		newstatus &= bus->hostintmask;
 		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
 		if (newstatus) {
-			W_SDREG(newstatus, &regs->intstatus, retries, u32);
+			w_sdreg32(bus, newstatus,
+				  offsetof(struct sdpcmd_regs, intstatus),
+				  &retries);
 			bus->f1regdata++;
 		}
 	}
@@ -4701,7 +4707,9 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	 */
 	if (intstatus & I_HMB_FC_CHANGE) {
 		intstatus &= ~I_HMB_FC_CHANGE;
-		W_SDREG(I_HMB_FC_CHANGE, &regs->intstatus, retries, u32);
+		w_sdreg32(bus, I_HMB_FC_CHANGE,
+			  offsetof(struct sdpcmd_regs, intstatus), &retries);
+
 		r_sdreg32(bus, &newstatus,
 			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 		bus->f1regdata += 2;
-- 
1.7.1


