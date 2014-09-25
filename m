Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37492 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaIYKof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 06:44:35 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so7624835wgg.8
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2014 03:44:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/4] ath10k: split wmi stats parsing
Date: Thu, 25 Sep 2014 12:33:47 +0200
Message-Id: <1411641230-18785-2-git-send-email-michal.kazior@tieto.com> (sfid-20140925_124439_206548_9381EE16)
In-Reply-To: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The parsing function was rather complex. Simplify
by splitting it up into firmware branch specific
implementations.

While at it move the parsing code into wmi.c where
it belongs.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 127 ++----------------------
 drivers/net/wireless/ath/ath10k/debug.h |   5 +-
 drivers/net/wireless/ath/ath10k/wmi.c   | 165 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h   |  24 ++---
 4 files changed, 180 insertions(+), 141 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 101c6f9..0afd1aa 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -242,133 +242,22 @@ static const struct file_operations fops_wmi_services = {
 	.llseek = default_llseek,
 };
 
-void ath10k_debug_read_target_stats(struct ath10k *ar,
-				    struct wmi_stats_event *ev)
+void ath10k_debug_read_target_stats(struct ath10k *ar, struct sk_buff *skb)
 {
-	u8 *tmp = ev->data;
-	struct ath10k_target_stats *stats;
-	int num_pdev_stats, num_vdev_stats, num_peer_stats;
-	struct wmi_pdev_stats_10x *ps;
-	int i;
+	int ret;
 
 	spin_lock_bh(&ar->data_lock);
 
-	stats = &ar->debug.target_stats;
-
-	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats); /* 0 or 1 */
-	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats); /* 0 or max vdevs */
-	num_peer_stats = __le32_to_cpu(ev->num_peer_stats); /* 0 or max peers */
-
-	if (num_pdev_stats) {
-		ps = (struct wmi_pdev_stats_10x *)tmp;
-
-		stats->ch_noise_floor = __le32_to_cpu(ps->chan_nf);
-		stats->tx_frame_count = __le32_to_cpu(ps->tx_frame_count);
-		stats->rx_frame_count = __le32_to_cpu(ps->rx_frame_count);
-		stats->rx_clear_count = __le32_to_cpu(ps->rx_clear_count);
-		stats->cycle_count = __le32_to_cpu(ps->cycle_count);
-		stats->phy_err_count = __le32_to_cpu(ps->phy_err_count);
-		stats->chan_tx_power = __le32_to_cpu(ps->chan_tx_pwr);
-
-		stats->comp_queued = __le32_to_cpu(ps->wal.tx.comp_queued);
-		stats->comp_delivered =
-			__le32_to_cpu(ps->wal.tx.comp_delivered);
-		stats->msdu_enqued = __le32_to_cpu(ps->wal.tx.msdu_enqued);
-		stats->mpdu_enqued = __le32_to_cpu(ps->wal.tx.mpdu_enqued);
-		stats->wmm_drop = __le32_to_cpu(ps->wal.tx.wmm_drop);
-		stats->local_enqued = __le32_to_cpu(ps->wal.tx.local_enqued);
-		stats->local_freed = __le32_to_cpu(ps->wal.tx.local_freed);
-		stats->hw_queued = __le32_to_cpu(ps->wal.tx.hw_queued);
-		stats->hw_reaped = __le32_to_cpu(ps->wal.tx.hw_reaped);
-		stats->underrun = __le32_to_cpu(ps->wal.tx.underrun);
-		stats->tx_abort = __le32_to_cpu(ps->wal.tx.tx_abort);
-		stats->mpdus_requed = __le32_to_cpu(ps->wal.tx.mpdus_requed);
-		stats->tx_ko = __le32_to_cpu(ps->wal.tx.tx_ko);
-		stats->data_rc = __le32_to_cpu(ps->wal.tx.data_rc);
-		stats->self_triggers = __le32_to_cpu(ps->wal.tx.self_triggers);
-		stats->sw_retry_failure =
-			__le32_to_cpu(ps->wal.tx.sw_retry_failure);
-		stats->illgl_rate_phy_err =
-			__le32_to_cpu(ps->wal.tx.illgl_rate_phy_err);
-		stats->pdev_cont_xretry =
-			__le32_to_cpu(ps->wal.tx.pdev_cont_xretry);
-		stats->pdev_tx_timeout =
-			__le32_to_cpu(ps->wal.tx.pdev_tx_timeout);
-		stats->pdev_resets = __le32_to_cpu(ps->wal.tx.pdev_resets);
-		stats->phy_underrun = __le32_to_cpu(ps->wal.tx.phy_underrun);
-		stats->txop_ovf = __le32_to_cpu(ps->wal.tx.txop_ovf);
-
-		stats->mid_ppdu_route_change =
-			__le32_to_cpu(ps->wal.rx.mid_ppdu_route_change);
-		stats->status_rcvd = __le32_to_cpu(ps->wal.rx.status_rcvd);
-		stats->r0_frags = __le32_to_cpu(ps->wal.rx.r0_frags);
-		stats->r1_frags = __le32_to_cpu(ps->wal.rx.r1_frags);
-		stats->r2_frags = __le32_to_cpu(ps->wal.rx.r2_frags);
-		stats->r3_frags = __le32_to_cpu(ps->wal.rx.r3_frags);
-		stats->htt_msdus = __le32_to_cpu(ps->wal.rx.htt_msdus);
-		stats->htt_mpdus = __le32_to_cpu(ps->wal.rx.htt_mpdus);
-		stats->loc_msdus = __le32_to_cpu(ps->wal.rx.loc_msdus);
-		stats->loc_mpdus = __le32_to_cpu(ps->wal.rx.loc_mpdus);
-		stats->oversize_amsdu =
-			__le32_to_cpu(ps->wal.rx.oversize_amsdu);
-		stats->phy_errs = __le32_to_cpu(ps->wal.rx.phy_errs);
-		stats->phy_err_drop = __le32_to_cpu(ps->wal.rx.phy_err_drop);
-		stats->mpdu_errs = __le32_to_cpu(ps->wal.rx.mpdu_errs);
-
-		if (test_bit(ATH10K_FW_FEATURE_WMI_10X,
-			     ar->fw_features)) {
-			stats->ack_rx_bad = __le32_to_cpu(ps->ack_rx_bad);
-			stats->rts_bad = __le32_to_cpu(ps->rts_bad);
-			stats->rts_good = __le32_to_cpu(ps->rts_good);
-			stats->fcs_bad = __le32_to_cpu(ps->fcs_bad);
-			stats->no_beacons = __le32_to_cpu(ps->no_beacons);
-			stats->mib_int_count = __le32_to_cpu(ps->mib_int_count);
-			tmp += sizeof(struct wmi_pdev_stats_10x);
-		} else {
-			tmp += sizeof(struct wmi_pdev_stats_old);
-		}
-	}
-
-	/* 0 or max vdevs */
-	/* Currently firmware does not support VDEV stats */
-	if (num_vdev_stats) {
-		struct wmi_vdev_stats *vdev_stats;
-
-		for (i = 0; i < num_vdev_stats; i++) {
-			vdev_stats = (struct wmi_vdev_stats *)tmp;
-			tmp += sizeof(struct wmi_vdev_stats);
-		}
+	ret = ath10k_wmi_pull_fw_stats(ar, skb, &ar->debug.target_stats);
+	if (ret) {
+		ath10k_warn(ar, "failed to pull fw stats: %d\n", ret);
+		goto unlock;
 	}
 
-	if (num_peer_stats) {
-		struct wmi_peer_stats_10x *peer_stats;
-		struct ath10k_peer_stat *s;
-
-		stats->peers = num_peer_stats;
-
-		for (i = 0; i < num_peer_stats; i++) {
-			peer_stats = (struct wmi_peer_stats_10x *)tmp;
-			s = &stats->peer_stat[i];
-
-			memcpy(s->peer_macaddr, &peer_stats->peer_macaddr.addr,
-			       ETH_ALEN);
-			s->peer_rssi = __le32_to_cpu(peer_stats->peer_rssi);
-			s->peer_tx_rate =
-				__le32_to_cpu(peer_stats->peer_tx_rate);
-			if (test_bit(ATH10K_FW_FEATURE_WMI_10X,
-				     ar->fw_features)) {
-				s->peer_rx_rate =
-					__le32_to_cpu(peer_stats->peer_rx_rate);
-				tmp += sizeof(struct wmi_peer_stats_10x);
-
-			} else {
-				tmp += sizeof(struct wmi_peer_stats_old);
-			}
-		}
-	}
+	complete(&ar->debug.event_stats_compl);
 
+unlock:
 	spin_unlock_bh(&ar->data_lock);
-	complete(&ar->debug.event_stats_compl);
 }
 
 static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index d6276fe..f7e8131 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -55,8 +55,7 @@ void ath10k_debug_unregister(struct ath10k *ar);
 void ath10k_debug_read_service_map(struct ath10k *ar,
 				   const void *service_map,
 				   size_t map_size);
-void ath10k_debug_read_target_stats(struct ath10k *ar,
-				    struct wmi_stats_event *ev);
+void ath10k_debug_read_target_stats(struct ath10k *ar, struct sk_buff *skb);
 struct ath10k_fw_crash_data *
 ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
 
@@ -99,7 +98,7 @@ static inline void ath10k_debug_read_service_map(struct ath10k *ar,
 }
 
 static inline void ath10k_debug_read_target_stats(struct ath10k *ar,
-						  struct wmi_stats_event *ev)
+						  struct sk_buff *skb)
 {
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index bfc1fb3..8e2d021 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1329,14 +1329,171 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
+static void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
+				       struct ath10k_target_stats *dst)
+{
+	const struct wal_dbg_tx_stats *tx = &src->wal.tx;
+	const struct wal_dbg_rx_stats *rx = &src->wal.rx;
+
+	dst->ch_noise_floor = __le32_to_cpu(src->chan_nf);
+	dst->tx_frame_count = __le32_to_cpu(src->tx_frame_count);
+	dst->rx_frame_count = __le32_to_cpu(src->rx_frame_count);
+	dst->rx_clear_count = __le32_to_cpu(src->rx_clear_count);
+	dst->cycle_count = __le32_to_cpu(src->cycle_count);
+	dst->phy_err_count = __le32_to_cpu(src->phy_err_count);
+	dst->chan_tx_power = __le32_to_cpu(src->chan_tx_pwr);
+
+	dst->comp_queued = __le32_to_cpu(tx->comp_queued);
+	dst->comp_delivered = __le32_to_cpu(tx->comp_delivered);
+	dst->msdu_enqued = __le32_to_cpu(tx->msdu_enqued);
+	dst->mpdu_enqued = __le32_to_cpu(tx->mpdu_enqued);
+	dst->wmm_drop = __le32_to_cpu(tx->wmm_drop);
+	dst->local_enqued = __le32_to_cpu(tx->local_enqued);
+	dst->local_freed = __le32_to_cpu(tx->local_freed);
+	dst->hw_queued = __le32_to_cpu(tx->hw_queued);
+	dst->hw_reaped = __le32_to_cpu(tx->hw_reaped);
+	dst->underrun = __le32_to_cpu(tx->underrun);
+	dst->tx_abort = __le32_to_cpu(tx->tx_abort);
+	dst->mpdus_requed = __le32_to_cpu(tx->mpdus_requed);
+	dst->tx_ko = __le32_to_cpu(tx->tx_ko);
+	dst->data_rc = __le32_to_cpu(tx->data_rc);
+	dst->self_triggers = __le32_to_cpu(tx->self_triggers);
+	dst->sw_retry_failure = __le32_to_cpu(tx->sw_retry_failure);
+	dst->illgl_rate_phy_err = __le32_to_cpu(tx->illgl_rate_phy_err);
+	dst->pdev_cont_xretry = __le32_to_cpu(tx->pdev_cont_xretry);
+	dst->pdev_tx_timeout = __le32_to_cpu(tx->pdev_tx_timeout);
+	dst->pdev_resets = __le32_to_cpu(tx->pdev_resets);
+	dst->phy_underrun = __le32_to_cpu(tx->phy_underrun);
+	dst->txop_ovf = __le32_to_cpu(tx->txop_ovf);
+
+	dst->mid_ppdu_route_change = __le32_to_cpu(rx->mid_ppdu_route_change);
+	dst->status_rcvd = __le32_to_cpu(rx->status_rcvd);
+	dst->r0_frags = __le32_to_cpu(rx->r0_frags);
+	dst->r1_frags = __le32_to_cpu(rx->r1_frags);
+	dst->r2_frags = __le32_to_cpu(rx->r2_frags);
+	dst->r3_frags = __le32_to_cpu(rx->r3_frags);
+	dst->htt_msdus = __le32_to_cpu(rx->htt_msdus);
+	dst->htt_mpdus = __le32_to_cpu(rx->htt_mpdus);
+	dst->loc_msdus = __le32_to_cpu(rx->loc_msdus);
+	dst->loc_mpdus = __le32_to_cpu(rx->loc_mpdus);
+	dst->oversize_amsdu = __le32_to_cpu(rx->oversize_amsdu);
+	dst->phy_errs = __le32_to_cpu(rx->phy_errs);
+	dst->phy_err_drop = __le32_to_cpu(rx->phy_err_drop);
+	dst->mpdu_errs = __le32_to_cpu(rx->mpdu_errs);
+}
+
+static void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
+				       struct ath10k_peer_stat *dst)
+{
+	ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
+	dst->peer_rssi = __le32_to_cpu(src->peer_rssi);
+	dst->peer_tx_rate = __le32_to_cpu(src->peer_tx_rate);
+}
+
+static int ath10k_wmi_main_pull_fw_stats(struct ath10k *ar,
+					 struct sk_buff *skb,
+					 struct ath10k_target_stats *stats)
+{
+	const struct wmi_stats_event *ev = (void *)skb->data;
+	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
+	int i;
+
+	if (!skb_pull(skb, sizeof(*ev)))
+		return -EPROTO;
+
+	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
+	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
+	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
+
+	if (num_pdev_stats) {
+		const struct wmi_pdev_stats *src;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		ath10k_wmi_pull_pdev_stats(src, stats);
+	}
+
+	/* fw doesn't implement vdev stats */
+
+	for (i = 0; i < num_peer_stats; i++) {
+		const struct wmi_peer_stats *src;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		ath10k_wmi_pull_peer_stats(src, &stats->peer_stat[i]);
+	}
+
+	return 0;
+}
+
+static int ath10k_wmi_10x_pull_fw_stats(struct ath10k *ar,
+					struct sk_buff *skb,
+					struct ath10k_target_stats *stats)
+{
+	const struct wmi_stats_event *ev = (void *)skb->data;
+	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
+	int i;
+
+	if (!skb_pull(skb, sizeof(*ev)))
+		return -EPROTO;
+
+	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
+	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
+	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
+
+	if (num_pdev_stats) {
+		const struct wmi_10x_pdev_stats *src;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		ath10k_wmi_pull_pdev_stats(&src->old, stats);
+
+		stats->ack_rx_bad = __le32_to_cpu(src->ack_rx_bad);
+		stats->rts_bad = __le32_to_cpu(src->rts_bad);
+		stats->rts_good = __le32_to_cpu(src->rts_good);
+		stats->fcs_bad = __le32_to_cpu(src->fcs_bad);
+		stats->no_beacons = __le32_to_cpu(src->no_beacons);
+		stats->mib_int_count = __le32_to_cpu(src->mib_int_count);
+	}
+
+	/* fw doesn't implement vdev stats */
+
+	for (i = 0; i < num_peer_stats; i++) {
+		const struct wmi_10x_peer_stats *src;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		ath10k_wmi_pull_peer_stats(&src->old, &stats->peer_stat[i]);
+
+		stats->peer_stat[i].peer_rx_rate =
+				__le32_to_cpu(src->peer_rx_rate);
+	}
+
+	return 0;
+}
+
+int ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
+			     struct ath10k_target_stats *stats)
+{
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+		return ath10k_wmi_10x_pull_fw_stats(ar, skb, stats);
+	else
+		return ath10k_wmi_main_pull_fw_stats(ar, skb, stats);
+}
+
 static void ath10k_wmi_event_update_stats(struct ath10k *ar,
 					  struct sk_buff *skb)
 {
-	struct wmi_stats_event *ev = (struct wmi_stats_event *)skb->data;
-
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_UPDATE_STATS_EVENTID\n");
-
-	ath10k_debug_read_target_stats(ar, ev);
+	ath10k_debug_read_target_stats(ar, skb);
 }
 
 static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 55d8317..4ce8e3c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3021,7 +3021,7 @@ struct wmi_stats_event {
  * PDEV statistics
  * TODO: add all PDEV stats here
  */
-struct wmi_pdev_stats_old {
+struct wmi_pdev_stats {
 	__le32 chan_nf;        /* Channel noise floor */
 	__le32 tx_frame_count; /* TX frame count */
 	__le32 rx_frame_count; /* RX frame count */
@@ -3032,15 +3032,8 @@ struct wmi_pdev_stats_old {
 	struct wal_dbg_stats wal; /* WAL dbg stats */
 } __packed;
 
-struct wmi_pdev_stats_10x {
-	__le32 chan_nf;        /* Channel noise floor */
-	__le32 tx_frame_count; /* TX frame count */
-	__le32 rx_frame_count; /* RX frame count */
-	__le32 rx_clear_count; /* rx clear count */
-	__le32 cycle_count;    /* cycle count */
-	__le32 phy_err_count;  /* Phy error count */
-	__le32 chan_tx_pwr;    /* channel tx power */
-	struct wal_dbg_stats wal; /* WAL dbg stats */
+struct wmi_10x_pdev_stats {
+	struct wmi_pdev_stats old;
 	__le32 ack_rx_bad;
 	__le32 rts_bad;
 	__le32 rts_good;
@@ -3061,16 +3054,14 @@ struct wmi_vdev_stats {
  * peer statistics.
  * TODO: add more stats
  */
-struct wmi_peer_stats_old {
+struct wmi_peer_stats {
 	struct wmi_mac_addr peer_macaddr;
 	__le32 peer_rssi;
 	__le32 peer_tx_rate;
 } __packed;
 
-struct wmi_peer_stats_10x {
-	struct wmi_mac_addr peer_macaddr;
-	__le32 peer_rssi;
-	__le32 peer_tx_rate;
+struct wmi_10x_peer_stats {
+	struct wmi_peer_stats old;
 	__le32 peer_rx_rate;
 } __packed;
 
@@ -4582,6 +4573,7 @@ struct wmi_svc_rdy_ev_arg {
 
 struct ath10k;
 struct ath10k_vif;
+struct ath10k_target_stats;
 
 int ath10k_wmi_attach(struct ath10k *ar);
 void ath10k_wmi_detach(struct ath10k *ar);
@@ -4653,5 +4645,7 @@ int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 			     enum wmi_force_fw_hang_type type, u32 delay_ms);
 int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable);
+int ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
+			     struct ath10k_target_stats *stats);
 
 #endif /* _WMI_H_ */
-- 
1.8.5.3

