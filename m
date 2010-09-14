Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42735 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab0INJEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 05:04:48 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 02:04:42 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Fix CPU usage issue during scan period
Date: Tue, 14 Sep 2010 14:35:55 +0530
Message-ID: <1284455155-20441-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CPU consumption during the scan period is high, since
the register write go over Interrupt endpoint. On downloading
the firmware to the target, the USB descriptors are
'patched' to change the type of the endpoints from Interrupt
to Bulk.

With this fix, the CPU usage during a scan run comes down to
acceptable levels.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 495f189..27f88a0 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -92,10 +92,10 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 	cmd->skb = skb;
 	cmd->hif_dev = hif_dev;
 
-	usb_fill_int_urb(urb, hif_dev->udev,
-			 usb_sndintpipe(hif_dev->udev, USB_REG_OUT_PIPE),
+	usb_fill_bulk_urb(urb, hif_dev->udev,
+			 usb_sndbulkpipe(hif_dev->udev, USB_REG_OUT_PIPE),
 			 skb->data, skb->len,
-			 hif_usb_regout_cb, cmd, 1);
+			 hif_usb_regout_cb, cmd);
 
 	usb_anchor_urb(urb, &hif_dev->regout_submitted);
 	ret = usb_submit_urb(urb, GFP_KERNEL);
@@ -822,7 +822,9 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 
 static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 {
-	int ret;
+	int ret, idx;
+	struct usb_host_interface *alt = &hif_dev->interface->altsetting[0];
+	struct usb_endpoint_descriptor *endp;
 
 	/* Request firmware */
 	ret = request_firmware(&hif_dev->firmware, hif_dev->fw_name,
@@ -850,6 +852,22 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 		goto err_fw_download;
 	}
 
+	/* On downloading the firmware to the target, the USB descriptor of EP4
+	 * is 'patched' to change the type of the endpoint to Bulk. This will
+	 * bring down CPU usage during the scan period.
+	 */
+	for (idx = 0; idx < alt->desc.bNumEndpoints; idx++) {
+		endp = &alt->endpoint[idx].desc;
+		if (((endp->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK)
+				== 0x04) &&
+		    ((endp->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+				== USB_ENDPOINT_XFER_INT)) {
+			endp->bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
+			endp->bmAttributes |= USB_ENDPOINT_XFER_BULK;
+			endp->bInterval = 0;
+		}
+	}
+
 	return 0;
 
 err_fw_download:
-- 
1.7.2.3

