Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:53038 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3BFLtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 06:49:15 -0500
Received: by mail-bk0-f43.google.com with SMTP id jm19so594020bkc.30
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 03:49:13 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org, Marco Porsch <marco@cozybit.com>
Subject: [RFCv2 2/3] mac80211: mesh power save doze scheduling
Date: Wed,  6 Feb 2013 12:48:44 +0100
Message-Id: <1360151325-6368-3-git-send-email-marco@cozybit.com> (sfid-20130206_124921_590334_3C1E845B)
In-Reply-To: <1360151325-6368-1-git-send-email-marco@cozybit.com>
References: <1360151325-6368-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the HW for PS mode if the local mesh PS parameters
allow so.

Expose a callback ieee80211_mps_init for drivers to register
mesh powersave ops:
- hw_doze - put the radio to sleep now, wake up at given TBTT
- hw_wakeup - wake the radio up for frame RX
These ops may be extended in the future to allow drivers/HW to
implement mesh PS themselves. (The current design goal was to
concentrate most mesh PS routines in mac80211 to keep driver
modifications minimal.

Track the beacon timing information of peers we are in PS mode
towards. Calculate the next TBTT per-STA.

When going to doze state, get the most imminent STA TBTT and
configure the driver to trigger a wakeup on time to catch that
beacon. After successful receipt put the HW to doze again.
Set a timeout for the case that the beacon is not received on
time. In this case calculate the following TBTT and go to doze
again.

For mesh Awake Windows wakeup on SWBA (beacon_get_tim) and start
a timer which triggers a doze call on expiry.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 include/net/mac80211.h     |   29 ++++
 net/mac80211/ieee80211_i.h |    7 +-
 net/mac80211/mesh.c        |   17 +++
 net/mac80211/mesh.h        |   17 +++
 net/mac80211/mesh_plink.c  |    1 +
 net/mac80211/mesh_ps.c     |  316 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.c    |    3 +
 net/mac80211/sta_info.h    |   10 ++
 net/mac80211/tx.c          |    2 +
 9 files changed, 401 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3037f49..e393a49 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3999,6 +3999,35 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
  */
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn);
 
+/**
+ * struct ieee80211_mps_ops - callbacks from mac80211 to the driver for mesh PS
+ *
+ * @hw_doze: put the radio to doze state to conserve power, schedule wakeup
+ *	at given TSF value to receive peer beacon
+ * @hw_wakeup: wake up the radio to receive frames again
+ */
+struct ieee80211_mps_ops {
+	void (*hw_doze)(struct ieee80211_hw *hw, u64 nexttbtt);
+	void (*hw_wakeup)(struct ieee80211_hw *hw);
+};
+
+#ifdef CONFIG_MAC80211_MESH
+/**
+ * ieee80211_mps_init - register callbacks for mesh PS
+ *
+ * @hw: the hardware
+ * @ops: callbacks for this device
+ *
+ * called by driver on mesh interface add/remove
+ */
+int ieee80211_mps_init(struct ieee80211_hw *hw,
+		       const struct ieee80211_mps_ops *ops);
+#else
+static inline int ieee80211_mps_init(struct ieee80211_hw *hw,
+				     const struct ieee80211_mps_ops *ops)
+{ return 0; }
+#endif
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bba2b10..cb54bae 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -628,6 +628,7 @@ struct ieee80211_if_mesh {
 	int ps_peers_light_sleep;
 	int ps_peers_deep_sleep;
 	struct ps_data ps;
+	struct timer_list awake_window_end_timer;
 };
 
 #ifdef CONFIG_MAC80211_MESH
@@ -1125,7 +1126,7 @@ struct ieee80211_local {
 	bool pspolling;
 	bool offchannel_ps_enabled;
 	/*
-	 * PS can only be enabled when we have exactly one managed
+	 * managed mode PS can only be enabled when we have exactly one managed
 	 * interface (and monitors) in PS, this then points there.
 	 */
 	struct ieee80211_sub_if_data *ps_sdata;
@@ -1145,6 +1146,10 @@ struct ieee80211_local {
 
 	int user_power_level; /* in dBm, for all interfaces */
 
+	/* mesh power save */
+	bool mps_enabled;
+	const struct ieee80211_mps_ops *mps_ops;
+
 	enum ieee80211_smps_mode smps_mode;
 
 	struct work_struct restart_work;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 643262b..b0deb14 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -800,6 +800,7 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	if (ifmsh->preq_queue_len &&
@@ -821,6 +822,19 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 
 	if (test_and_clear_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags))
 		mesh_sync_adjust_tbtt(sdata);
+
+	if (test_and_clear_bit(MESH_WORK_PS_HW_CONF, &ifmsh->wrkq_flags))
+		ieee80211_mps_hw_conf(sdata);
+
+	/* in case both fired simultaneously, wakeup overrides doze */
+	if (test_bit(MESH_WORK_PS_DOZE, &ifmsh->wrkq_flags) &&
+	    test_bit(MESH_WORK_PS_WAKEUP, &ifmsh->wrkq_flags))
+		clear_bit(MESH_WORK_PS_DOZE, &ifmsh->wrkq_flags);
+
+	if (test_and_clear_bit(MESH_WORK_PS_WAKEUP, &ifmsh->wrkq_flags))
+		ieee80211_mps_wakeup(local);
+	else if (test_and_clear_bit(MESH_WORK_PS_DOZE, &ifmsh->wrkq_flags))
+		ieee80211_mps_doze(local);
 }
 
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
@@ -860,6 +874,9 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	setup_timer(&ifmsh->mesh_path_root_timer,
 		    ieee80211_mesh_path_root_timer,
 		    (unsigned long) sdata);
+	setup_timer(&ifmsh->awake_window_end_timer,
+		    ieee80211_mps_awake_window_end,
+		    (unsigned long) sdata);
 	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
 	skb_queue_head_init(&ifmsh->ps.bc_buf);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index d6d9933..686f991 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -58,6 +58,10 @@ enum mesh_path_flags {
  * @MESH_WORK_ROOT: the mesh root station needs to send a frame
  * @MESH_WORK_DRIFT_ADJUST: time to compensate for clock drift relative to other
  * mesh nodes
+ * @MESH_WORK_PS_HW_CONF: configure hardware according to the link-specific
+ * mesh power modes
+ * @MESH_WORK_PS_DOZE: put the hardware to sleep after checking all conditions
+ * @MESH_WORK_PS_WAKEUP: wakeup the hardware immediately
  */
 enum mesh_deferred_task_flags {
 	MESH_WORK_HOUSEKEEPING,
@@ -65,6 +69,9 @@ enum mesh_deferred_task_flags {
 	MESH_WORK_GROW_MPP_TABLE,
 	MESH_WORK_ROOT,
 	MESH_WORK_DRIFT_ADJUST,
+	MESH_WORK_PS_HW_CONF,
+	MESH_WORK_PS_DOZE,
+	MESH_WORK_PS_WAKEUP,
 };
 
 /**
@@ -258,6 +265,16 @@ void ieee80211_mpsp_trigger_process(u8 *qc, struct sta_info *sta,
 				    bool tx, bool acked);
 void ieee80211_mps_frame_release(struct sta_info *sta,
 				 struct ieee802_11_elems *elems);
+void ieee80211_mps_hw_conf(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mps_sta_tbtt_update(struct sta_info *sta,
+				   struct ieee80211_mgmt *mgmt,
+				   struct ieee80211_tim_ie *tim,
+				   u64 tsf);
+void ieee80211_mps_sta_tbtt_timeout(unsigned long data);
+void ieee80211_mps_awake_window_start(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mps_awake_window_end(unsigned long data);
+void ieee80211_mps_doze(struct ieee80211_local *local);
+void ieee80211_mps_wakeup(struct ieee80211_local *local);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index af6fbfd..f41b4bb 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -419,6 +419,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 		ifmsh->sync_ops->rx_bcn(sta, mgmt, elems, rx_status, tsf);
 
 	ieee80211_mps_frame_release(sta, elems);
+	ieee80211_mps_sta_tbtt_update(sta, mgmt, elems->tim, tsf);
 out:
 	rcu_read_unlock();
 }
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index b677962..08de056 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -9,6 +9,18 @@
 
 #include "mesh.h"
 #include "wme.h"
+#include <linux/export.h>
+
+
+#define BEACON_TIMEOUT	20000	/* in us units */
+
+
+static inline void mps_queue_work(struct ieee80211_sub_if_data *sdata,
+				  enum mesh_deferred_task_flags flag)
+{
+	set_bit(flag, &sdata->u.mesh.wrkq_flags);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+}
 
 
 /* mesh PS management */
@@ -126,6 +138,8 @@ void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
 
 	ifmsh->ps_peers_light_sleep = light_sleep_cnt;
 	ifmsh->ps_peers_deep_sleep = deep_sleep_cnt;
+
+	mps_queue_work(sdata, MESH_WORK_PS_HW_CONF);
 }
 
 /**
@@ -538,6 +552,12 @@ void ieee80211_mpsp_trigger_process(u8 *qc, struct sta_info *sta,
 		if (rspi && !test_and_set_sta_flag(sta, WLAN_STA_MPSP_OWNER))
 			mps_frame_deliver(sta, -1);
 	}
+
+	if (test_sta_flag(sta, WLAN_STA_MPSP_OWNER) ||
+	    test_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT))
+		mps_queue_work(sta->sdata, MESH_WORK_PS_WAKEUP);
+	else
+		mps_queue_work(sta->sdata, MESH_WORK_PS_DOZE);
 }
 
 /**
@@ -583,3 +603,299 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 	else
 		mps_frame_deliver(sta, 1);
 }
+
+
+/* mesh PS driver configuration and doze scheduling */
+
+static bool mps_hw_conf_check(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_mesh *ifmsh;
+	bool enable = true;
+
+	if (!local->mps_ops)
+		return false;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		/* If an AP or any other non-mesh vif is found, disable PS */
+		if (ieee80211_sdata_running(sdata) &&
+		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT) {
+			enable = false;
+			break;
+		}
+
+		ifmsh = &sdata->u.mesh;
+
+		/*
+		 * check for non-peer power mode, check for links in active
+		 * mode. Assume a valid power mode is set for each established
+		 * peer link
+		 */
+		if (ifmsh->nonpeer_pm == NL80211_MESH_POWER_ACTIVE ||
+		    ifmsh->ps_peers_light_sleep + ifmsh->ps_peers_deep_sleep
+				< atomic_read(&ifmsh->estab_plinks)) {
+			enable = false;
+			break;
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	return enable;
+}
+
+/**
+ * mps_hw_conf_sta_prepare - mark peers to catch beacon once before first doze
+ */
+static void mps_hw_conf_sta_prepare(struct ieee80211_local *local)
+{
+	struct sta_info *sta;
+
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list) {
+		if (!ieee80211_vif_is_mesh(&sta->sdata->vif) ||
+		    !ieee80211_sdata_running(sta->sdata) ||
+		    sta->plink_state != NL80211_PLINK_ESTAB)
+			continue;
+		else
+			set_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB);
+	}
+	mutex_unlock(&local->sta_mtx);
+}
+
+/**
+ * ieee80211_mps_hw_conf - check conditions for mesh PS and configure driver
+ *
+ * @sdata: local mesh subif
+ */
+void ieee80211_mps_hw_conf(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	bool enable;
+
+	enable = mps_hw_conf_check(local);
+
+	if (local->mps_enabled == enable)
+		return;
+
+	if (enable) {
+		mps_hw_conf_sta_prepare(local);
+		local->hw.conf.flags |= IEEE80211_CONF_PS;
+	} else {
+		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+	}
+
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	local->mps_enabled = enable;
+	mps_queue_work(sdata, MESH_WORK_PS_WAKEUP);
+}
+
+static void mps_sta_nexttbtt_calc(struct sta_info *sta,
+				  struct ieee80211_tim_ie *tim,
+				  u64 tsf_local)
+{
+	u64 tsf_peer;
+	int skip = 1;
+	u32 nexttbtt_interval;
+
+	/* simple Deep Sleep implementation: only wake up for DTIM beacons */
+	if (sta->local_pm == NL80211_MESH_POWER_DEEP_SLEEP)
+		skip = tim->dtim_count ? tim->dtim_count : tim->dtim_period;
+	/*
+	 * determine time to peer TBTT (TSF % beacon_interval = 0).
+	 * This approach is robust to delayed beacons.
+	 */
+	tsf_peer = tsf_local + sta->t_offset;
+	nexttbtt_interval = sta->beacon_interval * skip -
+			do_div(tsf_peer, sta->beacon_interval * skip);
+
+	mps_dbg(sta->sdata, "updating %pM next TBTT in %dus (%lldus awake)\n",
+		sta->sta.addr, nexttbtt_interval,
+		(long long) tsf_local - sta->nexttbtt_tsf);
+
+	sta->nexttbtt_tsf = tsf_local + nexttbtt_interval;
+	sta->nexttbtt_jiffies = jiffies + usecs_to_jiffies(nexttbtt_interval);
+
+	mod_timer(&sta->nexttbtt_timer, sta->nexttbtt_jiffies +
+			usecs_to_jiffies(BEACON_TIMEOUT));
+}
+
+/**
+ * ieee80211_mps_sta_tbtt_update - update peer beacon wakeup schedule
+ *
+ * @sta: mesh STA
+ * @mgmt: beacon frame
+ * @tim: TIM IE of beacon frame
+ * @tsf_local: current HW TSF
+ */
+void ieee80211_mps_sta_tbtt_update(struct sta_info *sta,
+				   struct ieee80211_mgmt *mgmt,
+				   struct ieee80211_tim_ie *tim,
+				   u64 tsf_local)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
+	if (!sdata->local->mps_enabled ||
+	    sta->plink_state != NL80211_PLINK_ESTAB)
+		return;
+
+	sta->beacon_interval = le16_to_cpu(mgmt->u.beacon.beacon_int) * 1024;
+	/* pending multicasts after DTIM beacon? TODO reset after RX */
+	if (tim->bitmap_ctrl & 0x01)
+		set_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB);
+	else
+		clear_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB);
+
+	mps_sta_nexttbtt_calc(sta, tim, tsf_local);
+
+	mps_queue_work(sdata, MESH_WORK_PS_DOZE);
+}
+
+/**
+ * ieee80211_mps_sta_tbtt_timeout - timer callback for missed peer beacons
+ */
+void ieee80211_mps_sta_tbtt_timeout(unsigned long data)
+{
+	struct sta_info *sta = (void *)data;
+
+	rcu_read_lock();
+	sta->nexttbtt_tsf += sta->beacon_interval;
+	sta->nexttbtt_jiffies += usecs_to_jiffies(sta->beacon_interval);
+
+	mps_dbg(sta->sdata, "beacon miss %pM\n", sta->sta.addr);
+	mps_queue_work(sta->sdata, MESH_WORK_PS_DOZE);
+	rcu_read_unlock();
+}
+
+/**
+ * ieee80211_mps_awake_window_start - start Awake Window on SWBA
+ *
+ * @sdata: local mesh subif
+ */
+void ieee80211_mps_awake_window_start(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	if (!sdata->local->mps_enabled)
+		return;
+
+	mod_timer(&ifmsh->awake_window_end_timer, jiffies + usecs_to_jiffies(
+			ifmsh->mshcfg.dot11MeshAwakeWindowDuration * 1024));
+
+	mps_dbg(sdata, "awake window start (%dTU)\n",
+		ifmsh->mshcfg.dot11MeshAwakeWindowDuration);
+	mps_queue_work(sdata, MESH_WORK_PS_WAKEUP);
+}
+
+/**
+ * ieee80211_mps_awake_window_end - timer callback for end of Awake Window
+ */
+void ieee80211_mps_awake_window_end(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata = (void *) data;
+
+	if (!sdata->local->mps_enabled)
+		return;
+
+	mps_dbg(sdata, "awake window end\n");
+	mps_queue_work(sdata, MESH_WORK_PS_DOZE);
+}
+
+static bool mps_doze_check_vif(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	bool allow = true;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		if (!ieee80211_vif_is_mesh(&sdata->vif) ||
+		    timer_pending(&sdata->u.mesh.awake_window_end_timer)) {
+			allow = false;
+			break;
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	return allow;
+}
+
+static bool mps_doze_check_sta(struct ieee80211_local *local, u64 *nexttbtt)
+{
+	struct sta_info *sta;
+	bool allow = true;
+	u64 nexttbtt_min = ULLONG_MAX;
+
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list) {
+		if (!ieee80211_vif_is_mesh(&sta->sdata->vif) ||
+		    !ieee80211_sdata_running(sta->sdata) ||
+		    sta->plink_state != NL80211_PLINK_ESTAB) {
+			continue;
+		} else if (test_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB) ||
+			   test_sta_flag(sta, WLAN_STA_MPSP_OWNER) ||
+			   test_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT) ||
+			   time_in_range(jiffies, sta->nexttbtt_jiffies,
+					 sta->nexttbtt_jiffies +
+					 usecs_to_jiffies(BEACON_TIMEOUT))) {
+			allow = false;
+			break;
+		} else if (sta->nexttbtt_tsf < nexttbtt_min) {
+			nexttbtt_min = sta->nexttbtt_tsf;
+		}
+	}
+	mutex_unlock(&local->sta_mtx);
+
+	if (nexttbtt_min != ULLONG_MAX)
+		*nexttbtt = nexttbtt_min;
+
+	return allow;
+}
+
+/**
+ * ieee80211_mps_doze - check conditions and trigger radio doze state
+ *
+ * @local: local interface data
+ */
+void ieee80211_mps_doze(struct ieee80211_local *local)
+{
+	u64 nexttbtt = 0;
+	struct sta_info *sta;
+
+	if (!local->mps_enabled ||
+	    !mps_doze_check_vif(local) ||
+	    !mps_doze_check_sta(local, &nexttbtt))
+		return;
+
+	if (local->mps_ops)
+		local->mps_ops->hw_doze(&local->hw, nexttbtt);
+}
+
+/**
+ * ieee80211_mps_wakeup - trigger radio wakeup immediately
+ *
+ * @local: local interface data
+ */
+void ieee80211_mps_wakeup(struct ieee80211_local *local)
+{
+	if (local->mps_ops)
+		local->mps_ops->hw_wakeup(&local->hw);
+}
+
+int ieee80211_mps_init(struct ieee80211_hw *hw,
+		       const struct ieee80211_mps_ops *ops)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	local->mps_ops = ops;
+	if (!ops)
+		local->mps_enabled = false;
+
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_mps_init);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f920154..2905f2a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -142,6 +142,7 @@ static void cleanup_single_sta(struct sta_info *sta)
 		mesh_accept_plinks_update(sdata);
 		mesh_plink_deactivate(sta);
 		del_timer_sync(&sta->plink_timer);
+		del_timer_sync(&sta->nexttbtt_timer);
 	}
 #endif
 
@@ -385,6 +386,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 #ifdef CONFIG_MAC80211_MESH
 	sta->plink_state = NL80211_PLINK_LISTEN;
 	init_timer(&sta->plink_timer);
+	setup_timer(&sta->nexttbtt_timer, ieee80211_mps_sta_tbtt_timeout,
+		    (unsigned long) sta);
 #endif
 
 	return sta;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5a1deba..624d32a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -58,6 +58,7 @@
  * @WLAN_STA_TOFFSET_KNOWN: toffset calculated for this station is valid.
  * @WLAN_STA_MPSP_OWNER: local STA is owner of a mesh Peer Service Period.
  * @WLAN_STA_MPSP_RECIPIENT: local STA is recipient of a MPSP.
+ * @WLAN_STA_MPS_WAIT_FOR_CAB: multicast frames from this STA are imminent.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -82,6 +83,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_TOFFSET_KNOWN,
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
+	WLAN_STA_MPS_WAIT_FOR_CAB,
 };
 
 #define ADDBA_RESP_INTERVAL HZ
@@ -289,6 +291,10 @@ struct sta_ampdu_mlme {
  * @local_pm: local link-specific power save mode
  * @peer_pm: peer-specific power save mode towards local STA
  * @nonpeer_pm: STA power save mode towards non-peer neighbors
+ * @beacon_interval: beacon interval of neighbor STA (in us)
+ * @nexttbtt_tsf: next TBTT in local TSF units
+ * @nexttbtt_jiffies: next TBTT in jiffies units
+ * @nexttbtt_timer: timeout for missed beacons
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -390,6 +396,10 @@ struct sta_info {
 	enum nl80211_mesh_power_mode local_pm;
 	enum nl80211_mesh_power_mode peer_pm;
 	enum nl80211_mesh_power_mode nonpeer_pm;
+	u32 beacon_interval;
+	u64 nexttbtt_tsf;
+	unsigned long nexttbtt_jiffies;
+	struct timer_list nexttbtt_timer;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 75ae941..4ad45f0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2495,6 +2495,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			pr_err("o11s: couldn't add ies!\n");
 			goto out;
 		}
+
+		ieee80211_mps_awake_window_start(sdata);
 	} else {
 		WARN_ON(1);
 		goto out;
-- 
1.7.9.5

