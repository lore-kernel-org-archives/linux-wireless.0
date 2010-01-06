Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852Ab0AFOaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 09:30:08 -0500
Subject: [PATCH] mac80211: fix netdev queues
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 15:30:01 +0100
Message-ID: <1262788201.9268.112.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot about commit 53623f1a09, which
had changed all netif_tx_*_all_queues()
instances to to netif_*_queue(), and now
that netdevs have multiple queues that
commit has to be essentially reverted.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/iface.c      |    4 ++--
 net/mac80211/mlme.c       |    4 ++--
 net/mac80211/offchannel.c |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-01-06 12:00:03.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2010-01-06 12:02:17.000000000 +0100
@@ -328,7 +328,7 @@ static int ieee80211_open(struct net_dev
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
 
-	netif_start_queue(dev);
+	netif_tx_start_all_queues(dev);
 
 	return 0;
  err_del_interface:
@@ -356,7 +356,7 @@ static int ieee80211_stop(struct net_dev
 	/*
 	 * Stop TX on this interface first.
 	 */
-	netif_stop_queue(dev);
+	netif_tx_stop_all_queues(dev);
 
 	/*
 	 * Purge work for this interface.
--- wireless-testing.orig/net/mac80211/mlme.c	2010-01-06 12:00:03.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2010-01-06 12:02:17.000000000 +0100
@@ -731,7 +731,7 @@ static void ieee80211_set_associated(str
 	ieee80211_recalc_smps(local, sdata);
 	mutex_unlock(&local->iflist_mtx);
 
-	netif_start_queue(sdata->dev);
+	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
 }
 
@@ -767,7 +767,7 @@ static void ieee80211_set_disassoc(struc
 	 * time -- we don't want the scan code to enable queues.
 	 */
 
-	netif_stop_queue(sdata->dev);
+	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 
 	rcu_read_lock();
--- wireless-testing.orig/net/mac80211/offchannel.c	2010-01-06 12:02:37.000000000 +0100
+++ wireless-testing/net/mac80211/offchannel.c	2010-01-06 12:03:02.000000000 +0100
@@ -113,7 +113,7 @@ void ieee80211_offchannel_stop_beaconing
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_MONITOR)
-			netif_stop_queue(sdata->dev);
+			netif_tx_stop_all_queues(sdata->dev);
 	}
 	mutex_unlock(&local->iflist_mtx);
 }
@@ -131,7 +131,7 @@ void ieee80211_offchannel_stop_station(s
 			continue;
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			netif_stop_queue(sdata->dev);
+			netif_tx_stop_all_queues(sdata->dev);
 			if (sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata);
 		}
@@ -153,7 +153,7 @@ void ieee80211_offchannel_return(struct 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_disable(sdata);
-			netif_wake_queue(sdata->dev);
+			netif_tx_wake_all_queues(sdata->dev);
 		}
 
 		/* re-enable beaconing */


