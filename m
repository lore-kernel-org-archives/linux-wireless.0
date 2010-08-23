Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43999 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0HWR5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 13:57:24 -0400
Received: by mail-wy0-f174.google.com with SMTP id 32so7066669wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 10:57:23 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/8] rt2x00: Remove Q_INDEX_CRYPTO and ENTRY_OWNER_DEVICE_CRYPTO
Date: Mon, 23 Aug 2010 19:54:41 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008231953.40629.IvDoorn@gmail.com> <201008231954.03752.IvDoorn@gmail.com> <201008231954.22661.IvDoorn@gmail.com>
In-Reply-To: <201008231954.22661.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008231954.42087.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Q_INDEX_CRYPTO and ENTRY_OWNER_DEVICE_CRYPTO where initially
added with the plan to implement hardware encryption for rt2500pci.
However there are no plans to do so anymore as the crypto
mechanism in rt2500pci is very different then any other Ralink
device.

So we can now safely remove the definitions, and don't think
about this feature anymore. :)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |    7 +++----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    7 -------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 2d018ce..7a907bc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -338,16 +338,15 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 		return -ENOMEM;
 
 	temp = data +
-	    sprintf(data, "qid\tcount\tlimit\tlength\tindex\tdone\tcrypto\n");
+	    sprintf(data, "qid\tcount\tlimit\tlength\tindex\tdone\n");
 
 	queue_for_each(intf->rt2x00dev, queue) {
 		spin_lock_irqsave(&queue->lock, irqflags);
 
-		temp += sprintf(temp, "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", queue->qid,
+		temp += sprintf(temp, "%d\t%d\t%d\t%d\t%d\t%d\n", queue->qid,
 				queue->count, queue->limit, queue->length,
 				queue->index[Q_INDEX],
-				queue->index[Q_INDEX_DONE],
-				queue->index[Q_INDEX_CRYPTO]);
+				queue->index[Q_INDEX_DONE]);
 
 		spin_unlock_irqrestore(&queue->lock, irqflags);
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 46a3be1..c451a50 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -360,9 +360,6 @@ struct txentry_desc {
  * @ENTRY_OWNER_DEVICE_DATA: This entry is owned by the device for data
  *	transfer (either TX or RX depending on the queue). The entry should
  *	only be touched after the device has signaled it is done with it.
- * @ENTRY_OWNER_DEVICE_CRYPTO: This entry is owned by the device for data
- *	encryption or decryption. The entry should only be touched after
- *	the device has signaled it is done with it.
  * @ENTRY_DATA_PENDING: This entry contains a valid frame and is waiting
  *	for the signal to start sending.
  * @ENTRY_DATA_IO_FAILED: Hardware indicated that an IO error occured
@@ -372,7 +369,6 @@ struct txentry_desc {
 enum queue_entry_flags {
 	ENTRY_BCN_ASSIGNED,
 	ENTRY_OWNER_DEVICE_DATA,
-	ENTRY_OWNER_DEVICE_CRYPTO,
 	ENTRY_DATA_PENDING,
 	ENTRY_DATA_IO_FAILED
 };
@@ -408,15 +404,12 @@ struct queue_entry {
  * @Q_INDEX_DONE: Index pointer to the next entry which will be completed by
  *	the hardware and for which we need to run the txdone handler. If this
  *	entry is not owned by the hardware the queue is considered to be empty.
- * @Q_INDEX_CRYPTO: Index pointer to the next entry which encryption/decription
- *	will be completed by the hardware next.
  * @Q_INDEX_MAX: Keep last, used in &struct data_queue to determine the size
  *	of the index array.
  */
 enum queue_index {
 	Q_INDEX,
 	Q_INDEX_DONE,
-	Q_INDEX_CRYPTO,
 	Q_INDEX_MAX,
 };
 
-- 
1.7.2.1

