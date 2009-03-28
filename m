Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46491 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbZC1Q10 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 12:27:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] Backport skb_queue_splice_tail_init to kernel 2.6.27.
Date: Sat, 28 Mar 2009 17:27:17 +0100
Message-Id: <1238257637-15226-1-git-send-email-hauke@hauke-m.de> (sfid-20090328_172729_887247_CBEC96A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |    4 ++--
 compat/compat.h    |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 config.mk          |    1 -
 3 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 1b6bc12..f0ea11f 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -357,7 +357,7 @@ index a0c860f..9c6f214 100644
  
  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
  	if (net_ratelimit())
-@@ -797,6 +799,7 @@
+@@ -796,6 +798,7 @@
  }
  EXPORT_SYMBOL(ieee80211_alloc_hw);
  
@@ -365,7 +365,7 @@ index a0c860f..9c6f214 100644
  static const struct net_device_ops ieee80211_master_ops = {
  	.ndo_start_xmit = ieee80211_master_start_xmit,
  	.ndo_open = ieee80211_master_open,
-@@ -804,12 +807,22 @@
+@@ -803,12 +806,22 @@
  	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
  	.ndo_select_queue = ieee80211_select_queue,
  };
diff --git a/compat/compat.h b/compat/compat.h
index 7e4b9b1..855a02c 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -28,6 +28,55 @@
 
 void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 
+
+/**
+ *	__skb_queue_head_init - initialize non-spinlock portions of sk_buff_head
+ *	@list: queue to initialize
+ *
+ *	This initializes only the list and queue length aspects of
+ *	an sk_buff_head object.  This allows to initialize the list
+ *	aspects of an sk_buff_head without reinitializing things like
+ *	the spinlock.  It can also be used for on-stack sk_buff_head
+ *	objects where the spinlock is known to not be used.
+ */
+static inline void __skb_queue_head_init(struct sk_buff_head *list)
+{
+	list->prev = list->next = (struct sk_buff *)list;
+	list->qlen = 0;
+}
+
+static inline void __skb_queue_splice(const struct sk_buff_head *list,
+				      struct sk_buff *prev,
+				      struct sk_buff *next)
+{
+	struct sk_buff *first = list->next;
+	struct sk_buff *last = list->prev;
+
+	first->prev = prev;
+	prev->next = first;
+
+	last->next = next;
+	next->prev = last;
+}
+
+/**
+ *	skb_queue_splice_tail - join two skb lists and reinitialise the emptied list
+ *	@list: the new list to add
+ *	@head: the place to add it in the first list
+ *
+ *	Each of the lists is a queue.
+ *	The list at @list is reinitialised
+ */
+static inline void skb_queue_splice_tail_init(struct sk_buff_head *list,
+					      struct sk_buff_head *head)
+{
+	if (!skb_queue_empty(list)) {
+		__skb_queue_splice(list, head->prev, (struct sk_buff *) head);
+		head->qlen += list->qlen;
+		__skb_queue_head_init(list);
+	}
+} /* From include/linux/skbuff.h */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
diff --git a/config.mk b/config.mk
index 00ab728..c346a4c 100644
--- a/config.mk
+++ b/config.mk
@@ -262,7 +262,6 @@ CONFIG_AT76C50X_USB=m
 # Activate AR9170 support only on kernel >= 2.6.29.
 # The needed USB poison feature was added in this kernel release.
 ifeq ($(shell test $(KERNEL_SUBLEVEL) -ge 29 && echo yes),yes)
-CONFIG_AR9170_COMMON=m
 CONFIG_AR9170_USB=m
 CONFIG_AR9170_LEDS=y
 endif
-- 
1.6.2.1

