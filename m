Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62413 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab1LWMX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 07:23:29 -0500
Received: by wibhm6 with SMTP id hm6so3120540wib.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 04:23:28 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] mac80211: add sta_state callback
Date: Fri, 23 Dec 2011 14:24:35 +0200
Message-Id: <1324643075-29385-4-git-send-email-eliad@wizery.com> (sfid-20111223_132332_345050_C74F9DC5)
In-Reply-To: <1324643075-29385-1-git-send-email-eliad@wizery.com>
References: <1324643075-29385-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a callback to notify the low-level driver whenever
the state of an "uploaded" station was changed.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/mac80211.h      |    7 +++++++
 net/mac80211/driver-ops.h   |   17 +++++++++++++++++
 net/mac80211/driver-trace.h |   28 ++++++++++++++++++++++++++++
 net/mac80211/sta_info.c     |    6 ++++++
 4 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 053b14a..f5f59dd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1973,6 +1973,10 @@ enum ieee80211_frame_release_type {
  *	in AP mode, this callback will not be called when the flag
  *	%IEEE80211_HW_AP_LINK_PS is set. Must be atomic.
  *
+ * @sta_state: Notifies low level driver about state transition of an
+ *	associated station, IBSS/WDS/mesh peer etc.
+ *	The callback can sleep.
+ *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
  *	Returns a negative error code on failure.
@@ -2192,6 +2196,9 @@ struct ieee80211_ops {
 			  struct ieee80211_sta *sta);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
+	void (*sta_state)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta,
+			  enum ieee80211_sta_state state);
 	int (*conf_tx)(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e8960ae..e05d1a2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -476,6 +476,23 @@ static inline void drv_sta_remove(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_sta_state(struct ieee80211_local *local,
+				 struct ieee80211_sub_if_data *sdata,
+				 struct ieee80211_sta *sta,
+				 enum ieee80211_sta_state state)
+{
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	check_sdata_in_driver(sdata);
+
+	trace_drv_sta_state(local, sdata, sta, state);
+	if (local->ops->sta_state)
+		local->ops->sta_state(&local->hw, &sdata->vif, sta,
+				      state);
+	trace_drv_return_void(local);
+}
+
 static inline int drv_conf_tx(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata, u16 queue,
 			      const struct ieee80211_tx_queue_params *params)
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6e9df8f..9416428 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -635,6 +635,34 @@ TRACE_EVENT(drv_sta_notify,
 	)
 );
 
+TRACE_EVENT(drv_sta_state,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 enum ieee80211_sta_state state),
+
+	TP_ARGS(local, sdata, sta, state),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u32, state)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->state = state;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " state:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->state
+	)
+);
+
 TRACE_EVENT(drv_sta_add,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 66e2de6..4fa9124 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1450,6 +1450,12 @@ int sta_info_move_state_checked(struct sta_info *sta,
 
 	printk(KERN_DEBUG "%s: moving STA %pM to state %d\n",
 		sta->sdata->name, sta->sta.addr, new_state);
+	/*
+	 * notify the driver before the actual change, so it will be
+	 * able to determine the transition
+	 */
+	if (sta->uploaded)
+		drv_sta_state(sta->local, sta->sdata, &sta->sta, new_state);
 	sta->sta.state = new_state;
 
 	return 0;
-- 
1.7.6.401.g6a319

