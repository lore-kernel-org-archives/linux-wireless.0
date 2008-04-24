Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbYDZPvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 11:51:06 -0400
Subject: [PATCH] mac80211: insert WDS peer after adding interface
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 14:18:37 +0200
Message-Id: <1209039517.3357.75.camel@johannes.berg> (sfid-20080426_175125_007920_8CCC34E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reorders the open code so that WDS peer STA info entries
are added after the corresponding interface is added to the
driver so that driver callbacks aren't invoked out of order.
Also make any master device startup fatal.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |   44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

--- everything.orig/net/mac80211/main.c	2008-04-24 13:56:39.000000000 +0200
+++ everything/net/mac80211/main.c	2008-04-24 13:57:13.000000000 +0200
@@ -257,20 +257,6 @@ static int ieee80211_open(struct net_dev
 	case IEEE80211_IF_TYPE_WDS:
 		if (!is_valid_ether_addr(sdata->u.wds.remote_addr))
 			return -ENOLINK;
-
-		/* Create STA entry for the WDS peer */
-		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
-				     GFP_KERNEL);
-		if (!sta)
-			return -ENOMEM;
-
-		sta->flags |= WLAN_STA_AUTHORIZED;
-
-		res = sta_info_insert(sta);
-		if (res) {
-			/* STA has been freed */
-			return res;
-		}
 		break;
 	case IEEE80211_IF_TYPE_VLAN:
 		if (!sdata->u.vlan.ap)
@@ -337,10 +323,8 @@ static int ieee80211_open(struct net_dev
 		conf.type = sdata->vif.type;
 		conf.mac_addr = dev->dev_addr;
 		res = local->ops->add_interface(local_to_hw(local), &conf);
-		if (res && !local->open_count && local->ops->stop)
-			local->ops->stop(local_to_hw(local));
 		if (res)
-			return res;
+			goto err_stop;
 
 		ieee80211_if_config(dev);
 		ieee80211_reset_erp_info(dev);
@@ -353,9 +337,29 @@ static int ieee80211_open(struct net_dev
 			netif_carrier_on(dev);
 	}
 
+	if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
+		/* Create STA entry for the WDS peer */
+		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
+				     GFP_KERNEL);
+		if (!sta) {
+			res = -ENOMEM;
+			goto err_del_interface;
+		}
+
+		sta->flags |= WLAN_STA_AUTHORIZED;
+
+		res = sta_info_insert(sta);
+		if (res) {
+			/* STA has been freed */
+			goto err_del_interface;
+		}
+	}
+
 	if (local->open_count == 0) {
 		res = dev_open(local->mdev);
 		WARN_ON(res);
+		if (res)
+			goto err_del_interface;
 		tasklet_enable(&local->tx_pending_tasklet);
 		tasklet_enable(&local->tasklet);
 	}
@@ -390,6 +394,12 @@ static int ieee80211_open(struct net_dev
 	netif_start_queue(dev);
 
 	return 0;
+ err_del_interface:
+	local->ops->remove_interface(local_to_hw(local), &conf);
+ err_stop:
+	if (!local->open_count && local->ops->stop)
+		local->ops->stop(local_to_hw(local));
+	return res;
 }
 
 static int ieee80211_stop(struct net_device *dev)


