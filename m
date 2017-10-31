Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:39445 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751229AbdJaL15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 07:27:57 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v3 2/3] mac80211: Add airtime account and scheduling to TXQs
Date: Tue, 31 Oct 2017 12:27:46 +0100
Message-Id: <20171031112747.5778-2-toke@toke.dk> (sfid-20171031_122834_911903_B9EF6FA6)
In-Reply-To: <20171031112747.5778-1-toke@toke.dk>
References: <20171031112747.5778-1-toke@toke.dk>
In-Reply-To: <20171027141451.22768-1-toke@toke.dk>
References: <20171027141451.22768-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds airtime accounting and scheduling to the mac80211 TXQ
scheduler. A new hardware flag, AIRTIME_ACCOUNTING, is added that
drivers can set if they support reporting airtime usage of
transmissions. When this flag is set, mac80211 will expect the actual
airtime usage to be reported in the tx_time and rx_time fields of the
respective status structs.

When airtime information is present, mac80211 will schedule TXQs
(through ieee80211_next_txq()) in a way that enforces airtime fairness
between active stations. This scheduling works the same way as the ath9k
in-driver airtime fairness scheduling.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/mac80211.h     | 24 ++++++++++++++++++++++++
 net/mac80211/debugfs.c     |  1 +
 net/mac80211/debugfs_sta.c | 29 +++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  9 +++++++--
 net/mac80211/main.c        |  3 ++-
 net/mac80211/rx.c          |  8 ++++++++
 net/mac80211/sta_info.c    |  2 ++
 net/mac80211/sta_info.h    |  7 +++++++
 net/mac80211/status.c      | 16 ++++++++++++++++
 net/mac80211/tx.c          | 31 ++++++++++++++++++++++++++-----
 10 files changed, 122 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 715f45501aff..453653d082af 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1188,6 +1188,8 @@ enum mac80211_rx_encoding {
  *	HT or VHT is used (%RX_FLAG_HT/%RX_FLAG_VHT)
  * @nss: number of streams (VHT and HE only)
  * @flag: %RX_FLAG_\*
+ * @airtime: Duration of frame in usec. See @IEEE80211_HW_AIRTIME_ACCOUNTING for
+ *       how to use this.
  * @encoding: &enum mac80211_rx_encoding
  * @bw: &enum rate_info_bw
  * @enc_flags: uses bits from &enum mac80211_rx_encoding_flags
@@ -1202,6 +1204,7 @@ struct ieee80211_rx_status {
 	u32 device_timestamp;
 	u32 ampdu_reference;
 	u32 flag;
+	u16 airtime;
 	u16 freq;
 	u8 enc_flags;
 	u8 encoding:2, bw:3;
@@ -2059,6 +2062,26 @@ struct ieee80211_txq {
  *	The stack will not do fragmentation.
  *	The callback for @set_frag_threshold should be set as well.
  *
+ * @IEEE80211_HW_AIRTIME_ACCOUNTING: Hardware supports accounting the airtime
+ *      usage of other stations and reports it in the @tx_time and/or @airtime
+ *      fields of the TX/RX status structs.
+ *      When setting this flag, the driver should ensure that the respective
+ *      fields in the TX and RX status structs are always either zero or
+ *      contains a valid duration for the frame in usec. The driver can choose
+ *      to report either or both of TX and RX airtime, but it is recommended to
+ *      report both.
+ *      The reported airtime should as a minimum include all time that is spent
+ *      transmitting to the remote station, including overhead and padding, but
+ *      not including time spent waiting for a TXOP. If the time is not reported
+ *      by the hardware it can in some cases be calculated from the rate and
+ *      known frame composition. When possible, the time should include any
+ *      failed transmission attempts.
+ *      For aggregated frames, there are two possible strategies to report the
+ *      airtime: Either include the airtime of the entire aggregate in the first
+ *      (or last) frame and leave the others at zero. Alternatively, include the
+ *      overhead of the full aggregate in the first or last frame and report the
+ *      time of each frame + padding not including the full aggregate overhead.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2101,6 +2124,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_FRAG_LIST,
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
+	IEEE80211_HW_AIRTIME_ACCOUNTING,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5fae001f286c..20e3aa0e8464 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -211,6 +211,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TX_FRAG_LIST),
 	FLAG(REPORTS_LOW_ACK),
 	FLAG(SUPPORTS_TX_FRAG),
+	FLAG(AIRTIME_ACCOUNTING),
 #undef FLAG
 };
 
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index b15412c21ac9..40dba446836f 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -188,6 +188,32 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(aqm);
 
+static ssize_t sta_airtime_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	size_t bufsz = 200;
+	char *buf = kzalloc(bufsz, GFP_KERNEL), *p = buf;
+	ssize_t rv;
+
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock_bh(&sta->lock);
+
+	p += scnprintf(p, bufsz + buf - p,
+		"RX: %llu us\nTX: %llu us\nDeficit: %lld us\n",
+		sta->airtime_stats.rx_airtime,
+		sta->airtime_stats.tx_airtime,
+		sta->airtime_deficit);
+
+	spin_unlock_bh(&sta->lock);
+	rv = simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+	kfree(buf);
+	return rv;
+}
+STA_OPS(airtime);
+
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
@@ -542,6 +568,9 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	if (local->ops->wake_tx_queue)
 		DEBUGFS_ADD(aqm);
 
+	if (ieee80211_hw_check(&local->hw, AIRTIME_ACCOUNTING))
+		DEBUGFS_ADD(airtime);
+
 	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
 		debugfs_create_x32("driver_buffered_tids", 0400,
 				   sta->debugfs_dir,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 95be548b1d4f..e74aeff7662a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -90,6 +90,9 @@ extern const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS];
 
 #define IEEE80211_MAX_NAN_INSTANCE_ID 255
 
+/* How much to increase airtime deficit on each scheduling round */
+#define IEEE80211_AIRTIME_QUANTUM        1000 /* usec */
+
 struct ieee80211_fragment_entry {
 	struct sk_buff_head skb_list;
 	unsigned long first_frag_time;
@@ -1122,9 +1125,11 @@ struct ieee80211_local {
 	struct codel_vars *cvars;
 	struct codel_params cparams;
 
-	/* protects active_txqs and txqi->schedule_order */
+	/* protects active_txqs_{new,old} and txqi->schedule_order */
 	spinlock_t active_txq_lock;
-	struct list_head active_txqs;
+	struct list_head active_txqs_new;
+	struct list_head active_txqs_old;
+
 
 	const struct ieee80211_ops *ops;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 9ad0556aa24b..acf73c398d9b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -616,7 +616,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
-	INIT_LIST_HEAD(&local->active_txqs);
+	INIT_LIST_HEAD(&local->active_txqs_new);
+	INIT_LIST_HEAD(&local->active_txqs_old);
 	spin_lock_init(&local->active_txq_lock);
 
 	INIT_LIST_HEAD(&local->chanctx_list);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 70e9d2ca8bbe..a6166850b971 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1637,6 +1637,14 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 		ieee80211_mps_rx_h_sta_process(sta, hdr);
 
+	/* airtime accounting */
+	if (status->airtime) {
+		spin_lock_bh(&sta->lock);
+		sta->airtime_stats.rx_airtime += status->airtime;
+		sta->airtime_deficit -= status->airtime;
+		spin_unlock_bh(&sta->lock);
+	}
+
 	/*
 	 * Drop (qos-)data::nullfunc frames silently, since they
 	 * are used only to control station power saving mode.
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index da3737d4778f..e8511922a7c7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -433,6 +433,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->cparams.interval = MS2TIME(100);
 	sta->cparams.ecn = true;
 
+	sta->airtime_deficit = IEEE80211_AIRTIME_QUANTUM;
+
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
 	return sta;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5c54acd10562..5d1802f22550 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -550,6 +550,13 @@ struct sta_info {
 	} tx_stats;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
+	/* Airtime stats and deficit, protected by lock */
+	struct {
+		u64 rx_airtime;
+		u64 tx_airtime;
+	} airtime_stats;
+	s64 airtime_deficit;
+
 	/*
 	 * Aggregation information, locked with lock.
 	 */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index da7427a41529..cf7956f7a040 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -823,6 +823,14 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 				ieee80211_lost_packet(sta, info);
 			}
 		}
+
+		if (ieee80211_hw_check(&local->hw, AIRTIME_ACCOUNTING) &&
+		    info->status.tx_time) {
+			spin_lock_bh(&sta->lock);
+			sta->airtime_stats.tx_airtime += info->status.tx_time;
+			sta->airtime_deficit -= info->status.tx_time;
+			spin_unlock_bh(&sta->lock);
+		}
 	}
 
 	/* SNMP counters
@@ -947,6 +955,14 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 			sta->status_stats.retry_failed++;
 		sta->status_stats.retry_count += retry_count;
 
+		if (ieee80211_hw_check(&local->hw, AIRTIME_ACCOUNTING) &&
+		    info->status.tx_time) {
+			spin_lock_bh(&sta->lock);
+			sta->airtime_stats.tx_airtime += info->status.tx_time;
+			sta->airtime_deficit -= info->status.tx_time;
+			spin_unlock_bh(&sta->lock);
+		}
+
 		if (acked) {
 			sta->status_stats.last_ack = jiffies;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 824d87e6d3eb..409e84509625 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3530,7 +3530,7 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 	spin_lock_bh(&local->active_txq_lock);
 
 	if (list_empty(&txqi->schedule_order)) {
-		list_add_tail(&txqi->schedule_order, &local->active_txqs);
+		list_add_tail(&txqi->schedule_order, &local->active_txqs_new);
 		ret = true;
 	}
 
@@ -3544,14 +3544,35 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct txq_info *txqi = NULL;
+	struct list_head *head;
 
 	spin_lock_bh(&local->active_txq_lock);
 
-	if (list_empty(&local->active_txqs))
-		goto out;
+begin:
+	head = &local->active_txqs_new;
+	if (list_empty(head)) {
+		head = &local->active_txqs_old;
+		if (list_empty(head))
+			goto out;
+	}
+
+	txqi = list_first_entry(head, struct txq_info, schedule_order);
+
+	if (txqi->txq.sta) {
+		struct sta_info *sta = container_of(txqi->txq.sta,
+						struct sta_info, sta);
+
+		spin_lock_bh(&sta->lock);
+		if (sta->airtime_deficit < 0) {
+			sta->airtime_deficit += IEEE80211_AIRTIME_QUANTUM;
+			list_move_tail(&txqi->schedule_order,
+				       &local->active_txqs_old);
+			spin_unlock_bh(&sta->lock);
+			goto begin;
+		}
+		spin_unlock_bh(&sta->lock);
+	}
 
-	txqi = list_first_entry(&local->active_txqs,
-				struct txq_info, schedule_order);
 	list_del_init(&txqi->schedule_order);
 
 out:
-- 
2.14.3
