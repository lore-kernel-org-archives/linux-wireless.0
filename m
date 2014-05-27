Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:57759 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaE0K4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/16] brcmfmac: rework usb callback operations
Date: Tue, 27 May 2014 12:56:19 +0200
Message-ID: <1401188188-16492-8-git-send-email-arend@broadcom.com> (sfid-20140527_125644_235453_9FE675E8)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The resume callbacks do partly the same a the probe callback
so put common code in separate function for use in the callbacks.
This also fixes suspend/resume regression introduced by

    brcmfmac: remove .init() callback for internal bus interface

    The .init() callback was the first function called by the common
    bus function brcmf_bus_start(). Given that it is not really
    necessary and the bus layer can call it before calling the
    brcmf_bus_start() function.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   48 ++++++++++++++-----------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 1c846c5..3c3ffff 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1227,6 +1227,31 @@ static struct brcmf_bus_ops brcmf_usb_bus_ops = {
 	.rxctl = brcmf_usb_rx_ctlpkt,
 };
 
+static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
+{
+	int ret;
+
+	/* Attach to the common driver interface */
+	ret = brcmf_attach(devinfo->dev);
+	if (ret) {
+		brcmf_err("brcmf_attach failed\n");
+		return ret;
+	}
+
+	ret = brcmf_usb_up(devinfo->dev);
+	if (ret)
+		goto fail;
+
+	ret = brcmf_bus_start(devinfo->dev);
+	if (ret)
+		goto fail;
+
+	return 0;
+fail:
+	brcmf_detach(devinfo->dev);
+	return ret;
+}
+
 static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 {
 	struct brcmf_bus *bus = NULL;
@@ -1255,23 +1280,9 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	bus->proto_type = BRCMF_PROTO_BCDC;
 	bus->always_use_fws_queue = true;
 
-	/* Attach to the common driver interface */
-	ret = brcmf_attach(dev);
-	if (ret) {
-		brcmf_err("brcmf_attach failed\n");
-		goto fail;
-	}
-
-	ret = brcmf_usb_up(dev);
-	if (ret) {
-		brcmf_detach(dev);
-		goto fail;
-	}
-
-	ret = brcmf_bus_start(dev);
+	ret = brcmf_usb_bus_setup(devinfo);
 	if (ret) {
 		brcmf_err("dongle is not responding\n");
-		brcmf_detach(dev);
 		goto fail;
 	}
 
@@ -1461,10 +1472,7 @@ static int brcmf_usb_resume(struct usb_interface *intf)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
 
 	brcmf_dbg(USB, "Enter\n");
-	if (!brcmf_attach(devinfo->dev))
-		return brcmf_bus_start(&usb->dev);
-
-	return 0;
+	return brcmf_usb_bus_setup(devinfo);
 }
 
 static int brcmf_usb_reset_resume(struct usb_interface *intf)
@@ -1475,7 +1483,7 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 	brcmf_dbg(USB, "Enter\n");
 
 	if (!brcmf_usb_fw_download(devinfo))
-		return brcmf_usb_resume(intf);
+		return brcmf_usb_bus_setup(devinfo);
 
 	return -EIO;
 }
-- 
1.7.9.5

