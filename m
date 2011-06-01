Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3784 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161136Ab1FALqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:20 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/83] staging: brcm80211: remove iovars IOV_DMA
Date: Wed, 1 Jun 2011 13:44:58 +0200
Message-ID: <1306928768-7501-13-git-send-email-rvossen@broadcom.com> (sfid-20110601_134624_244294_718333EC)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unused sdio related iovars IOV_DMA for fullmac driver

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   12 ------------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h |    1 -
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 4b13f42..a0f2463 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -54,7 +54,6 @@ uint sd_power = 1;		/* Default to SD Slot powered ON */
 uint sd_clock = 1;		/* Default to SD Clock turned ON */
 uint sd_hiok = false;		/* Don't use hi-speed mode by default */
 uint sd_msglevel = 0x01;
-uint sd_use_dma = true;
 DHD_PM_RESUME_WAIT_INIT(sdioh_request_byte_wait);
 DHD_PM_RESUME_WAIT_INIT(sdioh_request_word_wait);
 DHD_PM_RESUME_WAIT_INIT(sdioh_request_packet_wait);
@@ -352,7 +351,6 @@ uint sdioh_query_iofnum(sdioh_info_t *sd)
 enum {
 	IOV_MSGLEVEL = 1,
 	IOV_BLOCKSIZE,
-	IOV_DMA,
 	IOV_USEINTS,
 	IOV_NUMINTS,
 	IOV_NUMLOCALINTS,
@@ -371,7 +369,6 @@ const bcm_iovar_t sdioh_iovars[] = {
 	{"sd_msglevel", IOV_MSGLEVEL, 0, IOVT_UINT32, 0},
 	{"sd_blocksize", IOV_BLOCKSIZE, 0, IOVT_UINT32, 0},/* ((fn << 16) |
 								 size) */
-	{"sd_dma", IOV_DMA, 0, IOVT_BOOL, 0},
 	{"sd_ints", IOV_USEINTS, 0, IOVT_BOOL, 0},
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
 	{"sd_numlocalints", IOV_NUMLOCALINTS, 0, IOVT_UINT32, 0},
@@ -505,15 +502,6 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 		memcpy(arg, &int_val, val_size);
 		break;
 
-	case IOV_GVAL(IOV_DMA):
-		int_val = (s32) si->sd_use_dma;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_DMA):
-		si->sd_use_dma = (bool) int_val;
-		break;
-
 	case IOV_GVAL(IOV_USEINTS):
 		int_val = (s32) si->use_client_ints;
 		memcpy(arg, &int_val, val_size);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index 3ef42b3..86f88bf 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -85,7 +85,6 @@ struct sdioh_info {
 
 	uint irq;		/* Client irq */
 	int intrcount;		/* Client interrupts */
-	bool sd_use_dma;	/* DMA on CMD53 */
 	bool sd_blockmode;	/* sd_blockmode == false => 64 Byte Cmd 53s. */
 	/*  Must be on for sd_multiblock to be effective */
 	bool use_client_ints;	/* If this is false, make sure to restore */
-- 
1.7.4.1


