Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:2520 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759975AbYFWRhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 13:37:40 -0400
Received: by ug-out-1314.google.com with SMTP id h2so569684ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 10:37:38 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: kill URB for all TX queues during disable_radio()
Date: Mon, 23 Jun 2008 19:56:50 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806231956.50365.IvDoorn@gmail.com> (sfid-20080623_193759_555466_4184DA8E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During rt2x00usb_disable_radio() all pending urb's should
be killed and not only those from the RX queue.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 5593b9a..83862e7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -284,6 +284,7 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	struct queue_entry_priv_usb *entry_priv;
 	struct queue_entry_priv_usb_bcn *bcn_priv;
+	struct data_queue *queue;
 	unsigned int i;
 
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_RX_CONTROL, 0, 0,
@@ -292,9 +293,11 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Cancel all queues.
 	 */
-	for (i = 0; i < rt2x00dev->rx->limit; i++) {
-		entry_priv = rt2x00dev->rx->entries[i].priv_data;
-		usb_kill_urb(entry_priv->urb);
+	queue_for_each(rt2x00dev, queue) {
+		for (i = 0; i < queue->limit; i++) {
+			entry_priv = queue->entries[i].priv_data;
+			usb_kill_urb(entry_priv->urb);
+		}
 	}
 
 	/*
-- 
1.5.5.4

