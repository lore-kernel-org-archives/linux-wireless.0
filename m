Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:60628 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571Ab1BLSn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 13:43:29 -0500
Subject: [PATCH 1/4] zd1211rw: correct use of usb_bulk_msg on interrupt
	endpoints
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sat, 12 Feb 2011 20:43:23 +0200
Message-ID: <20110212184323.2062.75645.stgit@fate.lan>
In-Reply-To: <20110212184254.2062.33710.stgit@fate.lan>
References: <20110212184254.2062.33710.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1211rw is using usb_bulk_msg() with usb_sndbulkpipe() on interrupt endpoint.
However usb_bulk_msg() internally corrects this and makes interrupt URB.

It's better to change usb_bulk_msgs in zd1211rw to usb_interrupt_msg for less
confusion.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index f6df366..7346512 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1634,15 +1634,15 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 
 	udev = zd_usb_to_usbdev(usb);
 	prepare_read_regs_int(usb);
-	r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, EP_REGS_OUT),
-			 req, req_len, &actual_req_len, 50 /* ms */);
+	r = usb_interrupt_msg(udev, usb_sndintpipe(udev, EP_REGS_OUT),
+			      req, req_len, &actual_req_len, 50 /* ms */);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_bulk_msg(). Error number %d\n", r);
+			"error in usb_interrupt_msg(). Error number %d\n", r);
 		goto error;
 	}
 	if (req_len != actual_req_len) {
-		dev_dbg_f(zd_usb_dev(usb), "error in usb_bulk_msg()\n"
+		dev_dbg_f(zd_usb_dev(usb), "error in usb_interrupt_msg()\n"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
 		r = -EIO;
@@ -1705,16 +1705,16 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 	}
 
 	udev = zd_usb_to_usbdev(usb);
-	r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, EP_REGS_OUT),
-			 req, req_len, &actual_req_len, 50 /* ms */);
+	r = usb_interrupt_msg(udev, usb_sndintpipe(udev, EP_REGS_OUT),
+			      req, req_len, &actual_req_len, 50 /* ms */);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_bulk_msg(). Error number %d\n", r);
+			"error in usb_interrupt_msg(). Error number %d\n", r);
 		goto error;
 	}
 	if (req_len != actual_req_len) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_bulk_msg()"
+			"error in usb_interrupt_msg()"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
 		r = -EIO;
@@ -1794,15 +1794,15 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 	}
 
 	udev = zd_usb_to_usbdev(usb);
-	r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, EP_REGS_OUT),
-			 req, req_len, &actual_req_len, 50 /* ms */);
+	r = usb_interrupt_msg(udev, usb_sndintpipe(udev, EP_REGS_OUT),
+			      req, req_len, &actual_req_len, 50 /* ms */);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_bulk_msg(). Error number %d\n", r);
+			"error in usb_interrupt_msg(). Error number %d\n", r);
 		goto out;
 	}
 	if (req_len != actual_req_len) {
-		dev_dbg_f(zd_usb_dev(usb), "error in usb_bulk_msg()"
+		dev_dbg_f(zd_usb_dev(usb), "error in usb_interrupt_msg()"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
 		r = -EIO;

