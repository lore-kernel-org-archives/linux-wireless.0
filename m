Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42149 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754447AbXLSAIL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 19:08:11 -0500
Date: Wed, 19 Dec 2007 01:03:14 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/8] mac80211: make PID rate control algorithm the
 default
Message-ID: <20071219010314.4c43ec19@morte> (sfid-20071219_000814_205629_2A06501E)
In-Reply-To: <20071218233749.871878037@polimi.it>
References: <20071218233749.871878037@polimi.it>>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the new PID TX rate control algorithm the default instead of the
rc80211_simple rate control algorithm. The simple algorithm was flawed in
several ways: it wasn't responsive at all and didn't age the information it
was relying on properly. The PID algorithm allows us to tune
characteristics such as responsiveness by adjusting parameters and was
found to generally behave better.

Two separate modules are created, however we force users to build
rc80211-simple into mac80211 if rc80211-pid isn't built-in, so that this
won't break for users who disable module autoloading. The default algorithm
can be set through a modparam. While at it, mark rc80211-simple as
deprecated, and schedule it for removal.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
 Documentation/feature-removal-schedule.txt |    8 +++
 net/mac80211/Kconfig                       |   61
+++++++++++++++++++++++------ net/mac80211/Makefile
|   10 +++- net/mac80211/ieee80211.c                   |   32
--------------- net/mac80211/ieee80211_rate.c              |   12 +++++
 net/mac80211/ieee80211_rate.h              |    6 --
 6 files changed, 77 insertions(+), 52 deletions(-)

Index: wireless-2.6/net/mac80211/Kconfig
===================================================================
--- wireless-2.6.orig/net/mac80211/Kconfig
+++ wireless-2.6/net/mac80211/Kconfig
@@ -13,20 +13,45 @@ config MAC80211
 	This option enables the hardware independent IEEE 802.11
 	networking stack.

-config MAC80211_RCSIMPLE
-	bool "'simple' rate control algorithm" if EMBEDDED
-	default y
+choice
+	prompt "Default rate control algorithm"
+	default MAC80211_RC_DEFAULT_PID
+	depends on MAC80211
+	help
+	This option selects the default rate control algorithm
+	mac80211 will use. Note that this default can still be
+	overriden through the ieee80211_default_rc_algo module
+	parameter.
+
+config MAC80211_RC_DEFAULT_PID
+	bool "PID controller based rate control algorithm"
+	depends on MAC80211
+	select MAC80211_RC_PID
+	help
+	Select the PID controller based rate control as the
+	default rate control algorithm. You should choose
+	this unless you know what you are doing.
+
+config MAC80211_RC_DEFAULT_SIMPLE
+	bool "Simple rate control algorithm"
 	depends on MAC80211
+	select MAC80211_RC_SIMPLE
 	help
-	  This option allows you to turn off the 'simple' rate
-	  control algorithm in mac80211. If you do turn it off,
-	  you absolutely need another rate control algorithm.
+	Select the simple rate control as the default rate
+	control algorithm. Note that this is a non-responsive,
+	dumb algorithm. You should choose the PID rate control
+	instead.

-	  Say Y unless you know you will have another algorithm
-	  available.
+endchoice

-config MAC80211_RCPID
-	bool "'PID' rate control algorithm" if EMBEDDED
+config MAC80211_RC_DEFAULT
+	string
+	depends on MAC80211
+	default "pid" if MAC80211_RC_DEFAULT_PID
+	default "simple" if MAC80211_RC_DEFAULT_SIMPLE
+
+config MAC80211_RC_PID
+	tristate "PID controller based rate control algorithm"
 	default y
 	depends on MAC80211
 	help
@@ -34,8 +59,20 @@ config MAC80211_RCPID
 	  mac80211 that uses a PID controller to select the TX
 	  rate.

-	  Say Y unless you're sure you want to use a different
-	  rate control algorithm.
+	  Say Y or M unless you're sure you want to use a
+	  different rate control algorithm.
+
+config MAC80211_RC_SIMPLE
+	tristate "Simple rate control algorithm (DEPRECATED)"
+	default n
+	depends on MAC80211
+	help
+	  This option enables a very simple, non-responsive TX
+	  rate control algorithm. This algorithm is deprecated
+	  and will be removed from the kernel in near future.
+	  It has been replaced by the PID algorithm.
+
+	  Say N unless you know what you are doing.

 config MAC80211_LEDS
 	bool "Enable LED triggers"
Index: wireless-2.6/net/mac80211/Makefile
===================================================================
--- wireless-2.6.orig/net/mac80211/Makefile
+++ wireless-2.6/net/mac80211/Makefile
@@ -1,10 +1,12 @@
 obj-$(CONFIG_MAC80211) += mac80211.o
+obj-$(CONFIG_MAC80211_RC_PID) += rc80211_pid.o
+ifeq ($(CONFIG_MAC80211_RC_PID),y)
+	obj-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
+endif

 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
 mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o
debugfs_netdev.o debugfs_key.o mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
-mac80211-objs-$(CONFIG_MAC80211_RCSIMPLE) += rc80211_simple.o
-mac80211-objs-$(CONFIG_MAC80211_RCPID) += rc80211_pid.o

 mac80211-objs := \
 	ieee80211.o \
@@ -26,3 +28,7 @@ mac80211-objs := \
 	util.o \
 	event.o \
 	$(mac80211-objs-y)
+
+ifneq ($(CONFIG_MAC80211_RC_PID),y)
+	mac80211-objs += rc80211_simple.o
+endif
Index: wireless-2.6/net/mac80211/ieee80211.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211.c
+++ wireless-2.6/net/mac80211/ieee80211.c
@@ -1313,51 +1313,21 @@ static int __init ieee80211_init(void)

 	BUILD_BUG_ON(sizeof(struct ieee80211_tx_packet_data) >
sizeof(skb->cb));

-#ifdef CONFIG_MAC80211_RCSIMPLE
-	ret = ieee80211_rate_control_register(&mac80211_rcsimple);
-	if (ret)
-		goto fail;
-#endif
-
-#ifdef CONFIG_MAC80211_RCPID
-	ret = ieee80211_rate_control_register(&mac80211_rcpid);
-	if (ret)
-		goto fail;
-#endif
-
 	ret = ieee80211_wme_register();
 	if (ret) {
 		printk(KERN_DEBUG "ieee80211_init: failed to "
 		       "initialize WME (err=%d)\n", ret);
-		goto fail;
+		return ret;
 	}

 	ieee80211_debugfs_netdev_init();
 	ieee80211_regdomain_init();

 	return 0;
-
-fail:
-
-#ifdef CONFIG_MAC80211_RCSIMPLE
-	ieee80211_rate_control_unregister(&mac80211_rcsimple);
-#endif
-#ifdef CONFIG_MAC80211_RCPID
-	ieee80211_rate_control_unregister(&mac80211_rcpid);
-#endif
-
-	return ret;
 }

 static void __exit ieee80211_exit(void)
 {
-#ifdef CONFIG_MAC80211_RCSIMPLE
-	ieee80211_rate_control_unregister(&mac80211_rcsimple);
-#endif
-#ifdef CONFIG_MAC80211_RCPID
-	ieee80211_rate_control_unregister(&mac80211_rcpid);
-#endif
-
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
 }
Index: wireless-2.6/net/mac80211/ieee80211_rate.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_rate.c
+++ wireless-2.6/net/mac80211/ieee80211_rate.c
@@ -21,6 +21,11 @@ struct rate_control_alg {
 static LIST_HEAD(rate_ctrl_algs);
 static DEFINE_MUTEX(rate_ctrl_mutex);

+static char *ieee80211_default_rc_algo = CONFIG_MAC80211_RC_DEFAULT;
+module_param(ieee80211_default_rc_algo, charp, 0644);
+MODULE_PARM_DESC(ieee80211_default_rc_algo,
+		 "Default rate control algorithm for mac80211 to use");
+
 int ieee80211_rate_control_register(struct rate_control_ops *ops)
 {
 	struct rate_control_alg *alg;
@@ -97,13 +102,17 @@ ieee80211_rate_control_ops_get(const cha
 	struct rate_control_ops *ops;

 	if (!name)
-		name = "simple";
+		name = ieee80211_default_rc_algo;

 	ops = ieee80211_try_rate_control_ops_get(name);
 	if (!ops) {
 		request_module("rc80211_%s", name);
 		ops = ieee80211_try_rate_control_ops_get(name);
 	}
+	if (!ops)
+		/* If we get here, rc80211_simple must be built into
mac80211. */
+		ops = ieee80211_try_rate_control_ops_get("simple");
+
 	return ops;
 }

@@ -244,3 +253,4 @@ void rate_control_deinitialize(struct ie
 	local->rate_ctrl = NULL;
 	rate_control_put(ref);
 }
+
Index: wireless-2.6/net/mac80211/ieee80211_rate.h
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_rate.h
+++ wireless-2.6/net/mac80211/ieee80211_rate.h
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

Index: wireless-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- wireless-2.6.orig/Documentation/feature-removal-schedule.txt
+++ wireless-2.6/Documentation/feature-removal-schedule.txt
@@ -350,3 +350,11 @@ Why:	No in-kernel drivers will depend on
 Who:	John W. Linville <linville@tuxdriver.com>

 ---------------------------
+
+What:	rc80211-simple rate control algorithm for mac80211
+When:	2.6.26
+Files:	net/mac80211/rc80211-simple.c
+Why:	This algorithm was provided for reference but always exhibited
bad
+	responsiveness and performance and has some serious flaws. It has
been
+	replaced by rc80211-pid.
+Who:	Stefano Brivio <stefano.brivio@polimi.it>

--
Ciao
Stefano
