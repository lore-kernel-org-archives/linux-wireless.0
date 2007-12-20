Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:57815 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758950AbXLTXxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 18:53:48 -0500
Date: Fri, 21 Dec 2007 00:44:44 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/2] mac80211: fix breakage
Message-ID: <20071221004444.30c818cd@morte> (sfid-20071220_235355_935648_29740885)
In-Reply-To: <200712202035.45909.mb@bu3sch.de>
References: <200712202020.51320.mb@bu3sch.de>
 <200712202035.45909.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Properly fix breakage introduced by:

commit 14d9eab2febd9caa8821d2b578d84e961dda3103
Author: Stefano Brivio <stefano.brivio@polimi.it>
Date:   Wed Dec 19 01:26:16 2007 +0100

Always build rc80211-simple into mac80211, and let rc80211-pid to be selected
through a modparam and built as a module. The default rate control algorithm
to be used can be set into the kernel configuration as well.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
John,

sorry for the delay. In case you didn't merge the previous patch, this is the
proper fix for the breakage.
---
Index: wireless-2.6/net/mac80211/ieee80211.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211.c
+++ wireless-2.6/net/mac80211/ieee80211.c
@@ -1323,21 +1323,32 @@ static int __init ieee80211_init(void)
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_tx_packet_data) > sizeof(skb->cb));
 
+	ret = ieee80211_rate_control_register(&mac80211_rcsimple);
+	if (ret)
+		goto fail;
+
 	ret = ieee80211_wme_register();
 	if (ret) {
 		printk(KERN_DEBUG "ieee80211_init: failed to "
 		       "initialize WME (err=%d)\n", ret);
-		return ret;
+		goto fail;
 	}
 
 	ieee80211_debugfs_netdev_init();
 	ieee80211_regdomain_init();
 
 	return 0;
+
+fail:
+	ieee80211_rate_control_unregister(&mac80211_rcsimple);
+
+	return ret;
 }
 
 static void __exit ieee80211_exit(void)
 {
+	ieee80211_rate_control_unregister(&mac80211_rcsimple);
+
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
 }
Index: wireless-2.6/net/mac80211/ieee80211_rate.h
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_rate.h
+++ wireless-2.6/net/mac80211/ieee80211_rate.h
@@ -58,6 +58,9 @@ struct rate_control_ref {
 	struct kref kref;
 };
 
+/* default 'simple' algorithm */
+extern struct rate_control_ops mac80211_rcsimple;
+
 int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 
Index: wireless-2.6/net/mac80211/ieee80211_rate.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_rate.c
+++ wireless-2.6/net/mac80211/ieee80211_rate.c
@@ -94,8 +94,7 @@ ieee80211_try_rate_control_ops_get(const
 	return ops;
 }
 
-/* Get the rate control algorithm. If `name' is NULL, get the first
- * available algorithm. */
+/* Get the rate control algorithm. */
 static struct rate_control_ops *
 ieee80211_rate_control_ops_get(const char *name)
 {
Index: wireless-2.6/net/mac80211/Kconfig
===================================================================
--- wireless-2.6.orig/net/mac80211/Kconfig
+++ wireless-2.6/net/mac80211/Kconfig
@@ -35,7 +35,6 @@ config MAC80211_RC_DEFAULT_PID
 config MAC80211_RC_DEFAULT_SIMPLE
 	bool "Simple rate control algorithm"
 	depends on MAC80211
-	select MAC80211_RC_SIMPLE
 	help
 	Select the simple rate control as the default rate
 	control algorithm. Note that this is a non-responsive,
@@ -62,18 +61,6 @@ config MAC80211_RC_PID
 	  Say Y or M unless you're sure you want to use a
 	  different rate control algorithm.
 
-config MAC80211_RC_SIMPLE
-	tristate "Simple rate control algorithm (DEPRECATED)"
-	default n
-	depends on MAC80211
-	help
-	  This option enables a very simple, non-responsive TX
-	  rate control algorithm. This algorithm is deprecated
-	  and will be removed from the kernel in near future.
-	  It has been replaced by the PID algorithm.
-
-	  Say N unless you know what you are doing.
-
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211 && LEDS_TRIGGERS
Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -498,7 +498,8 @@ static void rate_control_pid_free_sta(vo
 	kfree(spinfo);
 }
 
-struct rate_control_ops mac80211_rcpid = {
+static struct rate_control_ops mac80211_rcpid = {
+	.module = THIS_MODULE,
 	.name = "pid",
 	.tx_status = rate_control_pid_tx_status,
 	.get_rate = rate_control_pid_get_rate,
@@ -513,3 +514,16 @@ struct rate_control_ops mac80211_rcpid =
 	.remove_sta_debugfs = rate_control_pid_remove_sta_debugfs,
 #endif
 };
+
+static int __init rate_control_pid_init(void)
+{
+	return ieee80211_rate_control_register(&mac80211_rcpid);
+}
+
+static void __exit rate_control_pid_exit(void)
+{
+	ieee80211_rate_control_unregister(&mac80211_rcpid);
+}
+
+subsys_initcall(rate_control_pid_init);
+module_exit(rate_control_pid_exit);



-- 
Ciao
Stefano
