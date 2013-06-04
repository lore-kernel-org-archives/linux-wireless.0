Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38351 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3FDLlG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:41:06 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 01/13] rt2x00: rt2x00queue: add priv_size field to struct data_queue
Date: Tue,  4 Jun 2013 13:40:38 +0200
Message-Id: <1370346050-7047-2-git-send-email-juhosg@openwrt.org> (sfid-20130604_134120_921029_C6B90110)
In-Reply-To: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
References: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new field into struct data_queue and store
the size of the per-queue_entry private data in
that. Additionally, use the new field in the
rt2x00queue_alloc_entries function to compute
the size of the queue entries for a given queue.

The patch does not change the current behaviour
but makes it possible to remove the queue_desc
parameter of the rt2x00queue_alloc_entries function.
That will be done by a subsequent patch.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    5 +++--
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 5efbbbd..7f938a5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1173,7 +1173,7 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 	/*
 	 * Allocate all queue entries.
 	 */
-	entry_size = sizeof(*entries) + qdesc->priv_size;
+	entry_size = sizeof(*entries) + queue->priv_size;
 	entries = kcalloc(queue->limit, entry_size, GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
@@ -1189,7 +1189,7 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 		entries[i].entry_idx = i;
 		entries[i].priv_data =
 		    QUEUE_ENTRY_PRIV_OFFSET(entries, i, queue->limit,
-					    sizeof(*entries), qdesc->priv_size);
+					    sizeof(*entries), queue->priv_size);
 	}
 
 #undef QUEUE_ENTRY_PRIV_OFFSET
@@ -1329,6 +1329,7 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 	queue->data_size = qdesc->data_size;
 	queue->desc_size = qdesc->desc_size;
 	queue->winfo_size = qdesc->winfo_size;
+	queue->priv_size = qdesc->priv_size;
 }
 
 int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 4a7b34e..2cf4903 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -453,6 +453,7 @@ enum data_queue_flags {
  * @cw_max: The cw max value for outgoing frames (field ignored in RX queue).
  * @data_size: Maximum data size for the frames in this queue.
  * @desc_size: Hardware descriptor size for the data in this queue.
+ * @priv_size: Size of per-queue_entry private data.
  * @usb_endpoint: Device endpoint used for communication (USB only)
  * @usb_maxpacket: Max packet size for given endpoint (USB only)
  */
@@ -481,6 +482,7 @@ struct data_queue {
 	unsigned short data_size;
 	unsigned char  desc_size;
 	unsigned char  winfo_size;
+	unsigned short priv_size;
 
 	unsigned short usb_endpoint;
 	unsigned short usb_maxpacket;
-- 
1.7.10

