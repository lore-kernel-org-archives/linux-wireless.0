Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4630 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271Ab1KJTaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:55 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/19] brcm80211: fmac: add coredisable function for
 bcm4330 chip
Date: Thu, 10 Nov 2011 20:30:23 +0100
Message-ID: <1320953434-16859-10-git-send-email-arend@broadcom.com> (sfid-20111110_203112_669514_270FD495)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

This patch is part of the series of adding new backplane support

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   11 +--
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  109 ++++++++++++++------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    6 +-
 3 files changed, 82 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5b81336..0d0e283 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3098,7 +3098,6 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 {
 	uint retries;
 	int bcmerror = 0;
-	u8 idx;
 	struct chip_info *ci = bus->ci;
 
 	/* To enter download state, disable ARM and reset SOCRAM.
@@ -3107,11 +3106,10 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 	if (enter) {
 		bus->alp_only = true;
 
-		idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
-		brcmf_sdio_chip_coredisable(bus->sdiodev, ci->c_inf[idx].base);
+		ci->coredisable(bus->sdiodev, ci, BCMA_CORE_ARM_CM3);
 
-		idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_INTERNAL_MEM);
-		brcmf_sdio_chip_resetcore(bus->sdiodev, ci->c_inf[idx].base);
+		brcmf_sdio_chip_resetcore(bus->sdiodev, ci,
+					  BCMA_CORE_INTERNAL_MEM);
 
 		/* Clear the top bit of memory */
 		if (bus->ramsize) {
@@ -3135,8 +3133,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 		w_sdreg32(bus, 0xFFFFFFFF,
 			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 
-		idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
-		brcmf_sdio_chip_resetcore(bus->sdiodev, ci->c_inf[idx].base);
+		brcmf_sdio_chip_resetcore(bus->sdiodev, ci, BCMA_CORE_ARM_CM3);
 
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 85b665e..d2cf8c6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -166,124 +166,165 @@ brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
 	return ret;
 }
 
-void
-brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
+static void
+brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
+			  struct chip_info *ci, u16 coreid)
 {
 	u32 regdata;
+	u8 idx;
+
+	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(corebase, sbtmstatelow), 4);
+		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
 	if (regdata & SSB_TMSLOW_RESET)
 		return;
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(corebase, sbtmstatelow), 4);
+		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
 	if ((regdata & SSB_TMSLOW_CLOCK) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
 		 */
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
-		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow),
-				       4, regdata | SSB_TMSLOW_REJECT);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+		brcmf_sdcard_reg_write(sdiodev,
+				CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+				4, regdata | SSB_TMSLOW_REJECT);
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
 		udelay(1);
 		SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatehigh), 4) &
+			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4) &
 			SSB_TMSHIGH_BUSY), 100000);
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatehigh), 4);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4);
 		if (regdata & SSB_TMSHIGH_BUSY)
 			brcmf_dbg(ERROR, "core state still busy\n");
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbidlow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbidlow), 4);
 		if (regdata & SSB_IDLOW_INITIATOR) {
 			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4) |
+				CORE_SB(ci->c_inf[idx].base, sbimstate), 4) |
 				SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(corebase, sbimstate), 4,
+				CORE_SB(ci->c_inf[idx].base, sbimstate), 4,
 				regdata);
 			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4);
+				CORE_SB(ci->c_inf[idx].base, sbimstate), 4);
 			udelay(1);
 			SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4) &
+				CORE_SB(ci->c_inf[idx].base, sbimstate), 4) &
 				SSB_IMSTATE_BUSY), 100000);
 		}
 
 		/* set reset and reject while enabling the clocks */
 		brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4,
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
 			(SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 			SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
 		udelay(10);
 
 		/* clear the initiator reject bit */
 		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbidlow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbidlow), 4);
 		if (regdata & SSB_IDLOW_INITIATOR) {
 			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4) &
+				CORE_SB(ci->c_inf[idx].base, sbimstate), 4) &
 				~SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(corebase, sbimstate), 4,
+				CORE_SB(ci->c_inf[idx].base, sbimstate), 4,
 				regdata);
 		}
 	}
 
 	/* leave reset and reject asserted */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdiodev,
+		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
 		(SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
 	udelay(1);
 }
 
+static void
+brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
+			  struct chip_info *ci, u16 coreid)
+{
+	u8 idx;
+	u32 regdata;
+
+	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+
+	/* if core is already in reset, just return */
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+					4);
+	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
+		return;
+
+	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+			       4, 0);
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					ci->c_inf[idx].wrapbase+BCMA_IOCTL, 4);
+	udelay(10);
+
+	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+			       4, BCMA_RESET_CTL_RESET);
+	udelay(1);
+}
+
 void
-brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
+brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev,
+			  struct chip_info *ci, u16 coreid)
 {
 	u32 regdata;
+	u8 idx;
+
+	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	/*
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	brcmf_sdio_chip_coredisable(sdiodev, corebase);
+	ci->coredisable(sdiodev, ci, coreid);
 
 	/*
 	 * Now do the initialization sequence.
 	 * set reset while enabling the clock and
 	 * forcing them on throughout the core
 	 */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET);
+	brcmf_sdcard_reg_write(sdiodev,
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
+			SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET);
 	udelay(1);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(corebase, sbtmstatehigh), 4);
+				CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4);
 	if (regdata & SSB_TMSHIGH_SERR)
 		brcmf_sdcard_reg_write(sdiodev,
-				       CORE_SB(corebase, sbtmstatehigh), 4, 0);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4, 0);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(corebase, sbimstate), 4);
+				CORE_SB(ci->c_inf[idx].base, sbimstate), 4);
 	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO))
-		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbimstate), 4,
+		brcmf_sdcard_reg_write(sdiodev,
+			CORE_SB(ci->c_inf[idx].base, sbimstate), 4,
 			regdata & ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO));
 
 	/* clear reset and allow it to propagate throughout the core */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+	brcmf_sdcard_reg_write(sdiodev,
+		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
 		SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
 	udelay(1);
 
 	/* leave clock enabled */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow),
+	brcmf_sdcard_reg_write(sdiodev,
+			       CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 			       4, SSB_TMSLOW_CLOCK);
 	udelay(1);
 }
@@ -329,10 +370,12 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	case SOCI_SB:
 		ci->iscoreup = brcmf_sdio_sb_iscoreup;
 		ci->corerev = brcmf_sdio_sb_corerev;
+		ci->coredisable = brcmf_sdio_sb_coredisable;
 		break;
 	case SOCI_AI:
 		ci->iscoreup = brcmf_sdio_ai_iscoreup;
 		ci->corerev = brcmf_sdio_ai_corerev;
+		ci->coredisable = brcmf_sdio_ai_coredisable;
 		break;
 	default:
 		brcmf_dbg(ERROR, "socitype %u not supported\n", ci->socitype);
@@ -395,7 +438,6 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 			     struct chip_info *ci)
 {
 	u32 regdata;
-	u8 idx;
 
 	/* get chipcommon rev */
 	ci->c_inf[0].rev = ci->corerev(sdiodev, ci, ci->c_inf[0].id);
@@ -425,8 +467,7 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 	 * Make sure any on-chip ARM is off (in case strapping is wrong),
 	 * or downloaded code was already running.
 	 */
-	idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
-	brcmf_sdio_chip_coredisable(sdiodev, ci->c_inf[idx].base);
+	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3);
 }
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index ea91e60..22232a8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -78,6 +78,8 @@ struct chip_info {
 			 u16 coreid);
 	u32 (*corerev)(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 			 u16 coreid);
+	void (*coredisable)(struct brcmf_sdio_dev *sdiodev,
+			struct chip_info *ci, u16 coreid);
 };
 
 struct sbconfig {
@@ -121,9 +123,7 @@ struct sbconfig {
 };
 
 extern void brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev,
-				      u32 corebase);
-extern void brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev,
-					u32 corebase);
+				      struct chip_info *ci, u16 coreid);
 extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 				  struct chip_info **ci_ptr, u32 regs);
 extern void brcmf_sdio_chip_detach(struct chip_info **ci_ptr);
-- 
1.7.5.4


