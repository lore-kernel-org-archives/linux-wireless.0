Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58951 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387Ab3HMTKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 15:10:37 -0400
Received: from zwerg.Speedport_W_723V_1_28_000 ([79.218.111.223]) by
 mail.gmx.com (mrgmx102) with ESMTPSA (Nemesis) id 0M0smx-1VygJo3m0d-00vBow
 for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 21:10:36 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k_htc: do not use bulk on EP3 and EP4
Date: Tue, 13 Aug 2013 21:10:20 +0200
Message-Id: <1376421020-11858-2-git-send-email-linux@rempel-privat.de> (sfid-20130813_211040_397908_30555593)
In-Reply-To: <1376421020-11858-1-git-send-email-linux@rempel-privat.de>
References: <1376421020-11858-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If usb auto suspend is enabled or system run in to suspend/resume
cycle, ath9k-htc adapter will stop to response. It is reproducible on xhci HCs.

Host part of problem:
XHCI do timing calculation based on Transfer Type and bInterval,
immediately after device was detected. Ath9k-htc try to overwrite
this parameters on module probe and some changes in FW,
since we do not initiate usb reset from the driver this changes
are not took to account. So, before any kind of suspend or reset,
host controller will operate with old parameters. Only after suspend/resume
and if interface id stay unchanged, new parameters will by applied. Host
will send bulk data with no intervals (?), which will cause
overflow on FIFO of EP4.

Firmware part of problem:
By default, ath9k-htc adapters configured with EP3 and EP4
as interrupt endpoints. Current firmware will try to overwrite
ConfigDescriptor to make EP3 and EP4 bulk. FIFO for this endpoints
stay not reconfigured, so under the hood it is still Int EP.

This patch is revert of 4a0e8ecca4ee commit which trying to
reduce CPU usage on some systems. Since it will produce more bug
as fixes, we will need to find other way to fix it.

here is comment from kernel source which has some more explanation:
* Some buggy high speed devices have bulk endpoints using
* maxpacket sizes other than 512.  High speed HCDs may not
* be able to handle that particular bug, so let's warn...

in our case EP3 and EP4 have maxpacket sizes = 64!!!

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 38 +++++++++-----------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 5205a36..6d5d716 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -115,10 +115,10 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 	cmd->skb = skb;
 	cmd->hif_dev = hif_dev;
 
-	usb_fill_bulk_urb(urb, hif_dev->udev,
-			 usb_sndbulkpipe(hif_dev->udev, USB_REG_OUT_PIPE),
+	usb_fill_int_urb(urb, hif_dev->udev,
+			 usb_sndintpipe(hif_dev->udev, USB_REG_OUT_PIPE),
 			 skb->data, skb->len,
-			 hif_usb_regout_cb, cmd);
+			 hif_usb_regout_cb, cmd, 1);
 
 	usb_anchor_urb(urb, &hif_dev->regout_submitted);
 	ret = usb_submit_urb(urb, GFP_KERNEL);
@@ -723,11 +723,11 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 			return;
 		}
 
-		usb_fill_bulk_urb(urb, hif_dev->udev,
-				 usb_rcvbulkpipe(hif_dev->udev,
+		usb_fill_int_urb(urb, hif_dev->udev,
+				 usb_rcvintpipe(hif_dev->udev,
 						 USB_REG_IN_PIPE),
 				 nskb->data, MAX_REG_IN_BUF_SIZE,
-				 ath9k_hif_usb_reg_in_cb, nskb);
+				 ath9k_hif_usb_reg_in_cb, nskb, 1);
 	}
 
 resubmit:
@@ -909,11 +909,11 @@ static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 			goto err_skb;
 		}
 
-		usb_fill_bulk_urb(urb, hif_dev->udev,
-				  usb_rcvbulkpipe(hif_dev->udev,
+		usb_fill_int_urb(urb, hif_dev->udev,
+				  usb_rcvintpipe(hif_dev->udev,
 						  USB_REG_IN_PIPE),
 				  skb->data, MAX_REG_IN_BUF_SIZE,
-				  ath9k_hif_usb_reg_in_cb, skb);
+				  ath9k_hif_usb_reg_in_cb, skb, 1);
 
 		/* Anchor URB */
 		usb_anchor_urb(urb, &hif_dev->reg_in_submitted);
@@ -1031,9 +1031,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 
 static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 {
-	struct usb_host_interface *alt = &hif_dev->interface->altsetting[0];
-	struct usb_endpoint_descriptor *endp;
-	int ret, idx;
+	int ret;
 
 	ret = ath9k_hif_usb_download_fw(hif_dev);
 	if (ret) {
@@ -1043,20 +1041,6 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 		return ret;
 	}
 
-	/* On downloading the firmware to the target, the USB descriptor of EP4
-	 * is 'patched' to change the type of the endpoint to Bulk. This will
-	 * bring down CPU usage during the scan period.
-	 */
-	for (idx = 0; idx < alt->desc.bNumEndpoints; idx++) {
-		endp = &alt->endpoint[idx].desc;
-		if ((endp->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-				== USB_ENDPOINT_XFER_INT) {
-			endp->bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
-			endp->bmAttributes |= USB_ENDPOINT_XFER_BULK;
-			endp->bInterval = 0;
-		}
-	}
-
 	/* Alloc URBs */
 	ret = ath9k_hif_usb_alloc_urbs(hif_dev);
 	if (ret) {
@@ -1268,7 +1252,7 @@ static void ath9k_hif_usb_reboot(struct usb_device *udev)
 	if (!buf)
 		return;
 
-	ret = usb_bulk_msg(udev, usb_sndbulkpipe(udev, USB_REG_OUT_PIPE),
+	ret = usb_interrupt_msg(udev, usb_sndintpipe(udev, USB_REG_OUT_PIPE),
 			   buf, 4, NULL, HZ);
 	if (ret)
 		dev_err(&udev->dev, "ath9k_htc: USB reboot failed\n");
-- 
1.8.1.2

