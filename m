Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2577 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab0EKVv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 17:51:56 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 5/9] rt2x00: Dump beacons under a different identifier than TX frames.
Date: Tue, 11 May 2010 23:51:41 +0200
Message-Id: <1273614705-25118-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows for specific identification of beacons in the debugfs
frame stream.
Preparation for later differences between dumped TX frames and dumped
beacons.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dump.h  |    3 +++
 drivers/net/wireless/rt2x00/rt2x00queue.c |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dump.h b/drivers/net/wireless/rt2x00/rt2x00dump.h
index 727019a..ed303b4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dump.h
+++ b/drivers/net/wireless/rt2x00/rt2x00dump.h
@@ -62,11 +62,14 @@
  *	the tx event which has either succeeded or failed. A frame
  *	with this type should also have been reported with as a
  *	%DUMP_FRAME_TX frame.
+ * @DUMP_FRAME_BEACON: This beacon frame is queued for transmission to the
+ *	hardware.
  */
 enum rt2x00_dump_type {
 	DUMP_FRAME_RXDONE = 1,
 	DUMP_FRAME_TX = 2,
 	DUMP_FRAME_TXDONE = 3,
+	DUMP_FRAME_BEACON = 4,
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 891d5f7..e5969a5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -420,6 +420,7 @@ static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 {
 	struct data_queue *queue = entry->queue;
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	enum rt2x00_dump_type;
 
 	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry->skb, txdesc);
 
@@ -427,7 +428,9 @@ static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 	 * All processing on the frame has been completed, this means
 	 * it is now ready to be dumped to userspace through debugfs.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TX, entry->skb);
+	dump_type = (txdesc->queue == QID_BEACON) ?
+					DUMP_FRAME_BEACON : DUMP_FRAME_TX;
+	rt2x00debug_dump_frame(rt2x00dev, dump_type, entry->skb);
 }
 
 static void rt2x00queue_kick_tx_queue(struct queue_entry *entry,
-- 
1.7.1

