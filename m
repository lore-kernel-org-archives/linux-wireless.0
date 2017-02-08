Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754576AbdBHNIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 08:08:54 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/3] rt2x00: call entry directly in rt2x00_dump_frame
Date: Wed,  8 Feb 2017 13:51:30 +0100
Message-Id: <1486558291-1615-3-git-send-email-sgruszka@redhat.com> (sfid-20170208_141008_337645_8000DB05)
In-Reply-To: <1486558291-1615-1-git-send-email-sgruszka@redhat.com>
References: <1486558291-1615-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c   | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c   | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c   | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      | 4 ++--
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c | 7 ++++---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c   | 4 ++--
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c     | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c     | 2 +-
 10 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index 085c5b4..1987443 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -1200,7 +1200,7 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Dump beacon to userspace through debugfs.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry);
 out:
 	/*
 	 * Enable beaconing again.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index 9832fd5..791434d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -1349,7 +1349,7 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Dump beacon to userspace through debugfs.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry);
 out:
 	/*
 	 * Enable beaconing again.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index cd3ab5a..6235746 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -1170,7 +1170,7 @@ static void rt2500usb_write_beacon(struct queue_entry *entry,
 	/*
 	 * Dump beacon to userspace through debugfs.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry);
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 572cdea..8223a15 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1014,7 +1014,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	/*
 	 * Dump beacon to userspace through debugfs.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry);
 
 	/*
 	 * Write entire beacon with TXWI and padding to register.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index ea299c4..26869b3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -1400,11 +1400,11 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
  */
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
-			    enum rt2x00_dump_type type, struct sk_buff *skb);
+			    enum rt2x00_dump_type type, struct queue_entry *entry);
 #else
 static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 					  enum rt2x00_dump_type type,
-					  struct sk_buff *skb)
+					  struct queue_entry *entry)
 {
 }
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
index 72ae530..964aefd 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
@@ -157,9 +157,10 @@ void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
 }
 
 void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
-			    enum rt2x00_dump_type type, struct sk_buff *skb)
+			    enum rt2x00_dump_type type, struct queue_entry *entry)
 {
 	struct rt2x00debug_intf *intf = rt2x00dev->debugfs_intf;
+	struct sk_buff *skb = entry->skb;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	struct sk_buff *skbcopy;
 	struct rt2x00dump_hdr *dump_hdr;
@@ -196,8 +197,8 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	dump_hdr->chip_rf = cpu_to_le16(rt2x00dev->chip.rf);
 	dump_hdr->chip_rev = cpu_to_le16(rt2x00dev->chip.rev);
 	dump_hdr->type = cpu_to_le16(type);
-	dump_hdr->queue_index = skbdesc->entry->queue->qid;
-	dump_hdr->entry_index = skbdesc->entry->entry_idx;
+	dump_hdr->queue_index = entry->queue->qid;
+	dump_hdr->entry_index = entry->entry_idx;
 	dump_hdr->timestamp_sec = cpu_to_le32(timestamp.tv_sec);
 	dump_hdr->timestamp_usec = cpu_to_le32(timestamp.tv_usec);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 4b08007..dd66781 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -363,7 +363,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * Send frame to debugfs immediately, after this call is completed
 	 * we are going to overwrite the skb->cb array.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry);
 
 	/*
 	 * Determine if the frame has been successfully transmitted and
@@ -772,7 +772,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	 */
 	rt2x00link_update_stats(rt2x00dev, entry->skb, &rxdesc);
 	rt2x00debug_update_crypto(rt2x00dev, &rxdesc);
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry);
 
 	/*
 	 * Initialize RX status information, and send frame
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index b2364d3..380daf4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -544,7 +544,7 @@ static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 	 * All processing on the frame has been completed, this means
 	 * it is now ready to be dumped to userspace through debugfs.
 	 */
-	rt2x00debug_dump_frame(queue->rt2x00dev, DUMP_FRAME_TX, entry->skb);
+	rt2x00debug_dump_frame(queue->rt2x00dev, DUMP_FRAME_TX, entry);
 }
 
 static void rt2x00queue_kick_tx_queue(struct data_queue *queue,
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index 8adb5f3..973d418 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -1988,7 +1988,7 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Dump beacon to userspace through debugfs.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry);
 
 	/*
 	 * Write entire beacon with descriptor and padding to register.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
index 1a29c4d..bb8d307 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -1557,7 +1557,7 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	/*
 	 * Dump beacon to userspace through debugfs.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry);
 
 	/*
 	 * Write entire beacon with descriptor and padding to register.
-- 
1.8.3.1
