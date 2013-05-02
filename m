Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46262 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822Ab3EBMaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 08:30:10 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 01/14] rt2x00: rt2x00queue: add priv_size field to struct data_queue
Date: Thu,  2 May 2013 14:30:16 +0200
Message-Id: <1367497829-7672-2-git-send-email-juhosg@openwrt.org> (sfid-20130502_143041_501944_AFB8D709)
In-Reply-To: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
References: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new field into struct data_queue and store
the size of the per-queue_entry private data in
that. Additionally, use the new field in the
rt2x00queue_alloc_entries function to compute
the size of the queue entries for a given queue.

This does not change the current behaviour but
makes it possible to move the initialization of
the queue_data fields into the rt2x00queue_init
routine.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    5 +++--
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 2c12311..15714a2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1175,11 +1175,12 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 	queue->data_size = qdesc->data_size;
 	queue->desc_size = qdesc->desc_size;
 	queue->winfo_size = qdesc->winfo_size;
+	queue->priv_size = qdesc->priv_size;
 
 	/*
 	 * Allocate all queue entries.
 	 */
-	entry_size = sizeof(*entries) + qdesc->priv_size;
+	entry_size = sizeof(*entries) + queue->priv_size;
 	entries = kcalloc(queue->limit, entry_size, GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
@@ -1195,7 +1196,7 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 		entries[i].entry_idx = i;
 		entries[i].priv_data =
 		    QUEUE_ENTRY_PRIV_OFFSET(entries, i, queue->limit,
-					    sizeof(*entries), qdesc->priv_size);
+					    sizeof(*entries), queue->priv_size);
 	}
 
 #undef QUEUE_ENTRY_PRIV_OFFSET
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

