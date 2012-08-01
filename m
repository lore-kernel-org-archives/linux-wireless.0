Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43323 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab2HAXFn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 19:05:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: add seq_hlist_next and seq_hlist_start_head
Date: Thu,  2 Aug 2012 01:05:22 +0200
Message-Id: <1343862324-26057-1-git-send-email-hauke@hauke-m.de> (sfid-20120802_010545_756490_94FCA696)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions are copied from the kernel and are needed by
net/bluetooth/af_bluetooth.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.34.c        |   55 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.34.h |    6 +++++
 2 files changed, 61 insertions(+)

diff --git a/compat/compat-2.6.34.c b/compat/compat-2.6.34.c
index b905a26..80a6107 100644
--- a/compat/compat-2.6.34.c
+++ b/compat/compat-2.6.34.c
@@ -28,3 +28,58 @@ int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags)
 {
 	return -EINVAL;
 }
+
+/**
+ * seq_hlist_start - start an iteration of a hlist
+ * @head: the head of the hlist
+ * @pos:  the start position of the sequence
+ *
+ * Called at seq_file->op->start().
+ */
+struct hlist_node *seq_hlist_start(struct hlist_head *head, loff_t pos)
+{
+	struct hlist_node *node;
+
+	hlist_for_each(node, head)
+		if (pos-- == 0)
+			return node;
+	return NULL;
+}
+
+/**
+ * seq_hlist_start_head - start an iteration of a hlist
+ * @head: the head of the hlist
+ * @pos:  the start position of the sequence
+ *
+ * Called at seq_file->op->start(). Call this function if you want to
+ * print a header at the top of the output.
+ */
+struct hlist_node *seq_hlist_start_head(struct hlist_head *head, loff_t pos)
+{
+	if (!pos)
+		return SEQ_START_TOKEN;
+
+	return seq_hlist_start(head, pos - 1);
+}
+EXPORT_SYMBOL(seq_hlist_start_head);
+
+/**
+ * seq_hlist_next - move to the next position of the hlist
+ * @v:    the current iterator
+ * @head: the head of the hlist
+ * @ppos: the current position
+ *
+ * Called at seq_file->op->next().
+ */
+struct hlist_node *seq_hlist_next(void *v, struct hlist_head *head,
+				  loff_t *ppos)
+{
+	struct hlist_node *node = v;
+
+	++*ppos;
+	if (v == SEQ_START_TOKEN)
+		return head->first;
+	else
+		return node->next;
+}
+EXPORT_SYMBOL(seq_hlist_next);
diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index b5a40e2..39bc13b 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -319,6 +319,12 @@ static inline int lockdep_rtnl_is_held(void)
 }
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 
+extern struct hlist_node *seq_hlist_start_head(struct hlist_head *head,
+					       loff_t pos);
+
+extern struct hlist_node *seq_hlist_next(void *v, struct hlist_head *head,
+					 loff_t *ppos);
+
 #else /* Kernels >= 2.6.34 */
 
 static inline void init_compat_mmc_pm_flags(void)
-- 
1.7.9.5

