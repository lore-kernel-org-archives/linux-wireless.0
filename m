Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3143 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab1GEUGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 13/21] staging: brcm80211: replaced macro R_SDREG by
 function r_sdreg()
Date: Tue, 5 Jul 2011 22:06:09 +0200
Message-ID: <1309896377-4425-14-git-send-email-arend@broadcom.com> (sfid-20110705_220638_988206_8DDEE668)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Leads to more readable code and better type checking.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   68 ++++++++++++++----------
 1 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 5a15002..13a319d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -403,7 +403,10 @@ struct rte_console {
 
 BRCMF_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
 
-/* Core reg address translation */
+/*
+ * Core reg address translation.
+ * Both macro's returns a 32 bits byte address on the backplane bus.
+ */
 #define CORE_CC_REG(base, field)	(base + offsetof(chipcregs_t, field))
 #define CORE_BUS_REG(base, field) \
 		(base + offsetof(struct sdpcmd_regs, field))
@@ -530,7 +533,7 @@ struct chip_info {
 	u32 cccorebase;
 	u32 ccrev;
 	u32 cccaps;
-	u32 buscorebase;
+	u32 buscorebase; /* 32 bits backplane bus address */
 	u32 buscorerev;
 	u32 buscoretype;
 	u32 ramcorebase;
@@ -549,7 +552,8 @@ struct brcmf_bus {
 	uint varsz;		/* Size of variables buffer */
 	u32 sbaddr;		/* Current SB window pointer (-1, invalid) */
 
-	struct sdpcmd_regs *regs;	/* SDIO core */
+	/* SDIO core, 32 bit address on the backplane bus: */
+	struct sdpcmd_regs *regs;
 	uint sdpcmrev;		/* SDIO core revision */
 	uint armrev;		/* CPU core revision */
 	uint ramrev;		/* SOCRAM core revision */
@@ -822,24 +826,26 @@ static bool brcmf_readahead;
 	(((u8)(bus->tx_max - bus->tx_seq) != 0) && \
 	(((u8)(bus->tx_max - bus->tx_seq) & 0x80) == 0))
 
-/* Macros to get register read/write status */
-/* NOTE: these assume a local dhdsdio_bus_t *bus! */
-#define R_SDREG(regvar, regaddr, retryvar, typ) \
-do { \
-	retryvar = 0; \
-	do { \
-		regvar = R_REG((u32)(regaddr), typ); \
-	} while (brcmf_sdcard_regfail(bus->card) && \
-		 (++retryvar <= retry_limit)); \
-	if (retryvar) { \
-		bus->regfails += (retryvar-1); \
-		if (retryvar > retry_limit) { \
-			DHD_ERROR(("%s: FAILED" #regvar "READ, LINE %d\n", \
-			__func__, __LINE__)); \
-			regvar = 0; \
-		} \
-	} \
-} while (0)
+/*
+ * Reads a register in the SDIO hardware block. This block occupies a series of
+ * adresses on the 32 bit backplane bus.
+ */
+static void
+r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
+{
+	*retryvar = 0;
+	do {
+		*regvar = R_REG(bus->ci->buscorebase + reg_offset, u32);
+	} while (brcmf_sdcard_regfail(bus->card) &&
+		 (++(*retryvar) <= retry_limit));
+	if (*retryvar) {
+		bus->regfails += (*retryvar-1);
+		if (*retryvar > retry_limit) {
+			DHD_ERROR(("FAILED READ %Xh\n", reg_offset));
+			*regvar = 0;
+		}
+	}
+}
 
 #define W_SDREG(regval, regaddr, retryvar, typ) \
 do { \
@@ -992,8 +998,9 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		if (pendok && ((bus->ci->buscoretype == PCMCIA_CORE_ID)
 			       && (bus->ci->buscorerev == 9))) {
 			u32 dummy, retries;
-			R_SDREG(dummy, &bus->regs->clockctlstatus, retries,
-				u32);
+			r_sdreg32(bus, &dummy,
+				  offsetof(struct sdpcmd_regs, clockctlstatus),
+				  &retries);
 		}
 
 		/* Check current status */
@@ -1521,7 +1528,6 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 	u8 tx_prec_map;
 
 	struct brcmf_pub *drvr = bus->drvr;
-	struct sdpcmd_regs *regs = bus->regs;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -1553,7 +1559,9 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
 			/* Check device status, signal pending interrupt */
-			R_SDREG(intstatus, &regs->intstatus, retries, u32);
+			r_sdreg32(bus, &intstatus,
+				  offsetof(struct sdpcmd_regs, intstatus),
+				  &retries);
 			bus->f2txdata++;
 			if (brcmf_sdcard_regfail(bus->card))
 				break;
@@ -4524,7 +4532,9 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	/* Read mailbox data and ack that we did so */
-	R_SDREG(hmb_data, &regs->tohostmailboxdata, retries, u32);
+	r_sdreg32(bus, &hmb_data,
+		  offsetof(struct sdpcmd_regs, tohostmailboxdata), &retries);
+
 	if (retries <= retry_limit)
 		W_SDREG(SMB_INT_ACK, &regs->tosbmailbox, retries, u32);
 	bus->f1regdata += 2;
@@ -4668,7 +4678,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	/* Pending interrupt indicates new device status */
 	if (bus->ipend) {
 		bus->ipend = false;
-		R_SDREG(newstatus, &regs->intstatus, retries, u32);
+		r_sdreg32(bus, &newstatus,
+			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 		bus->f1regdata++;
 		if (brcmf_sdcard_regfail(bus->card))
 			newstatus = 0;
@@ -4691,7 +4702,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	if (intstatus & I_HMB_FC_CHANGE) {
 		intstatus &= ~I_HMB_FC_CHANGE;
 		W_SDREG(I_HMB_FC_CHANGE, &regs->intstatus, retries, u32);
-		R_SDREG(newstatus, &regs->intstatus, retries, u32);
+		r_sdreg32(bus, &newstatus,
+			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 		bus->f1regdata += 2;
 		bus->fcstate =
 		    !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE));
-- 
1.7.4.1


