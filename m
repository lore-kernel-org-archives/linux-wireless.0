Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38207 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab2DSLYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 07:24:22 -0400
Received: by wibhq7 with SMTP id hq7so1671179wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 04:24:21 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, gwingerde@gmail.com,
	ivdoorn@gmail.com, marvin24@gmx.de,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: Use GFP_KERNEL for rx buffer allocation on USB devices
Date: Thu, 19 Apr 2012 13:24:10 +0200
Message-Id: <1334834650-10098-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120419_132428_276783_6B7E4CFC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the RX path on USB devices is handled in process context we can
use GFP_KERNEL for RX buffer allocation. This should reduce the
likelihood of allocation failures.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Tested-By: Marc Dietrich <marvin24@gmx.de>
---

 drivers/net/wireless/rt2x00/rt2x00.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 527a261..6ad9b6a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1294,7 +1294,7 @@ void rt2x00lib_dmadone(struct queue_entry *entry);
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc);
 void rt2x00lib_txdone_noinfo(struct queue_entry *entry, u32 status);
-void rt2x00lib_rxdone(struct queue_entry *entry);
+void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp);
 void rt2x00lib_wake_sta_tid(struct rt2x00_dev *rt2x00dev,
 			    struct rt2x00_sta *sta_priv,
 			    int tid);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 3da098b..20e6348 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -647,7 +647,7 @@ static int rt2x00lib_rxdone_read_signal(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
-void rt2x00lib_rxdone(struct queue_entry *entry)
+void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct rxdone_entry_desc rxdesc;
@@ -667,7 +667,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 	 * Allocate a new sk_buffer. If no new buffer available, drop the
 	 * received frame and reuse the existing buffer.
 	 */
-	skb = rt2x00queue_alloc_rxskb(entry);
+	skb = rt2x00queue_alloc_rxskb(entry, gfp);
 	if (!skb)
 		goto submit_entry;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 8317ae4..f0aca2a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -103,7 +103,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
  * rt2x00queue_alloc_rxskb - allocate a skb for RX purposes.
  * @entry: The entry for which the skb will be applicable.
  */
-struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry);
+struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp);
 
 /**
  * rt2x00queue_free_skb - free a skb
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 17148bb..0a4653a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -92,7 +92,7 @@ bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		/*
 		 * Send the frame to rt2x00lib for further processing.
 		 */
-		rt2x00lib_rxdone(entry);
+		rt2x00lib_rxdone(entry, GFP_ATOMIC);
 	}
 
 	return !max_rx;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7b4f6b1..7bee686 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -33,7 +33,7 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
-struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry)
+struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct sk_buff *skb;
@@ -68,7 +68,7 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry)
 	/*
 	 * Allocate skbuffer.
 	 */
-	skb = dev_alloc_skb(frame_size + head_size + tail_size);
+	skb = __dev_alloc_skb(frame_size + head_size + tail_size, gfp);
 	if (!skb)
 		return NULL;
 
@@ -1193,7 +1193,7 @@ static int rt2x00queue_alloc_rxskbs(struct data_queue *queue)
 	struct sk_buff *skb;
 
 	for (i = 0; i < queue->limit; i++) {
-		skb = rt2x00queue_alloc_rxskb(&queue->entries[i]);
+		skb = rt2x00queue_alloc_rxskb(&queue->entries[i], GFP_KERNEL);
 		if (!skb)
 			return -ENOMEM;
 		queue->entries[i].skb = skb;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 2eea386..790620a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -358,7 +358,7 @@ static void rt2x00usb_work_rxdone(struct work_struct *work)
 		/*
 		 * Send the frame to rt2x00lib for further processing.
 		 */
-		rt2x00lib_rxdone(entry);
+		rt2x00lib_rxdone(entry, GFP_KERNEL);
 	}
 }
 
-- 
1.7.7

