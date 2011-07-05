Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3143 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab1GEUGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 03/21] staging: brcm80211: removed
 brcmf_sdioh_interrupt_pending()
Date: Tue, 5 Jul 2011 22:05:59 +0200
Message-ID: <1309896377-4425-4-git-send-email-arend@broadcom.com> (sfid-20110705_220652_773179_56A30B76)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. This function always returned 0.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h     |    4 ----
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    8 --------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    7 -------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    3 +--
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    5 -----
 5 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index ee01e48..656caeb 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -53,10 +53,6 @@ brcmf_sdioh_interrupt_query(struct sdioh_info *si, bool *onoff);
 extern int
 brcmf_sdioh_interrupt_set(struct sdioh_info *si, bool enable_disable);
 
-#if defined(BCMDBG)
-extern bool brcmf_sdioh_interrupt_pending(struct sdioh_info *si);
-#endif
-
 extern int brcmf_sdioh_claim_host_and_lock(struct sdioh_info *si);
 extern int brcmf_sdioh_release_host_and_unlock(struct sdioh_info *si);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 4c7e4a9..132b18f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -138,14 +138,6 @@ int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card)
 	return brcmf_sdioh_interrupt_deregister(card->sdioh);
 }
 
-#if defined(BCMDBG)
-bool brcmf_sdcard_intr_pending(struct brcmf_sdio_card *card)
-{
-	ASSERT(card);
-	return brcmf_sdioh_interrupt_pending(card->sdioh);
-}
-#endif
-
 int brcmf_sdcard_devremove_reg(struct brcmf_sdio_card *card,
 			       brcmf_sdiocard_cb_fn_t fn,
 			       void *argh)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index d0e9b3d..092d044 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -244,13 +244,6 @@ brcmf_sdioh_interrupt_query(struct sdioh_info *sd, bool *onoff)
 	return 0;
 }
 
-#if defined(BCMDBG)
-extern bool brcmf_sdioh_interrupt_pending(struct sdioh_info *sd)
-{
-	return 0;
-}
-#endif
-
 uint brcmf_sdioh_query_iofnum(struct sdioh_info *sd)
 {
 	return sd->num_funcs;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 3ed9e12..e43c53a7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1889,8 +1889,7 @@ void brcmf_sdbrcm_bus_dump(struct brcmf_pub *dhdp, struct brcmu_strbuf *strbuf)
 #endif				/* SDTEST */
 #ifdef BCMDBG
 	brcmu_bprintf(strbuf, "dpc_sched %d host interrupt%spending\n",
-		    bus->dpc_sched,
-		    (brcmf_sdcard_intr_pending(bus->card) ? " " : " not "));
+		      bus->dpc_sched, " not ");
 	brcmu_bprintf(strbuf, "blocksize %d roundup %d\n", bus->blocksize,
 		    bus->roundup);
 #endif				/* BCMDBG */
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 5c5bbca..f05067a 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -93,11 +93,6 @@ brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card, brcmf_sdiocard_cb_fn_t fn,
 
 extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card);
 
-#if defined(BCMDBG)
-/* Query pending interrupt status from the host controller */
-extern bool brcmf_sdcard_intr_pending(struct brcmf_sdio_card *card);
-#endif
-
 /* Register a callback to be called on device removal.
  * No-op in the case of non-removable/hardwired devices.
  */
-- 
1.7.4.1


