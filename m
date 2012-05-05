Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1399 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/11] brcmfmac: replace brcmf_sdcard_reg_write with
 brcmf_sdio_regwl
Date: Fri, 4 May 2012 18:27:35 -0700
Message-ID: <1336181258-7305-9-git-send-email-frankyl@broadcom.com> (sfid-20120505_032844_978671_46B8B6F5)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the newly introduced brcmf_sdio_regwl to replace
brcmf_sdcard_reg_write as part of the SDIO WiFi dongle register
access interface clean up.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   32 -------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   12 +--
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   93 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    8 --
 4 files changed, 50 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 54a935b..cd5f7d7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -298,38 +298,6 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
-u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data)
-{
-	int status;
-	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
-	int err = 0;
-
-	brcmf_dbg(INFO, "fun = 1, addr = 0x%x, uint32data = 0x%x\n",
-		  addr, data);
-
-	if (bar0 != sdiodev->sbwad) {
-		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
-		if (err)
-			return err;
-
-		sdiodev->sbwad = bar0;
-	}
-
-	addr &= SBSDIO_SB_OFT_ADDR_MASK;
-	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
-	status =
-	    brcmf_sdioh_request_word(sdiodev, SDIOH_WRITE, SDIO_FUNC_1,
-				     addr, &data, 4);
-	sdiodev->regfail = (status != 0);
-
-	if (status == 0)
-		return 0;
-
-	brcmf_dbg(ERROR, "error writing 0x%08x to addr 0x%04x\n",
-		  data, addr);
-	return 0xFFFFFFFF;
-}
-
 bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev)
 {
 	return sdiodev->regfail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 1e96ebf..2c644a9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -653,13 +653,13 @@ static void
 w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 {
 	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
+	int ret;
 	*retryvar = 0;
 	do {
-		brcmf_sdcard_reg_write(bus->sdiodev,
-				       bus->ci->c_inf[idx].base + reg_offset,
-				       regval);
-	} while (brcmf_sdcard_regfail(bus->sdiodev) &&
-		 (++(*retryvar) <= retry_limit));
+		brcmf_sdio_regwl(bus->sdiodev,
+				 bus->ci->c_inf[idx].base + reg_offset,
+				 regval, &ret);
+	} while ((ret != 0) && (++(*retryvar) <= retry_limit));
 	if (*retryvar) {
 		bus->regfails += (*retryvar-1);
 		if (*retryvar > retry_limit)
@@ -3751,7 +3751,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	reg_addr = bus->ci->c_inf[idx].base +
 		   offsetof(struct sdpcmd_regs, corecontrol);
 	reg_val = brcmf_sdio_regrl(bus->sdiodev, reg_addr, NULL);
-	brcmf_sdcard_reg_write(bus->sdiodev, reg_addr, reg_val | CC_BPRESEN);
+	brcmf_sdio_regwl(bus->sdiodev, reg_addr, reg_val | CC_BPRESEN, NULL);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index c2ec99c..f8e1f1c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -171,9 +171,8 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 		 */
 		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow),
 					   NULL);
-		brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				regdata | SSB_TMSLOW_REJECT);
+		brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
+				 regdata | SSB_TMSLOW_REJECT, NULL);
 
 		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow),
 					   NULL);
@@ -196,9 +195,8 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 						   CORE_SB(base, sbimstate),
 						   NULL);
 			regdata |= SSB_IMSTATE_REJECT;
-			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate),
-				regdata);
+			brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbimstate),
+					 regdata, NULL);
 			regdata = brcmf_sdio_regrl(sdiodev,
 						   CORE_SB(base, sbimstate),
 						   NULL);
@@ -210,10 +208,10 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 		}
 
 		/* set reset and reject while enabling the clocks */
-		brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			(SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
-			SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
+		regdata = SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
+			  SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET;
+		brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
+				 regdata, NULL);
 		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbtmstatelow),
 					   NULL);
 		udelay(10);
@@ -226,16 +224,14 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 						   CORE_SB(base, sbimstate),
 						   NULL);
 			regdata &= ~SSB_IMSTATE_REJECT;
-			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(ci->c_inf[idx].base, sbimstate),
-				regdata);
+			brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbimstate),
+					 regdata, NULL);
 		}
 	}
 
 	/* leave reset and reject asserted */
-	brcmf_sdcard_reg_write(sdiodev,
-		CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-		(SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
+	brcmf_sdio_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
+			 (SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET), NULL);
 	udelay(1);
 }
 
@@ -255,13 +251,13 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
 		return;
 
-	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL, 0);
+	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL, 0, NULL);
 	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 				   NULL);
 	udelay(10);
 
-	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-			       BCMA_RESET_CTL_RESET);
+	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+			 BCMA_RESET_CTL_RESET, NULL);
 	udelay(1);
 }
 
@@ -285,9 +281,10 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 	 * set reset while enabling the clock and
 	 * forcing them on throughout the core
 	 */
-	brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET);
+	brcmf_sdio_regwl(sdiodev,
+			 CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET,
+			 NULL);
 	regdata = brcmf_sdio_regrl(sdiodev,
 				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 				   NULL);
@@ -298,30 +295,30 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 				   CORE_SB(ci->c_inf[idx].base, sbtmstatehigh),
 				   NULL);
 	if (regdata & SSB_TMSHIGH_SERR)
-		brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbtmstatehigh), 0);
+		brcmf_sdio_regwl(sdiodev,
+				 CORE_SB(ci->c_inf[idx].base, sbtmstatehigh),
+				 0, NULL);
 
 	regdata = brcmf_sdio_regrl(sdiodev,
 				   CORE_SB(ci->c_inf[idx].base, sbimstate),
 				   NULL);
 	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO))
-		brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(ci->c_inf[idx].base, sbimstate),
-			regdata & ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO));
+		brcmf_sdio_regwl(sdiodev,
+				 CORE_SB(ci->c_inf[idx].base, sbimstate),
+				 regdata & ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO),
+				 NULL);
 
 	/* clear reset and allow it to propagate throughout the core */
-	brcmf_sdcard_reg_write(sdiodev,
-		CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-		SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
+	brcmf_sdio_regwl(sdiodev, CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK, NULL);
 	regdata = brcmf_sdio_regrl(sdiodev,
 				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 				   NULL);
 	udelay(1);
 
 	/* leave clock enabled */
-	brcmf_sdcard_reg_write(sdiodev,
-			       CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			       SSB_TMSLOW_CLOCK);
+	brcmf_sdio_regwl(sdiodev, CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
+			 SSB_TMSLOW_CLOCK, NULL);
 	regdata = brcmf_sdio_regrl(sdiodev,
 				   CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
 				   NULL);
@@ -341,16 +338,16 @@ brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
 	brcmf_sdio_ai_coredisable(sdiodev, ci, coreid);
 
 	/* now do initialization sequence */
-	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			       BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
+	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+			 BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
 	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 				   NULL);
-	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-			       0);
+	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+			 0, NULL);
 	udelay(1);
 
-	brcmf_sdcard_reg_write(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			       BCMA_IOCTL_CLK);
+	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+			 BCMA_IOCTL_CLK, NULL);
 	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 				   NULL);
 	udelay(1);
@@ -536,10 +533,10 @@ int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_sdio_chip_buscoresetup(sdiodev, ci);
 
-	brcmf_sdcard_reg_write(sdiodev,
-		CORE_CC_REG(ci->c_inf[0].base, gpiopullup), 0);
-	brcmf_sdcard_reg_write(sdiodev,
-		CORE_CC_REG(ci->c_inf[0].base, gpiopulldown), 0);
+	brcmf_sdio_regwl(sdiodev, CORE_CC_REG(ci->c_inf[0].base, gpiopullup),
+			 0, NULL);
+	brcmf_sdio_regwl(sdiodev, CORE_CC_REG(ci->c_inf[0].base, gpiopulldown),
+			 0, NULL);
 
 	*ci_ptr = ci;
 	return 0;
@@ -605,9 +602,8 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 			}
 		}
 
-		brcmf_sdcard_reg_write(sdiodev,
-			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr),
-			1);
+		brcmf_sdio_regwl(sdiodev, CORE_CC_REG(base, chipcontrol_addr),
+				 1, NULL);
 		cc_data_temp =
 			brcmf_sdio_regrl(sdiodev,
 					 CORE_CC_REG(base, chipcontrol_addr),
@@ -615,9 +611,8 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		cc_data_temp &= ~str_mask;
 		drivestrength_sel <<= str_shift;
 		cc_data_temp |= drivestrength_sel;
-		brcmf_sdcard_reg_write(sdiodev,
-			CORE_CC_REG(ci->c_inf[0].base, chipcontrol_addr),
-			cc_data_temp);
+		brcmf_sdio_regwl(sdiodev, CORE_CC_REG(base, chipcontrol_addr),
+				 cc_data_temp, NULL);
 
 		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
 			  drivestrength, cc_data_temp);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 82d9dd1..a147535 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -168,14 +168,6 @@ struct brcmf_sdio_dev {
 extern int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev);
 extern int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev);
 
-/* Synchronous access to device (client) core registers via CMD53 to F1.
- *   addr: backplane address (i.e. >= regsva from attach)
- *   size: register width in bytes (2 or 4)
- *   data: data for register write
- */
-extern u32
-brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data);
-
 /* sdio device register access interface */
 extern u8 brcmf_sdio_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
 extern u32 brcmf_sdio_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
-- 
1.7.9.5


