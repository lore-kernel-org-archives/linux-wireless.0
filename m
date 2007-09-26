Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57085 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbXIZPzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 11:55:11 -0400
Message-Id: <20070926155435.685374000@sipsolutions.net>
References: <20070926155313.955049000@sipsolutions.net>
Date: Wed, 26 Sep 2007 17:53:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [patch 6/7] mac80211: allow only one IBSS interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Consider the case of multiple virtual IBSS interfaces
trying to join the same IBSS. They wouldn't see beacons
that the other virtual interface sent of course so this
leads to problems. Disallow it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-26 17:21:42.667337342 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-26 17:21:51.317337342 +0200
@@ -170,8 +170,25 @@ static int ieee80211_open(struct net_dev
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		struct net_device *ndev = nsdata->dev;
 
-		if (ndev != dev && ndev != local->mdev && netif_running(ndev) &&
-		    compare_ether_addr(dev->dev_addr, ndev->dev_addr) == 0) {
+		if (ndev != dev && ndev != local->mdev &&
+		    netif_running(ndev)) {
+			/*
+			 * We really only support one IBSS interface, think
+			 * what would happen if they tried to be in the same
+			 * BSS.
+			 */
+			if (sdata->type == IEEE80211_IF_TYPE_IBSS &&
+			    nsdata->type == IEEE80211_IF_TYPE_IBSS &&
+			    netif_running(nsdata->dev))
+				return -EBUSY;
+
+			/*
+			 * The remaining checks are only done for devices
+			 * with the same MAC address.
+			 */
+			if (compare_ether_addr(dev->dev_addr, ndev->dev_addr))
+				continue;
+
 			/*
 			 * check whether it may have the same address
 			 */

-- 

