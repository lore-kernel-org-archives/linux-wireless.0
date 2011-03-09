Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32934 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1CIUbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 15:31:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: bloat-devel@lists.bufferbloat.net, me@bobcopeland.com,
	mickflemm@gmail.com, johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 2/3] mac80211: implement support for cfg80211_ops->{get,set}_ringparam
Date: Wed,  9 Mar 2011 15:23:39 -0500
Message-Id: <1299702219-23905-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1299687684-19638-2-git-send-email-linville@tuxdriver.com>
References: <1299687684-19638-2-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/mac80211.h      |    7 +++++
 net/mac80211/cfg.c          |   17 ++++++++++++++
 net/mac80211/driver-ops.h   |   26 +++++++++++++++++++++
 net/mac80211/driver-trace.h |   52 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2b072fa..8650e7b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1804,6 +1804,10 @@ enum ieee80211_ampdu_mlme_action {
  *	return value is 1, then the @remain_on_channel will be used with a
  *	regular transmission (if supported.)
  * @offchannel_tx_cancel_wait: cancel wait associated with offchannel TX
+ *
+ * @set_ringparam: Set tx and rx ring sizes.
+ *
+ * @get_ringparam: Get tx and rx ring current and maximum sizes.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1888,6 +1892,9 @@ struct ieee80211_ops {
 			     enum nl80211_channel_type channel_type,
 			     unsigned int wait);
 	int (*offchannel_tx_cancel_wait)(struct ieee80211_hw *hw);
+	int (*set_ringparam)(struct ieee80211_hw *hw, u32 tx, u32 rx);
+	void (*get_ringparam)(struct ieee80211_hw *hw,
+			      u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7b701dc..bd1791c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2008,6 +2008,21 @@ static int ieee80211_get_antenna(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant)
 	return drv_get_antenna(local, tx_ant, rx_ant);
 }
 
+static int ieee80211_set_ringparam(struct wiphy *wiphy, u32 tx, u32 rx)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_set_ringparam(local, tx, rx);
+}
+
+static void ieee80211_get_ringparam(struct wiphy *wiphy,
+				    u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	drv_get_ringparam(local, tx, tx_max, rx, rx_max);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -2065,4 +2080,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 	.set_antenna = ieee80211_set_antenna,
 	.get_antenna = ieee80211_get_antenna,
+	.set_ringparam = ieee80211_set_ringparam,
+	.get_ringparam = ieee80211_get_ringparam,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 3729296..9c0d62b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -526,4 +526,30 @@ static inline int drv_offchannel_tx_cancel_wait(struct ieee80211_local *local)
 	return ret;
 }
 
+static inline int drv_set_ringparam(struct ieee80211_local *local,
+				    u32 tx, u32 rx)
+{
+	int ret = -ENOTSUPP;
+
+	might_sleep();
+
+	trace_drv_set_ringparam(local, tx, rx);
+	if (local->ops->set_ringparam)
+		ret = local->ops->set_ringparam(&local->hw, tx, rx);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline void drv_get_ringparam(struct ieee80211_local *local,
+				     u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max)
+{
+	might_sleep();
+
+	trace_drv_get_ringparam(local, tx, tx_max, rx, rx_max);
+	if (local->ops->get_ringparam)
+		local->ops->get_ringparam(&local->hw, tx, tx_max, rx, rx_max);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 520fe24..f50ae2c 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -912,6 +912,58 @@ TRACE_EVENT(drv_offchannel_tx,
 	)
 );
 
+TRACE_EVENT(drv_set_ringparam,
+	TP_PROTO(struct ieee80211_local *local, u32 tx, u32 rx),
+
+	TP_ARGS(local, tx, rx),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, tx)
+		__field(u32, rx)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->tx = tx;
+		__entry->rx = rx;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " tx:%d rx %d",
+		LOCAL_PR_ARG, __entry->tx, __entry->rx,
+	)
+);
+
+TRACE_EVENT(drv_get_ringparam,
+	TP_PROTO(struct ieee80211_local *local, u32 *tx, u32 *tx_max,
+		 u32 *rx, u32 *rx_max),
+
+	TP_ARGS(local, tx, tx_max, rx, rx_max),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, tx)
+		__field(u32, tx_max)
+		__field(u32, rx)
+		__field(u32, rx_max)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->tx = *tx;
+		__entry->tx_max = *tx_max;
+		__entry->rx = *rx;
+		__entry->rx_max = *rx_max;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " tx:%d tx_max %d rx %d rx_max %d",
+		LOCAL_PR_ARG,
+		__entry->tx, __entry->tx_max, __entry->rx, __entry->rx_max,
+	)
+);
+
 DEFINE_EVENT(local_only_evt, drv_offchannel_tx_cancel_wait,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-- 
1.7.4

