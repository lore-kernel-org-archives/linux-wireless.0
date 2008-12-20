Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:53948 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYLTKCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:02:20 -0500
Received: by ey-out-2122.google.com with SMTP id 22so125886eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:02:19 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 14/15] rt2x00: Fix segementation fault
Date: Sat, 20 Dec 2008 11:00:23 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201059.30095.IvDoorn@gmail.com> <200812201059.55767.IvDoorn@gmail.com>
In-Reply-To: <200812201059.55767.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201100.24069.IvDoorn@gmail.com> (sfid-20081220_110904_831174_DE9B4256)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The queue_end() macro points to 1 position after the
queue, which means that if we want to know if queue
is at the end of the queue we should first increment
the position and then check if it is a valid entry.

This fixes a segmentation fault which only occurs when
the device has enough endpoints to provide a dedicated
endpoint for all TX queues (which likely won't happen
for rt2500usb and rt73usb, but will happen for rt2800usb).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 83df312..0b29d76 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -434,11 +434,11 @@ static int rt2x00usb_find_endpoints(struct rt2x00_dev *rt2x00dev)
 
 		if (usb_endpoint_is_bulk_in(ep_desc)) {
 			rt2x00usb_assign_endpoint(rt2x00dev->rx, ep_desc);
-		} else if (usb_endpoint_is_bulk_out(ep_desc)) {
+		} else if (usb_endpoint_is_bulk_out(ep_desc) &&
+			   (queue != queue_end(rt2x00dev))) {
 			rt2x00usb_assign_endpoint(queue, ep_desc);
+			queue = queue_next(queue);
 
-			if (queue != queue_end(rt2x00dev))
-				queue = queue_next(queue);
 			tx_ep_desc = ep_desc;
 		}
 	}
-- 
1.5.6.1

