Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4456 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952Ab1F2Xsq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:46 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 064/119] staging: brcm80211: remove BCMLXSDMMC macro
 definition
Date: Wed, 29 Jun 2011 16:47:28 -0700
Message-ID: <1309391303-22741-65-git-send-email-frankyl@broadcom.com> (sfid-20110630_015017_067489_C82E2054)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The conditional code depending on BCMLXSDMMC macro definition is
always compiled into the fullmac driver.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile        |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |   39 +-------------------
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    9 +----
 4 files changed, 2 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 95d3147..f76e62a 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -16,7 +16,6 @@
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 ccflags-y :=			\
-	-DBCMLXSDMMC		\
 	-DBCMPLATFORM_BUS	\
 	-DBCMSDIO		\
 	-DBRCM_FULLMAC		\
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index a2408ec..5243f33 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -121,7 +121,6 @@ bool brcmf_sdio_chipmatch(u16 vendor, u16 device)
 }
 
 #if defined(BCMPLATFORM_BUS)
-#if defined(BCMLXSDMMC)
 /* forward declarations */
 int brcmf_sdio_probe(struct device *dev);
 EXPORT_SYMBOL(brcmf_sdio_probe);
@@ -129,36 +128,15 @@ EXPORT_SYMBOL(brcmf_sdio_probe);
 int brcmf_sdio_remove(struct device *dev);
 EXPORT_SYMBOL(brcmf_sdio_remove);
 
-#else
-/* forward declarations */
-static int __devinit brcmf_sdio_probe(struct device *dev);
-static int __devexit brcmf_sdio_remove(struct device *dev);
-#endif				/* BCMLXSDMMC */
-
-#ifndef BCMLXSDMMC
-static
-#endif				/* BCMLXSDMMC */
 int brcmf_sdio_probe(struct device *dev)
 {
 	struct bcmsdh_hc *sdhc = NULL;
 	unsigned long regs = 0;
 	struct brcmf_sdio *sdh = NULL;
-#if !defined(BCMLXSDMMC) && defined(BCMPLATFORM_BUS)
-	struct platform_device *pdev;
-	struct resource *r;
-#endif				/* BCMLXSDMMC */
 	int irq = 0;
 	u32 vendevid;
 	unsigned long irq_flags = 0;
 
-#if !defined(BCMLXSDMMC) && defined(BCMPLATFORM_BUS)
-	pdev = to_platform_device(dev);
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	irq = platform_get_irq(pdev, 0);
-	if (!r || irq == NO_IRQ)
-		return -ENXIO;
-#endif				/* BCMLXSDMMC */
-
 #if defined(OOB_INTR_ONLY)
 #ifdef HW_OOB
 	irq_flags =
@@ -181,19 +159,12 @@ int brcmf_sdio_probe(struct device *dev)
 	}
 	sdhc->dev = (void *)dev;
 
-#ifdef BCMLXSDMMC
 	sdh = brcmf_sdcard_attach((void *)0, (void **)&regs, irq);
 	if (!sdh) {
 		SDLX_MSG(("%s: bcmsdh_attach failed\n", __func__));
 		goto err;
 	}
-#else
-	sdh = brcmf_sdcard_attach((void *)r->start, (void **)&regs, irq);
-	if (!sdh) {
-		SDLX_MSG(("%s: bcmsdh_attach failed\n", __func__));
-		goto err;
-	}
-#endif				/* BCMLXSDMMC */
+
 	sdhc->sdh = sdh;
 	sdhc->oob_irq = irq;
 	sdhc->oob_flags = irq_flags;
@@ -229,9 +200,6 @@ err:
 	return -ENODEV;
 }
 
-#ifndef BCMLXSDMMC
-static
-#endif				/* BCMLXSDMMC */
 int brcmf_sdio_remove(struct device *dev)
 {
 	struct bcmsdh_hc *sdhc, *prev;
@@ -258,11 +226,6 @@ int brcmf_sdio_remove(struct device *dev)
 
 	/* release SDIO Host Controller info */
 	kfree(sdhc);
-
-#if !defined(BCMLXSDMMC)
-	dev_set_drvdata(dev, NULL);
-#endif				/* !defined(BCMLXSDMMC) */
-
 	return 0;
 }
 #endif				/* BCMPLATFORM_BUS */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index a60caea..6fd1072 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -38,9 +38,7 @@ int wifi_get_irq_number(unsigned long *irq_flags_ptr);
 
 #if defined(OOB_INTR_ONLY)
 
-#if defined(BCMLXSDMMC)
 extern int sdioh_mmc_irq(int irq);
-#endif				/* (BCMLXSDMMC)  */
 
 #ifdef CUSTOMER_HW3
 #include <mach/gpio.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 2b1762e..afb840a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -923,14 +923,7 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		DHD_INFO(("CLKCTL: turned ON\n"));
 
 #if defined(DHD_DEBUG)
-		if (bus->alp_only == true) {
-#if !defined(BCMLXSDMMC)
-			if (!SBSDIO_ALPONLY(clkctl)) {
-				DHD_ERROR(("%s: HT Clock, when ALP Only\n",
-					   __func__));
-			}
-#endif				/* !defined(BCMLXSDMMC) */
-		} else {
+		if (bus->alp_only != true) {
 			if (SBSDIO_ALPONLY(clkctl)) {
 				DHD_ERROR(("%s: HT Clock should be on.\n",
 					   __func__));
-- 
1.7.1


