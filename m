Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1334 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/11] brcmfmac: remove unused parameter of
 brcmf_sdcard_reg_read
Date: Fri, 4 May 2012 18:27:28 -0700
Message-ID: <1336181258-7305-2-git-send-email-frankyl@broadcom.com> (sfid-20120505_032839_780288_474B495D)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The size parameter for brcmf_sdcard_reg_read is always 4. Remove it
to make the code neat.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   30 +++-------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    7 +--
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   62 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 4 files changed, 42 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 4add7da..9966cf2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -222,7 +222,7 @@ brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 	return err;
 }
 
-u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size)
+u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr)
 {
 	int status;
 	u32 word = 0;
@@ -238,34 +238,20 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size)
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
-	if (size == 4)
-		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	status = brcmf_sdioh_request_word(sdiodev, SDIOH_READ, SDIO_FUNC_1,
-					  addr, &word, size);
+					  addr, &word, 4);
 
 	sdiodev->regfail = (status != 0);
 
-	brcmf_dbg(INFO, "u32data = 0x%x\n", word);
-
-	/* if ok, return appropriately masked word */
 	if (status == 0) {
-		switch (size) {
-		case sizeof(u8):
-			return word & 0xff;
-		case sizeof(u16):
-			return word & 0xffff;
-		case sizeof(u32):
-			return word;
-		default:
-			sdiodev->regfail = true;
-
-		}
+		brcmf_dbg(INFO, "data = 0x%x\n", word);
+		return word;
+	} else {
+		brcmf_dbg(ERROR, "failed %d at addr 0x%04x\n", status, addr);
+		return 0xFFFFFFFF;
 	}
-
-	/* otherwise, bad sdio access or invalid size */
-	brcmf_dbg(ERROR, "error reading addr 0x%04x size %d\n", addr, size);
-	return 0xFFFFFFFF;
 }
 
 u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 149ee67..0d1f3b8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -636,8 +636,7 @@ r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 	*retryvar = 0;
 	do {
 		*regvar = brcmf_sdcard_reg_read(bus->sdiodev,
-				bus->ci->c_inf[idx].base + reg_offset,
-				sizeof(u32));
+				bus->ci->c_inf[idx].base + reg_offset);
 	} while (brcmf_sdcard_regfail(bus->sdiodev) &&
 		 (++(*retryvar) <= retry_limit));
 	if (*retryvar) {
@@ -3737,7 +3736,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 		brcmf_dbg(ERROR, "FAILED to return to SI_ENUM_BASE\n");
 
 	pr_debug("F1 signature read @0x18000000=0x%4x\n",
-		 brcmf_sdcard_reg_read(bus->sdiodev, SI_ENUM_BASE, 4));
+		 brcmf_sdcard_reg_read(bus->sdiodev, SI_ENUM_BASE));
 
 	/*
 	 * Force PLL off until brcmf_sdio_chip_attach()
@@ -3782,7 +3781,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	reg_addr = bus->ci->c_inf[idx].base +
 		   offsetof(struct sdpcmd_regs, corecontrol);
-	reg_val = brcmf_sdcard_reg_read(bus->sdiodev, reg_addr, sizeof(u32));
+	reg_val = brcmf_sdcard_reg_read(bus->sdiodev, reg_addr);
 	brcmf_sdcard_reg_write(bus->sdiodev, reg_addr, sizeof(u32),
 			       reg_val | CC_BPRESEN);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 1534efc..b5688a7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -94,7 +94,7 @@ brcmf_sdio_sb_corerev(struct brcmf_sdio_dev *sdiodev,
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbidhigh), 4);
+			CORE_SB(ci->c_inf[idx].base, sbidhigh));
 	return SBCOREREV(regdata);
 }
 
@@ -119,7 +119,7 @@ brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 	regdata &= (SSB_TMSLOW_RESET | SSB_TMSLOW_REJECT |
 		    SSB_IMSTATE_REJECT | SSB_TMSLOW_CLOCK);
 	return (SSB_TMSLOW_CLOCK == regdata);
@@ -136,12 +136,11 @@ brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_IOCTL, 4);
+					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
 	ret = (regdata & (BCMA_IOCTL_FGC | BCMA_IOCTL_CLK)) == BCMA_IOCTL_CLK;
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-					4);
+					ci->c_inf[idx].wrapbase+BCMA_RESET_CTL);
 	ret = ret && ((regdata & BCMA_RESET_CTL_RESET) == 0);
 
 	return ret;
@@ -157,49 +156,49 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 	if (regdata & SSB_TMSLOW_RESET)
 		return;
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 	if ((regdata & SSB_TMSLOW_CLOCK) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
 		 */
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 		brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 				4, regdata | SSB_TMSLOW_REJECT);
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 		udelay(1);
 		SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4) &
+			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh)) &
 			SSB_TMSHIGH_BUSY), 100000);
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh));
 		if (regdata & SSB_TMSHIGH_BUSY)
 			brcmf_dbg(ERROR, "core state still busy\n");
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbidlow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbidlow));
 		if (regdata & SSB_IDLOW_INITIATOR) {
 			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate), 4) |
+				CORE_SB(ci->c_inf[idx].base, sbimstate)) |
 				SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbimstate), 4,
 				regdata);
 			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate), 4);
+				CORE_SB(ci->c_inf[idx].base, sbimstate));
 			udelay(1);
 			SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate), 4) &
+				CORE_SB(ci->c_inf[idx].base, sbimstate)) &
 				SSB_IMSTATE_BUSY), 100000);
 		}
 
@@ -209,15 +208,15 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 			(SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 			SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 		udelay(10);
 
 		/* clear the initiator reject bit */
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbidlow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbidlow));
 		if (regdata & SSB_IDLOW_INITIATOR) {
 			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate), 4) &
+				CORE_SB(ci->c_inf[idx].base, sbimstate)) &
 				~SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbimstate), 4,
@@ -243,15 +242,14 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 
 	/* if core is already in reset, just return */
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-					4);
+					ci->c_inf[idx].wrapbase+BCMA_RESET_CTL);
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
 		return;
 
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 			       4, 0);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_IOCTL, 4);
+					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
 	udelay(10);
 
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
@@ -283,18 +281,18 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
 			SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 	udelay(1);
 
 	/* clear any serror */
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4);
+				CORE_SB(ci->c_inf[idx].base, sbtmstatehigh));
 	if (regdata & SSB_TMSHIGH_SERR)
 		brcmf_sdcard_reg_write(sdiodev,
 			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4, 0);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate), 4);
+				CORE_SB(ci->c_inf[idx].base, sbimstate));
 	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO))
 		brcmf_sdcard_reg_write(sdiodev,
 			CORE_SB(ci->c_inf[idx].base, sbimstate), 4,
@@ -305,7 +303,7 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
 		SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 	udelay(1);
 
 	/* leave clock enabled */
@@ -313,7 +311,7 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 			       CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 			       4, SSB_TMSLOW_CLOCK);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 	udelay(1);
 }
 
@@ -333,7 +331,7 @@ brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 			       4, BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_IOCTL, 4);
+					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
 			       4, 0);
 	udelay(1);
@@ -341,7 +339,7 @@ brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 			       4, BCMA_IOCTL_CLK);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-					ci->c_inf[idx].wrapbase+BCMA_IOCTL, 4);
+					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
 	udelay(1);
 }
 
@@ -359,7 +357,7 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
 	ci->c_inf[0].base = regs;
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_CC_REG(ci->c_inf[0].base, chipid), 4);
+			CORE_CC_REG(ci->c_inf[0].base, chipid));
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 	ci->socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
@@ -478,12 +476,12 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 	/* get chipcommon capabilites */
 	ci->c_inf[0].caps =
 		brcmf_sdcard_reg_read(sdiodev,
-		CORE_CC_REG(ci->c_inf[0].base, capabilities), 4);
+		CORE_CC_REG(ci->c_inf[0].base, capabilities));
 
 	/* get pmu caps & rev */
 	if (ci->c_inf[0].caps & CC_CAP_PMU) {
 		ci->pmucaps = brcmf_sdcard_reg_read(sdiodev,
-			CORE_CC_REG(ci->c_inf[0].base, pmucapabilities), 4);
+			CORE_CC_REG(ci->c_inf[0].base, pmucapabilities));
 		ci->pmurev = ci->pmucaps & PCAP_REV_MASK;
 	}
 
@@ -595,7 +593,7 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr),
 			4, 1);
 		cc_data_temp = brcmf_sdcard_reg_read(sdiodev,
-			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr), 4);
+			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr));
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 7010eaf..a5670c4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -181,7 +181,7 @@ extern void brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint func,
  *   data: data for register write
  */
 extern u32
-brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size);
+brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr);
 
 extern u32
 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
-- 
1.7.9.5


