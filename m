Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51889 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0JGVWf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 17:22:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: backport some more kfifo stuff
Date: Thu,  7 Oct 2010 23:22:23 +0200
Message-Id: <1286486544-18975-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.33.h |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index e7e20d9..6a7cd3e 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -94,11 +94,44 @@ int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
 /* Backport for kfifo
  * kfifo_alloc and kfifo_free must be backported manually 
  */
-#define kfifo_in(a, b, c) __kfifo_put(*a, b, c)
-#define kfifo_out(a, b, c) __kfifo_get(*a, b, c)
+#define kfifo_in(a, b, c) __kfifo_put(*a, (unsigned char *)b, c)
+#define kfifo_out(a, b, c) __kfifo_get(*a, (unsigned char *)b, c)
 #define kfifo_len(a) __kfifo_len(*a)
 
 /**
+ * kfifo_is_empty - returns true if the fifo is empty
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check int kfifo_is_empty(struct kfifo **fifo)
+{
+	return (*fifo)->in == (*fifo)->out;
+}
+
+/**
+ * kfifo_size - returns the size of the fifo in bytes
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check unsigned int kfifo_size(struct kfifo *fifo)
+{
+	return fifo->size;
+}
+
+/**
+ * kfifo_is_full - returns true if the fifo is full
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check int kfifo_is_full(struct kfifo **fifo)
+{
+	return kfifo_len(fifo) == kfifo_size(*fifo);
+}
+
+static inline void compat_kfifo_free(struct kfifo **fifo) {
+	if (*fifo)
+		kfifo_free(*fifo);
+}
+#define kfifo_free compat_kfifo_free
+
+/**
  * list_for_each_entry_continue_rcu - continue iteration over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
-- 
1.7.0.4

