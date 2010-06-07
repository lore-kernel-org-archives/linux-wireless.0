Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:48919 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751674Ab0FGG6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 02:58:53 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0708983931
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 15:58:52 +0900 (JST)
Subject: [PATCH v3 2/3] mac80211: Add antenna configuration
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 07 Jun 2010 15:59:04 +0900
Message-ID: <20100607065903.16060.73955.stgit@tt-desk>
In-Reply-To: <20100607065858.16060.38448.stgit@tt-desk>
References: <20100607065858.16060.38448.stgit@tt-desk>
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
index e3c1d47..e0688a9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1732,6 +1732,8 @@ struct ieee80211_ops {
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
+	int (*set_antenna)(struct ieee80211_hw *hw, u8 tx_ant, u8 rx_ant);
+	int (*get_antenna)(struct ieee80211_hw *hw, u8 *tx_ant, u8 *rx_ant);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 952845e..2e4d947 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1560,6 +1560,20 @@ static int ieee80211_action(struct wiphy *wiphy, struct net_device *dev,
 				    buf, len, cookie);
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
index d1139e4..edb4b4e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -393,4 +393,27 @@ static inline void drv_channel_switch(struct ieee80211_local *local,
 	trace_drv_channel_switch(local, ch_switch);
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
index 6b90630..31bf664 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -827,6 +827,56 @@ TRACE_EVENT(drv_channel_switch,
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

