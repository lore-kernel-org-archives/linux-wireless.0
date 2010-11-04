Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59008 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0KDTnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:49 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1320245eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:48 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 07/13] rt2x00: Rename rt2x00queue_timeout
Date: Thu, 4 Nov 2010 20:39:23 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042038.35919.IvDoorn@gmail.com> <201011042038.57061.IvDoorn@gmail.com>
In-Reply-To: <201011042038.57061.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042039.24768.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename rt2x00queue_timeout to rt2x00queue_status_timeout to
better describe what is actually timing out (note that
we already have a rt2x00queue_dma_timeout).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.h |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 8a36ef3..64c00e2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -593,10 +593,10 @@ static inline int rt2x00queue_threshold(struct data_queue *queue)
 }
 
 /**
- * rt2x00queue_timeout - Check if a timeout occured for STATUS reorts
+ * rt2x00queue_status_timeout - Check if a timeout occured for STATUS reports
  * @queue: Queue to check.
  */
-static inline int rt2x00queue_timeout(struct data_queue *queue)
+static inline int rt2x00queue_status_timeout(struct data_queue *queue)
 {
 	return time_after(queue->last_action[Q_INDEX_DMA_DONE],
 			  queue->last_action[Q_INDEX_DONE] + (HZ / 10));
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index b3317df..88995d5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -361,7 +361,7 @@ void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev)
 		if (!rt2x00queue_empty(queue)) {
 			if (rt2x00queue_dma_timeout(queue))
 				rt2x00usb_watchdog_tx_dma(queue);
-			if (rt2x00queue_timeout(queue))
+			if (rt2x00queue_status_timeout(queue))
 				rt2x00usb_watchdog_tx_status(queue);
 		}
 	}
-- 
1.7.2.3

