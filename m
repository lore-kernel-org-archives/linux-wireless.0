Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1645 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759488Ab1KWBWK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:10 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/24] brcm80211: fmac: introduce common bus interface
 struct brcmf_bus
Date: Tue, 22 Nov 2011 17:21:51 -0800
Message-ID: <1322011319-24863-17-git-send-email-frankyl@broadcom.com> (sfid-20111123_022217_909733_94ED2200)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct brcmf_bus will contain function porinter, bus specific
private structure pointer and interface context of generic layer
and bus layer. It will be the only shared structure between generic
and bus layer. This patch is part of fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    3 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   23 +++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    5 ++++
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 6c85d66..74933dc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -40,7 +40,8 @@
 
 static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
-	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
+	struct brcmf_bus *bus_if = dev_get_drvdata(&func->card->dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
 
 	brcmf_dbg(TRACE, "***IRQHandler\n");
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 7a2325b..77f84f8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -461,6 +461,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 {
 	int ret = 0;
 	struct brcmf_sdio_dev *sdiodev;
+	struct brcmf_bus *bus_if;
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_dbg(TRACE, "func->class=%x\n", func->class);
 	brcmf_dbg(TRACE, "sdio_vendor: 0x%04x\n", func->vendor);
@@ -472,12 +473,18 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			brcmf_dbg(ERROR, "card private drvdata occupied\n");
 			return -ENXIO;
 		}
+		bus_if = kzalloc(sizeof(struct brcmf_bus), GFP_KERNEL);
+		if (!bus_if)
+			return -ENOMEM;
 		sdiodev = kzalloc(sizeof(struct brcmf_sdio_dev), GFP_KERNEL);
 		if (!sdiodev)
 			return -ENOMEM;
+		sdiodev->dev = &func->card->dev;
 		sdiodev->func[0] = func->card->sdio_func[0];
 		sdiodev->func[1] = func;
-		dev_set_drvdata(&func->card->dev, sdiodev);
+		bus_if->bus_priv = sdiodev;
+		bus_if->type = SDIO_BUS;
+		dev_set_drvdata(&func->card->dev, bus_if);
 
 		atomic_set(&sdiodev->suspend, false);
 		init_waitqueue_head(&sdiodev->request_byte_wait);
@@ -487,7 +494,8 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	}
 
 	if (func->num == 2) {
-		sdiodev = dev_get_drvdata(&func->card->dev);
+		bus_if = dev_get_drvdata(&func->card->dev);
+		sdiodev = bus_if->bus_priv;
 		if ((!sdiodev) || (sdiodev->func[1]->card != func->card))
 			return -ENODEV;
 		sdiodev->func[2] = func;
@@ -501,6 +509,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 
 static void brcmf_ops_sdio_remove(struct sdio_func *func)
 {
+	struct brcmf_bus *bus_if;
 	struct brcmf_sdio_dev *sdiodev;
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_dbg(INFO, "func->class=%x\n", func->class);
@@ -509,10 +518,12 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	brcmf_dbg(INFO, "Function#: 0x%04x\n", func->num);
 
 	if (func->num == 2) {
-		sdiodev = dev_get_drvdata(&func->card->dev);
+		bus_if = dev_get_drvdata(&func->card->dev);
+		sdiodev = bus_if->bus_priv;
 		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_remove...\n");
 		brcmf_sdio_remove(sdiodev);
 		dev_set_drvdata(&func->card->dev, NULL);
+		kfree(bus_if);
 		kfree(sdiodev);
 	}
 }
@@ -523,11 +534,12 @@ static int brcmf_sdio_suspend(struct device *dev)
 	mmc_pm_flag_t sdio_flags;
 	struct brcmf_sdio_dev *sdiodev;
 	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct brcmf_bus *bus_if = dev_get_drvdata(&func->card->dev);
 	int ret = 0;
 
 	brcmf_dbg(TRACE, "\n");
 
-	sdiodev = dev_get_drvdata(&func->card->dev);
+	sdiodev = bus_if->bus_priv;
 
 	atomic_set(&sdiodev->suspend, true);
 
@@ -552,8 +564,9 @@ static int brcmf_sdio_resume(struct device *dev)
 {
 	struct brcmf_sdio_dev *sdiodev;
 	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct brcmf_bus *bus_if = dev_get_drvdata(&func->card->dev);
 
-	sdiodev = dev_get_drvdata(&func->card->dev);
+	sdiodev = bus_if->bus_priv;
 	brcmf_sdio_wdtmr_enable(sdiodev, true);
 	atomic_set(&sdiodev->suspend, false);
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 451b34b..a557971 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -571,6 +571,11 @@ struct brcmf_dcmd {
 	uint needed;		/* bytes needed (optional) */
 };
 
+struct brcmf_bus {
+	u8 type;		/* bus type */
+	void *bus_priv;		/* pointer to bus private structure */
+};
+
 /* Forward decls for struct brcmf_pub (see below) */
 struct brcmf_sdio;		/* device bus info */
 struct brcmf_proto;	/* device communication protocol info */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 0618f5e..c4c2543 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -134,7 +134,7 @@ struct brcmf_sdio_dev {
 	wait_queue_head_t request_word_wait;
 	wait_queue_head_t request_chain_wait;
 	wait_queue_head_t request_buffer_wait;
-
+	struct device *dev;
 };
 
 /* Register/deregister device interrupt handler. */
-- 
1.7.5.4


