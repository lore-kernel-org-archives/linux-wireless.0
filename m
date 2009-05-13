Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbZEMJVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 05:21:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC v2 4/5] mac80211: add WoW support
Date: Wed, 13 May 2009 05:21:00 -0400
Message-Id: <1242206461-30793-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h |    5 ++++-
 net/mac80211/cfg.c     |   11 +++++++++++
 net/mac80211/pm.c      |    6 ++++++
 net/mac80211/util.c    |    8 ++++++++
 4 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9145cbf..17aeb99 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -536,6 +536,7 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_CHANNEL: the channel/channel_type changed
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
+ * @IEEE80211_CONF_CHANGE_WOW: Wake-on-Wireless LAN triggers have changed
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_RADIO_ENABLED	= BIT(0),
@@ -547,6 +548,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+	IEEE80211_CONF_CHANGE_WOW		= BIT(9),
 };
 
 static inline __deprecated enum ieee80211_conf_changed
@@ -1301,7 +1303,8 @@ enum ieee80211_ampdu_mlme_action {
  *	the device wants to enable Wake-on-Wireless-LAN.
  *	This may be called right after add_interface if that rejects
  *	an interface. To assist drivers with WoW we inform the driver
- *	whether or not the stop call is for suspend.
+ *	whether or not the stop call is for suspend. Driver wishing
+ *	to retrieve WoW enabled events can use the wiphy->wow.triggers_enabled.
  *	Must be implemented.
  *
  * @add_interface: Called when a netdevice attached to the hardware is
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index be86e15..a749908 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1146,6 +1146,16 @@ static int ieee80211_resume(struct wiphy *wiphy)
 {
 	return __ieee80211_resume(wiphy_priv(wiphy));
 }
+
+static int ieee80211_set_wow(struct wiphy *wiphy, u32 triggers)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (WARN_ON(!(triggers & wiphy->wow.triggers_supported)))
+		return -EOPNOTSUPP;
+
+	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_WOW);
+}
 #else
 #define ieee80211_suspend NULL
 #define ieee80211_resume NULL
@@ -1362,4 +1372,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.join_ibss = ieee80211_join_ibss,
 	.leave_ibss = ieee80211_leave_ibss,
 	.set_wiphy_params = ieee80211_set_wiphy_params,
+	.set_wow = ieee80211_set_wow,
 };
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 8883d05..0710e4c 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -8,11 +8,15 @@
 int __ieee80211_suspend(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct wiphy *wiphy = &local->hw.wiphy;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
 	unsigned long flags;
 
+	if (wiphy->wow.triggers_enabled)
+		goto send_stop_request;
+
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
@@ -62,6 +66,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 		}
 	}
 
+send_stop_request:
+
 	/* flush again, in case driver queued work */
 	flush_workqueue(local->hw.workqueue);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0689a8f..f3d2622 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1029,12 +1029,20 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 int ieee80211_reconfig(struct ieee80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
+	struct wiphy *wiphy = &local->hw.wiphy;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
 	unsigned long flags;
 	int res;
 
+	/*
+	 * We are coming back from suspend and WoW triggers were enabled,
+	 * this means we didn't do the usual clean suspend
+	 */
+	if (local->suspended && wiphy->wow.triggers_enabled)
+		return 0;
+
 	/* restart hardware */
 	if (local->open_count) {
 		res = drv_start(local);
-- 
1.6.0.6

