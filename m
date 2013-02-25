Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:62843 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759916Ab3BYQBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 11:01:09 -0500
Received: by mail-bk0-f44.google.com with SMTP id j4so1356370bkw.17
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 08:01:08 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Cc: sleffler@google.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCHv3 2/3] mac80211: mesh power save doze scheduling
Date: Mon, 25 Feb 2013 17:00:56 +0100
Message-Id: <1361808057-17899-2-git-send-email-marco@cozybit.com> (sfid-20130225_170118_685281_4D1B67FA)
In-Reply-To: <1361808057-17899-1-git-send-email-marco@cozybit.com>
References: <1361808057-17899-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the device for PS mode if the local mesh PS parameters
allow so and the driver supports it.

Add two callbacks to ieee80211_ops for mesh powersave:
- mesh_ps_doze - put the device to sleep now, wake up at given
  TBTT
- mesh_ps_wakeup - wake the device up now for frame RX
These ops may be extended in the future to allow drivers/HW to
implement mesh PS themselves. (Current design goal was to
concentrate most mesh PS routines in mac80211 to keep driver
modifications minimal.)

Track beacon timing information of peers we are in PS mode
towards. Calculate the next TBTT per STA. Stay awake to receive
multicast traffic after DTIM beacons.

When going to doze state, get the most imminent STA TBTT and
configure the device to trigger a wakeup on time to catch that
beacon. After successful receipt put the device to doze again.
Set a timeout for the case that the beacon is not received on
time. In this case calculate the following TBTT and go to doze
again.

For mesh Awake Windows wakeup on SWBA (beacon_get_tim) and start
a timer which triggers a doze call on expiry.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---

v3:
	use of ieee80211_tu_to_usec (Christian)
	use ieee80211_ops for mesh PS (Johannes)
	add tracing routines
	make mps_doze_check_sta always return nextbtt (Johannes)
	fixed comments for ieee80211_local (Johannes)

 include/net/mac80211.h     |   10 ++
 net/mac80211/driver-ops.h  |   24 ++++
 net/mac80211/ieee80211_i.h |    6 +-
 net/mac80211/mesh.c        |   11 ++
 net/mac80211/mesh.h        |   13 ++
 net/mac80211/mesh_plink.c  |    3 +
 net/mac80211/mesh_ps.c     |  298 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h    |   10 ++
 net/mac80211/trace.h       |   30 +++++
 net/mac80211/tx.c          |    2 +
 10 files changed, 406 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f7eba13..47bad0d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2557,6 +2557,11 @@ enum ieee80211_rate_control_changed {
  * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
  *	Currently, this is only called for managed or P2P client interfaces.
  *	This callback is optional; it must not sleep.
+ *
+ * @mesh_ps_doze: Put the device to doze state now; schedule wakeup at given
+ *	TSF value (if non-zero). This callback is optional and may sleep.
+ * @mesh_ps_wakeup: Wake the device up now. This callback is optional and may
+ *	sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2745,6 +2750,11 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct inet6_dev *idev);
 #endif
+
+#ifdef CONFIG_MAC80211_MESH
+	void (*mesh_ps_doze)(struct ieee80211_hw *hw, u64 nexttbtt);
+	void (*mesh_ps_wakeup)(struct ieee80211_hw *hw);
+#endif
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ee56d07..bbf3d24 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1090,4 +1090,28 @@ static inline void drv_ipv6_addr_change(struct ieee80211_local *local,
 }
 #endif
 
+#ifdef CONFIG_MAC80211_MESH
+
+static inline void drv_mesh_ps_doze(struct ieee80211_local *local, u64 nexttbtt)
+{
+	might_sleep();
+
+	trace_drv_mesh_ps_doze(local, nexttbtt);
+	if (local->ops->mesh_ps_doze)
+		local->ops->mesh_ps_doze(&local->hw, nexttbtt);
+	trace_drv_return_void(local);
+}
+
+static inline void drv_mesh_ps_wakeup(struct ieee80211_local *local)
+{
+	might_sleep();
+
+	trace_drv_mesh_ps_wakeup(local);
+	if (local->ops->mesh_ps_wakeup)
+		local->ops->mesh_ps_wakeup(&local->hw);
+	trace_drv_return_void(local);
+}
+
+#endif
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 631760f..dbb4bea 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -599,6 +599,7 @@ struct ieee80211_if_mesh {
 	int ps_peers_light_sleep;
 	int ps_peers_deep_sleep;
 	struct ps_data ps;
+	struct timer_list awake_window_end_timer;
 };
 
 #ifdef CONFIG_MAC80211_MESH
@@ -1092,7 +1093,7 @@ struct ieee80211_local {
 	bool pspolling;
 	bool offchannel_ps_enabled;
 	/*
-	 * PS can only be enabled when we have exactly one managed
+	 * managed mode PS can only be enabled when we have exactly one managed
 	 * interface (and monitors) in PS, this then points there.
 	 */
 	struct ieee80211_sub_if_data *ps_sdata;
@@ -1111,6 +1112,9 @@ struct ieee80211_local {
 
 	int user_power_level; /* in dBm, for all interfaces */
 
+	/* mesh power save can be enabled for multiple (but only mesh) vif */
+	bool mps_enabled;
+
 	enum ieee80211_smps_mode smps_mode;
 
 	struct work_struct restart_work;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 94682d2..61cfbe0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -168,6 +168,7 @@ void mesh_sta_cleanup(struct sta_info *sta)
 	if (sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) {
 		changed |= mesh_plink_deactivate(sta);
 		del_timer_sync(&sta->plink_timer);
+		del_timer_sync(&sta->nexttbtt_timer);
 	}
 
 	if (changed)
@@ -1026,6 +1027,7 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	if (ifmsh->preq_queue_len &&
@@ -1047,6 +1049,12 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 
 	if (test_and_clear_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags))
 		mesh_sync_adjust_tbtt(sdata);
+
+	if (test_and_clear_bit(MESH_WORK_PS_HW_CONF, &ifmsh->wrkq_flags))
+		ieee80211_mps_hw_conf(local);
+
+	if (test_and_clear_bit(MESH_WORK_PS_DOZE, &ifmsh->wrkq_flags))
+		ieee80211_mps_doze(local);
 }
 
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
@@ -1086,6 +1094,9 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
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
index ac02f38..8dd8637 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -58,6 +58,8 @@ enum mesh_path_flags {
  * @MESH_WORK_ROOT: the mesh root station needs to send a frame
  * @MESH_WORK_DRIFT_ADJUST: time to compensate for clock drift relative to other
  * mesh nodes
+ * @MESH_WORK_PS_HW_CONF: perform checks for PS mode and configure hardware
+ * @MESH_WORK_PS_DOZE: perform checks for doze state and put hardware to doze
  */
 enum mesh_deferred_task_flags {
 	MESH_WORK_HOUSEKEEPING,
@@ -65,6 +67,8 @@ enum mesh_deferred_task_flags {
 	MESH_WORK_GROW_MPP_TABLE,
 	MESH_WORK_ROOT,
 	MESH_WORK_DRIFT_ADJUST,
+	MESH_WORK_PS_HW_CONF,
+	MESH_WORK_PS_DOZE,
 };
 
 /**
@@ -256,6 +260,15 @@ void ieee80211_mpsp_trigger_process(u8 *qc, struct sta_info *sta,
 				    bool tx, bool acked);
 void ieee80211_mps_frame_release(struct sta_info *sta,
 				 struct ieee802_11_elems *elems);
+void ieee80211_mps_hw_conf(struct ieee80211_local *local);
+void ieee80211_mps_sta_tbtt_update(struct sta_info *sta,
+				   struct ieee80211_mgmt *mgmt,
+				   const struct ieee80211_tim_ie *tim,
+				   u64 tsf);
+void ieee80211_mps_sta_tbtt_timeout(unsigned long data);
+void ieee80211_mps_awake_window_start(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mps_awake_window_end(unsigned long data);
+void ieee80211_mps_doze(struct ieee80211_local *local);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index e34cfd1..bb4f8ec 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -422,6 +422,8 @@ __mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *hw_addr)
 
 	sta->plink_state = NL80211_PLINK_LISTEN;
 	init_timer(&sta->plink_timer);
+	setup_timer(&sta->nexttbtt_timer, ieee80211_mps_sta_tbtt_timeout,
+		    (unsigned long) sta);
 
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
@@ -538,6 +540,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 			ifmsh->sync_ops->rx_bcn(sta, mgmt, elems, t_r);
 
 		ieee80211_mps_frame_release(sta, elems);
+		ieee80211_mps_sta_tbtt_update(sta, mgmt, elems->tim, t_r);
 	}
 out:
 	rcu_read_unlock();
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 3b7bfc0..d877816 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -9,6 +9,18 @@
 
 #include "mesh.h"
 #include "wme.h"
+#include "driver-ops.h"
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
@@ -137,6 +149,8 @@ u32 ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
 	ifmsh->ps_peers_light_sleep = light_sleep_cnt;
 	ifmsh->ps_peers_deep_sleep = deep_sleep_cnt;
 
+	mps_queue_work(sdata, MESH_WORK_PS_HW_CONF);
+
 	return changed;
 }
 
@@ -329,6 +343,8 @@ static void mps_set_sta_nonpeer_pm(struct sta_info *sta,
 void ieee80211_mps_rx_h_sta_process(struct sta_info *sta,
 				    struct ieee80211_hdr *hdr)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
 	if (is_unicast_ether_addr(hdr->addr1) &&
 	    ieee80211_is_data_qos(hdr->frame_control)) {
 		/*
@@ -346,6 +362,13 @@ void ieee80211_mps_rx_h_sta_process(struct sta_info *sta,
 		 * (see IEEE802.11-2012 8.2.4.1.7)
 		 */
 		mps_set_sta_nonpeer_pm(sta, hdr);
+
+		/* resume doze after multicast receipt */
+		if (sdata->local->mps_enabled &&
+		    is_multicast_ether_addr(hdr->addr1) &&
+		    !ieee80211_has_moredata(hdr->frame_control) &&
+		    test_and_clear_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB))
+			mps_queue_work(sdata, MESH_WORK_PS_DOZE);
 	}
 }
 
@@ -529,6 +552,7 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 void ieee80211_mpsp_trigger_process(u8 *qc, struct sta_info *sta,
 				    bool tx, bool acked)
 {
+	struct ieee80211_local *local = sta->sdata->local;
 	u8 rspi = qc[1] & (IEEE80211_QOS_CTL_RSPI >> 8);
 	u8 eosp = qc[0] & IEEE80211_QOS_CTL_EOSP;
 
@@ -551,6 +575,15 @@ void ieee80211_mpsp_trigger_process(u8 *qc, struct sta_info *sta,
 		if (rspi && !test_and_set_sta_flag(sta, WLAN_STA_MPSP_OWNER))
 			mps_frame_deliver(sta, -1);
 	}
+
+	if (!local->mps_enabled)
+		return;
+
+	if (test_sta_flag(sta, WLAN_STA_MPSP_OWNER) ||
+	    test_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT))
+		drv_mesh_ps_wakeup(local);
+	else
+		mps_queue_work(sta->sdata, MESH_WORK_PS_DOZE);
 }
 
 /**
@@ -596,3 +629,268 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
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
+	if (!local->ops->mesh_ps_doze ||
+	    !local->ops->mesh_ps_wakeup)
+		return false;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		/* disallow PS if an AP or any other non-mesh vif is found */
+		if (ieee80211_sdata_running(sdata) &&
+		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT) {
+			enable = false;
+			break;
+		}
+
+		ifmsh = &sdata->u.mesh;
+
+		/*
+		 * Check for non-peer power mode and links in active mode.
+		 * Assume a valid power mode for each established peer link.
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
+ * ieee80211_mps_hw_conf - check conditions for mesh PS and configure driver
+ *
+ * @local: mac80211 hw info struct
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
+	if (enable)
+		local->hw.conf.flags |= IEEE80211_CONF_PS;
+	else
+		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	local->mps_enabled = enable;
+
+	/* receive all peer beacons once before doze */
+	if (enable)
+		drv_mesh_ps_wakeup(local);
+}
+
+static void mps_sta_nexttbtt_calc(struct sta_info *sta,
+				  const struct ieee80211_tim_ie *tim,
+				  u64 tsf_local)
+{
+	u64 tsf_peer;
+	int skip = 1;
+	u32 nexttbtt_interval;
+
+	/* simple Deep Sleep implementation: only wake up for DTIM beacons */
+	if (tim && sta->local_pm == NL80211_MESH_POWER_DEEP_SLEEP)
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
+				   const struct ieee80211_tim_ie *tim,
+				   u64 tsf_local)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
+	if (!sdata->local->mps_enabled ||
+	    sta->plink_state != NL80211_PLINK_ESTAB)
+		return;
+
+	sta->beacon_interval = ieee80211_tu_to_usec(
+			le16_to_cpu(mgmt->u.beacon.beacon_int));
+	if (tim && tim->bitmap_ctrl & 0x01) /* multicasts after DTIM? */
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
+	struct sta_info *sta = (void *) data;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
+	spin_lock_bh(&sta->lock);
+
+	if (!sdata->local->mps_enabled ||
+	    sta->plink_state != NL80211_PLINK_ESTAB) {
+		spin_unlock_bh(&sta->lock);
+		return;
+	}
+
+	sta->nexttbtt_tsf += sta->beacon_interval;
+	sta->nexttbtt_jiffies += usecs_to_jiffies(sta->beacon_interval);
+	mod_timer(&sta->nexttbtt_timer, sta->nexttbtt_jiffies +
+			usecs_to_jiffies(BEACON_TIMEOUT));
+	mps_queue_work(sdata, MESH_WORK_PS_DOZE);
+	mps_dbg(sdata, "beacon miss %pM\n", sta->sta.addr);
+
+	spin_unlock_bh(&sta->lock);
+}
+
+/**
+ * ieee80211_mps_awake_window_start - start Awake Window on SWBA/PRETBTT
+ *
+ * @sdata: local mesh subif
+ *
+ * TODO called from ieee80211_beacon_get_tim as time reference for TBTT,
+ * but mac80211 API guarantees neither exact timing nor periodicity
+ */
+void ieee80211_mps_awake_window_start(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	unsigned long timeout;
+
+	if (!local->mps_enabled)
+		return;
+
+	mps_dbg(sdata, "awake window start (%dTU)\n",
+		ifmsh->mshcfg.dot11MeshAwakeWindowDuration);
+
+	timeout = jiffies + usecs_to_jiffies(ieee80211_tu_to_usec(
+			ifmsh->mshcfg.dot11MeshAwakeWindowDuration));
+	mod_timer(&ifmsh->awake_window_end_timer, timeout);
+
+	drv_mesh_ps_wakeup(local);
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
+			   !timer_pending(&sta->nexttbtt_timer) ||
+			   time_after(jiffies, sta->nexttbtt_jiffies)) {
+			allow = false;
+			break;
+		} else if (sta->nexttbtt_tsf < nexttbtt_min) {
+			nexttbtt_min = sta->nexttbtt_tsf;
+		}
+	}
+	mutex_unlock(&local->sta_mtx);
+
+	*nexttbtt = (nexttbtt_min != ULLONG_MAX ? nexttbtt_min : 0);
+
+	return allow;
+}
+
+/**
+ * ieee80211_mps_doze - trigger radio doze state after checking conditions
+ *
+ * @local: mac80211 hw info struct
+ */
+void ieee80211_mps_doze(struct ieee80211_local *local)
+{
+	u64 nexttbtt;
+
+	if (!local->mps_enabled ||
+	    !mps_doze_check_vif(local) ||
+	    !mps_doze_check_sta(local, &nexttbtt))
+		return;
+
+	drv_mesh_ps_doze(local, nexttbtt);
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4947341..3d25b6b 100644
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
@@ -288,6 +290,10 @@ struct sta_ampdu_mlme {
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
@@ -389,6 +395,10 @@ struct sta_info {
 	enum nl80211_mesh_power_mode local_pm;
 	enum nl80211_mesh_power_mode peer_pm;
 	enum nl80211_mesh_power_mode nonpeer_pm;
+	u32 beacon_interval;
+	u64 nexttbtt_tsf;
+	unsigned long nexttbtt_jiffies;
+	struct timer_list nexttbtt_timer;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 3d7cd2a..6b71838 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1450,6 +1450,36 @@ DEFINE_EVENT(local_sdata_evt, drv_ipv6_addr_change,
 );
 #endif
 
+#ifdef CONFIG_MAC80211_MESH
+
+TRACE_EVENT(drv_mesh_ps_doze,
+	TP_PROTO(struct ieee80211_local *local, u64 nexttbtt),
+
+	TP_ARGS(local, nexttbtt),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u64, nexttbtt)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->nexttbtt = nexttbtt;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " nexttbtt:%llu",
+		LOCAL_PR_ARG, (unsigned long long)__entry->nexttbtt
+	)
+);
+
+DEFINE_EVENT(local_only_evt, drv_mesh_ps_wakeup,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local)
+);
+
+#endif
+
 /*
  * Tracing for API calls that drivers call.
  */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c79860f..9f12ce6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2475,6 +2475,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		memcpy(skb_put(skb, bcn->head_len), bcn->head, bcn->head_len);
 		ieee80211_beacon_add_tim(sdata, &ifmsh->ps, skb);
 		memcpy(skb_put(skb, bcn->tail_len), bcn->tail, bcn->tail_len);
+
+		ieee80211_mps_awake_window_start(sdata);
 	} else {
 		WARN_ON(1);
 		goto out;
-- 
1.7.9.5

