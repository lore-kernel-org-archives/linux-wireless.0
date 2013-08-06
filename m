Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:48878 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3HFLQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 07:16:09 -0400
Subject: [PATCH] pn533: fix stack being used as URB transfer_buffer
To: linux-nfc@lists.01.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Date: Tue, 06 Aug 2013 14:09:24 +0300
Message-ID: <20130806110924.26024.75370.stgit@localhost6.localdomain6> (sfid-20130806_131618_302817_AF56E8A7)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch fixes incorrect stack usage in pn533_send_ack(). Function currently sets
stack as transfer_buffer (stack may not be dma-able, must not be used for URB
buffers) and returns (stack buffer is still in use after function call).

Patch is only compile tested.

Cc: stable@vger.kernel.org
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 drivers/nfc/pn533.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index daf92ac..2da0775 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -382,6 +382,8 @@ struct pn533 {
 	u8 tgt_active_prot;
 	u8 tgt_mode;
 
+	void *ack_buf;
+
 	struct pn533_frame_ops *ops;
 };
 
@@ -761,7 +763,13 @@ static int pn533_send_ack(struct pn533 *dev, gfp_t flags)
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
-	dev->out_urb->transfer_buffer = ack;
+	if (!dev->ack_buf) {
+		dev->ack_buf = kmemdup(ack, sizeof(ack), flags);
+		if (!dev->ack_buf)
+			return -ENOMEM;
+	}
+
+	dev->out_urb->transfer_buffer = dev->ack_buf;
 	dev->out_urb->transfer_buffer_length = sizeof(ack);
 	rc = usb_submit_urb(dev->out_urb, flags);
 
@@ -2824,6 +2832,7 @@ error:
 	usb_free_urb(dev->in_urb);
 	usb_free_urb(dev->out_urb);
 	usb_put_dev(dev->udev);
+	kfree(dev->ack_buf);
 	kfree(dev);
 	return rc;
 }
@@ -2855,6 +2864,7 @@ static void pn533_disconnect(struct usb_interface *interface)
 
 	usb_free_urb(dev->in_urb);
 	usb_free_urb(dev->out_urb);
+	kfree(dev->ack_buf);
 	kfree(dev);
 
 	nfc_dev_info(&interface->dev, "NXP PN533 NFC device disconnected");

