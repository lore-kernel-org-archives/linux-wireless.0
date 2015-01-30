Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46073 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbbA3JsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 04:48:22 -0500
Received: by mail-wi0-f179.google.com with SMTP id l15so1563453wiw.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 01:48:20 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/4] ath10k: add vdev stats processing
Date: Fri, 30 Jan 2015 10:47:21 +0100
Message-Id: <1422611244-20767-2-git-send-email-michal.kazior@tieto.com> (sfid-20150130_104831_288539_B60404A5)
In-Reply-To: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
References: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New qca6174 wmi-tlv firmware supports vdev stats.
This patch adds support for it in the debug
frontend.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  | 20 +++++++
 drivers/net/wireless/ath/ath10k/debug.c | 96 +++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index abb3203..dbc6c51 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -159,6 +159,25 @@ struct ath10k_fw_stats_peer {
 	u32 peer_rx_rate; /* 10x only */
 };
 
+struct ath10k_fw_stats_vdev {
+	struct list_head list;
+
+	u32 vdev_id;
+	u32 beacon_snr;
+	u32 data_snr;
+	u32 num_tx_frames[4];
+	u32 num_rx_frames;
+	u32 num_tx_frames_retries[4];
+	u32 num_tx_frames_failures[4];
+	u32 num_rts_fail;
+	u32 num_rts_success;
+	u32 num_rx_err;
+	u32 num_rx_discard;
+	u32 num_tx_not_acked;
+	u32 tx_rate_history[10];
+	u32 beacon_rssi_history[10];
+};
+
 struct ath10k_fw_stats_pdev {
 	struct list_head list;
 
@@ -220,6 +239,7 @@ struct ath10k_fw_stats_pdev {
 
 struct ath10k_fw_stats {
 	struct list_head pdevs;
+	struct list_head vdevs;
 	struct list_head peers;
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 42b2e49..f0a6b93 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -243,6 +243,16 @@ static void ath10k_debug_fw_stats_pdevs_free(struct list_head *head)
 	}
 }
 
+static void ath10k_debug_fw_stats_vdevs_free(struct list_head *head)
+{
+	struct ath10k_fw_stats_vdev *i, *tmp;
+
+	list_for_each_entry_safe(i, tmp, head, list) {
+		list_del(&i->list);
+		kfree(i);
+	}
+}
+
 static void ath10k_debug_fw_stats_peers_free(struct list_head *head)
 {
 	struct ath10k_fw_stats_peer *i, *tmp;
@@ -258,6 +268,7 @@ static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
 	spin_lock_bh(&ar->data_lock);
 	ar->debug.fw_stats_done = false;
 	ath10k_debug_fw_stats_pdevs_free(&ar->debug.fw_stats.pdevs);
+	ath10k_debug_fw_stats_vdevs_free(&ar->debug.fw_stats.vdevs);
 	ath10k_debug_fw_stats_peers_free(&ar->debug.fw_stats.peers);
 	spin_unlock_bh(&ar->data_lock);
 }
@@ -273,14 +284,27 @@ static size_t ath10k_debug_fw_stats_num_peers(struct list_head *head)
 	return num;
 }
 
+static size_t ath10k_debug_fw_stats_num_vdevs(struct list_head *head)
+{
+	struct ath10k_fw_stats_vdev *i;
+	size_t num = 0;
+
+	list_for_each_entry(i, head, list)
+		++num;
+
+	return num;
+}
+
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_fw_stats stats = {};
 	bool is_start, is_started, is_end;
 	size_t num_peers;
+	size_t num_vdevs;
 	int ret;
 
 	INIT_LIST_HEAD(&stats.pdevs);
+	INIT_LIST_HEAD(&stats.vdevs);
 	INIT_LIST_HEAD(&stats.peers);
 
 	spin_lock_bh(&ar->data_lock);
@@ -308,6 +332,7 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 	}
 
 	num_peers = ath10k_debug_fw_stats_num_peers(&ar->debug.fw_stats.peers);
+	num_vdevs = ath10k_debug_fw_stats_num_vdevs(&ar->debug.fw_stats.vdevs);
 	is_start = (list_empty(&ar->debug.fw_stats.pdevs) &&
 		    !list_empty(&stats.pdevs));
 	is_end = (!list_empty(&ar->debug.fw_stats.pdevs) &&
@@ -330,7 +355,13 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 			goto free;
 		}
 
+		if (num_vdevs >= BITS_PER_LONG) {
+			ath10k_warn(ar, "dropping fw vdev stats\n");
+			goto free;
+		}
+
 		list_splice_tail_init(&stats.peers, &ar->debug.fw_stats.peers);
+		list_splice_tail_init(&stats.vdevs, &ar->debug.fw_stats.vdevs);
 	}
 
 	complete(&ar->debug.fw_stats_complete);
@@ -340,6 +371,7 @@ free:
 	 * resources if that is not the case.
 	 */
 	ath10k_debug_fw_stats_pdevs_free(&stats.pdevs);
+	ath10k_debug_fw_stats_vdevs_free(&stats.vdevs);
 	ath10k_debug_fw_stats_peers_free(&stats.peers);
 
 unlock:
@@ -395,8 +427,11 @@ static void ath10k_fw_stats_fill(struct ath10k *ar,
 	unsigned int len = 0;
 	unsigned int buf_len = ATH10K_FW_STATS_BUF_SIZE;
 	const struct ath10k_fw_stats_pdev *pdev;
+	const struct ath10k_fw_stats_vdev *vdev;
 	const struct ath10k_fw_stats_peer *peer;
 	size_t num_peers;
+	size_t num_vdevs;
+	int i;
 
 	spin_lock_bh(&ar->data_lock);
 
@@ -408,6 +443,7 @@ static void ath10k_fw_stats_fill(struct ath10k *ar,
 	}
 
 	num_peers = ath10k_debug_fw_stats_num_peers(&fw_stats->peers);
+	num_vdevs = ath10k_debug_fw_stats_num_vdevs(&fw_stats->vdevs);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%30s\n",
@@ -531,6 +567,65 @@ static void ath10k_fw_stats_fill(struct ath10k *ar,
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
+			 "ath10k VDEV stats", num_vdevs);
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	list_for_each_entry(vdev, &fw_stats->vdevs, list) {
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "vdev id", vdev->vdev_id);
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "beacon snr", vdev->beacon_snr);
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "data snr", vdev->data_snr);
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "num rx frames", vdev->num_rx_frames);
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "num rts fail", vdev->num_rts_fail);
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "num rts success", vdev->num_rts_success);
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "num rx err", vdev->num_rx_err);
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "num rx discard", vdev->num_rx_discard);
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "num tx not acked", vdev->num_tx_not_acked);
+
+		for (i = 0 ; i < ARRAY_SIZE(vdev->num_tx_frames); i++)
+			len += scnprintf(buf + len, buf_len - len,
+					"%25s [%02d] %u\n",
+					 "num tx frames", i,
+					 vdev->num_tx_frames[i]);
+
+		for (i = 0 ; i < ARRAY_SIZE(vdev->num_tx_frames_retries); i++)
+			len += scnprintf(buf + len, buf_len - len,
+					"%25s [%02d] %u\n",
+					 "num tx frames retries", i,
+					 vdev->num_tx_frames_retries[i]);
+
+		for (i = 0 ; i < ARRAY_SIZE(vdev->num_tx_frames_failures); i++)
+			len += scnprintf(buf + len, buf_len - len,
+					"%25s [%02d] %u\n",
+					 "num tx frames failures", i,
+					 vdev->num_tx_frames_failures[i]);
+
+		for (i = 0 ; i < ARRAY_SIZE(vdev->tx_rate_history); i++)
+			len += scnprintf(buf + len, buf_len - len,
+					"%25s [%02d] 0x%08x\n",
+					 "tx rate history", i,
+					 vdev->tx_rate_history[i]);
+
+		for (i = 0 ; i < ARRAY_SIZE(vdev->beacon_rssi_history); i++)
+			len += scnprintf(buf + len, buf_len - len,
+					"%25s [%02d] %u\n",
+					 "beacon rssi history", i,
+					 vdev->beacon_rssi_history[i]);
+
+		len += scnprintf(buf + len, buf_len - len, "\n");
+	}
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
 			 "ath10k PEER stats", num_peers);
 	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
 				 "=================");
@@ -1886,6 +1981,7 @@ int ath10k_debug_create(struct ath10k *ar)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&ar->debug.fw_stats.pdevs);
+	INIT_LIST_HEAD(&ar->debug.fw_stats.vdevs);
 	INIT_LIST_HEAD(&ar->debug.fw_stats.peers);
 
 	return 0;
-- 
1.8.5.3

