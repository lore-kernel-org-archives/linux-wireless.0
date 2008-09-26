Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35596 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752259AbYIZOUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 10:20:39 -0400
Date: Fri, 26 Sep 2008 16:20:36 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [compat-old PATCH 2/2] Allow compilation on 2.6.22
Message-ID: <20080926162036.1a181ae1@griffin.suse.cz> (sfid-20080926_162050_479797_817A248F)
In-Reply-To: <20080926161923.54cb0f66@griffin.suse.cz>
References: <20080926161923.54cb0f66@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows compilation of compat-wireless-old on 2.6.22 kernel. I suspect
some drivers don't work despite they compile, though.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 config.mk                              |    4 +++-
 drivers/net/wireless/libertas/if_usb.c |    2 ++
 include/net/compat.h                   |   17 +++++++++++++++++
 net/mac80211/wme.c                     |    2 +-
 4 files changed, 23 insertions(+), 2 deletions(-)

--- cw.orig/config.mk
+++ cw/config.mk
@@ -27,7 +27,6 @@ CONFIG_MAC80211=m
 ifeq ($(shell test -e $(KLIB_BUILD)/Makefile && echo yes),yes)
 KERNEL_SUBLEVEL = $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
 ifeq ($(shell test $(KERNEL_SUBLEVEL) -lt 23 && echo yes),yes)
-$(error "ERROR: There is a bug with compat-wireless on 2.6.22. Remove me if you want to fix me")
 CONFIG_MAC80211_QOS=y
 else
 
@@ -154,7 +153,10 @@ CONFIG_P54_PCI=m
 CONFIG_SSB_PCIHOST=y
 CONFIG_SSB_DRIVER_PCICORE=y
 CONFIG_SSB_B43_PCI_BRIDGE=y
+ifeq ($(shell test $(KERNEL_SUBLEVEL) -gt 22 && echo yes),yes)
+# b44 is not ported to 2.6.22
 CONFIG_B44=m
+endif
 
 CONFIG_RTL8180=m
 CONFIG_ADM8211=m
--- cw.orig/drivers/net/wireless/libertas/if_usb.c
+++ cw/drivers/net/wireless/libertas/if_usb.c
@@ -947,7 +947,9 @@ static struct usb_driver if_usb_driver =
 	.id_table = if_usb_table,
 	.suspend = if_usb_suspend,
 	.resume = if_usb_resume,
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
 	.reset_resume = if_usb_resume,
+#endif
 };
 
 static int __init if_usb_init_module(void)
--- cw.orig/include/net/compat.h
+++ cw/include/net/compat.h
@@ -33,6 +33,7 @@
 
 #include <net/arp.h>
 #include <net/neighbour.h>
+#include <net/pkt_sched.h>
 
 #include <linux/compat_autoconf.h>
 
@@ -173,6 +174,22 @@ static inline int netif_is_multiqueue(co
 	return (!!(NETIF_F_MULTI_QUEUE & dev->features));
 }
 
+/* 2.6.23 fixed a bug in tcf_destroy_chain and the parameter changed */
+static inline void tcf_destroy_chain_compat(struct tcf_proto **fl)
+{
+	struct tcf_proto *tp;
+
+	while ((tp = *fl) != NULL) {
+		*fl = tp->next;
+		tp->ops->destroy(tp);
+		module_put(tp->ops->owner);
+		kfree(tp);
+	}
+}
+
+#else
+
+#define tcf_destroy_chain_compat tcf_destroy_chain
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)) */
 
--- cw.orig/net/mac80211/wme.c
+++ cw/net/mac80211/wme.c
@@ -310,7 +310,7 @@ static void wme_qdiscop_destroy(struct Q
 	struct ieee80211_hw *hw = &local->hw;
 	int queue;
 
-	tcf_destroy_chain(&q->filter_list);
+	tcf_destroy_chain_compat(&q->filter_list);
 
 	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		skb_queue_purge(&q->requeued[queue]);


-- 
Jiri Benc
SUSE Labs
