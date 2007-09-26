Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbXIZM0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 08:26:10 -0400
Subject: [PATCH v2] mac80211: fix interface initialisation and  deinitialisation
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
In-Reply-To: <1190755892.18521.330.camel@johannes.berg>
References: <200709252206.57855.mb@bu3sch.de>
	 <1190755892.18521.330.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 14:27:23 +0200
Message-Id: <1190809643.4204.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an interface is registered it is still uninitialised so
ieee80211_if_reinit() can't be called on it (it will oops.)
Hence, we need to move the uninit method assignment.

Also, this patch fixes the bug that the master device is never
initialised nor deinitialised at all. Oddly, the deinit code
had an if statement to not run some code when running for the
master interface (which never happened), but that if statement
is also wrong. Fix that too.

Now that the uninit code is run for the master device, another
bug surfaced: it tries to remove all dependent interfaces and
that oopses or BUGs at some point, either because it unregisters
already unregistered interfaces (missing list_del bug) or due
to trying to iterate a list that has had other things removed.
Fix this too by handling the master interface specially.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c       |   19 ++++++++++++++++---
 net/mac80211/ieee80211_iface.c |   35 +++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 11 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-26 12:39:30.970162850 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-26 14:08:54.109659539 +0200
@@ -266,7 +266,6 @@ void ieee80211_if_mgmt_setup(struct net_
 	dev->stop = ieee80211_mgmt_stop;
 	dev->type = ARPHRD_IEEE80211_PRISM;
 	dev->hard_header_parse = header_parse_80211;
-	dev->uninit = ieee80211_if_reinit;
 	dev->destructor = ieee80211_if_free;
 }
 
@@ -543,7 +542,6 @@ void ieee80211_if_setup(struct net_devic
 	dev->change_mtu = ieee80211_change_mtu;
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
-	dev->uninit = ieee80211_if_reinit;
 	dev->destructor = ieee80211_if_free;
 }
 
@@ -1234,6 +1232,7 @@ int ieee80211_register_hw(struct ieee802
 		goto fail_dev;
 
 	ieee80211_debugfs_add_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
+	ieee80211_if_set_type(local->mdev, IEEE80211_IF_TYPE_AP);
 
 	result = ieee80211_init_rate_ctrl_alg(local, NULL);
 	if (result < 0) {
@@ -1338,8 +1337,22 @@ void ieee80211_unregister_hw(struct ieee
 	 * because the driver cannot be handing us frames any
 	 * more and the tasklet is killed.
 	 */
-	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list)
+
+	/*
+	 * First, we remove all non-master interfaces. Do this because they
+	 * may have bss pointer dependency on the master, and when we free
+	 * the master these would be freed as well, breaking our list
+	 * iteration completely.
+	 */
+	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
+		if (sdata->dev == local->mdev)
+			continue;
+		list_del(&sdata->list);
 		__ieee80211_if_del(local, sdata);
+	}
+
+	/* then, finally, remove the master interface */
+	__ieee80211_if_del(local, IEEE80211_DEV_TO_SUB_IF(local->mdev));
 
 	rtnl_unlock();
 
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-09-26 12:39:31.050162850 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-26 14:09:42.479659539 +0200
@@ -127,6 +127,12 @@ int ieee80211_if_add_mgmt(struct ieee802
 	if (ret)
 		goto fail;
 
+	/*
+	 * Called even when register_netdevice fails, it would
+	 * oops if assigned before initialising the rest.
+	 */
+	ndev->uninit = ieee80211_if_reinit;
+
 	ieee80211_debugfs_add_netdev(nsdata);
 
 	if (local->open_count > 0)
@@ -155,12 +161,27 @@ void ieee80211_if_set_type(struct net_de
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int oldtype = sdata->type;
 
-	dev->hard_start_xmit = ieee80211_subif_start_xmit;
+	/*
+	 * We need to call this function on the master interface
+	 * which already has a hard_start_xmit routine assigned
+	 * which must not be changed.
+	 */
+	if (!dev->hard_start_xmit)
+		dev->hard_start_xmit = ieee80211_subif_start_xmit;
+
+	/*
+	 * Called even when register_netdevice fails, it would
+	 * oops if assigned before initialising the rest.
+	 */
+	dev->uninit = ieee80211_if_reinit;
 
+	/* most have no BSS pointer */
+	sdata->bss = NULL;
 	sdata->type = type;
+
 	switch (type) {
 	case IEEE80211_IF_TYPE_WDS:
-		sdata->bss = NULL;
+		/* nothing special */
 		break;
 	case IEEE80211_IF_TYPE_VLAN:
 		sdata->u.vlan.ap = NULL;
@@ -213,6 +234,7 @@ void ieee80211_if_reinit(struct net_devi
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
+	struct sk_buff *skb;
 
 	ASSERT_RTNL();
 
@@ -246,12 +268,9 @@ void ieee80211_if_reinit(struct net_devi
 		kfree(sdata->u.ap.beacon_tail);
 		kfree(sdata->u.ap.generic_elem);
 
-		if (dev != local->mdev) {
-			struct sk_buff *skb;
-			while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
-				local->total_ps_buffered--;
-				dev_kfree_skb(skb);
-			}
+		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
+			local->total_ps_buffered--;
+			dev_kfree_skb(skb);
 		}
 
 		break;


