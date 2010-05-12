Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:43365 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754138Ab0ELIXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 04:23:33 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0255192611
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 17:23:32 +0900 (JST)
Subject: [PATCH 2/3] mac80211: Add antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Wed, 12 May 2010 17:23:31 +0900
Message-ID: <20100512082331.26565.61521.stgit@tt-desk>
In-Reply-To: <20100512082231.26565.16730.stgit@tt-desk>
References: <20100512082231.26565.16730.stgit@tt-desk>
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
index 9448a5b..1a8f97a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1694,6 +1694,8 @@ struct ieee80211_ops {
 	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
 #endif
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
+	int (*set_antenna)(struct ieee80211_hw *hw, u8 tx_ant, u8 rx_ant);
+	int (*get_antenna)(struct ieee80211_hw *hw, u8 *tx_ant, u8 *rx_ant);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c7000a6..efd04bc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1560,6 +1560,20 @@ static int ieee80211_action(struct wiphy *wiphy, struct net_device *dev,
 				    channel_type, buf, len, cookie);
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
@@ -1611,4 +1625,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.action = ieee80211_action,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.set_antenna = ieee80211_set_antenna,
+	.get_antenna = ieee80211_get_antenna,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 997008e..f1b031a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -373,4 +373,27 @@ static inline void drv_flush(struct ieee80211_local *local, bool drop)
 	if (local->ops->flush)
 		local->ops->flush(&local->hw, drop);
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
index ce734b5..466a509 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -774,6 +774,56 @@ TRACE_EVENT(drv_flush,
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

