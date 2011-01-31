Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:46407 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab1AaStU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:49:20 -0500
Subject: [PATCH 14/22] [v2] zd1211rw: use stack and preallocated memory for
	small cmd-buffers
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:49:14 +0200
Message-ID: <20110131184914.10044.19685.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use stack for allocing small < 64 byte arrays in zd_chip.c and preallocated
buffer in zd_usb.c. This might lower CPU usage for beacon setup.

v2:
 - Do not use stack buffers in zd_usb.c as they would be used for urb
   transfer_buffer.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |   43 +++++++++----------------------
 drivers/net/wireless/zd1211rw/zd_usb.c  |   42 ++++++++++++++++++++----------
 drivers/net/wireless/zd1211rw/zd_usb.h  |    1 +
 3 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index d8dc927..907e656 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -108,25 +108,17 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 {
 	int r;
 	int i;
-	zd_addr_t *a16;
-	u16 *v16;
+	zd_addr_t a16[USB_MAX_IOREAD32_COUNT * 2];
+	u16 v16[USB_MAX_IOREAD32_COUNT * 2];
 	unsigned int count16;
 
 	if (count > USB_MAX_IOREAD32_COUNT)
 		return -EINVAL;
 
-	/* Allocate a single memory block for values and addresses. */
-	count16 = 2*count;
-	/* zd_addr_t is __nocast, so the kmalloc needs an explicit cast */
-	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
-		                   GFP_KERNEL);
-	if (!a16) {
-		dev_dbg_f(zd_chip_dev(chip),
-			  "error ENOMEM in allocation of a16\n");
-		r = -ENOMEM;
-		goto out;
-	}
-	v16 = (u16 *)(a16 + count16);
+	/* Use stack for values and addresses. */
+	count16 = 2 * count;
+	BUG_ON(count16 * sizeof(zd_addr_t) > sizeof(a16));
+	BUG_ON(count16 * sizeof(u16) > sizeof(v16));
 
 	for (i = 0; i < count; i++) {
 		int j = 2*i;
@@ -139,7 +131,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 	if (r) {
 		dev_dbg_f(zd_chip_dev(chip),
 			  "error: zd_ioread16v_locked. Error number %d\n", r);
-		goto out;
+		return r;
 	}
 
 	for (i = 0; i < count; i++) {
@@ -147,18 +139,18 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
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
@@ -166,15 +158,8 @@ int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
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
@@ -192,8 +177,6 @@ int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
 			  "error %d in zd_usb_write16v\n", r);
 	}
 #endif /* DEBUG */
-out:
-	kfree(ioreqs16);
 	return r;
 }
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 9493ab8..6b604fc 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1361,15 +1361,20 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 		return -EWOULDBLOCK;
 	}
 	if (!usb_int_enabled(usb)) {
-		 dev_dbg_f(zd_usb_dev(usb),
+		dev_dbg_f(zd_usb_dev(usb),
 			  "error: usb interrupt not enabled\n");
 		return -EWOULDBLOCK;
 	}
 
+	ZD_ASSERT(mutex_is_locked(&zd_usb_to_chip(usb)->mutex));
+	BUILD_BUG_ON(sizeof(struct usb_req_read_regs) + USB_MAX_IOREAD16_COUNT *
+		     sizeof(__le16) > sizeof(usb->req_buf));
+	BUG_ON(sizeof(struct usb_req_read_regs) + count * sizeof(__le16) >
+	       sizeof(usb->req_buf));
+
 	req_len = sizeof(struct usb_req_read_regs) + count * sizeof(__le16);
-	req = kmalloc(req_len, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
+	req = (void *)usb->req_buf;
+
 	req->id = cpu_to_le16(USB_REQ_READ_REGS);
 	for (i = 0; i < count; i++)
 		req->addr[i] = cpu_to_le16((u16)addresses[i]);
@@ -1402,7 +1407,6 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 
 	r = get_results(usb, values, req, count);
 error:
-	kfree(req);
 	return r;
 }
 
@@ -1428,11 +1432,17 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 		return -EWOULDBLOCK;
 	}
 
+	ZD_ASSERT(mutex_is_locked(&zd_usb_to_chip(usb)->mutex));
+	BUILD_BUG_ON(sizeof(struct usb_req_write_regs) +
+		     USB_MAX_IOWRITE16_COUNT * sizeof(struct reg_data) >
+		     sizeof(usb->req_buf));
+	BUG_ON(sizeof(struct usb_req_write_regs) +
+	       count * sizeof(struct reg_data) >
+	       sizeof(usb->req_buf));
+
 	req_len = sizeof(struct usb_req_write_regs) +
 		  count * sizeof(struct reg_data);
-	req = kmalloc(req_len, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
+	req = (void *)usb->req_buf;
 
 	req->id = cpu_to_le16(USB_REQ_WRITE_REGS);
 	for (i = 0; i < count; i++) {
@@ -1460,7 +1470,6 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 
 	/* FALL-THROUGH with r == 0 */
 error:
-	kfree(req);
 	return r;
 }
 
@@ -1505,14 +1514,19 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error %d: Couldn't read CR203\n", r);
-		goto out;
+		return r;
 	}
 	bit_value_template &= ~(RF_IF_LE|RF_CLK|RF_DATA);
 
+	ZD_ASSERT(mutex_is_locked(&zd_usb_to_chip(usb)->mutex));
+	BUILD_BUG_ON(sizeof(struct usb_req_rfwrite) +
+		     USB_MAX_RFWRITE_BIT_COUNT * sizeof(__le16) >
+		     sizeof(usb->req_buf));
+	BUG_ON(sizeof(struct usb_req_rfwrite) + bits * sizeof(__le16) >
+	       sizeof(usb->req_buf));
+
 	req_len = sizeof(struct usb_req_rfwrite) + bits * sizeof(__le16);
-	req = kmalloc(req_len, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
+	req = (void *)usb->req_buf;
 
 	req->id = cpu_to_le16(USB_REQ_WRITE_RF);
 	/* 1: 3683a, but not used in ZYDAS driver */
@@ -1544,6 +1558,6 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 
 	/* FALL-THROUGH with r == 0 */
 out:
-	kfree(req);
 	return r;
 }
+
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 233ce82..2ed48ae 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -207,6 +207,7 @@ struct zd_usb {
 	struct zd_usb_rx rx;
 	struct zd_usb_tx tx;
 	struct usb_interface *intf;
+	u8 req_buf[64]; /* zd_usb_iowrite16v needs 62 bytes */
 	u8 is_zd1211b:1, initialized:1;
 };
 

