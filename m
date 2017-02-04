Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.parknet.co.jp ([210.171.160.6]:60139 "EHLO
        mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdBDBQ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 20:16:59 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        linux-wireless@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-nfc@ml01.01.org
Subject: [PATCH resend 4/4] nfc: Fix hangup of RC-S380* in port100_send_ack()
References: <871sveu579.fsf@mail.parknet.co.jp>
        <87wpd6sqlw.fsf@mail.parknet.co.jp>
        <87shnusqkz.fsf_-_@mail.parknet.co.jp>
Date: Sat, 04 Feb 2017 10:16:56 +0900
In-Reply-To: <87shnusqkz.fsf_-_@mail.parknet.co.jp> (OGAWA Hirofumi's message
        of "Sat, 04 Feb 2017 10:16:28 +0900")
Message-ID: <87o9yisqk7.fsf_-_@mail.parknet.co.jp> (sfid-20170204_021721_809402_B843FD25)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


If port100_send_ack() was called twice or more, it has race to hangup.

  port100_send_ack()          port100_send_ack()
    init_completion()
    [...]
    dev->cmd_cancel = true
                                /* this removes previous from completion */
                                init_completion()
				[...]
                                dev->cmd_cancel = true
                                wait_for_completion()
    /* never be waked up */
    wait_for_completion()

Like above race, this code is not assuming port100_send_ack() is
called twice or more.

To fix, this checks dev->cmd_cancel to know if prior cancel is
in-flight or not. And never be remove prior task from completion by
using reinit_completion(), so this guarantees to be waked up properly
soon or later.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/nfc/port100.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff -puN drivers/nfc/port100.c~nfc-port100-hang-fix drivers/nfc/port100.c
--- linux-ibmpc/drivers/nfc/port100.c~nfc-port100-hang-fix	2017-01-03 12:32:13.261785257 +0900
+++ linux-ibmpc-hirofumi/drivers/nfc/port100.c	2017-01-03 12:33:51.965364300 +0900
@@ -726,23 +726,33 @@ static int port100_submit_urb_for_ack(st
 
 static int port100_send_ack(struct port100 *dev)
 {
-	int rc;
+	int rc = 0;
 
 	mutex_lock(&dev->out_urb_lock);
 
-	init_completion(&dev->cmd_cancel_done);
-
-	usb_kill_urb(dev->out_urb);
+	/*
+	 * If prior cancel is in-flight (dev->cmd_cancel == true), we
+	 * can skip to send cancel. Then this will wait the prior
+	 * cancel, or merged into the next cancel rarely if next
+	 * cancel was started before waiting done. In any case, this
+	 * will be waked up soon or later.
+	 */
+	if (!dev->cmd_cancel) {
+		reinit_completion(&dev->cmd_cancel_done);
 
-	dev->out_urb->transfer_buffer = ack_frame;
-	dev->out_urb->transfer_buffer_length = sizeof(ack_frame);
-	rc = usb_submit_urb(dev->out_urb, GFP_KERNEL);
+		usb_kill_urb(dev->out_urb);
 
-	/* Set the cmd_cancel flag only if the URB has been successfully
-	 * submitted. It will be reset by the out URB completion callback
-	 * port100_send_complete().
-	 */
-	dev->cmd_cancel = !rc;
+		dev->out_urb->transfer_buffer = ack_frame;
+		dev->out_urb->transfer_buffer_length = sizeof(ack_frame);
+		rc = usb_submit_urb(dev->out_urb, GFP_KERNEL);
+
+		/*
+		 * Set the cmd_cancel flag only if the URB has been
+		 * successfully submitted. It will be reset by the out
+		 * URB completion callback port100_send_complete().
+		 */
+		dev->cmd_cancel = !rc;
+	}
 
 	mutex_unlock(&dev->out_urb_lock);
 
@@ -929,8 +939,8 @@ static void port100_send_complete(struct
 	struct port100 *dev = urb->context;
 
 	if (dev->cmd_cancel) {
+		complete_all(&dev->cmd_cancel_done);
 		dev->cmd_cancel = false;
-		complete(&dev->cmd_cancel_done);
 	}
 
 	switch (urb->status) {
@@ -1546,6 +1556,7 @@ static int port100_probe(struct usb_inte
 			    PORT100_COMM_RF_HEAD_MAX_LEN;
 	dev->skb_tailroom = PORT100_FRAME_TAIL_LEN;
 
+	init_completion(&dev->cmd_cancel_done);
 	INIT_WORK(&dev->cmd_complete_work, port100_wq_cmd_complete);
 
 	/* The first thing to do with the Port-100 is to set the command type
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
