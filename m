Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42210 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751931AbdJ2JvT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 05:51:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 11:51:08 +0200
Message-Id: <20171029095111.17078-3-luca@coelho.fi> (sfid-20171029_105208_837634_690FD969)
In-Reply-To: <20171029095111.17078-1-luca@coelho.fi>
References: <20171029095111.17078-1-luca@coelho.fi>
Subject: [PATCH 2/5] mac80211: call synchronize_net once in the restart flow
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently the restart flow enables RX back, and then proceeds
to tear down RX and TX aggregations.
The TX aggregation tear down calls synchronize_net(), which
waits for packet receiving to be done.
This is done for every session, while RX processing is already
active, and in some reproductions it takes up to 3 seconds.
Add a call once in the restart_work, before we have traffic
active again, and remove the subsequent calls when tearing
down the aggregation.
This requires to move down the code that turns off the
reconfig flag in order to be able to test it in
_ieee80211_stop_tx_ba_session().

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/agg-tx.c |  3 ++-
 net/mac80211/main.c   |  3 +++
 net/mac80211/util.c   | 19 ++++++++++---------
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 1d0bf857a3b5..96d1013d277d 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -387,7 +387,8 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	 * telling the driver. New packets will not go through since
 	 * the aggregation session is no longer OPERATIONAL.
 	 */
-	synchronize_net();
+	if (!local->in_reconfig)
+		synchronize_net();
 
 	tid_tx->stop_initiator = reason == AGG_STOP_PEER_REQUEST ?
 					WLAN_BACK_RECIPIENT :
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e054a2fd8d38..0785d04a80bc 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -263,6 +263,9 @@ static void ieee80211_restart_work(struct work_struct *work)
 	flush_delayed_work(&local->roc_work);
 	flush_work(&local->hw_roc_done);
 
+	/* wait for all packet processing to be done */
+	synchronize_net();
+
 	ieee80211_reconfig(local);
 	rtnl_unlock();
 }
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d57e5f6bd8b6..1f82191ce601 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2110,15 +2110,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy, 0);
 
  wake_up:
-	if (local->in_reconfig) {
-		local->in_reconfig = false;
-		barrier();
-
-		/* Restart deferred ROCs */
-		mutex_lock(&local->mtx);
-		ieee80211_start_next_roc(local);
-		mutex_unlock(&local->mtx);
-	}
 
 	if (local->monitors == local->open_count && local->monitors > 0)
 		ieee80211_add_virtual_monitor(local);
@@ -2146,6 +2137,16 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_unlock(&local->sta_mtx);
 	}
 
+	if (local->in_reconfig) {
+		local->in_reconfig = false;
+		barrier();
+
+		/* Restart deferred ROCs */
+		mutex_lock(&local->mtx);
+		ieee80211_start_next_roc(local);
+		mutex_unlock(&local->mtx);
+	}
+
 	ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 					false);
-- 
2.14.2
