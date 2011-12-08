Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2834 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab1LHXHK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:10 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/23] brcm80211: fmac: save bus interface structure in
 function 2 device
Date: Thu, 8 Dec 2011 15:06:37 -0800
Message-ID: <1323385619-7454-2-git-send-email-frankyl@broadcom.com> (sfid-20111209_000715_353311_04D8FD47)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bus interface was stored in sdio card device. The device pointer
is used as parameter of interface functions between common layer
and bus layer to make the function declaration generic for different
bus type. But the card device is a parent device layer for SDIO
function devices. It doesn't contain all contexts needed by udev.
This patch moves the shared structure to private driver data pointer
of SDIO function 2 device which is more appopriate for net device
and cfg80211 registration.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    3 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   23 +++++++++----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    1 +
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 74933dc..6c85d66 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -40,8 +40,7 @@
 
 static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
-	struct brcmf_bus *bus_if = dev_get_drvdata(&func->card->dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
 
 	brcmf_dbg(TRACE, "***IRQHandler\n");
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index b416e27..bc99267 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -481,12 +481,12 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			kfree(bus_if);
 			return -ENOMEM;
 		}
-		sdiodev->dev = &func->card->dev;
 		sdiodev->func[0] = func->card->sdio_func[0];
 		sdiodev->func[1] = func;
+		sdiodev->bus_if = bus_if;
 		bus_if->bus_priv = sdiodev;
 		bus_if->type = SDIO_BUS;
-		dev_set_drvdata(&func->card->dev, bus_if);
+		dev_set_drvdata(&func->card->dev, sdiodev);
 
 		atomic_set(&sdiodev->suspend, false);
 		init_waitqueue_head(&sdiodev->request_byte_wait);
@@ -496,12 +496,15 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	}
 
 	if (func->num == 2) {
-		bus_if = dev_get_drvdata(&func->card->dev);
-		sdiodev = bus_if->bus_priv;
+		sdiodev = dev_get_drvdata(&func->card->dev);
 		if ((!sdiodev) || (sdiodev->func[1]->card != func->card))
 			return -ENODEV;
 		sdiodev->func[2] = func;
 
+		bus_if = sdiodev->bus_if;
+		sdiodev->dev = &func->dev;
+		dev_set_drvdata(&func->dev, bus_if);
+
 		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_probe...\n");
 		ret = brcmf_sdio_probe(sdiodev);
 	}
@@ -520,11 +523,12 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	brcmf_dbg(INFO, "Function#: 0x%04x\n", func->num);
 
 	if (func->num == 2) {
-		bus_if = dev_get_drvdata(&func->card->dev);
+		bus_if = dev_get_drvdata(&func->dev);
 		sdiodev = bus_if->bus_priv;
 		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_remove...\n");
 		brcmf_sdio_remove(sdiodev);
 		dev_set_drvdata(&func->card->dev, NULL);
+		dev_set_drvdata(&func->dev, NULL);
 		kfree(bus_if);
 		kfree(sdiodev);
 	}
@@ -534,15 +538,12 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 static int brcmf_sdio_suspend(struct device *dev)
 {
 	mmc_pm_flag_t sdio_flags;
-	struct brcmf_sdio_dev *sdiodev;
 	struct sdio_func *func = dev_to_sdio_func(dev);
-	struct brcmf_bus *bus_if = dev_get_drvdata(&func->card->dev);
+	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
 	int ret = 0;
 
 	brcmf_dbg(TRACE, "\n");
 
-	sdiodev = bus_if->bus_priv;
-
 	atomic_set(&sdiodev->suspend, true);
 
 	sdio_flags = sdio_get_host_pm_caps(sdiodev->func[1]);
@@ -564,11 +565,9 @@ static int brcmf_sdio_suspend(struct device *dev)
 
 static int brcmf_sdio_resume(struct device *dev)
 {
-	struct brcmf_sdio_dev *sdiodev;
 	struct sdio_func *func = dev_to_sdio_func(dev);
-	struct brcmf_bus *bus_if = dev_get_drvdata(&func->card->dev);
+	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
 
-	sdiodev = bus_if->bus_priv;
 	brcmf_sdio_wdtmr_enable(sdiodev, true);
 	atomic_set(&sdiodev->suspend, false);
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index c4c2543..d36a2a8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -135,6 +135,7 @@ struct brcmf_sdio_dev {
 	wait_queue_head_t request_chain_wait;
 	wait_queue_head_t request_buffer_wait;
 	struct device *dev;
+	struct brcmf_bus *bus_if;
 };
 
 /* Register/deregister device interrupt handler. */
-- 
1.7.5.4


