Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:45411 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab2F2Kr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 06:47:27 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 07/13] mac80211: refactor virtual monitor code
Date: Fri, 29 Jun 2012 12:47:02 +0200
Message-ID: <1340966828-22874-8-git-send-email-michal.kazior@tieto.com> (sfid-20120629_124733_963295_A1482C91)
In-Reply-To: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use cfg80211 the new .set_monitor_enabled instead
of tracking it inside mac80211.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         |   11 +++++++++++
 net/mac80211/ieee80211_i.h |    4 ++++
 net/mac80211/iface.c       |   16 ++--------------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0f02c8b..ea4b1ea 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2990,6 +2990,16 @@ ieee80211_wiphy_get_channel(struct wiphy *wiphy,
 	return local->oper_channel;
 }
 
+static void ieee80211_set_monitor_enabled(struct wiphy *wiphy, bool enabled)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (enabled)
+		WARN_ON(ieee80211_add_virtual_monitor(local));
+	else
+		ieee80211_del_virtual_monitor(local);
+}
+
 #ifdef CONFIG_PM
 static void ieee80211_set_wakeup(struct wiphy *wiphy, bool enabled)
 {
@@ -3065,6 +3075,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.probe_client = ieee80211_probe_client,
 	.get_channel = ieee80211_wiphy_get_channel,
 	.set_noack_map = ieee80211_set_noack_map,
+	.set_monitor_enabled = ieee80211_set_monitor_enabled,
 #ifdef CONFIG_PM
 	.set_wakeup = ieee80211_set_wakeup,
 #endif
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6b7157d..b88bdfd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1485,6 +1485,10 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb, bool need_basic);
 
+/* virtual monitor */
+int ieee80211_add_virtual_monitor(struct ieee80211_local *local);
+void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
+
 /* channel management */
 enum ieee80211_chan_mode {
 	CHAN_MODE_UNDEFINED,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0a6b4e1..fbef7a1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -330,7 +330,7 @@ static void ieee80211_set_default_queues(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 }
 
-static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
+int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
@@ -371,7 +371,7 @@ static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	return 0;
 }
 
-static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
+void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -487,12 +487,6 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 			break;
 		}
 
-		if (local->monitors == 0 && local->open_count == 0) {
-			res = ieee80211_add_virtual_monitor(local);
-			if (res)
-				goto err_stop;
-		}
-
 		/* must be before the call to ieee80211_configure_filter */
 		local->monitors++;
 		if (local->monitors == 1) {
@@ -507,8 +501,6 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 		break;
 	default:
 		if (coming_up) {
-			ieee80211_del_virtual_monitor(local);
-
 			res = drv_add_interface(local, sdata);
 			if (res)
 				goto err_stop;
@@ -743,7 +735,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		if (local->monitors == 0) {
 			local->hw.conf.flags &= ~IEEE80211_CONF_MONITOR;
 			hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
-			ieee80211_del_virtual_monitor(local);
 		}
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
@@ -817,9 +808,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
-
-	if (local->monitors == local->open_count && local->monitors > 0)
-		ieee80211_add_virtual_monitor(local);
 }
 
 static int ieee80211_stop(struct net_device *dev)
-- 
1.7.0.4

