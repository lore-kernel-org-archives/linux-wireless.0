Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.parknet.co.jp ([210.171.160.6]:45947 "EHLO
        mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756379AbdACFsU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 00:48:20 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        linux-wireless@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH resend 3/4] nfc: Fix RC-S380* needs zero-length packet
References: <87ful0lmop.fsf@mail.parknet.co.jp>
        <87bmvolmnt.fsf@mail.parknet.co.jp>
Date: Tue, 03 Jan 2017 14:48:17 +0900
In-Reply-To: <87bmvolmnt.fsf@mail.parknet.co.jp> (OGAWA Hirofumi's message of
        "Tue, 03 Jan 2017 14:47:50 +0900")
Message-ID: <877f6clmn2.fsf_-_@mail.parknet.co.jp> (sfid-20170103_064845_558418_3D64F1E2)
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
