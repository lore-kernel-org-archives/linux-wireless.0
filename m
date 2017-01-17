Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33708 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdAQTXk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 14:23:40 -0500
Received: by mail-lf0-f68.google.com with SMTP id x1so12233603lff.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2017 11:23:39 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/2] brcmfmac: rename brcmf_bus_start function to brcmf_attach_phase2
Date: Tue, 17 Jan 2017 20:23:24 +0100
Message-Id: <20170117192325.14528-1-zajec5@gmail.com> (sfid-20170117_202343_621840_954873D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This change intends to make init/attach process easier to follow.

What driver were doing in brcmf_bus_start wasn't bus specific at all and
function brcmf_bus_stop wasn't undoing things done there. It seems
brcmf_detach was actually undoing things done in both: brcmf_attach and
brcmf_bus_start.

To me it makes more sense to call these two function in a similar way as
they both handle some part of attaching process. It also makes
brcmf_detach more meaningful.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
This patchset is based on top of
[PATCH 2/2] brcmfmac: move function declarations to proper headers
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c   | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h   | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 6 +++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 6 +++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c    | 6 +++---
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 3e15d64..6fb7d12 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -74,7 +74,7 @@ module_param_named(roamoff, brcmf_roamoff, int, S_IRUSR);
 MODULE_PARM_DESC(roamoff, "Do not use internal roaming engine");
 
 #ifdef DEBUG
-/* always succeed brcmf_bus_start() */
+/* always succeed brcmf_attach_phase2() */
 static int brcmf_ignore_probe_fail;
 module_param_named(ignore_probe_fail, brcmf_ignore_probe_fail, int, 0);
 MODULE_PARM_DESC(ignore_probe_fail, "always succeed probe for debugging");
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9e6f60a..adf8eb1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -893,7 +893,7 @@ static int brcmf_inet6addr_changed(struct notifier_block *nb,
 }
 #endif
 
-int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
+int brcmf_attach_phase1(struct device *dev, struct brcmf_mp_device *settings)
 {
 	struct brcmf_pub *drvr = NULL;
 	int ret = 0;
@@ -966,7 +966,7 @@ static int brcmf_revinfo_read(struct seq_file *s, void *data)
 	return 0;
 }
 
-int brcmf_bus_start(struct device *dev)
+int brcmf_attach_phase2(struct device *dev)
 {
 	int ret = -1;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index d92beca..df4189e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -226,8 +226,8 @@ void brcmf_rx_event(struct device *dev, struct sk_buff *rxp);
 void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 /* Indication from bus module regarding presence/insertion of dongle. */
-int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings);
-int brcmf_bus_start(struct device *dev);
+int brcmf_attach_phase1(struct device *dev, struct brcmf_mp_device *settings);
+int brcmf_attach_phase2(struct device *dev);
 void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
 /* Indication from bus module that dongle should be reset */
 void brcmf_dev_reset(struct device *dev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 048027f..bbc3ded 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1568,11 +1568,11 @@ static int brcmf_pcie_attach_bus(struct brcmf_pciedev_info *devinfo)
 	int ret;
 
 	/* Attach to the common driver interface */
-	ret = brcmf_attach(&devinfo->pdev->dev, devinfo->settings);
+	ret = brcmf_attach_phase1(&devinfo->pdev->dev, devinfo->settings);
 	if (ret) {
-		brcmf_err("brcmf_attach failed\n");
+		brcmf_err("brcmf_attach_phase1 failed\n");
 	} else {
-		ret = brcmf_bus_start(&devinfo->pdev->dev);
+		ret = brcmf_attach_phase2(&devinfo->pdev->dev);
 		if (ret)
 			brcmf_err("dongle is not responding\n");
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index dfb0658..5307223 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4065,7 +4065,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev,
 
 	sdio_release_host(sdiodev->func[1]);
 
-	err = brcmf_bus_start(dev);
+	err = brcmf_attach_phase2(dev);
 	if (err != 0) {
 		brcmf_err("dongle is not responding\n");
 		goto fail;
@@ -4150,9 +4150,9 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->tx_hdrlen = SDPCM_HWHDR_LEN + SDPCM_SWHDR_LEN;
 
 	/* Attach to the common layer, reserve hdr space */
-	ret = brcmf_attach(bus->sdiodev->dev, bus->sdiodev->settings);
+	ret = brcmf_attach_phase1(bus->sdiodev->dev, bus->sdiodev->settings);
 	if (ret != 0) {
-		brcmf_err("brcmf_attach failed\n");
+		brcmf_err("brcmf_attach_phase1 failed\n");
 		goto fail;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 2f978a3..e031fea 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1138,9 +1138,9 @@ static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
 	int ret;
 
 	/* Attach to the common driver interface */
-	ret = brcmf_attach(devinfo->dev, devinfo->settings);
+	ret = brcmf_attach_phase1(devinfo->dev, devinfo->settings);
 	if (ret) {
-		brcmf_err("brcmf_attach failed\n");
+		brcmf_err("brcmf_attach_phase1 failed\n");
 		return ret;
 	}
 
@@ -1148,7 +1148,7 @@ static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
 	if (ret)
 		goto fail;
 
-	ret = brcmf_bus_start(devinfo->dev);
+	ret = brcmf_attach_phase2(devinfo->dev);
 	if (ret)
 		goto fail;
 
-- 
2.10.1
