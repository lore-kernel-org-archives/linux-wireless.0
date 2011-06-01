Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4862 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 20/83] staging: brcm80211: remove iovars IOV_HISPEED
Date: Wed, 1 Jun 2011 13:45:05 +0200
Message-ID: <1306928768-7501-20-git-send-email-rvossen@broadcom.com> (sfid-20110601_134814_273823_CA1A5F02)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unused sdio related iovars IOV_HISPEED for fullmac driver

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    3 ---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   13 -------------
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 789922b..e57dd00 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -365,8 +365,5 @@ void bcmsdh_unregister_oob_intr(void)
 extern uint sd_msglevel;	/* Debug message level */
 module_param(sd_msglevel, uint, 0);
 
-extern uint sd_hiok;		/* Ok to use hi-speed mode */
-module_param(sd_hiok, uint, 0);
-
 extern uint sd_f2_blocksize;
 module_param(sd_f2_blocksize, int, 0);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 2422890..cc4738a 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -47,7 +47,6 @@ extern PBCMSDH_SDMMC_INSTANCE gInstance;
 
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
-uint sd_hiok = false;		/* Don't use hi-speed mode by default */
 uint sd_msglevel = 0x01;
 DHD_PM_RESUME_WAIT_INIT(sdioh_request_byte_wait);
 DHD_PM_RESUME_WAIT_INIT(sdioh_request_word_wait);
@@ -349,7 +348,6 @@ enum {
 	IOV_USEINTS,
 	IOV_NUMINTS,
 	IOV_DEVREG,
-	IOV_HISPEED,
 	IOV_HCIREGS,
 	IOV_RXCHAIN
 };
@@ -362,8 +360,6 @@ const bcm_iovar_t sdioh_iovars[] = {
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
 	,
-	{"sd_highspeed", IOV_HISPEED, 0, IOVT_UINT32, 0}
-	,
 	{"sd_rxchain", IOV_RXCHAIN, 0, IOVT_BOOL, 0}
 	,
 	{NULL, 0, 0, 0, 0}
@@ -494,15 +490,6 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 		break;
 
-	case IOV_GVAL(IOV_HISPEED):
-		int_val = (u32) sd_hiok;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_HISPEED):
-		sd_hiok = int_val;
-		break;
-
 	case IOV_GVAL(IOV_NUMINTS):
 		int_val = (s32) si->intrcount;
 		memcpy(arg, &int_val, val_size);
-- 
1.7.4.1


