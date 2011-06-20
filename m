Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:42259 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1FTLmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 07:42:46 -0400
Subject: [PATCH 4/6] zd1211rw: handle lost read-reg interrupts
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 20 Jun 2011 14:42:44 +0300
Message-ID: <20110620114244.964.60171.stgit@localhost6.localdomain6> (sfid-20110620_134249_800641_158097FB)
In-Reply-To: <20110620114228.964.35459.stgit@localhost6.localdomain6>
References: <20110620114228.964.35459.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Device losses read-reg interrupts. By looking at usbmon it appears that
USB_INT_ID_RETRY_FAILED can override USB_INT_ID_REGS. This causes read
command to timeout, usually under heavy TX.

Fix by retrying read registers again if USB_INT_ID_RETRY_FAILED is received
while waiting for USB_INT_ID_REGS.

However USB_INT_ID_REGS is not always lost but is received after
USB_INT_ID_RETRY_FAILED and is usually received by the retried read
command. USB_INT_ID_REGS of the retry is then left unhandled and might
be received by next read command. Handle this by ignoring previous
USB_INT_ID_REGS that doesn't match current read command request.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |  125 +++++++++++++++++++++++++++-----
 drivers/net/wireless/zd1211rw/zd_usb.h |    5 +
 2 files changed, 109 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 621c2cc..cf0d69d 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -111,6 +111,9 @@ MODULE_DEVICE_TABLE(usb, usb_ids);
 #define FW_ZD1211_PREFIX	"zd1211/zd1211_"
 #define FW_ZD1211B_PREFIX	"zd1211/zd1211b_"
 
+static bool check_read_regs(struct zd_usb *usb, struct usb_req_read_regs *req,
+			    unsigned int count);
+
 /* USB device initialization */
 static void int_urb_complete(struct urb *urb);
 
@@ -365,6 +368,20 @@ exit:
 
 #define urb_dev(urb) (&(urb)->dev->dev)
 
+static inline void handle_regs_int_override(struct urb *urb)
+{
+	struct zd_usb *usb = urb->context;
+	struct zd_usb_interrupt *intr = &usb->intr;
+
+	spin_lock(&intr->lock);
+	if (atomic_read(&intr->read_regs_enabled)) {
+		atomic_set(&intr->read_regs_enabled, 0);
+		intr->read_regs_int_overridden = 1;
+		complete(&intr->read_regs.completion);
+	}
+	spin_unlock(&intr->lock);
+}
+
 static inline void handle_regs_int(struct urb *urb)
 {
 	struct zd_usb *usb = urb->context;
@@ -383,25 +400,45 @@ static inline void handle_regs_int(struct urb *urb)
 				USB_MAX_EP_INT_BUFFER);
 		spin_unlock(&mac->lock);
 		schedule_work(&mac->process_intr);
-	} else if (intr->read_regs_enabled) {
-		intr->read_regs.length = len = urb->actual_length;
-
+	} else if (atomic_read(&intr->read_regs_enabled)) {
+		len = urb->actual_length;
+		intr->read_regs.length = urb->actual_length;
 		if (len > sizeof(intr->read_regs.buffer))
 			len = sizeof(intr->read_regs.buffer);
+
 		memcpy(intr->read_regs.buffer, urb->transfer_buffer, len);
-		intr->read_regs_enabled = 0;
+
+		/* Sometimes USB_INT_ID_REGS is not overridden, but comes after
+		 * USB_INT_ID_RETRY_FAILED. Read-reg retry then gets this
+		 * delayed USB_INT_ID_REGS, but leaves USB_INT_ID_REGS of
+		 * retry unhandled. Next read-reg command then might catch
+		 * this wrong USB_INT_ID_REGS. Fix by ignoring wrong reads.
+		 */
+		if (!check_read_regs(usb, intr->read_regs.req,
+						intr->read_regs.req_count))
+			goto out;
+
+		atomic_set(&intr->read_regs_enabled, 0);
+		intr->read_regs_int_overridden = 0;
 		complete(&intr->read_regs.completion);
+
 		goto out;
 	}
 
 out:
 	spin_unlock(&intr->lock);
+
+	/* CR_INTERRUPT might override read_reg too. */
+	if (int_num == CR_INTERRUPT && atomic_read(&intr->read_regs_enabled))
+		handle_regs_int_override(urb);
 }
 
 static void int_urb_complete(struct urb *urb)
 {
 	int r;
 	struct usb_int_header *hdr;
+	struct zd_usb *usb;
+	struct zd_usb_interrupt *intr;
 
 	switch (urb->status) {
 	case 0:
@@ -430,6 +467,14 @@ static void int_urb_complete(struct urb *urb)
 		goto resubmit;
 	}
 
+	/* USB_INT_ID_RETRY_FAILED triggered by tx-urb submit can override
+	 * pending USB_INT_ID_REGS causing read command timeout.
+	 */
+	usb = urb->context;
+	intr = &usb->intr;
+	if (hdr->id != USB_INT_ID_REGS && atomic_read(&intr->read_regs_enabled))
+		handle_regs_int_override(urb);
+
 	switch (hdr->id) {
 	case USB_INT_ID_REGS:
 		handle_regs_int(urb);
@@ -1129,6 +1174,7 @@ static inline void init_usb_interrupt(struct zd_usb *usb)
 	spin_lock_init(&intr->lock);
 	intr->interval = int_urb_interval(zd_usb_to_usbdev(usb));
 	init_completion(&intr->read_regs.completion);
+	atomic_set(&intr->read_regs_enabled, 0);
 	intr->read_regs.cr_int_addr = cpu_to_le16((u16)CR_INTERRUPT);
 }
 
@@ -1563,12 +1609,16 @@ static int usb_int_regs_length(unsigned int count)
 	return sizeof(struct usb_int_regs) + count * sizeof(struct reg_data);
 }
 
-static void prepare_read_regs_int(struct zd_usb *usb)
+static void prepare_read_regs_int(struct zd_usb *usb,
+				  struct usb_req_read_regs *req,
+				  unsigned int count)
 {
 	struct zd_usb_interrupt *intr = &usb->intr;
 
 	spin_lock_irq(&intr->lock);
-	intr->read_regs_enabled = 1;
+	atomic_set(&intr->read_regs_enabled, 1);
+	intr->read_regs.req = req;
+	intr->read_regs.req_count = count;
 	INIT_COMPLETION(intr->read_regs.completion);
 	spin_unlock_irq(&intr->lock);
 }
@@ -1578,22 +1628,18 @@ static void disable_read_regs_int(struct zd_usb *usb)
 	struct zd_usb_interrupt *intr = &usb->intr;
 
 	spin_lock_irq(&intr->lock);
-	intr->read_regs_enabled = 0;
+	atomic_set(&intr->read_regs_enabled, 0);
 	spin_unlock_irq(&intr->lock);
 }
 
-static int get_results(struct zd_usb *usb, u16 *values,
-	               struct usb_req_read_regs *req, unsigned int count)
+static bool check_read_regs(struct zd_usb *usb, struct usb_req_read_regs *req,
+			    unsigned int count)
 {
-	int r;
 	int i;
 	struct zd_usb_interrupt *intr = &usb->intr;
 	struct read_regs_int *rr = &intr->read_regs;
 	struct usb_int_regs *regs = (struct usb_int_regs *)rr->buffer;
 
-	spin_lock_irq(&intr->lock);
-
-	r = -EIO;
 	/* The created block size seems to be larger than expected.
 	 * However results appear to be correct.
 	 */
@@ -1601,13 +1647,14 @@ static int get_results(struct zd_usb *usb, u16 *values,
 		dev_dbg_f(zd_usb_dev(usb),
 			 "error: actual length %d less than expected %d\n",
 			 rr->length, usb_int_regs_length(count));
-		goto error_unlock;
+		return false;
 	}
+
 	if (rr->length > sizeof(rr->buffer)) {
 		dev_dbg_f(zd_usb_dev(usb),
 			 "error: actual length %d exceeds buffer size %zu\n",
 			 rr->length, sizeof(rr->buffer));
-		goto error_unlock;
+		return false;
 	}
 
 	for (i = 0; i < count; i++) {
@@ -1617,8 +1664,39 @@ static int get_results(struct zd_usb *usb, u16 *values,
 				 "rd[%d] addr %#06hx expected %#06hx\n", i,
 				 le16_to_cpu(rd->addr),
 				 le16_to_cpu(req->addr[i]));
-			goto error_unlock;
+			return false;
 		}
+	}
+
+	return true;
+}
+
+static int get_results(struct zd_usb *usb, u16 *values,
+		       struct usb_req_read_regs *req, unsigned int count,
+		       bool *retry)
+{
+	int r;
+	int i;
+	struct zd_usb_interrupt *intr = &usb->intr;
+	struct read_regs_int *rr = &intr->read_regs;
+	struct usb_int_regs *regs = (struct usb_int_regs *)rr->buffer;
+
+	spin_lock_irq(&intr->lock);
+
+	r = -EIO;
+
+	/* Read failed because firmware bug? */
+	*retry = !!intr->read_regs_int_overridden;
+	if (*retry)
+		goto error_unlock;
+
+	if (!check_read_regs(usb, req, count)) {
+		dev_dbg_f(zd_usb_dev(usb), "error: invalid read regs\n");
+		goto error_unlock;
+	}
+
+	for (i = 0; i < count; i++) {
+		struct reg_data *rd = &regs->regs[i];
 		values[i] = le16_to_cpu(rd->value);
 	}
 
@@ -1631,11 +1709,11 @@ error_unlock:
 int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	             const zd_addr_t *addresses, unsigned int count)
 {
-	int r;
-	int i, req_len, actual_req_len;
+	int r, i, req_len, actual_req_len, try_count = 0;
 	struct usb_device *udev;
 	struct usb_req_read_regs *req = NULL;
 	unsigned long timeout;
+	bool retry = false;
 
 	if (count < 1) {
 		dev_dbg_f(zd_usb_dev(usb), "error: count is zero\n");
@@ -1671,8 +1749,10 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	for (i = 0; i < count; i++)
 		req->addr[i] = cpu_to_le16((u16)addresses[i]);
 
+retry_read:
+	try_count++;
 	udev = zd_usb_to_usbdev(usb);
-	prepare_read_regs_int(usb);
+	prepare_read_regs_int(usb, req, count);
 	r = zd_ep_regs_out_msg(udev, req, req_len, &actual_req_len, 50 /*ms*/);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
@@ -1696,7 +1776,12 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 		goto error;
 	}
 
-	r = get_results(usb, values, req, count);
+	r = get_results(usb, values, req, count, &retry);
+	if (retry && try_count < 20) {
+		dev_dbg_f(zd_usb_dev(usb), "read retry, tries so far: %d\n",
+				try_count);
+		goto retry_read;
+	}
 error:
 	return r;
 }
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index bf94284..99193b4 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -144,6 +144,8 @@ struct usb_int_retry_fail {
 
 struct read_regs_int {
 	struct completion completion;
+	struct usb_req_read_regs *req;
+	unsigned int req_count;
 	/* Stores the USB int structure and contains the USB address of the
 	 * first requested register before request.
 	 */
@@ -169,7 +171,8 @@ struct zd_usb_interrupt {
 	void *buffer;
 	dma_addr_t buffer_dma;
 	int interval;
-	u8 read_regs_enabled:1;
+	atomic_t read_regs_enabled;
+	u8 read_regs_int_overridden:1;
 };
 
 static inline struct usb_int_regs *get_read_regs(struct zd_usb_interrupt *intr)

