Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:64764 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbbA3Js1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 04:48:27 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so26125508wev.12
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 01:48:26 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/4] ath10k: implement fw stats for wmi-tlv
Date: Fri, 30 Jan 2015 10:47:24 +0100
Message-Id: <1422611244-20767-5-git-send-email-michal.kazior@tieto.com> (sfid-20150130_104836_634687_5B3A8674)
In-Reply-To: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
References: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This processes and pushes fw stats to the debug
module (if enabled).

Changing the generic ath10k_wmi_requests_stats()
call to use more stat bits has no effect on older
firmware binaries.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/debug.c   |   5 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 112 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |   9 +++
 3 files changed, 122 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 33f36ee..518d21c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -395,7 +395,10 @@ static int ath10k_debug_fw_stats_request(struct ath10k *ar)
 
 		reinit_completion(&ar->debug.fw_stats_complete);
 
-		ret = ath10k_wmi_request_stats(ar, WMI_STAT_PEER);
+		ret = ath10k_wmi_request_stats(ar,
+					       WMI_STAT_PDEV |
+					       WMI_STAT_VDEV |
+					       WMI_STAT_PEER);
 		if (ret) {
 			ath10k_warn(ar, "could not request stats (%d)\n", ret);
 			return ret;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 8264f2e..737f747 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -869,16 +869,57 @@ static int ath10k_wmi_tlv_op_pull_rdy_ev(struct ath10k *ar,
 	return 0;
 }
 
+static void ath10k_wmi_tlv_pull_vdev_stats(const struct wmi_tlv_vdev_stats *src,
+					   struct ath10k_fw_stats_vdev *dst)
+{
+	int i;
+
+	dst->vdev_id = __le32_to_cpu(src->vdev_id);
+	dst->beacon_snr = __le32_to_cpu(src->beacon_snr);
+	dst->data_snr = __le32_to_cpu(src->data_snr);
+	dst->num_rx_frames = __le32_to_cpu(src->num_rx_frames);
+	dst->num_rts_fail = __le32_to_cpu(src->num_rts_fail);
+	dst->num_rts_success = __le32_to_cpu(src->num_rts_success);
+	dst->num_rx_err = __le32_to_cpu(src->num_rx_err);
+	dst->num_rx_discard = __le32_to_cpu(src->num_rx_discard);
+	dst->num_tx_not_acked = __le32_to_cpu(src->num_tx_not_acked);
+
+	for (i = 0; i < ARRAY_SIZE(src->num_tx_frames); i++)
+		dst->num_tx_frames[i] =
+			__le32_to_cpu(src->num_tx_frames[i]);
+
+	for (i = 0; i < ARRAY_SIZE(src->num_tx_frames_retries); i++)
+		dst->num_tx_frames_retries[i] =
+			__le32_to_cpu(src->num_tx_frames_retries[i]);
+
+	for (i = 0; i < ARRAY_SIZE(src->num_tx_frames_failures); i++)
+		dst->num_tx_frames_failures[i] =
+			__le32_to_cpu(src->num_tx_frames_failures[i]);
+
+	for (i = 0; i < ARRAY_SIZE(src->tx_rate_history); i++)
+		dst->tx_rate_history[i] =
+			__le32_to_cpu(src->tx_rate_history[i]);
+
+	for (i = 0; i < ARRAY_SIZE(src->beacon_rssi_history); i++)
+		dst->beacon_rssi_history[i] =
+			__le32_to_cpu(src->beacon_rssi_history[i]);
+}
+
 static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 					   struct sk_buff *skb,
 					   struct ath10k_fw_stats *stats)
 {
 	const void **tb;
-	const struct wmi_stats_event *ev;
+	const struct wmi_tlv_stats_ev *ev;
 	const void *data;
-	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
+	u32 num_pdev_stats;
+	u32 num_vdev_stats;
+	u32 num_peer_stats;
+	u32 num_bcnflt_stats;
+	u32 num_chan_stats;
 	size_t data_len;
 	int ret;
+	int i;
 
 	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
@@ -899,8 +940,73 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
 	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
+	num_bcnflt_stats = __le32_to_cpu(ev->num_bcnflt_stats);
+	num_chan_stats = __le32_to_cpu(ev->num_chan_stats);
 
-	WARN_ON(1); /* FIXME: not implemented yet */
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi tlv stats update pdev %i vdev %i peer %i bcnflt %i chan %i\n",
+		   num_pdev_stats, num_vdev_stats, num_peer_stats,
+		   num_bcnflt_stats, num_chan_stats);
+
+	for (i = 0; i < num_pdev_stats; i++) {
+		const struct wmi_pdev_stats *src;
+		struct ath10k_fw_stats_pdev *dst;
+
+		src = data;
+		if (data_len < sizeof(*src))
+			return -EPROTO;
+
+		data += sizeof(*src);
+		data_len -= sizeof(*src);
+
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_pdev_stats_base(&src->base, dst);
+		ath10k_wmi_pull_pdev_stats_tx(&src->tx, dst);
+		ath10k_wmi_pull_pdev_stats_rx(&src->rx, dst);
+		list_add_tail(&dst->list, &stats->pdevs);
+	}
+
+	for (i = 0; i < num_vdev_stats; i++) {
+		const struct wmi_tlv_vdev_stats *src;
+		struct ath10k_fw_stats_vdev *dst;
+
+		src = data;
+		if (data_len < sizeof(*src))
+			return -EPROTO;
+
+		data += sizeof(*src);
+		data_len -= sizeof(*src);
+
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_tlv_pull_vdev_stats(src, dst);
+		list_add_tail(&dst->list, &stats->vdevs);
+	}
+
+	for (i = 0; i < num_peer_stats; i++) {
+		const struct wmi_10x_peer_stats *src;
+		struct ath10k_fw_stats_peer *dst;
+
+		src = data;
+		if (data_len < sizeof(*src))
+			return -EPROTO;
+
+		data += sizeof(*src);
+		data_len -= sizeof(*src);
+
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_peer_stats(&src->old, dst);
+		dst->peer_rx_rate = __le32_to_cpu(src->peer_rx_rate);
+		list_add_tail(&dst->list, &stats->peers);
+	}
 
 	kfree(tb);
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index de68fe7..d7a31e1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1439,6 +1439,15 @@ struct wmi_tlv_sta_keepalive_cmd {
 	__le32 interval; /* in seconds */
 } __packed;
 
+struct wmi_tlv_stats_ev {
+	__le32 stats_id; /* WMI_STAT_ */
+	__le32 num_pdev_stats;
+	__le32 num_vdev_stats;
+	__le32 num_peer_stats;
+	__le32 num_bcnflt_stats;
+	__le32 num_chan_stats;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
-- 
1.8.5.3

