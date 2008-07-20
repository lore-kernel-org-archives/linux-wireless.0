Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:47716 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbYGTCsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 22:48:08 -0400
Date: Sat, 19 Jul 2008 22:48:02 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] [PATCH 4/4] list.h: add list_cut_position()
Message-ID: <20080720024802.GU17936@ruslug.rutgers.edu> (sfid-20080720_044811_689118_D2361999)
References: <20080720024341.GQ17936@ruslug.rutgers.edu> <20080720024500.GR17936@ruslug.rutgers.edu> <20080720024554.GS17936@ruslug.rutgers.edu> <20080720024709.GT17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080720024709.GT17936@ruslug.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds list_cut_position() which lets you cut a list into
two lists given a pivot in in the list.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   35 -----------------------------------
 include/linux/list.h              |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 807dcdf..65f8c50 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -49,41 +49,6 @@ struct ath_node;
 /* Utility macros */
 /******************/
 
-/* An attempt will be made to merge these link list helpers upstream
- * instead */
-
-static inline void __list_cut_position(struct list_head *list,
-		struct list_head *head, struct list_head *entry)
-{
-	struct list_head *new_first =
-		(entry->next != head) ? entry->next : head;
-	list->next = head->next;
-	list->next->prev = list;
-	list->prev = entry;
-	entry->next = list;
-	head->next = new_first;
-	new_first->prev = head;
-}
-
-/**
- * list_cut_position - cut a list into two
- * @list: a new list to add all removed entries
- * @head: a list with entries
- * @entry: an entry within head, could be the head itself
- *	and if so we won't won't cut the list
- */
-static inline void list_cut_position(struct list_head *list,
-		struct list_head *head, struct list_head *entry)
-{
-	BUG_ON(list_empty(head));
-	if (list_is_singular(head))
-		BUG_ON(head->next != entry && head != entry);
-	if (entry == head)
-		INIT_LIST_HEAD(list);
-	else
-		__list_cut_position(list, head, entry);
-}
-
 /* Macro to expand scalars to 64-bit objects */
 
 #define	ito64(x) (sizeof(x) == 8) ? \
diff --git a/include/linux/list.h b/include/linux/list.h
index fc7b700..8766d33 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -326,6 +326,38 @@ static inline int list_is_singular(const struct list_head *head)
 	return !list_empty(head) && (head->next == head->prev);
 }
 
+static inline void __list_cut_position(struct list_head *list,
+		struct list_head *head, struct list_head *entry)
+{
+	struct list_head *new_first =
+		(entry->next != head) ? entry->next : head;
+	list->next = head->next;
+	list->next->prev = list;
+	list->prev = entry;
+	entry->next = list;
+	head->next = new_first;
+	new_first->prev = head;
+}
+
+/**
+ * list_cut_position - cut a list into two
+ * @list: a new list to add all removed entries
+ * @head: a list with entries
+ * @entry: an entry within head, could be the head itself
+ *	and if so we won't won't cut the list
+ */
+static inline void list_cut_position(struct list_head *list,
+		struct list_head *head, struct list_head *entry)
+{
+	BUG_ON(list_empty(head));
+	if (list_is_singular(head))
+		BUG_ON(head->next != entry && head != entry);
+	if (entry == head)
+		INIT_LIST_HEAD(list);
+	else
+		__list_cut_position(list, head, entry);
+}
+
 static inline void __list_splice(const struct list_head *list,
 				 struct list_head *head)
 {
-- 
1.5.4.3

