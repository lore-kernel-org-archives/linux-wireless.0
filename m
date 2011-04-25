Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4653 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174Ab1DYWpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 18:45:30 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	brudley@broadcom.com, henryp@broadcom.com, hharte@broadcom.com
Subject: [PATCH 2/7] staging: brcm80211: Add dhdsdio_chip_attach in
 dhd_sdio.c
Date: Mon, 25 Apr 2011 15:45:08 -0700
Message-ID: <1303771513-18851-3-git-send-email-frankyl@broadcom.com> (sfid-20110426_004539_739372_257B2ADF)
In-Reply-To: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
References: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dhdsdio_chip_attach and it sub functions are added for si/sb utils removal.
It will replace si_attach in following patches.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  253 +++++++++++++++++++++++++
 1 files changed, 253 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index aad9965..75be99d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -53,6 +53,7 @@
 #include <dhdioctl.h>
 #include <sdiovar.h>
 #include <siutils_priv.h>
+#include <bcmchip.h>
 
 #ifndef DHDSDIO_MEM_DUMP_FNAME
 #define DHDSDIO_MEM_DUMP_FNAME         "mem_dump"
@@ -166,12 +167,28 @@ typedef struct dhd_console {
 } dhd_console_t;
 #endif				/* DHD_DEBUG */
 
+/* misc chip info needed by some of the routines */
+struct chip_info {
+	u32 chip;
+	u32 chiprev;
+	u32 cccorebase;
+	u32 ccrev;
+	u32 cccaps;
+	u32 buscorebase;
+	u32 buscorerev;
+	u32 buscoretype;
+	u32 ramcorebase;
+	u32 armcorebase;
+	u32 pmurev;
+};
+
 /* Private data for SDIO bus interaction */
 typedef struct dhd_bus {
 	dhd_pub_t *dhd;
 
 	bcmsdh_info_t *sdh;	/* Handle for BCMSDH calls */
 	si_t *sih;		/* Handle for SI calls */
+	struct chip_info *ci;	/* Chip info struct */
 	char *vars;		/* Variables (from CIS and/or other) */
 	uint varsz;		/* Size of variables buffer */
 	u32 sbaddr;		/* Current SB window pointer (-1, invalid) */
@@ -465,6 +482,7 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus);
 #ifdef BCMEMBEDIMAGE
 static int dhdsdio_download_code_array(struct dhd_bus *bus);
 #endif
+static int dhdsdio_chip_attach(struct dhd_bus *bus, void *regs);
 
 static void dhd_dongle_setmemsize(struct dhd_bus *bus, int mem_size)
 {
@@ -5289,6 +5307,10 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 		DHD_ERROR(("%s: si_attach failed!\n", __func__));
 		goto fail;
 	}
+	if (dhdsdio_chip_attach(bus, regsva)) {
+		DHD_ERROR(("%s: dhdsdio_chip_attach failed!\n", __func__));
+		goto fail;
+	}
 
 	bcmsdh_chipinfo(sdh, bus->sih->chip, bus->sih->chiprev);
 
@@ -6071,3 +6093,234 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 	}
 	return bcmerror;
 }
+
+static int
+dhdsdio_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci, void *regs)
+{
+	u32 regdata;
+
+	/*
+	 * Get CC core rev
+	 * Chipid is assume to be at offset 0 from regs arg
+	 * For different chiptypes or old sdio hosts w/o chipcommon,
+	 * other ways of recognition should be added here.
+	 */
+	ci->cccorebase = (u32)regs;
+	regdata = bcmsdh_reg_read(sdh, CORE_CC_REG(ci->cccorebase, chipid), 4);
+	ci->chip = regdata & CID_ID_MASK;
+	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
+
+	DHD_INFO(("%s: chipid=0x%x chiprev=%d\n",
+		__func__, ci->chip, ci->chiprev));
+
+	/* Address of cores for new chips should be added here */
+	switch (ci->chip) {
+	case BCM4329_CHIP_ID:
+		ci->buscorebase = BCM4329_CORE_BUS_BASE;
+		ci->ramcorebase = BCM4329_CORE_SOCRAM_BASE;
+		ci->armcorebase	= BCM4329_CORE_ARM_BASE;
+		break;
+	default:
+		DHD_ERROR(("%s: chipid 0x%x is not supported\n",
+			__func__, ci->chip));
+		return -ENODEV;
+	}
+
+	regdata = bcmsdh_reg_read(sdh,
+		CORE_SB(ci->cccorebase, sbidhigh), 4);
+	ci->ccrev = SBCOREREV(regdata);
+
+	regdata = bcmsdh_reg_read(sdh,
+		CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
+	ci->pmurev = regdata & PCAP_REV_MASK;
+
+	regdata = bcmsdh_reg_read(sdh, CORE_SB(ci->buscorebase, sbidhigh), 4);
+	ci->buscorerev = SBCOREREV(regdata);
+	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
+
+	DHD_INFO(("%s: ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
+		__func__, ci->ccrev, ci->pmurev,
+		ci->buscorerev, ci->buscoretype));
+
+	/* get chipcommon capabilites */
+	ci->cccaps = bcmsdh_reg_read(sdh,
+		CORE_CC_REG(ci->cccorebase, capabilities), 4);
+
+	return 0;
+}
+
+static void
+dhdsdio_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase)
+{
+	u32 regdata;
+
+	regdata = bcmsdh_reg_read(sdh,
+		CORE_SB(corebase, sbtmstatelow), 4);
+	if (regdata & SBTML_RESET)
+		return;
+
+	regdata = bcmsdh_reg_read(sdh,
+		CORE_SB(corebase, sbtmstatelow), 4);
+	if ((regdata & (SICF_CLOCK_EN << SBTML_SICF_SHIFT)) != 0) {
+		/*
+		 * set target reject and spin until busy is clear
+		 * (preserve core-specific bits)
+		 */
+		regdata = bcmsdh_reg_read(sdh,
+			CORE_SB(corebase, sbtmstatelow), 4);
+		bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+			regdata | SBTML_REJ);
+
+		regdata = bcmsdh_reg_read(sdh,
+			CORE_SB(corebase, sbtmstatelow), 4);
+		udelay(1);
+		SPINWAIT((bcmsdh_reg_read(sdh,
+			CORE_SB(corebase, sbtmstatehigh), 4) &
+			SBTMH_BUSY), 100000);
+
+		regdata = bcmsdh_reg_read(sdh,
+			CORE_SB(corebase, sbtmstatehigh), 4);
+		if (regdata & SBTMH_BUSY)
+			DHD_ERROR(("%s: ARM core still busy\n", __func__));
+
+		regdata = bcmsdh_reg_read(sdh,
+			CORE_SB(corebase, sbidlow), 4);
+		if (regdata & SBIDL_INIT) {
+			regdata = bcmsdh_reg_read(sdh,
+				CORE_SB(corebase, sbimstate), 4) |
+				SBIM_RJ;
+			bcmsdh_reg_write(sdh,
+				CORE_SB(corebase, sbimstate), 4,
+				regdata);
+			regdata = bcmsdh_reg_read(sdh,
+				CORE_SB(corebase, sbimstate), 4);
+			udelay(1);
+			SPINWAIT((bcmsdh_reg_read(sdh,
+				CORE_SB(corebase, sbimstate), 4) &
+				SBIM_BY), 100000);
+		}
+
+		/* set reset and reject while enabling the clocks */
+		bcmsdh_reg_write(sdh,
+			CORE_SB(corebase, sbtmstatelow), 4,
+			(((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
+			SBTML_REJ | SBTML_RESET));
+		regdata = bcmsdh_reg_read(sdh,
+			CORE_SB(corebase, sbtmstatelow), 4);
+		udelay(10);
+
+		/* clear the initiator reject bit */
+		regdata = bcmsdh_reg_read(sdh,
+			CORE_SB(corebase, sbidlow), 4);
+		if (regdata & SBIDL_INIT) {
+			regdata = bcmsdh_reg_read(sdh,
+				CORE_SB(corebase, sbimstate), 4) &
+				~SBIM_RJ;
+			bcmsdh_reg_write(sdh,
+				CORE_SB(corebase, sbimstate), 4,
+				regdata);
+		}
+	}
+
+	/* leave reset and reject asserted */
+	bcmsdh_reg_write(sdh, CORE_SB(corebase, sbtmstatelow), 4,
+		(SBTML_REJ | SBTML_RESET));
+	udelay(1);
+}
+
+static int
+dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
+{
+	struct chip_info *ci;
+	int err;
+	u8 clkval, clkset;
+
+	DHD_TRACE(("%s: Enter\n", __func__));
+
+	/* alloc chip_info_t */
+	ci = kmalloc(sizeof(struct chip_info), GFP_ATOMIC);
+	if (NULL == ci) {
+		DHD_ERROR(("%s: malloc failed!\n", __func__));
+		return -ENOMEM;
+	}
+
+	memset((unsigned char *)ci, 0, sizeof(struct chip_info));
+
+	/* bus/core/clk setup for register access */
+	/* Try forcing SDIO core to do ALPAvail request only */
+	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
+	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
+			clkset, &err);
+	if (err) {
+		DHD_ERROR(("%s: error writing for HT off\n", __func__));
+		goto fail;
+	}
+
+	/* If register supported, wait for ALPAvail and then force ALP */
+	/* This may take up to 15 milliseconds */
+	clkval = bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_1,
+			SBSDIO_FUNC1_CHIPCLKCSR, NULL);
+	if ((clkval & ~SBSDIO_AVBITS) == clkset) {
+		SPINWAIT(((clkval =
+				bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_1,
+						SBSDIO_FUNC1_CHIPCLKCSR,
+						NULL)),
+				!SBSDIO_ALPAV(clkval)),
+				PMU_MAX_TRANSITION_DLY);
+		if (!SBSDIO_ALPAV(clkval)) {
+			DHD_ERROR(("%s: timeout on ALPAV wait, clkval 0x%02x\n",
+				__func__, clkval));
+			err = -EBUSY;
+			goto fail;
+		}
+		clkset = SBSDIO_FORCE_HW_CLKREQ_OFF |
+				SBSDIO_FORCE_ALP;
+		bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1,
+				SBSDIO_FUNC1_CHIPCLKCSR,
+				clkset, &err);
+		udelay(65);
+	} else {
+		DHD_ERROR(("%s: ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
+			__func__, clkset, clkval));
+		err = -EACCES;
+		goto fail;
+	}
+
+	/* Also, disable the extra SDIO pull-ups */
+	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_SDIOPULLUP, 0,
+			 NULL);
+
+	err = dhdsdio_chip_recognition(bus->sdh, ci, regs);
+	if (err)
+		goto fail;
+
+	/*
+	 * Make sure any on-chip ARM is off (in case strapping is wrong),
+	 * or downloaded code was already running.
+	 */
+	dhdsdio_chip_disablecore(bus->sdh, ci->armcorebase);
+
+	bcmsdh_reg_write(bus->sdh,
+		CORE_CC_REG(ci->cccorebase, gpiopullup), 4, 0);
+	bcmsdh_reg_write(bus->sdh,
+		CORE_CC_REG(ci->cccorebase, gpiopulldown), 4, 0);
+
+	/* Disable F2 to clear any intermediate frame state on the dongle */
+	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIOD_CCCR_IOEN,
+		SDIO_FUNC_ENABLE_1, NULL);
+
+	/* WAR: cmd52 backplane read so core HW will drop ALPReq */
+	clkval = bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_1,
+			0, NULL);
+
+	/* Done with backplane-dependent accesses, can drop clock... */
+	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR, 0,
+			 NULL);
+
+	bus->ci = ci;
+	return 0;
+fail:
+	bus->ci = NULL;
+	kfree(ci);
+	return err;
+}
-- 
1.7.1


