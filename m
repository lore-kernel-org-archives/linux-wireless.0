Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1395 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758368Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/11] brcmfmac: replace brcmf_sdcard_reg_read with
 brcmf_sdio_regrl
Date: Fri, 4 May 2012 18:27:34 -0700
Message-ID: <1336181258-7305-8-git-send-email-frankyl@broadcom.com> (sfid-20120505_032842_282371_A2318641)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the newly introduced brcmf_sdio_regrl to replace
brcmf_sdcard_reg_read as part of the SDIO WiFi dongle register
access interface clean up.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   32 -----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   21 ++-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  150 +++++++++++---------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    3 -
 4 files changed, 95 insertions(+), 111 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index f6bb148..54a935b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -298,38 +298,6 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
-u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr)
-{
-	int status;
-	u32 word = 0;
-	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
-
-	brcmf_dbg(INFO, "fun = 1, addr = 0x%x\n", addr);
-
-	if (bar0 != sdiodev->sbwad) {
-		if (brcmf_sdcard_set_sbaddr_window(sdiodev, bar0))
-			return 0xFFFFFFFF;
-
-		sdiodev->sbwad = bar0;
-	}
-
-	addr &= SBSDIO_SB_OFT_ADDR_MASK;
-	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
-
-	status = brcmf_sdioh_request_word(sdiodev, SDIOH_READ, SDIO_FUNC_1,
-					  addr, &word, 4);
-
-	sdiodev->regfail = (status != 0);
-
-	if (status == 0) {
-		brcmf_dbg(INFO, "data = 0x%x\n", word);
-		return word;
-	} else {
-		brcmf_dbg(ERROR, "failed %d at addr 0x%04x\n", status, addr);
-		return 0xFFFFFFFF;
-	}
-}
-
 u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data)
 {
 	int status;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 1e35a3d..1e96ebf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -630,19 +630,20 @@ static bool data_ok(struct brcmf_sdio *bus)
  * adresses on the 32 bit backplane bus.
  */
 static void
-r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
+r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset, u32 *retryvar)
 {
 	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
+	int ret;
 	*retryvar = 0;
 	do {
-		*regvar = brcmf_sdcard_reg_read(bus->sdiodev,
-				bus->ci->c_inf[idx].base + reg_offset);
-	} while (brcmf_sdcard_regfail(bus->sdiodev) &&
-		 (++(*retryvar) <= retry_limit));
+		*regvar = brcmf_sdio_regrl(bus->sdiodev,
+					   bus->ci->c_inf[idx].base + offset,
+					   &ret);
+	} while ((ret != 0) && (++(*retryvar) <= retry_limit));
 	if (*retryvar) {
 		bus->regfails += (*retryvar-1);
 		if (*retryvar > retry_limit) {
-			brcmf_dbg(ERROR, "FAILED READ %Xh\n", reg_offset);
+			brcmf_dbg(ERROR, "FAILED READ %Xh\n", offset);
 			*regvar = 0;
 		}
 	}
@@ -3705,12 +3706,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 
 	bus->alp_only = true;
 
-	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev, SI_ENUM_BASE))
-		brcmf_dbg(ERROR, "FAILED to return to SI_ENUM_BASE\n");
-
 	pr_debug("F1 signature read @0x18000000=0x%4x\n",
-		 brcmf_sdcard_reg_read(bus->sdiodev, SI_ENUM_BASE));
+		 brcmf_sdio_regrl(bus->sdiodev, SI_ENUM_BASE, NULL));
 
 	/*
 	 * Force PLL off until brcmf_sdio_chip_attach()
@@ -3753,7 +3750,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	reg_addr = bus->ci->c_inf[idx].base +
 		   offsetof(struct sdpcmd_regs, corecontrol);
-	reg_val = brcmf_sdcard_reg_read(bus->sdiodev, reg_addr);
+	reg_val = brcmf_sdio_regrl(bus->sdiodev, reg_addr, NULL);
 	brcmf_sdcard_reg_write(bus->sdiodev, reg_addr, reg_val | CC_BPRESEN);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index d4b390c..c2ec99c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -93,8 +93,9 @@ brcmf_sdio_sb_corerev(struct brcmf_sdio_dev *sdiodev,
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbidhigh));
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   CORE_SB(ci->c_inf[idx].base, sbidhigh),
+				   NULL);
 	return SBCOREREV(regdata);
 }
 
@@ -118,8 +119,9 @@ brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+				   NULL);
 	regdata &= (SSB_TMSLOW_RESET | SSB_TMSLOW_REJECT |
 		    SSB_IMSTATE_REJECT | SSB_TMSLOW_CLOCK);
 	return (SSB_TMSLOW_CLOCK == regdata);
@@ -135,12 +137,13 @@ brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
+	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+				   NULL);
 	ret = (regdata & (BCMA_IOCTL_FGC | BCMA_IOCTL_CLK)) == BCMA_IOCTL_CLK;
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_RESET_CTL);
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+				   NULL);
 	ret = ret && ((regdata & BCMA_RESET_CTL_RESET) == 0);
 
 	return ret;
@@ -150,55 +153,59 @@ static void
 brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 			  struct chip_info *ci, u16 coreid)
 {
-	u32 regdata;
+	u32 regdata, base;
 	u8 idx;
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+	base = ci->c_inf[idx].base;
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
+	regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow), NULL);
 	if (regdata & SSB_TMSLOW_RESET)
 		return;
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
+	regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow), NULL);
 	if ((regdata & SSB_TMSLOW_CLOCK) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
 		 */
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
+		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow),
+					   NULL);
 		brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 				regdata | SSB_TMSLOW_REJECT);
 
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
+		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow),
+					   NULL);
 		udelay(1);
-		SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh)) &
+		SPINWAIT((brcmf_sdio_regrl(sdiodev,
+					   CORE_SB(base, sbtmstatehigh),
+					   NULL) &
 			SSB_TMSHIGH_BUSY), 100000);
 
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh));
+		regdata = brcmf_sdio_regrl(sdiodev,
+					   CORE_SB(base, sbtmstatehigh),
+					   NULL);
 		if (regdata & SSB_TMSHIGH_BUSY)
 			brcmf_dbg(ERROR, "core state still busy\n");
 
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbidlow));
+		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbidlow),
+					   NULL);
 		if (regdata & SSB_IDLOW_INITIATOR) {
-			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate)) |
-				SSB_IMSTATE_REJECT;
+			regdata = brcmf_sdio_regrl(sdiodev,
+						   CORE_SB(base, sbimstate),
+						   NULL);
+			regdata |= SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbimstate),
 				regdata);
-			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate));
+			regdata = brcmf_sdio_regrl(sdiodev,
+						   CORE_SB(base, sbimstate),
+						   NULL);
 			udelay(1);
-			SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate)) &
+			SPINWAIT((brcmf_sdio_regrl(sdiodev,
+						   CORE_SB(base, sbimstate),
+						   NULL) &
 				SSB_IMSTATE_BUSY), 100000);
 		}
 
@@ -207,17 +214,18 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 			CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 			(SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 			SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
+		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow),
+					   NULL);
 		udelay(10);
 
 		/* clear the initiator reject bit */
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbidlow));
+		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbidlow),
+					   NULL);
 		if (regdata & SSB_IDLOW_INITIATOR) {
-			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate)) &
-				~SSB_IMSTATE_REJECT;
+			regdata = brcmf_sdio_regrl(sdiodev,
+						   CORE_SB(base, sbimstate),
+						   NULL);
+			regdata &= ~SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbimstate),
 				regdata);
@@ -241,14 +249,15 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	/* if core is already in reset, just return */
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_RESET_CTL);
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+				   NULL);
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
 		return;
 
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL, 0);
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
+	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+				   NULL);
 	udelay(10);
 
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
@@ -279,19 +288,22 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdcard_reg_write(sdiodev,
 			CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 			SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET);
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+				   NULL);
 	udelay(1);
 
 	/* clear any serror */
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatehigh));
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   CORE_SB(ci->c_inf[idx].base, sbtmstatehigh),
+				   NULL);
 	if (regdata & SSB_TMSHIGH_SERR)
 		brcmf_sdcard_reg_write(sdiodev,
 			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 0);
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate));
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   CORE_SB(ci->c_inf[idx].base, sbimstate),
+				   NULL);
 	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO))
 		brcmf_sdcard_reg_write(sdiodev,
 			CORE_SB(ci->c_inf[idx].base, sbimstate),
@@ -301,16 +313,18 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdcard_reg_write(sdiodev,
 		CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 		SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+				   NULL);
 	udelay(1);
 
 	/* leave clock enabled */
 	brcmf_sdcard_reg_write(sdiodev,
 			       CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 			       SSB_TMSLOW_CLOCK);
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+				   NULL);
 	udelay(1);
 }
 
@@ -329,16 +343,16 @@ brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
 	/* now do initialization sequence */
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 			       BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
+	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+				   NULL);
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
 			       0);
 	udelay(1);
 
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 			       BCMA_IOCTL_CLK);
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
+	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+				   NULL);
 	udelay(1);
 }
 
@@ -355,8 +369,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	 */
 	ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
 	ci->c_inf[0].base = regs;
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_CC_REG(ci->c_inf[0].base, chipid));
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   CORE_CC_REG(ci->c_inf[0].base, chipid),
+				   NULL);
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 	ci->socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
@@ -466,18 +481,22 @@ static void
 brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 			     struct chip_info *ci)
 {
+	u32 base = ci->c_inf[0].base;
+
 	/* get chipcommon rev */
 	ci->c_inf[0].rev = ci->corerev(sdiodev, ci, ci->c_inf[0].id);
 
 	/* get chipcommon capabilites */
-	ci->c_inf[0].caps =
-		brcmf_sdcard_reg_read(sdiodev,
-		CORE_CC_REG(ci->c_inf[0].base, capabilities));
+	ci->c_inf[0].caps = brcmf_sdio_regrl(sdiodev,
+					     CORE_CC_REG(base, capabilities),
+					     NULL);
 
 	/* get pmu caps & rev */
 	if (ci->c_inf[0].caps & CC_CAP_PMU) {
-		ci->pmucaps = brcmf_sdcard_reg_read(sdiodev,
-			CORE_CC_REG(ci->c_inf[0].base, pmucapabilities));
+		ci->pmucaps =
+			brcmf_sdio_regrl(sdiodev,
+					 CORE_CC_REG(base, pmucapabilities),
+					 NULL);
 		ci->pmurev = ci->pmucaps & PCAP_REV_MASK;
 	}
 
@@ -556,6 +575,7 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 	u32 str_mask = 0;
 	u32 str_shift = 0;
 	char chn[8];
+	u32 base = ci->c_inf[0].base;
 
 	if (!(ci->c_inf[0].caps & CC_CAP_PMU))
 		return;
@@ -588,8 +608,10 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		brcmf_sdcard_reg_write(sdiodev,
 			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr),
 			1);
-		cc_data_temp = brcmf_sdcard_reg_read(sdiodev,
-			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr));
+		cc_data_temp =
+			brcmf_sdio_regrl(sdiodev,
+					 CORE_CC_REG(base, chipcontrol_addr),
+					 NULL);
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 7a97cb5..82d9dd1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -174,9 +174,6 @@ extern int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev);
  *   data: data for register write
  */
 extern u32
-brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr);
-
-extern u32
 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data);
 
 /* sdio device register access interface */
-- 
1.7.9.5


