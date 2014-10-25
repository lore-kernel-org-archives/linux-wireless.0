Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:44680
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751085AbaJYWc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 18:32:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2] mac80211: add support for driver tx power reporting
Date: Sun, 26 Oct 2014 00:32:53 +0200
Message-Id: <1414276373-45058-1-git-send-email-nbd@openwrt.org> (sfid-20141026_003300_313871_6ADB1767)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The configured tx power is often limited by hardware capabilities,
channel settings, antenna configuration, etc.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h    |  5 +++++
 net/mac80211/cfg.c        |  3 +++
 net/mac80211/driver-ops.h | 14 ++++++++++++++
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0ad1f47..41b0e60 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2838,6 +2838,9 @@ enum ieee80211_roc_type {
  * @get_expected_throughput: extract the expected throughput towards the
  *	specified station. The returned value is expressed in Kbps. It returns 0
  *	if the RC algorithm does not have proper data to provide.
+ *
+ * @get_txpower: get current maximum tx power (in dBm) based on configuration
+ *	and hardware limits.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3039,6 +3042,8 @@ struct ieee80211_ops {
 	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
+	int (*get_txpower)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   int *dbm);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fb6a150..df38198 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2081,6 +2081,9 @@ static int ieee80211_get_tx_power(struct wiphy *wiphy,
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
+	if (local->ops->get_txpower)
+		return drv_get_txpower(local, sdata, dbm);
+
 	if (!local->use_chanctx)
 		*dbm = local->hw.conf.power_level;
 	else
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 196d48c..78c93de 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1238,4 +1238,18 @@ static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_get_txpower(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata, int *dbm)
+{
+	int ret;
+
+	if (!local->ops->get_txpower)
+		return -EOPNOTSUPP;
+
+	ret = local->ops->get_txpower(&local->hw, &sdata->vif, dbm);
+	trace_drv_get_txpower(local, sdata, *dbm, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 38fae7e..c4150d1 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2106,6 +2106,33 @@ TRACE_EVENT(drv_channel_switch_beacon,
 	)
 );
 
+TRACE_EVENT(drv_get_txpower,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 int dbm, int ret),
+
+	TP_ARGS(local, sdata, dbm, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		SDATA_ENTRY
+		__field(int, dbm)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		SDATA_ASSIGN;
+		__entry->dbm = dbm;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT STA_PR_FMT " dbm:%d ret:%d",
+		LOCAL_PR_ARG, STA_PR_ARG, __entry->dbm, __entry->ret
+	)
+);
+
 
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
-- 
2.1.2

