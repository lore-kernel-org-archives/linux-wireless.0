Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41266 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3AWKTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 05:19:33 -0500
Received: by mail-bk0-f42.google.com with SMTP id ji2so4330646bkc.15
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 02:19:31 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org, Marco Porsch <marco@cozybit.com>
Subject: [RFC 2/3] mac80211: mesh power save doze scheduling
Date: Wed, 23 Jan 2013 11:19:19 +0100
Message-Id: <1358936360-7795-3-git-send-email-marco@cozybit.com> (sfid-20130123_111939_731573_C26F954C)
In-Reply-To: <1358936360-7795-1-git-send-email-marco@cozybit.com>
References: <1358936360-7795-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the HW for PS mode if the local mesh PS parameters
allow so.

Expose a callback ieee80211_mps_init for drivers to register
mesh powersave ops:
- hw_doze - put the radio to sleep now
- hw_wakeup - wake the radio up for frame RX
These ops may be extended in the future to allow drivers/HW to
implement mesh PS themselves. (The current design goal was to
concentrate mesh PS routines in mac80211 to keep driver
modifications minimal.

Track the beacon timing information of peers we are in PS mode
towards. Set a per-STA hrtimer which will trigger a wakeup right
before the peer's next TBTT.
Also use the same hrtimer to go to sleep mode after not
receiving a beacon in a defined time margin. In this case
calculate the next TBTT and increase the margin.

For mesh Awake Windows wakeup on SWBA (beacon_get_tim) and start
a timer which triggers a hw_doze call on expiry.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 include/net/mac80211.h     |   34 +++++
 net/mac80211/ieee80211_i.h |    9 +-
 net/mac80211/mesh.c        |   17 +++
 net/mac80211/mesh.h        |   17 +++
 net/mac80211/mesh_plink.c  |    1 +
 net/mac80211/mesh_ps.c     |  357 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.c    |    4 +
 net/mac80211/sta_info.h    |   13 ++
 net/mac80211/tx.c          |    2 +
 9 files changed, 453 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 23daed3..ca6979d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3952,6 +3952,40 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
  */
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn);
 
+/**
+ * struct ieee80211_mps_ops - callbacks from mac80211 to driver for mesh PS
+ *
+ * This structure contains callbacks that the driver has to or may handle for
+ * mesh powersave.
+ * TODO Add further callbacks for HW that performs certain mesh PS tasks on its
+ * own (e.g. assign list of STA to track).
+ *
+ * @hw_doze: put the radio to doze state to conserve power
+ * @hw_wakeup: wake up the radio to receive frames again
+ */
+struct ieee80211_mps_ops {
+	void (*hw_doze)(struct ieee80211_hw *hw);
+	void (*hw_wakeup)(struct ieee80211_hw *hw);
+};
+
+#ifdef CONFIG_MAC80211_MESH
+/**
+ * ieee80211_mps_init - register driver callbacks for mesh PS
+ *
+ * @hw: the hardware
+ * @ops: callbacks for this device
+ *
+ * called by driver on mesh interface add/remove
+ * TODO add HW capability flags
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
index e08b4c0..c08f423 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -629,6 +629,8 @@ struct ieee80211_if_mesh {
 	int ps_peers_deep_sleep;
 	struct ps_data ps;
 	atomic_t num_mpsp; /* counts both owner and recipient independently */
+	struct timer_list awake_window_end_timer;
+	bool in_awake_window;
 };
 
 #ifdef CONFIG_MAC80211_MESH
@@ -1126,7 +1128,7 @@ struct ieee80211_local {
 	bool pspolling;
 	bool offchannel_ps_enabled;
 	/*
-	 * PS can only be enabled when we have exactly one managed
+	 * managed mode PS can only be enabled when we have exactly one managed
 	 * interface (and monitors) in PS, this then points there.
 	 */
 	struct ieee80211_sub_if_data *ps_sdata;
@@ -1146,6 +1148,11 @@ struct ieee80211_local {
 
 	int user_power_level; /* in dBm, for all interfaces */
 
+	/* mesh power save */
+	bool mps_enabled;
+	bool mps_hw_doze;
+	const struct ieee80211_mps_ops *mps_ops;
+
 	enum ieee80211_smps_mode smps_mode;
 
 	struct work_struct restart_work;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8ce5d60..740d035 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -803,6 +803,7 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	if (ifmsh->preq_queue_len &&
@@ -824,6 +825,19 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 
 	if (test_and_clear_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags))
 		mesh_sync_adjust_tbtt(sdata);
+
+	if (test_and_clear_bit(MESH_WORK_PS_HW_CONF, &ifmsh->wrkq_flags))
+		ieee80211_mps_hw_conf(local);
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
@@ -863,6 +877,9 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
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
index fa1423e..ce35b78 100644
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
@@ -258,6 +265,16 @@ void ieee80211_mpsp_trigger_process(struct ieee80211_hdr *hdr,
 				    struct sta_info *sta, bool tx, bool acked);
 void ieee80211_mps_frame_release(struct sta_info *sta,
 				 struct ieee802_11_elems *elems);
+void ieee80211_mps_hw_conf(struct ieee80211_local *local);
+void ieee80211_mps_sta_tbtt_update(struct sta_info *sta,
+				   struct ieee80211_mgmt *mgmt,
+				   struct ieee80211_tim_ie *tim,
+				   u64 tsf);
+enum hrtimer_restart ieee80211_mps_sta_tbtt_timer(struct hrtimer *timer);
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
index 788b935..d7fffd9 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -9,12 +9,32 @@
 
 #include "mesh.h"
 #include "wme.h"
+#include <linux/export.h>
+#include <linux/hrtimer.h>
 
+/*
+ * time to wakeup before and stay awake after peer TBTT until beacon receipt.
+ * required to cope with stack delay and HW wakeup time before TBTT and delayed
+ * beacons after TBTT
+ * TODO adjust this value for different hardware or make it adaptive
+ */
+#define TBTT_MARGIN	5000	/* in us units */
+
+
+static inline void mps_queue_work(struct ieee80211_sub_if_data *sdata,
+				  enum mesh_deferred_task_flags flag)
+{
+	set_bit(flag, &sdata->u.mesh.wrkq_flags);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+}
 
 static inline bool test_and_set_mpsp_flag(struct sta_info *sta,
 					  enum ieee80211_sta_info_flags flag)
 {
 	if (!test_and_set_sta_flag(sta, flag)) {
+		if (sta->sdata->local->mps_enabled &&
+		    atomic_read(&sta->sdata->u.mesh.num_mpsp) == 0)
+			mps_queue_work(sta->sdata, MESH_WORK_PS_WAKEUP);
 		atomic_inc(&sta->sdata->u.mesh.num_mpsp);
 		return false;
 	}
@@ -26,6 +46,9 @@ static inline bool test_and_clear_mpsp_flag(struct sta_info *sta,
 {
 	if (test_and_clear_sta_flag(sta, flag)) {
 		atomic_dec(&sta->sdata->u.mesh.num_mpsp);
+		if (sta->sdata->local->mps_enabled &&
+		    atomic_read(&sta->sdata->u.mesh.num_mpsp) == 0)
+			mps_queue_work(sta->sdata, MESH_WORK_PS_DOZE);
 		return true;
 	}
 	return false;
@@ -148,6 +171,8 @@ void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
 
 	ifmsh->ps_peers_light_sleep = light_sleep_cnt;
 	ifmsh->ps_peers_deep_sleep = deep_sleep_cnt;
+
+	mps_queue_work(sdata, MESH_WORK_PS_HW_CONF);
 }
 
 /**
@@ -605,3 +630,335 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
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
+			set_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_BEACON);
+	}
+	mutex_unlock(&local->sta_mtx);
+}
+
+/**
+ * ieee80211_mps_hw_conf - check conditions for mesh PS and configure driver
+ *
+ * @local: local interface data
+ */
+void ieee80211_mps_hw_conf(struct ieee80211_local *local)
+{
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
+}
+
+static void mps_sta_tbtt_set_timer(struct sta_info *sta,
+				   struct ieee80211_tim_ie *tim,
+				   u64 tsf_local)
+{
+	u64 tsf_peer;
+	int skip = 1;
+	u32 nexttbtt_interval;
+	ktime_t now;
+
+	/* simple Deep Sleep implementation: only wake up for DTIM beacons */
+	if (sta->local_pm == NL80211_MESH_POWER_DEEP_SLEEP &&
+	    tim->dtim_count == 0)
+		skip = tim->dtim_period;
+
+	/*
+	 * determine time to peer TBTT (TSF % beacon_interval = 0).
+	 * This approach is robust to delayed beacons.
+	 */
+	tsf_peer = tsf_local + sta->t_offset;
+	nexttbtt_interval = sta->beacon_interval -
+			do_div(tsf_peer, sta->beacon_interval * skip);
+	now = hrtimer_cb_get_time(&sta->mps_beacon_timer);
+
+	mps_dbg(sta->sdata, "updating %pM next TBTT in %dus (%llus awake)\n",
+		sta->sta.addr, nexttbtt_interval,
+		(long long) ktime_to_us(ktime_sub(now, sta->tbtt_wakeup)));
+
+	sta->tbtt_wakeup = ktime_add_us(now, nexttbtt_interval - TBTT_MARGIN);
+	sta->tbtt_miss = ktime_add_us(now, nexttbtt_interval + TBTT_MARGIN);
+
+	hrtimer_start(&sta->mps_beacon_timer, sta->tbtt_wakeup,
+		      HRTIMER_MODE_ABS);
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
+	hrtimer_cancel(&sta->mps_beacon_timer);
+	clear_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_BEACON);
+
+	sta->beacon_interval = le16_to_cpu(mgmt->u.beacon.beacon_int) * 1024;
+	/* pending multicasts after DTIM beacon? TODO reset after RX */
+	if (tim->bitmap_ctrl & 0x01)
+		set_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB);
+	else
+		clear_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB);
+
+	mps_sta_tbtt_set_timer(sta, tim, tsf_local);
+
+	mps_queue_work(sdata, MESH_WORK_PS_DOZE);
+}
+
+/**
+ * ieee80211_mps_sta_tbtt_timer - hrtimer callback for mesh PS doze/wakeup
+ *
+ * Used for both waking up before TBTT and resuming doze in case the beacon
+ * is not received on time.
+ * XXX what lock should be used here? hrtimer callbacks are hard IRQ context
+ */
+enum hrtimer_restart ieee80211_mps_sta_tbtt_timer(struct hrtimer *timer)
+{
+	/*
+	 * This STA is valid because the timer is canceled on STA removal
+	 * after having made sure it cannot be armed (by deleting the plink.)
+	 */
+	struct sta_info *sta = container_of(timer, struct sta_info,
+					    mps_beacon_timer);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
+	if (!sdata->local->mps_enabled ||
+	    sta->plink_state != NL80211_PLINK_ESTAB)
+		return HRTIMER_NORESTART;
+
+	if (!test_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_BEACON)) {
+		mps_dbg(sdata, "wakeup for %pM (margin %dus)\n",
+			sta->sta.addr, TBTT_MARGIN);
+
+		set_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_BEACON);
+		hrtimer_set_expires(&sta->mps_beacon_timer, sta->tbtt_miss);
+
+		mps_queue_work(sdata, MESH_WORK_PS_WAKEUP);
+	} else {
+		mps_dbg(sdata, "beacon miss %pM\n", sta->sta.addr);
+
+		clear_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_BEACON);
+
+		/* increase the margin for each beacon miss TODO deep sleep */
+		sta->tbtt_wakeup = ktime_add_us(sta->tbtt_wakeup,
+				sta->beacon_interval - TBTT_MARGIN);
+		sta->tbtt_miss = ktime_add_us(sta->tbtt_miss,
+				sta->beacon_interval + TBTT_MARGIN);
+		hrtimer_set_expires(&sta->mps_beacon_timer, sta->tbtt_wakeup);
+
+		mps_queue_work(sdata, MESH_WORK_PS_DOZE);
+	}
+
+	return HRTIMER_RESTART;
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
+	mps_dbg(sdata, "awake window start (%dTU)\n",
+		ifmsh->mshcfg.dot11MeshAwakeWindowDuration);
+
+	ifmsh->in_awake_window = true;
+	mod_timer(&ifmsh->awake_window_end_timer, jiffies + usecs_to_jiffies(
+			ifmsh->mshcfg.dot11MeshAwakeWindowDuration * 1024));
+
+	mps_queue_work(sdata, MESH_WORK_PS_WAKEUP);
+}
+
+/**
+ * ieee80211_mps_awake_window_end - timer callback for end of Awake Window
+ */
+void ieee80211_mps_awake_window_end(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata = (void *) data;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	mps_dbg(sdata, "awake window end\n");
+
+	ifmsh->in_awake_window = false;
+
+	if (!sdata->local->mps_enabled)
+		return;
+
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
+		    sdata->u.mesh.in_awake_window ||
+		    atomic_read(&sdata->u.mesh.num_mpsp)) {
+			allow = false;
+			break;
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	return allow;
+}
+
+static bool mps_doze_check_sta(struct ieee80211_local *local)
+{
+	struct sta_info *sta;
+	bool allow = true;
+
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list) {
+		if (!ieee80211_vif_is_mesh(&sta->sdata->vif) ||
+		    !ieee80211_sdata_running(sta->sdata) ||
+		    sta->plink_state != NL80211_PLINK_ESTAB) {
+			continue;
+		} else if (test_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_BEACON) ||
+			   test_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB)) {
+			allow = false;
+			break;
+		}
+	}
+	mutex_unlock(&local->sta_mtx);
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
+	if (!local->mps_enabled ||
+	    local->mps_hw_doze ||
+	    !mps_doze_check_vif(local) ||
+	    !mps_doze_check_sta(local))
+		return;
+
+	local->mps_hw_doze = true;
+	if (local->mps_ops)
+		local->mps_ops->hw_doze(&local->hw);
+}
+
+/**
+ * ieee80211_mps_wakeup - trigger radio wakeup immediately
+ *
+ * @local: local interface data
+ */
+void ieee80211_mps_wakeup(struct ieee80211_local *local)
+{
+	if (!local->mps_hw_doze)
+		return;
+
+	local->mps_hw_doze = false;
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
index 3d447a1..3e30788 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -142,6 +142,7 @@ static void cleanup_single_sta(struct sta_info *sta)
 		mesh_accept_plinks_update(sdata);
 		mesh_plink_deactivate(sta);
 		del_timer_sync(&sta->plink_timer);
+		hrtimer_cancel(&sta->mps_beacon_timer);
 	}
 #endif
 
@@ -385,6 +386,9 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 #ifdef CONFIG_MAC80211_MESH
 	sta->plink_state = NL80211_PLINK_LISTEN;
 	init_timer(&sta->plink_timer);
+	hrtimer_init(&sta->mps_beacon_timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_REL);
+	sta->mps_beacon_timer.function = ieee80211_mps_sta_tbtt_timer;
 #endif
 
 	return sta;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5a1deba..3bd1f96 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -16,6 +16,7 @@
 #include <linux/average.h>
 #include <linux/etherdevice.h>
 #include "key.h"
+#include <linux/hrtimer.h>
 
 /**
  * enum ieee80211_sta_info_flags - Stations flags
@@ -58,6 +59,8 @@
  * @WLAN_STA_TOFFSET_KNOWN: toffset calculated for this station is valid.
  * @WLAN_STA_MPSP_OWNER: local STA is owner of a mesh Peer Service Period.
  * @WLAN_STA_MPSP_RECIPIENT: local STA is recipient of a MPSP.
+ * @WLAN_STA_MPS_WAIT_FOR_BEACON: STA beacon is imminent
+ * @WLAN_STA_MPS_WAIT_FOR_CAB: STA multicast frames are imminent
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -82,6 +85,8 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_TOFFSET_KNOWN,
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
+	WLAN_STA_MPS_WAIT_FOR_BEACON,
+	WLAN_STA_MPS_WAIT_FOR_CAB,
 };
 
 #define ADDBA_RESP_INTERVAL HZ
@@ -289,6 +294,10 @@ struct sta_ampdu_mlme {
  * @local_pm: local link-specific power save mode
  * @peer_pm: peer-specific power save mode towards local STA
  * @nonpeer_pm: STA power save mode towards non-peer neighbors
+ * @beacon_interval: beacon interval of neighbor STA (in us)
+ * @mps_beacon_timer: timer to trigger wakeup and sleep events for beacons RX
+ * @tbtt_wakeup: absolute time to wakeup for this peer beacon
+ * @tbtt_miss: absolute time to give up waiting for this peer beacon
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -390,6 +399,10 @@ struct sta_info {
 	enum nl80211_mesh_power_mode local_pm;
 	enum nl80211_mesh_power_mode peer_pm;
 	enum nl80211_mesh_power_mode nonpeer_pm;
+	u32 beacon_interval;
+	struct hrtimer mps_beacon_timer;
+	ktime_t tbtt_wakeup;
+	ktime_t tbtt_miss;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1890441..e09f597 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2494,6 +2494,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
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

