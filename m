Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1161 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab3DLI4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 04:56:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 11/15] brcmfmac: define and use platform specific
 data for SDIO.
Date: Fri, 12 Apr 2013 10:55:55 +0200
Message-ID: <1365756955-8813-1-git-send-email-arend@broadcom.com> (sfid-20130412_105620_413015_76268CCE)
In-Reply-To: <1365679740-25679-12-git-send-email-arend@broadcom.com>
References: <1365679740-25679-12-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch adds support for platform specific data for SDIO
fullmac devices. Currently OOB interrupts are configured by Kconfig
BRCMFMAC_SDIO_OOB but that is now determined dynamically by checking
availibility of platform data.

Cc: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

Hauke indicated the platform data header should be in
include/linux/platform_data. This patch does that and
replaces patch with message-id:

<1365679740-25679-12-git-send-email-arend@broadcom.com>

Regards,
Arend
---
 drivers/net/wireless/brcm80211/Kconfig             |    9 --
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  155 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  114 ++++----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   29 ++--
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    6 +-
 include/linux/platform_data/brcmfmac-sdio.h        |  125 ++++++++++++++++
 6 files changed, 251 insertions(+), 187 deletions(-)
 create mode 100644 include/linux/platform_data/brcmfmac-sdio.h

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index 747e931..fc8a0fa 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -37,15 +37,6 @@ config BRCMFMAC_SDIO
 	  IEEE802.11n embedded FullMAC WLAN driver. Say Y if you want to
 	  use the driver for a SDIO wireless card.
 
-config BRCMFMAC_SDIO_OOB
-	bool "Out of band interrupt support for SDIO interface chipset"
-	depends on BRCMFMAC_SDIO
-	---help---
-	  This option enables out-of-band interrupt support for Broadcom
-	  SDIO Wifi chipset using fullmac in order to gain better
-	  performance and deep sleep wake up capability on certain
-	  platforms. Say N if you are unsure.
-
 config BRCMFMAC_USB
 	bool "USB bus interface support for FullMAC driver"
 	depends on USB
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index aa51f37..4891e3d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -25,6 +25,7 @@
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
+#include <linux/platform_data/brcmfmac-sdio.h>
 
 #include <defs.h>
 #include <brcm_hw_ids.h>
@@ -37,16 +38,15 @@
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
-#ifdef CONFIG_BRCMFMAC_SDIO_OOB
-static irqreturn_t brcmf_sdio_irqhandler(int irq, void *dev_id)
+
+static irqreturn_t brcmf_sdio_oob_irqhandler(int irq, void *dev_id)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev_id);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
-	brcmf_dbg(INTR, "oob intr triggered\n");
+	brcmf_dbg(INTR, "OOB intr triggered\n");
 
-	/*
-	 * out-of-band interrupt is level-triggered which won't
+	/* out-of-band interrupt is level-triggered which won't
 	 * be cleared until dpc
 	 */
 	if (sdiodev->irq_en) {
@@ -59,72 +59,12 @@ static irqreturn_t brcmf_sdio_irqhandler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
-{
-	int ret = 0;
-	u8 data;
-	unsigned long flags;
-
-	brcmf_dbg(SDIO, "Entering: irq %d\n", sdiodev->irq);
-
-	ret = request_irq(sdiodev->irq, brcmf_sdio_irqhandler,
-			  sdiodev->irq_flags, "brcmf_oob_intr",
-			  &sdiodev->func[1]->dev);
-	if (ret != 0)
-		return ret;
-	spin_lock_init(&sdiodev->irq_en_lock);
-	spin_lock_irqsave(&sdiodev->irq_en_lock, flags);
-	sdiodev->irq_en = true;
-	spin_unlock_irqrestore(&sdiodev->irq_en_lock, flags);
-
-	ret = enable_irq_wake(sdiodev->irq);
-	if (ret != 0)
-		return ret;
-	sdiodev->irq_wake = true;
-
-	sdio_claim_host(sdiodev->func[1]);
-
-	/* must configure SDIO_CCCR_IENx to enable irq */
-	data = brcmf_sdio_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
-	data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
-	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_IENx, data, &ret);
-
-	/* redirect, configure and enable io for interrupt signal */
-	data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
-	if (sdiodev->irq_flags & IRQF_TRIGGER_HIGH)
-		data |= SDIO_SEPINT_ACT_HI;
-	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
-
-	sdio_release_host(sdiodev->func[1]);
-
-	return 0;
-}
-
-int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
-{
-	brcmf_dbg(SDIO, "Entering\n");
-
-	sdio_claim_host(sdiodev->func[1]);
-	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
-	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
-	sdio_release_host(sdiodev->func[1]);
-
-	if (sdiodev->irq_wake) {
-		disable_irq_wake(sdiodev->irq);
-		sdiodev->irq_wake = false;
-	}
-	free_irq(sdiodev->irq, &sdiodev->func[1]->dev);
-	sdiodev->irq_en = false;
-
-	return 0;
-}
-#else		/* CONFIG_BRCMFMAC_SDIO_OOB */
-static void brcmf_sdio_irqhandler(struct sdio_func *func)
+static void brcmf_sdio_ib_irqhandler(struct sdio_func *func)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(&func->dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
-	brcmf_dbg(INTR, "ib intr triggered\n");
+	brcmf_dbg(INTR, "IB intr triggered\n");
 
 	brcmf_sdbrcm_isr(sdiodev->bus);
 }
@@ -136,12 +76,56 @@ static void brcmf_sdio_dummy_irqhandler(struct sdio_func *func)
 
 int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
-	brcmf_dbg(SDIO, "Entering\n");
+	int ret = 0;
+	u8 data;
+	unsigned long flags;
 
-	sdio_claim_host(sdiodev->func[1]);
-	sdio_claim_irq(sdiodev->func[1], brcmf_sdio_irqhandler);
-	sdio_claim_irq(sdiodev->func[2], brcmf_sdio_dummy_irqhandler);
-	sdio_release_host(sdiodev->func[1]);
+	if ((sdiodev->pdata) && (sdiodev->pdata->oob_irq_supported)) {
+		brcmf_dbg(SDIO, "Enter, register OOB IRQ %d\n",
+			  sdiodev->pdata->oob_irq_nr);
+		ret = request_irq(sdiodev->pdata->oob_irq_nr,
+				  brcmf_sdio_oob_irqhandler,
+				  sdiodev->pdata->oob_irq_flags,
+				  "brcmf_oob_intr",
+				  &sdiodev->func[1]->dev);
+		if (ret != 0) {
+			brcmf_err("request_irq failed %d\n", ret);
+			return ret;
+		}
+		sdiodev->oob_irq_requested = true;
+		spin_lock_init(&sdiodev->irq_en_lock);
+		spin_lock_irqsave(&sdiodev->irq_en_lock, flags);
+		sdiodev->irq_en = true;
+		spin_unlock_irqrestore(&sdiodev->irq_en_lock, flags);
+
+		ret = enable_irq_wake(sdiodev->pdata->oob_irq_nr);
+		if (ret != 0) {
+			brcmf_err("enable_irq_wake failed %d\n", ret);
+			return ret;
+		}
+		sdiodev->irq_wake = true;
+
+		sdio_claim_host(sdiodev->func[1]);
+
+		/* must configure SDIO_CCCR_IENx to enable irq */
+		data = brcmf_sdio_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
+		data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
+		brcmf_sdio_regwb(sdiodev, SDIO_CCCR_IENx, data, &ret);
+
+		/* redirect, configure and enable io for interrupt signal */
+		data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
+		if (sdiodev->pdata->oob_irq_flags & IRQF_TRIGGER_HIGH)
+			data |= SDIO_SEPINT_ACT_HI;
+		brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
+
+		sdio_release_host(sdiodev->func[1]);
+	} else {
+		brcmf_dbg(SDIO, "Entering\n");
+		sdio_claim_host(sdiodev->func[1]);
+		sdio_claim_irq(sdiodev->func[1], brcmf_sdio_ib_irqhandler);
+		sdio_claim_irq(sdiodev->func[2], brcmf_sdio_dummy_irqhandler);
+		sdio_release_host(sdiodev->func[1]);
+	}
 
 	return 0;
 }
@@ -150,14 +134,31 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
 	brcmf_dbg(SDIO, "Entering\n");
 
-	sdio_claim_host(sdiodev->func[1]);
-	sdio_release_irq(sdiodev->func[2]);
-	sdio_release_irq(sdiodev->func[1]);
-	sdio_release_host(sdiodev->func[1]);
+	if ((sdiodev->pdata) && (sdiodev->pdata->oob_irq_supported)) {
+		sdio_claim_host(sdiodev->func[1]);
+		brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
+		brcmf_sdio_regwb(sdiodev, SDIO_CCCR_IENx, 0, NULL);
+		sdio_release_host(sdiodev->func[1]);
+
+		if (sdiodev->oob_irq_requested) {
+			sdiodev->oob_irq_requested = false;
+			if (sdiodev->irq_wake) {
+				disable_irq_wake(sdiodev->pdata->oob_irq_nr);
+				sdiodev->irq_wake = false;
+			}
+			free_irq(sdiodev->pdata->oob_irq_nr,
+				 &sdiodev->func[1]->dev);
+			sdiodev->irq_en = false;
+		}
+	} else {
+		sdio_claim_host(sdiodev->func[1]);
+		sdio_release_irq(sdiodev->func[2]);
+		sdio_release_irq(sdiodev->func[1]);
+		sdio_release_host(sdiodev->func[1]);
+	}
 
 	return 0;
 }
-#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
 
 int
 brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index b1ea103..44fa0cd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>	/* request_irq() */
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/brcmfmac-sdio.h>
 #include <net/cfg80211.h>
 
 #include <defs.h>
@@ -62,14 +63,8 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
-#ifdef CONFIG_BRCMFMAC_SDIO_OOB
-static struct list_head oobirq_lh;
-struct brcmf_sdio_oobirq {
-	unsigned int irq;
-	unsigned long flags;
-	struct list_head list;
-};
-#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
+static struct brcmfmac_sdio_platform_data *brcmfmac_sdio_pdata;
+
 
 static bool
 brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
@@ -428,33 +423,6 @@ void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 
 }
 
-#ifdef CONFIG_BRCMFMAC_SDIO_OOB
-static int brcmf_sdio_getintrcfg(struct brcmf_sdio_dev *sdiodev)
-{
-	struct brcmf_sdio_oobirq *oobirq_entry;
-
-	if (list_empty(&oobirq_lh)) {
-		brcmf_err("no valid oob irq resource\n");
-		return -ENXIO;
-	}
-
-	oobirq_entry = list_first_entry(&oobirq_lh, struct brcmf_sdio_oobirq,
-					list);
-
-	sdiodev->irq = oobirq_entry->irq;
-	sdiodev->irq_flags = oobirq_entry->flags;
-	list_del(&oobirq_entry->list);
-	kfree(oobirq_entry);
-
-	return 0;
-}
-#else
-static inline int brcmf_sdio_getintrcfg(struct brcmf_sdio_dev *sdiodev)
-{
-	return 0;
-}
-#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
-
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
 				const struct sdio_device_id *id)
 {
@@ -495,15 +463,13 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	dev_set_drvdata(&func->dev, bus_if);
 	dev_set_drvdata(&sdiodev->func[1]->dev, bus_if);
 	sdiodev->dev = &sdiodev->func[1]->dev;
+	sdiodev->pdata = brcmfmac_sdio_pdata;
 
 	atomic_set(&sdiodev->suspend, false);
 	init_waitqueue_head(&sdiodev->request_byte_wait);
 	init_waitqueue_head(&sdiodev->request_word_wait);
 	init_waitqueue_head(&sdiodev->request_chain_wait);
 	init_waitqueue_head(&sdiodev->request_buffer_wait);
-	err = brcmf_sdio_getintrcfg(sdiodev);
-	if (err)
-		goto fail;
 
 	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdio_probe...\n");
 	err = brcmf_sdio_probe(sdiodev);
@@ -598,7 +564,7 @@ static const struct dev_pm_ops brcmf_sdio_pm_ops = {
 static struct sdio_driver brcmf_sdmmc_driver = {
 	.probe = brcmf_ops_sdio_probe,
 	.remove = brcmf_ops_sdio_remove,
-	.name = "brcmfmac",
+	.name = BRCMFMAC_SDIO_PDATA_NAME,
 	.id_table = brcmf_sdmmc_ids,
 #ifdef CONFIG_PM_SLEEP
 	.drv = {
@@ -607,72 +573,51 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 #endif	/* CONFIG_PM_SLEEP */
 };
 
-#ifdef CONFIG_BRCMFMAC_SDIO_OOB
 static int brcmf_sdio_pd_probe(struct platform_device *pdev)
 {
-	struct resource *res;
-	struct brcmf_sdio_oobirq *oobirq_entry;
-	int i, ret;
+	int ret;
 
-	INIT_LIST_HEAD(&oobirq_lh);
+	brcmf_dbg(SDIO, "Enter\n");
 
-	for (i = 0; ; i++) {
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
-		if (!res)
-			break;
+	brcmfmac_sdio_pdata = pdev->dev.platform_data;
 
-		oobirq_entry = kzalloc(sizeof(struct brcmf_sdio_oobirq),
-				       GFP_KERNEL);
-		if (!oobirq_entry)
-			return -ENOMEM;
-		oobirq_entry->irq = res->start;
-		oobirq_entry->flags = res->flags & IRQF_TRIGGER_MASK;
-		list_add_tail(&oobirq_entry->list, &oobirq_lh);
-	}
-	if (i == 0)
-		return -ENXIO;
+	if (brcmfmac_sdio_pdata->power_on)
+		brcmfmac_sdio_pdata->power_on();
 
 	ret = sdio_register_driver(&brcmf_sdmmc_driver);
-
 	if (ret)
 		brcmf_err("sdio_register_driver failed: %d\n", ret);
 
 	return ret;
 }
 
-static struct platform_driver brcmf_sdio_pd = {
-	.probe		= brcmf_sdio_pd_probe,
-	.driver		= {
-		.name	= "brcmf_sdio_pd"
-	}
-};
-
-void brcmf_sdio_exit(void)
+static int brcmf_sdio_pd_remove(struct platform_device *pdev)
 {
 	brcmf_dbg(SDIO, "Enter\n");
 
+	if (brcmfmac_sdio_pdata->power_off)
+		brcmfmac_sdio_pdata->power_off();
+
 	sdio_unregister_driver(&brcmf_sdmmc_driver);
 
-	platform_driver_unregister(&brcmf_sdio_pd);
+	return 0;
 }
 
-void brcmf_sdio_init(void)
-{
-	int ret;
-
-	brcmf_dbg(SDIO, "Enter\n");
-
-	ret = platform_driver_register(&brcmf_sdio_pd);
+static struct platform_driver brcmf_sdio_pd = {
+	.remove		= brcmf_sdio_pd_remove,
+	.driver		= {
+		.name	= BRCMFMAC_SDIO_PDATA_NAME
+	}
+};
 
-	if (ret)
-		brcmf_err("platform_driver_register failed: %d\n", ret);
-}
-#else
 void brcmf_sdio_exit(void)
 {
 	brcmf_dbg(SDIO, "Enter\n");
 
-	sdio_unregister_driver(&brcmf_sdmmc_driver);
+	if (brcmfmac_sdio_pdata)
+		platform_driver_unregister(&brcmf_sdio_pd);
+	else
+		sdio_unregister_driver(&brcmf_sdmmc_driver);
 }
 
 void brcmf_sdio_init(void)
@@ -681,9 +626,12 @@ void brcmf_sdio_init(void)
 
 	brcmf_dbg(SDIO, "Enter\n");
 
-	ret = sdio_register_driver(&brcmf_sdmmc_driver);
+	ret = platform_driver_probe(&brcmf_sdio_pd, brcmf_sdio_pd_probe);
+	if (ret == -ENODEV) {
+		brcmf_dbg(SDIO, "No platform data available, registering without.\n");
+		ret = sdio_register_driver(&brcmf_sdmmc_driver);
+	}
 
 	if (ret)
-		brcmf_err("sdio_register_driver failed: %d\n", ret);
+		brcmf_err("driver registration failed: %d\n", ret);
 }
-#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index fd697ce..d248751 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -31,6 +31,7 @@
 #include <linux/bcma/bcma.h>
 #include <linux/debugfs.h>
 #include <linux/vmalloc.h>
+#include <linux/platform_data/brcmfmac-sdio.h>
 #include <asm/unaligned.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
@@ -517,7 +518,7 @@ static int qcount[NUMPRIO];
 static int tx_packets[NUMPRIO];
 #endif				/* DEBUG */
 
-#define SDIO_DRIVE_STRENGTH	6	/* in milliamps */
+#define DEFAULT_SDIO_DRIVE_STRENGTH	6	/* in milliamps */
 
 #define RETRYCHAN(chan) ((chan) == SDPCM_EVENT_CHANNEL)
 
@@ -2046,23 +2047,19 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	bus->tx_seq = bus->rx_seq = 0;
 }
 
-#ifdef CONFIG_BRCMFMAC_SDIO_OOB
 static inline void brcmf_sdbrcm_clrintr(struct brcmf_sdio *bus)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&bus->sdiodev->irq_en_lock, flags);
-	if (!bus->sdiodev->irq_en && !atomic_read(&bus->ipend)) {
-		enable_irq(bus->sdiodev->irq);
-		bus->sdiodev->irq_en = true;
+	if (bus->sdiodev->oob_irq_requested) {
+		spin_lock_irqsave(&bus->sdiodev->irq_en_lock, flags);
+		if (!bus->sdiodev->irq_en && !atomic_read(&bus->ipend)) {
+			enable_irq(bus->sdiodev->pdata->oob_irq_nr);
+			bus->sdiodev->irq_en = true;
+		}
+		spin_unlock_irqrestore(&bus->sdiodev->irq_en_lock, flags);
 	}
-	spin_unlock_irqrestore(&bus->sdiodev->irq_en_lock, flags);
-}
-#else
-static inline void brcmf_sdbrcm_clrintr(struct brcmf_sdio *bus)
-{
 }
-#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
 
 static inline void brcmf_sdbrcm_adddpctsk(struct brcmf_sdio *bus)
 {
@@ -3639,6 +3636,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	int err = 0;
 	int reg_addr;
 	u32 reg_val;
+	u32 drivestrength;
 
 	bus->alp_only = true;
 
@@ -3679,8 +3677,11 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 		goto fail;
 	}
 
-	brcmf_sdio_chip_drivestrengthinit(bus->sdiodev, bus->ci,
-					  SDIO_DRIVE_STRENGTH);
+	if ((bus->sdiodev->pdata) && (bus->sdiodev->pdata->drive_strength))
+		drivestrength = bus->sdiodev->pdata->drive_strength;
+	else
+		drivestrength = DEFAULT_SDIO_DRIVE_STRENGTH;
+	brcmf_sdio_chip_drivestrengthinit(bus->sdiodev, bus->ci, drivestrength);
 
 	/* Get info on the SOCRAM cores... */
 	bus->ramsize = bus->ci->ramsize;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 28ed3cc..7c1b633 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -174,13 +174,11 @@ struct brcmf_sdio_dev {
 	wait_queue_head_t request_buffer_wait;
 	struct device *dev;
 	struct brcmf_bus *bus_if;
-#ifdef CONFIG_BRCMFMAC_SDIO_OOB
-	unsigned int irq;		/* oob interrupt number */
-	unsigned long irq_flags;	/* board specific oob flags */
+	struct brcmfmac_sdio_platform_data *pdata;
+	bool oob_irq_requested;
 	bool irq_en;			/* irq enable flags */
 	spinlock_t irq_en_lock;
 	bool irq_wake;			/* irq wake enable flags */
-#endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
 };
 
 /* Register/deregister interrupt handler. */
diff --git a/include/linux/platform_data/brcmfmac-sdio.h b/include/linux/platform_data/brcmfmac-sdio.h
new file mode 100644
index 0000000..fd8802e
--- /dev/null
+++ b/include/linux/platform_data/brcmfmac-sdio.h
@@ -0,0 +1,125 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _LINUX_BRCMFMAC_PLATFORM_H
+#define _LINUX_BRCMFMAC_PLATFORM_H
+
+/*
+ * Platform specific driver functions and data. Through the platform specific
+ * device data functions can be provided to help the brcmfmac driver to
+ * operate with the device in combination with the used platform.
+ *
+ * Use the platform data in the following (similar) way:
+ *
+ *
+#include <brcmfmac_platform.h>
+
+
+static void brcmfmac_power_on(void)
+{
+}
+
+static void brcmfmac_power_off(void)
+{
+}
+
+static void brcmfmac_reset(void)
+{
+}
+
+static struct brcmfmac_sdio_platform_data brcmfmac_sdio_pdata = {
+	.power_on		= brcmfmac_power_on,
+	.power_off		= brcmfmac_power_off,
+	.reset			= brcmfmac_reset
+};
+
+static struct platform_device brcmfmac_device = {
+	.name			= BRCMFMAC_SDIO_PDATA_NAME,
+	.id			= PLATFORM_DEVID_NONE,
+	.dev.platform_data	= &brcmfmac_sdio_pdata
+};
+
+void __init brcmfmac_init_pdata(void)
+{
+	brcmfmac_sdio_pdata.oob_irq_supported = true;
+	brcmfmac_sdio_pdata.oob_irq_nr = gpio_to_irq(GPIO_BRCMF_SDIO_OOB);
+	brcmfmac_sdio_pdata.oob_irq_flags = IORESOURCE_IRQ |
+					    IORESOURCE_IRQ_HIGHLEVEL;
+	platform_device_register(&brcmfmac_device);
+}
+ *
+ *
+ * Note: the brcmfmac can be loaded as module or be statically built-in into
+ * the kernel. If built-in then do note that it uses module_init (and
+ * module_exit) routines which equal device_initcall. So if you intend to
+ * create a module with the platform specific data for the brcmfmac and have
+ * it built-in to the kernel then use a higher initcall then device_initcall
+ * (see init.h). If this is not done then brcmfmac will load without problems
+ * but will not pickup the platform data.
+ *
+ * When the driver does not "detect" platform driver data then it will continue
+ * without reporting anything and just assume there is no data needed. Which is
+ * probably true for most platforms.
+ *
+ * Explanation of the platform_data fields:
+ *
+ * drive_strength: is the preferred drive_strength to be used for the SDIO
+ * pins. If 0 then a default value will be used. This is the target drive
+ * strength, the exact drive strength which will be used depends on the
+ * capabilities of the device.
+ *
+ * oob_irq_supported: does the board have support for OOB interrupts. SDIO
+ * in-band interrupts are relatively slow and for having less overhead on
+ * interrupt processing an out of band interrupt can be used. If the HW
+ * supports this then enable this by setting this field to true and configure
+ * the oob related fields.
+ *
+ * oob_irq_nr, oob_irq_flags: the OOB interrupt information. The values are
+ * used for registering the irq using request_irq function.
+ *
+ * power_on: This function is called by the brcmfmac when the module gets
+ * loaded. This can be particularly useful for low power devices. The platform
+ * spcific routine may for example decide to power up the complete device.
+ * If there is no use-case for this function then provide NULL.
+ *
+ * power_off: This function is called by the brcmfmac when the module gets
+ * unloaded. At this point the device can be powered down or otherwise be reset.
+ * So if an actual power_off is not supported but reset is then reset the device
+ * when this function gets called. This can be particularly useful for low power
+ * devices. If there is no use-case for this function (either power-down or
+ * reset) then provide NULL.
+ *
+ * reset: This function can get called if the device communication broke down.
+ * This functionality is particularly useful in case of SDIO type devices. It is
+ * possible to reset a dongle via sdio data interface, but it requires that
+ * this is fully functional. This function is chip/module specific and this
+ * function should return only after the complete reset has completed.
+ */
+
+#define BRCMFMAC_SDIO_PDATA_NAME	"brcmfmac_sdio"
+
+struct brcmfmac_sdio_platform_data {
+	unsigned int drive_strength;
+	bool oob_irq_supported;
+	unsigned int oob_irq_nr;
+	unsigned long oob_irq_flags;
+	void (*power_on)(void);
+	void (*power_off)(void);
+	void (*reset)(void);
+};
+
+#endif /* _LINUX_BRCMFMAC_PLATFORM_H */
+
-- 
1.7.10.4


