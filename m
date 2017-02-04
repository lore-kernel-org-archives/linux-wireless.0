Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.parknet.co.jp ([210.171.160.6]:60134 "EHLO
        mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdBDBQa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 20:16:30 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        linux-wireless@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-nfc@ml01.01.org
Subject: [PATCH resend 3/4] nfc: Fix RC-S380* needs zero-length packet
References: <871sveu579.fsf@mail.parknet.co.jp>
        <87wpd6sqlw.fsf@mail.parknet.co.jp>
Date: Sat, 04 Feb 2017 10:16:28 +0900
In-Reply-To: <87wpd6sqlw.fsf@mail.parknet.co.jp> (OGAWA Hirofumi's message of
        "Sat, 04 Feb 2017 10:15:55 +0900")
Message-ID: <87shnusqkz.fsf_-_@mail.parknet.co.jp> (sfid-20170204_021648_510644_DB1E43E8)
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
--- linux-ibmpc/drivers/nfc/port100.c~nfc-need-zero-packet	2016-12-31 18:27:14.814753508 +0900
+++ linux-ibmpc-hirofumi/drivers/nfc/port100.c	2016-12-31 18:32:12.928334607 +0900
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
