Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3783 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161139Ab1FALqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 15/83] staging: brcm80211: remove iovars IOV_HOSTREG
Date: Wed, 1 Jun 2011 13:45:00 +0200
Message-ID: <1306928768-7501-15-git-send-email-rvossen@broadcom.com> (sfid-20110601_134638_848250_751A6CFB)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unused sdio related iovars IOV_HOSTREG for fullmac driver

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   53 ---------------------
 1 files changed, 0 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 44b1371..f24de82 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -353,7 +353,6 @@ enum {
 	IOV_BLOCKSIZE,
 	IOV_USEINTS,
 	IOV_NUMINTS,
-	IOV_HOSTREG,
 	IOV_DEVREG,
 	IOV_DIVISOR,
 	IOV_SDMODE,
@@ -370,8 +369,6 @@ const bcm_iovar_t sdioh_iovars[] = {
 								 size) */
 	{"sd_ints", IOV_USEINTS, 0, IOVT_BOOL, 0},
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
-	{"sd_hostreg", IOV_HOSTREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
-	,
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
 	,
 	{"sd_divisor", IOV_DIVISOR, 0, IOVT_UINT32, 0}
@@ -564,56 +561,6 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 		memcpy(arg, &int_val, val_size);
 		break;
 
-	case IOV_GVAL(IOV_HOSTREG):
-		{
-			sdreg_t *sd_ptr = (sdreg_t *) params;
-
-			if (sd_ptr->offset < SD_SysAddr
-			    || sd_ptr->offset > SD_MaxCurCap) {
-				sd_err(("%s: bad offset 0x%x\n", __func__,
-					sd_ptr->offset));
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			sd_trace(("%s: rreg%d at offset %d\n", __func__,
-				  (sd_ptr->offset & 1) ? 8
-				  : ((sd_ptr->offset & 2) ? 16 : 32),
-				  sd_ptr->offset));
-			if (sd_ptr->offset & 1)
-				int_val = 8;	/* sdioh_sdmmc_rreg8(si,
-						 sd_ptr->offset); */
-			else if (sd_ptr->offset & 2)
-				int_val = 16;	/* sdioh_sdmmc_rreg16(si,
-						 sd_ptr->offset); */
-			else
-				int_val = 32;	/* sdioh_sdmmc_rreg(si,
-						 sd_ptr->offset); */
-
-			memcpy(arg, &int_val, sizeof(int_val));
-			break;
-		}
-
-	case IOV_SVAL(IOV_HOSTREG):
-		{
-			sdreg_t *sd_ptr = (sdreg_t *) params;
-
-			if (sd_ptr->offset < SD_SysAddr
-			    || sd_ptr->offset > SD_MaxCurCap) {
-				sd_err(("%s: bad offset 0x%x\n", __func__,
-					sd_ptr->offset));
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			sd_trace(("%s: wreg%d value 0x%08x at offset %d\n",
-				  __func__, sd_ptr->value,
-				  (sd_ptr->offset & 1) ? 8
-				  : ((sd_ptr->offset & 2) ? 16 : 32),
-				  sd_ptr->offset));
-			break;
-		}
-
 	case IOV_GVAL(IOV_DEVREG):
 		{
 			sdreg_t *sd_ptr = (sdreg_t *) params;
-- 
1.7.4.1


