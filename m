Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:38996 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYBJVxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:48 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4239380fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:48 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 08/14] rt2x00: Add queue statistics to debugfs
Date: Sun, 10 Feb 2008 22:50:28 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102250.28268.IvDoorn@gmail.com> (sfid-20080210_215352_192910_24EDA6F1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename "frame" folder to "queue" folder,
add extra file to this folder which contains
statistics about all hardware queues. This will
help debugging and spotting problems in the
queue indexing system.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   90 ++++++++++++++++++++++++-----
 1 files changed, 76 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 4e048ac..21af11a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -33,7 +33,7 @@
 #include "rt2x00lib.h"
 #include "rt2x00dump.h"
 
-#define PRINT_LINE_LEN_MAX 32
+#define MAX_LINE_LENGTH 64
 
 struct rt2x00debug_intf {
 	/*
@@ -60,8 +60,9 @@ struct rt2x00debug_intf {
 	 *     - eeprom offset/value files
 	 *     - bbp offset/value files
 	 *     - rf offset/value files
-	 *   - frame dump folder
+	 *   - queue folder
 	 *     - frame dump file
+	 *     - queue stats file
 	 */
 	struct dentry *driver_folder;
 	struct dentry *driver_entry;
@@ -76,8 +77,9 @@ struct rt2x00debug_intf {
 	struct dentry *bbp_val_entry;
 	struct dentry *rf_off_entry;
 	struct dentry *rf_val_entry;
-	struct dentry *frame_folder;
-	struct dentry *frame_dump_entry;
+	struct dentry *queue_folder;
+	struct dentry *queue_frame_dump_entry;
+	struct dentry *queue_stats_entry;
 
 	/*
 	 * The frame dump file only allows a single reader,
@@ -269,6 +271,61 @@ static const struct file_operations rt2x00debug_fop_queue_dump = {
 	.release	= rt2x00debug_release_queue_dump,
 };
 
+static ssize_t rt2x00debug_read_queue_stats(struct file *file,
+					    char __user *buf,
+					    size_t length,
+					    loff_t *offset)
+{
+	struct rt2x00debug_intf *intf = file->private_data;
+	struct data_queue *queue;
+	unsigned int lines = 1 + intf->rt2x00dev->data_queues;
+	size_t size;
+	char *data;
+	char *temp;
+
+	if (*offset)
+		return 0;
+
+	data = kzalloc(lines * MAX_LINE_LENGTH, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	temp = data +
+	    sprintf(data, "qid\tcount\tlimit\tlength\tindex\tdone\tcrypto\n");
+
+	queue_for_each(intf->rt2x00dev, queue) {
+		spin_lock(&queue->lock);
+
+		temp += sprintf(temp, "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", queue->qid,
+				queue->count, queue->limit, queue->length,
+				queue->index[Q_INDEX],
+				queue->index[Q_INDEX_DONE],
+				queue->index[Q_INDEX_CRYPTO]);
+
+		spin_unlock(&queue->lock);
+	}
+
+	size = strlen(data);
+	size = min(size, length);
+
+	if (copy_to_user(buf, data, size)) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	kfree(data);
+
+	*offset += size;
+	return size;
+}
+
+static const struct file_operations rt2x00debug_fop_queue_stats = {
+	.owner		= THIS_MODULE,
+	.read		= rt2x00debug_read_queue_stats,
+	.open		= rt2x00debug_file_open,
+	.release	= rt2x00debug_file_release,
+};
+
 #define RT2X00DEBUGFS_OPS_READ(__name, __format, __type)	\
 static ssize_t rt2x00debug_read_##__name(struct file *file,	\
 					 char __user *buf,	\
@@ -386,7 +443,7 @@ static struct dentry *rt2x00debug_create_file_driver(const char *name,
 {
 	char *data;
 
-	data = kzalloc(3 * PRINT_LINE_LEN_MAX, GFP_KERNEL);
+	data = kzalloc(3 * MAX_LINE_LENGTH, GFP_KERNEL);
 	if (!data)
 		return NULL;
 
@@ -409,7 +466,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	const struct rt2x00debug *debug = intf->debug;
 	char *data;
 
-	data = kzalloc(8 * PRINT_LINE_LEN_MAX, GFP_KERNEL);
+	data = kzalloc(8 * MAX_LINE_LENGTH, GFP_KERNEL);
 	if (!data)
 		return NULL;
 
@@ -496,20 +553,24 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 
 #undef RT2X00DEBUGFS_CREATE_REGISTER_ENTRY
 
-	intf->frame_folder =
-	    debugfs_create_dir("frame", intf->driver_folder);
-	if (IS_ERR(intf->frame_folder))
+	intf->queue_folder =
+	    debugfs_create_dir("queue", intf->driver_folder);
+	if (IS_ERR(intf->queue_folder))
 		goto exit;
 
-	intf->frame_dump_entry =
-	    debugfs_create_file("dump", S_IRUGO, intf->frame_folder,
+	intf->queue_frame_dump_entry =
+	    debugfs_create_file("dump", S_IRUGO, intf->queue_folder,
 				intf, &rt2x00debug_fop_queue_dump);
-	if (IS_ERR(intf->frame_dump_entry))
+	if (IS_ERR(intf->queue_frame_dump_entry))
 		goto exit;
 
 	skb_queue_head_init(&intf->frame_dump_skbqueue);
 	init_waitqueue_head(&intf->frame_dump_waitqueue);
 
+	intf->queue_stats_entry =
+	    debugfs_create_file("queue", S_IRUGO, intf->queue_folder,
+				intf, &rt2x00debug_fop_queue_stats);
+
 	return;
 
 exit:
@@ -528,8 +589,9 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 
 	skb_queue_purge(&intf->frame_dump_skbqueue);
 
-	debugfs_remove(intf->frame_dump_entry);
-	debugfs_remove(intf->frame_folder);
+	debugfs_remove(intf->queue_stats_entry);
+	debugfs_remove(intf->queue_frame_dump_entry);
+	debugfs_remove(intf->queue_folder);
 	debugfs_remove(intf->rf_val_entry);
 	debugfs_remove(intf->rf_off_entry);
 	debugfs_remove(intf->bbp_val_entry);
-- 
1.5.4

