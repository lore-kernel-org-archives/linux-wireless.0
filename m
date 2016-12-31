Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.parknet.co.jp ([210.171.160.6]:45443 "EHLO
        mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753202AbcLaLmj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Dec 2016 06:42:39 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        linux-wireless@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] nfc: Fix RC-S380* needs zero-length packet
References: <8737h4nx6b.fsf@mail.parknet.co.jp>
        <87y3ywmikp.fsf@mail.parknet.co.jp>
Date: Sat, 31 Dec 2016 20:42:37 +0900
In-Reply-To: <87y3ywmikp.fsf@mail.parknet.co.jp> (OGAWA Hirofumi's message of
        "Sat, 31 Dec 2016 20:41:42 +0900")
Message-ID: <87tw9kmij6.fsf_-_@mail.parknet.co.jp> (sfid-20161231_124443_085967_503D2DB6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


If sent packet size is wMaxPacketSize boundary, this device doesn't
answer. To fix this, we have to send zero-length packet in usb spec.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/nfc/port100.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/nfc/port100.c~nfc-need-zero-packet drivers/nfc/port100.c
--- linux/drivers/nfc/port100.c~nfc-need-zero-packet	2016-12-31 19:11:03.893974993 +0900
+++ linux-hirofumi/drivers/nfc/port100.c	2016-12-31 19:11:03.895975004 +0900
@@ -1540,6 +1540,7 @@ static int port100_probe(struct usb_inte
 	usb_fill_bulk_urb(dev->out_urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev, out_endpoint),
 			  NULL, 0, port100_send_complete, dev);
+	dev->out_urb->transfer_flags = URB_ZERO_PACKET;
 
 	dev->skb_headroom = PORT100_FRAME_HEADER_LEN +
 			    PORT100_COMM_RF_HEAD_MAX_LEN;
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
