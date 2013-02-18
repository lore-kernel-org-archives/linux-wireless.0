Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:59913 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab3BRQIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 11:08:42 -0500
Received: by mail-bk0-f43.google.com with SMTP id jm19so2613425bkc.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 08:08:40 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Cc: sleffler@google.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCHv2 2/3] mac80211: mesh power save doze scheduling
Date: Mon, 18 Feb 2013 17:08:28 +0100
Message-Id: <1361203709-16669-2-git-send-email-marco@cozybit.com> (sfid-20130218_170859_522559_CE6B8940)
In-Reply-To: <1361203709-16669-1-git-send-email-marco@cozybit.com>
References: <1361203709-16669-1-git-send-email-marco@cozybit.com>
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
towards. Calculate the next TBTT per STA. Stay awake to receive
multicast traffic after DTIM beacons.

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
 net/mac80211/mesh.c        |   11 ++
 net/mac80211/mesh.h        |   13 ++
 net/mac80211/mesh_plink.c  |    3 +
 net/mac80211/mesh_ps.c     |  313 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h    |   10 ++
 net/mac80211/tx.c          |    2 +
 8 files changed, 387 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f7eba13..a27383f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2801,6 +2801,18 @@ enum ieee80211_tpt_led_trigger_flags {
 	IEEE80211_TPT_LEDTRIG_FL_CONNECTED	= BIT(2),
 };
 
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
 #ifdef CONFIG_MAC80211_LEDS
 extern char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
 extern char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
@@ -4058,6 +4070,23 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
  */
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn);
 
+/**
+ * ieee80211_mps_init - register callbacks for mesh powersave mode
+ *
+ * @hw: the hardware
+ * @ops: callbacks for this device
+ *
+ * called by driver on mesh interface add/remove
+ */
+#ifdef CONFIG_MAC80211_MESH
+void ieee80211_mps_init(struct ieee80211_hw *hw,
+			const struct ieee80211_mps_ops *ops);
+#else
+static inline void ieee80211_mps_init(struct ieee80211_hw *hw,
+				      const struct ieee80211_mps_ops *ops)
+{ return; }
+#endif
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 631760f..c42a506 100644
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
@@ -1111,6 +1112,10 @@ struct ieee80211_local {
 
 	int user_power_level; /* in dBm, for all interfaces */
 
+	/* mesh power save can be enabled for multiple (but only mesh) vif */
+	bool mps_enabled;
+	const struct ieee80211_mps_ops *mps_ops;
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
index d40fedd..ab4b836 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -422,6 +422,8 @@ __mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *hw_addr)
 
 	sta->plink_state = NL80211_PLINK_LISTEN;
 	init_timer(&sta->plink_timer);
+	setup_timer(&sta->nexttbtt_timer, ieee80211_mps_sta_tbtt_timeout,
+		    (unsigned long) sta);
 
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
@@ -536,6 +538,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 		ifmsh->sync_ops->rx_bcn(sta, mgmt, elems, t_r);
 
 	ieee80211_mps_frame_release(sta, elems);
+	ieee80211_mps_sta_tbtt_update(sta, mgmt, elems->tim, t_r);
 out:
 	rcu_read_unlock();
 	ieee80211_mbss_info_change_notify(sdata, changed);
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 3b7bfc0..9199643 100644
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
 
@@ -551,6 +575,17 @@ void ieee80211_mpsp_trigger_process(u8 *qc, struct sta_info *sta,
 		if (rspi && !test_and_set_sta_flag(sta, WLAN_STA_MPSP_OWNER))
 			mps_frame_deliver(sta, -1);
 	}
+
+	if (!local->mps_enabled)
+		return;
+
+	if (test_sta_flag(sta, WLAN_STA_MPSP_OWNER) ||
+	    test_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT)) {
+		if (local->mps_ops)
+			local->mps_ops->hw_wakeup(&local->hw);
+	} else {
+		mps_queue_work(sta->sdata, MESH_WORK_PS_DOZE);
+	}
 }
 
 /**
@@ -596,3 +631,281 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
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
+ * @sdata: local mesh subif
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
+	if (enable && local->mps_ops)
+		local->mps_ops->hw_wakeup(&local->hw);
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
+	sta->beacon_interval = le16_to_cpu(mgmt->u.beacon.beacon_int) * 1024;
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
+
+	if (!local->mps_enabled)
+		return;
+
+	mps_dbg(sdata, "awake window start (%dTU)\n",
+		ifmsh->mshcfg.dot11MeshAwakeWindowDuration);
+
+	mod_timer(&ifmsh->awake_window_end_timer, jiffies + usecs_to_jiffies(
+			ifmsh->mshcfg.dot11MeshAwakeWindowDuration * 1024));
+
+	if (local->mps_ops)
+		local->mps_ops->hw_wakeup(&local->hw);
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
+	if (nexttbtt_min != ULLONG_MAX)
+		*nexttbtt = nexttbtt_min;
+
+	return allow;
+}
+
+/**
+ * ieee80211_mps_doze - trigger radio doze state after checking conditions
+ *
+ * @local: local interface data
+ */
+void ieee80211_mps_doze(struct ieee80211_local *local)
+{
+	u64 nexttbtt = 0;
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
+void ieee80211_mps_init(struct ieee80211_hw *hw,
+			const struct ieee80211_mps_ops *ops)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	if (!ops)
+		local->mps_enabled = false;
+	else if (WARN_ON(!ops->hw_doze || !ops->hw_wakeup))
+		return;
+
+	local->mps_ops = ops;
+}
+EXPORT_SYMBOL(ieee80211_mps_init);
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
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b9602b..a44c712 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2460,6 +2460,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
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

