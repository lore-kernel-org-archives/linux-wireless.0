Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:34234 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab3BPXLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 18:11:22 -0500
Subject: [PATCH] rtlwifi: usb: allocate URB control message setup_packet and
 data buffer separately
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 17 Feb 2013 01:00:16 +0200
Message-ID: <20130216230016.15041.99979.stgit@localhost6.localdomain6> (sfid-20130217_001129_420149_8D41A84D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtlwifi allocates both setup_packet and data buffer of control message urb,
using shared kmalloc in _usbctrl_vendorreq_async_write. Structure used for
allocating is:
	struct {
		u8 data[254];
		struct usb_ctrlrequest dr;
	};

Because 'struct usb_ctrlrequest' is __packed, setup packet is unaligned and
DMA mapping of both 'data' and 'dr' confuses ARM/sunxi, leading to memory
corruptions and freezes.

Patch changes setup packet to be allocated separately.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rtlwifi/usb.c |   44 +++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 476eaef..d98fcdb 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -42,8 +42,12 @@
 
 static void usbctrl_async_callback(struct urb *urb)
 {
-	if (urb)
-		kfree(urb->context);
+	if (urb) {
+		/* free dr */
+		kfree(urb->setup_packet);
+		/* free databuf */
+		kfree(urb->transfer_buffer);
+	}
 }
 
 static int _usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
@@ -55,39 +59,47 @@ static int _usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
 	u8 reqtype;
 	struct usb_ctrlrequest *dr;
 	struct urb *urb;
-	struct rtl819x_async_write_data {
-		u8 data[REALTEK_USB_VENQT_MAX_BUF_SIZE];
-		struct usb_ctrlrequest dr;
-	} *buf;
+	const u16 databuf_maxlen = REALTEK_USB_VENQT_MAX_BUF_SIZE;
+	u8 *databuf;
+
+	if (WARN_ON(len > databuf_maxlen))
+		len = databuf_maxlen;
 
 	pipe = usb_sndctrlpipe(udev, 0); /* write_out */
 	reqtype =  REALTEK_USB_VENQT_WRITE;
 
-	buf = kmalloc(sizeof(*buf), GFP_ATOMIC);
-	if (!buf)
+	dr = kmalloc(sizeof(*dr), GFP_ATOMIC);
+	if (!dr)
 		return -ENOMEM;
 
+	databuf = kmalloc(databuf_maxlen, GFP_ATOMIC);
+	if (!databuf) {
+		kfree(dr);
+		return -ENOMEM;
+	}
+
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
-		kfree(buf);
+		kfree(databuf);
+		kfree(dr);
 		return -ENOMEM;
 	}
 
-	dr = &buf->dr;
-
 	dr->bRequestType = reqtype;
 	dr->bRequest = request;
 	dr->wValue = cpu_to_le16(value);
 	dr->wIndex = cpu_to_le16(index);
 	dr->wLength = cpu_to_le16(len);
 	/* data are already in little-endian order */
-	memcpy(buf, pdata, len);
+	memcpy(databuf, pdata, len);
 	usb_fill_control_urb(urb, udev, pipe,
-			     (unsigned char *)dr, buf, len,
-			     usbctrl_async_callback, buf);
+			     (unsigned char *)dr, databuf, len,
+			     usbctrl_async_callback, NULL);
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
-	if (rc < 0)
-		kfree(buf);
+	if (rc < 0) {
+		kfree(databuf);
+		kfree(dr);
+	}
 	usb_free_urb(urb);
 	return rc;
 }

