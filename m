Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54335 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbbFROiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 10:38:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: remove local pointer from sta_info
Date: Thu, 18 Jun 2015 16:38:50 +0200
Message-Id: <1434638330-10799-1-git-send-email-johannes@sipsolutions.net> (sfid-20150618_163905_987388_1F68CB1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The pointer is pretty useless, you can always reach the
hw struct by sta->sdata->local or in other ways, so we
can remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c      |  6 +++---
 net/mac80211/agg-tx.c      |  4 ++--
 net/mac80211/cfg.c         |  4 ++--
 net/mac80211/debugfs_sta.c |  4 ++--
 net/mac80211/rx.c          |  6 +++---
 net/mac80211/sta_info.c    | 23 +++++++++++------------
 net/mac80211/sta_info.h    |  1 -
 net/mac80211/status.c      |  2 +-
 net/mac80211/tx.c          |  2 +-
 9 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 5c564a68fb50..8300b3864450 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -59,7 +59,7 @@ static void ieee80211_free_tid_rx(struct rcu_head *h)
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     u16 initiator, u16 reason, bool tx)
 {
-	struct ieee80211_local *local = sta->local;
+	struct ieee80211_local *local = sta->sdata->local;
 	struct tid_ampdu_rx *tid_rx;
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
@@ -126,7 +126,7 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
 		if (ba_rx_bitmap & BIT(i))
 			set_bit(i, sta->ampdu_mlme.tid_rx_stop_requested);
 
-	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
+	ieee80211_queue_work(&sdata->local->hw, &sta->ampdu_mlme.work);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_stop_rx_ba_session);
@@ -167,7 +167,7 @@ static void sta_rx_agg_session_timer_expired(unsigned long data)
 	       sta->sta.addr, (u16)*ptid);
 
 	set_bit(*ptid, sta->ampdu_mlme.tid_rx_timer_expired);
-	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
+	ieee80211_queue_work(&sta->sdata->local->hw, &sta->ampdu_mlme.work);
 }
 
 static void sta_rx_agg_reorder_timer_expired(unsigned long data)
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index c8ba2e77737c..b9a448f482de 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -292,7 +292,7 @@ static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_agg_stop_reason reason)
 {
-	struct ieee80211_local *local = sta->local;
+	struct ieee80211_local *local = sta->sdata->local;
 	struct tid_ampdu_tx *tid_tx;
 	enum ieee80211_ampdu_mlme_action action;
 	int ret;
@@ -442,8 +442,8 @@ static void sta_addba_resp_timer_expired(unsigned long data)
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
-	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	u16 start_seq_num;
 	int ret;
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5789d8353505..fdec0f966ae8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -452,7 +452,7 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		int shift = ieee80211_vif_get_shift(&sta->sdata->vif);
 		u16 brate;
 
-		sband = sta->local->hw.wiphy->bands[
+		sband = sta->sdata->local->hw.wiphy->bands[
 				ieee80211_get_sdata_band(sta->sdata)];
 		brate = sband->bitrates[rate->idx].bitrate;
 		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
@@ -485,7 +485,7 @@ void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 		int shift = ieee80211_vif_get_shift(&sta->sdata->vif);
 		u16 brate;
 
-		sband = sta->local->hw.wiphy->bands[
+		sband = sta->sdata->local->hw.wiphy->bands[
 				ieee80211_get_sdata_band(sta->sdata)];
 		brate = sband->bitrates[sta->last_rx_rate_idx].bitrate;
 		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 06d52935036d..d770ab92db23 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -335,8 +335,8 @@ STA_OPS(vht_capa);
 
 void ieee80211_sta_debugfs_add(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	struct dentry *stations_dir = sta->sdata->debugfs.subdir_stations;
 	u8 mac[3*ETH_ALEN];
 
@@ -386,8 +386,8 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 
 	drv_sta_remove_debugfs(local, sdata, &sta->sta, sta->debugfs.dir);
 	debugfs_remove_recursive(sta->debugfs.dir);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index eae50d095930..7067866a6836 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1280,7 +1280,7 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *pubsta, bool start)
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	bool in_ps;
 
-	WARN_ON(!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS));
+	WARN_ON(!ieee80211_hw_check(&sta->sdata->local->hw, AP_LINK_PS));
 
 	/* Don't let the same PS state be set twice */
 	in_ps = test_sta_flag(sta, WLAN_STA_PS_STA);
@@ -1451,7 +1451,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	 * Change STA power saving mode only at the end of a frame
 	 * exchange sequence.
 	 */
-	if (!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS) &&
+	if (!ieee80211_hw_check(&rx->local->hw, AP_LINK_PS) &&
 	    !ieee80211_has_morefrags(hdr->frame_control) &&
 	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
@@ -3248,7 +3248,7 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 	struct ieee80211_rx_data rx = {
 		.sta = sta,
 		.sdata = sta->sdata,
-		.local = sta->local,
+		.local = sta->sdata->local,
 		/* This is OK -- must be QoS data frame */
 		.security_idx = tid,
 		.seqno_idx = tid,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 494422729132..15f8bb5c3550 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -334,7 +334,6 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	memcpy(sta->addr, addr, ETH_ALEN);
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
-	sta->local = local;
 	sta->sdata = sdata;
 	sta->last_rx = jiffies;
 
@@ -488,8 +487,8 @@ static int sta_info_insert_drv_state(struct ieee80211_local *local,
  */
 static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 {
-	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	struct station_info sinfo;
 	int err = 0;
 
@@ -555,7 +554,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 {
-	struct ieee80211_local *local = sta->local;
+	struct ieee80211_local *local = sta->sdata->local;
 	int err;
 
 	might_sleep();
@@ -634,7 +633,7 @@ static unsigned long ieee80211_tids_for_ac(int ac)
 
 static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 {
-	struct ieee80211_local *local = sta->local;
+	struct ieee80211_local *local = sta->sdata->local;
 	struct ps_data *ps;
 	bool indicate_tim = false;
 	u8 ignore_for_tim = sta->sta.uapsd_queues;
@@ -849,8 +848,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	if (!sta)
 		return -ENOENT;
 
-	local = sta->local;
 	sdata = sta->sdata;
+	local = sdata->local;
 
 	lockdep_assert_held(&local->sta_mtx);
 
@@ -889,8 +888,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 
 static void __sta_info_destroy_part2(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	struct station_info sinfo = {};
 	int ret;
 
@@ -1631,7 +1630,7 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 
-	trace_api_sta_block_awake(sta->local, pubsta, block);
+	trace_api_sta_block_awake(sta->sdata->local, pubsta, block);
 
 	if (block) {
 		set_sta_flag(sta, WLAN_STA_PS_DRIVER);
@@ -1661,7 +1660,7 @@ EXPORT_SYMBOL(ieee80211_sta_block_awake);
 void ieee80211_sta_eosp(struct ieee80211_sta *pubsta)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
-	struct ieee80211_local *local = sta->local;
+	struct ieee80211_local *local = sta->sdata->local;
 
 	trace_api_eosp(local, pubsta);
 
@@ -1677,7 +1676,7 @@ void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 	if (WARN_ON(tid >= IEEE80211_NUM_TIDS))
 		return;
 
-	trace_api_sta_set_buffered(sta->local, pubsta, tid, buffered);
+	trace_api_sta_set_buffered(sta->sdata->local, pubsta, tid, buffered);
 
 	if (buffered)
 		set_bit(tid, &sta->driver_buffered_tids);
@@ -1730,7 +1729,7 @@ int sta_info_move_state(struct sta_info *sta,
 	 * fail the transition
 	 */
 	if (test_sta_flag(sta, WLAN_STA_INSERTED)) {
-		int err = drv_sta_state(sta->local, sta->sdata, sta,
+		int err = drv_sta_state(sta->sdata->local, sta->sdata, sta,
 					sta->sta_state, new_state);
 		if (err)
 			return err;
@@ -1937,8 +1936,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->rx_beacon_signal_avg = ieee80211_ave_rssi(&sdata->vif);
 	}
 
-	if (ieee80211_hw_check(&sta->local->hw, SIGNAL_DBM) ||
-	    ieee80211_hw_check(&sta->local->hw, SIGNAL_UNSPEC)) {
+	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM) ||
+	    ieee80211_hw_check(&local->hw, SIGNAL_UNSPEC)) {
 		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
 			sinfo->signal = (s8)sta->last_signal;
 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 013fa5ac36e2..4adad72a54fc 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -416,7 +416,6 @@ struct sta_info {
 	struct rcu_head rcu_head;
 	struct rhash_head hash_node;
 	u8 addr[ETH_ALEN];
-	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
 	struct ieee80211_key __rcu *ptk[NUM_DEFAULT_KEYS];
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index fe145668a30c..7bc6add7f360 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -178,8 +178,8 @@ static void ieee80211_check_pending_bar(struct sta_info *sta, u8 *addr, u8 tid)
 static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (void *) skb->data;
-	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 
 	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
 		sta->last_rx = jiffies;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9489b5da5a46..3a24648dbcbc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2423,8 +2423,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 void ieee80211_check_fast_xmit(struct sta_info *sta)
 {
 	struct ieee80211_fast_tx build = {}, *fast_tx = NULL, *old;
-	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr = (void *)build.hdr;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	__le16 fc;
-- 
2.1.4

