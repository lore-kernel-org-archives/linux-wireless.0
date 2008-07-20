Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:47709 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbYGTCrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 22:47:15 -0400
Date: Sat, 19 Jul 2008 22:47:09 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 3/4] list.h: Add list_splice_tail() and list_splice_tail_init()
Message-ID: <20080720024709.GT17936@ruslug.rutgers.edu> (sfid-20080720_044717_115541_E18E3E84)
References: <20080720024341.GQ17936@ruslug.rutgers.edu> <20080720024500.GR17936@ruslug.rutgers.edu> <20080720024554.GS17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080720024554.GS17936@ruslug.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you are using linked lists for queus list_splice() will not do what
you would expect even if you use the elements passed reversed. We need
to handle these differently. We add list_splice_tail() and
list_splice_tail_init()

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   42 ----------------------------------
 include/linux/list.h              |   45 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 1499f6e..807dcdf 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -52,19 +52,6 @@ struct ath_node;
 /* An attempt will be made to merge these link list helpers upstream
  * instead */
 
-static inline void __list_splice_tail(const struct list_head *list,
-				 struct list_head *head)
-{
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *current_tail = head->prev;
-
-	current_tail->next = first;
-	last->next = head;
-	head->prev = last;
-	first->prev = current_tail;
-}
-
 static inline void __list_cut_position(struct list_head *list,
 		struct list_head *head, struct list_head *entry)
 {
@@ -79,35 +66,6 @@ static inline void __list_cut_position(struct list_head *list,
 }
 
 /**
- * list_splice_tail - join two lists, each list being a queue
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- */
-static inline void list_splice_tail(const struct list_head *list,
-				struct list_head *head)
-{
-	if (!list_empty(list))
-		__list_splice_tail(list, head);
-}
-
-/**
- * list_splice_tail_init - join two lists, each list being a queue, and
- * 	reinitialise the emptied list.
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- *
- * The list at @list is reinitialised
- */
-static inline void list_splice_tail_init(struct list_head *list,
-				    struct list_head *head)
-{
-	if (!list_empty(list)) {
-		__list_splice_tail(list, head);
-		INIT_LIST_HEAD(list);
-	}
-}
-
-/**
  * list_cut_position - cut a list into two
  * @list: a new list to add all removed entries
  * @head: a list with entries
diff --git a/include/linux/list.h b/include/linux/list.h
index 08cf4f6..fc7b700 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -341,7 +341,7 @@ static inline void __list_splice(const struct list_head *list,
 }
 
 /**
- * list_splice - join two lists
+ * list_splice - join two lists, this is designed for stacks
  * @list: the new list to add.
  * @head: the place to add it in the first list.
  */
@@ -368,6 +368,49 @@ static inline void list_splice_init(struct list_head *list,
 	}
 }
 
+static inline void __list_splice_tail(const struct list_head *list,
+				 struct list_head *head)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *current_tail = head->prev;
+
+	current_tail->next = first;
+	last->next = head;
+	head->prev = last;
+	first->prev = current_tail;
+}
+
+/**
+ * list_splice_tail - join two lists, each list being a queue
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice_tail(const struct list_head *list,
+				struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice_tail(list, head);
+}
+
+/**
+ * list_splice_tail_init - join two lists, each list being a queue, and
+ * 	reinitialise the emptied list.
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_tail_init(struct list_head *list,
+				    struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice_tail(list, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+
 /**
  * list_splice_init_rcu - splice an RCU-protected list into an existing list.
  * @list:	the RCU-protected list to splice
-- 
1.5.4.3

