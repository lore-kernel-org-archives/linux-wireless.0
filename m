Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3755 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/19] brcm80211: fmac: add resetcore function for
 bcm4330 chip
Date: Thu, 10 Nov 2011 20:30:24 +0100
Message-ID: <1320953434-16859-11-git-send-email-arend@broadcom.com> (sfid-20111110_203108_723235_6476B4F0)
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
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   45 ++++++++++++++++++--
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    4 +-
 3 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 0d0e283..a5d1c35 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3108,8 +3108,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 
 		ci->coredisable(bus->sdiodev, ci, BCMA_CORE_ARM_CM3);
 
-		brcmf_sdio_chip_resetcore(bus->sdiodev, ci,
-					  BCMA_CORE_INTERNAL_MEM);
+		ci->resetcore(bus->sdiodev, ci, BCMA_CORE_INTERNAL_MEM);
 
 		/* Clear the top bit of memory */
 		if (bus->ramsize) {
@@ -3133,7 +3132,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 		w_sdreg32(bus, 0xFFFFFFFF,
 			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 
-		brcmf_sdio_chip_resetcore(bus->sdiodev, ci, BCMA_CORE_ARM_CM3);
+		ci->resetcore(bus->sdiodev, ci, BCMA_CORE_ARM_CM3);
 
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index d2cf8c6..cef9abb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -278,9 +278,9 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 	udelay(1);
 }
 
-void
-brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev,
-			  struct chip_info *ci, u16 coreid)
+static void
+brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
+			struct chip_info *ci, u16 coreid)
 {
 	u32 regdata;
 	u8 idx;
@@ -291,7 +291,7 @@ brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev,
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	ci->coredisable(sdiodev, ci, coreid);
+	brcmf_sdio_sb_coredisable(sdiodev, ci, coreid);
 
 	/*
 	 * Now do the initialization sequence.
@@ -301,8 +301,11 @@ brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdcard_reg_write(sdiodev,
 			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
 			SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET);
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
 	udelay(1);
 
+	/* clear any serror */
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4);
 	if (regdata & SSB_TMSHIGH_SERR)
@@ -320,12 +323,44 @@ brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdcard_reg_write(sdiodev,
 		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
 		SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
 	udelay(1);
 
 	/* leave clock enabled */
 	brcmf_sdcard_reg_write(sdiodev,
 			       CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 			       4, SSB_TMSLOW_CLOCK);
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
+	udelay(1);
+}
+
+static void
+brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
+			struct chip_info *ci, u16 coreid)
+{
+	u8 idx;
+	u32 regdata;
+
+	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+
+	/* must disable first to work for arbitrary current core state */
+	brcmf_sdio_ai_coredisable(sdiodev, ci, coreid);
+
+	/* now do initialization sequence */
+	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+			       4, BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					ci->c_inf[idx].wrapbase+BCMA_IOCTL, 4);
+	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+			       4, 0);
+	udelay(1);
+
+	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+			       4, BCMA_IOCTL_CLK);
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					ci->c_inf[idx].wrapbase+BCMA_IOCTL, 4);
 	udelay(1);
 }
 
@@ -371,11 +406,13 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->iscoreup = brcmf_sdio_sb_iscoreup;
 		ci->corerev = brcmf_sdio_sb_corerev;
 		ci->coredisable = brcmf_sdio_sb_coredisable;
+		ci->resetcore = brcmf_sdio_sb_resetcore;
 		break;
 	case SOCI_AI:
 		ci->iscoreup = brcmf_sdio_ai_iscoreup;
 		ci->corerev = brcmf_sdio_ai_corerev;
 		ci->coredisable = brcmf_sdio_ai_coredisable;
+		ci->resetcore = brcmf_sdio_ai_resetcore;
 		break;
 	default:
 		brcmf_dbg(ERROR, "socitype %u not supported\n", ci->socitype);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 22232a8..ce974d7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -80,6 +80,8 @@ struct chip_info {
 			 u16 coreid);
 	void (*coredisable)(struct brcmf_sdio_dev *sdiodev,
 			struct chip_info *ci, u16 coreid);
+	void (*resetcore)(struct brcmf_sdio_dev *sdiodev,
+			struct chip_info *ci, u16 coreid);
 };
 
 struct sbconfig {
@@ -122,8 +124,6 @@ struct sbconfig {
 	u32 sbidhigh;	/* identification */
 };
 
-extern void brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev,
-				      struct chip_info *ci, u16 coreid);
 extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 				  struct chip_info **ci_ptr, u32 regs);
 extern void brcmf_sdio_chip_detach(struct chip_info **ci_ptr);
-- 
1.7.5.4


