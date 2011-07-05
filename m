Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3148 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab1GEUGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 04/21] staging: brcm80211: removed
 brcmf_sdioh_reset()
Date: Tue, 5 Jul 2011 22:06:00 +0200
Message-ID: <1309896377-4425-5-git-send-email-arend@broadcom.com> (sfid-20110705_220657_232457_E4697967)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. This function did not perform a reset, hence it was removed.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h     |    3 ---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    5 -----
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    8 --------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    2 --
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    3 ---
 5 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 656caeb..eb08152 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -97,9 +97,6 @@ extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
 extern int brcmf_sdioh_start(struct sdioh_info *si, int stage);
 extern int brcmf_sdioh_stop(struct sdioh_info *si);
 
-/* Reset and re-initialize the device */
-extern int brcmf_sdioh_reset(struct sdioh_info *si);
-
 /* Helper function */
 void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 132b18f..11abd55 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -545,11 +545,6 @@ uint brcmf_sdcard_query_iofnum(struct brcmf_sdio_card *card)
 	return brcmf_sdioh_query_iofnum(card->sdioh);
 }
 
-int brcmf_sdcard_reset(struct brcmf_sdio_card *card)
-{
-	return brcmf_sdioh_reset(card->sdioh);
-}
-
 void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card)
 {
 	ASSERT(card);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 092d044..0f0dc42 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -846,14 +846,6 @@ extern int brcmf_sdioh_abort(struct sdioh_info *sd, uint func)
 	return 0;
 }
 
-/* Reset and re-initialize the device */
-int brcmf_sdioh_reset(struct sdioh_info *si)
-{
-	sd_trace(("%s: Enter\n", __func__));
-	sd_trace(("%s: Exit\n", __func__));
-	return 0;
-}
-
 /* Disable device interrupt */
 void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index e43c53a7..4b0352f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -6013,8 +6013,6 @@ int brcmf_bus_devreset(struct brcmf_pub *dhdp, u8 flag)
 
 		if (bus->dhd->dongle_reset) {
 			/* Turn on WLAN */
-			/* Reset SD client */
-			brcmf_sdcard_reset(bus->card);
 
 			/* Attempt to re-attach & download */
 			if (brcmf_sdbrcm_probe_attach(bus, bus->card,
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index f05067a..df4063c 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -207,9 +207,6 @@ extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 				 void *params, int plen, void *arg, int len,
 				 bool set);
 
-/* Reset and reinitialize the device */
-extern int brcmf_sdcard_reset(struct brcmf_sdio_card *card);
-
 /* helper functions */
 
 extern void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card);
-- 
1.7.4.1


