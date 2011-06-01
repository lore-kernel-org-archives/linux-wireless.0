Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4854 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 14/83] staging: brcm80211: remove iovars
 IOV_NUMLOCALINTS
Date: Wed, 1 Jun 2011 13:44:59 +0200
Message-ID: <1306928768-7501-14-git-send-email-rvossen@broadcom.com> (sfid-20110601_134820_008145_2E846D11)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unused sdio related iovars IOV_NUMLOCALINTS for fullmac driver

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index a0f2463..44b1371 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -353,7 +353,6 @@ enum {
 	IOV_BLOCKSIZE,
 	IOV_USEINTS,
 	IOV_NUMINTS,
-	IOV_NUMLOCALINTS,
 	IOV_HOSTREG,
 	IOV_DEVREG,
 	IOV_DIVISOR,
@@ -371,7 +370,6 @@ const bcm_iovar_t sdioh_iovars[] = {
 								 size) */
 	{"sd_ints", IOV_USEINTS, 0, IOVT_BOOL, 0},
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
-	{"sd_numlocalints", IOV_NUMLOCALINTS, 0, IOVT_UINT32, 0},
 	{"sd_hostreg", IOV_HOSTREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
 	,
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(sdreg_t)}
@@ -566,11 +564,6 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 		memcpy(arg, &int_val, val_size);
 		break;
 
-	case IOV_GVAL(IOV_NUMLOCALINTS):
-		int_val = (s32) 0;
-		memcpy(arg, &int_val, val_size);
-		break;
-
 	case IOV_GVAL(IOV_HOSTREG):
 		{
 			sdreg_t *sd_ptr = (sdreg_t *) params;
-- 
1.7.4.1


