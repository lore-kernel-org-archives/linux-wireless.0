Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3C0Wda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 18:33:30 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/3] mac80211: fix do_stop handling while suspended
Date: Wed, 27 Mar 2013 23:33:22 +0100
Message-Id: <1364423602-18821-4-git-send-email-johannes@sipsolutions.net> (sfid-20130327_233334_233635_67836BB6)
In-Reply-To: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
References: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a device is unplugged while suspended, mac80211 is
de-initialized and all interfaces are removed while no
state is actually present in the driver. This can cause
warnings and driver confusion.

Fix this by reordering the do_stop code to not call the
driver when it is suspended, i.e. when there's no state
in the driver anyway.

The previous patches removed a few corner cases in ROC
and virtual monitor interfaces so that now this is safe
to do and no state should be left over.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 66 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5ec9c02..f54e72f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -760,8 +760,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 				 sdata->dev->addr_len);
 		spin_unlock_bh(&local->filter_lock);
 		netif_addr_unlock_bh(sdata->dev);
-
-		ieee80211_configure_filter(local);
 	}
 
 	del_timer_sync(&local->dynamic_ps_timer);
@@ -772,6 +770,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
 
 	if (sdata->wdev.cac_started) {
+		WARN_ON(local->suspended);
 		mutex_lock(&local->iflist_mtx);
 		ieee80211_vif_release_channel(sdata);
 		mutex_unlock(&local->iflist_mtx);
@@ -822,14 +821,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		if (local->monitors == 0) {
 			local->hw.conf.flags &= ~IEEE80211_CONF_MONITOR;
 			hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
-			ieee80211_del_virtual_monitor(local);
 		}
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
-		ieee80211_configure_filter(local);
-		mutex_lock(&local->mtx);
-		ieee80211_recalc_idle(local);
-		mutex_unlock(&local->mtx);
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* relies on synchronize_rcu() below */
@@ -859,13 +853,53 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/* fall through */
 	case NL80211_IFTYPE_AP:
 		skb_queue_purge(&sdata->skb_queue);
+	}
+
+	sdata->bss = NULL;
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
+		skb_queue_walk_safe(&local->pending[i], skb, tmp) {
+			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+			if (info->control.vif == &sdata->vif) {
+				__skb_unlink(skb, &local->pending[i]);
+				ieee80211_free_txskb(&local->hw, skb);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+
+	/*
+	 * If the interface goes down while suspended, presumably because
+	 * the device was unplugged and that happens before our resume,
+	 * then the driver is already unconfigured and the remainder of
+	 * this function isn't needed.
+	 * XXX: what about WoWLAN? If the device has software state, e.g.
+	 *	memory allocated, it might expect teardown commands from
+	 *	mac80211 here?
+	 */
+	if (local->suspended) {
+		WARN_ON(local->wowlan);
+		WARN_ON(rtnl_dereference(local->monitor_sdata));
+		return;
+	}
 
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP_VLAN:
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		if (local->monitors == 0)
+			ieee80211_del_virtual_monitor(local);
+
+		mutex_lock(&local->mtx);
+		ieee80211_recalc_idle(local);
+		mutex_unlock(&local->mtx);
+		break;
+	default:
 		if (going_down)
 			drv_remove_interface(local, sdata);
 	}
 
-	sdata->bss = NULL;
-
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
@@ -877,20 +911,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* do after stop to avoid reconfiguring when we stop anyway */
-	if (hw_reconf_flags)
+	if (hw_reconf_flags) {
+		ieee80211_configure_filter(local);
 		ieee80211_hw_config(local, hw_reconf_flags);
-
-	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
-		skb_queue_walk_safe(&local->pending[i], skb, tmp) {
-			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-			if (info->control.vif == &sdata->vif) {
-				__skb_unlink(skb, &local->pending[i]);
-				ieee80211_free_txskb(&local->hw, skb);
-			}
-		}
 	}
-	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 	if (local->monitors == local->open_count && local->monitors > 0)
 		ieee80211_add_virtual_monitor(local);
-- 
1.8.0

