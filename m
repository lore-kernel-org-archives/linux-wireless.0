Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:54408 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbbJHSdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/11] brcmfmac: Fix race condition between USB probe/load and disconnect.
Date: Thu, 8 Oct 2015 20:33:12 +0200
Message-ID: <1444329201-3696-3-git-send-email-arend@broadcom.com> (sfid-20151008_203340_520698_46E947EB)
In-Reply-To: <1444329201-3696-1-git-send-email-arend@broadcom.com>
References: <1444329201-3696-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When a USB device gets disconnected due to for example removal
then it is possible that it is still in the loading phase due to
the asynchronous load routines. These routines can then possible
access memory which has been freed. Fix this by mutex locking the
device init phase.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c | 29 ++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index daba86d..689e64d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -144,6 +144,7 @@ struct brcmf_usbdev_info {
 
 	struct usb_device *usbdev;
 	struct device *dev;
+	struct mutex dev_init_lock;
 
 	int ctl_in_pipe, ctl_out_pipe;
 	struct urb *ctl_urb; /* URB for control endpoint */
@@ -1204,6 +1205,8 @@ static void brcmf_usb_probe_phase2(struct device *dev,
 	int ret;
 
 	brcmf_dbg(USB, "Start fw downloading\n");
+
+	devinfo = bus->bus_priv.usb->devinfo;
 	ret = check_file(fw->data);
 	if (ret < 0) {
 		brcmf_err("invalid firmware\n");
@@ -1211,7 +1214,6 @@ static void brcmf_usb_probe_phase2(struct device *dev,
 		goto error;
 	}
 
-	devinfo = bus->bus_priv.usb->devinfo;
 	devinfo->image = fw->data;
 	devinfo->image_len = fw->size;
 
@@ -1224,9 +1226,11 @@ static void brcmf_usb_probe_phase2(struct device *dev,
 	if (ret)
 		goto error;
 
+	mutex_unlock(&devinfo->dev_init_lock);
 	return;
 error:
 	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), ret);
+	mutex_unlock(&devinfo->dev_init_lock);
 	device_release_driver(dev);
 }
 
@@ -1264,6 +1268,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 		if (ret)
 			goto fail;
 		/* we are done */
+		mutex_unlock(&devinfo->dev_init_lock);
 		return 0;
 	}
 	bus->chip = bus_pub->devid;
@@ -1317,6 +1322,12 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	devinfo->usbdev = usb;
 	devinfo->dev = &usb->dev;
+	/* Take an init lock, to protect for disconnect while still loading.
+	 * Necessary because of the asynchronous firmware load construction
+	 */
+	mutex_init(&devinfo->dev_init_lock);
+	mutex_lock(&devinfo->dev_init_lock);
+
 	usb_set_intfdata(intf, devinfo);
 
 	/* Check that the device supports only one configuration */
@@ -1391,6 +1402,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	return 0;
 
 fail:
+	mutex_unlock(&devinfo->dev_init_lock);
 	kfree(devinfo);
 	usb_set_intfdata(intf, NULL);
 	return ret;
@@ -1403,8 +1415,19 @@ brcmf_usb_disconnect(struct usb_interface *intf)
 
 	brcmf_dbg(USB, "Enter\n");
 	devinfo = (struct brcmf_usbdev_info *)usb_get_intfdata(intf);
-	brcmf_usb_disconnect_cb(devinfo);
-	kfree(devinfo);
+
+	if (devinfo) {
+		mutex_lock(&devinfo->dev_init_lock);
+		/* Make sure that devinfo still exists. Firmware probe routines
+		 * may have released the device and cleared the intfdata.
+		 */
+		if (!usb_get_intfdata(intf))
+			goto done;
+
+		brcmf_usb_disconnect_cb(devinfo);
+		kfree(devinfo);
+	}
+done:
 	brcmf_dbg(USB, "Exit\n");
 }
 
-- 
1.9.1

