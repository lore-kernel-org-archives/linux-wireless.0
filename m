Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:23643 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbYJQTQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 15:16:19 -0400
Received: by rv-out-0506.google.com with SMTP id k40so710592rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 12:16:19 -0700 (PDT)
Message-ID: <48F8E481.7000308@gmail.com> (sfid-20081017_211622_602802_22BFF82F)
Date: Fri, 17 Oct 2008 12:16:17 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: rt2400-devel@lists.sourceforge.net
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: reduce checkpatch.pl errors
Content-Type: multipart/mixed;
 boundary="------------010200080407060904070200"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010200080407060904070200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

A few changes to reduce checkpatch.pl errors in the rt2x00 driver.  For 
the most part, I only fixed cosmetic things, and left the actual 'code 
flow' untouched (hopefully)!

Diff is against wireless-testing HEAD.

Signed-off-by: John Daiker <daikerjohn@gmail.com>

---



--------------010200080407060904070200
Content-Type: text/x-diff;
 name="rt2x00.checkpatch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rt2x00.checkpatch.diff"

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 5cf4c85..96bc0a0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -285,7 +285,7 @@ exit:
 }
 
 static unsigned int rt2x00debug_poll_queue_dump(struct file *file,
-					        poll_table *wait)
+						poll_table *wait)
 {
 	struct rt2x00debug_intf *intf = file->private_data;
 
@@ -377,7 +377,7 @@ static ssize_t rt2x00debug_read_crypto_stats(struct file *file,
 	if (*offset)
 		return 0;
 
-	data = kzalloc((1 + CIPHER_MAX)* MAX_LINE_LENGTH, GFP_KERNEL);
+	data = kzalloc((1 + CIPHER_MAX) * MAX_LINE_LENGTH, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 451d410..ce69650 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -556,7 +556,7 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 		queue->length++;
 	} else if (index == Q_INDEX_DONE) {
 		queue->length--;
-		queue->count ++;
+		queue->count++;
 	}
 
 	spin_unlock_irqrestore(&queue->lock, irqflags);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index a461620..f03ba53 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1934,7 +1934,7 @@ static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 }
 
 static void rt61pci_fill_rxdone(struct queue_entry *entry,
-			        struct rxdone_entry_desc *rxdesc)
+				struct rxdone_entry_desc *rxdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 934f8e0..00aa837 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1685,7 +1685,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 }
 
 static void rt73usb_fill_rxdone(struct queue_entry *entry,
-			        struct rxdone_entry_desc *rxdesc)
+				struct rxdone_entry_desc *rxdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);

--------------010200080407060904070200--
