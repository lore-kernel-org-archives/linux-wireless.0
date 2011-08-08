Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2817 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab1HHN7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:31 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 48/82] staging: brcm80211: remove structure sdio_hc in
 brcmfmac
Date: Mon, 8 Aug 2011 15:58:32 +0200
Message-ID: <1312811946-16713-49-git-send-email-arend@broadcom.com> (sfid-20110808_160114_436583_40CEBF14)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Most members in sdio_hc are no longer needed anymore. And fullmac
is keeping a global pointer of this structure. This patch deletes
the structure and places the useful member to a new structure
brcmf_sdio_dev. The pointer of brcmf_sdio_dev will be save in the
private driver data during sdio_probe. Therefore, we don't need to
keep the global pointer.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   90 ++++-----------------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   41 ++++++++--
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   18 +++-
 3 files changed, 61 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 310d4fd..7b66787 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -74,25 +74,8 @@ struct brcmf_sdio_card {
 	u32 sbwad;		/* Save backplane window address */
 };
 
-/**
- * SDIO Host Controller info
- */
-struct sdio_hc {
-	struct sdio_hc *next;
-	struct device *dev;	/* platform device handle */
-	void *regs;		/* SDIO Host Controller address */
-	struct brcmf_sdio_card *card;
-	void *ch;
-	unsigned int oob_irq;
-	unsigned long oob_flags;	/* OOB Host specifiction
-					as edge and etc */
-	bool oob_irq_registered;
-};
-
 const uint brcmf_sdio_msglevel = BRCMF_SD_ERROR_VAL;
 
-static struct sdio_hc *sdhcinfo;
-
 /* driver info, initialized when brcmf_sdio_register is called */
 static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
 
@@ -101,7 +84,7 @@ static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
 module_param(sd_f2_blocksize, int, 0);
 
 struct brcmf_sdio_card*
-brcmf_sdcard_attach(void *cfghdl, u32 *regsva, uint irq)
+brcmf_sdcard_attach(void *cfghdl, u32 *regsva)
 {
 	struct brcmf_sdio_card *card;
 
@@ -111,7 +94,7 @@ brcmf_sdcard_attach(void *cfghdl, u32 *regsva, uint irq)
 		return NULL;
 	}
 
-	card->sdioh = brcmf_sdioh_attach(cfghdl, irq);
+	card->sdioh = brcmf_sdioh_attach(cfghdl);
 	if (!card->sdioh) {
 		brcmf_sdcard_detach(card);
 		return NULL;
@@ -495,44 +478,26 @@ u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
 	return card->sbwad;
 }
 
-int brcmf_sdio_probe(struct device *dev)
+int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 {
-	struct sdio_hc *sdhc = NULL;
 	u32 regs = 0;
 	struct brcmf_sdio_card *card = NULL;
-	int irq = 0;
 	u32 vendevid;
-	unsigned long irq_flags = 0;
-
-	/* allocate SDIO Host Controller state info */
-	sdhc = kzalloc(sizeof(struct sdio_hc), GFP_ATOMIC);
-	if (!sdhc) {
-		SDLX_MSG(("%s: out of memory\n", __func__));
-		goto err;
-	}
-	sdhc->dev = (void *)dev;
 
-	card = brcmf_sdcard_attach((void *)0, &regs, irq);
+	card = brcmf_sdcard_attach((void *)0, &regs);
 	if (!card) {
 		SDLX_MSG(("%s: attach failed\n", __func__));
 		goto err;
 	}
+	sdiodev->card = card;
 
-	sdhc->card = card;
-	sdhc->oob_irq = irq;
-	sdhc->oob_flags = irq_flags;
-	sdhc->oob_irq_registered = false;	/* to make sure.. */
-
-	/* chain SDIO Host Controller info together */
-	sdhc->next = sdhcinfo;
-	sdhcinfo = sdhc;
 	/* Read the vendor/device ID from the CIS */
 	vendevid = brcmf_sdcard_query_device(card);
 
 	/* try to attach to the target device */
-	sdhc->ch = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
+	sdiodev->bus = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
 				  0, 0, 0, 0, regs, card);
-	if (!sdhc->ch) {
+	if (!sdiodev->bus) {
 		SDLX_MSG(("%s: device attach failed\n", __func__));
 		goto err;
 	}
@@ -541,42 +506,17 @@ int brcmf_sdio_probe(struct device *dev)
 
 	/* error handling */
 err:
-	if (sdhc) {
-		if (sdhc->card)
-			brcmf_sdcard_detach(sdhc->card);
-		kfree(sdhc);
-	}
+	if (sdiodev->card)
+		brcmf_sdcard_detach(sdiodev->card);
 
 	return -ENODEV;
 }
 EXPORT_SYMBOL(brcmf_sdio_probe);
 
-int brcmf_sdio_remove(struct device *dev)
+int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 {
-	struct sdio_hc *sdhc, *prev;
-
-	sdhc = sdhcinfo;
-	drvinfo.detach(sdhc->ch);
-	brcmf_sdcard_detach(sdhc->card);
-	/* find the SDIO Host Controller state for this pdev
-		 and take it out from the list */
-	for (sdhc = sdhcinfo, prev = NULL; sdhc; sdhc = sdhc->next) {
-		if (sdhc->dev == (void *)dev) {
-			if (prev)
-				prev->next = sdhc->next;
-			else
-				sdhcinfo = NULL;
-			break;
-		}
-		prev = sdhc;
-	}
-	if (!sdhc) {
-		SDLX_MSG(("%s: failed\n", __func__));
-		return 0;
-	}
-
-	/* release SDIO Host Controller info */
-	kfree(sdhc);
+	drvinfo.detach(sdiodev->bus);
+	brcmf_sdcard_detach(sdiodev->card);
 	return 0;
 }
 EXPORT_SYMBOL(brcmf_sdio_remove);
@@ -594,10 +534,10 @@ void brcmf_sdio_unregister(void)
 	brcmf_sdio_function_cleanup();
 }
 
-void brcmf_sdio_wdtmr_enable(bool enable)
+void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev, bool enable)
 {
 	if (enable)
-		brcmf_sdbrcm_wd_timer(sdhcinfo->ch, brcmf_watchdog_ms);
+		brcmf_sdbrcm_wd_timer(sdiodev->bus, brcmf_watchdog_ms);
 	else
-		brcmf_sdbrcm_wd_timer(sdhcinfo->ch, 0);
+		brcmf_sdbrcm_wd_timer(sdiodev->bus, 0);
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 4ffd934..16ea6e8 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -68,8 +68,6 @@ uint sd_f2_blocksize = 512;	/* Default blocksize */
 struct brcmf_sdmmc_instance *gInstance;
 static atomic_t brcmf_mmc_suspend;
 
-struct device sdmmc_dev;
-
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
@@ -160,7 +158,7 @@ static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 /*
  *	Public entry points & extern's
  */
-struct sdioh_info *brcmf_sdioh_attach(void *bar0, uint irq)
+struct sdioh_info *brcmf_sdioh_attach(void *bar0)
 {
 	struct sdioh_info *sd;
 	int err_ret;
@@ -960,6 +958,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 {
 	int ret = 0;
 	static struct sdio_func sdio_func_0;
+	struct brcmf_sdio_dev *sdiodev;
 	BRCMF_TRACE(("sdio_probe: %s Enter\n", __func__));
 	BRCMF_TRACE(("sdio_probe: func->class=%x\n", func->class));
 	BRCMF_TRACE(("sdio_vendor: 0x%04x\n", func->vendor));
@@ -970,14 +969,30 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		sdio_func_0.num = 0;
 		sdio_func_0.card = func->card;
 		gInstance->func[0] = &sdio_func_0;
+
+		if (dev_get_drvdata(&func->card->dev)) {
+			BRCMF_ERROR(("%s: card private drvdata occupied.\n",
+				     __func__));
+			return -ENXIO;
+		}
+		sdiodev = kzalloc(sizeof(struct brcmf_sdio_dev), GFP_KERNEL);
+		if (!sdiodev)
+			return -ENOMEM;
+		sdiodev->func1 = func;
+		dev_set_drvdata(&func->card->dev, sdiodev);
 	}
 
 	gInstance->func[func->num] = func;
 
 	if (func->num == 2) {
+		sdiodev = dev_get_drvdata(&func->card->dev);
+		if ((!sdiodev) || (sdiodev->func1->card != func->card))
+			return -ENODEV;
+		sdiodev->func2 = func;
+
 		brcmf_cfg80211_sdio_func(func);
 		BRCMF_TRACE(("F2 found, calling brcmf_sdio_probe...\n"));
-		ret = brcmf_sdio_probe(&sdmmc_dev);
+		ret = brcmf_sdio_probe(sdiodev);
 	}
 
 	return ret;
@@ -985,6 +1000,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 
 static void brcmf_ops_sdio_remove(struct sdio_func *func)
 {
+	struct brcmf_sdio_dev *sdiodev;
 	BRCMF_TRACE(("%s Enter\n", __func__));
 	BRCMF_INFO(("func->class=%x\n", func->class));
 	BRCMF_INFO(("sdio_vendor: 0x%04x\n", func->vendor));
@@ -992,8 +1008,11 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	BRCMF_INFO(("Function#: 0x%04x\n", func->num));
 
 	if (func->num == 2) {
+		sdiodev = dev_get_drvdata(&func->card->dev);
 		BRCMF_TRACE(("F2 found, calling brcmf_sdio_remove...\n"));
-		brcmf_sdio_remove(&sdmmc_dev);
+		brcmf_sdio_remove(sdiodev);
+		dev_set_drvdata(&func->card->dev, NULL);
+		kfree(sdiodev);
 	}
 }
 
@@ -1002,6 +1021,8 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 static int brcmf_sdio_suspend(struct device *dev)
 {
 	mmc_pm_flag_t sdio_flags;
+	struct brcmf_sdio_dev *sdiodev;
+	struct sdio_func *func = dev_to_sdio_func(dev);
 	int ret = 0;
 
 	BRCMF_TRACE(("%s\n", __func__));
@@ -1020,14 +1041,19 @@ static int brcmf_sdio_suspend(struct device *dev)
 		return ret;
 	}
 
-	brcmf_sdio_wdtmr_enable(false);
+	sdiodev = dev_get_drvdata(&func->card->dev);
+	brcmf_sdio_wdtmr_enable(sdiodev, false);
 
 	return ret;
 }
 
 static int brcmf_sdio_resume(struct device *dev)
 {
-	brcmf_sdio_wdtmr_enable(true);
+	struct brcmf_sdio_dev *sdiodev;
+	struct sdio_func *func = dev_to_sdio_func(dev);
+
+	sdiodev = dev_get_drvdata(&func->card->dev);
+	brcmf_sdio_wdtmr_enable(sdiodev, true);
 	atomic_set(&brcmf_mmc_suspend, false);
 	return 0;
 }
@@ -1097,7 +1123,6 @@ int brcmf_sdio_function_init(void)
 	if (!gInstance)
 		return -ENOMEM;
 
-	memset(&sdmmc_dev, 0, sizeof(sdmmc_dev));
 	error = sdio_register_driver(&brcmf_sdmmc_driver);
 
 	return error;
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index c33720d..9853e74 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -130,6 +130,13 @@ struct brcmf_sdmmc_instance {
 	u32 host_claimed;
 };
 
+struct brcmf_sdio_dev {
+	struct sdio_func *func1;
+	struct sdio_func *func2;
+	struct brcmf_sdio_card *card;
+	void *bus;
+};
+
 /* Attach and build an interface to the underlying SD host driver.
  *  - Allocates resources (structs, arrays, mem, OS handles, etc) needed by
  *    brcmf_sdcard.
@@ -139,7 +146,7 @@ struct brcmf_sdmmc_instance {
  *    most recent one) to enable single-instance implementations to pass NULL.
  */
 extern struct brcmf_sdio_card*
-brcmf_sdcard_attach(void *cfghdl, u32 *regsva, uint irq);
+brcmf_sdcard_attach(void *cfghdl, u32 *regsva);
 
 /* Detach - freeup resources allocated in attach */
 extern int brcmf_sdcard_detach(struct brcmf_sdio_card *card);
@@ -272,8 +279,8 @@ extern int brcmf_sdio_function_init(void);
 extern int brcmf_sdio_register(struct brcmf_sdioh_driver *driver);
 extern void brcmf_sdio_unregister(void);
 extern void brcmf_sdio_function_cleanup(void);
-extern int brcmf_sdio_probe(struct device *dev);
-extern int brcmf_sdio_remove(struct device *dev);
+extern int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
+extern int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev);
 
 /* Function to return current window addr */
 extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card);
@@ -290,7 +297,7 @@ extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
  *  The handler shall be provided by all subsequent calls. No local cache
  *  cfghdl points to the starting address of pci device mapped memory
  */
-extern struct sdioh_info *brcmf_sdioh_attach(void *cfghdl, uint irq);
+extern struct sdioh_info *brcmf_sdioh_attach(void *cfghdl);
 extern int brcmf_sdioh_detach(struct sdioh_info *si);
 
 extern int
@@ -338,7 +345,8 @@ extern int brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
 
 /* Watchdog timer interface for pm ops */
-extern void brcmf_sdio_wdtmr_enable(bool enable);
+extern void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev,
+				    bool enable);
 
 extern uint sd_f2_blocksize;
 
-- 
1.7.4.1


