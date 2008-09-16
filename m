Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYIPMz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 08:55:58 -0400
Subject: [PATCH] cfg80211: show interface type
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 14:55:09 +0200
Message-Id: <1221569709.8916.36.camel@johannes.berg> (sfid-20080916_145601_935520_348A7127)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes cfg80211 show the interface in the nl80211
information about a specific interface. API users are required
to keep the type updated (everything else is fairly complicated)
but you will get a warning if you fail to keep it updated.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
NB: This depends on "mac80211: make master interface not wireless"!

 include/net/cfg80211.h |    6 ++++--
 include/net/wireless.h |    2 ++
 net/mac80211/iface.c   |    1 +
 net/wireless/core.c    |    2 ++
 net/wireless/nl80211.c |    6 +++++-
 5 files changed, 14 insertions(+), 3 deletions(-)

--- everything.orig/include/net/wireless.h	2008-09-16 14:12:43.000000000 +0200
+++ everything/include/net/wireless.h	2008-09-16 14:14:30.000000000 +0200
@@ -223,9 +223,11 @@ struct wiphy {
  * the netdev.)
  *
  * @wiphy: pointer to hardware description
+ * @iftype: interface type
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
+	enum nl80211_iftype iftype;
 
 	/* private to the generic wireless code */
 	struct list_head list;
--- everything.orig/net/wireless/core.c	2008-09-16 14:12:40.000000000 +0200
+++ everything/net/wireless/core.c	2008-09-16 14:14:30.000000000 +0200
@@ -384,6 +384,8 @@ static int cfg80211_netdev_notifier_call
 
 	rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
 
+	WARN_ON(dev->ieee80211_ptr->iftype == NL80211_IFTYPE_UNSPECIFIED);
+
 	switch (state) {
 	case NETDEV_REGISTER:
 		mutex_lock(&rdev->devlist_mtx);
--- everything.orig/include/net/cfg80211.h	2008-09-16 14:11:35.000000000 +0200
+++ everything/include/net/cfg80211.h	2008-09-16 14:14:30.000000000 +0200
@@ -363,11 +363,13 @@ struct wiphy;
  * wireless extensions but this is subject to reevaluation as soon as this
  * code is used more widely and we have a first user without wext.
  *
- * @add_virtual_intf: create a new virtual interface with the given name
+ * @add_virtual_intf: create a new virtual interface with the given name,
+ *	must set the struct wireless_dev's iftype.
  *
  * @del_virtual_intf: remove the virtual interface determined by ifindex.
  *
- * @change_virtual_intf: change type of virtual interface
+ * @change_virtual_intf: change type/configuration of virtual interface,
+ *	keep the struct wireless_dev's iftype updated.
  *
  * @add_key: add a key with the given parameters. @mac_addr will be %NULL
  *	when adding a group key.
--- everything.orig/net/mac80211/iface.c	2008-09-16 14:11:36.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-09-16 14:14:30.000000000 +0200
@@ -624,6 +624,7 @@ static void ieee80211_setup_sdata(struct
 	/* and set some type-dependent values */
 	sdata->vif.type = type;
 	sdata->dev->hard_start_xmit = ieee80211_subif_start_xmit;
+	sdata->wdev.iftype = type;
 
 	/* only monitor differs */
 	sdata->dev->type = ARPHRD_ETHER;
--- everything.orig/net/wireless/nl80211.c	2008-09-16 14:11:35.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-09-16 14:23:45.000000000 +0200
@@ -299,7 +299,7 @@ static int nl80211_send_iface(struct sk_
 
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
 	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, dev->name);
-	/* TODO: interface type */
+	NLA_PUT_U32(msg, NL80211_ATTR_IFTYPE, dev->ieee80211_ptr->iftype);
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -453,6 +453,10 @@ static int nl80211_set_interface(struct 
 				  &flags);
 	err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
 					    type, err ? NULL : &flags, &params);
+
+	dev = __dev_get_by_index(&init_net, ifindex);
+	WARN_ON(!dev || (!err && dev->ieee80211_ptr->iftype != type));
+
 	rtnl_unlock();
 
  unlock:


