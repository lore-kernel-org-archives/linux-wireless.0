Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:16492 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbXK0Tyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:54:44 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1090951nfb
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:54:41 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/11] rt2x00: Add TX/RX frame dumping facility
Date: Tue, 27 Nov 2007 21:49:29 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272149.29390.IvDoorn@gmail.com> (sfid-20071127_211139_489382_989E056E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds TX/RX frame dumping capabilities through debugfs.
The intention is that with this approach debugging of rt2x00 is
simplified since _all_ frames going in and out of the device
are send to debugfs as well along with additional information
like the hardware descriptor.

Based on the patch by Mattias Nissler.
Mattias also has some tools that will make the dumped frames
available to wireshark: http://www-user.rhrk.uni-kl.de/~nissler/rt2x00/

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    8 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c |  182 ++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   20 +++-
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    6 +
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    4 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    6 +-
 6 files changed, 216 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 31e48c2..ba874cf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -623,7 +623,7 @@ struct rt2x00_dev {
 	 * required for deregistration of debugfs.
 	 */
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	const struct rt2x00debug_intf *debugfs_intf;
+	struct rt2x00debug_intf *debugfs_intf;
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
 	/*
@@ -791,6 +791,12 @@ struct rt2x00_dev {
 	ring_loop(__entry, (__dev)->tx, ring_end(__dev))
 
 /*
+ * Compute an array index from a pointer to an element and the base pointer.
+ */
+#define ARRAY_INDEX(__elem, __base) \
+	( ((char *)(__elem) - (char *)(__base)) / sizeof(*(__elem)) )
+
+/*
  * Generic RF access.
  * The RF is being accessed by word index.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 3aa7e0a..e72c981 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -26,10 +26,12 @@
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/poll.h>
 #include <linux/uaccess.h>
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
+#include "rt2x00dump.h"
 
 #define PRINT_LINE_LEN_MAX 32
 
@@ -58,6 +60,8 @@ struct rt2x00debug_intf {
 	 *     - eeprom offset/value files
 	 *     - bbp offset/value files
 	 *     - rf offset/value files
+	 *   - frame dump folder
+	 *     - frame dump file
 	 */
 	struct dentry *driver_folder;
 	struct dentry *driver_entry;
@@ -72,6 +76,24 @@ struct rt2x00debug_intf {
 	struct dentry *bbp_val_entry;
 	struct dentry *rf_off_entry;
 	struct dentry *rf_val_entry;
+	struct dentry *frame_folder;
+	struct dentry *frame_dump_entry;
+
+	/*
+	 * The frame dump file only allows a single reader,
+	 * so we need to store the current state here.
+	 */
+	unsigned long frame_dump_flags;
+#define FRAME_DUMP_FILE_OPEN	1
+
+	/*
+	 * We queue each frame before dumping it to the user,
+	 * per read command we will pass a single skb structure
+	 * so we should be prepared to queue multiple sk buffers
+	 * before sending it to userspace.
+	 */
+	struct sk_buff_head frame_dump_skbqueue;
+	wait_queue_head_t frame_dump_waitqueue;
 
 	/*
 	 * Driver and chipset files will use a data buffer
@@ -90,6 +112,63 @@ struct rt2x00debug_intf {
 	unsigned int offset_rf;
 };
 
+void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
+			    struct sk_buff *skb)
+{
+	struct rt2x00debug_intf *intf = rt2x00dev->debugfs_intf;
+	struct skb_desc *desc = get_skb_desc(skb);
+	struct sk_buff *skbcopy;
+	struct rt2x00dump_hdr *dump_hdr;
+	struct timeval timestamp;
+	unsigned int ring_index;
+	unsigned int entry_index;
+
+	do_gettimeofday(&timestamp);
+	ring_index = ARRAY_INDEX(desc->ring, rt2x00dev->rx);
+	entry_index = ARRAY_INDEX(desc->entry, desc->ring->entry);
+
+	if (!test_bit(FRAME_DUMP_FILE_OPEN, &intf->frame_dump_flags))
+		return;
+
+	if (skb_queue_len(&intf->frame_dump_skbqueue) > 20) {
+		DEBUG(rt2x00dev, "txrx dump queue length exceeded.\n");
+		return;
+	}
+
+	skbcopy = alloc_skb(sizeof(*dump_hdr) + desc->desc_len + desc->data_len,
+			    GFP_ATOMIC);
+	if (!skbcopy) {
+		DEBUG(rt2x00dev, "Failed to copy skb for dump.\n");
+		return;
+	}
+
+	dump_hdr = (struct rt2x00dump_hdr *)skb_put(skbcopy, sizeof(*dump_hdr));
+	dump_hdr->version = cpu_to_le32(DUMP_HEADER_VERSION);
+	dump_hdr->header_length = cpu_to_le32(sizeof(*dump_hdr));
+	dump_hdr->desc_length = cpu_to_le32(desc->desc_len);
+	dump_hdr->data_length = cpu_to_le32(desc->data_len);
+	dump_hdr->chip_rt = cpu_to_le16(rt2x00dev->chip.rt);
+	dump_hdr->chip_rf = cpu_to_le16(rt2x00dev->chip.rf);
+	dump_hdr->chip_rev = cpu_to_le32(rt2x00dev->chip.rev);
+	dump_hdr->type = cpu_to_le16(desc->frame_type);
+	dump_hdr->ring_index = ring_index;
+	dump_hdr->entry_index = entry_index;
+	dump_hdr->timestamp_sec = cpu_to_le32(timestamp.tv_sec);
+	dump_hdr->timestamp_usec = cpu_to_le32(timestamp.tv_usec);
+
+	memcpy(skb_put(skbcopy, desc->desc_len), desc->desc, desc->desc_len);
+	memcpy(skb_put(skbcopy, desc->data_len), desc->data, desc->data_len);
+
+	skb_queue_tail(&intf->frame_dump_skbqueue, skbcopy);
+	wake_up_interruptible(&intf->frame_dump_waitqueue);
+
+	/*
+	 * Verify that the file has not been closed while we were working.
+	 */
+	if (!test_bit(FRAME_DUMP_FILE_OPEN, &intf->frame_dump_flags))
+		skb_queue_purge(&intf->frame_dump_skbqueue);
+}
+
 static int rt2x00debug_file_open(struct inode *inode, struct file *file)
 {
 	struct rt2x00debug_intf *intf = inode->i_private;
@@ -111,6 +190,89 @@ static int rt2x00debug_file_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int rt2x00debug_open_ring_dump(struct inode *inode, struct file *file)
+{
+	struct rt2x00debug_intf *intf = inode->i_private;
+	int retval;
+
+	retval = rt2x00debug_file_open(inode, file);
+	if (retval)
+		return retval;
+
+	if (test_and_set_bit(FRAME_DUMP_FILE_OPEN, &intf->frame_dump_flags)) {
+		rt2x00debug_file_release(inode, file);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int rt2x00debug_release_ring_dump(struct inode *inode, struct file *file)
+{
+	struct rt2x00debug_intf *intf = inode->i_private;
+
+	skb_queue_purge(&intf->frame_dump_skbqueue);
+
+	clear_bit(FRAME_DUMP_FILE_OPEN, &intf->frame_dump_flags);
+
+	return rt2x00debug_file_release(inode, file);
+}
+
+static ssize_t rt2x00debug_read_ring_dump(struct file *file,
+					  char __user *buf,
+					  size_t length,
+					  loff_t *offset)
+{
+	struct rt2x00debug_intf *intf = file->private_data;
+	struct sk_buff *skb;
+	size_t status;
+	int retval;
+
+	if (file->f_flags & O_NONBLOCK)
+		return -EAGAIN;
+
+	retval =
+	    wait_event_interruptible(intf->frame_dump_waitqueue,
+				     (skb =
+				     skb_dequeue(&intf->frame_dump_skbqueue)));
+	if (retval)
+		return retval;
+
+	status = min((size_t)skb->len, length);
+	if (copy_to_user(buf, skb->data, status)) {
+		status = -EFAULT;
+		goto exit;
+	}
+
+	*offset += status;
+
+exit:
+	kfree_skb(skb);
+
+	return status;
+}
+
+static unsigned int rt2x00debug_poll_ring_dump(struct file *file,
+					       poll_table *wait)
+{
+	struct rt2x00debug_intf *intf = file->private_data;
+
+	poll_wait(file, &intf->frame_dump_waitqueue, wait);
+
+	if (!skb_queue_empty(&intf->frame_dump_skbqueue))
+		return POLLOUT | POLLWRNORM;
+
+	return 0;
+}
+
+static const struct file_operations rt2x00debug_fop_ring_dump = {
+	.owner		= THIS_MODULE,
+	.read		= rt2x00debug_read_ring_dump,
+	.poll		= rt2x00debug_poll_ring_dump,
+	.open		= rt2x00debug_open_ring_dump,
+	.release	= rt2x00debug_release_ring_dump,
+};
+
 #define RT2X00DEBUGFS_OPS_READ(__name, __format, __type)	\
 static ssize_t rt2x00debug_read_##__name(struct file *file,	\
 					 char __user *buf,	\
@@ -339,6 +501,20 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 
 #undef RT2X00DEBUGFS_CREATE_REGISTER_ENTRY
 
+	intf->frame_folder =
+	    debugfs_create_dir("frame", intf->driver_folder);
+	if (IS_ERR(intf->frame_folder))
+		goto exit;
+
+	intf->frame_dump_entry =
+	    debugfs_create_file("dump", S_IRUGO, intf->frame_folder,
+				intf, &rt2x00debug_fop_ring_dump);
+	if (IS_ERR(intf->frame_dump_entry))
+		goto exit;
+
+	skb_queue_head_init(&intf->frame_dump_skbqueue);
+	init_waitqueue_head(&intf->frame_dump_waitqueue);
+
 	return;
 
 exit:
@@ -350,11 +526,15 @@ exit:
 
 void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 {
-	const struct rt2x00debug_intf *intf = rt2x00dev->debugfs_intf;
+	struct rt2x00debug_intf *intf = rt2x00dev->debugfs_intf;
 
 	if (unlikely(!intf))
 		return;
 
+	skb_queue_purge(&intf->frame_dump_skbqueue);
+
+	debugfs_remove(intf->frame_dump_entry);
+	debugfs_remove(intf->frame_folder);
 	debugfs_remove(intf->rf_val_entry);
 	debugfs_remove(intf->rf_off_entry);
 	debugfs_remove(intf->bbp_val_entry);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 4f32ee8..48e2515 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -28,6 +28,7 @@
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
+#include "rt2x00dump.h"
 
 /*
  * Ring handler.
@@ -511,9 +512,11 @@ void rt2x00lib_txdone(struct data_entry *entry,
 	}
 
 	/*
-	 * Send the tx_status to mac80211,
-	 * that method also cleans up the skb structure.
+	 * Send the tx_status to mac80211 & debugfs.
+	 * mac80211 will clean up the skb structure.
 	 */
+	get_skb_desc(entry->skb)->frame_type = DUMP_FRAME_TXDONE;
+	rt2x00debug_dump_frame(rt2x00dev, entry->skb);
 	ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb, tx_status);
 	entry->skb = NULL;
 }
@@ -563,8 +566,10 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
 	/*
-	 * Send frame to mac80211
+	 * Send frame to mac80211 & debugfs
 	 */
+	get_skb_desc(skb)->frame_type = DUMP_FRAME_RXDONE;
+	rt2x00debug_dump_frame(rt2x00dev, skb);
 	ieee80211_rx_irqsafe(rt2x00dev->hw, skb, rx_status);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
@@ -715,6 +720,15 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 */
 	skbdesc->entry->skb = skb;
 	memcpy(&skbdesc->entry->tx_status.control, control, sizeof(*control));
+
+	/*
+	 * The frame has been completely initialized and ready
+	 * for sending to the device. The caller will push the
+	 * frame to the device, but we are going to push the
+	 * frame to debugfs here.
+	 */
+	skbdesc->frame_type = DUMP_FRAME_TX;
+	rt2x00debug_dump_frame(rt2x00dev, skb);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 7319411..0bf10ff 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -80,6 +80,7 @@ static inline void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev)
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 void rt2x00debug_register(struct rt2x00_dev *rt2x00dev);
 void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev);
+void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 #else
 static inline void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 {
@@ -88,6 +89,11 @@ static inline void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 static inline void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 {
 }
+
+static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
+					  struct skb_buff *skb)
+{
+}
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 9b11c6d..abeffdb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -166,8 +166,8 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		 * Fill in skb descriptor
 		 */
 		skbdesc = get_skb_desc(skb);
-		skbdesc->desc_len = desc.size;
-		skbdesc->data_len = entry->ring->desc_size;
+		skbdesc->desc_len = entry->ring->desc_size;
+		skbdesc->data_len = skb->len;
 		skbdesc->desc = entry->priv;
 		skbdesc->data = skb->data;
 		skbdesc->ring = ring;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index f1282c6..82e95b9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -287,9 +287,9 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_desc(entry->skb);
-	skbdesc->desc_len = desc.size;
-	skbdesc->data_len = entry->ring->desc_size;
-	skbdesc->desc = entry->skb->data + desc.size;
+	skbdesc->desc_len = entry->ring->desc_size;
+	skbdesc->data_len = entry->skb->len;
+	skbdesc->desc = entry->skb->data - skbdesc->desc_len;
 	skbdesc->data = entry->skb->data;
 	skbdesc->ring = ring;
 	skbdesc->entry = entry;
-- 
1.5.3.6

