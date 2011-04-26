Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2513 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852Ab1DZCef (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 22:34:35 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	brudley@broadcom.com, henryp@broadcom.com, hharte@broadcom.com
Subject: [PATCH 4/5] staging: brcm80211: Remove siutils dependence from
 dhd_sdio.c
Date: Mon, 25 Apr 2011 19:34:07 -0700
Message-ID: <1303785248-27420-5-git-send-email-frankyl@broadcom.com> (sfid-20110426_043444_222258_D2BD264B)
In-Reply-To: <1303785248-27420-1-git-send-email-frankyl@broadcom.com>
References: <1303785248-27420-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove siutils related functions and resources from dhd_sdio.c

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmchip.h  |    1 +
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   79 +++++++++----------------
 2 files changed, 28 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmchip.h b/drivers/staging/brcm80211/brcmfmac/bcmchip.h
index 29eeee2..c0d4c3b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmchip.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmchip.h
@@ -30,5 +30,6 @@
 #define BCM4329_CORE_SOCRAM_BASE	0x18003000
 /* ARM Cortex M3 core, ID 0x82a */
 #define BCM4329_CORE_ARM_BASE		0x18002000
+#define BCM4329_RAMSIZE			0x48000
 
 #endif				/* _bcmchip_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 74d7935..dc80e27 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -180,6 +180,7 @@ struct chip_info {
 	u32 ramcorebase;
 	u32 armcorebase;
 	u32 pmurev;
+	u32 ramsize;
 };
 
 /* Private data for SDIO bus interaction */
@@ -187,7 +188,6 @@ typedef struct dhd_bus {
 	dhd_pub_t *dhd;
 
 	bcmsdh_info_t *sdh;	/* Handle for BCMSDH calls */
-	si_t *sih;		/* Handle for SI calls */
 	struct chip_info *ci;	/* Chip info struct */
 	char *vars;		/* Variables (from CIS and/or other) */
 	uint varsz;		/* Size of variables buffer */
@@ -535,8 +535,8 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		clkreq =
 		    bus->alp_only ? SBSDIO_ALP_AVAIL_REQ : SBSDIO_HT_AVAIL_REQ;
 
-		if ((bus->sih->chip == BCM4329_CHIP_ID)
-		    && (bus->sih->chiprev == 0))
+		if ((bus->ci->chip == BCM4329_CHIP_ID)
+		    && (bus->ci->chiprev == 0))
 			clkreq |= SBSDIO_FORCE_ALP;
 
 		bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
@@ -547,8 +547,8 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 			return BCME_ERROR;
 		}
 
-		if (pendok && ((bus->sih->buscoretype == PCMCIA_CORE_ID)
-			       && (bus->sih->buscorerev == 9))) {
+		if (pendok && ((bus->ci->buscoretype == PCMCIA_CORE_ID)
+			       && (bus->ci->buscorerev == 9))) {
 			u32 dummy, retries;
 			R_SDREG(dummy, &bus->regs->clockctlstatus, retries);
 		}
@@ -842,8 +842,8 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 				 SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
 
 		/* Isolate the bus */
-		if (bus->sih->chip != BCM4329_CHIP_ID
-		    && bus->sih->chip != BCM4319_CHIP_ID) {
+		if (bus->ci->chip != BCM4329_CHIP_ID
+		    && bus->ci->chip != BCM4319_CHIP_ID) {
 			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
 					 SBSDIO_DEVCTL_PADS_ISO, NULL);
 		}
@@ -859,8 +859,8 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 
 		/* Force pad isolation off if possible
 			 (in case power never toggled) */
-		if ((bus->sih->buscoretype == PCMCIA_CORE_ID)
-		    && (bus->sih->buscorerev >= 10))
+		if ((bus->ci->buscoretype == PCMCIA_CORE_ID)
+		    && (bus->ci->buscorerev >= 10))
 			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL, 0,
 					 NULL);
 
@@ -2920,14 +2920,11 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 
 	/* If F2 successfully enabled, set core and enable interrupts */
 	if (ready == enable) {
-		/* Make sure we're talking to the core. */
-		bus->regs = si_setcore(bus->sih, PCMCIA_CORE_ID, 0);
-		if (!(bus->regs))
-			bus->regs = si_setcore(bus->sih, SDIOD_CORE_ID, 0);
-
 		/* Set up the interrupt mask and enable interrupts */
 		bus->hostintmask = HOSTINTMASK;
-		W_SDREG(bus->hostintmask, &bus->regs->hostintmask, retries);
+		W_SDREG(bus->hostintmask,
+			(unsigned int *)CORE_BUS_REG(bus->ci->buscorebase,
+			hostintmask), retries);
 
 		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_WATERMARK,
 				 (u8) watermark, &err);
@@ -5187,7 +5184,10 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 
 #endif				/* DHD_DEBUG */
 
-	/* Force PLL off until si_attach() programs PLL control regs */
+	/*
+	 * Force PLL off until dhdsdio_chip_attach()
+	 * programs PLL control regs
+	 */
 
 	bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			 DHD_INIT_CLKCTL1, &err);
@@ -5253,23 +5253,16 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 	}
 #endif				/* DHD_DEBUG */
 
-	/* si_attach() will provide an SI handle and scan the backplane */
-	bus->sih = si_attach((uint) devid, regsva, DHD_BUS, sdh,
-				   &bus->vars, &bus->varsz);
-	if (!(bus->sih)) {
-		DHD_ERROR(("%s: si_attach failed!\n", __func__));
-		goto fail;
-	}
 	if (dhdsdio_chip_attach(bus, regsva)) {
 		DHD_ERROR(("%s: dhdsdio_chip_attach failed!\n", __func__));
 		goto fail;
 	}
 
-	bcmsdh_chipinfo(sdh, bus->sih->chip, bus->sih->chiprev);
+	bcmsdh_chipinfo(sdh, bus->ci->chip, bus->ci->chiprev);
 
-	if (!dhdsdio_chipmatch((u16) bus->sih->chip)) {
+	if (!dhdsdio_chipmatch((u16) bus->ci->chip)) {
 		DHD_ERROR(("%s: unsupported chip: 0x%04x\n",
-			   __func__, bus->sih->chip));
+			   __func__, bus->ci->chip));
 		goto fail;
 	}
 
@@ -5277,14 +5270,9 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 
 	/* Get info on the ARM and SOCRAM cores... */
 	if (!DHD_NOPMU(bus)) {
-		if ((si_setcore(bus->sih, ARM7S_CORE_ID, 0)) ||
-		    (si_setcore(bus->sih, ARMCM3_CORE_ID, 0))) {
-			bus->armrev = si_corerev(bus->sih);
-		} else {
-			DHD_ERROR(("%s: failed to find ARM core!\n", __func__));
-			goto fail;
-		}
-		bus->orig_ramsize = si_socram_size(bus->sih);
+		bus->armrev = SBCOREREV(bcmsdh_reg_read(bus->sdh,
+			CORE_SB(bus->ci->armcorebase, sbidhigh), 4));
+		bus->orig_ramsize = bus->ci->ramsize;
 		if (!(bus->orig_ramsize)) {
 			DHD_ERROR(("%s: failed to find SOCRAM memory!\n",
 				   __func__));
@@ -5298,17 +5286,7 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 			   bus->ramsize, bus->orig_ramsize));
 	}
 
-	/* ...but normally deal with the SDPCMDEV core */
-	bus->regs = si_setcore(bus->sih, PCMCIA_CORE_ID, 0);
-	if (!bus->regs) {
-		bus->regs = si_setcore(bus->sih, SDIOD_CORE_ID, 0);
-		if (!bus->regs) {
-			DHD_ERROR(("%s: failed to find SDIODEV core!\n",
-					__func__));
-			goto fail;
-		}
-	}
-	bus->sdpcmrev = si_corerev(bus->sih);
+	bus->regs = (void *)bus->ci->buscorebase;
 
 	/* Set core control so an SDIO reset does a backplane reset */
 	OR_REG(&bus->regs->corecontrol, CC_BPRESEN);
@@ -5522,13 +5500,9 @@ static void dhdsdio_release_dongle(dhd_bus_t *bus)
 	if (bus->dhd && bus->dhd->dongle_reset)
 		return;
 
-	if (bus->sih) {
+	if (bus->ci) {
 		dhdsdio_clkctl(bus, CLK_AVAIL, false);
-#if !defined(BCMLXSDMMC)
-		si_watchdog(bus->sih, 4);
-#endif				/* !defined(BCMLXSDMMC) */
 		dhdsdio_clkctl(bus, CLK_NONE, false);
-		si_detach(bus->sih);
 		dhdsdio_chip_detach(bus);
 		if (bus->vars && bus->varsz)
 			kfree(bus->vars);
@@ -5955,8 +5929,8 @@ dhd_bcmsdh_send_buf(dhd_bus_t *bus, u32 addr, uint fn, uint flags,
 
 uint dhd_bus_chip(struct dhd_bus *bus)
 {
-	ASSERT(bus->sih != NULL);
-	return bus->sih->chip;
+	ASSERT(bus->ci != NULL);
+	return bus->ci->chip;
 }
 
 void *dhd_bus_pub(struct dhd_bus *bus)
@@ -6071,6 +6045,7 @@ dhdsdio_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci, void *regs)
 		ci->buscorebase = BCM4329_CORE_BUS_BASE;
 		ci->ramcorebase = BCM4329_CORE_SOCRAM_BASE;
 		ci->armcorebase	= BCM4329_CORE_ARM_BASE;
+		ci->ramsize = BCM4329_RAMSIZE;
 		break;
 	default:
 		DHD_ERROR(("%s: chipid 0x%x is not supported\n",
-- 
1.7.1


