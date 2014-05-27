Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59323 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaE0K4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:37 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 15/16] brcmfmac: Remove interrupt endpoint usage from USB driver.
Date: Tue, 27 May 2014 12:56:27 +0200
Message-ID: <1401188188-16492-16-git-send-email-arend@broadcom.com> (sfid-20140527_125721_381293_D0BBCBA8)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The USB bus driver always configured an USB intr EP urb. The
driver did not use the result at all and with newer firmware it is
causing continues errors on this EP.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   78 +------------------------
 1 file changed, 1 insertion(+), 77 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 21335e2..fa440ba 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -64,11 +64,6 @@ struct brcmf_usb_image {
 };
 static struct list_head fw_image_list;
 
-struct intr_transfer_buf {
-	u32 notification;
-	u32 reserved;
-};
-
 struct brcmf_usbdev_info {
 	struct brcmf_usbdev bus_pub; /* MUST BE FIRST */
 	spinlock_t qlock;
@@ -76,7 +71,7 @@ struct brcmf_usbdev_info {
 	struct list_head rx_postq;
 	struct list_head tx_freeq;
 	struct list_head tx_postq;
-	uint rx_pipe, tx_pipe, intr_pipe, rx_pipe2;
+	uint rx_pipe, tx_pipe, rx_pipe2;
 
 	int rx_low_watermark;
 	int tx_low_watermark;
@@ -105,10 +100,6 @@ struct brcmf_usbdev_info {
 	ulong ctl_op;
 
 	struct urb *bulk_urb; /* used for FW download */
-	struct urb *intr_urb; /* URB for interrupt endpoint */
-	int intr_size;          /* Size of interrupt message */
-	int interval;           /* Interrupt polling interval */
-	struct intr_transfer_buf intr; /* Data buffer for interrupt endpoint */
 };
 
 static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
@@ -532,39 +523,6 @@ brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
 	}
 }
 
-static void
-brcmf_usb_intr_complete(struct urb *urb)
-{
-	struct brcmf_usbdev_info *devinfo =
-			(struct brcmf_usbdev_info *)urb->context;
-	int err;
-
-	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
-
-	if (devinfo == NULL)
-		return;
-
-	if (unlikely(urb->status)) {
-		if (urb->status == -ENOENT ||
-		    urb->status == -ESHUTDOWN ||
-		    urb->status == -ENODEV) {
-			brcmf_usb_state_change(devinfo,
-					       BRCMFMAC_USB_STATE_DOWN);
-		}
-	}
-
-	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_DOWN) {
-		brcmf_err("intr cb when DBUS down, ignoring\n");
-		return;
-	}
-
-	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP) {
-		err = usb_submit_urb(devinfo->intr_urb, GFP_ATOMIC);
-		if (err)
-			brcmf_err("usb_submit_urb, err=%d\n", err);
-	}
-}
-
 static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 {
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
@@ -620,7 +578,6 @@ static int brcmf_usb_up(struct device *dev)
 {
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 	u16 ifnum;
-	int ret;
 
 	brcmf_dbg(USB, "Enter\n");
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP)
@@ -629,23 +586,6 @@ static int brcmf_usb_up(struct device *dev)
 	/* Success, indicate devinfo is fully up */
 	brcmf_usb_state_change(devinfo, BRCMFMAC_USB_STATE_UP);
 
-	if (devinfo->intr_urb) {
-		usb_fill_int_urb(devinfo->intr_urb, devinfo->usbdev,
-			devinfo->intr_pipe,
-			&devinfo->intr,
-			devinfo->intr_size,
-			(usb_complete_t)brcmf_usb_intr_complete,
-			devinfo,
-			devinfo->interval);
-
-		ret = usb_submit_urb(devinfo->intr_urb, GFP_ATOMIC);
-		if (ret) {
-			brcmf_err("USB_SUBMIT_URB failed with status %d\n",
-				  ret);
-			return -EINVAL;
-		}
-	}
-
 	if (devinfo->ctl_urb) {
 		devinfo->ctl_in_pipe = usb_rcvctrlpipe(devinfo->usbdev, 0);
 		devinfo->ctl_out_pipe = usb_sndctrlpipe(devinfo->usbdev, 0);
@@ -682,8 +622,6 @@ static void brcmf_usb_down(struct device *dev)
 		return;
 
 	brcmf_usb_state_change(devinfo, BRCMFMAC_USB_STATE_DOWN);
-	if (devinfo->intr_urb)
-		usb_kill_urb(devinfo->intr_urb);
 
 	if (devinfo->ctl_urb)
 		usb_kill_urb(devinfo->ctl_urb);
@@ -1037,7 +975,6 @@ static void brcmf_usb_detach(struct brcmf_usbdev_info *devinfo)
 	brcmf_usb_free_q(&devinfo->rx_freeq, false);
 	brcmf_usb_free_q(&devinfo->tx_freeq, false);
 
-	usb_free_urb(devinfo->intr_urb);
 	usb_free_urb(devinfo->ctl_urb);
 	usb_free_urb(devinfo->bulk_urb);
 
@@ -1202,11 +1139,6 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 		goto error;
 	devinfo->tx_freecount = ntxq;
 
-	devinfo->intr_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!devinfo->intr_urb) {
-		brcmf_err("usb_alloc_urb (intr) failed\n");
-		goto error;
-	}
 	devinfo->ctl_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!devinfo->ctl_urb) {
 		brcmf_err("usb_alloc_urb (ctl) failed\n");
@@ -1418,9 +1350,6 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto fail;
 	}
 
-	endpoint_num = endpoint->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
-	devinfo->intr_pipe = usb_rcvintpipe(usb, endpoint_num);
-
 	devinfo->rx_pipe = 0;
 	devinfo->rx_pipe2 = 0;
 	devinfo->tx_pipe = 0;
@@ -1452,11 +1381,6 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		}
 	}
 
-	/* Allocate interrupt URB and data buffer */
-	devinfo->intr_size =
-		le16_to_cpu(IFEPDESC(usb, CONTROL_IF, 0).wMaxPacketSize);
-	devinfo->interval = IFEPDESC(usb, CONTROL_IF, 0).bInterval;
-
 	if (usb->speed == USB_SPEED_SUPER)
 		brcmf_dbg(USB, "Broadcom super speed USB wireless device detected\n");
 	else if (usb->speed == USB_SPEED_HIGH)
-- 
1.7.9.5

