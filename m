Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4643 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab1DYWpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 18:45:30 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	brudley@broadcom.com, henryp@broadcom.com, hharte@broadcom.com
Subject: [PATCH 3/7] staging: brcm80211: Remove siutils dependency of
 dhdsdio_download_state
Date: Mon, 25 Apr 2011 15:45:09 -0700
Message-ID: <1303771513-18851-4-git-send-email-frankyl@broadcom.com> (sfid-20110426_004545_943168_416E7C42)
In-Reply-To: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
References: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dhdsdio_chip_disablecore and dhd_sdio_chip_resetcore to replace
siutils functions used in dhdsdio_download_state

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  114 ++++++++++++-------------
 1 files changed, 53 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 75be99d..4e5d1ee 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -482,7 +482,9 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus);
 #ifdef BCMEMBEDIMAGE
 static int dhdsdio_download_code_array(struct dhd_bus *bus);
 #endif
+static void dhdsdio_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase);
 static int dhdsdio_chip_attach(struct dhd_bus *bus, void *regs);
+static void dhdsdio_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase);
 
 static void dhd_dongle_setmemsize(struct dhd_bus *bus, int mem_size)
 {
@@ -2615,42 +2617,18 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 {
 	uint retries;
+	u32 regdata;
 	int bcmerror = 0;
 
 	/* To enter download state, disable ARM and reset SOCRAM.
 	 * To exit download state, simply reset ARM (default is RAM boot).
 	 */
 	if (enter) {
-
 		bus->alp_only = true;
 
-		if (!(si_setcore(bus->sih, ARM7S_CORE_ID, 0)) &&
-		    !(si_setcore(bus->sih, ARMCM3_CORE_ID, 0))) {
-			DHD_ERROR(("%s: Failed to find ARM core!\n", __func__));
-			bcmerror = -EBADE;
-			goto fail;
-		}
+		dhdsdio_chip_disablecore(bus->sdh, bus->ci->armcorebase);
 
-		si_core_disable(bus->sih, 0);
-		if (bcmsdh_regfail(bus->sdh)) {
-			bcmerror = -EIO;
-			goto fail;
-		}
-
-		if (!(si_setcore(bus->sih, SOCRAM_CORE_ID, 0))) {
-			DHD_ERROR(("%s: Failed to find SOCRAM core!\n",
-				   __func__));
-			bcmerror = -EBADE;
-			goto fail;
-		}
-
-		si_core_reset(bus->sih, 0, 0);
-		if (bcmsdh_regfail(bus->sdh)) {
-			DHD_ERROR(("%s: Failure trying reset SOCRAM core?\n",
-				   __func__));
-			bcmerror = -EIO;
-			goto fail;
-		}
+		dhdsdio_chip_resetcore(bus->sdh, bus->ci->ramcorebase);
 
 		/* Clear the top bit of memory */
 		if (bus->ramsize) {
@@ -2659,14 +2637,11 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 					 (u8 *)&zeros, 4);
 		}
 	} else {
-		if (!(si_setcore(bus->sih, SOCRAM_CORE_ID, 0))) {
-			DHD_ERROR(("%s: Failed to find SOCRAM core!\n",
-				   __func__));
-			bcmerror = -EBADE;
-			goto fail;
-		}
-
-		if (!si_iscoreup(bus->sih)) {
+		regdata = bcmsdh_reg_read(bus->sdh,
+			 CORE_SB(bus->ci->ramcorebase, sbtmstatelow), 4);
+		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
+			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+		if ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) != regdata) {
 			DHD_ERROR(("%s: SOCRAM core is down after reset?\n",
 				   __func__));
 			bcmerror = -EBADE;
@@ -2679,41 +2654,16 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 			bcmerror = 0;
 		}
 
-		if (!si_setcore(bus->sih, PCMCIA_CORE_ID, 0) &&
-		    !si_setcore(bus->sih, SDIOD_CORE_ID, 0)) {
-			DHD_ERROR(("%s: Can't change back to SDIO core?\n",
-				   __func__));
-			bcmerror = -EBADE;
-			goto fail;
-		}
 		W_SDREG(0xFFFFFFFF, &bus->regs->intstatus, retries);
 
-		if (!(si_setcore(bus->sih, ARM7S_CORE_ID, 0)) &&
-		    !(si_setcore(bus->sih, ARMCM3_CORE_ID, 0))) {
-			DHD_ERROR(("%s: Failed to find ARM core!\n", __func__));
-			bcmerror = -EBADE;
-			goto fail;
-		}
-
-		si_core_reset(bus->sih, 0, 0);
-		if (bcmsdh_regfail(bus->sdh)) {
-			DHD_ERROR(("%s: Failure trying to reset ARM core?\n",
-				   __func__));
-			bcmerror = -EIO;
-			goto fail;
-		}
+		dhdsdio_chip_resetcore(bus->sdh, bus->ci->armcorebase);
 
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
 
 		bus->dhd->busstate = DHD_BUS_LOAD;
 	}
-
 fail:
-	/* Always return to SDIOD core */
-	if (!si_setcore(bus->sih, PCMCIA_CORE_ID, 0))
-		si_setcore(bus->sih, SDIOD_CORE_ID, 0);
-
 	return bcmerror;
 }
 
@@ -6324,3 +6274,45 @@ fail:
 	kfree(ci);
 	return err;
 }
+
+static void
+dhdsdio_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase)
+{
+	u32 regdata;
+
+	/*
+	 * Must do the disable sequence first to work for
+	 * arbitrary current core state.
+	 */
+	dhdsdio_chip_disablecore(sdh, corebase);
+
+	/*
+	 * Now do the initialization sequence.
+	 * set reset while enabling the clock and
+	 * forcing them on throughout the core
+	 */
+	bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+		((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
+		SBTML_RESET);
+	udelay(1);
+
+	regdata = bcmsdh_reg_read(sdh, CORE_SB(corebase, sbtmstatehigh), 4);
+	if (regdata & SBTMH_SERR)
+		bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatehigh), 4, 0);
+
+	regdata = bcmsdh_reg_read(sdh, CORE_SB(corebase, sbimstate), 4);
+	if (regdata & (SBIM_IBE | SBIM_TO))
+		bcmsdh_reg_write(sdh, CORE_SB(corebase, sbimstate), 4,
+			regdata & ~(SBIM_IBE | SBIM_TO));
+
+	/* clear reset and allow it to propagate throughout the core */
+	bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+		(SICF_FGC << SBTML_SICF_SHIFT) |
+		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+	udelay(1);
+
+	/* leave clock enabled */
+	bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+	udelay(1);
+}
-- 
1.7.1


