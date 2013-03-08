Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3CHLOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 06:14:33 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: add driver callback for per-interface multicast filter
Date: Fri,  8 Mar 2013 12:14:27 +0100
Message-Id: <1362741267-19387-1-git-send-email-johannes@sipsolutions.net> (sfid-20130308_121443_550811_F496A6E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Some devices have multicast filter capability for each individual
virtual interface rather than just a global one. Add an interface
specific driver callback allowing such drivers to configure this.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |  7 +++++++
 net/mac80211/driver-ops.h | 16 ++++++++++++++++
 net/mac80211/iface.c      |  3 +++
 net/mac80211/trace.h      | 24 ++++++++++++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f940296..d5bc60c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2261,6 +2261,9 @@ enum ieee80211_roc_type {
  *	See the section "Frame filtering" for more information.
  *	This callback must be implemented and can sleep.
  *
+ * @set_multicast_list: Configure the device's interface specific RX multicast
+ *	filter. This callback is optional. This callback must be atomic.
+ *
  * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
  * 	must be set or cleared for a given STA. Must be atomic.
  *
@@ -2610,6 +2613,10 @@ struct ieee80211_ops {
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
 				 u64 multicast);
+	void (*set_multicast_list)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif, bool allmulti,
+				   struct netdev_hw_addr_list *mc_list);
+
 	int (*set_tim)(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		       bool set);
 	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 33f99b9..a8b8cf1 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -241,6 +241,22 @@ static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline void drv_set_multicast_list(struct ieee80211_local *local,
+					  struct ieee80211_sub_if_data *sdata,
+					  struct netdev_hw_addr_list *mc_list)
+{
+	bool allmulti = sdata->flags & IEEE80211_SDATA_ALLMULTI;
+
+	trace_drv_set_multicast_list(local, sdata, mc_list->count);
+
+	check_sdata_in_driver(sdata);
+
+	if (local->ops->set_multicast_list)
+		local->ops->set_multicast_list(&local->hw, &sdata->vif,
+					       allmulti, mc_list);
+	trace_drv_return_void(local);
+}
+
 static inline void drv_configure_filter(struct ieee80211_local *local,
 					unsigned int changed_flags,
 					unsigned int *total_flags,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b22ee2f..3afa831 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -919,6 +919,9 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 			atomic_dec(&local->iff_promiscs);
 		sdata->flags ^= IEEE80211_SDATA_PROMISC;
 	}
+
+	drv_set_multicast_list(local, sdata, &dev->mc);
+
 	spin_lock_bh(&local->filter_lock);
 	__hw_addr_sync(&local->mc_list, &dev->mc, dev->addr_len);
 	spin_unlock_bh(&local->filter_lock);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index f18f32b..c589979 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -431,6 +431,30 @@ TRACE_EVENT(drv_prepare_multicast,
 	)
 );
 
+TRACE_EVENT(drv_set_multicast_list,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata, int mc_count),
+
+	TP_ARGS(local, sdata, mc_count),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(bool, allmulti)
+		__field(int, mc_count)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->allmulti = sdata->flags & IEEE80211_SDATA_ALLMULTI;
+		__entry->mc_count = mc_count;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " configure mc filter, count=%d, allmulti=%d",
+		LOCAL_PR_ARG, __entry->mc_count, __entry->allmulti
+	)
+);
+
 TRACE_EVENT(drv_configure_filter,
 	TP_PROTO(struct ieee80211_local *local,
 		 unsigned int changed_flags,
-- 
1.8.0

