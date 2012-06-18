Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62282 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab2FRK6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 06:58:06 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [RFC 5/5] mac80211: bind prepare_multicast callback to subif.
Date: Mon, 18 Jun 2012 12:57:15 +0200
Message-ID: <1340017035-7657-6-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120618_125812_900273_0DF38F46)
In-Reply-To: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
References: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver is now aware for which virtual interace the multicast
is being configured.

ieee80211_sub_if_data *sdata parameter is added to
drv_prepare_multicast.

vieee80211_vif *vif parameter is added to driver's
prepare_multicast callback.

Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
---
 include/net/mac80211.h      |    1 +
 net/mac80211/driver-ops.h   |    6 ++++--
 net/mac80211/driver-trace.h |   12 ++++++++----
 net/mac80211/main.c         |    2 +-
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c515a6f..39ebba0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2280,6 +2280,7 @@ struct ieee80211_ops {
 				 u32 changed);
 
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index cfc4a35..e27dd48 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -222,14 +222,16 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 }
 
 static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
+					struct ieee80211_sub_if_data *sdata,
 					struct netdev_hw_addr_list *mc_list)
 {
 	u64 ret = 0;
 
-	trace_drv_prepare_multicast(local, mc_list->count);
+	trace_drv_prepare_multicast(local, sdata, mc_list->count);
 
 	if (local->ops->prepare_multicast)
-		ret = local->ops->prepare_multicast(&local->hw, mc_list);
+		ret = local->ops->prepare_multicast(&local->hw, &sdata->vif,
+						    mc_list);
 
 	trace_drv_return_u64(local, ret);
 
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index ad99338..2226816 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -338,23 +338,27 @@ TRACE_EVENT(drv_bss_info_changed,
 );
 
 TRACE_EVENT(drv_prepare_multicast,
-	TP_PROTO(struct ieee80211_local *local, int mc_count),
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 int mc_count),
 
-	TP_ARGS(local, mc_count),
+	TP_ARGS(local, sdata, mc_count),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		VIF_ENTRY
 		__field(int, mc_count)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		VIF_ASSIGN;
 		__entry->mc_count = mc_count;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " prepare mc (%d)",
-		LOCAL_PR_ARG, __entry->mc_count
+		LOCAL_PR_FMT VIF_PR_FMT " prepare mc (%d)",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->mc_count
 	)
 );
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b00eb59..6541c74 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -67,7 +67,7 @@ void ieee80211_configure_filter(struct ieee80211_sub_if_data *sdata)
 	spin_lock_bh(&sdata->filter_lock);
 	changed_flags = sdata->filter_flags ^ new_flags;
 
-	mc = drv_prepare_multicast(local, &sdata->mc_list);
+	mc = drv_prepare_multicast(local, sdata, &sdata->mc_list);
 	spin_unlock_bh(&sdata->filter_lock);
 
 	/* be a bit nasty */
-- 
1.7.0.4

