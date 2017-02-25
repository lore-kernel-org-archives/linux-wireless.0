Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24379 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751661AbdBYNwJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Feb 2017 08:52:09 -0500
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <ath10k@lists.infradead.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv2 2/4] mac80211: Add support to enable or disable btcoex
Date: Sat, 25 Feb 2017 19:07:51 +0530
Message-ID: <1488029873-14600-3-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170225_145212_407602_25D263C3)
In-Reply-To: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
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
 include/net/mac80211.h    |    3 +++
 net/mac80211/cfg.c        |    8 ++++++++
 net/mac80211/driver-ops.h |   14 ++++++++++++++
 net/mac80211/trace.h      |   14 ++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b9a08cd..57717f1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3447,6 +3447,8 @@ enum ieee80211_reconfig_type {
  * @del_nan_func: Remove a NAN function. The driver must call
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
+ * @set_btcoex_: Called when BTCOEX is enabled/disabled, use
+ *     this callback to enable or disable btcoex.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3728,6 +3730,7 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+	int (*set_btcoex)(struct ieee80211_hw *hw, bool enabled);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ac879bb..7e17eff 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3574,6 +3574,13 @@ static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
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
@@ -3665,4 +3672,5 @@ static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
 	.add_nan_func = ieee80211_add_nan_func,
 	.del_nan_func = ieee80211_del_nan_func,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
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
index 0d645bc..0d9b5a0 100644
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
