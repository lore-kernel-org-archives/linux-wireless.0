Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:43092 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751811Ab0KJDuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 22:50:44 -0500
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0180071041
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 12:50:43 +0900 (JST)
Subject: [PATCH v7 2/3] mac80211: Add antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, mcgrof@gmail.com, linux-wireless@vger.kernel.org
Date: Wed, 10 Nov 2010 12:50:56 +0900
Message-ID: <20101110035056.23721.12731.stgit@localhost6.localdomain6>
In-Reply-To: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow antenna configuration by calling driver's function for it.

We disallow antenna configuration if the wiphy is already running, mainly to
make life easier for 802.11n drivers which need to recalculate HT capabilites.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/net/mac80211.h      |    2 ++
 net/mac80211/cfg.c          |   19 ++++++++++++++++
 net/mac80211/driver-ops.h   |   23 ++++++++++++++++++++
 net/mac80211/driver-trace.h |   50 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9fdf982..fb6671d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1793,6 +1793,8 @@ struct ieee80211_ops {
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
 	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
+	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
+	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18bd0e5..c9c870c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1621,6 +1621,23 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 	ieee80211_queue_work(&local->hw, &local->reconfig_filter);
 }
 
+static int ieee80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (local->started)
+		return -EOPNOTSUPP;
+
+	return drv_set_antenna(local, tx_ant, rx_ant);
+}
+
+static int ieee80211_get_antenna(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_get_antenna(local, tx_ant, rx_ant);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1673,4 +1690,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.mgmt_tx = ieee80211_mgmt_tx,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
+	.set_antenna = ieee80211_set_antenna,
+	.get_antenna = ieee80211_get_antenna,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1698382..c27a422 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -428,4 +428,27 @@ static inline void drv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+
+static inline int drv_set_antenna(struct ieee80211_local *local,
+				  u32 tx_ant, u32 rx_ant)
+{
+	int ret = -EOPNOTSUPP;
+	might_sleep();
+	if (local->ops->set_antenna)
+		ret = local->ops->set_antenna(&local->hw, tx_ant, rx_ant);
+	trace_drv_set_antenna(local, tx_ant, rx_ant, ret);
+	return ret;
+}
+
+static inline int drv_get_antenna(struct ieee80211_local *local,
+				  u32 *tx_ant, u32 *rx_ant)
+{
+	int ret = -EOPNOTSUPP;
+	might_sleep();
+	if (local->ops->get_antenna)
+		ret = local->ops->get_antenna(&local->hw, tx_ant, rx_ant);
+	trace_drv_get_antenna(local, *tx_ant, *rx_ant, ret);
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6831fb1..7773fb9 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -862,6 +862,56 @@ TRACE_EVENT(drv_channel_switch,
 	)
 );
 
+TRACE_EVENT(drv_set_antenna,
+	TP_PROTO(struct ieee80211_local *local, u32 tx_ant, u32 rx_ant, int ret),
+
+	TP_ARGS(local, tx_ant, rx_ant, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, tx_ant)
+		__field(u32, rx_ant)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->tx_ant = tx_ant;
+		__entry->rx_ant = rx_ant;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " tx_ant:%d rx_ant:%d ret:%d",
+		LOCAL_PR_ARG, __entry->tx_ant, __entry->rx_ant, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_get_antenna,
+	TP_PROTO(struct ieee80211_local *local, u32 tx_ant, u32 rx_ant, int ret),
+
+	TP_ARGS(local, tx_ant, rx_ant, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, tx_ant)
+		__field(u32, rx_ant)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->tx_ant = tx_ant;
+		__entry->rx_ant = rx_ant;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " tx_ant:%d rx_ant:%d ret:%d",
+		LOCAL_PR_ARG, __entry->tx_ant, __entry->rx_ant, __entry->ret
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */

