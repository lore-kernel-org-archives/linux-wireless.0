Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:39310
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753595AbaKRWih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 17:38:37 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: notify drivers on sta rate table changes
Date: Tue, 18 Nov 2014 23:38:35 +0100
Message-Id: <1416350315-82818-1-git-send-email-nbd@openwrt.org> (sfid-20141118_233840_529376_11680664)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This allows drivers with a firmware or chip-based rate lookup table to
use the most recent default rate selection without having to get it from
per-packet data or explicit ieee80211_get_tx_rate calls

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h    |  6 ++++++
 net/mac80211/driver-ops.h | 14 ++++++++++++++
 net/mac80211/rate.c       |  3 +++
 net/mac80211/trace.h      |  7 +++++++
 4 files changed, 30 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 28ea999..b5b4ea2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2631,6 +2631,9 @@ enum ieee80211_reconfig_type {
  *	uses hardware rate control (%IEEE80211_HW_HAS_RATE_CONTROL) since
  *	otherwise the rate control algorithm is notified directly.
  *	Must be atomic.
+ * @sta_rate_tbl_update: Notifies the driver that the rate table changed. This
+ *	is only used if the configured rate control algorithm actually uses
+ *	the new rate table API, and is therefore optional. Must be atomic.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
@@ -2972,6 +2975,9 @@ struct ieee80211_ops {
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
 			      u32 changed);
+	void (*sta_rate_tbl_update)(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif, u16 ac,
 		       const struct ieee80211_tx_queue_params *params);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 9759dd1..ba8db1b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -621,6 +621,20 @@ static inline void drv_sta_rc_update(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_sta_rate_tbl_update(struct ieee80211_local *local,
+					   struct ieee80211_sub_if_data *sdata,
+					   struct ieee80211_sta *sta)
+{
+	sdata = get_bss_sdata(sdata);
+	check_sdata_in_driver(sdata);
+
+	trace_drv_sta_rate_tbl_update(local, sdata, sta);
+	if (local->ops->sta_rate_tbl_update)
+		local->ops->sta_rate_tbl_update(&local->hw, &sdata->vif, sta);
+
+	trace_drv_return_void(local);
+}
+
 static inline int drv_conf_tx(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata, u16 ac,
 			      const struct ieee80211_tx_queue_params *params)
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 6081329..7dea81d 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -696,6 +696,7 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *pubsta,
 			   struct ieee80211_sta_rates *rates)
 {
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_sta_rates *old;
 
 	/*
@@ -709,6 +710,8 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 	if (old)
 		kfree_rcu(old, rcu_head);
 
+	drv_sta_rate_tbl_update(hw_to_local(hw), sta->sdata, pubsta);
+
 	return 0;
 }
 EXPORT_SYMBOL(rate_control_set_rates);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 809a498..5753379 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -826,6 +826,13 @@ DEFINE_EVENT(sta_event, drv_sta_pre_rcu_remove,
 	TP_ARGS(local, sdata, sta)
 );
 
+DEFINE_EVENT(sta_event, drv_sta_rate_tbl_update,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
+);
+
 TRACE_EVENT(drv_conf_tx,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
2.1.2

