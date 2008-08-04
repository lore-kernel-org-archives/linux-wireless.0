Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47245 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYHDXNX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 19:13:23 -0400
Date: Mon, 4 Aug 2008 16:13:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 2/4] list.h: add list_cut_position()
Message-ID: <20080804231320.GG6447@tesla> (sfid-20080805_011327_749035_015E4A6C)
References: <1217890089-12100-1-git-send-email-lrodriguez@atheros.com> <20080804160011.ec964f1f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20080804160011.ec964f1f.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 04, 2008 at 04:00:11PM -0700, Randy Dunlap wrote:
> On Mon, 4 Aug 2008 15:48:09 -0700 Luis R. Rodriguez wrote:
> 
> > This adds list_cut_position() which lets you cut a list into
> > two lists given a pivot in the list.
> >
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  include/linux/list.h |   32 ++++++++++++++++++++++++++++++++
> >  1 files changed, 32 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/list.h b/include/linux/list.h
> > index 594f67c..2999b0f 100644
> > --- a/include/linux/list.h
> > +++ b/include/linux/list.h
> > @@ -214,6 +214,38 @@ static inline int list_is_singular(const struct list_head *head)
> >       return !list_empty(head) && (head->next == head->prev);
> >  }
> >
> > +static inline void __list_cut_position(struct list_head *list,
> > +             struct list_head *head, struct list_head *entry)
> > +{
> > +     struct list_head *new_first =
> > +             (entry->next != head) ? entry->next : head;
> > +     list->next = head->next;
> > +     list->next->prev = list;
> > +     list->prev = entry;
> > +     entry->next = list;
> > +     head->next = new_first;
> > +     new_first->prev = head;
> > +}
> > +
> > +/**
> > + * list_cut_position - cut a list into two
> > + * @list: a new list to add all removed entries
> > + * @head: a list with entries
> > + * @entry: an entry within head, could be the head itself
> > + *   and if so we won't won't cut the list
> 
> drop one "won't"

Thanks.

---
 include/linux/list.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 594f67c..2999b0f 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -214,6 +214,38 @@ static inline int list_is_singular(const struct list_head *head)
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
+ *	and if so we won't cut the list
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
1.5.6.rc2.15.g457bb.dirty

