Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40008 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0IOVVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 17:21:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: backport list_for_each_entry_continue_rcu
Date: Wed, 15 Sep 2010 22:42:33 +0200
Message-Id: <1284583353-11456-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284583353-11456-1-git-send-email-hauke@hauke-m.de>
References: <1284583353-11456-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed for new driver carl9170.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.31.h |   11 +++++++++++
 include/linux/compat-2.6.33.h |   14 ++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index 54ddefd..6c454cb 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -191,6 +191,17 @@ void compat_synchronize_threaded_irq(struct compat_threaded_irq *comp)
 	cancel_work_sync(&comp->work);
 }
 
+/**
+ * list_entry_rcu - get the struct for this entry
+ * @ptr:        the &struct list_head pointer.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_struct within the struct.
+ *
+ * This primitive may safely run concurrently with the _rcu list-mutation
+ * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
+ */
+#define list_entry_rcu(ptr, type, member) \
+	container_of(rcu_dereference(ptr), type, member)
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
 
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index e4dff72..e7e20d9 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -98,6 +98,20 @@ int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
 #define kfifo_out(a, b, c) __kfifo_get(*a, b, c)
 #define kfifo_len(a) __kfifo_len(*a)
 
+/**
+ * list_for_each_entry_continue_rcu - continue iteration over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Continue to iterate over list of given type, continuing after
+ * the current position.
+ */
+#define list_for_each_entry_continue_rcu(pos, head, member) 		\
+	for (pos = list_entry_rcu(pos->member.next, typeof(*pos), member); \
+	     prefetch(pos->member.next), &pos->member != (head);	\
+	     pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
 
 #endif /* LINUX_26_33_COMPAT_H */
-- 
1.7.0.4

