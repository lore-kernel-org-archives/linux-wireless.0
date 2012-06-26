Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:64975 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab2FZMaj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:30:39 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v3 07/13] mac80211: refactor virtual monitor code
Date: Tue, 26 Jun 2012 14:30:12 +0200
Message-ID: <1340713818-28549-8-git-send-email-michal.kazior@tieto.com> (sfid-20120626_143054_479778_F49AA15E)
In-Reply-To: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
References: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
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
index 85ac364..df7332e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2943,6 +2943,16 @@ ieee80211_wiphy_get_channel(struct wiphy *wiphy,
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
@@ -3018,6 +3028,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.probe_client = ieee80211_probe_client,
 	.get_channel = ieee80211_wiphy_get_channel,
 	.set_noack_map = ieee80211_set_noack_map,
+	.set_monitor_enabled = ieee80211_set_monitor_enabled,
 #ifdef CONFIG_PM
 	.set_wakeup = ieee80211_set_wakeup,
 #endif
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e6cbf5b..9eb3b8b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1472,6 +1472,10 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       enum nl80211_channel_type channel_type,
 			       u16 prot_mode);
 
+/* virtual monitor */
+int ieee80211_add_virtual_monitor(struct ieee80211_local *local);
+void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
+
 /* channel management */
 enum ieee80211_chan_mode {
 	CHAN_MODE_UNDEFINED,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 87aeb4f..47f46fd 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -214,7 +214,7 @@ static void ieee80211_set_default_queues(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 }
 
-static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
+int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
@@ -255,7 +255,7 @@ static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	return 0;
 }
 
-static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
+void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -371,12 +371,6 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
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
@@ -391,8 +385,6 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 		break;
 	default:
 		if (coming_up) {
-			ieee80211_del_virtual_monitor(local);
-
 			res = drv_add_interface(local, sdata);
 			if (res)
 				goto err_stop;
@@ -627,7 +619,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		if (local->monitors == 0) {
 			local->hw.conf.flags &= ~IEEE80211_CONF_MONITOR;
 			hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
-			ieee80211_del_virtual_monitor(local);
 		}
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
@@ -701,9 +692,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
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

