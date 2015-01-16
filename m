Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56399 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbbAPNNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 08:13:05 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so20444781wgg.5
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 05:13:04 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, antonio@open-mesh.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: split fw pdev stats parsing
Date: Fri, 16 Jan 2015 14:12:07 +0100
Message-Id: <1421413928-7282-2-git-send-email-michal.kazior@tieto.com> (sfid-20150116_141314_561431_CF5FCCFE)
In-Reply-To: <1421413928-7282-1-git-send-email-michal.kazior@tieto.com>
References: <1421413928-7282-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will make it easier to implement fw stats
parsing for firmware 10.2.

This also renames a few structures for
consistency.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 117 +++++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/wmi.h |  55 ++++++++++------
 2 files changed, 100 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 5fe17e8..ce095da 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1680,12 +1680,9 @@ int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
-void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
-				struct ath10k_fw_stats_pdev *dst)
+void ath10k_wmi_pull_pdev_stats_base(const struct wmi_pdev_stats_base *src,
+				     struct ath10k_fw_stats_pdev *dst)
 {
-	const struct wal_dbg_tx_stats *tx = &src->wal.tx;
-	const struct wal_dbg_rx_stats *rx = &src->wal.rx;
-
 	dst->ch_noise_floor = __le32_to_cpu(src->chan_nf);
 	dst->tx_frame_count = __le32_to_cpu(src->tx_frame_count);
 	dst->rx_frame_count = __le32_to_cpu(src->rx_frame_count);
@@ -1693,44 +1690,63 @@ void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
 	dst->cycle_count = __le32_to_cpu(src->cycle_count);
 	dst->phy_err_count = __le32_to_cpu(src->phy_err_count);
 	dst->chan_tx_power = __le32_to_cpu(src->chan_tx_pwr);
+}
 
-	dst->comp_queued = __le32_to_cpu(tx->comp_queued);
-	dst->comp_delivered = __le32_to_cpu(tx->comp_delivered);
-	dst->msdu_enqued = __le32_to_cpu(tx->msdu_enqued);
-	dst->mpdu_enqued = __le32_to_cpu(tx->mpdu_enqued);
-	dst->wmm_drop = __le32_to_cpu(tx->wmm_drop);
-	dst->local_enqued = __le32_to_cpu(tx->local_enqued);
-	dst->local_freed = __le32_to_cpu(tx->local_freed);
-	dst->hw_queued = __le32_to_cpu(tx->hw_queued);
-	dst->hw_reaped = __le32_to_cpu(tx->hw_reaped);
-	dst->underrun = __le32_to_cpu(tx->underrun);
-	dst->tx_abort = __le32_to_cpu(tx->tx_abort);
-	dst->mpdus_requed = __le32_to_cpu(tx->mpdus_requed);
-	dst->tx_ko = __le32_to_cpu(tx->tx_ko);
-	dst->data_rc = __le32_to_cpu(tx->data_rc);
-	dst->self_triggers = __le32_to_cpu(tx->self_triggers);
-	dst->sw_retry_failure = __le32_to_cpu(tx->sw_retry_failure);
-	dst->illgl_rate_phy_err = __le32_to_cpu(tx->illgl_rate_phy_err);
-	dst->pdev_cont_xretry = __le32_to_cpu(tx->pdev_cont_xretry);
-	dst->pdev_tx_timeout = __le32_to_cpu(tx->pdev_tx_timeout);
-	dst->pdev_resets = __le32_to_cpu(tx->pdev_resets);
-	dst->phy_underrun = __le32_to_cpu(tx->phy_underrun);
-	dst->txop_ovf = __le32_to_cpu(tx->txop_ovf);
-
-	dst->mid_ppdu_route_change = __le32_to_cpu(rx->mid_ppdu_route_change);
-	dst->status_rcvd = __le32_to_cpu(rx->status_rcvd);
-	dst->r0_frags = __le32_to_cpu(rx->r0_frags);
-	dst->r1_frags = __le32_to_cpu(rx->r1_frags);
-	dst->r2_frags = __le32_to_cpu(rx->r2_frags);
-	dst->r3_frags = __le32_to_cpu(rx->r3_frags);
-	dst->htt_msdus = __le32_to_cpu(rx->htt_msdus);
-	dst->htt_mpdus = __le32_to_cpu(rx->htt_mpdus);
-	dst->loc_msdus = __le32_to_cpu(rx->loc_msdus);
-	dst->loc_mpdus = __le32_to_cpu(rx->loc_mpdus);
-	dst->oversize_amsdu = __le32_to_cpu(rx->oversize_amsdu);
-	dst->phy_errs = __le32_to_cpu(rx->phy_errs);
-	dst->phy_err_drop = __le32_to_cpu(rx->phy_err_drop);
-	dst->mpdu_errs = __le32_to_cpu(rx->mpdu_errs);
+void ath10k_wmi_pull_pdev_stats_tx(const struct wmi_pdev_stats_tx *src,
+				   struct ath10k_fw_stats_pdev *dst)
+{
+	dst->comp_queued = __le32_to_cpu(src->comp_queued);
+	dst->comp_delivered = __le32_to_cpu(src->comp_delivered);
+	dst->msdu_enqued = __le32_to_cpu(src->msdu_enqued);
+	dst->mpdu_enqued = __le32_to_cpu(src->mpdu_enqued);
+	dst->wmm_drop = __le32_to_cpu(src->wmm_drop);
+	dst->local_enqued = __le32_to_cpu(src->local_enqued);
+	dst->local_freed = __le32_to_cpu(src->local_freed);
+	dst->hw_queued = __le32_to_cpu(src->hw_queued);
+	dst->hw_reaped = __le32_to_cpu(src->hw_reaped);
+	dst->underrun = __le32_to_cpu(src->underrun);
+	dst->tx_abort = __le32_to_cpu(src->tx_abort);
+	dst->mpdus_requed = __le32_to_cpu(src->mpdus_requed);
+	dst->tx_ko = __le32_to_cpu(src->tx_ko);
+	dst->data_rc = __le32_to_cpu(src->data_rc);
+	dst->self_triggers = __le32_to_cpu(src->self_triggers);
+	dst->sw_retry_failure = __le32_to_cpu(src->sw_retry_failure);
+	dst->illgl_rate_phy_err = __le32_to_cpu(src->illgl_rate_phy_err);
+	dst->pdev_cont_xretry = __le32_to_cpu(src->pdev_cont_xretry);
+	dst->pdev_tx_timeout = __le32_to_cpu(src->pdev_tx_timeout);
+	dst->pdev_resets = __le32_to_cpu(src->pdev_resets);
+	dst->phy_underrun = __le32_to_cpu(src->phy_underrun);
+	dst->txop_ovf = __le32_to_cpu(src->txop_ovf);
+}
+
+void ath10k_wmi_pull_pdev_stats_rx(const struct wmi_pdev_stats_rx *src,
+				   struct ath10k_fw_stats_pdev *dst)
+{
+	dst->mid_ppdu_route_change = __le32_to_cpu(src->mid_ppdu_route_change);
+	dst->status_rcvd = __le32_to_cpu(src->status_rcvd);
+	dst->r0_frags = __le32_to_cpu(src->r0_frags);
+	dst->r1_frags = __le32_to_cpu(src->r1_frags);
+	dst->r2_frags = __le32_to_cpu(src->r2_frags);
+	dst->r3_frags = __le32_to_cpu(src->r3_frags);
+	dst->htt_msdus = __le32_to_cpu(src->htt_msdus);
+	dst->htt_mpdus = __le32_to_cpu(src->htt_mpdus);
+	dst->loc_msdus = __le32_to_cpu(src->loc_msdus);
+	dst->loc_mpdus = __le32_to_cpu(src->loc_mpdus);
+	dst->oversize_amsdu = __le32_to_cpu(src->oversize_amsdu);
+	dst->phy_errs = __le32_to_cpu(src->phy_errs);
+	dst->phy_err_drop = __le32_to_cpu(src->phy_err_drop);
+	dst->mpdu_errs = __le32_to_cpu(src->mpdu_errs);
+}
+
+void ath10k_wmi_pull_pdev_stats_extra(const struct wmi_pdev_stats_extra *src,
+				      struct ath10k_fw_stats_pdev *dst)
+{
+	dst->ack_rx_bad = __le32_to_cpu(src->ack_rx_bad);
+	dst->rts_bad = __le32_to_cpu(src->rts_bad);
+	dst->rts_good = __le32_to_cpu(src->rts_good);
+	dst->fcs_bad = __le32_to_cpu(src->fcs_bad);
+	dst->no_beacons = __le32_to_cpu(src->no_beacons);
+	dst->mib_int_count = __le32_to_cpu(src->mib_int_count);
 }
 
 void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
@@ -1768,7 +1784,10 @@ static int ath10k_wmi_main_op_pull_fw_stats(struct ath10k *ar,
 		if (!dst)
 			continue;
 
-		ath10k_wmi_pull_pdev_stats(src, dst);
+		ath10k_wmi_pull_pdev_stats_base(&src->base, dst);
+		ath10k_wmi_pull_pdev_stats_tx(&src->tx, dst);
+		ath10k_wmi_pull_pdev_stats_rx(&src->rx, dst);
+
 		list_add_tail(&dst->list, &stats->pdevs);
 	}
 
@@ -1820,14 +1839,10 @@ static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
 		if (!dst)
 			continue;
 
-		ath10k_wmi_pull_pdev_stats(&src->old, dst);
-
-		dst->ack_rx_bad = __le32_to_cpu(src->ack_rx_bad);
-		dst->rts_bad = __le32_to_cpu(src->rts_bad);
-		dst->rts_good = __le32_to_cpu(src->rts_good);
-		dst->fcs_bad = __le32_to_cpu(src->fcs_bad);
-		dst->no_beacons = __le32_to_cpu(src->no_beacons);
-		dst->mib_int_count = __le32_to_cpu(src->mib_int_count);
+		ath10k_wmi_pull_pdev_stats_base(&src->base, dst);
+		ath10k_wmi_pull_pdev_stats_tx(&src->tx, dst);
+		ath10k_wmi_pull_pdev_stats_rx(&src->rx, dst);
+		ath10k_wmi_pull_pdev_stats_extra(&src->extra, dst);
 
 		list_add_tail(&dst->list, &stats->pdevs);
 	}
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index bd7f29a..109ed62 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2946,7 +2946,7 @@ struct wmi_pdev_set_wmm_params_arg {
 	struct wmi_wmm_params_arg ac_vo;
 };
 
-struct wal_dbg_tx_stats {
+struct wmi_pdev_stats_tx {
 	/* Num HTT cookies queued to dispatch list */
 	__le32 comp_queued;
 
@@ -3016,7 +3016,7 @@ struct wal_dbg_tx_stats {
 	__le32 txop_ovf;
 } __packed;
 
-struct wal_dbg_rx_stats {
+struct wmi_pdev_stats_rx {
 	/* Cnts any change in ring routing mid-ppdu */
 	__le32 mid_ppdu_route_change;
 
@@ -3050,17 +3050,11 @@ struct wal_dbg_rx_stats {
 	__le32 mpdu_errs;
 } __packed;
 
-struct wal_dbg_peer_stats {
+struct wmi_pdev_stats_peer {
 	/* REMOVE THIS ONCE REAL PEER STAT COUNTERS ARE ADDED */
 	__le32 dummy;
 } __packed;
 
-struct wal_dbg_stats {
-	struct wal_dbg_tx_stats tx;
-	struct wal_dbg_rx_stats rx;
-	struct wal_dbg_peer_stats peer;
-} __packed;
-
 enum wmi_stats_id {
 	WMI_REQUEST_PEER_STAT	= 0x01,
 	WMI_REQUEST_AP_STAT	= 0x02
@@ -3131,19 +3125,24 @@ struct wmi_stats_event {
  * PDEV statistics
  * TODO: add all PDEV stats here
  */
+struct wmi_pdev_stats_base {
+	__le32 chan_nf;
+	__le32 tx_frame_count;
+	__le32 rx_frame_count;
+	__le32 rx_clear_count;
+	__le32 cycle_count;
+	__le32 phy_err_count;
+	__le32 chan_tx_pwr;
+} __packed;
+
 struct wmi_pdev_stats {
-	__le32 chan_nf;        /* Channel noise floor */
-	__le32 tx_frame_count; /* TX frame count */
-	__le32 rx_frame_count; /* RX frame count */
-	__le32 rx_clear_count; /* rx clear count */
-	__le32 cycle_count;    /* cycle count */
-	__le32 phy_err_count;  /* Phy error count */
-	__le32 chan_tx_pwr;    /* channel tx power */
-	struct wal_dbg_stats wal; /* WAL dbg stats */
+	struct wmi_pdev_stats_base base;
+	struct wmi_pdev_stats_tx tx;
+	struct wmi_pdev_stats_rx rx;
+	struct wmi_pdev_stats_peer peer;
 } __packed;
 
-struct wmi_10x_pdev_stats {
-	struct wmi_pdev_stats old;
+struct wmi_pdev_stats_extra {
 	__le32 ack_rx_bad;
 	__le32 rts_bad;
 	__le32 rts_good;
@@ -3152,6 +3151,14 @@ struct wmi_10x_pdev_stats {
 	__le32 mib_int_count;
 } __packed;
 
+struct wmi_10x_pdev_stats {
+	struct wmi_pdev_stats_base base;
+	struct wmi_pdev_stats_tx tx;
+	struct wmi_pdev_stats_rx rx;
+	struct wmi_pdev_stats_peer peer;
+	struct wmi_pdev_stats_extra extra;
+} __packed;
+
 /*
  * VDEV statistics
  * TODO: add all VDEV stats here
@@ -4772,8 +4779,14 @@ int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
 			       u32 cmd_id);
 void ath10k_wmi_start_scan_init(struct ath10k *ar, struct wmi_start_scan_arg *);
 
-void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
-				struct ath10k_fw_stats_pdev *dst);
+void ath10k_wmi_pull_pdev_stats_base(const struct wmi_pdev_stats_base *src,
+				     struct ath10k_fw_stats_pdev *dst);
+void ath10k_wmi_pull_pdev_stats_tx(const struct wmi_pdev_stats_tx *src,
+				   struct ath10k_fw_stats_pdev *dst);
+void ath10k_wmi_pull_pdev_stats_rx(const struct wmi_pdev_stats_rx *src,
+				   struct ath10k_fw_stats_pdev *dst);
+void ath10k_wmi_pull_pdev_stats_extra(const struct wmi_pdev_stats_extra *src,
+				      struct ath10k_fw_stats_pdev *dst);
 void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
 				struct ath10k_fw_stats_peer *dst);
 void ath10k_wmi_put_host_mem_chunks(struct ath10k *ar,
-- 
1.8.5.3

