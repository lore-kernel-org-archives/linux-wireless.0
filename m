Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1142 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758894Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 17/83] staging: brcm80211: remove iovars IOV_POWER
Date: Wed, 1 Jun 2011 13:45:02 +0200
Message-ID: <1306928768-7501-17-git-send-email-rvossen@broadcom.com> (sfid-20110601_134808_464848_86C566E4)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unused sdio related iovars IOV_POWER for fullmac driver

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    4 ----
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   13 -------------
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index ab4d0cc..5b8529c 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -365,10 +365,6 @@ void bcmsdh_unregister_oob_intr(void)
 extern uint sd_msglevel;	/* Debug message level */
 module_param(sd_msglevel, uint, 0);
 
-extern uint sd_power;		/* 0 = SD Power OFF,
-					 1 = SD Power ON. */
-module_param(sd_power, uint, 0);
-
 extern uint sd_clock;		/* SD Clock Control, 0 = SD Clock OFF,
 				 1 = SD Clock ON */
 module_param(sd_clock, uint, 0);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 02fa5b4..a2d0ad8 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -48,7 +48,6 @@ extern PBCMSDH_SDMMC_INSTANCE gInstance;
 uint sd_sdmode = SDIOH_MODE_SD4;	/* Use SD4 mode by default */
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
-uint sd_power = 1;		/* Default to SD Slot powered ON */
 uint sd_clock = 1;		/* Default to SD Clock turned ON */
 uint sd_hiok = false;		/* Don't use hi-speed mode by default */
 uint sd_msglevel = 0x01;
@@ -355,7 +354,6 @@ enum {
 	IOV_SDMODE,
 	IOV_HISPEED,
 	IOV_HCIREGS,
-	IOV_POWER,
 	IOV_CLOCK,
 	IOV_RXCHAIN
 };
@@ -368,8 +366,6 @@ const bcm_iovar_t sdioh_iovars[] = {
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
 	,
-	{"sd_power", IOV_POWER, 0, IOVT_UINT32, 0}
-	,
 	{"sd_clock", IOV_CLOCK, 0, IOVT_UINT32, 0}
 	,
 	{"sd_mode", IOV_SDMODE, 0, IOVT_UINT32, 100}
@@ -506,15 +502,6 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 		break;
 
-	case IOV_GVAL(IOV_POWER):
-		int_val = (u32) sd_power;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_POWER):
-		sd_power = int_val;
-		break;
-
 	case IOV_GVAL(IOV_CLOCK):
 		int_val = (u32) sd_clock;
 		memcpy(arg, &int_val, val_size);
-- 
1.7.4.1


