Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54962 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751227AbXLRUBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 15:01:33 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197982157.4885.124.camel@johannes.berg>
References: <20071217012517.882216322@gmx.de>
	 <20071217012550.213561122@gmx.de> <20071217150202.GC3121@tuxdriver.com>
	 <20071217210649.370ba385@morte> <20071217204112.GE3121@tuxdriver.com>
	 <20071217221610.7906f3e2@morte>  <1197982157.4885.124.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 21:01:27 +0100
Message-Id: <1198008087.7553.9.camel@localhost> (sfid-20071218_200138_269873_1AF5AE72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

below is a new patch that I'd be ok to go with. It builds both pid and
simple as modules. A Kconfig choice makes sure one of them is always
built. Furthermore, there is a modparam that can be used to override the
default algo to use.

The only issue I know about is that if people disable module auto
loading, they'll end up without rate control algorithm. If you don't
like this, please comment on how to fix it.

Mattias



This makes the new PID TX rate control algorithm the default instead of the
rc80211_simple rate control algorithm. The simple algorithm was flawed in
several ways: It wasn't responsive at all and didn't age the information it was
relying on properly. The PID algorithm allows us to tune characteristics such
as responsiveness by adjusting parameters and was found to generally behave
better.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
 net/mac80211/Kconfig          |   12 --
 net/mac80211/Makefile         |    1 -
 net/mac80211/ieee80211.c      |   12 --
 net/mac80211/ieee80211_rate.c |    2 +-
 net/mac80211/ieee80211_rate.h |    3 -
 net/mac80211/rc80211_simple.c |  366 -----------------------------------------
 6 files changed, 1 insertions(+), 395 deletions(-)
 delete mode 100644 net/mac80211/rc80211_simple.c

Index: rt2x00/net/mac80211/Kconfig
===================================================================
--- rt2x00.orig/net/mac80211/Kconfig
+++ rt2x00/net/mac80211/Kconfig
@@ -13,20 +13,40 @@ config MAC80211
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
+	This option selects the default rate control algorithm mac80211 will
+	use. Note that this default can still be overriden by the
+	ieee80211_default_rc_algo module parameter.
+
+config MAC80211_RC_DEFAULT_PID
+	bool "PID controller based rate control algorithm"
+	depends on MAC80211
+	select MAC80211_RC_PID
+	help
+	Select the PID controller based rate control as default rate control
+	algorithm.
+
+config MAC80211_RC_DEFAULT_SIMPLE
+	bool "Simple rate control algorithm"
 	depends on MAC80211
+	select MAC80211_RC_SIMPLE
 	help
-	  This option allows you to turn off the 'simple' rate
-	  control algorithm in mac80211. If you do turn it off,
-	  you absolutely need another rate control algorithm.
+	Select the simple rate control as default rate control algorithm.
 
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
@@ -37,6 +57,18 @@ config MAC80211_RCPID
 	  Say Y unless you're sure you want to use a different
 	  rate control algorithm.
 
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
+
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211 && LEDS_TRIGGERS
Index: rt2x00/net/mac80211/Makefile
===================================================================
--- rt2x00.orig/net/mac80211/Makefile
+++ rt2x00/net/mac80211/Makefile
@@ -1,10 +1,10 @@
 obj-$(CONFIG_MAC80211) += mac80211.o
+obj-$(CONFIG_MAC80211_RC_PID) += rc80211_pid.o
+obj-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
 mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
 mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
-mac80211-objs-$(CONFIG_MAC80211_RCSIMPLE) += rc80211_simple.o
-mac80211-objs-$(CONFIG_MAC80211_RCPID) += rc80211_pid.o
 
 mac80211-objs := \
 	ieee80211.o \
Index: rt2x00/net/mac80211/ieee80211.c
===================================================================
--- rt2x00.orig/net/mac80211/ieee80211.c
+++ rt2x00/net/mac80211/ieee80211.c
@@ -1313,51 +1313,21 @@ static int __init ieee80211_init(void)
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_tx_packet_data) > sizeof(skb->cb));
 
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
Index: rt2x00/net/mac80211/ieee80211_rate.c
===================================================================
--- rt2x00.orig/net/mac80211/ieee80211_rate.c
+++ rt2x00/net/mac80211/ieee80211_rate.c
@@ -21,6 +21,11 @@ struct rate_control_alg {
 static LIST_HEAD(rate_ctrl_algs);
 static DEFINE_MUTEX(rate_ctrl_mutex);
 
+static char *ieee80211_default_rc_algo = CONFIG_MAC80211_RC_DEFAULT;
+module_param(ieee80211_default_rc_algo, charp, 0444);
+MODULE_PARM_DESC(ieee80211_default_rc_algo,
+		 "Default rate control algorithm for mac80211 to use");
+
 int ieee80211_rate_control_register(struct rate_control_ops *ops)
 {
 	struct rate_control_alg *alg;
@@ -97,7 +102,7 @@ ieee80211_rate_control_ops_get(const cha
 	struct rate_control_ops *ops;
 
 	if (!name)
-		name = "simple";
+		name = ieee80211_default_rc_algo;
 
 	ops = ieee80211_try_rate_control_ops_get(name);
 	if (!ops) {
@@ -244,3 +249,4 @@ void rate_control_deinitialize(struct ie
 	local->rate_ctrl = NULL;
 	rate_control_put(ref);
 }
+
Index: rt2x00/net/mac80211/ieee80211_rate.h
===================================================================
--- rt2x00.orig/net/mac80211/ieee80211_rate.h
+++ rt2x00/net/mac80211/ieee80211_rate.h
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
 
Index: rt2x00/Documentation/feature-removal-schedule.txt
===================================================================
--- rt2x00.orig/Documentation/feature-removal-schedule.txt
+++ rt2x00/Documentation/feature-removal-schedule.txt
@@ -350,3 +350,12 @@ Why:	No in-kernel drivers will depend on
 Who:	John W. Linville <linville@tuxdriver.com>
 
 ---------------------------
+
+What:	rc80211-simple rate control algorithm for mac80211
+When:	2.6.26
+Files:	net/mac80211/rc80211-simple.c
+Why:	This algorithm was provided for reference but always exhibited bad
+	responsiveness and performance and has some serious flaws. It has been
+	replaced by rc80211-pid.
+Who:	Stefano Brivio <stefano.brivio@polimi.it>
+



