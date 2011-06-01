Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1144 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 16/83] staging: brcm80211: remove iovars IOV_DIVISOR
Date: Wed, 1 Jun 2011 13:45:01 +0200
Message-ID: <1306928768-7501-16-git-send-email-rvossen@broadcom.com> (sfid-20110601_134805_860646_0F56C300)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unused sdio related iovars IOV_DIVISOR for fullmac driver

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    3 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   14 ------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   51 +-------------------
 3 files changed, 3 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 465f623..ab4d0cc 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -373,9 +373,6 @@ extern uint sd_clock;		/* SD Clock Control, 0 = SD Clock OFF,
 				 1 = SD Clock ON */
 module_param(sd_clock, uint, 0);
 
-extern uint sd_divisor;		/* Divisor (-1 means external clock) */
-module_param(sd_divisor, uint, 0);
-
 extern uint sd_sdmode;		/* Default is SD4, 0=SPI, 1=SD1, 2=SD4 */
 module_param(sd_sdmode, uint, 0);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index f24de82..02fa5b4 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -48,8 +48,6 @@ extern PBCMSDH_SDMMC_INSTANCE gInstance;
 uint sd_sdmode = SDIOH_MODE_SD4;	/* Use SD4 mode by default */
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
-uint sd_divisor = 2;		/* Default 48MHz/2 = 24MHz */
-
 uint sd_power = 1;		/* Default to SD Slot powered ON */
 uint sd_clock = 1;		/* Default to SD Clock turned ON */
 uint sd_hiok = false;		/* Don't use hi-speed mode by default */
@@ -354,7 +352,6 @@ enum {
 	IOV_USEINTS,
 	IOV_NUMINTS,
 	IOV_DEVREG,
-	IOV_DIVISOR,
 	IOV_SDMODE,
 	IOV_HISPEED,
 	IOV_HCIREGS,
@@ -371,8 +368,6 @@ const bcm_iovar_t sdioh_iovars[] = {
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
 	,
-	{"sd_divisor", IOV_DIVISOR, 0, IOVT_UINT32, 0}
-	,
 	{"sd_power", IOV_POWER, 0, IOVT_UINT32, 0}
 	,
 	{"sd_clock", IOV_CLOCK, 0, IOVT_UINT32, 0}
@@ -511,15 +506,6 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 		break;
 
-	case IOV_GVAL(IOV_DIVISOR):
-		int_val = (u32) sd_divisor;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_DIVISOR):
-		sd_divisor = int_val;
-		break;
-
 	case IOV_GVAL(IOV_POWER):
 		int_val = (u32) sd_power;
 		memcpy(arg, &int_val, val_size);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 19a12b9..ff3e88c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -252,7 +252,6 @@ typedef struct dhd_bus {
 	s32 idletime;		/* Control for activity timeout */
 	s32 idlecount;	/* Activity timeout counter */
 	s32 idleclock;	/* How to set bus driver when idle */
-	s32 sd_divisor;	/* Speed control to bus driver */
 	s32 sd_mode;		/* Mode control to bus driver */
 	s32 sd_rxchain;	/* If bcmsdh api accepts PKT chains */
 	bool use_rxchain;	/* If dhd should use PKT chains */
@@ -684,23 +683,13 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 					   __func__, err));
 				return -EBADE;
 			}
-		} else if (bus->idleclock != DHD_IDLE_ACTIVE) {
-			/* Restore clock speed */
-			iovalue = bus->sd_divisor;
-			err = bcmsdh_iovar_op(bus->sdh, "sd_divisor", NULL, 0,
-					      &iovalue, sizeof(iovalue), true);
-			if (err) {
-				DHD_ERROR(("%s: error restoring sd_divisor: %d\n",
-					__func__, err));
-				return -EBADE;
-			}
 		}
 		bus->clkstate = CLK_SDONLY;
 	} else {
 		/* Stop or slow the SD clock itself */
-		if ((bus->sd_divisor == -1) || (bus->sd_mode == -1)) {
-			DHD_TRACE(("%s: can't idle clock, divisor %d mode %d\n",
-				   __func__, bus->sd_divisor, bus->sd_mode));
+		if (bus->sd_mode == -1) {
+			DHD_TRACE(("%s: can't idle clock, mode %d\n",
+				   __func__, bus->sd_mode));
 			return -EBADE;
 		}
 		if (bus->idleclock == DHD_IDLE_STOP) {
@@ -726,16 +715,6 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 					   __func__, err));
 				return -EBADE;
 			}
-		} else if (bus->idleclock != DHD_IDLE_ACTIVE) {
-			/* Set divisor to idle value */
-			iovalue = bus->idleclock;
-			err = bcmsdh_iovar_op(bus->sdh, "sd_divisor", NULL, 0,
-					      &iovalue, sizeof(iovalue), true);
-			if (err) {
-				DHD_ERROR(("%s: error changing sd_divisor: %d\n",
-					__func__, err));
-				return -EBADE;
-			}
 		}
 		bus->clkstate = CLK_NONE;
 	}
@@ -2711,19 +2690,6 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 
 		/* Check for bus configuration changes of interest */
 
-		/* If it was divisor change, read the new one */
-		if (set && strcmp(name, "sd_divisor") == 0) {
-			if (bcmsdh_iovar_op(bus->sdh, "sd_divisor", NULL, 0,
-					    &bus->sd_divisor, sizeof(s32),
-					    false) != 0) {
-				bus->sd_divisor = -1;
-				DHD_ERROR(("%s: fail on %s get\n", __func__,
-					   name));
-			} else {
-				DHD_INFO(("%s: noted %s update, value now %d\n",
-					  __func__, name, bus->sd_divisor));
-			}
-		}
 		/* If it was a mode change, read the new one */
 		if (set && strcmp(name, "sd_mode") == 0) {
 			if (bcmsdh_iovar_op(bus->sdh, "sd_mode", NULL, 0,
@@ -5367,17 +5333,6 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 	bus->idletime = (s32) dhd_idletime;
 	bus->idleclock = DHD_IDLE_ACTIVE;
 
-	/* Query the SD clock speed */
-	if (bcmsdh_iovar_op(sdh, "sd_divisor", NULL, 0,
-			    &bus->sd_divisor, sizeof(s32),
-			    false) != 0) {
-		DHD_ERROR(("%s: fail on %s get\n", __func__, "sd_divisor"));
-		bus->sd_divisor = -1;
-	} else {
-		DHD_INFO(("%s: Initial value for %s is %d\n",
-			  __func__, "sd_divisor", bus->sd_divisor));
-	}
-
 	/* Query the SD bus mode */
 	if (bcmsdh_iovar_op(sdh, "sd_mode", NULL, 0,
 			    &bus->sd_mode, sizeof(s32), false) != 0) {
-- 
1.7.4.1


