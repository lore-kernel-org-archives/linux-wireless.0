Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3687 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab1KDVYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:06 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/16] brcm80211: fmac: optimize chip core info
 management
Date: Fri, 4 Nov 2011 22:23:42 +0100
Message-ID: <1320441822-4615-17-git-send-email-arend@broadcom.com> (sfid-20111104_222432_766196_97658786)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Prepare for adding backplane interconnect type support

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   35 +++++++----
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   65 +++++++++++++-------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |   23 +++++---
 3 files changed, 81 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index d45fa32..43b4496 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -28,6 +28,7 @@
 #include <linux/semaphore.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
+#include <linux/bcma/bcma.h>
 #include <asm/unaligned.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
@@ -614,10 +615,12 @@ static bool data_ok(struct brcmf_bus *bus)
 static void
 r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 {
+	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	*retryvar = 0;
 	do {
 		*regvar = brcmf_sdcard_reg_read(bus->sdiodev,
-				bus->ci->buscorebase + reg_offset, sizeof(u32));
+				bus->ci->c_inf[idx].base + reg_offset,
+				sizeof(u32));
 	} while (brcmf_sdcard_regfail(bus->sdiodev) &&
 		 (++(*retryvar) <= retry_limit));
 	if (*retryvar) {
@@ -632,10 +635,11 @@ r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 static void
 w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 {
+	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	*retryvar = 0;
 	do {
 		brcmf_sdcard_reg_write(bus->sdiodev,
-				       bus->ci->buscorebase + reg_offset,
+				       bus->ci->c_inf[idx].base + reg_offset,
 				       sizeof(u32), regval);
 	} while (brcmf_sdcard_regfail(bus->sdiodev) &&
 		 (++(*retryvar) <= retry_limit));
@@ -683,8 +687,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 			return -EBADE;
 		}
 
-		if (pendok && ((bus->ci->buscoretype == PCMCIA_CORE_ID)
-			       && (bus->ci->buscorerev == 9))) {
+		if (pendok && ((bus->ci->c_inf[1].id == PCMCIA_CORE_ID)
+			       && (bus->ci->c_inf[1].rev == 9))) {
 			u32 dummy, retries;
 			r_sdreg32(bus, &dummy,
 				  offsetof(struct sdpcmd_regs, clockctlstatus),
@@ -909,8 +913,8 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 
 		/* Force pad isolation off if possible
 			 (in case power never toggled) */
-		if ((bus->ci->buscoretype == PCMCIA_CORE_ID)
-		    && (bus->ci->buscorerev >= 10))
+		if ((bus->ci->c_inf[1].id == PCMCIA_CORE_ID)
+		    && (bus->ci->c_inf[1].rev >= 10))
 			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, 0, NULL);
 
@@ -3094,6 +3098,8 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 {
 	uint retries;
 	int bcmerror = 0;
+	u8 idx;
+	struct chip_info *ci = bus->ci;
 
 	/* To enter download state, disable ARM and reset SOCRAM.
 	 * To exit download state, simply reset ARM (default is RAM boot).
@@ -3101,10 +3107,11 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 	if (enter) {
 		bus->alp_only = true;
 
-		brcmf_sdio_chip_coredisable(bus->sdiodev,
-					      bus->ci->armcorebase);
+		idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
+		brcmf_sdio_chip_coredisable(bus->sdiodev, ci->c_inf[idx].base);
 
-		brcmf_sdio_chip_resetcore(bus->sdiodev, bus->ci->ramcorebase);
+		idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_INTERNAL_MEM);
+		brcmf_sdio_chip_resetcore(bus->sdiodev, ci->c_inf[idx].base);
 
 		/* Clear the top bit of memory */
 		if (bus->ramsize) {
@@ -3113,8 +3120,9 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 					 (u8 *)&zeros, 4);
 		}
 	} else {
+		idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_INTERNAL_MEM);
 		if (!brcmf_sdio_chip_iscoreup(bus->sdiodev,
-					      bus->ci->ramcorebase)) {
+					      ci->c_inf[idx].base)) {
 			brcmf_dbg(ERROR, "SOCRAM core is down after reset?\n");
 			bcmerror = -EBADE;
 			goto fail;
@@ -3129,7 +3137,8 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 		w_sdreg32(bus, 0xFFFFFFFF,
 			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 
-		brcmf_sdio_chip_resetcore(bus->sdiodev, bus->ci->armcorebase);
+		idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
+		brcmf_sdio_chip_resetcore(bus->sdiodev, ci->c_inf[idx].base);
 
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
@@ -3711,6 +3720,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 	int err = 0;
 	int reg_addr;
 	u32 reg_val;
+	u8 idx;
 
 	bus->alp_only = true;
 
@@ -3764,7 +3774,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 	}
 
 	/* Set core control so an SDIO reset does a backplane reset */
-	reg_addr = bus->ci->buscorebase +
+	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
+	reg_addr = bus->ci->c_inf[idx].base +
 		   offsetof(struct sdpcmd_regs, corecontrol);
 	reg_val = brcmf_sdcard_reg_read(bus->sdiodev, reg_addr, sizeof(u32));
 	brcmf_sdcard_reg_write(bus->sdiodev, reg_addr, sizeof(u32),
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 62c4621..99d00dd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -19,6 +19,7 @@
 #include <linux/netdevice.h>
 #include <linux/mmc/card.h>
 #include <linux/ssb/ssb_regs.h>
+#include <linux/bcma/bcma.h>
 
 #include <chipcommon.h>
 #include <brcm_hw_ids.h>
@@ -82,6 +83,18 @@ static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
 	0, 0x0}
 	};
 
+u8
+brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid)
+{
+	u8 idx;
+
+	for (idx = 0; idx < BRCMF_MAX_CORENUM; idx++)
+		if (coreid == ci->c_inf[idx].id)
+			return idx;
+
+	return BRCMF_MAX_CORENUM;
+}
+
 static u32
 brcmf_sdio_chip_corerev(struct brcmf_sdio_dev *sdiodev,
 			u32 corebase)
@@ -239,9 +252,10 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	 * For different chiptypes or old sdio hosts w/o chipcommon,
 	 * other ways of recognition should be added here.
 	 */
-	ci->cccorebase = regs;
+	ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
+	ci->c_inf[0].base = regs;
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_CC_REG(ci->cccorebase, chipid), 4);
+			CORE_CC_REG(ci->c_inf[0].base, chipid), 4);
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 
@@ -250,9 +264,12 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	/* Address of cores for new chips should be added here */
 	switch (ci->chip) {
 	case BCM4329_CHIP_ID:
-		ci->buscorebase = BCM4329_CORE_BUS_BASE;
-		ci->ramcorebase = BCM4329_CORE_SOCRAM_BASE;
-		ci->armcorebase	= BCM4329_CORE_ARM_BASE;
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = BCM4329_CORE_BUS_BASE;
+		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+		ci->c_inf[2].base = BCM4329_CORE_SOCRAM_BASE;
+		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+		ci->c_inf[3].base = BCM4329_CORE_ARM_BASE;
 		ci->ramsize = BCM4329_RAMSIZE;
 		break;
 	default:
@@ -316,35 +333,39 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 			     struct chip_info *ci)
 {
 	u32 regdata;
+	u8 idx;
 
 	/* get chipcommon rev */
-	ci->ccrev = brcmf_sdio_chip_corerev(sdiodev, ci->cccorebase);
+	ci->c_inf[0].rev =
+		brcmf_sdio_chip_corerev(sdiodev, ci->c_inf[0].base);
 
 	/* get chipcommon capabilites */
-	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
-		CORE_CC_REG(ci->cccorebase, capabilities), 4);
+	ci->c_inf[0].caps =
+		brcmf_sdcard_reg_read(sdiodev,
+		CORE_CC_REG(ci->c_inf[0].base, capabilities), 4);
 
 	/* get pmu caps & rev */
-	if (ci->cccaps & CC_CAP_PMU) {
+	if (ci->c_inf[0].caps & CC_CAP_PMU) {
 		ci->pmucaps = brcmf_sdcard_reg_read(sdiodev,
-			CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
+			CORE_CC_REG(ci->c_inf[0].base, pmucapabilities), 4);
 		ci->pmurev = ci->pmucaps & PCAP_REV_MASK;
 	}
 
-
-	ci->buscorerev = brcmf_sdio_chip_corerev(sdiodev, ci->buscorebase);
+	ci->c_inf[1].rev = brcmf_sdio_chip_corerev(sdiodev, ci->c_inf[1].base);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(ci->buscorebase, sbidhigh), 4);
-	ci->buscoretype = (regdata & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
+				CORE_SB(ci->c_inf[1].base, sbidhigh), 4);
+	ci->c_inf[1].id = (regdata & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
 
 	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
-		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
+		  ci->c_inf[0].rev, ci->pmurev,
+		  ci->c_inf[1].rev, ci->c_inf[1].id);
 
 	/*
 	 * Make sure any on-chip ARM is off (in case strapping is wrong),
 	 * or downloaded code was already running.
 	 */
-	brcmf_sdio_chip_coredisable(sdiodev, ci->armcorebase);
+	idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
+	brcmf_sdio_chip_coredisable(sdiodev, ci->c_inf[idx].base);
 }
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
@@ -371,9 +392,9 @@ int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdio_chip_buscoresetup(sdiodev, ci);
 
 	brcmf_sdcard_reg_write(sdiodev,
-		CORE_CC_REG(ci->cccorebase, gpiopullup), 4, 0);
+		CORE_CC_REG(ci->c_inf[0].base, gpiopullup), 4, 0);
 	brcmf_sdcard_reg_write(sdiodev,
-		CORE_CC_REG(ci->cccorebase, gpiopulldown), 4, 0);
+		CORE_CC_REG(ci->c_inf[0].base, gpiopulldown), 4, 0);
 
 	*ci_ptr = ci;
 	return 0;
@@ -410,7 +431,7 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 	u32 str_shift = 0;
 	char chn[8];
 
-	if (!(ci->cccaps & CC_CAP_PMU))
+	if (!(ci->c_inf[0].caps & CC_CAP_PMU))
 		return;
 
 	switch (SDIOD_DRVSTR_KEY(ci->chip, ci->pmurev)) {
@@ -450,15 +471,15 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		}
 
 		brcmf_sdcard_reg_write(sdiodev,
-			CORE_CC_REG(ci->cccorebase, chipcontrol_addr),
+			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr),
 			4, 1);
 		cc_data_temp = brcmf_sdcard_reg_read(sdiodev,
-			CORE_CC_REG(ci->cccorebase, chipcontrol_addr), 4);
+			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr), 4);
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
 		brcmf_sdcard_reg_write(sdiodev,
-			CORE_CC_REG(ci->cccorebase, chipcontrol_addr),
+			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr),
 			4, cc_data_temp);
 
 		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 6383746..0ee37ae 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -52,17 +52,22 @@
 #define SBSDIO_CLKAV(regval, alponly) \
 	(SBSDIO_ALPAV(regval) && (alponly ? 1 : SBSDIO_HTAV(regval)))
 
+#define BRCMF_MAX_CORENUM	6
+
+struct chip_core_info {
+	u16 id;
+	u16 rev;
+	u32 base;
+	u32 wrapbase;
+	u32 caps;
+};
+
 struct chip_info {
 	u32 chip;
 	u32 chiprev;
-	u32 cccorebase;
-	u32 ccrev;
-	u32 cccaps;
-	u32 buscorebase; /* 32 bits backplane bus address */
-	u32 buscorerev;
-	u32 buscoretype;
-	u32 ramcorebase;
-	u32 armcorebase;
+	/* core info */
+	/* always put chipcommon core at 0, bus core at 1 */
+	struct chip_core_info c_inf[BRCMF_MAX_CORENUM];
 	u32 pmurev;
 	u32 pmucaps;
 	u32 ramsize;
@@ -120,5 +125,7 @@ extern void brcmf_sdio_chip_detach(struct chip_info **ci_ptr);
 extern void brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 					      struct chip_info *ci,
 					      u32 drivestrength);
+extern u8 brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid);
+
 
 #endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
-- 
1.7.4.1


