Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56946 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762924AbZJOTQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 15:16:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: replace netif_tx_{start,stop,wake}_all_queues
Date: Thu, 15 Oct 2009 15:14:18 -0400
Message-Id: <1255634058-6614-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace netif_tx_{start,stop,wake}_all_queues with the single-queue
equivalents (i.e. netif_{start,stop,wake}_queue).  Since we are down to
a single queue, these should peform slightly better.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/iface.c |    4 ++--
 net/mac80211/mlme.c  |    4 ++--
 net/mac80211/scan.c  |   10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3004492..6d54d99 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -314,7 +314,7 @@ static int ieee80211_open(struct net_device *dev)
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
 
-	netif_tx_start_all_queues(dev);
+	netif_start_queue(dev);
 
 	return 0;
  err_del_interface:
@@ -343,7 +343,7 @@ static int ieee80211_stop(struct net_device *dev)
 	/*
 	 * Stop TX on this interface first.
 	 */
-	netif_tx_stop_all_queues(dev);
+	netif_stop_queue(dev);
 
 	/*
 	 * Now delete all active aggregation sessions.
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a884672..697a149 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -929,7 +929,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_ps(local, -1);
 	mutex_unlock(&local->iflist_mtx);
 
-	netif_tx_start_all_queues(sdata->dev);
+	netif_start_queue(sdata->dev);
 	netif_carrier_on(sdata->dev);
 }
 
@@ -1061,7 +1061,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	 * time -- we don't want the scan code to enable queues.
 	 */
 
-	netif_tx_stop_all_queues(sdata->dev);
+	netif_stop_queue(sdata->dev);
 	netif_carrier_off(sdata->dev);
 
 	rcu_read_lock();
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 71e10ca..7a350d2 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -306,10 +306,10 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.associated) {
 				ieee80211_scan_ps_disable(sdata);
-				netif_tx_wake_all_queues(sdata->dev);
+				netif_wake_queue(sdata->dev);
 			}
 		} else
-			netif_tx_wake_all_queues(sdata->dev);
+			netif_wake_queue(sdata->dev);
 
 		/* re-enable beaconing */
 		if (sdata->vif.type == NL80211_IFTYPE_AP ||
@@ -364,7 +364,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 		 * are handled in the scan state machine
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
-			netif_tx_stop_all_queues(sdata->dev);
+			netif_stop_queue(sdata->dev);
 	}
 	mutex_unlock(&local->iflist_mtx);
 
@@ -523,7 +523,7 @@ static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *loca
 			continue;
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			netif_tx_stop_all_queues(sdata->dev);
+			netif_stop_queue(sdata->dev);
 			if (sdata->u.mgd.associated)
 				ieee80211_scan_ps_enable(sdata);
 		}
@@ -558,7 +558,7 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.associated)
 				ieee80211_scan_ps_disable(sdata);
-			netif_tx_wake_all_queues(sdata->dev);
+			netif_wake_queue(sdata->dev);
 		}
 	}
 	mutex_unlock(&local->iflist_mtx);
-- 
1.6.2.5

