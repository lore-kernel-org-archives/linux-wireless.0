Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34722 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934478AbaFUKLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 06:11:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/8] brcmfmac: Change USB probe routine to support Composite USB
Date: Sat, 21 Jun 2014 12:11:15 +0200
Message-ID: <1403345479-13467-5-git-send-email-arend@broadcom.com> (sfid-20140621_121140_522702_68D8084A)
In-Reply-To: <1403345479-13467-1-git-send-email-arend@broadcom.com>
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Some of the USB devices also have Bluetooth inside. These devices
can with specific firmware result in a composite USB device. This
change will update the driver such that it will also accept the
correct interface of composite devices. It is backward compatible
with old non-composite USB fw.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |  204 +++++++++++--------------
 1 file changed, 87 insertions(+), 117 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index d2927ac..839bcda 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -29,33 +29,24 @@
 #include "usb_rdl.h"
 #include "usb.h"
 
-#define IOCTL_RESP_TIMEOUT  2000
+#define IOCTL_RESP_TIMEOUT		2000
 
 #define BRCMF_USB_RESET_GETVER_SPINWAIT	100	/* in unit of ms */
 #define BRCMF_USB_RESET_GETVER_LOOP_CNT	10
 
 #define BRCMF_POSTBOOT_ID		0xA123  /* ID to detect if dongle
 						   has boot up */
-#define BRCMF_USB_NRXQ	50
-#define BRCMF_USB_NTXQ	50
+#define BRCMF_USB_NRXQ			50
+#define BRCMF_USB_NTXQ			50
 
-#define CONFIGDESC(usb)         (&((usb)->actconfig)->desc)
-#define IFPTR(usb, idx)         ((usb)->actconfig->interface[(idx)])
-#define IFALTS(usb, idx)        (IFPTR((usb), (idx))->altsetting[0])
-#define IFDESC(usb, idx)        IFALTS((usb), (idx)).desc
-#define IFEPDESC(usb, idx, ep)  (IFALTS((usb), (idx)).endpoint[(ep)]).desc
+#define BRCMF_USB_CBCTL_WRITE		0
+#define BRCMF_USB_CBCTL_READ		1
+#define BRCMF_USB_MAX_PKT_SIZE		1600
 
-#define CONTROL_IF              0
-#define BULK_IF                 0
-
-#define BRCMF_USB_CBCTL_WRITE	0
-#define BRCMF_USB_CBCTL_READ	1
-#define BRCMF_USB_MAX_PKT_SIZE	1600
-
-#define BRCMF_USB_43143_FW_NAME	"brcm/brcmfmac43143.bin"
-#define BRCMF_USB_43236_FW_NAME	"brcm/brcmfmac43236b.bin"
-#define BRCMF_USB_43242_FW_NAME	"brcm/brcmfmac43242a.bin"
-#define BRCMF_USB_43569_FW_NAME	"brcm/brcmfmac43569.bin"
+#define BRCMF_USB_43143_FW_NAME		"brcm/brcmfmac43143.bin"
+#define BRCMF_USB_43236_FW_NAME		"brcm/brcmfmac43236b.bin"
+#define BRCMF_USB_43242_FW_NAME		"brcm/brcmfmac43242a.bin"
+#define BRCMF_USB_43569_FW_NAME		"brcm/brcmfmac43569.bin"
 
 struct brcmf_usb_image {
 	struct list_head list;
@@ -71,7 +62,7 @@ struct brcmf_usbdev_info {
 	struct list_head rx_postq;
 	struct list_head tx_freeq;
 	struct list_head tx_postq;
-	uint rx_pipe, tx_pipe, rx_pipe2;
+	uint rx_pipe, tx_pipe;
 
 	int rx_low_watermark;
 	int tx_low_watermark;
@@ -98,6 +89,7 @@ struct brcmf_usbdev_info {
 	int ctl_completed;
 	wait_queue_head_t ioctl_resp_wait;
 	ulong ctl_op;
+	u8 ifnum;
 
 	struct urb *bulk_urb; /* used for FW download */
 };
@@ -577,7 +569,6 @@ fail:
 static int brcmf_usb_up(struct device *dev)
 {
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
-	u16 ifnum;
 
 	brcmf_dbg(USB, "Enter\n");
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP)
@@ -590,21 +581,19 @@ static int brcmf_usb_up(struct device *dev)
 		devinfo->ctl_in_pipe = usb_rcvctrlpipe(devinfo->usbdev, 0);
 		devinfo->ctl_out_pipe = usb_sndctrlpipe(devinfo->usbdev, 0);
 
-		ifnum = IFDESC(devinfo->usbdev, CONTROL_IF).bInterfaceNumber;
-
 		/* CTL Write */
 		devinfo->ctl_write.bRequestType =
 			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE;
 		devinfo->ctl_write.bRequest = 0;
 		devinfo->ctl_write.wValue = cpu_to_le16(0);
-		devinfo->ctl_write.wIndex = cpu_to_le16p(&ifnum);
+		devinfo->ctl_write.wIndex = cpu_to_le16(devinfo->ifnum);
 
 		/* CTL Read */
 		devinfo->ctl_read.bRequestType =
 			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE;
 		devinfo->ctl_read.bRequest = 1;
 		devinfo->ctl_read.wValue = cpu_to_le16(0);
-		devinfo->ctl_read.wIndex = cpu_to_le16p(&ifnum);
+		devinfo->ctl_read.wIndex = cpu_to_le16(devinfo->ifnum);
 	}
 	brcmf_usb_rx_fill_all(devinfo);
 	return 0;
@@ -643,19 +632,19 @@ brcmf_usb_sync_complete(struct urb *urb)
 	brcmf_usb_ioctl_resp_wake(devinfo);
 }
 
-static bool brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
-			     void *buffer, int buflen)
+static int brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
+			    void *buffer, int buflen)
 {
-	int ret = 0;
+	int ret;
 	char *tmpbuf;
 	u16 size;
 
 	if ((!devinfo) || (devinfo->ctl_urb == NULL))
-		return false;
+		return -EINVAL;
 
 	tmpbuf = kmalloc(buflen, GFP_ATOMIC);
 	if (!tmpbuf)
-		return false;
+		return -ENOMEM;
 
 	size = buflen;
 	devinfo->ctl_urb->transfer_buffer_length = size;
@@ -676,14 +665,16 @@ static bool brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
 	ret = usb_submit_urb(devinfo->ctl_urb, GFP_ATOMIC);
 	if (ret < 0) {
 		brcmf_err("usb_submit_urb failed %d\n", ret);
-		kfree(tmpbuf);
-		return false;
+		goto finalize;
 	}
 
-	ret = brcmf_usb_ioctl_resp_wait(devinfo);
-	memcpy(buffer, tmpbuf, buflen);
-	kfree(tmpbuf);
+	if (!brcmf_usb_ioctl_resp_wait(devinfo))
+		ret = -ETIMEDOUT;
+	else
+		memcpy(buffer, tmpbuf, buflen);
 
+finalize:
+	kfree(tmpbuf);
 	return ret;
 }
 
@@ -725,6 +716,7 @@ brcmf_usb_resetcfg(struct brcmf_usbdev_info *devinfo)
 {
 	struct bootrom_id_le id;
 	u32 loop_cnt;
+	int err;
 
 	brcmf_dbg(USB, "Enter\n");
 
@@ -733,7 +725,9 @@ brcmf_usb_resetcfg(struct brcmf_usbdev_info *devinfo)
 		mdelay(BRCMF_USB_RESET_GETVER_SPINWAIT);
 		loop_cnt++;
 		id.chip = cpu_to_le32(0xDEAD);       /* Get the ID */
-		brcmf_usb_dl_cmd(devinfo, DL_GETVER, &id, sizeof(id));
+		err = brcmf_usb_dl_cmd(devinfo, DL_GETVER, &id, sizeof(id));
+		if ((err) && (err != -ETIMEDOUT))
+			return err;
 		if (id.chip == cpu_to_le32(BRCMF_POSTBOOT_ID))
 			break;
 	} while (loop_cnt < BRCMF_USB_RESET_GETVER_LOOP_CNT);
@@ -795,8 +789,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 	}
 
 	/* 1) Prepare USB boot loader for runtime image */
-	brcmf_usb_dl_cmd(devinfo, DL_START, &state,
-			 sizeof(struct rdl_state_le));
+	brcmf_usb_dl_cmd(devinfo, DL_START, &state, sizeof(state));
 
 	rdlstate = le32_to_cpu(state.state);
 	rdlbytes = le32_to_cpu(state.bytes);
@@ -840,10 +833,10 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 			dlpos += sendlen;
 			sent += sendlen;
 		}
-		if (!brcmf_usb_dl_cmd(devinfo, DL_GETSTATE, &state,
-				      sizeof(struct rdl_state_le))) {
-			brcmf_err("DL_GETSTATE Failed xxxx\n");
-			err = -EINVAL;
+		err = brcmf_usb_dl_cmd(devinfo, DL_GETSTATE, &state,
+				       sizeof(state));
+		if (err) {
+			brcmf_err("DL_GETSTATE Failed\n");
 			goto fail;
 		}
 
@@ -899,13 +892,12 @@ static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 		return -EINVAL;
 
 	/* Check we are runnable */
-	brcmf_usb_dl_cmd(devinfo, DL_GETSTATE, &state,
-		sizeof(struct rdl_state_le));
+	state.state = 0;
+	brcmf_usb_dl_cmd(devinfo, DL_GETSTATE, &state, sizeof(state));
 
 	/* Start the image */
 	if (state.state == cpu_to_le32(DL_RUNNABLE)) {
-		if (!brcmf_usb_dl_cmd(devinfo, DL_GO, &state,
-			sizeof(struct rdl_state_le)))
+		if (brcmf_usb_dl_cmd(devinfo, DL_GO, &state, sizeof(state)))
 			return -ENODEV;
 		if (brcmf_usb_resetcfg(devinfo))
 			return -ENODEV;
@@ -1228,13 +1220,13 @@ brcmf_usb_disconnect_cb(struct brcmf_usbdev_info *devinfo)
 static int
 brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
-	int ep;
-	struct usb_endpoint_descriptor *endpoint;
-	int ret = 0;
 	struct usb_device *usb = interface_to_usbdev(intf);
-	int num_of_eps;
-	u8 endpoint_num;
 	struct brcmf_usbdev_info *devinfo;
+	struct usb_interface_descriptor	*desc;
+	struct usb_endpoint_descriptor *endpoint;
+	int ret = 0;
+	u32 num_of_eps;
+	u8 endpoint_num, ep;
 
 	brcmf_dbg(USB, "Enter 0x%04x:0x%04x\n", id->idVendor, id->idProduct);
 
@@ -1244,92 +1236,71 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	devinfo->usbdev = usb;
 	devinfo->dev = &usb->dev;
-
 	usb_set_intfdata(intf, devinfo);
 
 	/* Check that the device supports only one configuration */
 	if (usb->descriptor.bNumConfigurations != 1) {
-		ret = -1;
-		goto fail;
-	}
-
-	if (usb->descriptor.bDeviceClass != USB_CLASS_VENDOR_SPEC) {
-		ret = -1;
-		goto fail;
-	}
-
-	/*
-	 * Only the BDC interface configuration is supported:
-	 *	Device class: USB_CLASS_VENDOR_SPEC
-	 *	if0 class: USB_CLASS_VENDOR_SPEC
-	 *	if0/ep0: control
-	 *	if0/ep1: bulk in
-	 *	if0/ep2: bulk out (ok if swapped with bulk in)
-	 */
-	if (CONFIGDESC(usb)->bNumInterfaces != 1) {
-		ret = -1;
+		brcmf_err("Number of configurations: %d not supported\n",
+			  usb->descriptor.bNumConfigurations);
+		ret = -ENODEV;
 		goto fail;
 	}
 
-	/* Check interface */
-	if (IFDESC(usb, CONTROL_IF).bInterfaceClass != USB_CLASS_VENDOR_SPEC ||
-	    IFDESC(usb, CONTROL_IF).bInterfaceSubClass != 2 ||
-	    IFDESC(usb, CONTROL_IF).bInterfaceProtocol != 0xff) {
-		brcmf_err("invalid control interface: class %d, subclass %d, proto %d\n",
-			  IFDESC(usb, CONTROL_IF).bInterfaceClass,
-			  IFDESC(usb, CONTROL_IF).bInterfaceSubClass,
-			  IFDESC(usb, CONTROL_IF).bInterfaceProtocol);
-		ret = -1;
+	if ((usb->descriptor.bDeviceClass != USB_CLASS_VENDOR_SPEC) &&
+	    (usb->descriptor.bDeviceClass != USB_CLASS_MISC) &&
+	    (usb->descriptor.bDeviceClass != USB_CLASS_WIRELESS_CONTROLLER)) {
+		brcmf_err("Device class: 0x%x not supported\n",
+			  usb->descriptor.bDeviceClass);
+		ret = -ENODEV;
 		goto fail;
 	}
 
-	/* Check control endpoint */
-	endpoint = &IFEPDESC(usb, CONTROL_IF, 0);
-	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-		!= USB_ENDPOINT_XFER_INT) {
-		brcmf_err("invalid control endpoint %d\n",
-			  endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK);
-		ret = -1;
+	desc = &intf->altsetting[0].desc;
+	if ((desc->bInterfaceClass != USB_CLASS_VENDOR_SPEC) ||
+	    (desc->bInterfaceSubClass != 2) ||
+	    (desc->bInterfaceProtocol != 0xff)) {
+		brcmf_err("non WLAN interface %d: 0x%x:0x%x:0x%x\n",
+			  desc->bInterfaceNumber, desc->bInterfaceClass,
+			  desc->bInterfaceSubClass, desc->bInterfaceProtocol);
+		ret = -ENODEV;
 		goto fail;
 	}
 
-	devinfo->rx_pipe = 0;
-	devinfo->rx_pipe2 = 0;
-	devinfo->tx_pipe = 0;
-	num_of_eps = IFDESC(usb, BULK_IF).bNumEndpoints - 1;
-
-	/* Check data endpoints and get pipes */
-	for (ep = 1; ep <= num_of_eps; ep++) {
-		endpoint = &IFEPDESC(usb, BULK_IF, ep);
-		if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) !=
-		    USB_ENDPOINT_XFER_BULK) {
-			brcmf_err("invalid data endpoint %d\n", ep);
-			ret = -1;
-			goto fail;
-		}
-
-		endpoint_num = endpoint->bEndpointAddress &
-			       USB_ENDPOINT_NUMBER_MASK;
-		if ((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
-			== USB_DIR_IN) {
-			if (!devinfo->rx_pipe) {
+	num_of_eps = desc->bNumEndpoints;
+	for (ep = 0; ep < num_of_eps; ep++) {
+		endpoint = &intf->altsetting[0].endpoint[ep].desc;
+		endpoint_num = usb_endpoint_num(endpoint);
+		if (!usb_endpoint_xfer_bulk(endpoint))
+			continue;
+		if (usb_endpoint_dir_in(endpoint)) {
+			if (!devinfo->rx_pipe)
 				devinfo->rx_pipe =
 					usb_rcvbulkpipe(usb, endpoint_num);
-			} else {
-				devinfo->rx_pipe2 =
-					usb_rcvbulkpipe(usb, endpoint_num);
-			}
 		} else {
-			devinfo->tx_pipe = usb_sndbulkpipe(usb, endpoint_num);
+			if (!devinfo->tx_pipe)
+				devinfo->tx_pipe =
+					usb_sndbulkpipe(usb, endpoint_num);
 		}
 	}
+	if (devinfo->rx_pipe == 0) {
+		brcmf_err("No RX (in) Bulk EP found\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+	if (devinfo->tx_pipe == 0) {
+		brcmf_err("No TX (out) Bulk EP found\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+
+	devinfo->ifnum = desc->bInterfaceNumber;
 
 	if (usb->speed == USB_SPEED_SUPER)
-		brcmf_dbg(USB, "Broadcom super speed USB wireless device detected\n");
+		brcmf_dbg(USB, "Broadcom super speed USB WLAN interface detected\n");
 	else if (usb->speed == USB_SPEED_HIGH)
-		brcmf_dbg(USB, "Broadcom high speed USB wireless device detected\n");
+		brcmf_dbg(USB, "Broadcom high speed USB WLAN interface detected\n");
 	else
-		brcmf_dbg(USB, "Broadcom full speed USB wireless device detected\n");
+		brcmf_dbg(USB, "Broadcom full speed USB WLAN interface detected\n");
 
 	ret = brcmf_usb_probe_cb(devinfo);
 	if (ret)
@@ -1339,11 +1310,9 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	return 0;
 
 fail:
-	brcmf_err("failed with errno %d\n", ret);
 	kfree(devinfo);
 	usb_set_intfdata(intf, NULL);
 	return ret;
-
 }
 
 static void
@@ -1388,6 +1357,7 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 {
 	struct usb_device *usb = interface_to_usbdev(intf);
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
+
 	brcmf_dbg(USB, "Enter\n");
 
 	return brcmf_fw_get_firmwares(&usb->dev, 0,
-- 
1.7.9.5

