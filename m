Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58887 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab2BFGXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 01:23:37 -0500
Subject: [PATCH 1/2] ath6kl: store firmware logs in skbuffs
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Mon, 06 Feb 2012 08:23:27 +0200
Message-ID: <20120206062327.20231.11602.stgit@localhost6.localdomain6> (sfid-20120206_072341_079539_4E2EAE91)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently firmware logs are stored in a circular buffer, but this was
not very flexible and fragile. It's a lot easier to store logs to struct
skbuffs and store them in a skb queue. Also this makes it possible
to easily increase the buffer size, even dynamically if we so want (but
that's not yet supported).

>From user space point of view nothing should change.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    5 +
 drivers/net/wireless/ath/ath6kl/debug.c |  121 ++++++++++---------------------
 2 files changed, 41 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c4d66e0..9a58214 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -652,10 +652,9 @@ struct ath6kl {
 
 #ifdef CONFIG_ATH6KL_DEBUG
 	struct {
-		struct circ_buf fwlog_buf;
-		spinlock_t fwlog_lock;
-		void *fwlog_tmp;
+		struct sk_buff_head fwlog_queue;
 		u32 fwlog_mask;
+
 		unsigned int dbgfs_diag_reg;
 		u32 diag_reg_addr_wr;
 		u32 diag_reg_val_wr;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 6b546dc..9b25cbd 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -16,7 +16,7 @@
 
 #include "core.h"
 
-#include <linux/circ_buf.h>
+#include <linux/skbuff.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/export.h>
@@ -32,9 +32,8 @@ struct ath6kl_fwlog_slot {
 	u8 payload[0];
 };
 
-#define ATH6KL_FWLOG_SIZE 32768
-#define ATH6KL_FWLOG_SLOT_SIZE (sizeof(struct ath6kl_fwlog_slot) + \
-				ATH6KL_FWLOG_PAYLOAD_SIZE)
+#define ATH6KL_FWLOG_MAX_ENTRIES 20
+
 #define ATH6KL_FWLOG_VALID_MASK 0x1ffff
 
 int ath6kl_printk(const char *level, const char *fmt, ...)
@@ -268,105 +267,77 @@ static const struct file_operations fops_war_stats = {
 	.llseek = default_llseek,
 };
 
-static void ath6kl_debug_fwlog_add(struct ath6kl *ar, const void *buf,
-				   size_t buf_len)
-{
-	struct circ_buf *fwlog = &ar->debug.fwlog_buf;
-	size_t space;
-	int i;
-
-	/* entries must all be equal size */
-	if (WARN_ON(buf_len != ATH6KL_FWLOG_SLOT_SIZE))
-		return;
-
-	space = CIRC_SPACE(fwlog->head, fwlog->tail, ATH6KL_FWLOG_SIZE);
-	if (space < buf_len)
-		/* discard oldest slot */
-		fwlog->tail = (fwlog->tail + ATH6KL_FWLOG_SLOT_SIZE) &
-			(ATH6KL_FWLOG_SIZE - 1);
-
-	for (i = 0; i < buf_len; i += space) {
-		space = CIRC_SPACE_TO_END(fwlog->head, fwlog->tail,
-					  ATH6KL_FWLOG_SIZE);
-
-		if ((size_t) space > buf_len - i)
-			space = buf_len - i;
-
-		memcpy(&fwlog->buf[fwlog->head], buf, space);
-		fwlog->head = (fwlog->head + space) & (ATH6KL_FWLOG_SIZE - 1);
-	}
-
-}
-
 void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len)
 {
-	struct ath6kl_fwlog_slot *slot = ar->debug.fwlog_tmp;
+	struct ath6kl_fwlog_slot *slot;
+	struct sk_buff *skb;
 	size_t slot_len;
 
 	if (WARN_ON(len > ATH6KL_FWLOG_PAYLOAD_SIZE))
 		return;
 
-	spin_lock_bh(&ar->debug.fwlog_lock);
+	slot_len = sizeof(*slot) + len;
 
+	skb = alloc_skb(slot_len, GFP_KERNEL);
+	if (!skb)
+		return;
+
+	slot = (struct ath6kl_fwlog_slot *) skb_put(skb, slot_len);
 	slot->timestamp = cpu_to_le32(jiffies);
 	slot->length = cpu_to_le32(len);
 	memcpy(slot->payload, buf, len);
 
-	slot_len = sizeof(*slot) + len;
+	spin_lock(&ar->debug.fwlog_queue.lock);
 
-	if (slot_len < ATH6KL_FWLOG_SLOT_SIZE)
-		memset(slot->payload + len, 0,
-		       ATH6KL_FWLOG_SLOT_SIZE - slot_len);
+	__skb_queue_tail(&ar->debug.fwlog_queue, skb);
 
-	ath6kl_debug_fwlog_add(ar, slot, ATH6KL_FWLOG_SLOT_SIZE);
+	/* drop oldest entries */
+	while (skb_queue_len(&ar->debug.fwlog_queue) >
+	       ATH6KL_FWLOG_MAX_ENTRIES) {
+		skb = __skb_dequeue(&ar->debug.fwlog_queue);
+		kfree_skb(skb);
+	}
 
-	spin_unlock_bh(&ar->debug.fwlog_lock);
-}
+	spin_unlock(&ar->debug.fwlog_queue.lock);
 
-static bool ath6kl_debug_fwlog_empty(struct ath6kl *ar)
-{
-	return CIRC_CNT(ar->debug.fwlog_buf.head,
-			ar->debug.fwlog_buf.tail,
-			ATH6KL_FWLOG_SLOT_SIZE) == 0;
+	return;
 }
 
 static ssize_t ath6kl_fwlog_read(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
 	struct ath6kl *ar = file->private_data;
-	struct circ_buf *fwlog = &ar->debug.fwlog_buf;
-	size_t len = 0, buf_len = count;
+	struct sk_buff *skb;
 	ssize_t ret_cnt;
+	size_t len = 0;
 	char *buf;
-	int ccnt;
 
-	buf = vmalloc(buf_len);
+	buf = vmalloc(count);
 	if (!buf)
 		return -ENOMEM;
 
 	/* read undelivered logs from firmware */
 	ath6kl_read_fwlogs(ar);
 
-	spin_lock_bh(&ar->debug.fwlog_lock);
+	spin_lock(&ar->debug.fwlog_queue.lock);
 
-	while (len < buf_len && !ath6kl_debug_fwlog_empty(ar)) {
-		ccnt = CIRC_CNT_TO_END(fwlog->head, fwlog->tail,
-				       ATH6KL_FWLOG_SIZE);
+	while ((skb = __skb_dequeue(&ar->debug.fwlog_queue))) {
+		if (skb->len > count - len) {
+			/* not enough space, put skb back and leave */
+			__skb_queue_head(&ar->debug.fwlog_queue, skb);
+			break;
+		}
 
-		if ((size_t) ccnt > buf_len - len)
-			ccnt = buf_len - len;
 
-		memcpy(buf + len, &fwlog->buf[fwlog->tail], ccnt);
-		len += ccnt;
+		memcpy(buf + len, skb->data, skb->len);
+		len += skb->len;
 
-		fwlog->tail = (fwlog->tail + ccnt) &
-			(ATH6KL_FWLOG_SIZE - 1);
+		kfree_skb(skb);
 	}
 
-	spin_unlock_bh(&ar->debug.fwlog_lock);
+	spin_unlock(&ar->debug.fwlog_queue.lock);
 
-	if (WARN_ON(len > buf_len))
-		len = buf_len;
+	/* FIXME: what to do if len == 0? */
 
 	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 
@@ -1649,17 +1620,7 @@ static const struct file_operations fops_power_params = {
 
 int ath6kl_debug_init(struct ath6kl *ar)
 {
-	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
-	if (ar->debug.fwlog_buf.buf == NULL)
-		return -ENOMEM;
-
-	ar->debug.fwlog_tmp = kmalloc(ATH6KL_FWLOG_SLOT_SIZE, GFP_KERNEL);
-	if (ar->debug.fwlog_tmp == NULL) {
-		vfree(ar->debug.fwlog_buf.buf);
-		return -ENOMEM;
-	}
-
-	spin_lock_init(&ar->debug.fwlog_lock);
+	skb_queue_head_init(&ar->debug.fwlog_queue);
 
 	/*
 	 * Actually we are lying here but don't know how to read the mask
@@ -1669,11 +1630,8 @@ int ath6kl_debug_init(struct ath6kl *ar)
 
 	ar->debugfs_phy = debugfs_create_dir("ath6kl",
 					     ar->wiphy->debugfsdir);
-	if (!ar->debugfs_phy) {
-		vfree(ar->debug.fwlog_buf.buf);
-		kfree(ar->debug.fwlog_tmp);
+	if (!ar->debugfs_phy)
 		return -ENOMEM;
-	}
 
 	debugfs_create_file("tgt_stats", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_tgt_stats);
@@ -1740,8 +1698,7 @@ int ath6kl_debug_init(struct ath6kl *ar)
 
 void ath6kl_debug_cleanup(struct ath6kl *ar)
 {
-	vfree(ar->debug.fwlog_buf.buf);
-	kfree(ar->debug.fwlog_tmp);
+	skb_queue_purge(&ar->debug.fwlog_queue);
 	kfree(ar->debug.roam_tbl);
 }
 

