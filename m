Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3144 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab1GEUGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 05/21] staging: brcm80211: removed
 brcmf_sdioh_start() and brcmf_sdioh_stop()
Date: Tue, 5 Jul 2011 22:06:01 +0200
Message-ID: <1309896377-4425-6-git-send-email-arend@broadcom.com> (sfid-20110705_220701_197396_93136C2E)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. These functions were empty.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h     |    4 ----
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   10 ----------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   10 ----------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    6 ------
 4 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index eb08152..761ec20 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -93,10 +93,6 @@ extern int brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 /* Issue abort to the specified function and clear controller as needed */
 extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
 
-/* Start and Stop SDIO without re-enumerating the SD card. */
-extern int brcmf_sdioh_start(struct sdioh_info *si, int stage);
-extern int brcmf_sdioh_stop(struct sdioh_info *si);
-
 /* Helper function */
 void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 11abd55..09bad40 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -521,16 +521,6 @@ int brcmf_sdcard_abort(struct brcmf_sdio_card *card, uint fn)
 	return brcmf_sdioh_abort(card->sdioh, fn);
 }
 
-int brcmf_sdcard_start(struct brcmf_sdio_card *card, int stage)
-{
-	return brcmf_sdioh_start(card->sdioh, stage);
-}
-
-int brcmf_sdcard_stop(struct brcmf_sdio_card *card)
-{
-	return brcmf_sdioh_stop(card->sdioh);
-}
-
 int brcmf_sdcard_query_device(struct brcmf_sdio_card *card)
 {
 	card->vendevid = (PCI_VENDOR_ID_BROADCOM << 16) | 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 0f0dc42..7da200f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -921,13 +921,3 @@ static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func)
 
 	ASSERT(sd != NULL);
 }
-
-int brcmf_sdioh_start(struct sdioh_info *si, int stage)
-{
-	return 0;
-}
-
-int brcmf_sdioh_stop(struct sdioh_info *si)
-{
-	return 0;
-}
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index df4063c..712d0df 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -190,12 +190,6 @@ extern int brcmf_sdcard_rwdata(struct brcmf_sdio_card *card, uint rw, u32 addr,
 /* Issue an abort to the specified function */
 extern int brcmf_sdcard_abort(struct brcmf_sdio_card *card, uint fn);
 
-/* Start SDIO Host Controller communication */
-extern int brcmf_sdcard_start(struct brcmf_sdio_card *card, int stage);
-
-/* Stop SDIO Host Controller communication */
-extern int brcmf_sdcard_stop(struct brcmf_sdio_card *card);
-
 /* Returns the "Device ID" of target device on the SDIO bus. */
 extern int brcmf_sdcard_query_device(struct brcmf_sdio_card *card);
 
-- 
1.7.4.1


