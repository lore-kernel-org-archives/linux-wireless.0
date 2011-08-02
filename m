Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41217 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab1HBVP1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 17:15:27 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/5] compat: add skb_walk_frags() and skb_has_frag_list()
Date: Tue,  2 Aug 2011 23:14:19 +0200
Message-Id: <1312319663-21654-1-git-send-email-hauke@hauke-m.de> (sfid-20110802_231531_165812_3142A1CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions are needed for ./net/bluetooth/l2cap_core.c and ./net/bluetooth/af_bluetooth.c.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.31.h |    3 +++
 include/linux/compat-2.6.37.h |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index d2e0f01..ce944bb 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -199,6 +199,9 @@ void compat_synchronize_threaded_irq(struct compat_threaded_irq *comp)
 #define list_entry_rcu(ptr, type, member) \
 	container_of(rcu_dereference(ptr), type, member)
 
+#define skb_walk_frags(skb, iter)	\
+	for (iter = skb_shinfo(skb)->frag_list; iter; iter = iter->next)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
 
 #endif /* LINUX_26_31_COMPAT_H */
diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index e0dd6b4..d375746 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -124,6 +124,11 @@ extern void *vzalloc(unsigned long size);
 #define RCU_INIT_POINTER(p, v) \
 		p = (typeof(*v) __force __rcu *)(v)
 
+static inline bool skb_has_frag_list(const struct sk_buff *skb)
+{
+	return skb_shinfo(skb)->frag_list != NULL;
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
-- 
1.7.4.1

