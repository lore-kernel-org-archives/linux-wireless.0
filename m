Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51830 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033174AbeCAR7n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 12:59:43 -0500
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 2/2] mac80211: Add support to enable or disable btcoex
Date: Thu,  1 Mar 2018 23:29:30 +0530
Message-Id: <1519927170-11920-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180301_185947_119843_A4C90CAF)
In-Reply-To: <1519927170-11920-1-git-send-email-tamizhr@codeaurora.org>
References: <1519927170-11920-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

This patch introduces a new driver call back drv_set_btcoex
to enable/disable btcoex.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h    |    2 ++
 net/mac80211/cfg.c        |    8 ++++++++
 net/mac80211/driver-ops.h |   13 +++++++++++++
 net/mac80211/trace.h      |   17 +++++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2fd59ed..45d4281 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3487,6 +3487,7 @@ enum ieee80211_reconfig_type {
  * @del_nan_func: Remove a NAN function. The driver must call
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
+ * @set_btcoex: To enable/disable btcoex. Returns 0 on success.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3768,6 +3769,7 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+	int (*set_btcoex)(struct ieee80211_hw *hw, bool enabled);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fd68f6f..1a939c1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3694,6 +3694,13 @@ static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_btcoex(struct wiphy *wiphy, bool enabled)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_set_btcoex(local, enabled);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3786,4 +3793,5 @@ static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
 	.add_nan_func = ieee80211_add_nan_func,
 	.del_nan_func = ieee80211_del_nan_func,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
+	.set_btcoex = ieee80211_set_btcoex,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4d82fe7..c424e17 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1250,4 +1250,17 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_set_btcoex(struct ieee80211_local *local, bool enabled)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_drv_set_btcoex(local, enabled);
+	if (local->ops->set_btcoex)
+		ret = local->ops->set_btcoex(&local->hw, enabled);
+
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 591ad02..e30e0b1 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -746,6 +746,23 @@
 	TP_ARGS(local, value)
 );
 
+TRACE_EVENT(drv_set_btcoex,
+	TP_PROTO(struct ieee80211_local *local, bool enabled),
+	TP_ARGS(local, enabled),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(bool, enabled)
+	),
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->enabled = enabled;
+	),
+	TP_printk(
+		LOCAL_PR_FMT " enabled:%d ",
+		LOCAL_PR_ARG, __entry->enabled
+	)
+);
+
 TRACE_EVENT(drv_set_coverage_class,
 	TP_PROTO(struct ieee80211_local *local, s16 value),
 
-- 
1.7.9.5
