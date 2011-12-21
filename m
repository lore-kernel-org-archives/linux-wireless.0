Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:58077 "HELO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752712Ab1LUCUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 21:20:09 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <padovan@profusion.mobi>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] Bluetooth: btusb: fix bInterval for high/super speed isochronous endpoints
Date: Tue, 20 Dec 2011 18:19:00 -0800
Message-Id: <1324433940-16838-1-git-send-email-bzhao@marvell.com> (sfid-20111221_032037_893938_E5D7D096)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For high-speed/super-speed isochronous endpoints, the bInterval
value is used as exponent, 2^(bInterval-1). Luckily we have
usb_fill_int_urb() function that handles it correctly. So we just
call this function to fill in the RX URB.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/bluetooth/btusb.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index ea5ad1c..a67c6db 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -508,15 +508,10 @@ static int btusb_submit_isoc_urb(struct hci_dev *hdev, gfp_t mem_flags)
 
 	pipe = usb_rcvisocpipe(data->udev, data->isoc_rx_ep->bEndpointAddress);
 
-	urb->dev      = data->udev;
-	urb->pipe     = pipe;
-	urb->context  = hdev;
-	urb->complete = btusb_isoc_complete;
-	urb->interval = data->isoc_rx_ep->bInterval;
+	usb_fill_int_urb(urb, data->udev, pipe, buf, size, btusb_isoc_complete,
+				hdev, data->isoc_rx_ep->bInterval);
 
 	urb->transfer_flags  = URB_FREE_BUFFER | URB_ISO_ASAP;
-	urb->transfer_buffer = buf;
-	urb->transfer_buffer_length = size;
 
 	__fill_isoc_descriptor(urb, size,
 			le16_to_cpu(data->isoc_rx_ep->wMaxPacketSize));
-- 
1.7.4.1

