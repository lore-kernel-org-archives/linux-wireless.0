Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49855 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZJQVGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 17:06:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [compat-2.6 and compat-2.6-stable] rename ieee80211_rx
Date: Sat, 17 Oct 2009 23:06:45 +0200
Message-Id: <1255813605-19366-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename ieee80211_rx to avoild conflicts with the export done by older
libipw. libipw in kernel 2.6.32 and older also exports a symbol named
ieee80211_rx. If libipw from normal kernel and mac80211 from
compat-wireless is loaded you will get an conflict.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.32.h                          |    3 +++
 compat/patches/15-symbol-export-conflicts.patch |   20 ++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 compat/patches/15-symbol-export-conflicts.patch

diff --git a/compat/compat-2.6.32.h b/compat/compat-2.6.32.h
index ad7f01b..1362e3e 100644
--- a/compat/compat-2.6.32.h
+++ b/compat/compat-2.6.32.h
@@ -71,6 +71,9 @@ struct dev_pm_ops name = { \
 
 #define wireless_send_event(a, b, c, d) wireless_send_event(a, b, c, (char * ) d)
 
+/* The export symbol in changed in compat/patches/15-symbol-export-conflicts.patch */
+#define ieee80211_rx(hw, skb) mac80211_ieee80211_rx(hw, skb)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
 
 #endif /* LINUX_26_32_COMPAT_H */
diff --git a/compat/patches/15-symbol-export-conflicts.patch b/compat/patches/15-symbol-export-conflicts.patch
new file mode 100644
index 0000000..e095f9b
--- /dev/null
+++ b/compat/patches/15-symbol-export-conflicts.patch
@@ -0,0 +1,20 @@
+In kernel < 2.6.32 libipw also exports ieee80211_rx.
+To avoid conflicts with the other export we rename our.
+
+diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
+index 5c385e3..26e5fc9 100644
+--- a/net/mac80211/rx.c
++++ b/net/mac80211/rx.c
+@@ -2545,7 +2545,12 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
+  drop:
+ 	kfree_skb(skb);
+ }
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
+ EXPORT_SYMBOL(ieee80211_rx);
++#else
++EXPORT_SYMBOL(mac80211_ieee80211_rx);
++#endif
++
+ 
+ /* This is a version of the rx handler that can be called from hard irq
+  * context. Post the skb on the queue and schedule the tasklet */
-- 
1.6.2.1

