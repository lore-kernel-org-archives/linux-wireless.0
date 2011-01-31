Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:53824 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345Ab1AaSt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:49:29 -0500
Subject: [PATCH 15/22] zd1211rw: change interrupt URB buffer to DMA buffer
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:49:24 +0200
Message-ID: <20110131184924.10044.45635.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As might lower beacon update CPU usage.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   36 ++++++++++++++++++++------------
 drivers/net/wireless/zd1211rw/zd_usb.h |    2 ++
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 6b604fc..b866f7a 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -411,7 +411,7 @@ static void int_urb_complete(struct urb *urb)
 	case -ENOENT:
 	case -ECONNRESET:
 	case -EPIPE:
-		goto kfree;
+		return;
 	default:
 		goto resubmit;
 	}
@@ -443,12 +443,11 @@ static void int_urb_complete(struct urb *urb)
 resubmit:
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r) {
-		dev_dbg_f(urb_dev(urb), "resubmit urb %p\n", urb);
-		goto kfree;
+		dev_dbg_f(urb_dev(urb), "error: resubmit urb %p err code %d\n",
+			  urb, r);
+		/* TODO: add worker to reset intr->urb */
 	}
 	return;
-kfree:
-	kfree(urb->transfer_buffer);
 }
 
 static inline int int_urb_interval(struct usb_device *udev)
@@ -479,9 +478,8 @@ static inline int usb_int_enabled(struct zd_usb *usb)
 int zd_usb_enable_int(struct zd_usb *usb)
 {
 	int r;
-	struct usb_device *udev;
+	struct usb_device *udev = zd_usb_to_usbdev(usb);
 	struct zd_usb_interrupt *intr = &usb->intr;
-	void *transfer_buffer = NULL;
 	struct urb *urb;
 
 	dev_dbg_f(zd_usb_dev(usb), "\n");
@@ -502,20 +500,21 @@ int zd_usb_enable_int(struct zd_usb *usb)
 	intr->urb = urb;
 	spin_unlock_irq(&intr->lock);
 
-	/* TODO: make it a DMA buffer */
 	r = -ENOMEM;
-	transfer_buffer = kmalloc(USB_MAX_EP_INT_BUFFER, GFP_KERNEL);
-	if (!transfer_buffer) {
+	intr->buffer = usb_alloc_coherent(udev, USB_MAX_EP_INT_BUFFER,
+					  GFP_KERNEL, &intr->buffer_dma);
+	if (!intr->buffer) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"couldn't allocate transfer_buffer\n");
 		goto error_set_urb_null;
 	}
 
-	udev = zd_usb_to_usbdev(usb);
 	usb_fill_int_urb(urb, udev, usb_rcvintpipe(udev, EP_INT_IN),
-			 transfer_buffer, USB_MAX_EP_INT_BUFFER,
+			 intr->buffer, USB_MAX_EP_INT_BUFFER,
 			 int_urb_complete, usb,
 			 intr->interval);
+	urb->transfer_dma = intr->buffer_dma;
+	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
 	dev_dbg_f(zd_usb_dev(usb), "submit urb %p\n", intr->urb);
 	r = usb_submit_urb(urb, GFP_KERNEL);
@@ -527,7 +526,8 @@ int zd_usb_enable_int(struct zd_usb *usb)
 
 	return 0;
 error:
-	kfree(transfer_buffer);
+	usb_free_coherent(udev, USB_MAX_EP_INT_BUFFER,
+			  intr->buffer, intr->buffer_dma);
 error_set_urb_null:
 	spin_lock_irq(&intr->lock);
 	intr->urb = NULL;
@@ -541,8 +541,11 @@ out:
 void zd_usb_disable_int(struct zd_usb *usb)
 {
 	unsigned long flags;
+	struct usb_device *udev = zd_usb_to_usbdev(usb);
 	struct zd_usb_interrupt *intr = &usb->intr;
 	struct urb *urb;
+	void *buffer;
+	dma_addr_t buffer_dma;
 
 	spin_lock_irqsave(&intr->lock, flags);
 	urb = intr->urb;
@@ -551,11 +554,18 @@ void zd_usb_disable_int(struct zd_usb *usb)
 		return;
 	}
 	intr->urb = NULL;
+	buffer = intr->buffer;
+	buffer_dma = intr->buffer_dma;
+	intr->buffer = NULL;
 	spin_unlock_irqrestore(&intr->lock, flags);
 
 	usb_kill_urb(urb);
 	dev_dbg_f(zd_usb_dev(usb), "urb %p killed\n", urb);
 	usb_free_urb(urb);
+
+	if (buffer)
+		usb_free_coherent(udev, USB_MAX_EP_INT_BUFFER,
+				  buffer, buffer_dma);
 }
 
 static void handle_rx_packet(struct zd_usb *usb, const u8 *buffer,
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 2ed48ae..24db0dd 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -162,6 +162,8 @@ struct zd_usb_interrupt {
 	struct read_regs_int read_regs;
 	spinlock_t lock;
 	struct urb *urb;
+	void *buffer;
+	dma_addr_t buffer_dma;
 	int interval;
 	u8 read_regs_enabled:1;
 };

