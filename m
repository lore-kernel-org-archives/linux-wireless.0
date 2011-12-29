Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48678 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356Ab1L2MkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 07:40:16 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id d3so2600118lah.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2011 04:40:15 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 3/3] mac80211: add sta_state callback
Date: Thu, 29 Dec 2011 14:41:41 +0200
Message-Id: <1325162501-7996-4-git-send-email-eliad@wizery.com> (sfid-20111229_134031_023910_BABC9787)
In-Reply-To: <1325162501-7996-1-git-send-email-eliad@wizery.com>
References: <1325162501-7996-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a callback to notify the low-level driver whenever
the state of an "uploaded" station was changed.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: call drv_sta_state() within the sta addition process (thanks Johannes)

 include/net/mac80211.h      |    7 +++++++
 net/mac80211/driver-ops.h   |   17 +++++++++++++++++
 net/mac80211/driver-trace.h |   28 ++++++++++++++++++++++++++++
 net/mac80211/sta_info.c     |   13 ++++++++++++-
 net/mac80211/util.c         |    9 ++++++++-
 5 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cec5610..55b657f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1981,6 +1981,10 @@ enum ieee80211_frame_release_type {
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
@@ -2200,6 +2204,9 @@ struct ieee80211_ops {
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
index 66e2de6..672a170 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -392,8 +392,13 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 			printk(KERN_DEBUG "%s: failed to add IBSS STA %pM to "
 					  "driver (%d) - keeping it anyway.\n",
 			       sdata->name, sta->sta.addr, err);
-		} else
+		} else {
+			enum ieee80211_sta_state state = IEEE80211_STA_NONE;
+
 			sta->uploaded = true;
+			while (state < sta->sta.state)
+				drv_sta_state(local, sdata, &sta->sta, ++state);
+		}
 	}
 
 	if (!dummy_reinsert) {
@@ -1450,6 +1455,12 @@ int sta_info_move_state_checked(struct sta_info *sta,
 
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
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 87ce917..6d79fbc 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1186,13 +1186,20 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
 		if (sta->uploaded) {
+			enum ieee80211_sta_state state = IEEE80211_STA_NONE;
+
 			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				sdata = container_of(sdata->bss,
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-			WARN_ON(drv_sta_add(local, sdata, &sta->sta));
+			if (WARN_ON(drv_sta_add(local, sdata, &sta->sta)))
+				continue;
+
+			while (state < sta->sta.state)
+				drv_sta_state(local, sdata, &sta->sta,
+					      ++state);
 		}
 	}
 	mutex_unlock(&local->sta_mtx);
-- 
1.7.6.401.g6a319

