Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEC3C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 23:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A0B220827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 23:17:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A0B220827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbeKJJAg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Nov 2018 04:00:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56790 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbeKJJAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Nov 2018 04:00:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 18CA960ADB; Fri,  9 Nov 2018 23:17:50 +0000 (UTC)
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 230DD607CA;
        Fri,  9 Nov 2018 23:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 230DD607CA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=pass (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=pass smtp.mailfrom=rmanohar@qti.qualcomm.com
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Fri, 09 Nov 2018 15:17:46 -0800
From:   Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v2 3/6] mac80211: Add airtime accounting and scheduling to TXQs
Date:   Fri,  9 Nov 2018 15:16:58 -0800
Message-Id: <1541805421-27309-4-git-send-email-rmanohar@qti.qualcomm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1541805421-27309-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1541805421-27309-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>

This adds airtime accounting and scheduling to the mac80211 TXQ
scheduler. A new callback, ieee80211_sta_register_airtime(), is added
that drivers can call to report airtime usage for stations.

When airtime information is present, mac80211 will schedule TXQs
(through ieee80211_next_txq()) in a way that enforces airtime fairness
between active stations. This scheduling works the same way as the ath9k
in-driver airtime fairness scheduling. If no airtime usage is reported
by the driver, the scheduler will default to round-robin scheduling.

For drivers that don't control TXQ scheduling in software, a new API
function, ieee80211_txq_may_transmit(), is added which the driver can use
to check if the TXQ is eligible for transmission, or should be throttled to
enforce fairness. Calls to this function must also be enclosed in
ieee80211_txq_schedule_{start,end}() calls to ensure proper locking.

The API ieee80211_txq_may_transmit() also ensures that TXQ list will be
aligned aginst driver's own round-robin scheduler list. i.e it rotates
the TXQ list till it makes the requested node becomes the first entry
in TXQ list. Thus both the TXQ list and driver's list are in sync.

Co-Developed-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 include/net/mac80211.h     | 59 ++++++++++++++++++++++++++++++
 net/mac80211/cfg.c         |  3 ++
 net/mac80211/debugfs.c     |  3 ++
 net/mac80211/debugfs_sta.c | 50 ++++++++++++++++++++++++--
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/main.c        |  4 +++
 net/mac80211/sta_info.c    | 44 +++++++++++++++++++++--
 net/mac80211/sta_info.h    | 13 +++++++
 net/mac80211/status.c      |  6 ++++
 net/mac80211/tx.c          | 90 +++++++++++++++++++++++++++++++++++++++++++---
 10 files changed, 264 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 18b11c119b7e..c43d615ee9b1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2357,6 +2357,9 @@ enum ieee80211_hw_flags {
  * @tx_sk_pacing_shift: Pacing shift to set on TCP sockets when frames from
  *	them are encountered. The default should typically not be changed,
  *	unless the driver has good reasons for needing more buffers.
+ *
+ * @weight_multipler: Driver specific airtime weight multiplier used while
+ *	refilling deficit of each TXQ.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -2393,6 +2396,7 @@ struct ieee80211_hw {
 	const struct ieee80211_cipher_scheme *cipher_schemes;
 	u8 max_nan_de_entries;
 	u8 tx_sk_pacing_shift;
+	u8 weight_multiplier;
 };
 
 static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
@@ -5393,6 +5397,34 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 void ieee80211_send_eosp_nullfunc(struct ieee80211_sta *pubsta, int tid);
 
 /**
+ * ieee80211_sta_register_airtime - register airtime usage for a sta/tid
+ *
+ * Register airtime usage for a given sta on a given tid. The driver can call
+ * this function to notify mac80211 that a station used a certain amount of
+ * airtime. This information will be used by the TXQ scheduler to schedule
+ * stations in a way that ensures airtime fairness.
+ *
+ * The reported airtime should as a minimum include all time that is spent
+ * transmitting to the remote station, including overhead and padding, but not
+ * including time spent waiting for a TXOP. If the time is not reported by the
+ * hardware it can in some cases be calculated from the rate and known frame
+ * composition. When possible, the time should include any failed transmission
+ * attempts.
+ *
+ * The driver can either call this function synchronously for every packet or
+ * aggregate, or asynchronously as airtime usage information becomes available.
+ * TX and RX airtime can be reported together, or separately by setting one of
+ * them to 0.
+ *
+ * @pubsta: the station
+ * @tid: the TID to register airtime for
+ * @tx_airtime: airtime used during TX (in usec)
+ * @rx_airtime: airtime used during RX (in usec)
+ */
+void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
+				    u32 tx_airtime, u32 rx_airtime);
+
+/**
  * ieee80211_iter_keys - iterate keys programmed into the device
  * @hw: pointer obtained from ieee80211_alloc_hw()
  * @vif: virtual interface to iterate, may be %NULL for all
@@ -6150,6 +6182,33 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac);
 
 /**
+ * ieee80211_txq_may_transmit - check whether TXQ is allowed to transmit
+ *
+ * This function is used to check whether given txq is allowed to transmit by
+ * the airtime scheduler, and can be used by drivers to access the airtime
+ * fairness accounting without going using the scheduling order enfored by
+ * next_txq().
+ *
+ * Returns %true if the airtime scheduler thinks the TXQ should be allowed to
+ * transmit, and %false if it should be throttled. This function can also have
+ * the side effect of rotating the TXQ in the scheduler rotation, which will
+ * eventually bring the deficit to positive and allow the station to transmit
+ * again.
+ *
+ * The API ieee80211_txq_may_transmit() also ensures that TXQ list will be
+ * aligned aginst driver's own round-robin scheduler list. i.e it rotates
+ * the TXQ list till it makes the requested node becomes the first entry
+ * in TXQ list. Thus both the TXQ list and driver's list are in sync. If this
+ * function returns %true, the driver is expected to schedule packets
+ * for transmission, and then return the TXQ through ieee80211_return_txq().
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ */
+bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
+				struct ieee80211_txq *txq);
+
+/**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
  * The values are not guaranteed to be coherent with regard to each other, i.e.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 818aa0060349..57c59e5ceb98 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1447,6 +1447,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		sta_apply_mesh_params(local, sta, params);
 
+	if (params->airtime_weight)
+		sta->airtime_weight = params->airtime_weight;
+
 	/* set the STA state after all sta info from usermode has been set */
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) ||
 	    set & BIT(NL80211_STA_FLAG_ASSOCIATED)) {
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3fe541e358f3..81c5fec2eae7 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -383,6 +383,9 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	if (local->ops->wake_tx_queue)
 		DEBUGFS_ADD_MODE(aqm, 0600);
 
+	debugfs_create_u16("airtime_flags", 0600,
+			   phyd, &local->airtime_flags);
+
 	statsd = debugfs_create_dir("statistics", phyd);
 
 	/* if the dir failed, don't put all the other things into the root! */
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index af5185a836e5..446908ab3f5d 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -181,9 +181,9 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 			       txqi->tin.tx_bytes,
 			       txqi->tin.tx_packets,
 			       txqi->flags,
-			       txqi->flags & (1<<IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
-			       txqi->flags & (1<<IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
-			       txqi->flags & (1<<IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : "");
+			       test_bit(IEEE80211_TXQ_STOP, &txqi->flags) ? "STOP" : "RUN",
+			       test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags) ? " AMPDU" : "",
+			       test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags) ? " NO-AMSDU" : "");
 	}
 
 	rcu_read_unlock();
@@ -195,6 +195,46 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(aqm);
 
+static ssize_t sta_airtime_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct ieee80211_local *local = sta->sdata->local;
+	size_t bufsz = 200;
+	char *buf = kzalloc(bufsz, GFP_KERNEL), *p = buf;
+	u64 rx_airtime = 0, tx_airtime = 0;
+	s64 deficit[IEEE80211_NUM_ACS];
+	ssize_t rv;
+	int ac;
+
+	if (!buf)
+		return -ENOMEM;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		spin_lock_bh(&local->active_txq_lock[ac]);
+		rx_airtime += sta->airtime[ac].rx_airtime;
+		tx_airtime += sta->airtime[ac].tx_airtime;
+		deficit[ac] = sta->airtime[ac].deficit;
+		spin_unlock_bh(&local->active_txq_lock[ac]);
+	}
+
+	p += scnprintf(p, bufsz + buf - p,
+		"RX: %llu us\nTX: %llu us\nWeight: %u\n"
+		"Deficit: VO: %lld us VI: %lld us BE: %lld us BK: %lld us\n",
+		rx_airtime,
+		tx_airtime,
+		sta->airtime_weight,
+		deficit[0],
+		deficit[1],
+		deficit[2],
+		deficit[3]);
+
+	rv = simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+	kfree(buf);
+	return rv;
+}
+STA_OPS(airtime);
+
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
@@ -906,6 +946,10 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	if (local->ops->wake_tx_queue)
 		DEBUGFS_ADD(aqm);
 
+	if (wiphy_ext_feature_isset(local->hw.wiphy,
+				    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+		DEBUGFS_ADD(airtime);
+
 	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
 		debugfs_create_x32("driver_buffered_tids", 0400,
 				   sta->debugfs_dir,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 33763a2eac81..c5b6ba571288 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1137,6 +1137,8 @@ struct ieee80211_local {
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
 
+	u16 airtime_flags;
+
 	const struct ieee80211_ops *ops;
 
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ba64757afea4..3710727fa9c1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -667,6 +667,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 		INIT_LIST_HEAD(&local->active_txqs[i]);
 		spin_lock_init(&local->active_txq_lock[i]);
 	}
+	local->airtime_flags = AIRTIME_USE_TX | AIRTIME_USE_RX;
 
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
@@ -1153,6 +1154,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (!local->hw.max_nan_de_entries)
 		local->hw.max_nan_de_entries = IEEE80211_MAX_NAN_INSTANCE_ID;
 
+	if (!local->hw.weight_multiplier)
+		local->hw.weight_multiplier = 1;
+
 	result = ieee80211_wep_init(local);
 	if (result < 0)
 		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c2f5cb7df54f..114277ff3624 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -90,7 +90,6 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	struct fq *fq = &local->fq;
 	struct ps_data *ps;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
@@ -120,9 +119,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 
 			txqi = to_txq_info(sta->sta.txq[i]);
 
-			spin_lock_bh(&fq->lock);
 			ieee80211_txq_purge(local, txqi);
-			spin_unlock_bh(&fq->lock);
 		}
 	}
 
@@ -387,9 +384,12 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	if (sta_prepare_rate_control(local, sta, gfp))
 		goto free_txq;
 
+	sta->airtime_weight = IEEE80211_DEFAULT_AIRTIME_WEIGHT;
+
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		skb_queue_head_init(&sta->ps_tx_buf[i]);
 		skb_queue_head_init(&sta->tx_filtered[i]);
+		sta->airtime[i].deficit = sta->airtime_weight;
 	}
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
@@ -1826,6 +1826,27 @@ void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 }
 EXPORT_SYMBOL(ieee80211_sta_set_buffered);
 
+void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
+				    u32 tx_airtime, u32 rx_airtime)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct ieee80211_local *local = sta->sdata->local;
+	u8 ac = ieee80211_ac_from_tid(tid);
+	u32 airtime = 0;
+
+	if (sta->local->airtime_flags & AIRTIME_USE_TX)
+		airtime += tx_airtime;
+	if (sta->local->airtime_flags & AIRTIME_USE_RX)
+		airtime += rx_airtime;
+
+	spin_lock_bh(&local->active_txq_lock[ac]);
+	sta->airtime[ac].tx_airtime += tx_airtime;
+	sta->airtime[ac].rx_airtime += rx_airtime;
+	sta->airtime[ac].deficit -= airtime;
+	spin_unlock_bh(&local->active_txq_lock[ac]);
+}
+EXPORT_SYMBOL(ieee80211_sta_register_airtime);
+
 int sta_info_move_state(struct sta_info *sta,
 			enum ieee80211_sta_state new_state)
 {
@@ -2188,6 +2209,23 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 	}
 
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_DURATION))) {
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+			sinfo->rx_duration += sta->airtime[ac].rx_airtime;
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_DURATION);
+	}
+
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_DURATION))) {
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+			sinfo->tx_duration += sta->airtime[ac].tx_airtime;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_DURATION);
+	}
+
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_AIRTIME_WEIGHT))) {
+		sinfo->airtime_weight = sta->airtime_weight;
+		sinfo->filled |= BIT(NL80211_STA_INFO_AIRTIME_WEIGHT);
+	}
+
 	sinfo->rx_dropped_misc = sta->rx_stats.dropped;
 	if (sta->pcpu_rx_stats) {
 		for_each_possible_cpu(cpu) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9a04327d71d1..b1b0fd6a2e21 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -127,6 +127,16 @@ enum ieee80211_agg_stop_reason {
 	AGG_STOP_DESTROY_STA,
 };
 
+/* Debugfs flags to enable/disable use of RX/TX airtime in scheduler */
+#define AIRTIME_USE_TX		BIT(0)
+#define AIRTIME_USE_RX		BIT(1)
+
+struct airtime_info {
+	u64 rx_airtime;
+	u64 tx_airtime;
+	s64 deficit;
+};
+
 struct sta_info;
 
 /**
@@ -563,6 +573,9 @@ struct sta_info {
 	} tx_stats;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
+	struct airtime_info airtime[IEEE80211_NUM_ACS];
+	u16 airtime_weight;
+
 	/*
 	 * Aggregation information, locked with lock.
 	 */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index aa4afbf0abaf..a1f1256448f5 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -818,6 +818,12 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data,
 						acked, info->status.tx_time);
 
+		if (info->status.tx_time &&
+		    wiphy_ext_feature_isset(local->hw.wiphy,
+					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+			ieee80211_sta_register_airtime(&sta->sta, tid,
+						       info->status.tx_time, 0);
+
 		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			if (info->flags & IEEE80211_TX_STAT_ACK) {
 				if (sta->status_stats.lost_packets)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 305965283506..dd2354188357 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1488,8 +1488,11 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
 
+	spin_lock_bh(&fq->lock);
 	fq_tin_reset(fq, tin, fq_skb_free_func);
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+	spin_unlock_bh(&fq->lock);
+
 	spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
 	list_del_init(&txqi->schedule_order);
 	spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);
@@ -3638,11 +3641,28 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 
 	lockdep_assert_held(&local->active_txq_lock[ac]);
 
+ begin:
 	txqi = list_first_entry_or_null(&local->active_txqs[ac],
 					struct txq_info,
 					schedule_order);
+	if (!txqi)
+		return NULL;
+
+	if (txqi->txq.sta) {
+		struct sta_info *sta = container_of(txqi->txq.sta,
+						struct sta_info, sta);
+
+		if (sta->airtime[txqi->txq.ac].deficit < 0) {
+			sta->airtime[txqi->txq.ac].deficit +=
+				sta->airtime_weight;
+			list_move_tail(&txqi->schedule_order,
+				       &local->active_txqs[txqi->txq.ac]);
+			goto begin;
+		}
+	}
+
 
-	if (!txqi || txqi->schedule_round == local->schedule_round[ac])
+	if (txqi->schedule_round == local->schedule_round[ac])
 		return NULL;
 
 	list_del_init(&txqi->schedule_order);
@@ -3660,12 +3680,74 @@ void ieee80211_return_txq(struct ieee80211_hw *hw,
 	lockdep_assert_held(&local->active_txq_lock[txq->ac]);
 
 	if (list_empty(&txqi->schedule_order) &&
-	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets))
-		list_add_tail(&txqi->schedule_order,
-			      &local->active_txqs[txq->ac]);
+	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets)) {
+		/* If airtime accounting is active, always enqueue STAs at the
+		 * head of the list to ensure that they only get moved to the
+		 * back by the airtime DRR scheduler once they have a negative
+		 * deficit. A station that already has a negative deficit will
+		 * get immediately moved to the back of the list on the next
+		 * call to ieee80211_next_txq().
+		 */
+		if (wiphy_ext_feature_isset(local->hw.wiphy,
+					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS)
+		    && txqi->txq.sta)
+			list_add(&txqi->schedule_order,
+				 &local->active_txqs[txq->ac]);
+		else
+			list_add_tail(&txqi->schedule_order,
+				      &local->active_txqs[txq->ac]);
+	}
 }
 EXPORT_SYMBOL(ieee80211_return_txq);
 
+bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
+				struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *iter, *tmp, *txqi = to_txq_info(txq);
+	struct sta_info *sta;
+	u8 ac = txq->ac;
+
+	lockdep_assert_held(&local->active_txq_lock[ac]);
+
+	if (!txqi->txq.sta)
+		goto out;
+
+	if (list_empty(&txqi->schedule_order))
+		goto out;
+
+	list_for_each_entry_safe(iter, tmp, &local->active_txqs[ac],
+				 schedule_order) {
+		if (iter == txqi)
+			break;
+
+		if (!iter->txq.sta) {
+			list_move_tail(&iter->schedule_order,
+				       &local->active_txqs[ac]);
+			continue;
+		}
+		sta = container_of(iter->txq.sta, struct sta_info, sta);
+		if (sta->airtime[ac].deficit < 0)
+			sta->airtime[ac].deficit += sta->airtime_weight;
+		list_move_tail(&iter->schedule_order, &local->active_txqs[ac]);
+	}
+
+	sta = container_of(txqi->txq.sta, struct sta_info, sta);
+	if (sta->airtime[ac].deficit >= 0)
+		goto out;
+
+	sta->airtime[ac].deficit += sta->airtime_weight;
+	list_move_tail(&txqi->schedule_order, &local->active_txqs[ac]);
+
+	return false;
+out:
+	if (!list_empty(&txqi->schedule_order))
+		list_del_init(&txqi->schedule_order);
+
+	return true;
+}
+EXPORT_SYMBOL(ieee80211_txq_may_transmit);
+
 void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-- 
1.9.1

