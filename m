Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab3CKRA7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 13:00:59 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] mac80211: some fixes for ieee80211_do_stop while suspend
Date: Mon, 11 Mar 2013 18:01:18 +0100
Message-Id: <1363021279-9809-1-git-send-email-sgruszka@redhat.com> (sfid-20130311_180104_016641_842A6B8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is possible that we close interface while we are suspended, that
can result warning like below (and some others similar):

WARNING: at net/mac80211/driver-ops.h:12 ieee80211_do_stop+0x62e/0x670 [mac80211]()
wlan0:  Failed check-sdata-in-driver check, flags: 0x4
Call Trace:
 [<ffffffff8105c9d6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa045d46e>] ieee80211_do_stop+0x62e/0x670 [mac80211]
 [<ffffffffa045d4ca>] ieee80211_stop+0x1a/0x20 [mac80211]
 [<ffffffff815122ed>] __dev_close_many+0x7d/0xc0
 [<ffffffff81513af8>] dev_close_many+0x88/0x100
 [<ffffffff81513f2a>] dev_close+0x3a/0x50
 [<ffffffffa03c90ae>] cfg80211_rfkill_set_block+0x6e/0xa0 [cfg80211]
 [<ffffffffa03c9106>] cfg80211_rfkill_sync_work+0x26/0x30 [cfg80211]

Patch try to avoid calling most of drv callbacks when stopping interface
while suspended.

Some further work is probably needed to handle ROC, DFS, WDS and
ieee80211_{add,del}_virtual_monitor . However patch should fix issues
in most common scenario, i.e. managed mode without any new futures.
 
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
Patch is on top of my two pending patches:
 - [PATCH 1/2] mac80211: move sdata debugfs dir to vif
 - [PATCH 2/2] mac80211: remove vif debugfs driver callbacks

 net/mac80211/iface.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dfe9cb9..c136050 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -744,8 +744,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 				 sdata->dev->addr_len);
 		spin_unlock_bh(&local->filter_lock);
 		netif_addr_unlock_bh(sdata->dev);
-
-		ieee80211_configure_filter(local);
+		/* configure filter latter (if not suspended) */
 	}
 
 	del_timer_sync(&local->dynamic_ps_timer);
@@ -810,10 +809,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		}
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
-		ieee80211_configure_filter(local);
-		mutex_lock(&local->mtx);
-		ieee80211_recalc_idle(local);
-		mutex_unlock(&local->mtx);
+		/* tell driver latter (if not suspended) */
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* relies on synchronize_rcu() below */
@@ -844,26 +840,29 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 		skb_queue_purge(&sdata->skb_queue);
 
-		if (going_down)
+		if (going_down && !local->suspended)
 			drv_remove_interface(local, sdata);
 	}
 
 	sdata->bss = NULL;
 
-	ieee80211_recalc_ps(local, -1);
+	if (!local->suspended) {
+		if (local->open_count == 0) {
+			ieee80211_clear_tx_pending(local);
+			ieee80211_stop_device(local);
+		} else {
+			ieee80211_configure_filter(local);
+			ieee80211_recalc_ps(local, -1);
 
-	if (local->open_count == 0) {
-		ieee80211_clear_tx_pending(local);
-		ieee80211_stop_device(local);
+			mutex_lock(&local->mtx);
+			ieee80211_recalc_idle(local);
+			mutex_unlock(&local->mtx);
 
-		/* no reconfiguring after stop! */
-		hw_reconf_flags = 0;
+			if (hw_reconf_flags)
+				ieee80211_hw_config(local, hw_reconf_flags);
+		}
 	}
 
-	/* do after stop to avoid reconfiguring when we stop anyway */
-	if (hw_reconf_flags)
-		ieee80211_hw_config(local, hw_reconf_flags);
-
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
 		skb_queue_walk_safe(&local->pending[i], skb, tmp) {
-- 
1.7.1

