Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0H0Lpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:45:32 -0400
Subject: [PATCH] mac80211: fix offchannel queue stop
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Luis Rodriguez <mcgrof@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 13:45:28 +0200
Message-ID: <1282909528.4377.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Somebody noticed this problem, and I outlined
to them how to fix it, but haven't heard back
from them. So while I was adding the state
field I figured I could use it to fix it.

The problem, as I understand it, is that when
we go offchannel while the driver has a queue
stopped, the driver will likely start draining
the queue and then enable it while offchannel.
This in turn will enable the interface queue,
and that leads to transmitting data frames on
the wrong channel.

Fix this by keeping track of offchannel status
per interface, and not enabling the interface
queues on interfaces that are offchannel when
the driver enables a queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Too lazy to dig out who reported this, so CCing
a bunch of people at Atheros ...

 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/offchannel.c  |   19 +++++++++++++++++--
 net/mac80211/util.c        |    5 ++++-
 3 files changed, 24 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-08-27 13:26:38.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-08-27 13:29:44.000000000 +0200
@@ -477,9 +477,12 @@ enum ieee80211_sub_if_data_flags {
  * @SDATA_STATE_RUNNING: virtual interface is up & running; this
  *	mirrors netif_running() but is separate for interface type
  *	change handling while the interface is up
+ * @SDATA_STATE_OFFCHANNEL: This interface is currently in offchannel
+ *	mode, so queues are stopped
  */
 enum ieee80211_sdata_state_bits {
 	SDATA_STATE_RUNNING,
+	SDATA_STATE_OFFCHANNEL,
 };
 
 struct ieee80211_sub_if_data {
--- wireless-testing.orig/net/mac80211/offchannel.c	2010-08-27 13:26:38.000000000 +0200
+++ wireless-testing/net/mac80211/offchannel.c	2010-08-27 13:34:31.000000000 +0200
@@ -112,8 +112,10 @@ void ieee80211_offchannel_stop_beaconing
 		 * used from user space controlled off-channel operations.
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-		    sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		    sdata->vif.type != NL80211_IFTYPE_MONITOR) {
+			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
 			netif_tx_stop_all_queues(sdata->dev);
+		}
 	}
 	mutex_unlock(&local->iflist_mtx);
 }
@@ -131,6 +133,7 @@ void ieee80211_offchannel_stop_station(s
 			continue;
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
 			netif_tx_stop_all_queues(sdata->dev);
 			if (sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata);
@@ -155,8 +158,20 @@ void ieee80211_offchannel_return(struct
 				ieee80211_offchannel_ps_disable(sdata);
 		}
 
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
+			clear_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
+			/*
+			 * This may wake up queues even though the driver
+			 * currently has them stopped. This is not very
+			 * likely, since the driver won't have gotten any
+			 * (or hardly any) new packets while we weren't
+			 * on the right channel, and even if it happens
+			 * it will at most lead to queueing up one more
+			 * packet per queue in mac80211 rather than on
+			 * the interface qdisc.
+			 */
 			netif_tx_wake_all_queues(sdata->dev);
+		}
 
 		/* re-enable beaconing */
 		if (enable_beaconing &&
--- wireless-testing.orig/net/mac80211/util.c	2010-08-27 13:27:34.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-08-27 13:29:44.000000000 +0200
@@ -283,8 +283,11 @@ static void __ieee80211_wake_queue(struc
 
 	if (skb_queue_empty(&local->pending[queue])) {
 		rcu_read_lock();
-		list_for_each_entry_rcu(sdata, &local->interfaces, list)
+		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+			if (test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))
+				continue;
 			netif_wake_subqueue(sdata->dev, queue);
+		}
 		rcu_read_unlock();
 	} else
 		tasklet_schedule(&local->tx_pending_tasklet);


