Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:12750 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752675Ab0G0JsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 05:48:07 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0317754085
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 18:48:05 +0900 (JST)
Subject: [PATCH v4 2/3] mac80211: Add antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Date: Tue, 27 Jul 2010 18:48:05 +0900
Message-ID: <20100727094805.27186.62514.stgit@tt-desk>
In-Reply-To: <20100727094732.27186.30900.stgit@tt-desk>
References: <20100727094732.27186.30900.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow antenna configuration by calling driver's function for it.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/net/mac80211.h      |    2 ++
 net/mac80211/cfg.c          |   16 ++++++++++++++
 net/mac80211/driver-ops.h   |   23 ++++++++++++++++++++
 net/mac80211/driver-trace.h |   50 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 20d372e..f8e04d1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1744,6 +1744,8 @@ struct ieee80211_ops {
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
+	int (*set_antenna)(struct ieee80211_hw *hw, u8 tx_ant, u8 rx_ant);
+	int (*get_antenna)(struct ieee80211_hw *hw, u8 *tx_ant, u8 *rx_ant);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f09a52d..7b99e6a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1598,6 +1598,20 @@ static int ieee80211_action(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_set_antenna(struct wiphy *wiphy, u8 tx_ant, u8 rx_ant)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_set_antenna(local, tx_ant, rx_ant);
+}
+
+static int ieee80211_get_antenna(struct wiphy *wiphy, u8 *tx_ant, u8 *rx_ant)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_get_antenna(local, tx_ant, rx_ant);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1649,4 +1663,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.action = ieee80211_action,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.set_antenna = ieee80211_set_antenna,
+	.get_antenna = ieee80211_get_antenna,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 14123dc..0aa6399 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -414,4 +414,27 @@ static inline void drv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+
+static inline int drv_set_antenna(struct ieee80211_local *local,
+				  u8 tx_ant, u8 rx_ant)
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
+				  u8 *tx_ant, u8 *rx_ant)
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
index 5d5d2a9..3aac91b 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -832,6 +832,56 @@ TRACE_EVENT(drv_channel_switch,
 	)
 );
 
+TRACE_EVENT(drv_set_antenna,
+	TP_PROTO(struct ieee80211_local *local, u8 tx_ant, u8 rx_ant, int ret),
+
+	TP_ARGS(local, tx_ant, rx_ant, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u8, tx_ant)
+		__field(u8, rx_ant)
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
+	TP_PROTO(struct ieee80211_local *local, u8 tx_ant, u8 rx_ant, int ret),
+
+	TP_ARGS(local, tx_ant, rx_ant, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u8, tx_ant)
+		__field(u8, rx_ant)
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

