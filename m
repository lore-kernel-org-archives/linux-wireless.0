Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2095 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 068/119] staging: brcm80211: remove MMC_SDIO_ABORT macro
 definition
Date: Wed, 29 Jun 2011 16:47:32 -0700
Message-ID: <1309391303-22741-69-git-send-email-frankyl@broadcom.com> (sfid-20110630_015035_177115_38177C12)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The fullmac driver is always needing the code conditionalized with
MMC_SDIO_ABORT macro so the macro has been removed and the code
is always compiled in.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile       |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    6 ------
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 2ccfa1f..c97e5bb 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -21,7 +21,6 @@ ccflags-y :=			\
 	-DBRCMF_FIRSTREAD=64	\
 	-DBRCMF_SDALIGN=64	\
 	-DMAX_HDR_READ=64	\
-	-DMMC_SDIO_ABORT	\
 	-DSHOW_EVENTS		\
 	-DTOE
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index c814701..5e52813 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -667,7 +667,6 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 					sdio_release_host(gInstance->func[2]);
 				}
 			}
-#if defined(MMC_SDIO_ABORT)
 			/* to allow abort command through F1 */
 			else if (regaddr == SDIO_CCCR_ABORT) {
 				sdio_claim_host(gInstance->func[func]);
@@ -681,7 +680,6 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 					    regaddr, &err_ret);
 				sdio_release_host(gInstance->func[func]);
 			}
-#endif				/* MMC_SDIO_ABORT */
 			else if (regaddr < 0xF0) {
 				sd_err(("bcmsdh_sdmmc: F0 Wr:0x%02x: write "
 					"disallowed\n", regaddr));
@@ -951,16 +949,12 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 /* this function performs "abort" for both of host & device */
 extern int brcmf_sdioh_abort(struct sdioh_info *sd, uint func)
 {
-#if defined(MMC_SDIO_ABORT)
 	char t_func = (char)func;
-#endif				/* defined(MMC_SDIO_ABORT) */
 	sd_trace(("%s: Enter\n", __func__));
 
-#if defined(MMC_SDIO_ABORT)
 	/* issue abort cmd52 command through F0 */
 	brcmf_sdioh_request_byte(sd, SDIOH_WRITE, SDIO_FUNC_0, SDIO_CCCR_ABORT,
 			   &t_func);
-#endif				/* defined(MMC_SDIO_ABORT) */
 
 	sd_trace(("%s: Exit\n", __func__));
 	return SDIOH_API_RC_SUCCESS;
-- 
1.7.1


