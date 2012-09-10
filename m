Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3842 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab2IJNXS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 09:23:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/10] brcmfmac: avoid using local usb data.
Date: Mon, 10 Sep 2012 15:16:57 +0200
Message-ID: <1347283018-24223-10-git-send-email-arend@broadcom.com> (sfid-20120910_152323_159376_E86F5057)
In-Reply-To: <1347283018-24223-1-git-send-email-arend@broadcom.com>
References: <1347283018-24223-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch removes usage of some of the local data in the usb
host interface driver. This is a step in the preperation to
support multiple USB devices.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |  119 ++++++++-----------------
 1 file changed, 39 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 6e3ff6f..c6d5aeb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -80,20 +80,6 @@ enum usbdev_suspend_state {
 	USBOS_SUSPEND_STATE_SUSPENDED	/* Device suspended */
 };
 
-struct brcmf_usb_probe_info {
-	void *usbdev_info;
-	struct usb_device *usb; /* USB device pointer from OS */
-	uint rx_pipe, tx_pipe, intr_pipe, rx_pipe2;
-	int intr_size; /* Size of interrupt message */
-	int interval;  /* Interrupt polling interval */
-	int vid;
-	int pid;
-	enum usb_device_speed device_speed;
-	enum usbdev_suspend_state suspend_state;
-	struct usb_interface *intf;
-};
-static struct brcmf_usb_probe_info usbdev_probe_info;
-
 struct brcmf_usb_image {
 	void *data;
 	u32 len;
@@ -134,7 +120,6 @@ struct brcmf_usbdev_info {
 
 	struct usb_device *usbdev;
 	struct device *dev;
-	enum usb_device_speed  device_speed;
 
 	int ctl_in_pipe, ctl_out_pipe;
 	struct urb *ctl_urb; /* URB for control endpoint */
@@ -154,9 +139,6 @@ struct brcmf_usbdev_info {
 	int intr_size;          /* Size of interrupt message */
 	int interval;           /* Interrupt polling interval */
 	struct intr_transfer_buf intr; /* Data buffer for interrupt endpoint */
-
-	struct brcmf_usb_probe_info probe_info;
-
 };
 
 static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
@@ -1166,11 +1148,8 @@ brcmf_usb_fw_download(struct brcmf_usbdev_info *devinfo)
 }
 
 
-static void brcmf_usb_detach(const struct brcmf_usbdev *bus_pub)
+static void brcmf_usb_detach(struct brcmf_usbdev_info *devinfo)
 {
-	struct brcmf_usbdev_info *devinfo =
-		(struct brcmf_usbdev_info *)bus_pub;
-
 	brcmf_dbg(TRACE, "devinfo %p\n", devinfo);
 
 	/* store the image globally */
@@ -1187,7 +1166,6 @@ static void brcmf_usb_detach(const struct brcmf_usbdev *bus_pub)
 
 	kfree(devinfo->tx_reqs);
 	kfree(devinfo->rx_reqs);
-	kfree(devinfo);
 }
 
 #define TRX_MAGIC       0x30524448      /* "HDR0" */
@@ -1280,14 +1258,9 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 
 
 static
-struct brcmf_usbdev *brcmf_usb_attach(int nrxq, int ntxq, struct device *dev)
+struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
+				      int nrxq, int ntxq)
 {
-	struct brcmf_usbdev_info *devinfo;
-
-	devinfo = kzalloc(sizeof(struct brcmf_usbdev_info), GFP_ATOMIC);
-	if (devinfo == NULL)
-		return NULL;
-
 	devinfo->bus_pub.nrxq = nrxq;
 	devinfo->rx_low_watermark = nrxq / 2;
 	devinfo->bus_pub.devinfo = devinfo;
@@ -1296,18 +1269,6 @@ struct brcmf_usbdev *brcmf_usb_attach(int nrxq, int ntxq, struct device *dev)
 	/* flow control when too many tx urbs posted */
 	devinfo->tx_low_watermark = ntxq / 4;
 	devinfo->tx_high_watermark = devinfo->tx_low_watermark * 3;
-	devinfo->dev = dev;
-	devinfo->usbdev = usbdev_probe_info.usb;
-	devinfo->tx_pipe = usbdev_probe_info.tx_pipe;
-	devinfo->rx_pipe = usbdev_probe_info.rx_pipe;
-	devinfo->rx_pipe2 = usbdev_probe_info.rx_pipe2;
-	devinfo->intr_pipe = usbdev_probe_info.intr_pipe;
-
-	devinfo->interval = usbdev_probe_info.interval;
-	devinfo->intr_size = usbdev_probe_info.intr_size;
-
-	memcpy(&devinfo->probe_info, &usbdev_probe_info,
-		sizeof(struct brcmf_usb_probe_info));
 	devinfo->bus_pub.bus_mtu = BRCMF_USB_MAX_PKT_SIZE;
 
 	/* Initialize other structure content */
@@ -1366,19 +1327,19 @@ struct brcmf_usbdev *brcmf_usb_attach(int nrxq, int ntxq, struct device *dev)
 
 error:
 	brcmf_dbg(ERROR, "failed!\n");
-	brcmf_usb_detach(&devinfo->bus_pub);
+	brcmf_usb_detach(devinfo);
 	return NULL;
 }
 
-static int brcmf_usb_probe_cb(struct device *dev, const char *desc,
-				u32 bustype, u32 hdrlen)
+static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo,
+			      const char *desc,	u32 bustype, u32 hdrlen)
 {
 	struct brcmf_bus *bus = NULL;
 	struct brcmf_usbdev *bus_pub = NULL;
 	int ret;
+	struct device *dev = devinfo->dev;
 
-
-	bus_pub = brcmf_usb_attach(BRCMF_USB_NRXQ, BRCMF_USB_NTXQ, dev);
+	bus_pub = brcmf_usb_attach(devinfo, BRCMF_USB_NRXQ, BRCMF_USB_NTXQ);
 	if (!bus_pub) {
 		ret = -ENODEV;
 		goto fail;
@@ -1417,23 +1378,21 @@ static int brcmf_usb_probe_cb(struct device *dev, const char *desc,
 	return 0;
 fail:
 	/* Release resources in reverse order */
-	if (bus_pub)
-		brcmf_usb_detach(bus_pub);
 	kfree(bus);
+	brcmf_usb_detach(devinfo);
 	return ret;
 }
 
 static void
-brcmf_usb_disconnect_cb(struct brcmf_usbdev *bus_pub)
+brcmf_usb_disconnect_cb(struct brcmf_usbdev_info *devinfo)
 {
-	if (!bus_pub)
+	if (!devinfo)
 		return;
-	brcmf_dbg(TRACE, "enter: bus_pub %p\n", bus_pub);
-
-	brcmf_detach(bus_pub->devinfo->dev);
-	kfree(bus_pub->bus);
-	brcmf_usb_detach(bus_pub);
+	brcmf_dbg(TRACE, "enter: bus_pub %p\n", devinfo);
 
+	brcmf_detach(devinfo->dev);
+	kfree(devinfo->bus_pub.bus);
+	brcmf_usb_detach(devinfo);
 }
 
 static int
@@ -1445,18 +1404,18 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct usb_device *usb = interface_to_usbdev(intf);
 	int num_of_eps;
 	u8 endpoint_num;
+	struct brcmf_usbdev_info *devinfo;
 
 	brcmf_dbg(TRACE, "enter\n");
 
-	usbdev_probe_info.usb = usb;
-	usbdev_probe_info.intf = intf;
+	devinfo = kzalloc(sizeof(*devinfo), GFP_ATOMIC);
+	if (devinfo == NULL)
+		return -ENOMEM;
 
-	if (id != NULL) {
-		usbdev_probe_info.vid = id->idVendor;
-		usbdev_probe_info.pid = id->idProduct;
-	}
+	devinfo->usbdev = usb;
+	devinfo->dev = &usb->dev;
 
-	usb_set_intfdata(intf, &usbdev_probe_info);
+	usb_set_intfdata(intf, devinfo);
 
 	/* Check that the device supports only one configuration */
 	if (usb->descriptor.bNumConfigurations != 1) {
@@ -1505,11 +1464,11 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	}
 
 	endpoint_num = endpoint->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
-	usbdev_probe_info.intr_pipe = usb_rcvintpipe(usb, endpoint_num);
+	devinfo->intr_pipe = usb_rcvintpipe(usb, endpoint_num);
 
-	usbdev_probe_info.rx_pipe = 0;
-	usbdev_probe_info.rx_pipe2 = 0;
-	usbdev_probe_info.tx_pipe = 0;
+	devinfo->rx_pipe = 0;
+	devinfo->rx_pipe2 = 0;
+	devinfo->tx_pipe = 0;
 	num_of_eps = IFDESC(usb, BULK_IF).bNumEndpoints - 1;
 
 	/* Check data endpoints and get pipes */
@@ -1526,35 +1485,33 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 			       USB_ENDPOINT_NUMBER_MASK;
 		if ((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
 			== USB_DIR_IN) {
-			if (!usbdev_probe_info.rx_pipe) {
-				usbdev_probe_info.rx_pipe =
+			if (!devinfo->rx_pipe) {
+				devinfo->rx_pipe =
 					usb_rcvbulkpipe(usb, endpoint_num);
 			} else {
-				usbdev_probe_info.rx_pipe2 =
+				devinfo->rx_pipe2 =
 					usb_rcvbulkpipe(usb, endpoint_num);
 			}
 		} else {
-			usbdev_probe_info.tx_pipe =
-					usb_sndbulkpipe(usb, endpoint_num);
+			devinfo->tx_pipe = usb_sndbulkpipe(usb, endpoint_num);
 		}
 	}
 
 	/* Allocate interrupt URB and data buffer */
 	/* RNDIS says 8-byte intr, our old drivers used 4-byte */
 	if (IFEPDESC(usb, CONTROL_IF, 0).wMaxPacketSize == cpu_to_le16(16))
-		usbdev_probe_info.intr_size = 8;
+		devinfo->intr_size = 8;
 	else
-		usbdev_probe_info.intr_size = 4;
+		devinfo->intr_size = 4;
 
-	usbdev_probe_info.interval = IFEPDESC(usb, CONTROL_IF, 0).bInterval;
+	devinfo->interval = IFEPDESC(usb, CONTROL_IF, 0).bInterval;
 
-	usbdev_probe_info.device_speed = usb->speed;
 	if (usb->speed == USB_SPEED_HIGH)
 		brcmf_dbg(INFO, "Broadcom high speed USB wireless device detected\n");
 	else
 		brcmf_dbg(INFO, "Broadcom full speed USB wireless device detected\n");
 
-	ret = brcmf_usb_probe_cb(&usb->dev, "", USB_BUS, 0);
+	ret = brcmf_usb_probe_cb(devinfo, "", USB_BUS, 0);
 	if (ret)
 		goto fail;
 
@@ -1563,6 +1520,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 fail:
 	brcmf_dbg(ERROR, "failed with errno %d\n", ret);
+	kfree(devinfo);
 	usb_set_intfdata(intf, NULL);
 	return ret;
 
@@ -1571,11 +1529,12 @@ fail:
 static void
 brcmf_usb_disconnect(struct usb_interface *intf)
 {
-	struct usb_device *usb = interface_to_usbdev(intf);
+	struct brcmf_usbdev_info *devinfo;
 
 	brcmf_dbg(TRACE, "enter\n");
-	brcmf_usb_disconnect_cb(brcmf_usb_get_buspub(&usb->dev));
-	usb_set_intfdata(intf, NULL);
+	devinfo = (struct brcmf_usbdev_info *)usb_get_intfdata(intf);
+	brcmf_usb_disconnect_cb(devinfo);
+	kfree(devinfo);
 }
 
 /*
-- 
1.7.9.5


