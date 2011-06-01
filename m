Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4848 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 18/83] staging: brcm80211: remove iovars IOV_CLOCK
Date: Wed, 1 Jun 2011 13:45:03 +0200
Message-ID: <1306928768-7501-18-git-send-email-rvossen@broadcom.com> (sfid-20110601_134828_277677_DD2D1938)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unused sdio related iovars IOV_CLOCK for fullmac driver

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    4 ----
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   13 -------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   19 -------------------
 3 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 5b8529c..3755774 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -365,10 +365,6 @@ void bcmsdh_unregister_oob_intr(void)
 extern uint sd_msglevel;	/* Debug message level */
 module_param(sd_msglevel, uint, 0);
 
-extern uint sd_clock;		/* SD Clock Control, 0 = SD Clock OFF,
-				 1 = SD Clock ON */
-module_param(sd_clock, uint, 0);
-
 extern uint sd_sdmode;		/* Default is SD4, 0=SPI, 1=SD1, 2=SD4 */
 module_param(sd_sdmode, uint, 0);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index a2d0ad8..c817e5e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -48,7 +48,6 @@ extern PBCMSDH_SDMMC_INSTANCE gInstance;
 uint sd_sdmode = SDIOH_MODE_SD4;	/* Use SD4 mode by default */
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
-uint sd_clock = 1;		/* Default to SD Clock turned ON */
 uint sd_hiok = false;		/* Don't use hi-speed mode by default */
 uint sd_msglevel = 0x01;
 DHD_PM_RESUME_WAIT_INIT(sdioh_request_byte_wait);
@@ -354,7 +353,6 @@ enum {
 	IOV_SDMODE,
 	IOV_HISPEED,
 	IOV_HCIREGS,
-	IOV_CLOCK,
 	IOV_RXCHAIN
 };
 
@@ -366,8 +364,6 @@ const bcm_iovar_t sdioh_iovars[] = {
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
 	,
-	{"sd_clock", IOV_CLOCK, 0, IOVT_UINT32, 0}
-	,
 	{"sd_mode", IOV_SDMODE, 0, IOVT_UINT32, 100}
 	,
 	{"sd_highspeed", IOV_HISPEED, 0, IOVT_UINT32, 0}
@@ -502,15 +498,6 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 		break;
 
-	case IOV_GVAL(IOV_CLOCK):
-		int_val = (u32) sd_clock;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_CLOCK):
-		sd_clock = int_val;
-		break;
-
 	case IOV_GVAL(IOV_SDMODE):
 		int_val = (u32) sd_sdmode;
 		memcpy(arg, &int_val, val_size);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index ff3e88c..d2c4301 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -665,16 +665,6 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 
 	if (on) {
 		if (bus->idleclock == DHD_IDLE_STOP) {
-			/* Turn on clock and restore mode */
-			iovalue = 1;
-			err = bcmsdh_iovar_op(bus->sdh, "sd_clock", NULL, 0,
-					      &iovalue, sizeof(iovalue), true);
-			if (err) {
-				DHD_ERROR(("%s: error enabling sd_clock: %d\n",
-					   __func__, err));
-				return -EBADE;
-			}
-
 			iovalue = bus->sd_mode;
 			err = bcmsdh_iovar_op(bus->sdh, "sd_mode", NULL, 0,
 					      &iovalue, sizeof(iovalue), true);
@@ -706,15 +696,6 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 					return -EBADE;
 				}
 			}
-
-			iovalue = 0;
-			err = bcmsdh_iovar_op(bus->sdh, "sd_clock", NULL, 0,
-					      &iovalue, sizeof(iovalue), true);
-			if (err) {
-				DHD_ERROR(("%s: error disabling sd_clock: %d\n",
-					   __func__, err));
-				return -EBADE;
-			}
 		}
 		bus->clkstate = CLK_NONE;
 	}
-- 
1.7.4.1


