Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0E1Msz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 08:48:55 -0400
Subject: [PATCH] mac80211: remove useless work starting
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 14:48:52 +0200
Message-ID: <1275050932.3909.103.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ever since we use only cfg80211 for configuration,
there is no configuration that could be pending at
this point, cfg80211 will have the configuration
that is pending and apply it afterwards.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/iface.c |    9 ---------
 1 file changed, 9 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-05-28 14:47:29.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-05-28 14:47:32.000000000 +0200
@@ -321,15 +321,6 @@ static int ieee80211_open(struct net_dev
 
 	ieee80211_recalc_ps(local, -1);
 
-	/*
-	 * ieee80211_sta_work is disabled while network interface
-	 * is down. Therefore, some configuration changes may not
-	 * yet be effective. Trigger execution of ieee80211_sta_work
-	 * to fix this.
-	 */
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
-
 	netif_tx_start_all_queues(dev);
 
 	return 0;


