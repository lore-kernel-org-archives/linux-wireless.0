Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:37751 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754244AbZAVWtD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 17:49:03 -0500
Subject: patch p54usb-fix-traffic-stalls-packet-drop.patch added to 2.6.28-stable tree
To: chunkeey@web.de, art.08.09@gmail.com, gregkh@suse.de,
	Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	rjw@sisk.pl
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Thu, 22 Jan 2009 14:47:40 -0800
In-Reply-To: <200901202311.11854.chunkeey@web.de>
Message-Id: <20090122224902.3E4E948815@coco.kroah.org> (sfid-20090122_234908_754471_43C8A3D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: p54usb: fix traffic stalls / packet drop

to the 2.6.28-stable tree.  Its filename is

    p54usb-fix-traffic-stalls-packet-drop.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From chunkeey@web.de  Thu Jan 22 14:30:12 2009
From: Christian Lamparter <chunkeey@web.de>
Date: Tue, 20 Jan 2009 23:11:11 +0100
Subject: p54usb: fix traffic stalls / packet drop
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH gr <gregkh@suse.de>, Artur Skawina <art.08.09@gmail.com>
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>, "Linux wireless" <linux-wireless@vger.kernel.org>
Message-ID: <200901202311.11854.chunkeey@web.de>
Content-Disposition: inline

From: Christian Lamparter <chunkeey@web.de>

commit 00627f229c9807e4cb825a7ce36b886e2adf2229 upstream.

All p54usb devices need a explicit termination packet, in oder to finish the pending transfer properly.
Else, the firmware could freeze, or simply drop the frame.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -215,6 +215,8 @@ static void p54u_tx_3887(struct ieee8021
 	usb_fill_bulk_urb(data_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), data, len,
 		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+	addr_urb->transfer_flags |= URB_ZERO_PACKET;
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_submit_urb(addr_urb, GFP_ATOMIC);
 	usb_submit_urb(data_urb, GFP_ATOMIC);
@@ -252,6 +254,7 @@ static void p54u_tx_lm87(struct ieee8021
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
 		len + sizeof(*hdr), free_on_tx ? p54u_tx_free_cb : p54u_tx_cb,
 		dev);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
@@ -294,11 +297,13 @@ static void p54u_tx_net2280(struct ieee8
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
 		p54u_tx_free_cb, dev);
+	int_urb->transfer_flags |= URB_ZERO_PACKET;
 	usb_submit_urb(int_urb, GFP_ATOMIC);
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr, len + sizeof(*hdr),
 		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 


Patches currently in stable-queue which might be from chunkeey@web.de are

queue-2.6.28/p54usb-fix-traffic-stalls-packet-drop.patch
