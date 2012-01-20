Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2ATNB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 08:01:29 -0500
Subject: [PATCH 05/11 (resend for list)] mac80211: add sta_state callback
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
In-Reply-To: <20120120125516.000124996@sipsolutions.net> (sfid-20120120_135845_820468_851FFECD)
References: <20120120125516.000124996@sipsolutions.net>
	 (sfid-20120120_135845_820468_851FFECD)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jan 2012 14:01:28 +0100
Message-ID: <1327064488.9857.1.camel@jlt3.sipsolutions.net> (sfid-20120120_140133_619265_06E711F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

(based on Eliad's patch)

Add a callback to notify the low-level driver whenever
the state of a station changes. The driver is only
notified when the station is actually in the mac80211
hash table, not for pre-insert state transitions.

To allow the driver to replace sta_add/remove calls
with this, call extra transitions with the NOTEXIST
state.

This callback can fail, so we need to be careful in
handling it when a station is inserted, particularly
in the IBSS case where we still keep the station entry
around for mac80211 purposes.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: call drv_sta_state() within the sta addition process (thanks Johannes)
Johannes:
v3: - call drv_sta_state() in suspend
    - introduce NOTEXIST state
    - don't put old state into driver visible data but pass it to the
      callback -- also fixes a reconfig bug
    - make exclusive (forbid having sta_add/remove and sta_state)
    - allow drv_sta_state() to fail and unwind initial
      addition if it does
v4: - handle updates correctly when state change fails

 include/net/mac80211.h      |   30 ++++++++++++
 net/mac80211/driver-ops.h   |   22 +++++++++
 net/mac80211/driver-trace.h |   32 +++++++++++++
 net/mac80211/main.c         |    3 +
 net/mac80211/pm.c           |   10 +++-
 net/mac80211/sta_info.c     |  106 ++++++++++++++++++++++++++++++++++++--------
 net/mac80211/sta_info.h     |    9 ---
 net/mac80211/util.c         |   10 +++-
 8 files changed, 194 insertions(+), 28 deletions(-)

--- a/include/net/mac80211.h	2012-01-20 13:54:17.000000000 +0100
+++ b/include/net/mac80211.h	2012-01-20 13:54:19.000000000 +0100
@@ -982,6 +982,25 @@ enum set_key_cmd {
 };
 
 /**
+ * enum ieee80211_sta_state - station state
+ *
+ * @IEEE80211_STA_NOTEXIST: station doesn't exist at all,
+ *	this is a special state for add/remove transitions
+ * @IEEE80211_STA_NONE: station exists without special state
+ * @IEEE80211_STA_AUTH: station is authenticated
+ * @IEEE80211_STA_ASSOC: station is associated
+ * @IEEE80211_STA_AUTHORIZED: station is authorized (802.1X)
+ */
+enum ieee80211_sta_state {
+	/* NOTE: These need to be ordered correctly! */
+	IEEE80211_STA_NOTEXIST,
+	IEEE80211_STA_NONE,
+	IEEE80211_STA_AUTH,
+	IEEE80211_STA_ASSOC,
+	IEEE80211_STA_AUTHORIZED,
+};
+
+/**
  * struct ieee80211_sta - station table entry
  *
  * A station table entry represents a station we are possibly
@@ -1974,6 +1993,13 @@ enum ieee80211_frame_release_type {
  *	in AP mode, this callback will not be called when the flag
  *	%IEEE80211_HW_AP_LINK_PS is set. Must be atomic.
  *
+ * @sta_state: Notifies low level driver about state transition of a
+ *	station (which can be the AP, a client, IBSS/WDS/mesh peer etc.)
+ *	This callback is mutually exclusive with @sta_add/@sta_remove.
+ *	It must not fail for down transitions but may fail for transitions
+ *	up the list of states.
+ *	The callback can sleep.
+ *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
  *	Returns a negative error code on failure.
@@ -2193,6 +2219,10 @@ struct ieee80211_ops {
 			  struct ieee80211_sta *sta);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
+	int (*sta_state)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta,
+			 enum ieee80211_sta_state old_state,
+			 enum ieee80211_sta_state new_state);
 	int (*conf_tx)(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
--- a/net/mac80211/driver-ops.h	2012-01-20 13:54:19.000000000 +0100
+++ b/net/mac80211/driver-ops.h	2012-01-20 13:54:19.000000000 +0100
@@ -478,6 +478,28 @@ static inline void drv_sta_remove(struct
 	trace_drv_return_void(local);
 }
 
+static inline __must_check
+int drv_sta_state(struct ieee80211_local *local,
+		  struct ieee80211_sub_if_data *sdata,
+		  struct sta_info *sta,
+		  enum ieee80211_sta_state old_state,
+		  enum ieee80211_sta_state new_state)
+{
+	int ret = 0;
+
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	check_sdata_in_driver(sdata);
+
+	trace_drv_sta_state(local, sdata, &sta->sta, old_state, new_state);
+	if (local->ops->sta_state)
+		ret = local->ops->sta_state(&local->hw, &sdata->vif, &sta->sta,
+					    old_state, new_state);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int drv_conf_tx(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata, u16 queue,
 			      const struct ieee80211_tx_queue_params *params)
--- a/net/mac80211/driver-trace.h	2012-01-20 13:54:09.000000000 +0100
+++ b/net/mac80211/driver-trace.h	2012-01-20 13:54:19.000000000 +0100
@@ -635,6 +635,38 @@ TRACE_EVENT(drv_sta_notify,
 	)
 );
 
+TRACE_EVENT(drv_sta_state,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 enum ieee80211_sta_state old_state,
+		 enum ieee80211_sta_state new_state),
+
+	TP_ARGS(local, sdata, sta, old_state, new_state),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u32, old_state)
+		__field(u32, new_state)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->old_state = old_state;
+		__entry->new_state = new_state;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " state: %d->%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG,
+		__entry->old_state, __entry->new_state
+	)
+);
+
 TRACE_EVENT(drv_sta_add,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
--- a/net/mac80211/sta_info.c	2012-01-20 13:54:19.000000000 +0100
+++ b/net/mac80211/sta_info.c	2012-01-20 13:54:19.000000000 +0100
@@ -351,6 +351,38 @@ static int sta_info_insert_check(struct
 	return 0;
 }
 
+static int sta_info_insert_drv_state(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata,
+				     struct sta_info *sta)
+{
+	enum ieee80211_sta_state state;
+	int err = 0;
+
+	for (state = IEEE80211_STA_NOTEXIST; state < sta->sta_state; state++) {
+		err = drv_sta_state(local, sdata, sta, state, state + 1);
+		if (err)
+			break;
+	}
+
+	if (!err) {
+		sta->uploaded = true;
+		return 0;
+	}
+
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		printk(KERN_DEBUG
+		       "%s: failed to move IBSS STA %pM to state %d (%d) - keeping it anyway.\n",
+		       sdata->name, sta->sta.addr, state + 1, err);
+		err = 0;
+	}
+
+	/* unwind on error */
+	for (; state > IEEE80211_STA_NOTEXIST; state--)
+		WARN_ON(drv_sta_state(local, sdata, sta, state, state - 1));
+
+	return err;
+}
+
 /*
  * should be called with sta_mtx locked
  * this function replaces the mutex lock
@@ -392,8 +424,11 @@ static int sta_info_insert_finish(struct
 			printk(KERN_DEBUG "%s: failed to add IBSS STA %pM to "
 					  "driver (%d) - keeping it anyway.\n",
 			       sdata->name, sta->sta.addr, err);
-		} else
-			sta->uploaded = true;
+		} else {
+			err = sta_info_insert_drv_state(local, sdata, sta);
+			if (err)
+				goto out_err;
+		}
 	}
 
 	if (!dummy_reinsert) {
@@ -770,15 +805,19 @@ int __must_check __sta_info_destroy(stru
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
 	while (sta->sta_state > IEEE80211_STA_NONE) {
-		int err = sta_info_move_state(sta, sta->sta_state - 1);
-		if (err) {
+		ret = sta_info_move_state(sta, sta->sta_state - 1);
+		if (ret) {
 			WARN_ON_ONCE(1);
 			break;
 		}
 	}
 
-	if (sta->uploaded)
+	if (sta->uploaded) {
 		drv_sta_remove(local, sdata, &sta->sta);
+		ret = drv_sta_state(local, sdata, sta, IEEE80211_STA_NONE,
+				    IEEE80211_STA_NOTEXIST);
+		WARN_ON_ONCE(ret != 0);
+	}
 
 	/*
 	 * At this point, after we wait for an RCU grace period,
@@ -1404,20 +1443,58 @@ int sta_info_move_state(struct sta_info
 	if (sta->sta_state == new_state)
 		return 0;
 
+	/* check allowed transitions first */
+
+	switch (new_state) {
+	case IEEE80211_STA_NONE:
+		if (sta->sta_state != IEEE80211_STA_AUTH)
+			return -EINVAL;
+		break;
+	case IEEE80211_STA_AUTH:
+		if (sta->sta_state != IEEE80211_STA_NONE &&
+		    sta->sta_state != IEEE80211_STA_ASSOC)
+			return -EINVAL;
+		break;
+	case IEEE80211_STA_ASSOC:
+		if (sta->sta_state != IEEE80211_STA_AUTH &&
+		    sta->sta_state != IEEE80211_STA_AUTHORIZED)
+			return -EINVAL;
+		break;
+	case IEEE80211_STA_AUTHORIZED:
+		if (sta->sta_state != IEEE80211_STA_ASSOC)
+			return -EINVAL;
+		break;
+	default:
+		WARN(1, "invalid state %d", new_state);
+		return -EINVAL;
+	}
+
+	printk(KERN_DEBUG "%s: moving STA %pM to state %d\n",
+		sta->sdata->name, sta->sta.addr, new_state);
+
+	/*
+	 * notify the driver before the actual changes so it can
+	 * fail the transition
+	 */
+	if (test_sta_flag(sta, WLAN_STA_INSERTED)) {
+		int err = drv_sta_state(sta->local, sta->sdata, sta,
+					sta->sta_state, new_state);
+		if (err)
+			return err;
+	}
+
+	/* reflect the change in all state variables */
+
 	switch (new_state) {
 	case IEEE80211_STA_NONE:
 		if (sta->sta_state == IEEE80211_STA_AUTH)
 			clear_bit(WLAN_STA_AUTH, &sta->_flags);
-		else
-			return -EINVAL;
 		break;
 	case IEEE80211_STA_AUTH:
 		if (sta->sta_state == IEEE80211_STA_NONE)
 			set_bit(WLAN_STA_AUTH, &sta->_flags);
 		else if (sta->sta_state == IEEE80211_STA_ASSOC)
 			clear_bit(WLAN_STA_ASSOC, &sta->_flags);
-		else
-			return -EINVAL;
 		break;
 	case IEEE80211_STA_ASSOC:
 		if (sta->sta_state == IEEE80211_STA_AUTH) {
@@ -1426,24 +1503,19 @@ int sta_info_move_state(struct sta_info
 			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
 				atomic_dec(&sta->sdata->u.ap.num_sta_authorized);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
-		} else
-			return -EINVAL;
+		}
 		break;
 	case IEEE80211_STA_AUTHORIZED:
 		if (sta->sta_state == IEEE80211_STA_ASSOC) {
 			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
 				atomic_inc(&sta->sdata->u.ap.num_sta_authorized);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
-		} else
-			return -EINVAL;
+		}
 		break;
 	default:
-		WARN(1, "invalid state %d", new_state);
-		return -EINVAL;
+		break;
 	}
 
-	printk(KERN_DEBUG "%s: moving STA %pM to state %d\n",
-		sta->sdata->name, sta->sta.addr, new_state);
 	sta->sta_state = new_state;
 
 	return 0;
--- a/net/mac80211/util.c	2012-01-20 13:54:19.000000000 +0100
+++ b/net/mac80211/util.c	2012-01-20 13:54:19.000000000 +0100
@@ -1184,8 +1184,16 @@ int ieee80211_reconfig(struct ieee80211_
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
-		if (sta->uploaded)
+		if (sta->uploaded) {
+			enum ieee80211_sta_state state;
+
 			WARN_ON(drv_sta_add(local, sta->sdata, &sta->sta));
+
+			for (state = IEEE80211_STA_NOTEXIST;
+			     state < sta->sta_state - 1; state++)
+				WARN_ON(drv_sta_state(local, sta->sdata, sta,
+						      state, state + 1));
+		}
 	}
 	mutex_unlock(&local->sta_mtx);
 
--- a/net/mac80211/main.c	2012-01-20 13:54:09.000000000 +0100
+++ b/net/mac80211/main.c	2012-01-20 13:54:19.000000000 +0100
@@ -534,6 +534,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	int priv_size, i;
 	struct wiphy *wiphy;
 
+	if (WARN_ON(ops->sta_state && (ops->sta_add || ops->sta_remove)))
+		return NULL;
+
 	/* Ensure 32-byte alignment of our private data and hw private data.
 	 * We use the wiphy priv data for both our ieee80211_local and for
 	 * the driver's private data
--- a/net/mac80211/sta_info.h	2012-01-20 13:54:19.000000000 +0100
+++ b/net/mac80211/sta_info.h	2012-01-20 13:54:19.000000000 +0100
@@ -75,15 +75,6 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_INSERTED,
 };
 
-enum ieee80211_sta_state {
-	/* NOTE: These need to be ordered correctly! */
-	IEEE80211_STA_NOTEXIST,
-	IEEE80211_STA_NONE,
-	IEEE80211_STA_AUTH,
-	IEEE80211_STA_ASSOC,
-	IEEE80211_STA_AUTHORIZED,
-};
-
 #define STA_TID_NUM 16
 #define ADDBA_RESP_INTERVAL HZ
 #define HT_AGG_MAX_RETRIES		15
--- a/net/mac80211/pm.c	2012-01-20 13:54:19.000000000 +0100
+++ b/net/mac80211/pm.c	2012-01-20 13:54:19.000000000 +0100
@@ -97,9 +97,17 @@ int __ieee80211_suspend(struct ieee80211
 	/* tear down aggregation sessions and remove STAs */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
-		if (sta->uploaded)
+		if (sta->uploaded) {
+			enum ieee80211_sta_state state;
+
 			drv_sta_remove(local, sta->sdata, &sta->sta);
 
+			state = sta->sta_state;
+			for (; state > IEEE80211_STA_NOTEXIST; state--)
+				WARN_ON(drv_sta_state(local, sdata, sta,
+						      state, state - 1));
+		}
+
 		mesh_plink_quiesce(sta);
 	}
 	mutex_unlock(&local->sta_mtx);


