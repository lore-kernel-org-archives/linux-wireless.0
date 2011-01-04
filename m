Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:43412 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab1ADXtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:49:41 -0500
Subject: [RFC PATCH 13/17] zd1211rw: use stack for small cmd-buffers
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:49:35 +0200
Message-ID: <20110104234935.25309.7558.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use stack for allocing small < 64 byte arrays.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |   43 +++++++---------------
 drivers/net/wireless/zd1211rw/zd_usb.c  |   60 ++++++++++++-------------------
 2 files changed, 38 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index fa90d06..8a286b8 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -108,24 +108,18 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 {
 	int r;
 	int i;
-	zd_addr_t *a16;
-	u16 *v16;
+	zd_addr_t a16[USB_MAX_IOREAD32_COUNT * 2];
+	u16 v16[USB_MAX_IOREAD32_COUNT * 2];
 	unsigned int count16;
 
+	/* Use stack for values and addresses. */
+
 	if (count > USB_MAX_IOREAD32_COUNT)
 		return -EINVAL;
 
-	/* Allocate a single memory block for values and addresses. */
-	count16 = 2*count;
-	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
-		                   GFP_KERNEL);
-	if (!a16) {
-		dev_dbg_f(zd_chip_dev(chip),
-			  "error ENOMEM in allocation of a16\n");
-		r = -ENOMEM;
-		goto out;
-	}
-	v16 = (u16 *)(a16 + count16);
+	count16 = 2 * count;
+	BUG_ON(count16 * sizeof(zd_addr_t) > sizeof(a16));
+	BUG_ON(count16 * sizeof(u16) > sizeof(v16));
 
 	for (i = 0; i < count; i++) {
 		int j = 2*i;
@@ -138,7 +132,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 	if (r) {
 		dev_dbg_f(zd_chip_dev(chip),
 			  "error: zd_ioread16v_locked. Error number %d\n", r);
-		goto out;
+		return r;
 	}
 
 	for (i = 0; i < count; i++) {
@@ -146,18 +140,18 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 		values[i] = (v16[j] << 16) | v16[j+1];
 	}
 
-out:
-	kfree((void *)a16);
-	return r;
+	return 0;
 }
 
 int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
 	           unsigned int count)
 {
 	int i, j, r;
-	struct zd_ioreq16 *ioreqs16;
+	struct zd_ioreq16 ioreqs16[USB_MAX_IOWRITE32_COUNT * 2];
 	unsigned int count16;
 
+	/* Use stack for values and addresses. */
+
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
 
 	if (count == 0)
@@ -165,15 +159,8 @@ int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
 	if (count > USB_MAX_IOWRITE32_COUNT)
 		return -EINVAL;
 
-	/* Allocate a single memory block for values and addresses. */
-	count16 = 2*count;
-	ioreqs16 = kmalloc(count16 * sizeof(struct zd_ioreq16), GFP_KERNEL);
-	if (!ioreqs16) {
-		r = -ENOMEM;
-		dev_dbg_f(zd_chip_dev(chip),
-			  "error %d in ioreqs16 allocation\n", r);
-		goto out;
-	}
+	count16 = 2 * count;
+	BUG_ON(count16 * sizeof(struct zd_ioreq16) > sizeof(ioreqs16));
 
 	for (i = 0; i < count; i++) {
 		j = 2*i;
@@ -191,8 +178,6 @@ int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
 			  "error %d in zd_usb_write16v\n", r);
 	}
 #endif /* DEBUG */
-out:
-	kfree(ioreqs16);
 	return r;
 }
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index ed5379b..13a089b 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1358,10 +1358,12 @@ error_unlock:
 int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	             const zd_addr_t *addresses, unsigned int count)
 {
+	unsigned char buf[sizeof(struct usb_req_read_regs) +
+			  USB_MAX_IOREAD16_COUNT * sizeof(__le16)];
 	int r;
 	int i, req_len, actual_req_len;
 	struct usb_device *udev;
-	struct usb_req_read_regs *req = NULL;
+	struct usb_req_read_regs *req = (void *)buf;
 	unsigned long timeout;
 
 	if (count < 1) {
@@ -1386,9 +1388,8 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	}
 
 	req_len = sizeof(struct usb_req_read_regs) + count * sizeof(__le16);
-	req = kmalloc(req_len, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
+	BUG_ON(req_len > sizeof(buf));
+
 	req->id = cpu_to_le16(USB_REQ_READ_REGS);
 	for (i = 0; i < count; i++)
 		req->addr[i] = cpu_to_le16((u16)addresses[i]);
@@ -1400,14 +1401,13 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error in usb_bulk_msg(). Error number %d\n", r);
-		goto error;
+		return r;
 	}
 	if (req_len != actual_req_len) {
 		dev_dbg_f(zd_usb_dev(usb), "error in usb_bulk_msg()\n"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
-		r = -EIO;
-		goto error;
+		return -EIO;
 	}
 
 	timeout = wait_for_completion_timeout(&usb->intr.read_regs.completion,
@@ -1415,22 +1415,20 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	if (!timeout) {
 		disable_read_regs_int(usb);
 		dev_dbg_f(zd_usb_dev(usb), "read timed out\n");
-		r = -ETIMEDOUT;
-		goto error;
+		return -ETIMEDOUT;
 	}
 
-	r = get_results(usb, values, req, count);
-error:
-	kfree(req);
-	return r;
+	return get_results(usb, values, req, count);
 }
 
 int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 	              unsigned int count)
 {
+	unsigned char buf[sizeof(struct usb_req_write_regs) +
+			  USB_MAX_IOWRITE16_COUNT * sizeof(struct reg_data)];
 	int r;
 	struct usb_device *udev;
-	struct usb_req_write_regs *req = NULL;
+	struct usb_req_write_regs *req = (void *)buf;
 	int i, req_len, actual_req_len;
 
 	if (count == 0)
@@ -1449,9 +1447,7 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 
 	req_len = sizeof(struct usb_req_write_regs) +
 		  count * sizeof(struct reg_data);
-	req = kmalloc(req_len, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
+	BUG_ON(req_len > sizeof(buf));
 
 	req->id = cpu_to_le16(USB_REQ_WRITE_REGS);
 	for (i = 0; i < count; i++) {
@@ -1466,28 +1462,26 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error in usb_bulk_msg(). Error number %d\n", r);
-		goto error;
+		return r;
 	}
 	if (req_len != actual_req_len) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error in usb_bulk_msg()"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
-		r = -EIO;
-		goto error;
+		return -EIO;
 	}
 
-	/* FALL-THROUGH with r == 0 */
-error:
-	kfree(req);
-	return r;
+	return 0;
 }
 
 int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 {
+	unsigned char buf[sizeof(struct usb_req_rfwrite) +
+			  USB_MAX_RFWRITE_BIT_COUNT * sizeof(__le16)];
 	int r;
 	struct usb_device *udev;
-	struct usb_req_rfwrite *req = NULL;
+	struct usb_req_rfwrite *req = (void *)buf;
 	int i, req_len, actual_req_len;
 	u16 bit_value_template;
 
@@ -1524,14 +1518,12 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error %d: Couldn't read CR203\n", r);
-		goto out;
+		return r;
 	}
 	bit_value_template &= ~(RF_IF_LE|RF_CLK|RF_DATA);
 
 	req_len = sizeof(struct usb_req_rfwrite) + bits * sizeof(__le16);
-	req = kmalloc(req_len, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
+	BUG_ON(req_len > sizeof(buf));
 
 	req->id = cpu_to_le16(USB_REQ_WRITE_RF);
 	/* 1: 3683a, but not used in ZYDAS driver */
@@ -1551,18 +1543,14 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error in usb_bulk_msg(). Error number %d\n", r);
-		goto out;
+		return r;
 	}
 	if (req_len != actual_req_len) {
 		dev_dbg_f(zd_usb_dev(usb), "error in usb_bulk_msg()"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
-		r = -EIO;
-		goto out;
+		return -EIO;
 	}
 
-	/* FALL-THROUGH with r == 0 */
-out:
-	kfree(req);
-	return r;
+	return 0;
 }

