Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46957 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab0FXU7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 16:59:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport skb_queue_splice_init
Date: Thu, 24 Jun 2010 22:59:23 +0200
Message-Id: <1277413163-6718-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by iwmc3200wifi.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.28.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 2cab320..7160548 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -147,6 +147,23 @@ static inline void skb_queue_splice(const struct sk_buff_head *list,
 }
 
 /**
+ *	skb_queue_splice - join two skb lists and reinitialise the emptied list
+ *	@list: the new list to add
+ *	@head: the place to add it in the first list
+ *
+ *	The list at @list is reinitialised
+ */
+static inline void skb_queue_splice_init(struct sk_buff_head *list,
+					 struct sk_buff_head *head)
+{
+	if (!skb_queue_empty(list)) {
+		__skb_queue_splice(list, (struct sk_buff *) head, head->next);
+		head->qlen += list->qlen;
+		__skb_queue_head_init(list);
+	}
+}
+
+/**
  *	skb_queue_splice_tail - join two skb lists and reinitialise the emptied list
  *	@list: the new list to add
  *	@head: the place to add it in the first list
-- 
1.7.0.4

