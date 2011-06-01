Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2226 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161215Ab1FALqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/83] staging: brcm80211: remove iovars IOV_BLOCKMODE
Date: Wed, 1 Jun 2011 13:44:57 +0200
Message-ID: <1306928768-7501-12-git-send-email-rvossen@broadcom.com> (sfid-20110601_134630_719945_618D02C0)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unused sdio related iovars IOV_BLCOKMODE for fullmac driver

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index c0ffbd3..4b13f42 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -138,7 +138,6 @@ sdioh_info_t *sdioh_attach(void *bar0, uint irq)
 	}
 
 	sd->num_funcs = 2;
-	sd->sd_blockmode = true;
 	sd->use_client_ints = true;
 	sd->client_block_size[0] = 64;
 
@@ -352,7 +351,6 @@ uint sdioh_query_iofnum(sdioh_info_t *sd)
 /* IOVar table */
 enum {
 	IOV_MSGLEVEL = 1,
-	IOV_BLOCKMODE,
 	IOV_BLOCKSIZE,
 	IOV_DMA,
 	IOV_USEINTS,
@@ -371,7 +369,6 @@ enum {
 
 const bcm_iovar_t sdioh_iovars[] = {
 	{"sd_msglevel", IOV_MSGLEVEL, 0, IOVT_UINT32, 0},
-	{"sd_blockmode", IOV_BLOCKMODE, 0, IOVT_BOOL, 0},
 	{"sd_blocksize", IOV_BLOCKSIZE, 0, IOVT_UINT32, 0},/* ((fn << 16) |
 								 size) */
 	{"sd_dma", IOV_DMA, 0, IOVT_BOOL, 0},
@@ -457,16 +454,6 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 		sd_msglevel = int_val;
 		break;
 
-	case IOV_GVAL(IOV_BLOCKMODE):
-		int_val = (s32) si->sd_blockmode;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_BLOCKMODE):
-		si->sd_blockmode = (bool) int_val;
-		/* Haven't figured out how to make non-block mode with DMA */
-		break;
-
 	case IOV_GVAL(IOV_BLOCKSIZE):
 		if ((u32) int_val > si->num_funcs) {
 			bcmerror = -EINVAL;
-- 
1.7.4.1


