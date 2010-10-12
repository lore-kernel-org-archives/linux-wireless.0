Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0JLWKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 18:10:01 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so2776714bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 15:10:00 -0700 (PDT)
From: mike.rapoport@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 3/7] staging: brcm80211: remove osl_malloced()/MALLOCED()
Date: Wed, 13 Oct 2010 00:09:09 +0200
Message-Id: <75f45ad531317b75002fefe8ba82af6131516884.1286920620.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1286920620.git.mike.rapoport@gmail.com>
References: <cover.1286920620.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

because there are other means to track memory leaks in kernel

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    3 +--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    6 ++----
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    3 +--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |    4 ----
 drivers/staging/brcm80211/include/linux_osl.h     |    2 --
 drivers/staging/brcm80211/sys/wl_mac80211.c       |    9 ++-------
 drivers/staging/brcm80211/sys/wlc_alloc.c         |    3 +--
 drivers/staging/brcm80211/sys/wlc_ampdu.c         |    2 +-
 drivers/staging/brcm80211/sys/wlc_antsel.c        |    2 +-
 drivers/staging/brcm80211/sys/wlc_channel.c       |    3 +--
 drivers/staging/brcm80211/sys/wlc_phy_shim.c      |    2 +-
 drivers/staging/brcm80211/util/hnddma.c           |    7 +++----
 drivers/staging/brcm80211/util/linux_osl.c        |    6 ------
 drivers/staging/brcm80211/util/nicpci.c           |    3 +--
 drivers/staging/brcm80211/util/siutils.c          |    3 +--
 15 files changed, 16 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 42f1878..1b597e1 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -60,8 +60,7 @@ bcmsdh_info_t *bcmsdh_attach(osl_t *osh, void *cfghdl, void **regsva, uint irq)
 
 	bcmsdh = (bcmsdh_info_t *) MALLOC(osh, sizeof(bcmsdh_info_t));
 	if (bcmsdh == NULL) {
-		BCMSDH_ERROR(("bcmsdh_attach: out of memory, "
-			"malloced %d bytes\n", MALLOCED(osh)));
+		BCMSDH_ERROR(("bcmsdh_attach: out of memory"));
 		return NULL;
 	}
 	bzero((char *)bcmsdh, sizeof(bcmsdh_info_t));
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index c6817b7..c6b9adc 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -197,8 +197,7 @@ int bcmsdh_probe(struct device *dev)
 	}
 	sdhc = MALLOC(osh, sizeof(bcmsdh_hc_t));
 	if (!sdhc) {
-		SDLX_MSG(("%s: out of memory, allocated %d bytes\n",
-			  __func__, MALLOCED(osh)));
+		SDLX_MSG(("%s: out of memory\n", __func__));
 		goto err;
 	}
 	bzero(sdhc, sizeof(bcmsdh_hc_t));
@@ -430,8 +429,7 @@ bcmsdh_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	sdhc = MALLOC(osh, sizeof(bcmsdh_hc_t));
 	if (!sdhc) {
-		SDLX_MSG(("%s: out of memory, allocated %d bytes\n",
-			  __func__, MALLOCED(osh)));
+		SDLX_MSG(("%s: out of memory\n", __func__));
 		goto err;
 	}
 	bzero(sdhc, sizeof(bcmsdh_hc_t));
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 05c89ad..b8003db 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -125,8 +125,7 @@ extern sdioh_info_t *sdioh_attach(osl_t *osh, void *bar0, uint irq)
 
 	sd = (sdioh_info_t *) MALLOC(osh, sizeof(sdioh_info_t));
 	if (sd == NULL) {
-		sd_err(("sdioh_attach: out of memory, malloced %d bytes\n",
-			MALLOCED(osh)));
+		sd_err(("sdioh_attach: out of memory\n"));
 		return NULL;
 	}
 	bzero((char *)sd, sizeof(sdioh_info_t));
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 3bc2c4d..224f426 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1823,10 +1823,6 @@ osl_t *dhd_osl_attach(void *pdev, uint bustype)
 
 void dhd_osl_detach(osl_t *osh)
 {
-	if (MALLOCED(osh)) {
-		DHD_ERROR(("%s: MEMORY LEAK %d bytes\n", __func__,
-			   MALLOCED(osh)));
-	}
 	osl_detach(osh);
 }
 
diff --git a/drivers/staging/brcm80211/include/linux_osl.h b/drivers/staging/brcm80211/include/linux_osl.h
index 006452e..9273301 100644
--- a/drivers/staging/brcm80211/include/linux_osl.h
+++ b/drivers/staging/brcm80211/include/linux_osl.h
@@ -96,10 +96,8 @@ typedef struct {
 
 #define MALLOC(osh, size)	osl_malloc((osh), (size))
 #define MFREE(osh, addr, size)	osl_mfree((osh), (addr), (size))
-#define MALLOCED(osh)		osl_malloced((osh))
 extern void *osl_malloc(osl_t *osh, uint size);
 extern void osl_mfree(osl_t *osh, void *addr, uint size);
-extern uint osl_malloced(osl_t *osh);
 
 #define NATIVE_MALLOC(osh, size)	kmalloc(size, GFP_ATOMIC)
 #define NATIVE_MFREE(osh, addr, size)	kfree(addr)
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index 7a3116b..e43f05a 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -1615,11 +1615,6 @@ void wl_free(wl_info_t *wl)
 	}
 #endif				/* WLC_HIGH_ONLY */
 
-	if (osl_malloced(osh)) {
-		printf("****   Memory leak of bytes %d\n", osl_malloced(osh));
-		ASSERT(0 && "Memory Leak");
-	}
-
 	osl_detach(osh);
 }
 
@@ -1664,7 +1659,7 @@ wl_schedule_task(wl_info_t *wl, void (*fn) (struct wl_task *task),
 
 	task = osl_malloc(wl->osh, sizeof(wl_task_t));
 	if (!task) {
-		WL_ERROR(("wl%d: wl_schedule_task: out of memory, malloced %d bytes\n", wl->pub->unit, osl_malloced(wl->osh)));
+		WL_ERROR(("wl%d: wl_schedule_task: out of memory\n", wl->pub->unit));
 		return -ENOMEM;
 	}
 
@@ -1918,7 +1913,7 @@ wl_timer_t *wl_init_timer(wl_info_t *wl, void (*fn) (void *arg), void *arg,
 
 	t = osl_malloc(wl->osh, sizeof(wl_timer_t));
 	if (!t) {
-		WL_ERROR(("wl%d: wl_init_timer: out of memory, malloced %d bytes\n", wl->pub->unit, osl_malloced(wl->osh)));
+		WL_ERROR(("wl%d: wl_init_timer: out of memory\n", wl->pub->unit));
 		return 0;
 	}
 
diff --git a/drivers/staging/brcm80211/sys/wlc_alloc.c b/drivers/staging/brcm80211/sys/wlc_alloc.c
index 9c902d7..e637e62 100644
--- a/drivers/staging/brcm80211/sys/wlc_alloc.c
+++ b/drivers/staging/brcm80211/sys/wlc_alloc.c
@@ -39,8 +39,7 @@ void *wlc_calloc(osl_t *osh, uint unit, uint size)
 
 	item = MALLOC(osh, size);
 	if (item == NULL)
-		WL_ERROR(("wl%d: %s: out of memory, malloced %d bytes\n",
-			  unit, __func__, MALLOCED(osh)));
+		WL_ERROR(("wl%d: %s: out of memory\n", unit, __func__));
 	else
 		bzero((char *)item, size);
 	return item;
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index 0987e51..26bc9cc 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -181,7 +181,7 @@ ampdu_info_t *wlc_ampdu_attach(wlc_info_t *wlc)
 
 	ampdu = (ampdu_info_t *) MALLOC(wlc->osh, sizeof(ampdu_info_t));
 	if (!ampdu) {
-		WL_ERROR(("wl%d: wlc_ampdu_attach: out of mem, malloced %d bytes\n", wlc->pub->unit, MALLOCED(wlc->osh)));
+		WL_ERROR(("wl%d: wlc_ampdu_attach: out of mem\n", wlc->pub->unit));
 		return NULL;
 	}
 	bzero((char *)ampdu, sizeof(ampdu_info_t));
diff --git a/drivers/staging/brcm80211/sys/wlc_antsel.c b/drivers/staging/brcm80211/sys/wlc_antsel.c
index 671a0aa..ee1cefd 100644
--- a/drivers/staging/brcm80211/sys/wlc_antsel.c
+++ b/drivers/staging/brcm80211/sys/wlc_antsel.c
@@ -96,7 +96,7 @@ antsel_info_t *wlc_antsel_attach(wlc_info_t *wlc, osl_t *osh,
 
 	asi = (antsel_info_t *) MALLOC(osh, sizeof(antsel_info_t));
 	if (!asi) {
-		WL_ERROR(("wl%d: wlc_antsel_attach: out of mem, malloced %d bytes\n", pub->unit, MALLOCED(osh)));
+		WL_ERROR(("wl%d: wlc_antsel_attach: out of mem\n", pub->unit));
 		return NULL;
 	}
 
diff --git a/drivers/staging/brcm80211/sys/wlc_channel.c b/drivers/staging/brcm80211/sys/wlc_channel.c
index ae152bb..f62144a 100644
--- a/drivers/staging/brcm80211/sys/wlc_channel.c
+++ b/drivers/staging/brcm80211/sys/wlc_channel.c
@@ -614,8 +614,7 @@ wlc_cm_info_t *wlc_channel_mgr_attach(wlc_info_t *wlc)
 
 	wlc_cm = (wlc_cm_info_t *) MALLOC(pub->osh, sizeof(wlc_cm_info_t));
 	if (wlc_cm == NULL) {
-		WL_ERROR(("wl%d: %s: out of memory, malloced %d bytes",
-			  pub->unit, __func__, MALLOCED(pub->osh)));
+		WL_ERROR(("wl%d: %s: out of memory", pub->unit, __func__));
 		return NULL;
 	}
 	bzero((char *)wlc_cm, sizeof(wlc_cm_info_t));
diff --git a/drivers/staging/brcm80211/sys/wlc_phy_shim.c b/drivers/staging/brcm80211/sys/wlc_phy_shim.c
index 7c8193a..37bb593 100644
--- a/drivers/staging/brcm80211/sys/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/sys/wlc_phy_shim.c
@@ -69,7 +69,7 @@ wlc_phy_shim_info_t *wlc_phy_shim_attach(wlc_hw_info_t *wlc_hw,
 	physhim = (wlc_phy_shim_info_t *)MALLOC(wlc_hw->osh,
 		sizeof(wlc_phy_shim_info_t));
 	if (!physhim) {
-		WL_ERROR(("wl%d: wlc_phy_shim_attach: out of mem, malloced %d bytes\n", wlc_hw->unit, MALLOCED(wlc_hw->osh)));
+		WL_ERROR(("wl%d: wlc_phy_shim_attach: out of mem\n", wlc_hw->unit));
 		return NULL;
 	}
 	bzero((char *)physhim, sizeof(wlc_phy_shim_info_t));
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index 4276f24..cb99a23 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -381,8 +381,7 @@ hnddma_t *dma_attach(osl_t *osh, char *name, si_t *sih, void *dmaregstx,
 	di = MALLOC(osh, sizeof(dma_info_t));
 	if (di == NULL) {
 #ifdef BCMDBG
-		printf("dma_attach: out of memory, malloced %d bytes\n",
-		       MALLOCED(osh));
+		printf("dma_attach: out of memory\n");
 #endif
 		return NULL;
 	}
@@ -517,7 +516,7 @@ hnddma_t *dma_attach(osl_t *osh, char *name, si_t *sih, void *dmaregstx,
 		size = ntxd * sizeof(void *);
 		di->txp = MALLOC(osh, size);
 		if (di->txp == NULL) {
-			DMA_ERROR(("%s: dma_attach: out of tx memory, malloced %d bytes\n", di->name, MALLOCED(osh)));
+			DMA_ERROR(("%s: dma_attach: out of tx memory\n", di->name));
 			goto fail;
 		}
 		bzero((char *)di->txp, size);
@@ -528,7 +527,7 @@ hnddma_t *dma_attach(osl_t *osh, char *name, si_t *sih, void *dmaregstx,
 		size = nrxd * sizeof(void *);
 		di->rxp = MALLOC(osh, size);
 		if (di->rxp == NULL) {
-			DMA_ERROR(("%s: dma_attach: out of rx memory, malloced %d bytes\n", di->name, MALLOCED(osh)));
+			DMA_ERROR(("%s: dma_attach: out of rx memory\n", di->name));
 			goto fail;
 		}
 		bzero((char *)di->rxp, size);
diff --git a/drivers/staging/brcm80211/util/linux_osl.c b/drivers/staging/brcm80211/util/linux_osl.c
index 15c236a..7f4da18 100644
--- a/drivers/staging/brcm80211/util/linux_osl.c
+++ b/drivers/staging/brcm80211/util/linux_osl.c
@@ -314,12 +314,6 @@ void osl_mfree(osl_t *osh, void *addr, uint size)
 	kfree(addr);
 }
 
-uint osl_malloced(osl_t *osh)
-{
-	ASSERT((osh && (osh->magic == OS_HANDLE_MAGIC)));
-	return osh->malloced;
-}
-
 uint osl_dma_consistent_align(void)
 {
 	return PAGE_SIZE;
diff --git a/drivers/staging/brcm80211/util/nicpci.c b/drivers/staging/brcm80211/util/nicpci.c
index cc031bd..1c7a21c 100644
--- a/drivers/staging/brcm80211/util/nicpci.c
+++ b/drivers/staging/brcm80211/util/nicpci.c
@@ -117,8 +117,7 @@ void *pcicore_init(si_t *sih, osl_t *osh, void *regs)
 	/* alloc pcicore_info_t */
 	pi = MALLOC(osh, sizeof(pcicore_info_t));
 	if (pi == NULL) {
-		PCI_ERROR(("pci_attach: malloc failed! malloced %d bytes\n",
-			   MALLOCED(osh)));
+		PCI_ERROR(("pci_attach: malloc failed!\n"));
 		return NULL;
 	}
 
diff --git a/drivers/staging/brcm80211/util/siutils.c b/drivers/staging/brcm80211/util/siutils.c
index dc1dd39..ec21dbd 100644
--- a/drivers/staging/brcm80211/util/siutils.c
+++ b/drivers/staging/brcm80211/util/siutils.c
@@ -90,8 +90,7 @@ si_t *si_attach(uint devid, osl_t *osh, void *regs, uint bustype, void *sdh,
 	/* alloc si_info_t */
 	sii = MALLOC(osh, sizeof(si_info_t));
 	if (sii == NULL) {
-		SI_ERROR(("si_attach: malloc failed! malloced %d bytes\n",
-			  MALLOCED(osh)));
+		SI_ERROR(("si_attach: malloc failed!\n"));
 		return NULL;
 	}
 
-- 
1.6.4.4

