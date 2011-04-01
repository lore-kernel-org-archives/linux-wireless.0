Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:59832 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757906Ab1DAQeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:34:12 -0400
Subject: [2.6.39 PATCH 1/2] zd1211rw: remove URB_SHORT_NOT_OK flag in
	zd_usb_iowrite16v_async()
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 01 Apr 2011 19:34:08 +0300
Message-ID: <20110401163408.24880.70537.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch removes the bogus flag introduced by upstream commit
eefdbec1ea8b7093d2c09d1825f68438701723cf. Old code had buffer length check
that new code tried to handle with URB_SHORT_NOT_OK flag. With USB debugging
enabled bogus flag caused usb_submit_urb fail.

Remove URB_SHORT_NOT_OK flag and add buffer length check to urb completion
handler.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=32092
Reported-by: Jonathan Callen <abcd@gentoo.org>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 58236e6..9b1a26a 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1671,6 +1671,10 @@ static void iowrite16v_urb_complete(struct urb *urb)
 
 	if (urb->status && !usb->cmd_error)
 		usb->cmd_error = urb->status;
+
+	if (!usb->cmd_error &&
+			urb->actual_length != urb->transfer_buffer_length)
+		usb->cmd_error = -EIO;
 }
 
 static int zd_submit_waiting_urb(struct zd_usb *usb, bool last)
@@ -1805,7 +1809,7 @@ int zd_usb_iowrite16v_async(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 	usb_fill_int_urb(urb, udev, usb_sndintpipe(udev, EP_REGS_OUT),
 			 req, req_len, iowrite16v_urb_complete, usb,
 			 ep->desc.bInterval);
-	urb->transfer_flags |= URB_FREE_BUFFER | URB_SHORT_NOT_OK;
+	urb->transfer_flags |= URB_FREE_BUFFER;
 
 	/* Submit previous URB */
 	r = zd_submit_waiting_urb(usb, false);

