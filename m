Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52582 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYBJNTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 08:19:11 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Fix initial hardware configuration
Date: Sun, 10 Feb 2008 14:16:52 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802101416.52482.mb@bu3sch.de> (sfid-20080210_131916_560164_6C464515)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the initial device-open we need to defer the hardware reconfiguration
after we incremented the open_count, because the hw_config checks this flag
and won't call the lowlevel driver in case it is zero.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this should also go to -stable once you applied it to the tree.
Do you take care of this?


Index: wireless-2.6/net/mac80211/ieee80211.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211.c	2008-02-08 22:54:22.000000000 +0100
+++ wireless-2.6/net/mac80211/ieee80211.c	2008-02-10 14:07:23.000000000 +0100
@@ -172,12 +172,13 @@ static inline int identical_mac_addr_all
 static int ieee80211_open(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata, *nsdata;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_if_init_conf conf;
 	int res;
+	bool need_hw_reconfig = 0;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		struct net_device *ndev = nsdata->dev;
@@ -225,13 +226,13 @@ static int ieee80211_open(struct net_dev
 	if (local->open_count == 0) {
 		res = 0;
 		if (local->ops->start)
 			res = local->ops->start(local_to_hw(local));
 		if (res)
 			return res;
-		ieee80211_hw_config(local);
+		need_hw_reconfig = 1;
 		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
 	}
 
 	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_VLAN:
 		list_add(&sdata->u.vlan.list, &sdata->u.vlan.ap->u.ap.vlans);
@@ -302,12 +303,14 @@ static int ieee80211_open(struct net_dev
 		atomic_inc(&local->iff_allmultis);
 
 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
 		atomic_inc(&local->iff_promiscs);
 
 	local->open_count++;
+	if (need_hw_reconfig)
+		ieee80211_hw_config(local);
 
 	netif_start_queue(dev);
 
 	return 0;
 }
 
