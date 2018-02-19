Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:47997 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932339AbeBSXOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 18:14:34 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6/8] brcmfmac: remove brcmf_bus_started() from bus api
Date: Tue, 20 Feb 2018 00:14:23 +0100
Message-Id: <1519082065-10128-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180220_001453_422045_2B2D5998)
In-Reply-To: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No longer needed to call this in bus layer so make it static and call
it in the last phase of brcmf_attach() instead.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  1 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 14 +++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 20 +---------------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 10 ++------
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 28 ++++------------------
 5 files changed, 16 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 0b76a61..0b90a63b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -253,7 +253,6 @@ int brcmf_bus_get_fwname(struct brcmf_bus *bus, uint chip, uint chiprev,
 /* Configure the "global" bus state used by upper layers */
 void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
 
-int brcmf_bus_started(struct device *dev);
 s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data, u32 len);
 void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9eab7a9..1904852 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -944,11 +944,10 @@ static int brcmf_revinfo_read(struct seq_file *s, void *data)
 	return 0;
 }
 
-int brcmf_bus_started(struct device *dev)
+static int brcmf_bus_started(struct brcmf_pub *drvr)
 {
 	int ret = -1;
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_bus *bus_if = drvr->bus_if;
 	struct brcmf_if *ifp;
 	struct brcmf_if *p2p_ifp;
 
@@ -965,7 +964,7 @@ int brcmf_bus_started(struct device *dev)
 	brcmf_bus_change_state(bus_if, BRCMF_BUS_UP);
 
 	/* do bus specific preinit here */
-	ret = brcmf_bus_preinit(ifp->drvr->bus_if);
+	ret = brcmf_bus_preinit(bus_if);
 	if (ret < 0)
 		goto fail;
 
@@ -1085,7 +1084,12 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
 	/* attach firmware event handler */
 	brcmf_fweh_attach(drvr);
 
-	return ret;
+	ret = brcmf_bus_started(drvr);
+	if (ret != 0) {
+		brcmf_err("dongle is not responding: err=%d\n", ret);
+		goto fail;
+	}
+	return 0;
 
 fail:
 	brcmf_detach(dev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 8752707..a7d827c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1581,24 +1581,6 @@ static void brcmf_pcie_release_resource(struct brcmf_pciedev_info *devinfo)
 }
 
 
-static int brcmf_pcie_attach_bus(struct brcmf_pciedev_info *devinfo)
-{
-	int ret;
-
-	/* Attach to the common driver interface */
-	ret = brcmf_attach(&devinfo->pdev->dev, devinfo->settings);
-	if (ret) {
-		brcmf_err("brcmf_attach failed\n");
-	} else {
-		ret = brcmf_bus_started(&devinfo->pdev->dev);
-		if (ret)
-			brcmf_err("dongle is not responding\n");
-	}
-
-	return ret;
-}
-
-
 static u32 brcmf_pcie_buscore_prep_addr(const struct pci_dev *pdev, u32 addr)
 {
 	u32 ret_addr;
@@ -1735,7 +1717,7 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 	init_waitqueue_head(&devinfo->mbdata_resp_wait);
 
 	brcmf_pcie_intr_enable(devinfo);
-	if (brcmf_pcie_attach_bus(devinfo) == 0)
+	if (brcmf_attach(&devinfo->pdev->dev, devinfo->settings) == 0)
 		return;
 
 	brcmf_pcie_bus_console_read(devinfo);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 0f1e452..aa82336 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3422,6 +3422,8 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	if (bus->rxbuf)
 		bus->rxblen = value;
 
+	brcmf_sdio_debugfs_create(bus);
+
 	/* the commands below use the terms tx and rx from
 	 * a device perspective, ie. bus:txglom affects the
 	 * bus transfers from device to host.
@@ -4136,14 +4138,6 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		goto fail;
 	}
 
-	brcmf_sdio_debugfs_create(bus);
-
-	err = brcmf_bus_started(dev);
-	if (err != 0) {
-		brcmf_err("dongle is not responding\n");
-		goto fail;
-	}
-
 	/* ready */
 	return;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index d22cd166..41642dd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1155,27 +1155,6 @@ static int brcmf_usb_get_fwname(struct device *dev, u32 chip, u32 chiprev,
 	.get_fwname = brcmf_usb_get_fwname,
 };
 
-static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
-{
-	int ret;
-
-	/* Attach to the common driver interface */
-	ret = brcmf_attach(devinfo->dev, devinfo->settings);
-	if (ret) {
-		brcmf_err("brcmf_attach failed\n");
-		return ret;
-	}
-
-	ret = brcmf_bus_started(devinfo->dev);
-	if (ret)
-		goto fail;
-
-	return 0;
-fail:
-	brcmf_detach(devinfo->dev);
-	return ret;
-}
-
 static void brcmf_usb_probe_phase2(struct device *dev, int ret,
 				   const struct firmware *fw,
 				   void *nvram, u32 nvlen)
@@ -1203,7 +1182,8 @@ static void brcmf_usb_probe_phase2(struct device *dev, int ret,
 	if (ret)
 		goto error;
 
-	ret = brcmf_usb_bus_setup(devinfo);
+	/* Attach to the common driver interface */
+	ret = brcmf_attach(devinfo->dev, devinfo->settings);
 	if (ret)
 		goto error;
 
@@ -1253,7 +1233,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	}
 
 	if (!brcmf_usb_dlneeded(devinfo)) {
-		ret = brcmf_usb_bus_setup(devinfo);
+		ret = brcmf_attach(devinfo->dev, devinfo->settings);
 		if (ret)
 			goto fail;
 		/* we are done */
@@ -1456,7 +1436,7 @@ static int brcmf_usb_resume(struct usb_interface *intf)
 
 	brcmf_dbg(USB, "Enter\n");
 	if (!devinfo->wowl_enabled)
-		return brcmf_usb_bus_setup(devinfo);
+		return brcmf_attach(devinfo->dev, devinfo->settings);
 
 	devinfo->bus_pub.state = BRCMFMAC_USB_STATE_UP;
 	brcmf_usb_rx_fill_all(devinfo);
-- 
1.9.1
