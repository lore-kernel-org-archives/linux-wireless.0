Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYABOR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 09:17:26 -0500
Subject: [PATCH v2] mac80211: better rate control algorithm selection
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 15:17:03 +0100
Message-Id: <1199283424.4172.88.camel@johannes.berg> (sfid-20080102_141729_512327_7329F77F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
This version rewrites the makefile based on Sam's suggestion, thanks
much!

 net/mac80211/Kconfig            |   37 +++++++++++++++++-------------------
 net/mac80211/Makefile           |   41 ++++++++++++++++++++++++++--------------
 net/mac80211/ieee80211.c        |   34 ++++++++++-----------------------
 net/mac80211/ieee80211_rate.c   |    4 +++
 net/mac80211/ieee80211_rate.h   |   38 +++++++++++++++++++++++++++++++------
 net/mac80211/rc80211_pid_algo.c |   24 +++++++++++++++++++++--
 net/mac80211/rc80211_simple.c   |   21 +++++++++++++++++++-
 7 files changed, 134 insertions(+), 65 deletions(-)

--- everything.orig/net/mac80211/Kconfig	2007-12-23 10:12:08.568939290 +0100
+++ everything/net/mac80211/Kconfig	2007-12-23 10:12:16.698937717 +0100
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
--- everything.orig/net/mac80211/Makefile	2007-12-23 10:12:08.658937771 +0100
+++ everything/net/mac80211/Makefile	2008-01-02 15:07:52.568414117 +0100
@@ -1,19 +1,15 @@
 obj-$(CONFIG_MAC80211) += mac80211.o
 
-mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
-mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
-mac80211-objs-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
-mac80211-objs-$(CONFIG_MAC80211_RC_PID) += rc80211_pid_algo.o
+# objects for PID algorithm
+rc80211_pid-y := rc80211_pid_algo.o
+rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
 
-mac80211-debugfs-objs-$(CONFIG_MAC80211_RC_PID) += rc80211_pid_debugfs.o
-mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += \
-	debugfs.o \
-	debugfs_sta.o \
-	debugfs_netdev.o \
-	debugfs_key.o \
-	$(mac80211-debugfs-objs-y)
+# build helper for PID algorithm
+rc-pid-y := $(rc80211_pid-y)
+rc-pid-m := rc80211_pid.o
 
-mac80211-objs := \
+# mac80211 objects
+mac80211-y := \
 	ieee80211.o \
 	ieee80211_ioctl.o \
 	sta_info.o \
@@ -31,5 +27,22 @@ mac80211-objs := \
 	tx.o \
 	key.o \
 	util.o \
-	event.o \
-	$(mac80211-objs-y)
+	event.o
+
+mac80211-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
+mac80211-$(CONFIG_NET_SCHED) += wme.o
+mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
+	debugfs.o \
+	debugfs_sta.o \
+	debugfs_netdev.o \
+	debugfs_key.o
+
+
+# Build rate control algorithm(s)
+CFLAGS_rc80211_simple.o += -DRC80211_SIMPLE_COMPILE
+CFLAGS_rc80211_pid_algo.o += -DRC80211_PID_COMPILE
+mac80211-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
+mac80211-$(CONFIG_MAC80211_RC_PID) += $(rc-pid-$(CONFIG_MAC80211_RC_PID))
+
+# Modular rate algorithms are assigned to mac80211-m - make separate modules
+obj-m += $(mac80211-m)
--- everything.orig/net/mac80211/rc80211_simple.c	2007-12-23 10:12:08.768936469 +0100
+++ everything/net/mac80211/rc80211_simple.c	2008-01-02 14:49:36.748416233 +0100
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
--- everything.orig/net/mac80211/ieee80211_rate.h	2007-12-23 10:12:08.868938585 +0100
+++ everything/net/mac80211/ieee80211_rate.h	2008-01-02 14:49:36.378415907 +0100
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
--- everything.orig/net/mac80211/ieee80211.c	2007-12-23 10:12:08.968938638 +0100
+++ everything/net/mac80211/ieee80211.c	2008-01-02 14:49:41.348415582 +0100
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
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2007-12-23 10:12:09.078939018 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-01-02 14:49:42.378415094 +0100
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
--- everything.orig/net/mac80211/ieee80211_rate.c	2007-12-23 10:12:09.208937880 +0100
+++ everything/net/mac80211/ieee80211_rate.c	2008-01-02 14:49:36.868415853 +0100
@@ -115,6 +115,10 @@ ieee80211_rate_control_ops_get(const cha
 		/* try default if specific alg requested but not found */
 		ops = ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
 
+	/* try built-in one if specific alg requested but not found */
+	if (!ops && strlen(CONFIG_MAC80211_RC_DEFAULT))
+		ops = ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
+
 	return ops;
 }
 


