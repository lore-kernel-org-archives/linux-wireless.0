Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1206 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282Ab2KOCqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:37 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 16/19] brcmfmac: avoid usage of func->card->dev in sdio
 probe.
Date: Wed, 14 Nov 2012 18:46:20 -0800
Message-ID: <1352947583-25341-17-git-send-email-frankyl@broadcom.com> (sfid-20121115_041527_747276_45FC455E)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_ops_sdio_probe used the private_date func->card->dev to
store device data of brcmfmac sdio. This is not a good place to
store the data. Use dev of func and use func->card->sdio_func
to group the functions the driver is using.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   10 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  140 ++++++++++----------
 2 files changed, 79 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index b924ed7..4c3315c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -42,7 +42,8 @@
 #ifdef CONFIG_BRCMFMAC_SDIO_OOB
 static irqreturn_t brcmf_sdio_irqhandler(int irq, void *dev_id)
 {
-	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(dev_id);
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev_id);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
 	brcmf_dbg(INTR, "oob intr triggered\n");
 
@@ -71,7 +72,7 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 	brcmf_dbg(ERROR, "requesting irq %d\n", sdiodev->irq);
 	ret = request_irq(sdiodev->irq, brcmf_sdio_irqhandler,
 			  sdiodev->irq_flags, "brcmf_oob_intr",
-			  &sdiodev->func[1]->card->dev);
+			  &sdiodev->func[1]->dev);
 	if (ret != 0)
 		return ret;
 	spin_lock_init(&sdiodev->irq_en_lock);
@@ -115,7 +116,7 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 		disable_irq_wake(sdiodev->irq);
 		sdiodev->irq_wake = false;
 	}
-	free_irq(sdiodev->irq, &sdiodev->func[1]->card->dev);
+	free_irq(sdiodev->irq, &sdiodev->func[1]->dev);
 	sdiodev->irq_en = false;
 
 	return 0;
@@ -123,7 +124,8 @@ int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 #else		/* CONFIG_BRCMFMAC_SDIO_OOB */
 static void brcmf_sdio_irqhandler(struct sdio_func *func)
 {
-	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
+	struct brcmf_bus *bus_if = dev_get_drvdata(&func->dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
 	brcmf_dbg(INTR, "ib intr triggered\n");
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 8545733..6dd75cc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -456,101 +456,107 @@ static inline int brcmf_sdio_getintrcfg(struct brcmf_sdio_dev *sdiodev)
 #endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
 
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
-			      const struct sdio_device_id *id)
+				const struct sdio_device_id *id)
 {
-	int ret = 0;
+	int err;
 	struct brcmf_sdio_dev *sdiodev;
 	struct brcmf_bus *bus_if;
 
 	brcmf_dbg(TRACE, "Enter\n");
-	brcmf_dbg(TRACE, "func->class=%x\n", func->class);
-	brcmf_dbg(TRACE, "sdio_vendor: 0x%04x\n", func->vendor);
-	brcmf_dbg(TRACE, "sdio_device: 0x%04x\n", func->device);
-	brcmf_dbg(TRACE, "Function#: 0x%04x\n", func->num);
-
-	if (func->num == 1) {
-		if (dev_get_drvdata(&func->card->dev)) {
-			brcmf_dbg(ERROR, "card private drvdata occupied\n");
-			return -ENXIO;
-		}
-		bus_if = kzalloc(sizeof(struct brcmf_bus), GFP_KERNEL);
-		if (!bus_if)
-			return -ENOMEM;
-		sdiodev = kzalloc(sizeof(struct brcmf_sdio_dev), GFP_KERNEL);
-		if (!sdiodev) {
-			kfree(bus_if);
-			return -ENOMEM;
-		}
-		sdiodev->func[0] = func;
-		sdiodev->func[1] = func;
-		sdiodev->bus_if = bus_if;
-		bus_if->bus_priv.sdio = sdiodev;
-		bus_if->type = SDIO_BUS;
-		bus_if->align = BRCMF_SDALIGN;
-		dev_set_drvdata(&func->card->dev, sdiodev);
-
-		atomic_set(&sdiodev->suspend, false);
-		init_waitqueue_head(&sdiodev->request_byte_wait);
-		init_waitqueue_head(&sdiodev->request_word_wait);
-		init_waitqueue_head(&sdiodev->request_chain_wait);
-		init_waitqueue_head(&sdiodev->request_buffer_wait);
+	brcmf_dbg(TRACE, "Class=%x\n", func->class);
+	brcmf_dbg(TRACE, "sdio vendor ID: 0x%04x\n", func->vendor);
+	brcmf_dbg(TRACE, "sdio device ID: 0x%04x\n", func->device);
+	brcmf_dbg(TRACE, "Function#: %d\n", func->num);
+
+	/* Consume func num 1 but dont do anything with it. */
+	if (func->num == 1)
+		return 0;
+
+	/* Ignore anything but func 2 */
+	if (func->num != 2)
+		return -ENODEV;
+
+	bus_if = kzalloc(sizeof(struct brcmf_bus), GFP_KERNEL);
+	if (!bus_if)
+		return -ENOMEM;
+	sdiodev = kzalloc(sizeof(struct brcmf_sdio_dev), GFP_KERNEL);
+	if (!sdiodev) {
+		kfree(bus_if);
+		return -ENOMEM;
 	}
 
-	if (func->num == 2) {
-		sdiodev = dev_get_drvdata(&func->card->dev);
-		if ((!sdiodev) || (sdiodev->func[1]->card != func->card))
-			return -ENODEV;
-
-		ret = brcmf_sdio_getintrcfg(sdiodev);
-		if (ret)
-			return ret;
-		sdiodev->func[2] = func;
+	sdiodev->func[0] = func->card->sdio_func[0];
+	sdiodev->func[1] = func->card->sdio_func[0];
+	sdiodev->func[2] = func;
 
-		bus_if = sdiodev->bus_if;
-		sdiodev->dev = &func->dev;
-		dev_set_drvdata(&func->dev, bus_if);
+	sdiodev->bus_if = bus_if;
+	bus_if->bus_priv.sdio = sdiodev;
+	bus_if->type = SDIO_BUS;
+	bus_if->align = BRCMF_SDALIGN;
+	dev_set_drvdata(&func->dev, bus_if);
+	dev_set_drvdata(&sdiodev->func[1]->dev, bus_if);
+	sdiodev->dev = &sdiodev->func[1]->dev;
 
-		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_probe...\n");
-		ret = brcmf_sdio_probe(sdiodev);
-		if (ret)
-			dev_set_drvdata(&func->dev, NULL);
+	atomic_set(&sdiodev->suspend, false);
+	init_waitqueue_head(&sdiodev->request_byte_wait);
+	init_waitqueue_head(&sdiodev->request_word_wait);
+	init_waitqueue_head(&sdiodev->request_chain_wait);
+	init_waitqueue_head(&sdiodev->request_buffer_wait);
+	err = brcmf_sdio_getintrcfg(sdiodev);
+	if (err)
+		goto fail;
+
+	brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_probe...\n");
+	err = brcmf_sdio_probe(sdiodev);
+	if (err) {
+		brcmf_dbg(ERROR, "F2 error, probe failed %d...\n", err);
+		goto fail;
 	}
+	brcmf_dbg(TRACE, "F2 init completed...\n");
+	return 0;
 
-	return ret;
+fail:
+	dev_set_drvdata(&func->dev, NULL);
+	dev_set_drvdata(&sdiodev->func[1]->dev, NULL);
+	kfree(sdiodev);
+	kfree(bus_if);
+	return err;
 }
 
 static void brcmf_ops_sdio_remove(struct sdio_func *func)
 {
 	struct brcmf_bus *bus_if;
 	struct brcmf_sdio_dev *sdiodev;
+
 	brcmf_dbg(TRACE, "Enter\n");
-	brcmf_dbg(INFO, "func->class=%x\n", func->class);
-	brcmf_dbg(INFO, "sdio_vendor: 0x%04x\n", func->vendor);
-	brcmf_dbg(INFO, "sdio_device: 0x%04x\n", func->device);
-	brcmf_dbg(INFO, "Function#: 0x%04x\n", func->num);
+	brcmf_dbg(TRACE, "sdio vendor ID: 0x%04x\n", func->vendor);
+	brcmf_dbg(TRACE, "sdio device ID: 0x%04x\n", func->device);
+	brcmf_dbg(TRACE, "Function: %d\n", func->num);
 
-	if (func->num == 2) {
-		bus_if = dev_get_drvdata(&func->dev);
+	if (func->num != 1 && func->num != 2)
+		return;
+
+	bus_if = dev_get_drvdata(&func->dev);
+	if (bus_if) {
 		sdiodev = bus_if->bus_priv.sdio;
-		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_remove...\n");
 		brcmf_sdio_remove(sdiodev);
-		dev_set_drvdata(&func->dev, NULL);
-	}
-	if (func->num == 1) {
-		sdiodev = dev_get_drvdata(&func->card->dev);
-		bus_if = sdiodev->bus_if;
-		dev_set_drvdata(&func->card->dev, NULL);
+
+		dev_set_drvdata(&sdiodev->func[1]->dev, NULL);
+		dev_set_drvdata(&sdiodev->func[2]->dev, NULL);
+
 		kfree(bus_if);
 		kfree(sdiodev);
 	}
+
+	brcmf_dbg(TRACE, "Exit\n");
 }
 
 #ifdef CONFIG_PM_SLEEP
 static int brcmf_sdio_suspend(struct device *dev)
 {
 	mmc_pm_flag_t sdio_flags;
-	struct sdio_func *func = dev_to_sdio_func(dev);
-	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	int ret = 0;
 
 	brcmf_dbg(TRACE, "\n");
@@ -576,8 +582,8 @@ static int brcmf_sdio_suspend(struct device *dev)
 
 static int brcmf_sdio_resume(struct device *dev)
 {
-	struct sdio_func *func = dev_to_sdio_func(dev);
-	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
 	brcmf_sdio_wdtmr_enable(sdiodev, true);
 	atomic_set(&sdiodev->suspend, false);
-- 
1.7.9.5


