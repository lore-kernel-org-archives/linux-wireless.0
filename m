Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab2GML6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 07:58:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] Revert "mac80211: refactor virtual monitor code"
Date: Fri, 13 Jul 2012 13:58:48 +0200
Message-Id: <1342180730-19987-2-git-send-email-johannes@sipsolutions.net> (sfid-20120713_135900_361181_7EDD2F3A)
In-Reply-To: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net>
References: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit 870d37fc22f3e40f9f23e06c581c8538fc16a2f0.

This code doesn't work as cfg80211 will call
set_monitor_enabled at the wrong time and it
doesn't seem to be possible to fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   11 -----------
 net/mac80211/ieee80211_i.h |    4 ----
 net/mac80211/iface.c       |   16 ++++++++++++++--
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index cfdc03f..e95f24e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2982,16 +2982,6 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static void ieee80211_set_monitor_enabled(struct wiphy *wiphy, bool enabled)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-
-	if (enabled)
-		WARN_ON(ieee80211_add_virtual_monitor(local));
-	else
-		ieee80211_del_virtual_monitor(local);
-}
-
 #ifdef CONFIG_PM
 static void ieee80211_set_wakeup(struct wiphy *wiphy, bool enabled)
 {
@@ -3066,7 +3056,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.tdls_mgmt = ieee80211_tdls_mgmt,
 	.probe_client = ieee80211_probe_client,
 	.set_noack_map = ieee80211_set_noack_map,
-	.set_monitor_enabled = ieee80211_set_monitor_enabled,
 #ifdef CONFIG_PM
 	.set_wakeup = ieee80211_set_wakeup,
 #endif
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7998513..bb61f77 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1491,10 +1491,6 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb, bool need_basic);
 
-/* virtual monitor */
-int ieee80211_add_virtual_monitor(struct ieee80211_local *local);
-void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
-
 /* channel management */
 enum ieee80211_chan_mode {
 	CHAN_MODE_UNDEFINED,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 334ee0f..bfb57dc 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -331,7 +331,7 @@ static void ieee80211_set_default_queues(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 }
 
-int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
+static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 	int ret = 0;
@@ -377,7 +377,7 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	return ret;
 }
 
-void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
+static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -497,6 +497,12 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 			break;
 		}
 
+		if (local->monitors == 0 && local->open_count == 0) {
+			res = ieee80211_add_virtual_monitor(local);
+			if (res)
+				goto err_stop;
+		}
+
 		/* must be before the call to ieee80211_configure_filter */
 		local->monitors++;
 		if (local->monitors == 1) {
@@ -511,6 +517,8 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 		break;
 	default:
 		if (coming_up) {
+			ieee80211_del_virtual_monitor(local);
+
 			res = drv_add_interface(local, sdata);
 			if (res)
 				goto err_stop;
@@ -745,6 +753,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		if (local->monitors == 0) {
 			local->hw.conf.flags &= ~IEEE80211_CONF_MONITOR;
 			hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
+			ieee80211_del_virtual_monitor(local);
 		}
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
@@ -818,6 +827,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+
+	if (local->monitors == local->open_count && local->monitors > 0)
+		ieee80211_add_virtual_monitor(local);
 }
 
 static int ieee80211_stop(struct net_device *dev)
-- 
1.7.10.4

