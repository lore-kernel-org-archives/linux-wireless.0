Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33251 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab0KHHUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 02:20:08 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 07 Nov 2010 23:19:55 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <tom.leiming@gmail.com>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Fix probe failure if CONFIG_USB_DEBUG enabled
Date: Mon, 8 Nov 2010 12:49:12 +0530
Message-ID: <1289200752-18928-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the endpoint descriptors (EP3 & EP4) were changed from Interrupt
to Bulk type by firmware, the urb submission done on Bulk pipes.
And the recent commit "check the endpoint type against the pipe type"
added aditional error checking against pipe types under CONFIG_USB_DEBUG.

So bmAttribute has to be updated for both EP3 & EP4 before submitting
urbs on that pipe. This patch resolves the following failure.

[ 2215.710936] usb 1-1: usb_probe_device
[ 2215.710945] usb 1-1: configuration #1 chosen from 1 choice
[ 2215.711152] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[ 2215.711252] ath9k_hif_usb 1-1:1.0: usb_probe_interface
[ 2215.711255] ath9k_hif_usb 1-1:1.0: usb_probe_interface - got id
[ 2215.712780] usb 1-1: BOGUS urb xfer, pipe 3 != type 1
[ 2215.713782] usb 1-1: ath9k_htc: Unable to allocate URBs
[ 2215.713801] ath9k_hif_usb: probe of 1-1:1.0 failed with error -22

Reported-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 6576f68..5b40db7 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -540,11 +540,11 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 			return;
 		}
 
-		usb_fill_int_urb(urb, hif_dev->udev,
+		usb_fill_bulk_urb(urb, hif_dev->udev,
 				 usb_rcvbulkpipe(hif_dev->udev,
 						 USB_REG_IN_PIPE),
 				 nskb->data, MAX_REG_IN_BUF_SIZE,
-				 ath9k_hif_usb_reg_in_cb, nskb, 1);
+				 ath9k_hif_usb_reg_in_cb, nskb);
 
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
 		if (ret) {
@@ -720,11 +720,11 @@ static int ath9k_hif_usb_alloc_reg_in_urb(struct hif_device_usb *hif_dev)
 	if (!skb)
 		goto err;
 
-	usb_fill_int_urb(hif_dev->reg_in_urb, hif_dev->udev,
+	usb_fill_bulk_urb(hif_dev->reg_in_urb, hif_dev->udev,
 			 usb_rcvbulkpipe(hif_dev->udev,
 					 USB_REG_IN_PIPE),
 			 skb->data, MAX_REG_IN_BUF_SIZE,
-			 ath9k_hif_usb_reg_in_cb, skb, 1);
+			 ath9k_hif_usb_reg_in_cb, skb);
 
 	if (usb_submit_urb(hif_dev->reg_in_urb, GFP_KERNEL) != 0)
 		goto err;
@@ -843,14 +843,6 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 		goto err_fw_req;
 	}
 
-	/* Alloc URBs */
-	ret = ath9k_hif_usb_alloc_urbs(hif_dev);
-	if (ret) {
-		dev_err(&hif_dev->udev->dev,
-			"ath9k_htc: Unable to allocate URBs\n");
-		goto err_urb;
-	}
-
 	/* Download firmware */
 	ret = ath9k_hif_usb_download_fw(hif_dev);
 	if (ret) {
@@ -866,16 +858,22 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 	 */
 	for (idx = 0; idx < alt->desc.bNumEndpoints; idx++) {
 		endp = &alt->endpoint[idx].desc;
-		if (((endp->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK)
-				== 0x04) &&
-		    ((endp->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-				== USB_ENDPOINT_XFER_INT)) {
+		if ((endp->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+				== USB_ENDPOINT_XFER_INT) {
 			endp->bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
 			endp->bmAttributes |= USB_ENDPOINT_XFER_BULK;
 			endp->bInterval = 0;
 		}
 	}
 
+	/* Alloc URBs */
+	ret = ath9k_hif_usb_alloc_urbs(hif_dev);
+	if (ret) {
+		dev_err(&hif_dev->udev->dev,
+			"ath9k_htc: Unable to allocate URBs\n");
+		goto err_urb;
+	}
+
 	return 0;
 
 err_fw_download:
-- 
1.7.3.2

