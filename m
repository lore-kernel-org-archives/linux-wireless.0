Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760026AbYBUJY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 04:24:29 -0500
Subject: [PATCH] mac80211: Disallow concurrent IBSS/STA mode interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 01:10:07 +0100
Message-Id: <1203552607.17534.117.camel@johannes.berg> (sfid-20080221_092526_969749_9DEA53C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disallow having more than one IBSS interface up at any time
because of beacon distribution issues, and for now also disallow
having more than one IBSS/STA interface up at the same time
because we use the master interface's BSS struct which would
be completely corrupted when we have more than one up.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Having two STA mode interfaces associated to the same AP
actually works, but is pretty useless. That restriction,
however, can fairly easily be lifted should anybody want to.

Note that right now we don't have any drivers allowing this,
but still.

 net/mac80211/ieee80211.c |   51 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

--- everything.orig/net/mac80211/ieee80211.c	2008-02-21 00:46:41.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-21 01:04:10.000000000 +0100
@@ -183,8 +183,52 @@ static int ieee80211_open(struct net_dev
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		struct net_device *ndev = nsdata->dev;
 
-		if (ndev != dev && ndev != local->mdev && netif_running(ndev) &&
-		    compare_ether_addr(dev->dev_addr, ndev->dev_addr) == 0) {
+		if (ndev != dev && ndev != local->mdev && netif_running(ndev)) {
+			/*
+			 * Allow only a single IBSS interface to be up at any
+			 * time. This is restricted because beacon distribution
+			 * cannot work properly if both are in the same IBSS.
+			 *
+			 * To remove this restriction we'd have to disallow them
+			 * from setting the same SSID on different IBSS interfaces
+			 * belonging to the same hardware. Then, however, we're
+			 * faced with having to adopt two different TSF timers...
+			 */
+			if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
+			    nsdata->vif.type == IEEE80211_IF_TYPE_IBSS)
+				return -EBUSY;
+
+			/*
+			 * Disallow multiple IBSS/STA mode interfaces.
+			 *
+			 * This is a technical restriction, it is possible although
+			 * most likely not IEEE 802.11 compliant to have multiple
+			 * STAs with just a single hardware (the TSF timer will not
+			 * be adjusted properly.)
+			 *
+			 * However, because mac80211 uses the master device's BSS
+			 * information for each STA/IBSS interface, doing this will
+			 * currently corrupt that BSS information completely, unless,
+			 * a not very useful case, both STAs are associated to the
+			 * same BSS.
+			 *
+			 * To remove this restriction, the BSS information needs to
+			 * be embedded in the STA/IBSS mode sdata instead of using
+			 * the master device's BSS structure.
+			 */
+			if ((sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+			     sdata->vif.type == IEEE80211_IF_TYPE_IBSS) &&
+			    (nsdata->vif.type == IEEE80211_IF_TYPE_STA ||
+			     nsdata->vif.type == IEEE80211_IF_TYPE_IBSS))
+				return -EBUSY;
+
+			/*
+			 * The remaining checks are only performed for interfaces
+			 * with the same MAC address.
+			 */
+			if (compare_ether_addr(dev->dev_addr, ndev->dev_addr))
+				continue;
+
 			/*
 			 * check whether it may have the same address
 			 */
@@ -196,8 +240,7 @@ static int ieee80211_open(struct net_dev
 			 * can only add VLANs to enabled APs
 			 */
 			if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN &&
-			    nsdata->vif.type == IEEE80211_IF_TYPE_AP &&
-			    netif_running(nsdata->dev))
+			    nsdata->vif.type == IEEE80211_IF_TYPE_AP)
 				sdata->u.vlan.ap = nsdata;
 		}
 	}


