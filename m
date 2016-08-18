Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58019 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbcHRH3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2016 03:29:41 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
	Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH 1/3] mac80211: RX BA support for sta max_rx_aggregation_subframes
Date: Thu, 18 Aug 2016 10:36:25 +0300
Message-ID: <20160818073627.30972-2-maxim.altshul@ti.com> (sfid-20160818_092950_288548_05417005)
In-Reply-To: <20160818073627.30972-1-maxim.altshul@ti.com>
References: <20160818073627.30972-1-maxim.altshul@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ability to change the max_rx_aggregation frames is useful
in cases of IOP.

There exist some devices (latest mobile phones and some AP's)
that tend to not respect a BA sessions maximum size (in Kbps).
These devices won't respect the AMPDU size that was negotiated during
associasion (even though they do respect the maximal number of packets).

This violation is characterized by a valid number of packets in
a single AMPDU. Even so, the total size will exceed the size negotiated
during association.

Eventually, this will cause some undefined behavior, which in turn
causes the hw to drop packets, causing the throughput to plummet.

This patch will:
a. Make the subframe limitation to be held by each station,
instead of being held only by hw.
b. Create an api for the driver to call which will remove violating
BA sessions with a specific peer. When the session is reopened, it
will use the new size, limiting the aggregation.

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
 include/net/mac80211.h  | 22 ++++++++++++++++++++++
 net/mac80211/agg-rx.c   | 31 +++++++++++++++++++++++++++----
 net/mac80211/ht.c       | 18 ++++++++++++++++++
 net/mac80211/sta_info.c |  3 +++
 4 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cca510a..eec97d5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1735,6 +1735,9 @@ struct ieee80211_sta_rates {
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_cap: HT capabilities of this STA; restricted to our own capabilities
  * @vht_cap: VHT capabilities of this STA; restricted to our own capabilities
+ * @max_rx_aggregation_subframes: restriction on rx buff size for this active
+ *	aggregation. Initially set to local->hw.max_rx_aggregation_subframes but
+ *	can be modified by driver.
  * @wme: indicates whether the STA supports QoS/WME (if local devices does,
  *	otherwise always false)
  * @drv_priv: data area for driver use, will always be aligned to
@@ -1775,6 +1778,7 @@ struct ieee80211_sta {
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
 	struct ieee80211_sta_vht_cap vht_cap;
+	u8 max_rx_aggregation_subframes;
 	bool wme;
 	u8 uapsd_queues;
 	u8 max_sp;
@@ -5281,6 +5285,24 @@ void ieee80211_mark_rx_ba_filtered_frames(struct ieee80211_sta *pubsta, u8 tid,
 					  u16 received_mpdus);
 
 /**
+ * ieee80211_change_rx_ba_max_subframes - callback to change
+ * sta.max_rx_aggregation_subframes and stop existing BA sessions
+ *
+ * This capability is useful in cases of IOP, i.e. cases where peer sta
+ * or ap doesn't respect the max size (Kbps) of an AMPDU.
+ * In these cases the driver/chip may recover by decreasing the
+ * max_rx_aggregation_subframes, which will in turn reduce the size of
+ * the whole aggregation.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @addr: & to bssid mac address
+ * @max_subframes: new max_rx_aggregation_subframes for this sta
+ */
+void ieee80211_change_rx_ba_max_subframes(struct ieee80211_vif *vif,
+					  const u8 *addr,
+					  u8 max_subframes);
+
+/**
  * ieee80211_send_bar - send a BlockAckReq frame
  *
  * can be used to flush pending frames from the peer's aggregation reorder
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index a9aff60..8089234 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -147,6 +147,27 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
 }
 EXPORT_SYMBOL(ieee80211_stop_rx_ba_session);
 
+void ieee80211_change_rx_ba_max_subframes(struct ieee80211_vif *vif,
+					  const u8 *addr,
+					  u8 max_subframes)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	sta = sta_info_get_bss(sdata, addr);
+
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+
+	sta->sta.max_rx_aggregation_subframes = max_subframes;
+	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(ieee80211_change_rx_ba_max_subframes);
+
 /*
  * After accepting the AddBA Request we activated a timer,
  * resetting it after each frame that arrives from the originator.
@@ -297,13 +318,15 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	if (buf_size == 0)
 		buf_size = IEEE80211_MAX_AMPDU_BUF;
 
+	/* examine state machine */
+	mutex_lock(&sta->ampdu_mlme.mtx);
+
 	/* make sure the size doesn't exceed the maximum supported by the hw */
-	if (buf_size > local->hw.max_rx_aggregation_subframes)
-		buf_size = local->hw.max_rx_aggregation_subframes;
+	if (buf_size > sta->sta.max_rx_aggregation_subframes)
+		buf_size = sta->sta.max_rx_aggregation_subframes;
 	params.buf_size = buf_size;
 
-	/* examine state machine */
-	mutex_lock(&sta->ampdu_mlme.mtx);
+	ht_dbg(sta->sdata, "AddBA Req buf_size=%d\n", buf_size);
 
 	if (test_bit(tid, sta->ampdu_mlme.agg_session_valid)) {
 		tid_agg_rx = rcu_dereference_protected(
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index f4a5287..eaff7a8 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -305,6 +305,7 @@ void ieee80211_ba_session_work(struct work_struct *work)
 	struct sta_info *sta =
 		container_of(work, struct sta_info, ampdu_mlme.work);
 	struct tid_ampdu_tx *tid_tx;
+	struct tid_ampdu_rx *tid_rx;
 	int tid;
 
 	/*
@@ -329,6 +330,23 @@ void ieee80211_ba_session_work(struct work_struct *work)
 				sta, tid, WLAN_BACK_RECIPIENT,
 				WLAN_REASON_UNSPECIFIED, true);
 
+		/* Stop RX BA sessions affected by change of
+		 * sta.max_rx_aggregation_subframe
+		 */
+		tid_rx = sta->ampdu_mlme.tid_rx[tid];
+		if (tid_rx &&
+		    tid_rx->buf_size > sta->sta.max_rx_aggregation_subframes) {
+			ht_dbg(sta->sdata,
+			       "buf_size(%d) > max_subframes(%d) stopping tid %d\n",
+			       tid_rx->buf_size,
+			       sta->sta.max_rx_aggregation_subframes,
+			       tid);
+
+			___ieee80211_stop_rx_ba_session(
+				sta, tid, WLAN_BACK_RECIPIENT,
+				WLAN_REASON_UNSPECIFIED, true);
+		}
+
 		spin_lock_bh(&sta->lock);
 
 		tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 19f14c9..5e70fa5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -340,6 +340,9 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	memcpy(sta->addr, addr, ETH_ALEN);
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
+	sta->sta.max_rx_aggregation_subframes =
+		local->hw.max_rx_aggregation_subframes;
+
 	sta->local = local;
 	sta->sdata = sdata;
 	sta->rx_stats.last_rx = jiffies;
-- 
2.9.0
