Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:39143 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYG0Mri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 08:47:38 -0400
Received: by ik-out-1112.google.com with SMTP id c28so3595922ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 05:47:36 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/3] rt2x00: Fix access permissions on debugfs files
Date: Sun, 27 Jul 2008 15:06:05 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807271505.38116.IvDoorn@gmail.com>
In-Reply-To: <200807271505.38116.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807271506.05316.IvDoorn@gmail.com> (sfid-20080727_144747_827008_520B2A2D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although most rt2x00 debugfs files don't contain
information which could compromise network security,
it is better to set the access permissions to root only.

This will be required when HW crypto is implemented,
because it could be possible to read the HW key from
the registers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 300cf06..6bee1d6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -372,9 +372,6 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,	\
 	if (*offset)						\
 		return 0;					\
 								\
-	if (!capable(CAP_NET_ADMIN))				\
-		return -EPERM;					\
-								\
 	if (intf->offset_##__name >= debug->__name.word_count)	\
 		return -EINVAL;					\
 								\
@@ -454,7 +451,7 @@ static struct dentry *rt2x00debug_create_file_driver(const char *name,
 	data += sprintf(data, "compiled: %s %s\n", __DATE__, __TIME__);
 	blob->size = strlen(blob->data);
 
-	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
+	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
 }
 
 static struct dentry *rt2x00debug_create_file_chipset(const char *name,
@@ -482,7 +479,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	data += sprintf(data, "rf length: %d\n", debug->rf.word_count);
 	blob->size = strlen(blob->data);
 
-	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
+	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
 }
 
 void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
@@ -517,7 +514,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->chipset_entry))
 		goto exit;
 
-	intf->dev_flags = debugfs_create_file("dev_flags", S_IRUGO,
+	intf->dev_flags = debugfs_create_file("dev_flags", S_IRUSR,
 					      intf->driver_folder, intf,
 					      &rt2x00debug_fop_dev_flags);
 	if (IS_ERR(intf->dev_flags))
@@ -532,7 +529,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 ({								\
 	(__intf)->__name##_off_entry =				\
 	    debugfs_create_u32(__stringify(__name) "_offset",	\
-			       S_IRUGO | S_IWUSR,		\
+			       S_IRUSR | S_IWUSR,		\
 			       (__intf)->register_folder,	\
 			       &(__intf)->offset_##__name);	\
 	if (IS_ERR((__intf)->__name##_off_entry))		\
@@ -540,7 +537,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 								\
 	(__intf)->__name##_val_entry =				\
 	    debugfs_create_file(__stringify(__name) "_value",	\
-				S_IRUGO | S_IWUSR,		\
+				S_IRUSR | S_IWUSR,		\
 				(__intf)->register_folder,	\
 				(__intf), &rt2x00debug_fop_##__name);\
 	if (IS_ERR((__intf)->__name##_val_entry))		\
@@ -560,7 +557,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 		goto exit;
 
 	intf->queue_frame_dump_entry =
-	    debugfs_create_file("dump", S_IRUGO, intf->queue_folder,
+	    debugfs_create_file("dump", S_IRUSR, intf->queue_folder,
 				intf, &rt2x00debug_fop_queue_dump);
 	if (IS_ERR(intf->queue_frame_dump_entry))
 		goto exit;
@@ -569,7 +566,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	init_waitqueue_head(&intf->frame_dump_waitqueue);
 
 	intf->queue_stats_entry =
-	    debugfs_create_file("queue", S_IRUGO, intf->queue_folder,
+	    debugfs_create_file("queue", S_IRUSR, intf->queue_folder,
 				intf, &rt2x00debug_fop_queue_stats);
 
 	return;
-- 
1.5.6.1

