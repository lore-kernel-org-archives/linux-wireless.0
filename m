Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1911 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022Ab1F2Xsv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:51 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 058/119] staging: brcm80211: replaced typedef by struct
 for several sdio types
Date: Wed, 29 Jun 2011 16:47:22 -0700
Message-ID: <1309391303-22741-59-git-send-email-frankyl@broadcom.com> (sfid-20110630_015113_347101_5177B3F2)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |   16 +++++++---------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    2 +-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    6 +++---
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 66d81d1..a2408ec 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -49,10 +49,8 @@ extern void brcmf_sdbrcm_isr(void *args);
 /**
  * SDIO Host Controller info
  */
-typedef struct bcmsdh_hc bcmsdh_hc_t;
-
 struct bcmsdh_hc {
-	bcmsdh_hc_t *next;
+	struct bcmsdh_hc *next;
 #ifdef BCMPLATFORM_BUS
 	struct device *dev;	/* platform device handle */
 #else
@@ -69,10 +67,10 @@ struct bcmsdh_hc {
 	spinlock_t irq_lock;
 #endif
 };
-static bcmsdh_hc_t *sdhcinfo;
+static struct bcmsdh_hc *sdhcinfo;
 
 /* driver info, initialized when brcmf_sdio_register is called */
-static bcmsdh_driver_t drvinfo = { NULL, NULL };
+static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
 
 /* debugging macros */
 #define SDLX_MSG(x)
@@ -142,7 +140,7 @@ static
 #endif				/* BCMLXSDMMC */
 int brcmf_sdio_probe(struct device *dev)
 {
-	bcmsdh_hc_t *sdhc = NULL;
+	struct bcmsdh_hc *sdhc = NULL;
 	unsigned long regs = 0;
 	struct brcmf_sdio *sdh = NULL;
 #if !defined(BCMLXSDMMC) && defined(BCMPLATFORM_BUS)
@@ -176,7 +174,7 @@ int brcmf_sdio_probe(struct device *dev)
 	}
 #endif				/* defined(OOB_INTR_ONLY) */
 	/* allocate SDIO Host Controller state info */
-	sdhc = kzalloc(sizeof(bcmsdh_hc_t), GFP_ATOMIC);
+	sdhc = kzalloc(sizeof(struct bcmsdh_hc), GFP_ATOMIC);
 	if (!sdhc) {
 		SDLX_MSG(("%s: out of memory\n", __func__));
 		goto err;
@@ -236,7 +234,7 @@ static
 #endif				/* BCMLXSDMMC */
 int brcmf_sdio_remove(struct device *dev)
 {
-	bcmsdh_hc_t *sdhc, *prev;
+	struct bcmsdh_hc *sdhc, *prev;
 
 	sdhc = sdhcinfo;
 	drvinfo.detach(sdhc->ch);
@@ -271,7 +269,7 @@ int brcmf_sdio_remove(struct device *dev)
 
 extern int brcmf_sdio_function_init(void);
 
-int brcmf_sdio_register(bcmsdh_driver_t *driver)
+int brcmf_sdio_register(struct brcmf_sdioh_driver *driver)
 {
 	drvinfo = *driver;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 2ede425..c00f0f2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -5632,7 +5632,7 @@ static void brcmf_sdbrcm_disconnect(void *ptr)
  * order to look for or await the device.
  */
 
-static bcmsdh_driver_t dhd_sdio = {
+static struct brcmf_sdioh_driver dhd_sdio = {
 	brcmf_sdbrcm_probe,
 	brcmf_sdbrcm_disconnect
 };
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index c7d60ca..b7e0754 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -201,16 +201,16 @@ extern int brcmf_sdcard_reset(struct brcmf_sdio *sdh);
 extern void *brcmf_sdcard_get_sdioh(struct brcmf_sdio *sdh);
 
 /* callback functions */
-typedef struct {
+struct brcmf_sdioh_driver {
 	/* attach to device */
 	void *(*attach) (u16 vend_id, u16 dev_id, u16 bus, u16 slot,
 			 u16 func, uint bustype, void *regsva, void *param);
 	/* detach from device */
 	void (*detach) (void *ch);
-} bcmsdh_driver_t;
+};
 
 /* platform specific/high level functions */
-extern int brcmf_sdio_register(bcmsdh_driver_t *driver);
+extern int brcmf_sdio_register(struct brcmf_sdioh_driver *driver);
 extern void brcmf_sdio_unregister(void);
 extern bool brcmf_sdio_chipmatch(u16 vendor, u16 device);
 extern void brcmf_sdio_device_remove(void *sdh);
-- 
1.7.1


