Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:36466 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbAPNNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 08:13:07 -0500
Received: by mail-we0-f179.google.com with SMTP id q59so20155420wes.10
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 05:13:05 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, antonio@open-mesh.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: fix 10.2 fw stats parsing
Date: Fri, 16 Jan 2015 14:12:08 +0100
Message-Id: <1421413928-7282-3-git-send-email-michal.kazior@tieto.com> (sfid-20150116_141311_915368_6B592F2A)
In-Reply-To: <1421413928-7282-1-git-send-email-michal.kazior@tieto.com>
References: <1421413928-7282-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both 10.2 firmware binaries 10.2-00082-4 and
10.2.4.20 have introduced ABI changes to fw_stats
each. This caused fw_stats to output wrong data.

Define new structures and use them to parse the
statistics correctly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 162 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h |  52 +++++++++++
 2 files changed, 212 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ce095da..fb1e2d1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1871,6 +1871,164 @@ static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
 	return 0;
 }
 
+static int ath10k_wmi_10_2_op_pull_fw_stats(struct ath10k *ar,
+					    struct sk_buff *skb,
+					    struct ath10k_fw_stats *stats)
+{
+	const struct wmi_10_2_stats_event *ev = (void *)skb->data;
+	u32 num_pdev_stats;
+	u32 num_pdev_ext_stats;
+	u32 num_vdev_stats;
+	u32 num_peer_stats;
+	int i;
+
+	if (!skb_pull(skb, sizeof(*ev)))
+		return -EPROTO;
+
+	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
+	num_pdev_ext_stats = __le32_to_cpu(ev->num_pdev_ext_stats);
+	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
+	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
+
+	for (i = 0; i < num_pdev_stats; i++) {
+		const struct wmi_10_2_pdev_stats *src;
+		struct ath10k_fw_stats_pdev *dst;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_pdev_stats_base(&src->base, dst);
+		ath10k_wmi_pull_pdev_stats_tx(&src->tx, dst);
+		ath10k_wmi_pull_pdev_stats_rx(&src->rx, dst);
+		ath10k_wmi_pull_pdev_stats_extra(&src->extra, dst);
+		/* FIXME: expose 10.2 specific values */
+
+		list_add_tail(&dst->list, &stats->pdevs);
+	}
+
+	for (i = 0; i < num_pdev_ext_stats; i++) {
+		const struct wmi_10_2_pdev_ext_stats *src;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		/* FIXME: expose values to userspace
+		 *
+		 * Note: Even though this loop seems to do nothing it is
+		 * required to parse following sub-structures properly.
+		 */
+	}
+
+	/* fw doesn't implement vdev stats */
+
+	for (i = 0; i < num_peer_stats; i++) {
+		const struct wmi_10_2_peer_stats *src;
+		struct ath10k_fw_stats_peer *dst;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_peer_stats(&src->old, dst);
+
+		dst->peer_rx_rate = __le32_to_cpu(src->peer_rx_rate);
+		/* FIXME: expose 10.2 specific values */
+
+		list_add_tail(&dst->list, &stats->peers);
+	}
+
+	return 0;
+}
+
+static int ath10k_wmi_10_2_4_op_pull_fw_stats(struct ath10k *ar,
+					      struct sk_buff *skb,
+					      struct ath10k_fw_stats *stats)
+{
+	const struct wmi_10_2_stats_event *ev = (void *)skb->data;
+	u32 num_pdev_stats;
+	u32 num_pdev_ext_stats;
+	u32 num_vdev_stats;
+	u32 num_peer_stats;
+	int i;
+
+	if (!skb_pull(skb, sizeof(*ev)))
+		return -EPROTO;
+
+	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
+	num_pdev_ext_stats = __le32_to_cpu(ev->num_pdev_ext_stats);
+	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
+	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
+
+	for (i = 0; i < num_pdev_stats; i++) {
+		const struct wmi_10_2_pdev_stats *src;
+		struct ath10k_fw_stats_pdev *dst;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_pdev_stats_base(&src->base, dst);
+		ath10k_wmi_pull_pdev_stats_tx(&src->tx, dst);
+		ath10k_wmi_pull_pdev_stats_rx(&src->rx, dst);
+		ath10k_wmi_pull_pdev_stats_extra(&src->extra, dst);
+		/* FIXME: expose 10.2 specific values */
+
+		list_add_tail(&dst->list, &stats->pdevs);
+	}
+
+	for (i = 0; i < num_pdev_ext_stats; i++) {
+		const struct wmi_10_2_pdev_ext_stats *src;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		/* FIXME: expose values to userspace
+		 *
+		 * Note: Even though this loop seems to do nothing it is
+		 * required to parse following sub-structures properly.
+		 */
+	}
+
+	/* fw doesn't implement vdev stats */
+
+	for (i = 0; i < num_peer_stats; i++) {
+		const struct wmi_10_2_4_peer_stats *src;
+		struct ath10k_fw_stats_peer *dst;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_peer_stats(&src->common.old, dst);
+
+		dst->peer_rx_rate = __le32_to_cpu(src->common.peer_rx_rate);
+		/* FIXME: expose 10.2 specific values */
+
+		list_add_tail(&dst->list, &stats->peers);
+	}
+
+	return 0;
+}
+
 void ath10k_wmi_event_update_stats(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_UPDATE_STATS_EVENTID\n");
@@ -5121,6 +5279,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 
 static const struct wmi_ops wmi_10_2_ops = {
 	.rx = ath10k_wmi_10_2_op_rx,
+	.pull_fw_stats = ath10k_wmi_10_2_op_pull_fw_stats,
 	.gen_init = ath10k_wmi_10_2_op_gen_init,
 	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
 	/* .gen_pdev_get_temperature not implemented */
@@ -5128,7 +5287,6 @@ static const struct wmi_ops wmi_10_2_ops = {
 	/* shared with 10.1 */
 	.map_svc = wmi_10x_svc_map,
 	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
-	.pull_fw_stats = ath10k_wmi_10x_op_pull_fw_stats,
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
 	.gen_start_scan = ath10k_wmi_10x_op_gen_start_scan,
 
@@ -5180,6 +5338,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 
 static const struct wmi_ops wmi_10_2_4_ops = {
 	.rx = ath10k_wmi_10_2_op_rx,
+	.pull_fw_stats = ath10k_wmi_10_2_4_op_pull_fw_stats,
 	.gen_init = ath10k_wmi_10_2_op_gen_init,
 	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
 	.gen_pdev_get_temperature = ath10k_wmi_10_2_op_gen_pdev_get_temperature,
@@ -5187,7 +5346,6 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	/* shared with 10.1 */
 	.map_svc = wmi_10x_svc_map,
 	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
-	.pull_fw_stats = ath10k_wmi_10x_op_pull_fw_stats,
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
 	.gen_start_scan = ath10k_wmi_10x_op_gen_start_scan,
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 109ed62..0514b1a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3121,6 +3121,16 @@ struct wmi_stats_event {
 	u8 data[0];
 } __packed;
 
+struct wmi_10_2_stats_event {
+	__le32 stats_id; /* %WMI_REQUEST_ */
+	__le32 num_pdev_stats;
+	__le32 num_pdev_ext_stats;
+	__le32 num_vdev_stats;
+	__le32 num_peer_stats;
+	__le32 num_bcnflt_stats;
+	u8 data[0];
+} __packed;
+
 /*
  * PDEV statistics
  * TODO: add all PDEV stats here
@@ -3159,6 +3169,22 @@ struct wmi_10x_pdev_stats {
 	struct wmi_pdev_stats_extra extra;
 } __packed;
 
+struct wmi_pdev_stats_mem {
+	__le32 dram_free;
+	__le32 iram_free;
+} __packed;
+
+struct wmi_10_2_pdev_stats {
+	struct wmi_pdev_stats_base base;
+	struct wmi_pdev_stats_tx tx;
+	__le32 mc_drop;
+	struct wmi_pdev_stats_rx rx;
+	__le32 pdev_rx_timeout;
+	struct wmi_pdev_stats_mem mem;
+	struct wmi_pdev_stats_peer peer;
+	struct wmi_pdev_stats_extra extra;
+} __packed;
+
 /*
  * VDEV statistics
  * TODO: add all VDEV stats here
@@ -3182,6 +3208,32 @@ struct wmi_10x_peer_stats {
 	__le32 peer_rx_rate;
 } __packed;
 
+struct wmi_10_2_peer_stats {
+	struct wmi_peer_stats old;
+	__le32 peer_rx_rate;
+	__le32 current_per;
+	__le32 retries;
+	__le32 tx_rate_count;
+	__le32 max_4ms_frame_len;
+	__le32 total_sub_frames;
+	__le32 tx_bytes;
+	__le32 num_pkt_loss_overflow[4];
+	__le32 num_pkt_loss_excess_retry[4];
+} __packed;
+
+struct wmi_10_2_4_peer_stats {
+	struct wmi_10_2_peer_stats common;
+	__le32 unknown_value; /* FIXME: what is this word? */
+} __packed;
+
+struct wmi_10_2_pdev_ext_stats {
+	__le32 rx_rssi_comb;
+	__le32 rx_rssi[4];
+	__le32 rx_mcs[10];
+	__le32 tx_mcs[10];
+	__le32 ack_rssi;
+} __packed;
+
 struct wmi_vdev_create_cmd {
 	__le32 vdev_id;
 	__le32 vdev_type;
-- 
1.8.5.3

