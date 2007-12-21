Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXLUQf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 11:35:56 -0500
Subject: [PATCH] mac80211: better rate control algorithm selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	sam <sam@ravnborg.org>, Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 17:09:35 +0100
Message-Id: <1198253375.16241.76.camel@johannes.berg> (sfid-20071221_163601_002416_24531ADC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sam, I'm not entirely happy with the Makefile hacks. Can you take a look
at the comment there and tell me whether there's any way to convince
Kbuild to resolve the rc80211_pid.o even when rc80211_pid.o isn't in
obj-y or obj-m but within mac80211-y?

Also, I'm not really happy with the ieee80211_rate.h #if but I don't see
any way around that.

Below is the patch, comments welcome. I think this is the way we want
it, tristate for all rate control algorithms regardless of whether
mac80211 is modular (where =y then means "build algorithm into
mac80211") and forcing one of the algorithms to y to do exactly that.

From: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: better rate control algorithm selection

This patch changes mac80211's Kconfig/Makefile to:
 * select between the PID and the SIMPLE rate control
   algorithm as default
 * always allow tri-state for the rate control algorithms,
   building those that are selected 'y' into the mac80211
   module (if that is a module, otherwise all into the kernel)
 * force the default rate control algorithm to be built into
   mac80211

It also makes both rate control algorithms proper modules again
with MODULE_LICENSE etc.

Only if EMBEDDED is the user allowed to select "NONE" as default
which will cause no algorithm to be selected, this will work
only when the driver brings one itself (e.g. iwlwifi drivers).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Kconfig            |   37 ++++++++++++++++++-------------------
 net/mac80211/Makefile           |   40 ++++++++++++++++++++++++++++++++++------
 net/mac80211/ieee80211.c        |   34 +++++++++++-----------------------
 net/mac80211/ieee80211_rate.h   |   38 ++++++++++++++++++++++++++++++++------
 net/mac80211/rc80211_pid_algo.c |   24 ++++++++++++++++++++++--
 net/mac80211/rc80211_simple.c   |   21 ++++++++++++++++++++-
 6 files changed, 137 insertions(+), 57 deletions(-)

--- everything.orig/net/mac80211/Kconfig	2007-12-21 12:32:03.258062609 +0100
+++ everything/net/mac80211/Kconfig	2007-12-21 16:38:32.983806424 +0100
@@ -13,25 +13,17 @@ config MAC80211
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.
 
-config MAC80211_RC_DEFAULT_CHOICE
-	bool "Choose default rate control algorithm" if EMBEDDED
-	default y
-	depends on MAC80211
-	---help---
-	  This options enables selection of a default rate control
-	  algorithm to be built into the mac80211 module.  Alternate
-	  rate control algorithms might be built into the mac80211
-	  module as well.
+menu "Rate control algorithm selection"
+	depends on MAC80211 != n
 
 choice
 	prompt "Default rate control algorithm"
 	default MAC80211_RC_DEFAULT_PID
-	depends on MAC80211 && MAC80211_RC_DEFAULT_CHOICE
 	---help---
 	  This option selects the default rate control algorithm
 	  mac80211 will use. Note that this default can still be
 	  overriden through the ieee80211_default_rc_algo module
-	  parameter.
+	  parameter if different algorithms are available.
 
 config MAC80211_RC_DEFAULT_PID
 	bool "PID controller based rate control algorithm"
@@ -50,19 +42,27 @@ config MAC80211_RC_DEFAULT_SIMPLE
 	  dumb algorithm. You should choose the PID rate control
 	  instead.
 
+config MAC80211_RC_DEFAULT_NONE
+	bool "No default algorithm"
+	depends on EMBEDDED
+	help
+	  Selecting this option will select no default algorithm
+	  and allow you to not build any. Do not choose this
+	  option unless you know your driver comes with another
+	  suitable algorithm.
 endchoice
 
+comment "Selecting 'y' for an algorithm will"
+comment "build the algorithm into mac80211."
+
 config MAC80211_RC_DEFAULT
 	string
-	depends on MAC80211
 	default "pid" if MAC80211_RC_DEFAULT_PID
 	default "simple" if MAC80211_RC_DEFAULT_SIMPLE
 	default ""
 
 config MAC80211_RC_PID
-	bool "PID controller based rate control algorithm"
-	default y
-	depends on MAC80211
+	tristate "PID controller based rate control algorithm"
 	---help---
 	  This option enables a TX rate control algorithm for
 	  mac80211 that uses a PID controller to select the TX
@@ -72,16 +72,15 @@ config MAC80211_RC_PID
 	  different rate control algorithm.
 
 config MAC80211_RC_SIMPLE
-	bool "Simple rate control algorithm (DEPRECATED)"
-	default n
-	depends on MAC80211
+	tristate "Simple rate control algorithm (DEPRECATED)"
 	---help---
 	  This option enables a very simple, non-responsive TX
 	  rate control algorithm. This algorithm is deprecated
-	  and will be removed from the kernel in near future.
+	  and will be removed from the kernel in the near future.
 	  It has been replaced by the PID algorithm.
 
 	  Say N unless you know what you are doing.
+endmenu
 
 config MAC80211_LEDS
 	bool "Enable LED triggers"
--- everything.orig/net/mac80211/Makefile	2007-12-21 13:09:22.008062120 +0100
+++ everything/net/mac80211/Makefile	2007-12-21 16:58:21.893811361 +0100
@@ -1,17 +1,44 @@
 obj-$(CONFIG_MAC80211) += mac80211.o
 
+#
+# Rate control algorithms
+#
+# Build in those that are 'y' and build as modules those that are 'm'
+# Kconfig enforces (unless EMBEDDED) that one is always 'y'
+#
+mac80211-rc-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
+# Hmm. I'd like to not do this but Kbuild doesn't resolve
+# the rc80211_pid.o into rc80211_pid-y when it isn't right
+# within the objs-m/objs-y list...
+ifeq ($(CONFIG_MAC80211_RC_PID),y)
+mac80211-rc-$(CONFIG_MAC80211_RC_PID) += $(rc80211_pid-y)
+else
+ifeq ($(CONFIG_MAC80211_RC_PID),m)
+mac80211-rc-$(CONFIG_MAC80211_RC_PID) += rc80211_pid.o
+endif
+endif
+
+rc80211_pid-y += rc80211_pid_algo.o
+rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
+
+# extra #defines for the header file
+CFLAGS_rc80211_simple.o += -DRC80211_SIMPLE_COMPILE
+CFLAGS_rc80211_pid_algo.o += -DRC80211_PID_COMPILE
+
+# build the ones selected 'm' as modules
+obj-m += $(mac80211-rc-m)
+
+#
+# mac80211 building
+#
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
 mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
-mac80211-objs-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
-mac80211-objs-$(CONFIG_MAC80211_RC_PID) += rc80211_pid_algo.o
 
-mac80211-debugfs-objs-$(CONFIG_MAC80211_RC_PID) += rc80211_pid_debugfs.o
 mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += \
 	debugfs.o \
 	debugfs_sta.o \
 	debugfs_netdev.o \
-	debugfs_key.o \
-	$(mac80211-debugfs-objs-y)
+	debugfs_key.o
 
 mac80211-objs := \
 	ieee80211.o \
@@ -32,4 +59,5 @@ mac80211-objs := \
 	key.o \
 	util.o \
 	event.o \
-	$(mac80211-objs-y)
+	$(mac80211-objs-y) \
+	$(mac80211-rc-y)
--- everything.orig/net/mac80211/rc80211_simple.c	2007-12-21 13:10:50.258063802 +0100
+++ everything/net/mac80211/rc80211_simple.c	2007-12-21 13:41:07.702167209 +0100
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/compiler.h>
+#include <linux/module.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
@@ -349,7 +350,7 @@ static void rate_control_simple_remove_s
 }
 #endif
 
-struct rate_control_ops mac80211_rcsimple = {
+static struct rate_control_ops mac80211_rcsimple = {
 	.name = "simple",
 	.tx_status = rate_control_simple_tx_status,
 	.get_rate = rate_control_simple_get_rate,
@@ -364,3 +365,21 @@ struct rate_control_ops mac80211_rcsimpl
 	.remove_sta_debugfs = rate_control_simple_remove_sta_debugfs,
 #endif
 };
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Simple rate control algorithm");
+
+int __init rc80211_simple_init(void)
+{
+	return ieee80211_rate_control_register(&mac80211_rcsimple);
+}
+
+void __exit rc80211_simple_exit(void)
+{
+	ieee80211_rate_control_unregister(&mac80211_rcsimple);
+}
+
+#ifdef CONFIG_MAC80211_RC_SIMPLE_MODULE
+module_init(rc80211_simple_init);
+module_exit(rc80211_simple_exit);
+#endif
--- everything.orig/net/mac80211/ieee80211_rate.h	2007-12-21 13:41:31.842169001 +0100
+++ everything/net/mac80211/ieee80211_rate.h	2007-12-21 16:31:46.463806804 +0100
@@ -58,12 +58,6 @@ struct rate_control_ref {
 	struct kref kref;
 };
 
-/* default 'simple' algorithm */
-extern struct rate_control_ops mac80211_rcsimple;
-
-/* 'PID' algorithm */
-extern struct rate_control_ops mac80211_rcpid;
-
 int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 
@@ -170,4 +164,36 @@ int ieee80211_init_rate_ctrl_alg(struct 
 				 const char *name);
 void rate_control_deinitialize(struct ieee80211_local *local);
 
+
+/* Rate control algorithms */
+#if defined(RC80211_SIMPLE_COMPILE) || \
+	(defined(CONFIG_MAC80211_RC_SIMPLE) && \
+	 !defined(CONFIG_MAC80211_RC_SIMPLE_MODULE))
+extern int rc80211_simple_init(void);
+extern void rc80211_simple_exit(void);
+#else
+static inline int rc80211_simple_init(void)
+{
+	return 0;
+}
+static inline void rc80211_simple_exit(void)
+{
+}
+#endif
+
+#if defined(RC80211_PID_COMPILE) || \
+	(defined(CONFIG_MAC80211_RC_PID) && \
+	 !defined(CONFIG_MAC80211_RC_PID_MODULE))
+extern int rc80211_pid_init(void);
+extern void rc80211_pid_exit(void);
+#else
+static inline int rc80211_pid_init(void)
+{
+	return 0;
+}
+static inline void rc80211_pid_exit(void)
+{
+}
+#endif
+
 #endif /* IEEE80211_RATE_H */
--- everything.orig/net/mac80211/ieee80211.c	2007-12-21 13:42:28.272180773 +0100
+++ everything/net/mac80211/ieee80211.c	2007-12-21 13:47:34.412168892 +0100
@@ -1323,23 +1323,19 @@ static int __init ieee80211_init(void)
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_tx_packet_data) > sizeof(skb->cb));
 
-#ifdef CONFIG_MAC80211_RC_SIMPLE
-	ret = ieee80211_rate_control_register(&mac80211_rcsimple);
+	ret = rc80211_simple_init();
 	if (ret)
 		goto fail;
-#endif
 
-#ifdef CONFIG_MAC80211_RC_PID
-	ret = ieee80211_rate_control_register(&mac80211_rcpid);
+	ret = rc80211_pid_init();
 	if (ret)
-		goto fail;
-#endif
+		goto fail_simple;
 
 	ret = ieee80211_wme_register();
 	if (ret) {
 		printk(KERN_DEBUG "ieee80211_init: failed to "
 		       "initialize WME (err=%d)\n", ret);
-		goto fail;
+		goto fail_pid;
 	}
 
 	ieee80211_debugfs_netdev_init();
@@ -1347,26 +1343,18 @@ static int __init ieee80211_init(void)
 
 	return 0;
 
-fail:
-
-#ifdef CONFIG_MAC80211_RC_SIMPLE
-	ieee80211_rate_control_unregister(&mac80211_rcsimple);
-#endif
-#ifdef CONFIG_MAC80211_RC_PID
-	ieee80211_rate_control_unregister(&mac80211_rcpid);
-#endif
-
+ fail_pid:
+	rc80211_simple_exit();
+ fail_simple:
+	rc80211_pid_exit();
+ fail:
 	return ret;
 }
 
 static void __exit ieee80211_exit(void)
 {
-#ifdef CONFIG_MAC80211_RC_SIMPLE
-	ieee80211_rate_control_unregister(&mac80211_rcsimple);
-#endif
-#ifdef CONFIG_MAC80211_RC_PID
-	ieee80211_rate_control_unregister(&mac80211_rcpid);
-#endif
+	rc80211_simple_exit();
+	rc80211_pid_exit();
 
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2007-12-21 13:12:20.118094673 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2007-12-21 16:33:14.133809245 +0100
@@ -12,7 +12,7 @@
 #include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/skbuff.h>
-
+#include <linux/debugfs.h>
 #include <net/mac80211.h>
 #include "ieee80211_rate.h"
 
@@ -493,7 +493,7 @@ static void rate_control_pid_free_sta(vo
 	kfree(spinfo);
 }
 
-struct rate_control_ops mac80211_rcpid = {
+static struct rate_control_ops mac80211_rcpid = {
 	.name = "pid",
 	.tx_status = rate_control_pid_tx_status,
 	.get_rate = rate_control_pid_get_rate,
@@ -508,3 +508,23 @@ struct rate_control_ops mac80211_rcpid =
 	.remove_sta_debugfs = rate_control_pid_remove_sta_debugfs,
 #endif
 };
+
+MODULE_DESCRIPTION("PID controller based rate control algorithm");
+MODULE_AUTHOR("Stefano Brivio");
+MODULE_AUTHOR("Mattias Nissler");
+MODULE_LICENSE("GPL");
+
+int __init rc80211_pid_init(void)
+{
+	return ieee80211_rate_control_register(&mac80211_rcpid);
+}
+
+void __exit rc80211_pid_exit(void)
+{
+	ieee80211_rate_control_unregister(&mac80211_rcpid);
+}
+
+#ifdef CONFIG_MAC80211_RC_PID_MODULE
+module_init(rc80211_pid_init);
+module_exit(rc80211_pid_exit);
+#endif


