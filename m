Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:50685 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1ADXts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:49:48 -0500
Subject: [RFC PATCH 14/17] zd1211rw: lower hw command timeouts
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:49:44 +0200
Message-ID: <20110104234944.25309.65071.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Device command timeouts are set up very high (1 sec) and this causes
AP beacon to lock up for long for example. Checking timeouts on device
it's easy to see that 1 sec timeout is not needed, when device fails
to response longer timeout doesn't help:

[  473.074419] zd1211rw 1-1:1.0: print_times() Read times:
[  473.175163] zd1211rw 1-1:1.0: print_time()     0 - 10 msec: 1506
[  473.176429] zd1211rw 1-1:1.0: print_time()    11 - 50 msec: 0
[  473.177955] zd1211rw 1-1:1.0: print_time()   51 - 100 msec: 0
[  473.180703] zd1211rw 1-1:1.0: print_time()  101 - 250 msec: 0
[  473.182101] zd1211rw 1-1:1.0: print_time()  251 - 500 msec: 0
[  473.183221] zd1211rw 1-1:1.0: print_time() 500 - 1000 msec: 20
[  473.184381] zd1211rw 1-1:1.0: print_time() 1000 - ... msec: 18

Also vendor driver doesn't use this long timeout. Therefore change
timeout to 50msec.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 13a089b..b709a9d 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1397,7 +1397,7 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	udev = zd_usb_to_usbdev(usb);
 	prepare_read_regs_int(usb);
 	r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, EP_REGS_OUT),
-		         req, req_len, &actual_req_len, 1000 /* ms */);
+			 req, req_len, &actual_req_len, 50 /* ms */);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error in usb_bulk_msg(). Error number %d\n", r);
@@ -1411,7 +1411,7 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	}
 
 	timeout = wait_for_completion_timeout(&usb->intr.read_regs.completion,
-	                                      msecs_to_jiffies(1000));
+					      msecs_to_jiffies(50));
 	if (!timeout) {
 		disable_read_regs_int(usb);
 		dev_dbg_f(zd_usb_dev(usb), "read timed out\n");
@@ -1458,7 +1458,7 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 
 	udev = zd_usb_to_usbdev(usb);
 	r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, EP_REGS_OUT),
-		         req, req_len, &actual_req_len, 1000 /* ms */);
+			 req, req_len, &actual_req_len, 50 /* ms */);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error in usb_bulk_msg(). Error number %d\n", r);
@@ -1539,7 +1539,7 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 
 	udev = zd_usb_to_usbdev(usb);
 	r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, EP_REGS_OUT),
-		         req, req_len, &actual_req_len, 1000 /* ms */);
+			 req, req_len, &actual_req_len, 50 /* ms */);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error in usb_bulk_msg(). Error number %d\n", r);
@@ -1554,3 +1554,4 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 
 	return 0;
 }
+

