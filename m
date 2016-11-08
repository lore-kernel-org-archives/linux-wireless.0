Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3213 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbcKHNP3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 08:15:29 -0500
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 3/4] mac80211: Add support to enable or disable btcoex
Date: Tue, 8 Nov 2016 18:45:31 +0530
Message-ID: <1478610932-21954-4-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161108_141532_532516_C368E67D)
In-Reply-To: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch introduces a new driver call back drv_set_btcoex
This API will pass user space value to driver to
enable or disabe btcoex.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 include/net/mac80211.h    |    4 ++++
 net/mac80211/cfg.c        |    8 ++++++++
 net/mac80211/driver-ops.h |   14 ++++++++++++++
 net/mac80211/trace.h      |   14 ++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b9b24ab..e7db763 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3453,6 +3453,9 @@ enum ieee80211_reconfig_type {
  * @del_nan_func: Remove a NAN function. The driver must call
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
+ *
+ * @set_btcoex_: set_btcoex: Called when BTCOEX is enabled/disabled, use
+ *	this callback to enable or disable btcoex.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3705,6 +3708,7 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+	int (*set_btcoex)(struct ieee80211_hw *hw, bool enabled);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index eb68add..a687056 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3562,6 +3562,13 @@ void ieee80211_nan_func_match(struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_nan_func_match);
 
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
@@ -3652,4 +3659,5 @@ void ieee80211_nan_func_match(struct ieee80211_vif *vif,
 	.nan_change_conf = ieee80211_nan_change_conf,
 	.add_nan_func = ieee80211_add_nan_func,
 	.del_nan_func = ieee80211_del_nan_func,
+	.set_btcoex = ieee80211_set_btcoex,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 09f77e4..16d9c98 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1248,4 +1248,18 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_set_btcoex(struct ieee80211_local *local,
+				 bool enabled)
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
index 92a47af..760dfb6 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -742,6 +742,20 @@
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
+	TP_printk(LOCAL_PR_FMT " enabled:%d", LOCAL_PR_ARG, __entry->enabled)
+);
+
 TRACE_EVENT(drv_set_coverage_class,
 	TP_PROTO(struct ieee80211_local *local, s16 value),
 
-- 
1.7.9.5
