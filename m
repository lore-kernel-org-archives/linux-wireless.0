Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62282 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2FRK6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 06:58:05 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [RFC 3/5] mac80211: bind driver's filter callback to subif
Date: Mon, 18 Jun 2012 12:57:13 +0200
Message-ID: <1340017035-7657-4-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120618_125818_291712_503739CF)
In-Reply-To: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
References: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver is now aware for which virtual interface
the RX filter is being configured.

ieee80211_sub_if_data *sdata argument is added to
drv_configure_filter.

ieee80211_vif *vif argument is added to driver's
configure_filter callback.

Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
---
 include/net/mac80211.h      |    1 +
 net/mac80211/driver-ops.h   |    7 ++++---
 net/mac80211/driver-trace.h |    9 ++++++---
 net/mac80211/main.c         |    2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6914f99..c515a6f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2282,6 +2282,7 @@ struct ieee80211_ops {
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
 				 u64 multicast);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 6d33a0c..cfc4a35 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -237,16 +237,17 @@ static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 }
 
 static inline void drv_configure_filter(struct ieee80211_local *local,
+					struct ieee80211_sub_if_data *sdata,
 					unsigned int changed_flags,
 					unsigned int *total_flags,
 					u64 multicast)
 {
 	might_sleep();
 
-	trace_drv_configure_filter(local, changed_flags, total_flags,
+	trace_drv_configure_filter(local, sdata, changed_flags, total_flags,
 				   multicast);
-	local->ops->configure_filter(&local->hw, changed_flags, total_flags,
-				     multicast);
+	local->ops->configure_filter(&local->hw, &sdata->vif, changed_flags,
+				     total_flags, multicast);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6de00b2..ad99338 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -360,14 +360,16 @@ TRACE_EVENT(drv_prepare_multicast,
 
 TRACE_EVENT(drv_configure_filter,
 	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
 		 unsigned int changed_flags,
 		 unsigned int *total_flags,
 		 u64 multicast),
 
-	TP_ARGS(local, changed_flags, total_flags, multicast),
+	TP_ARGS(local, sdata, changed_flags, total_flags, multicast),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		VIF_ENTRY
 		__field(unsigned int, changed)
 		__field(unsigned int, total)
 		__field(u64, multicast)
@@ -375,14 +377,15 @@ TRACE_EVENT(drv_configure_filter,
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		VIF_ASSIGN;
 		__entry->changed = changed_flags;
 		__entry->total = *total_flags;
 		__entry->multicast = multicast;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " changed:%#x total:%#x",
-		LOCAL_PR_ARG, __entry->changed, __entry->total
+		LOCAL_PR_FMT VIF_PR_FMT " changed:%#x total:%#x",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->changed, __entry->total
 	)
 );
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6adc1d2..057e098 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -73,7 +73,7 @@ void ieee80211_configure_filter(struct ieee80211_sub_if_data *sdata)
 	/* be a bit nasty */
 	new_flags |= (1<<31);
 
-	drv_configure_filter(local, changed_flags, &new_flags, mc);
+	drv_configure_filter(local, sdata, changed_flags, &new_flags, mc);
 
 	WARN_ON(new_flags & (1<<31));
 
-- 
1.7.0.4

