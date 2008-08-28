Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:34935 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYH1Hhv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 03:37:51 -0400
Message-ID: <48B655C8.9020500@symas.com> (sfid-20080828_093756_828102_A6F8FFF4)
Date: Thu, 28 Aug 2008 00:37:44 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] compat-2.6: enable ath9k
References: <48AF209A.4080805@symas.com>
In-Reply-To: <48AF209A.4080805@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables building the wireless-testing ath9k driver with the 
compat-wireless tarball at 
http://www.orbit-lab.org/kernel/compat-wireless-2.6/2008/08/compat-wireless-2008-08-06.tar.bz2

In addition to applying this patch, you must also copy the 
drivers/net/wireless/ath9k directory from the wireless-testing image into the 
compat-wireless tree. Just posting this for posterity since it seems that it 
won't be needed for much longer.

Signed-off-by: Howard Chu <hyc@symas.com>
---

diff -wur compat-wireless-2008-08-06/config.mk 
compat-wireless-2008-08-06.N/config.mk
--- compat-wireless-2008-08-06/config.mk	2008-07-17 21:11:03.000000000 -0700
+++ compat-wireless-2008-08-06.N/config.mk	2008-08-27 23:17:22.000000000 -0700
@@ -72,6 +72,8 @@
  CONFIG_ATH5K=m
  CONFIG_ATH5K_DEBUG=n
  +CONFIG_ATH9K=m
+
  # Required for older kernels which still use this flag.
  CONFIG_IWLWIFI=m
  Only in compat-wireless-2008-08-06.N/drivers/net/wireless: ath9k
diff -wur compat-wireless-2008-08-06/drivers/net/wireless/Makefile 
compat-wireless-2008-08-06.N/drivers/net/wireless/Makefile
--- compat-wireless-2008-08-06/drivers/net/wireless/Makefile	2008-07-29 
21:11:04.000000000 -0700
+++ compat-wireless-2008-08-06.N/drivers/net/wireless/Makefile	2008-08-27 
23:17:48.000000000 -0700
@@ -29,5 +29,6 @@
  obj-$(CONFIG_P54_COMMON)	+= p54/
   obj-$(CONFIG_ATH5K)	+= ath5k/
+obj-$(CONFIG_ATH9K)	+= ath9k/
   obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
diff -wur compat-wireless-2008-08-06/include/net/compat.h 
compat-wireless-2008-08-06.N/include/net/compat.h
--- compat-wireless-2008-08-06/include/net/compat.h	2008-08-05 
16:47:29.000000000 -0700
+++ compat-wireless-2008-08-06.N/include/net/compat.h	2008-08-27 
23:57:32.000000000 -0700
@@ -784,6 +784,53 @@
  int register_rfkill_notifier(struct notifier_block *nb);
  int unregister_rfkill_notifier(struct notifier_block *nb);
  +/* From include/linux/list.h */
+static inline void __list_cut_position(struct list_head *list,
+		struct list_head *head, struct list_head *entry)
+{
+	struct list_head *new_first = entry->next;
+	list->next = head->next;
+	list->next->prev = list;
+	list->prev = entry;
+	entry->next = list;
+	head->next = new_first;
+	new_first->prev = head;
+}
+static inline void list_cut_position(struct list_head *list,
+		struct list_head *head, struct list_head *entry)
+{
+	if (list_empty(head))
+		return;
+	if (list_is_singular(head) &&
+		(head->next != entry && head != entry))
+		return;
+	if (entry == head)
+		INIT_LIST_HEAD(list);
+	else
+		__list_cut_position(list, head, entry);
+}
+static inline void __list_splice2(const struct list_head *list,
+				 struct list_head *prev,
+				 struct list_head *next)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+
+	first->prev = prev;
+	prev->next = first;
+
+	last->next = next;
+	next->prev = last;
+}
+static inline void list_splice_tail_init(struct list_head *list,
+					 struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice2(list, head->prev, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
   #endif /* LINUX_26_COMPAT_H */

-- 
    -- Howard Chu
    CTO, Symas Corp.           http://www.symas.com
    Director, Highland Sun     http://highlandsun.com/hyc/
    Chief Architect, OpenLDAP  http://www.openldap.org/project/

