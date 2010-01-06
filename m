Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab0AFLGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 06:06:04 -0500
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4B442008.2040207@lwfinger.net>
References: <1262710858.28653.5.camel@johannes.local>
	 <4B442008.2040207@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 12:05:46 +0100
Message-ID: <1262775946.9268.109.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-01-05 at 23:30 -0600, Larry Finger wrote:

> Reauthentication fails with a pop-up to reenter the WPA2 secret as I'm
> using NetworkManager. I can only reconnect if b43 (and mac80211) are
> unloaded and reloaded. I pulled the patch and confirmed that proper
> behavior is returned.

Ouch.

I can't seem to reproduce this with hwsim, but it never touches the
queues.

I think it may be because I forgot about
53623f1a09c7a7d23b74f0f7d93dba0ebde1006b ...

The patch below is certainly needed, but I'm not entirely sure it'll fix
your issue, can you give it a try please?

johannes

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


