Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbZAWQfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:35:11 -0500
Subject: [PATCH] mac80211: add interface list lock
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 18:04:39 +0100
Message-Id: <1232643879.5819.5.camel@johannes.local> (sfid-20090123_173515_930290_E25D97D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using only the RTNL has a number of problems, most notably that
ieee80211_iterate_active_interfaces() and other interface list
traversals cannot be done from the internal workqueue because it
needs to be flushed under the RTNL.

This patch introduces a new mutex that protects the interface list
against modifications. A more detailed explanation is part of the
code change.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Need this for the scan stuff I'm doing next, but this has the side
effect of allowing you to call ieee80211_iterate_active_interfaces()
from mac80211's workqueue, which might be interesting. Ivo, that's
the reason you got a copy of this.

 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/iface.c       |   31 +++++++++++++++++++++++++++++++
 net/mac80211/main.c        |    3 +++
 net/mac80211/util.c        |    4 ++--
 4 files changed, 38 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-21 12:48:12.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-21 13:57:49.000000000 +0100
@@ -643,7 +643,9 @@ struct ieee80211_local {
 	struct crypto_blkcipher *wep_rx_tfm;
 	u32 wep_iv;
 
+	/* see iface.c */
 	struct list_head interfaces;
+	struct mutex iflist_mtx;
 
 	/*
 	 * Key lock, protects sdata's key_list and sta_info's
--- wireless-testing.orig/net/mac80211/iface.c	2009-01-21 12:48:12.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-01-21 13:57:49.000000000 +0100
@@ -21,6 +21,23 @@
 #include "mesh.h"
 #include "led.h"
 
+/**
+ * DOC: Interface list locking
+ *
+ * The interface list in each struct ieee80211_local is protected
+ * three-fold:
+ *
+ * (1) modifications may only be done under the RTNL
+ * (2) modifications and readers are protected against each other by
+ *     the iflist_mtx.
+ * (3) modifications are done in an RCU manner so atomic readers
+ *     can traverse the list in RCU-safe blocks.
+ *
+ * As a consequence, reads (traversals) of the list can be protected
+ * by either the RTNL, the iflist_mtx or RCU.
+ */
+
+
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 {
 	int meshhdrlen;
@@ -800,7 +817,9 @@ int ieee80211_if_add(struct ieee80211_lo
 					    params->mesh_id_len,
 					    params->mesh_id);
 
+	mutex_lock(&local->iflist_mtx);
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
+	mutex_unlock(&local->iflist_mtx);
 
 	if (new_dev)
 		*new_dev = ndev;
@@ -816,7 +835,10 @@ void ieee80211_if_remove(struct ieee8021
 {
 	ASSERT_RTNL();
 
+	mutex_lock(&sdata->local->iflist_mtx);
 	list_del_rcu(&sdata->list);
+	mutex_unlock(&sdata->local->iflist_mtx);
+
 	synchronize_rcu();
 	unregister_netdevice(sdata->dev);
 }
@@ -832,7 +854,16 @@ void ieee80211_remove_interfaces(struct 
 	ASSERT_RTNL();
 
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
+		/*
+		 * we cannot hold the iflist_mtx across unregister_netdevice,
+		 * but we only need to hold it for list modifications to lock
+		 * out readers since we're under the RTNL here as all other
+		 * writers.
+		 */
+		mutex_lock(&local->iflist_mtx);
 		list_del(&sdata->list);
+		mutex_unlock(&local->iflist_mtx);
+
 		unregister_netdevice(sdata->dev);
 	}
 }
--- wireless-testing.orig/net/mac80211/main.c	2009-01-21 12:48:21.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-21 13:57:50.000000000 +0100
@@ -718,6 +718,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->hw.conf.radio_enabled = true;
 
 	INIT_LIST_HEAD(&local->interfaces);
+	mutex_init(&local->iflist_mtx);
 
 	spin_lock_init(&local->key_lock);
 
@@ -968,6 +969,8 @@ void ieee80211_free_hw(struct ieee80211_
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
+	mutex_destroy(&local->iflist_mtx);
+
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
--- wireless-testing.orig/net/mac80211/util.c	2009-01-21 12:48:12.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-01-21 12:48:21.000000000 +0100
@@ -459,7 +459,7 @@ void ieee80211_iterate_active_interfaces
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
-	rtnl_lock();
+	mutex_lock(&local->iflist_mtx);
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
@@ -480,7 +480,7 @@ void ieee80211_iterate_active_interfaces
 				 &sdata->vif);
 	}
 
-	rtnl_unlock();
+	mutex_unlock(&local->iflist_mtx);
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
 


