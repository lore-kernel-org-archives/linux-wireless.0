Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:51125 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571Ab1BLSni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 13:43:38 -0500
Subject: [PATCH 2/4] zd1211rw: use async urb for write command
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sat, 12 Feb 2011 20:43:32 +0200
Message-ID: <20110212184332.2062.96047.stgit@fate.lan>
In-Reply-To: <20110212184254.2062.33710.stgit@fate.lan>
References: <20110212184254.2062.33710.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Writing beacon to device happen through multiple write command calls.
zd_usb_iowrite16v uses synchronous urb call and with multiple write
commands in row causes high CPU usage.

This patch makes zd_usb_iowrite16v use asynchronous urb submit within
zd_usb.c. zd_usb_iowrite16v_async_start is used to initiate writing
multiple commands to device using zd_usb_iowrite16v_async. Each URB
is delayed and submitted to device by next zd_usb_iowrite16v_async
call or by call to zd_usb_iowrite16v_async_end. URBs submitted by
zd_usb_iowrite16v_async have URB_NO_INTERRUPT set and last URB
send by zd_usb_iowrite16v_async_end does not. This lower CPU
usage when doing writes that require multiple URBs.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |  162 +++++++++++++++++++++++++++-----
 drivers/net/wireless/zd1211rw/zd_usb.h |    5 +
 2 files changed, 142 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 7346512..c98f6e7 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1156,6 +1156,7 @@ void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *hw,
 	memset(usb, 0, sizeof(*usb));
 	usb->intf = usb_get_intf(intf);
 	usb_set_intfdata(usb->intf, hw);
+	init_usb_anchor(&usb->submitted_cmds);
 	init_usb_interrupt(usb);
 	init_usb_tx(usb);
 	init_usb_rx(usb);
@@ -1663,13 +1664,104 @@ error:
 	return r;
 }
 
-int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
-	              unsigned int count)
+static void iowrite16v_urb_complete(struct urb *urb)
+{
+	struct zd_usb *usb = urb->context;
+
+	if (urb->status && !usb->cmd_error)
+		usb->cmd_error = urb->status;
+}
+
+static int zd_submit_waiting_urb(struct zd_usb *usb, bool last)
+{
+	int r;
+	struct urb *urb = usb->urb_async_waiting;
+
+	if (!urb)
+		return 0;
+
+	usb->urb_async_waiting = NULL;
+
+	if (!last)
+		urb->transfer_flags |= URB_NO_INTERRUPT;
+
+	usb_anchor_urb(urb, &usb->submitted_cmds);
+	r = usb_submit_urb(urb, GFP_KERNEL);
+	if (r) {
+		usb_unanchor_urb(urb);
+		dev_dbg_f(zd_usb_dev(usb),
+			"error in usb_submit_urb(). Error number %d\n", r);
+		goto error;
+	}
+
+	/* fall-through with r == 0 */
+error:
+	usb_free_urb(urb);
+	return r;
+}
+
+static void zd_usb_iowrite16v_async_start(struct zd_usb *usb)
+{
+	ZD_ASSERT(usb_anchor_empty(&usb->submitted_cmds));
+	ZD_ASSERT(usb->urb_async_waiting == NULL);
+	ZD_ASSERT(!usb->in_async);
+
+	ZD_ASSERT(mutex_is_locked(&zd_usb_to_chip(usb)->mutex));
+
+	usb->in_async = 1;
+	usb->cmd_error = 0;
+	usb->urb_async_waiting = NULL;
+}
+
+static int zd_usb_iowrite16v_async_end(struct zd_usb *usb, unsigned int timeout)
+{
+	int r;
+
+	ZD_ASSERT(mutex_is_locked(&zd_usb_to_chip(usb)->mutex));
+	ZD_ASSERT(usb->in_async);
+
+	/* Submit last iowrite16v URB */
+	r = zd_submit_waiting_urb(usb, true);
+	if (r) {
+		dev_dbg_f(zd_usb_dev(usb),
+			"error in zd_submit_waiting_usb(). "
+			"Error number %d\n", r);
+
+		usb_kill_anchored_urbs(&usb->submitted_cmds);
+		goto error;
+	}
+
+	if (timeout)
+		timeout = usb_wait_anchor_empty_timeout(&usb->submitted_cmds,
+							timeout);
+	if (!timeout) {
+		usb_kill_anchored_urbs(&usb->submitted_cmds);
+		if (usb->cmd_error == -ENOENT) {
+			dev_dbg_f(zd_usb_dev(usb), "timed out");
+			r = -ETIMEDOUT;
+			goto error;
+		}
+	}
+
+	r = usb->cmd_error;
+error:
+	usb->in_async = 0;
+	return r;
+}
+
+static int zd_usb_iowrite16v_async(struct zd_usb *usb,
+				   const struct zd_ioreq16 *ioreqs,
+				   unsigned int count)
 {
 	int r;
 	struct usb_device *udev;
 	struct usb_req_write_regs *req = NULL;
-	int i, req_len, actual_req_len;
+	int i, req_len;
+	struct urb *urb;
+	struct usb_host_endpoint *ep;
+
+	ZD_ASSERT(mutex_is_locked(&zd_usb_to_chip(usb)->mutex));
+	ZD_ASSERT(usb->in_async);
 
 	if (count == 0)
 		return 0;
@@ -1685,17 +1777,23 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 		return -EWOULDBLOCK;
 	}
 
-	ZD_ASSERT(mutex_is_locked(&zd_usb_to_chip(usb)->mutex));
-	BUILD_BUG_ON(sizeof(struct usb_req_write_regs) +
-		     USB_MAX_IOWRITE16_COUNT * sizeof(struct reg_data) >
-		     sizeof(usb->req_buf));
-	BUG_ON(sizeof(struct usb_req_write_regs) +
-	       count * sizeof(struct reg_data) >
-	       sizeof(usb->req_buf));
+	udev = zd_usb_to_usbdev(usb);
+
+	ep = usb_pipe_endpoint(udev, usb_sndintpipe(udev, EP_REGS_OUT));
+	if (!ep)
+		return -ENOENT;
+
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!urb)
+		return -ENOMEM;
 
 	req_len = sizeof(struct usb_req_write_regs) +
 		  count * sizeof(struct reg_data);
-	req = (void *)usb->req_buf;
+	req = kmalloc(req_len, GFP_KERNEL);
+	if (!req) {
+		r = -ENOMEM;
+		goto error;
+	}
 
 	req->id = cpu_to_le16(USB_REQ_WRITE_REGS);
 	for (i = 0; i < count; i++) {
@@ -1704,28 +1802,44 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 		rw->value = cpu_to_le16(ioreqs[i].value);
 	}
 
-	udev = zd_usb_to_usbdev(usb);
-	r = usb_interrupt_msg(udev, usb_sndintpipe(udev, EP_REGS_OUT),
-			      req, req_len, &actual_req_len, 50 /* ms */);
+	usb_fill_int_urb(urb, udev, usb_sndintpipe(udev, EP_REGS_OUT),
+			 req, req_len, iowrite16v_urb_complete, usb,
+			 ep->desc.bInterval);
+	urb->transfer_flags |= URB_FREE_BUFFER | URB_SHORT_NOT_OK;
+
+	/* Submit previous URB */
+	r = zd_submit_waiting_urb(usb, false);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_interrupt_msg(). Error number %d\n", r);
-		goto error;
-	}
-	if (req_len != actual_req_len) {
-		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_interrupt_msg()"
-			" req_len %d != actual_req_len %d\n",
-			req_len, actual_req_len);
-		r = -EIO;
+			"error in zd_submit_waiting_usb(). "
+			"Error number %d\n", r);
 		goto error;
 	}
 
-	/* FALL-THROUGH with r == 0 */
+	/* Delay submit so that URB_NO_INTERRUPT flag can be set for all URBs
+	 * of currect batch except for very last.
+	 */
+	usb->urb_async_waiting = urb;
+	return 0;
 error:
+	usb_free_urb(urb);
 	return r;
 }
 
+int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
+			unsigned int count)
+{
+	int r;
+
+	zd_usb_iowrite16v_async_start(usb);
+	r = zd_usb_iowrite16v_async(usb, ioreqs, count);
+	if (r) {
+		zd_usb_iowrite16v_async_end(usb, 0);
+		return r;
+	}
+	return zd_usb_iowrite16v_async_end(usb, 50 /* ms */);
+}
+
 int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 {
 	int r;
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 2d688f4..9291426 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -217,8 +217,11 @@ struct zd_usb {
 	struct zd_usb_rx rx;
 	struct zd_usb_tx tx;
 	struct usb_interface *intf;
+	struct usb_anchor submitted_cmds;
+	struct urb *urb_async_waiting;
+	int cmd_error;
 	u8 req_buf[64]; /* zd_usb_iowrite16v needs 62 bytes */
-	u8 is_zd1211b:1, initialized:1, was_running:1;
+	u8 is_zd1211b:1, initialized:1, was_running:1, in_async:1;
 };
 
 #define zd_usb_dev(usb) (&usb->intf->dev)

