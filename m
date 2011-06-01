Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4919 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758908Ab1FALrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:47:03 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 19/83] staging: brcm80211: remove iovars IOV_SDMODE
Date: Wed, 1 Jun 2011 13:45:04 +0200
Message-ID: <1306928768-7501-19-git-send-email-rvossen@broadcom.com> (sfid-20110601_134754_878382_1C1139D3)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unused sdio related iovars IOV_SDMODE for fullmac driver

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    3 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   13 ----
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   65 +--------------------
 4 files changed, 2 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 3755774..789922b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -365,9 +365,6 @@ void bcmsdh_unregister_oob_intr(void)
 extern uint sd_msglevel;	/* Debug message level */
 module_param(sd_msglevel, uint, 0);
 
-extern uint sd_sdmode;		/* Default is SD4, 0=SPI, 1=SD1, 2=SD4 */
-module_param(sd_sdmode, uint, 0);
-
 extern uint sd_hiok;		/* Ok to use hi-speed mode */
 module_param(sd_hiok, uint, 0);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index c817e5e..2422890 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -45,7 +45,6 @@ extern int sdio_reset_comm(struct mmc_card *card);
 
 extern PBCMSDH_SDMMC_INSTANCE gInstance;
 
-uint sd_sdmode = SDIOH_MODE_SD4;	/* Use SD4 mode by default */
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
 uint sd_hiok = false;		/* Don't use hi-speed mode by default */
@@ -350,7 +349,6 @@ enum {
 	IOV_USEINTS,
 	IOV_NUMINTS,
 	IOV_DEVREG,
-	IOV_SDMODE,
 	IOV_HISPEED,
 	IOV_HCIREGS,
 	IOV_RXCHAIN
@@ -364,8 +362,6 @@ const bcm_iovar_t sdioh_iovars[] = {
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
 	,
-	{"sd_mode", IOV_SDMODE, 0, IOVT_UINT32, 100}
-	,
 	{"sd_highspeed", IOV_HISPEED, 0, IOVT_UINT32, 0}
 	,
 	{"sd_rxchain", IOV_RXCHAIN, 0, IOVT_BOOL, 0}
@@ -498,15 +494,6 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 		break;
 
-	case IOV_GVAL(IOV_SDMODE):
-		int_val = (u32) sd_sdmode;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_SDMODE):
-		sd_sdmode = int_val;
-		break;
-
 	case IOV_GVAL(IOV_HISPEED):
 		int_val = (u32) sd_hiok;
 		memcpy(arg, &int_val, val_size);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index 86f88bf..42c71a8 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -88,7 +88,6 @@ struct sdioh_info {
 	bool sd_blockmode;	/* sd_blockmode == false => 64 Byte Cmd 53s. */
 	/*  Must be on for sd_multiblock to be effective */
 	bool use_client_ints;	/* If this is false, make sure to restore */
-	int sd_mode;		/* SD1/SD4/SPI */
 	int client_block_size[SDIOD_MAX_IOFUNCS];	/* Blocksize */
 	u8 num_funcs;	/* Supported funcs on client */
 	u32 com_cis_ptr;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index d2c4301..7b94613 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -252,7 +252,6 @@ typedef struct dhd_bus {
 	s32 idletime;		/* Control for activity timeout */
 	s32 idlecount;	/* Activity timeout counter */
 	s32 idleclock;	/* How to set bus driver when idle */
-	s32 sd_mode;		/* Mode control to bus driver */
 	s32 sd_rxchain;	/* If bcmsdh api accepts PKT chains */
 	bool use_rxchain;	/* If dhd should use PKT chains */
 	bool sleeping;		/* Is SDIO bus sleeping? */
@@ -658,47 +657,12 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 /* Change idle/active SD state */
 static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 {
-	int err;
-	s32 iovalue;
-
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	if (on) {
-		if (bus->idleclock == DHD_IDLE_STOP) {
-			iovalue = bus->sd_mode;
-			err = bcmsdh_iovar_op(bus->sdh, "sd_mode", NULL, 0,
-					      &iovalue, sizeof(iovalue), true);
-			if (err) {
-				DHD_ERROR(("%s: error changing sd_mode: %d\n",
-					   __func__, err));
-				return -EBADE;
-			}
-		}
+	if (on)
 		bus->clkstate = CLK_SDONLY;
-	} else {
-		/* Stop or slow the SD clock itself */
-		if (bus->sd_mode == -1) {
-			DHD_TRACE(("%s: can't idle clock, mode %d\n",
-				   __func__, bus->sd_mode));
-			return -EBADE;
-		}
-		if (bus->idleclock == DHD_IDLE_STOP) {
-			if (sd1idle) {
-				/* Change to SD1 mode and turn off clock */
-				iovalue = 1;
-				err =
-				    bcmsdh_iovar_op(bus->sdh, "sd_mode", NULL,
-						    0, &iovalue,
-						    sizeof(iovalue), true);
-				if (err) {
-					DHD_ERROR(("%s: error changing sd_clock: %d\n",
-						__func__, err));
-					return -EBADE;
-				}
-			}
-		}
+	else
 		bus->clkstate = CLK_NONE;
-	}
 
 	return 0;
 }
@@ -2669,21 +2633,6 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 		    bcmsdh_iovar_op(bus->sdh, name, params, plen, arg, len,
 				    set);
 
-		/* Check for bus configuration changes of interest */
-
-		/* If it was a mode change, read the new one */
-		if (set && strcmp(name, "sd_mode") == 0) {
-			if (bcmsdh_iovar_op(bus->sdh, "sd_mode", NULL, 0,
-					    &bus->sd_mode, sizeof(s32),
-					    false) != 0) {
-				bus->sd_mode = -1;
-				DHD_ERROR(("%s: fail on %s get\n", __func__,
-					   name));
-			} else {
-				DHD_INFO(("%s: noted %s update, value now %d\n",
-					  __func__, name, bus->sd_mode));
-			}
-		}
 		/* Similar check for blocksize change */
 		if (set && strcmp(name, "sd_blocksize") == 0) {
 			s32 fnum = 2;
@@ -5314,16 +5263,6 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 	bus->idletime = (s32) dhd_idletime;
 	bus->idleclock = DHD_IDLE_ACTIVE;
 
-	/* Query the SD bus mode */
-	if (bcmsdh_iovar_op(sdh, "sd_mode", NULL, 0,
-			    &bus->sd_mode, sizeof(s32), false) != 0) {
-		DHD_ERROR(("%s: fail on %s get\n", __func__, "sd_mode"));
-		bus->sd_mode = -1;
-	} else {
-		DHD_INFO(("%s: Initial value for %s is %d\n",
-			  __func__, "sd_mode", bus->sd_mode));
-	}
-
 	/* Query the F2 block size, set roundup accordingly */
 	fnum = 2;
 	if (bcmsdh_iovar_op(sdh, "sd_blocksize", &fnum, sizeof(s32),
-- 
1.7.4.1


