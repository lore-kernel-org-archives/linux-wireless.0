Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30152 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752770AbdDKKOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 06:14:12 -0400
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv4 2/2] mac80211: Add support to enable or disable btcoex and set btcoex priority value
Date: Tue, 11 Apr 2017 15:45:30 +0530
Message-ID: <1491905730-16392-3-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170411_121448_780874_FCBF8571)
In-Reply-To: <1491905730-16392-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1491905730-16392-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch introduces a new driver call back drv_set_btcoex.
This API will pass user space value to driver to
enable or disabe btcoex and set or modify the btcoex priority value.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 include/net/mac80211.h    |    5 +++++
 net/mac80211/cfg.c        |    9 +++++++++
 net/mac80211/driver-ops.h |   15 +++++++++++++++
 net/mac80211/trace.h      |   20 ++++++++++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b1ac872..865eb7f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3453,6 +3453,9 @@ enum ieee80211_reconfig_type {
  * @del_nan_func: Remove a NAN function. The driver must call
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
+ * @set_btcoex: Called when BTCOEX is enabled/disabled, use
+ *     this callback to enable or disable btcoex and use this callback to
+ *     set btcoex_priority. BTCOEX should be enabled to set this priority.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3734,6 +3737,8 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+	int (*set_btcoex)(struct ieee80211_hw *hw, bool enabled,
+			  u32 btcoex_priority);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8bc3d366..512e5f7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3617,6 +3617,14 @@ static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_btcoex(struct wiphy *wiphy, bool enabled,
+				u32 btcoex_priority)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_set_btcoex(local, enabled, btcoex_priority);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3709,4 +3717,5 @@ static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
 	.add_nan_func = ieee80211_add_nan_func,
 	.del_nan_func = ieee80211_del_nan_func,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
+	.set_btcoex = ieee80211_set_btcoex,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 09f77e4..c420da5 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1248,4 +1248,19 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_set_btcoex(struct ieee80211_local *local,
+				 bool enabled, u32 btcoex_priority)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_drv_set_btcoex(local, enabled, btcoex_priority);
+	if (local->ops->set_btcoex)
+		ret = local->ops->set_btcoex(&local->hw, enabled,
+					     btcoex_priority);
+
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0d645bc..3a4621e 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -742,6 +742,26 @@
 	TP_ARGS(local, value)
 );
 
+TRACE_EVENT(drv_set_btcoex,
+	TP_PROTO(struct ieee80211_local *local, bool enabled,
+		 u32 btcoex_priority),
+	TP_ARGS(local, enabled, btcoex_priority),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(bool, enabled)
+		__field(u32, btcoex_priority)
+	),
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->enabled = enabled;
+		__entry->btcoex_priority = btcoex_priority;
+	),
+	TP_printk(
+		LOCAL_PR_FMT " enabled:%d btcoex_priority :%u",
+		LOCAL_PR_ARG, __entry->enabled, __entry->btcoex_priority
+	)
+);
+
 TRACE_EVENT(drv_set_coverage_class,
 	TP_PROTO(struct ieee80211_local *local, s16 value),
 
-- 
1.7.9.5
