Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbXJ1NQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 09:16:31 -0400
Subject: [PATCH] mac80211: make simple rate control algorithm built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <200710281148.50859.mb@bu3sch.de>
References: <4a55afb80710271456k6c3bbfeah879b67a91a3b8d41@mail.gmail.com>
	 <200710280034.41942.mb@bu3sch.de> <1193568021.3966.15.camel@johannes.berg>
	 <200710281148.50859.mb@bu3sch.de>
Content-Type: text/plain
Date: Sun, 28 Oct 2007 14:17:44 +0100
Message-Id: <1193577464.5197.2.camel@johannes.berg> (sfid-20071028_131636_539817_6FC6868F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Too frequently people do not have module autoloading enabled
or fail to install the rate control module correctly, hence
their hardware probing fails due to no rate control algorithm
being available. This makes the 'simple' algorithm built into
the mac80211 module unless EMBEDDED is enabled in which case
it can be disabled (eg. if the wanted driver requires another
rate control algorithm.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/Kconfig          |   12 ++++++++++++
 net/mac80211/Makefile         |    3 ++-
 net/mac80211/ieee80211.c      |   13 +++++++++++++
 net/mac80211/ieee80211_rate.c |   13 +++++++++++--
 net/mac80211/ieee80211_rate.h |    3 +++
 net/mac80211/rc80211_simple.c |   25 +------------------------
 6 files changed, 42 insertions(+), 27 deletions(-)

--- linux-2.6.orig/net/mac80211/Kconfig	2007-10-28 11:56:30.749321886 +0100
+++ linux-2.6/net/mac80211/Kconfig	2007-10-28 14:13:34.255049803 +0100
@@ -13,6 +13,18 @@ config MAC80211
 	This option enables the hardware independent IEEE 802.11
 	networking stack.
 
+config MAC80211_RCSIMPLE
+	bool "'simple' rate control algorithm"
+	default y
+	depends on MAC80211 && EMBEDDED
+	help
+	  This option allows you to turn off the 'simple' rate
+	  control algorithm in mac80211. If you do turn it off,
+	  you absolutely need another rate control algorithm.
+
+	  Say Y unless you know you will have another algorithm
+	  available.
+
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211 && LEDS_TRIGGERS
--- linux-2.6.orig/net/mac80211/Makefile	2007-10-28 11:55:23.509301107 +0100
+++ linux-2.6/net/mac80211/Makefile	2007-10-28 11:56:26.709301759 +0100
@@ -1,8 +1,9 @@
-obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o
+obj-$(CONFIG_MAC80211) += mac80211.o
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
 mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
 mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
+mac80211-objs-$(CONFIG_MAC80211_RCSIMPLE) += rc80211_simple.o
 
 mac80211-objs := \
 	ieee80211.o \
--- linux-2.6.orig/net/mac80211/ieee80211.c	2007-10-28 11:59:41.869300835 +0100
+++ linux-2.6/net/mac80211/ieee80211.c	2007-10-28 14:12:14.495041666 +0100
@@ -1435,8 +1435,17 @@ static int __init ieee80211_init(void)
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_tx_packet_data) > sizeof(skb->cb));
 
+#ifdef CONFIG_MAC80211_RCSIMPLE
+	ret = ieee80211_rate_control_register(&mac80211_rcsimple);
+	if (ret)
+		return ret;
+#endif
+
 	ret = ieee80211_wme_register();
 	if (ret) {
+#ifdef CONFIG_MAC80211_RCSIMPLE
+		ieee80211_rate_control_unregister(&mac80211_rcsimple);
+#endif
 		printk(KERN_DEBUG "ieee80211_init: failed to "
 		       "initialize WME (err=%d)\n", ret);
 		return ret;
@@ -1450,6 +1459,10 @@ static int __init ieee80211_init(void)
 
 static void __exit ieee80211_exit(void)
 {
+#ifdef CONFIG_MAC80211_RCSIMPLE
+	ieee80211_rate_control_unregister(&mac80211_rcsimple);
+#endif
+
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
 }
--- linux-2.6.orig/net/mac80211/ieee80211_rate.h	2007-10-28 12:01:32.659303603 +0100
+++ linux-2.6/net/mac80211/ieee80211_rate.h	2007-10-28 14:11:42.775035211 +0100
@@ -67,6 +67,9 @@ struct rate_control_ref {
 	struct kref kref;
 };
 
+/* default 'simple' algorithm */
+extern struct rate_control_ops mac80211_rcsimple;
+
 int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 
--- linux-2.6.orig/net/mac80211/rc80211_simple.c	2007-10-28 12:03:52.769304415 +0100
+++ linux-2.6/net/mac80211/rc80211_simple.c	2007-10-28 14:11:53.705037761 +0100
@@ -7,7 +7,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/types.h>
@@ -29,8 +28,6 @@
 #define RATE_CONTROL_INTERVAL (HZ / 20)
 #define RATE_CONTROL_MIN_TX 10
 
-MODULE_ALIAS("rc80211_default");
-
 static void rate_control_rate_inc(struct ieee80211_local *local,
 				  struct sta_info *sta)
 {
@@ -394,8 +391,7 @@ static void rate_control_simple_remove_s
 }
 #endif
 
-static struct rate_control_ops rate_control_simple = {
-	.module = THIS_MODULE,
+struct rate_control_ops mac80211_rcsimple = {
 	.name = "simple",
 	.tx_status = rate_control_simple_tx_status,
 	.get_rate = rate_control_simple_get_rate,
@@ -410,22 +406,3 @@ static struct rate_control_ops rate_cont
 	.remove_sta_debugfs = rate_control_simple_remove_sta_debugfs,
 #endif
 };
-
-
-static int __init rate_control_simple_init(void)
-{
-	return ieee80211_rate_control_register(&rate_control_simple);
-}
-
-
-static void __exit rate_control_simple_exit(void)
-{
-	ieee80211_rate_control_unregister(&rate_control_simple);
-}
-
-
-subsys_initcall(rate_control_simple_init);
-module_exit(rate_control_simple_exit);
-
-MODULE_DESCRIPTION("Simple rate control algorithm for ieee80211");
-MODULE_LICENSE("GPL");
--- linux-2.6.orig/net/mac80211/ieee80211_rate.c	2007-10-28 13:41:38.079305284 +0100
+++ linux-2.6/net/mac80211/ieee80211_rate.c	2007-10-28 14:07:51.665033203 +0100
@@ -25,6 +25,9 @@ int ieee80211_rate_control_register(stru
 {
 	struct rate_control_alg *alg;
 
+	if (!ops->name)
+		return -EINVAL;
+
 	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
 	if (alg == NULL) {
 		return -ENOMEM;
@@ -61,9 +64,12 @@ ieee80211_try_rate_control_ops_get(const
 	struct rate_control_alg *alg;
 	struct rate_control_ops *ops = NULL;
 
+	if (!name)
+		return NULL;
+
 	mutex_lock(&rate_ctrl_mutex);
 	list_for_each_entry(alg, &rate_ctrl_algs, list) {
-		if (!name || !strcmp(alg->ops->name, name))
+		if (!strcmp(alg->ops->name, name))
 			if (try_module_get(alg->ops->module)) {
 				ops = alg->ops;
 				break;
@@ -80,9 +86,12 @@ ieee80211_rate_control_ops_get(const cha
 {
 	struct rate_control_ops *ops;
 
+	if (!name)
+		name = "simple";
+
 	ops = ieee80211_try_rate_control_ops_get(name);
 	if (!ops) {
-		request_module("rc80211_%s", name ? name : "default");
+		request_module("rc80211_%s", name);
 		ops = ieee80211_try_rate_control_ops_get(name);
 	}
 	return ops;


