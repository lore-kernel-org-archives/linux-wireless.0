Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3404 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab2KOCqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:35 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 03/19] brcmfmac: usb suspend/resume.
Date: Wed, 14 Nov 2012 18:46:07 -0800
Message-ID: <1352947583-25341-4-git-send-email-frankyl@broadcom.com> (sfid-20121115_034656_358252_0DA05A6E)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Add support for usb suspend/resume.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |  136 ++++++++++---------------
 drivers/net/wireless/brcm80211/brcmfmac/usb.h |   18 +---
 2 files changed, 58 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 395c49d..589afe6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -67,16 +67,6 @@
 #define BRCMF_USB_43236_FW_NAME	"brcm/brcmfmac43236b.bin"
 #define BRCMF_USB_43242_FW_NAME	"brcm/brcmfmac43242a.bin"
 
-enum usbdev_suspend_state {
-	USBOS_SUSPEND_STATE_DEVICE_ACTIVE = 0, /* Device is busy, won't allow
-						  suspend */
-	USBOS_SUSPEND_STATE_SUSPEND_PENDING,	/* Device is idle, can be
-						 * suspended. Wating PM to
-						 * suspend the device
-						 */
-	USBOS_SUSPEND_STATE_SUSPENDED	/* Device suspended */
-};
-
 struct brcmf_usb_image {
 	struct list_head list;
 	s8 *fwname;
@@ -97,10 +87,8 @@ struct brcmf_usbdev_info {
 	struct list_head rx_postq;
 	struct list_head tx_freeq;
 	struct list_head tx_postq;
-	enum usbdev_suspend_state suspend_state;
 	uint rx_pipe, tx_pipe, intr_pipe, rx_pipe2;
 
-	bool activity;
 	int rx_low_watermark;
 	int tx_low_watermark;
 	int tx_high_watermark;
@@ -213,11 +201,6 @@ brcmf_usb_ctlwrite_complete(struct urb *urb)
 		urb->status);
 }
 
-static int brcmf_usb_pnp(struct brcmf_usbdev_info *devinfo, uint state)
-{
-	return 0;
-}
-
 static int
 brcmf_usb_send_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 {
@@ -229,14 +212,6 @@ brcmf_usb_send_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 	    len == 0 || devinfo->ctl_urb == NULL)
 		return -EINVAL;
 
-	/* If the USB/HSIC bus in sleep state, wake it up */
-	if (devinfo->suspend_state == USBOS_SUSPEND_STATE_SUSPENDED)
-		if (brcmf_usb_pnp(devinfo, BCMFMAC_USB_PNP_RESUME) != 0) {
-			brcmf_dbg(ERROR, "Could not Resume the bus!\n");
-			return -EIO;
-		}
-
-	devinfo->activity = true;
 	size = len;
 	devinfo->ctl_write.wLength = cpu_to_le16p(&size);
 	devinfo->ctl_urb->transfer_buffer_length = size;
@@ -299,10 +274,8 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 
 	brcmf_dbg(USB, "Enter\n");
-	if (devinfo->bus_pub.state != BCMFMAC_USB_STATE_UP) {
-		/* TODO: handle suspend/resume */
+	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP)
 		return -EIO;
-	}
 
 	if (test_and_set_bit(0, &devinfo->ctl_op))
 		return -EIO;
@@ -330,10 +303,9 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 
 	brcmf_dbg(USB, "Enter\n");
-	if (devinfo->bus_pub.state != BCMFMAC_USB_STATE_UP) {
-		/* TODO: handle suspend/resume */
+	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP)
 		return -EIO;
-	}
+
 	if (test_and_set_bit(0, &devinfo->ctl_op))
 		return -EIO;
 
@@ -499,7 +471,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 		return;
 	}
 
-	if (devinfo->bus_pub.state == BCMFMAC_USB_STATE_UP) {
+	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP) {
 		skb_put(skb, urb->actual_length);
 		if (brcmf_proto_hdrpull(devinfo->dev, &ifidx, skb) != 0) {
 			brcmf_dbg(ERROR, "rx protocol error\n");
@@ -552,8 +524,8 @@ static void brcmf_usb_rx_fill_all(struct brcmf_usbdev_info *devinfo)
 {
 	struct brcmf_usbreq *req;
 
-	if (devinfo->bus_pub.state != BCMFMAC_USB_STATE_UP) {
-		brcmf_dbg(ERROR, "bus is not up\n");
+	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP) {
+		brcmf_dbg(ERROR, "bus is not up=%d\n", devinfo->bus_pub.state);
 		return;
 	}
 	while ((req = brcmf_usb_deq(devinfo, &devinfo->rx_freeq, NULL)) != NULL)
@@ -573,20 +545,15 @@ brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
 		return;
 
 	old_state = devinfo->bus_pub.state;
-
-	/* Don't update state if it's PnP firmware re-download */
-	if (state != BCMFMAC_USB_STATE_PNP_FWDL) /* TODO */
-		devinfo->bus_pub.state = state;
-
-	if ((old_state  == BCMFMAC_USB_STATE_SLEEP)
-		&& (state == BCMFMAC_USB_STATE_UP)) {
-		brcmf_usb_rx_fill_all(devinfo);
-	}
+	devinfo->bus_pub.state = state;
 
 	/* update state of upper layer */
-	if (state == BCMFMAC_USB_STATE_DOWN) {
+	if (state == BRCMFMAC_USB_STATE_DOWN) {
 		brcmf_dbg(USB, "DBUS is down\n");
 		bcmf_bus->state = BRCMF_BUS_DOWN;
+	} else if (state == BRCMFMAC_USB_STATE_UP) {
+		brcmf_dbg(USB, "DBUS is up\n");
+		bcmf_bus->state = BRCMF_BUS_DATA;
 	} else {
 		brcmf_dbg(USB, "DBUS current state=%d\n", state);
 	}
@@ -597,7 +564,7 @@ brcmf_usb_intr_complete(struct urb *urb)
 {
 	struct brcmf_usbdev_info *devinfo =
 			(struct brcmf_usbdev_info *)urb->context;
-	bool killed;
+	int err;
 
 	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
 
@@ -605,24 +572,24 @@ brcmf_usb_intr_complete(struct urb *urb)
 		return;
 
 	if (unlikely(urb->status)) {
-		if (devinfo->suspend_state ==
-			USBOS_SUSPEND_STATE_SUSPEND_PENDING)
-			killed = true;
-
-		if ((urb->status == -ENOENT && (!killed))
-			|| urb->status == -ESHUTDOWN ||
-			urb->status == -ENODEV) {
-			brcmf_usb_state_change(devinfo, BCMFMAC_USB_STATE_DOWN);
+		if (urb->status == -ENOENT ||
+		    urb->status == -ESHUTDOWN ||
+		    urb->status == -ENODEV) {
+			brcmf_usb_state_change(devinfo,
+					       BRCMFMAC_USB_STATE_DOWN);
 		}
 	}
 
-	if (devinfo->bus_pub.state == BCMFMAC_USB_STATE_DOWN) {
+	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_DOWN) {
 		brcmf_dbg(ERROR, "intr cb when DBUS down, ignoring\n");
 		return;
 	}
 
-	if (devinfo->bus_pub.state == BCMFMAC_USB_STATE_UP)
-		usb_submit_urb(devinfo->intr_urb, GFP_ATOMIC);
+	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP) {
+		err = usb_submit_urb(devinfo->intr_urb, GFP_ATOMIC);
+		if (err)
+			brcmf_dbg(ERROR, "usb_submit_urb, err=%d\n", err);
+	}
 }
 
 static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
@@ -632,10 +599,8 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	int ret;
 
 	brcmf_dbg(USB, "Enter, skb=%p\n", skb);
-	if (devinfo->bus_pub.state != BCMFMAC_USB_STATE_UP) {
-		/* TODO: handle suspend/resume */
+	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP)
 		return -EIO;
-	}
 
 	req = brcmf_usb_deq(devinfo, &devinfo->tx_freeq,
 					&devinfo->tx_freecount);
@@ -675,26 +640,16 @@ static int brcmf_usb_up(struct device *dev)
 {
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 	u16 ifnum;
+	int ret;
 
 	brcmf_dbg(USB, "Enter\n");
-	if (devinfo->bus_pub.state == BCMFMAC_USB_STATE_UP)
+	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP)
 		return 0;
 
-	/* If the USB/HSIC bus in sleep state, wake it up */
-	if (devinfo->suspend_state == USBOS_SUSPEND_STATE_SUSPENDED) {
-		if (brcmf_usb_pnp(devinfo, BCMFMAC_USB_PNP_RESUME) != 0) {
-			brcmf_dbg(ERROR, "Could not Resume the bus!\n");
-			return -EIO;
-		}
-	}
-	devinfo->activity = true;
-
 	/* Success, indicate devinfo is fully up */
-	brcmf_usb_state_change(devinfo, BCMFMAC_USB_STATE_UP);
+	brcmf_usb_state_change(devinfo, BRCMFMAC_USB_STATE_UP);
 
 	if (devinfo->intr_urb) {
-		int ret;
-
 		usb_fill_int_urb(devinfo->intr_urb, devinfo->usbdev,
 			devinfo->intr_pipe,
 			&devinfo->intr,
@@ -743,10 +698,10 @@ static void brcmf_usb_down(struct device *dev)
 	if (devinfo == NULL)
 		return;
 
-	if (devinfo->bus_pub.state == BCMFMAC_USB_STATE_DOWN)
+	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_DOWN)
 		return;
 
-	brcmf_usb_state_change(devinfo, BCMFMAC_USB_STATE_DOWN);
+	brcmf_usb_state_change(devinfo, BRCMFMAC_USB_STATE_DOWN);
 	if (devinfo->intr_urb)
 		usb_kill_urb(devinfo->intr_urb);
 
@@ -1006,9 +961,9 @@ static int brcmf_usb_dlstart(struct brcmf_usbdev_info *devinfo, u8 *fw, int len)
 
 	err = brcmf_usb_dl_writeimage(devinfo, fw, len);
 	if (err == 0)
-		devinfo->bus_pub.state = BCMFMAC_USB_STATE_DL_DONE;
+		devinfo->bus_pub.state = BRCMFMAC_USB_STATE_DL_DONE;
 	else
-		devinfo->bus_pub.state = BCMFMAC_USB_STATE_DL_PENDING;
+		devinfo->bus_pub.state = BRCMFMAC_USB_STATE_DL_FAIL;
 	brcmf_dbg(USB, "Exit, err=%d\n", err);
 
 	return err;
@@ -1221,6 +1176,7 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 	devinfo->rx_low_watermark = nrxq / 2;
 	devinfo->bus_pub.devinfo = devinfo;
 	devinfo->bus_pub.ntxq = ntxq;
+	devinfo->bus_pub.state = BRCMFMAC_USB_STATE_DOWN;
 
 	/* flow control when too many tx urbs posted */
 	devinfo->tx_low_watermark = ntxq / 4;
@@ -1491,7 +1447,7 @@ brcmf_usb_disconnect(struct usb_interface *intf)
 }
 
 /*
- *	only need to signal the bus being down and update the suspend state.
+ * only need to signal the bus being down and update the state.
  */
 static int brcmf_usb_suspend(struct usb_interface *intf, pm_message_t state)
 {
@@ -1499,13 +1455,13 @@ static int brcmf_usb_suspend(struct usb_interface *intf, pm_message_t state)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
 
 	brcmf_dbg(USB, "Enter\n");
-	devinfo->bus_pub.state = BCMFMAC_USB_STATE_DOWN;
-	devinfo->suspend_state = USBOS_SUSPEND_STATE_SUSPENDED;
+	devinfo->bus_pub.state = BRCMFMAC_USB_STATE_SLEEP;
+	brcmf_detach(&usb->dev);
 	return 0;
 }
 
 /*
- *	mark suspend state active and crank up the bus.
+ * (re-) start the bus.
  */
 static int brcmf_usb_resume(struct usb_interface *intf)
 {
@@ -1513,11 +1469,25 @@ static int brcmf_usb_resume(struct usb_interface *intf)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
 
 	brcmf_dbg(USB, "Enter\n");
-	devinfo->suspend_state = USBOS_SUSPEND_STATE_DEVICE_ACTIVE;
-	brcmf_bus_start(&usb->dev);
+	if (!brcmf_attach(0, devinfo->dev))
+		return brcmf_bus_start(&usb->dev);
+
 	return 0;
 }
 
+static int brcmf_usb_reset_resume(struct usb_interface *intf)
+{
+	struct usb_device *usb = interface_to_usbdev(intf);
+	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
+
+	brcmf_dbg(USB, "Enter\n");
+
+	if (!brcmf_usb_fw_download(devinfo))
+		return brcmf_usb_resume(intf);
+
+	return -EIO;
+}
+
 #define BRCMF_USB_VENDOR_ID_BROADCOM	0x0a5c
 #define BRCMF_USB_DEVICE_ID_43143	0xbd1e
 #define BRCMF_USB_DEVICE_ID_43236	0xbd17
@@ -1537,7 +1507,6 @@ MODULE_FIRMWARE(BRCMF_USB_43143_FW_NAME);
 MODULE_FIRMWARE(BRCMF_USB_43236_FW_NAME);
 MODULE_FIRMWARE(BRCMF_USB_43242_FW_NAME);
 
-/* TODO: suspend and resume entries */
 static struct usb_driver brcmf_usbdrvr = {
 	.name = KBUILD_MODNAME,
 	.probe = brcmf_usb_probe,
@@ -1545,6 +1514,7 @@ static struct usb_driver brcmf_usbdrvr = {
 	.id_table = brcmf_usb_devid_table,
 	.suspend = brcmf_usb_suspend,
 	.resume = brcmf_usb_resume,
+	.reset_resume = brcmf_usb_reset_resume,
 	.supports_autosuspend = 1,
 	.disable_hub_initiated_lpm = 1,
 };
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.h b/drivers/net/wireless/brcm80211/brcmfmac/usb.h
index acfa5e8..f483a8c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.h
@@ -17,19 +17,11 @@
 #define BRCMFMAC_USB_H
 
 enum brcmf_usb_state {
-	BCMFMAC_USB_STATE_DL_PENDING,
-	BCMFMAC_USB_STATE_DL_DONE,
-	BCMFMAC_USB_STATE_UP,
-	BCMFMAC_USB_STATE_DOWN,
-	BCMFMAC_USB_STATE_PNP_FWDL,
-	BCMFMAC_USB_STATE_DISCONNECT,
-	BCMFMAC_USB_STATE_SLEEP
-};
-
-enum brcmf_usb_pnp_state {
-	BCMFMAC_USB_PNP_DISCONNECT,
-	BCMFMAC_USB_PNP_SLEEP,
-	BCMFMAC_USB_PNP_RESUME,
+	BRCMFMAC_USB_STATE_DOWN,
+	BRCMFMAC_USB_STATE_DL_FAIL,
+	BRCMFMAC_USB_STATE_DL_DONE,
+	BRCMFMAC_USB_STATE_UP,
+	BRCMFMAC_USB_STATE_SLEEP
 };
 
 struct brcmf_stats {
-- 
1.7.9.5


