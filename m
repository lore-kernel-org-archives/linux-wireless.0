Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1334 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab2EEB1p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:45 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/11] brcmfmac: remove unused parameter of
 brcmf_sdcard_reg_write
Date: Fri, 4 May 2012 18:27:29 -0700
Message-ID: <1336181258-7305-3-git-send-email-frankyl@broadcom.com> (sfid-20120505_032825_018747_FD0061D2)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The size parameter for brcmf_sdcard_reg_write is always 4. Remove it
to make the code cleaner.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   16 ++++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 +--
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   39 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    3 +-
 4 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9966cf2..7c9bc2b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -254,15 +254,14 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr)
 	}
 }
 
-u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
-			   u32 data)
+u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data)
 {
 	int status;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	brcmf_dbg(INFO, "fun = 1, addr = 0x%x, uint%ddata = 0x%x\n",
-		  addr, size * 8, data);
+	brcmf_dbg(INFO, "fun = 1, addr = 0x%x, uint32data = 0x%x\n",
+		  addr, data);
 
 	if (bar0 != sdiodev->sbwad) {
 		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
@@ -273,18 +272,17 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
 	}
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
-	if (size == 4)
-		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 	status =
 	    brcmf_sdioh_request_word(sdiodev, SDIOH_WRITE, SDIO_FUNC_1,
-				     addr, &data, size);
+				     addr, &data, 4);
 	sdiodev->regfail = (status != 0);
 
 	if (status == 0)
 		return 0;
 
-	brcmf_dbg(ERROR, "error writing 0x%08x to addr 0x%04x size %d\n",
-		  data, addr, size);
+	brcmf_dbg(ERROR, "error writing 0x%08x to addr 0x%04x\n",
+		  data, addr);
 	return 0xFFFFFFFF;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 0d1f3b8..7ed215d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -656,7 +656,7 @@ w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 	do {
 		brcmf_sdcard_reg_write(bus->sdiodev,
 				       bus->ci->c_inf[idx].base + reg_offset,
-				       sizeof(u32), regval);
+				       regval);
 	} while (brcmf_sdcard_regfail(bus->sdiodev) &&
 		 (++(*retryvar) <= retry_limit));
 	if (*retryvar) {
@@ -3782,8 +3782,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	reg_addr = bus->ci->c_inf[idx].base +
 		   offsetof(struct sdpcmd_regs, corecontrol);
 	reg_val = brcmf_sdcard_reg_read(bus->sdiodev, reg_addr);
-	brcmf_sdcard_reg_write(bus->sdiodev, reg_addr, sizeof(u32),
-			       reg_val | CC_BPRESEN);
+	brcmf_sdcard_reg_write(bus->sdiodev, reg_addr, reg_val | CC_BPRESEN);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index b5688a7..3ced613 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -171,7 +171,7 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 		brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				4, regdata | SSB_TMSLOW_REJECT);
+				regdata | SSB_TMSLOW_REJECT);
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
@@ -192,7 +192,7 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbimstate)) |
 				SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate), 4,
+				CORE_SB(ci->c_inf[idx].base, sbimstate),
 				regdata);
 			regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbimstate));
@@ -204,7 +204,7 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 
 		/* set reset and reject while enabling the clocks */
 		brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 			(SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 			SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
 		regdata = brcmf_sdcard_reg_read(sdiodev,
@@ -219,14 +219,14 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbimstate)) &
 				~SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate), 4,
+				CORE_SB(ci->c_inf[idx].base, sbimstate),
 				regdata);
 		}
 	}
 
 	/* leave reset and reject asserted */
 	brcmf_sdcard_reg_write(sdiodev,
-		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
+		CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 		(SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
 	udelay(1);
 }
@@ -246,14 +246,13 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
 		return;
 
-	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			       4, 0);
+	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL, 0);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
 	udelay(10);
 
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-			       4, BCMA_RESET_CTL_RESET);
+			       BCMA_RESET_CTL_RESET);
 	udelay(1);
 }
 
@@ -278,7 +277,7 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 	 * forcing them on throughout the core
 	 */
 	brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 			SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
@@ -289,18 +288,18 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatehigh));
 	if (regdata & SSB_TMSHIGH_SERR)
 		brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 4, 0);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 0);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbimstate));
 	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO))
 		brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbimstate), 4,
+			CORE_SB(ci->c_inf[idx].base, sbimstate),
 			regdata & ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO));
 
 	/* clear reset and allow it to propagate throughout the core */
 	brcmf_sdcard_reg_write(sdiodev,
-		CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4,
+		CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 		SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
@@ -309,7 +308,7 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 	/* leave clock enabled */
 	brcmf_sdcard_reg_write(sdiodev,
 			       CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			       4, SSB_TMSLOW_CLOCK);
+			       SSB_TMSLOW_CLOCK);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(ci->c_inf[idx].base, sbtmstatelow));
 	udelay(1);
@@ -329,15 +328,15 @@ brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
 
 	/* now do initialization sequence */
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			       4, BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
+			       BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-			       4, 0);
+			       0);
 	udelay(1);
 
 	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			       4, BCMA_IOCTL_CLK);
+			       BCMA_IOCTL_CLK);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 					ci->c_inf[idx].wrapbase+BCMA_IOCTL);
 	udelay(1);
@@ -522,9 +521,9 @@ int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdio_chip_buscoresetup(sdiodev, ci);
 
 	brcmf_sdcard_reg_write(sdiodev,
-		CORE_CC_REG(ci->c_inf[0].base, gpiopullup), 4, 0);
+		CORE_CC_REG(ci->c_inf[0].base, gpiopullup), 0);
 	brcmf_sdcard_reg_write(sdiodev,
-		CORE_CC_REG(ci->c_inf[0].base, gpiopulldown), 4, 0);
+		CORE_CC_REG(ci->c_inf[0].base, gpiopulldown), 0);
 
 	*ci_ptr = ci;
 	return 0;
@@ -591,7 +590,7 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 
 		brcmf_sdcard_reg_write(sdiodev,
 			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr),
-			4, 1);
+			1);
 		cc_data_temp = brcmf_sdcard_reg_read(sdiodev,
 			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr));
 		cc_data_temp &= ~str_mask;
@@ -599,7 +598,7 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		cc_data_temp |= drivestrength_sel;
 		brcmf_sdcard_reg_write(sdiodev,
 			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr),
-			4, cc_data_temp);
+			cc_data_temp);
 
 		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
 			  drivestrength, cc_data_temp);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index a5670c4..6df06cf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -184,8 +184,7 @@ extern u32
 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr);
 
 extern u32
-brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
-		       u32 data);
+brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data);
 
 /* Indicate if last reg read/write failed */
 extern bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev);
-- 
1.7.9.5


