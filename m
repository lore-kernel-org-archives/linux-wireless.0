Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5659 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbbJNIxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 04:53:44 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Manikanta <c_mpubbi@qti.qualcomm.com>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 1/2 v2] ath10k: Make fw stats prints specific to firmware version
Date: Wed, 14 Oct 2015 14:23:41 +0530
Message-ID: <1444812821-11138-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20151014_105350_944712_55918DB9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta <c_mpubbi@qti.qualcomm.com>

The patch makes debug stats prints fw specific by adding a new member
in wmi_ops

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c   |  267 +-------------------
 drivers/net/wireless/ath/ath10k/debug.h   |    3 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   13 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  377 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   10 +
 6 files changed, 412 insertions(+), 259 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f316efd..b3453c7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -285,28 +285,6 @@ static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
 	spin_unlock_bh(&ar->data_lock);
 }
 
-static size_t ath10k_debug_fw_stats_num_peers(struct list_head *head)
-{
-	struct ath10k_fw_stats_peer *i;
-	size_t num = 0;
-
-	list_for_each_entry(i, head, list)
-		++num;
-
-	return num;
-}
-
-static size_t ath10k_debug_fw_stats_num_vdevs(struct list_head *head)
-{
-	struct ath10k_fw_stats_vdev *i;
-	size_t num = 0;
-
-	list_for_each_entry(i, head, list)
-		++num;
-
-	return num;
-}
-
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_fw_stats stats = {};
@@ -343,8 +321,8 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 		goto free;
 	}
 
-	num_peers = ath10k_debug_fw_stats_num_peers(&ar->debug.fw_stats.peers);
-	num_vdevs = ath10k_debug_fw_stats_num_vdevs(&ar->debug.fw_stats.vdevs);
+	num_peers = ath10k_wmi_fw_stats_num_peers(&ar->debug.fw_stats.peers);
+	num_vdevs = ath10k_wmi_fw_stats_num_vdevs(&ar->debug.fw_stats.vdevs);
 	is_start = (list_empty(&ar->debug.fw_stats.pdevs) &&
 		    !list_empty(&stats.pdevs));
 	is_end = (!list_empty(&ar->debug.fw_stats.pdevs) &&
@@ -429,240 +407,6 @@ static int ath10k_debug_fw_stats_request(struct ath10k *ar)
 	return 0;
 }
 
-/* FIXME: How to calculate the buffer size sanely? */
-#define ATH10K_FW_STATS_BUF_SIZE (1024*1024)
-
-static void ath10k_fw_stats_fill(struct ath10k *ar,
-				 struct ath10k_fw_stats *fw_stats,
-				 char *buf)
-{
-	unsigned int len = 0;
-	unsigned int buf_len = ATH10K_FW_STATS_BUF_SIZE;
-	const struct ath10k_fw_stats_pdev *pdev;
-	const struct ath10k_fw_stats_vdev *vdev;
-	const struct ath10k_fw_stats_peer *peer;
-	size_t num_peers;
-	size_t num_vdevs;
-	int i;
-
-	spin_lock_bh(&ar->data_lock);
-
-	pdev = list_first_entry_or_null(&fw_stats->pdevs,
-					struct ath10k_fw_stats_pdev, list);
-	if (!pdev) {
-		ath10k_warn(ar, "failed to get pdev stats\n");
-		goto unlock;
-	}
-
-	num_peers = ath10k_debug_fw_stats_num_peers(&fw_stats->peers);
-	num_vdevs = ath10k_debug_fw_stats_num_vdevs(&fw_stats->vdevs);
-
-	len += scnprintf(buf + len, buf_len - len, "\n");
-	len += scnprintf(buf + len, buf_len - len, "%30s\n",
-			 "ath10k PDEV stats");
-	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
-				 "=================");
-
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Channel noise floor", pdev->ch_noise_floor);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "Channel TX power", pdev->chan_tx_power);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "TX frame count", pdev->tx_frame_count);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "RX frame count", pdev->rx_frame_count);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "RX clear count", pdev->rx_clear_count);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "Cycle count", pdev->cycle_count);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "PHY error count", pdev->phy_err_count);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "RTS bad count", pdev->rts_bad);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "RTS good count", pdev->rts_good);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "FCS bad count", pdev->fcs_bad);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "No beacon count", pdev->no_beacons);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "MIB int count", pdev->mib_int_count);
-
-	len += scnprintf(buf + len, buf_len - len, "\n");
-	len += scnprintf(buf + len, buf_len - len, "%30s\n",
-			 "ath10k PDEV TX stats");
-	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
-				 "=================");
-
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "HTT cookies queued", pdev->comp_queued);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "HTT cookies disp.", pdev->comp_delivered);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MSDU queued", pdev->msdu_enqued);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDU queued", pdev->mpdu_enqued);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MSDUs dropped", pdev->wmm_drop);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Local enqued", pdev->local_enqued);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Local freed", pdev->local_freed);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "HW queued", pdev->hw_queued);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PPDUs reaped", pdev->hw_reaped);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Num underruns", pdev->underrun);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PPDUs cleaned", pdev->tx_abort);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDUs requed", pdev->mpdus_requed);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Excessive retries", pdev->tx_ko);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "HW rate", pdev->data_rc);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Sched self tiggers", pdev->self_triggers);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Dropped due to SW retries",
-			 pdev->sw_retry_failure);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Illegal rate phy errors",
-			 pdev->illgl_rate_phy_err);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Pdev continous xretry", pdev->pdev_cont_xretry);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "TX timeout", pdev->pdev_tx_timeout);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PDEV resets", pdev->pdev_resets);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PHY underrun", pdev->phy_underrun);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDU is more than txop limit", pdev->txop_ovf);
-
-	len += scnprintf(buf + len, buf_len - len, "\n");
-	len += scnprintf(buf + len, buf_len - len, "%30s\n",
-			 "ath10k PDEV RX stats");
-	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
-				 "=================");
-
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Mid PPDU route change",
-			 pdev->mid_ppdu_route_change);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Tot. number of statuses", pdev->status_rcvd);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Extra frags on rings 0", pdev->r0_frags);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Extra frags on rings 1", pdev->r1_frags);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Extra frags on rings 2", pdev->r2_frags);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Extra frags on rings 3", pdev->r3_frags);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MSDUs delivered to HTT", pdev->htt_msdus);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDUs delivered to HTT", pdev->htt_mpdus);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MSDUs delivered to stack", pdev->loc_msdus);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDUs delivered to stack", pdev->loc_mpdus);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Oversized AMSUs", pdev->oversize_amsdu);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PHY errors", pdev->phy_errs);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PHY errors drops", pdev->phy_err_drop);
-	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDU errors (FCS, MIC, ENC)", pdev->mpdu_errs);
-
-	len += scnprintf(buf + len, buf_len - len, "\n");
-	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
-			 "ath10k VDEV stats", num_vdevs);
-	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
-				 "=================");
-
-	list_for_each_entry(vdev, &fw_stats->vdevs, list) {
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "vdev id", vdev->vdev_id);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "beacon snr", vdev->beacon_snr);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "data snr", vdev->data_snr);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "num rx frames", vdev->num_rx_frames);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "num rts fail", vdev->num_rts_fail);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "num rts success", vdev->num_rts_success);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "num rx err", vdev->num_rx_err);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "num rx discard", vdev->num_rx_discard);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "num tx not acked", vdev->num_tx_not_acked);
-
-		for (i = 0 ; i < ARRAY_SIZE(vdev->num_tx_frames); i++)
-			len += scnprintf(buf + len, buf_len - len,
-					"%25s [%02d] %u\n",
-					 "num tx frames", i,
-					 vdev->num_tx_frames[i]);
-
-		for (i = 0 ; i < ARRAY_SIZE(vdev->num_tx_frames_retries); i++)
-			len += scnprintf(buf + len, buf_len - len,
-					"%25s [%02d] %u\n",
-					 "num tx frames retries", i,
-					 vdev->num_tx_frames_retries[i]);
-
-		for (i = 0 ; i < ARRAY_SIZE(vdev->num_tx_frames_failures); i++)
-			len += scnprintf(buf + len, buf_len - len,
-					"%25s [%02d] %u\n",
-					 "num tx frames failures", i,
-					 vdev->num_tx_frames_failures[i]);
-
-		for (i = 0 ; i < ARRAY_SIZE(vdev->tx_rate_history); i++)
-			len += scnprintf(buf + len, buf_len - len,
-					"%25s [%02d] 0x%08x\n",
-					 "tx rate history", i,
-					 vdev->tx_rate_history[i]);
-
-		for (i = 0 ; i < ARRAY_SIZE(vdev->beacon_rssi_history); i++)
-			len += scnprintf(buf + len, buf_len - len,
-					"%25s [%02d] %u\n",
-					 "beacon rssi history", i,
-					 vdev->beacon_rssi_history[i]);
-
-		len += scnprintf(buf + len, buf_len - len, "\n");
-	}
-
-	len += scnprintf(buf + len, buf_len - len, "\n");
-	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
-			 "ath10k PEER stats", num_peers);
-	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
-				 "=================");
-
-	list_for_each_entry(peer, &fw_stats->peers, list) {
-		len += scnprintf(buf + len, buf_len - len, "%30s %pM\n",
-				 "Peer MAC address", peer->peer_macaddr);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "Peer RSSI", peer->peer_rssi);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "Peer TX rate", peer->peer_tx_rate);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "Peer RX rate", peer->peer_rx_rate);
-		len += scnprintf(buf + len, buf_len - len, "\n");
-	}
-
-unlock:
-	spin_unlock_bh(&ar->data_lock);
-
-	if (len >= buf_len)
-		buf[len - 1] = 0;
-	else
-		buf[len] = 0;
-}
-
 static int ath10k_fw_stats_open(struct inode *inode, struct file *file)
 {
 	struct ath10k *ar = inode->i_private;
@@ -688,7 +432,12 @@ static int ath10k_fw_stats_open(struct inode *inode, struct file *file)
 		goto err_free;
 	}
 
-	ath10k_fw_stats_fill(ar, &ar->debug.fw_stats, buf);
+	ret = ath10k_wmi_fw_stats_fill(ar, &ar->debug.fw_stats, buf);
+	if (ret) {
+		ath10k_warn(ar, "failed to fill fw stats: %d\n", ret);
+		goto err_free;
+	}
+
 	file->private_data = buf;
 
 	mutex_unlock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index b07639e..7de780c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -55,6 +55,9 @@ enum ath10k_dbg_aggr_mode {
 	ATH10K_DBG_AGGR_MODE_MAX,
 };
 
+/* FIXME: How to calculate the buffer size sanely? */
+#define ATH10K_FW_STATS_BUF_SIZE (1024*1024)
+
 extern unsigned int ath10k_debug_mask;
 
 __printf(2, 3) void ath10k_info(struct ath10k *ar, const char *fmt, ...);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index d3bc6df..c171a67 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -179,6 +179,9 @@ struct wmi_ops {
 	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
 	struct sk_buff *(*gen_pdev_get_tpc_config)(struct ath10k *ar,
 						   u32 param);
+	void (*fw_stats_fill)(struct ath10k *ar,
+			      struct ath10k_fw_stats *fw_stats,
+			      char *buf);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1289,4 +1292,14 @@ ath10k_wmi_pdev_get_tpc_config(struct ath10k *ar, u32 param)
 				   ar->wmi.cmd->pdev_get_tpc_config_cmdid);
 }
 
+static inline int
+ath10k_wmi_fw_stats_fill(struct ath10k *ar, struct ath10k_fw_stats *fw_stats,
+			char *buf)
+{
+	if (!ar->wmi.ops->fw_stats_fill)
+		return -EOPNOTSUPP;
+
+	ar->wmi.ops->fw_stats_fill(ar, fw_stats, buf);
+	return 0;
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index b5849b3..8f83548 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3468,6 +3468,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_update_fw_tdls_state = ath10k_wmi_tlv_op_gen_update_fw_tdls_state,
 	.gen_tdls_peer_update = ath10k_wmi_tlv_op_gen_tdls_peer_update,
 	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
+	.fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 063469b..db25b727 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6621,6 +6621,379 @@ ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config(struct ath10k *ar, u32 param)
 	return skb;
 }
 
+size_t ath10k_wmi_fw_stats_num_peers(struct list_head *head)
+{
+	struct ath10k_fw_stats_peer *i;
+	size_t num = 0;
+	list_for_each_entry(i, head, list)
+		++num;
+
+	return num;
+}
+
+size_t ath10k_wmi_fw_stats_num_vdevs(struct list_head *head)
+{
+	struct ath10k_fw_stats_vdev *i;
+	size_t num = 0;
+	list_for_each_entry(i, head, list)
+		++num;
+
+	return num;
+}
+
+static void
+ath10k_wmi_fw_pdev_base_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
+				   char *buf, u32 *length)
+{
+	u32 len = *length;
+	u32 buf_len = ATH10K_FW_STATS_BUF_SIZE;
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s\n",
+			"ath10k PDEV stats");
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+			"=================");
+
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			"Channel noise floor", pdev->ch_noise_floor);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"Channel TX power", pdev->chan_tx_power);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"TX frame count", pdev->tx_frame_count);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"RX frame count", pdev->rx_frame_count);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"RX clear count", pdev->rx_clear_count);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"Cycle count", pdev->cycle_count);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"PHY error count", pdev->phy_err_count);
+
+	*length = len;
+}
+
+static void
+ath10k_wmi_fw_pdev_extra_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
+				    char *buf, u32 *length)
+{
+	u32 len = *length;
+	u32 buf_len = ATH10K_FW_STATS_BUF_SIZE;
+
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"RTS bad count", pdev->rts_bad);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"RTS good count", pdev->rts_good);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"FCS bad count", pdev->fcs_bad);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"No beacon count", pdev->no_beacons);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			"MIB int count", pdev->mib_int_count);
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	*length = len;
+}
+
+static void
+ath10k_wmi_fw_pdev_tx_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
+				 char *buf, u32 *length)
+{
+	u32 len = *length;
+	u32 buf_len = ATH10K_FW_STATS_BUF_SIZE;
+
+	len += scnprintf(buf + len, buf_len - len, "\n%30s\n",
+			 "ath10k PDEV TX stats");
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "HTT cookies queued", pdev->comp_queued);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "HTT cookies disp.", pdev->comp_delivered);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MSDU queued", pdev->msdu_enqued);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MPDU queued", pdev->mpdu_enqued);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MSDUs dropped", pdev->wmm_drop);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Local enqued", pdev->local_enqued);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Local freed", pdev->local_freed);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "HW queued", pdev->hw_queued);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "PPDUs reaped", pdev->hw_reaped);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Num underruns", pdev->underrun);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "PPDUs cleaned", pdev->tx_abort);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MPDUs requed", pdev->mpdus_requed);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Excessive retries", pdev->tx_ko);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "HW rate", pdev->data_rc);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Sched self tiggers", pdev->self_triggers);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Dropped due to SW retries",
+			 pdev->sw_retry_failure);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Illegal rate phy errors",
+			 pdev->illgl_rate_phy_err);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Pdev continuous xretry", pdev->pdev_cont_xretry);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "TX timeout", pdev->pdev_tx_timeout);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "PDEV resets", pdev->pdev_resets);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "PHY underrun", pdev->phy_underrun);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MPDU is more than txop limit", pdev->txop_ovf);
+	*length = len;
+}
+
+static void
+ath10k_wmi_fw_pdev_rx_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
+				 char *buf, u32 *length)
+{
+	u32 len = *length;
+	u32 buf_len = ATH10K_FW_STATS_BUF_SIZE;
+
+	len += scnprintf(buf + len, buf_len - len, "\n%30s\n",
+			 "ath10k PDEV RX stats");
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Mid PPDU route change",
+			 pdev->mid_ppdu_route_change);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Tot. number of statuses", pdev->status_rcvd);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Extra frags on rings 0", pdev->r0_frags);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Extra frags on rings 1", pdev->r1_frags);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Extra frags on rings 2", pdev->r2_frags);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Extra frags on rings 3", pdev->r3_frags);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MSDUs delivered to HTT", pdev->htt_msdus);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MPDUs delivered to HTT", pdev->htt_mpdus);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MSDUs delivered to stack", pdev->loc_msdus);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MPDUs delivered to stack", pdev->loc_mpdus);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "Oversized AMSUs", pdev->oversize_amsdu);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "PHY errors", pdev->phy_errs);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "PHY errors drops", pdev->phy_err_drop);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "MPDU errors (FCS, MIC, ENC)", pdev->mpdu_errs);
+	*length = len;
+}
+
+static void
+ath10k_wmi_fw_vdev_stats_fill(const struct ath10k_fw_stats_vdev *vdev,
+			      char *buf, u32 *length)
+{
+	u32 len = *length;
+	u32 buf_len = ATH10K_FW_STATS_BUF_SIZE;
+	int i;
+
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"vdev id", vdev->vdev_id);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"beacon snr", vdev->beacon_snr);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"data snr", vdev->data_snr);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"num rx frames", vdev->num_rx_frames);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"num rts fail", vdev->num_rts_fail);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"num rts success", vdev->num_rts_success);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"num rx err", vdev->num_rx_err);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"num rx discard", vdev->num_rx_discard);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"num tx not acked", vdev->num_tx_not_acked);
+
+	for (i = 0 ; i < ARRAY_SIZE(vdev->num_tx_frames); i++)
+		len += scnprintf(buf + len, buf_len - len,
+				"%25s [%02d] %u\n",
+				"num tx frames", i,
+				vdev->num_tx_frames[i]);
+
+	for (i = 0 ; i < ARRAY_SIZE(vdev->num_tx_frames_retries); i++)
+		len += scnprintf(buf + len, buf_len - len,
+				"%25s [%02d] %u\n",
+				"num tx frames retries", i,
+				vdev->num_tx_frames_retries[i]);
+
+	for (i = 0 ; i < ARRAY_SIZE(vdev->num_tx_frames_failures); i++)
+		len += scnprintf(buf + len, buf_len - len,
+				"%25s [%02d] %u\n",
+				"num tx frames failures", i,
+				vdev->num_tx_frames_failures[i]);
+
+	for (i = 0 ; i < ARRAY_SIZE(vdev->tx_rate_history); i++)
+		len += scnprintf(buf + len, buf_len - len,
+				"%25s [%02d] 0x%08x\n",
+				"tx rate history", i,
+				vdev->tx_rate_history[i]);
+
+	for (i = 0 ; i < ARRAY_SIZE(vdev->beacon_rssi_history); i++)
+		len += scnprintf(buf + len, buf_len - len,
+				"%25s [%02d] %u\n",
+				"beacon rssi history", i,
+				vdev->beacon_rssi_history[i]);
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	*length = len;
+}
+
+static void
+ath10k_wmi_fw_peer_stats_fill(const struct ath10k_fw_stats_peer *peer,
+			      char *buf, u32 *length)
+{
+	u32 len = *length;
+	u32 buf_len = ATH10K_FW_STATS_BUF_SIZE;
+
+	len += scnprintf(buf + len, buf_len - len, "%30s %pM\n",
+			"Peer MAC address", peer->peer_macaddr);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"Peer RSSI", peer->peer_rssi);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"Peer TX rate", peer->peer_tx_rate);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"Peer RX rate", peer->peer_rx_rate);
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	*length = len;
+}
+
+void ath10k_wmi_main_op_fw_stats_fill(struct ath10k *ar,
+				      struct ath10k_fw_stats *fw_stats,
+				      char *buf)
+{
+	u32 len = 0;
+	u32 buf_len = ATH10K_FW_STATS_BUF_SIZE;
+	const struct ath10k_fw_stats_pdev *pdev;
+	const struct ath10k_fw_stats_vdev *vdev;
+	const struct ath10k_fw_stats_peer *peer;
+	size_t num_peers;
+	size_t num_vdevs;
+
+	spin_lock_bh(&ar->data_lock);
+
+	pdev = list_first_entry_or_null(&fw_stats->pdevs,
+					struct ath10k_fw_stats_pdev, list);
+	if (!pdev) {
+		ath10k_warn(ar, "failed to get pdev stats\n");
+		goto unlock;
+	}
+
+	num_peers = ath10k_wmi_fw_stats_num_peers(&fw_stats->peers);
+	num_vdevs = ath10k_wmi_fw_stats_num_vdevs(&fw_stats->vdevs);
+
+	ath10k_wmi_fw_pdev_base_stats_fill(pdev, buf, &len);
+	ath10k_wmi_fw_pdev_tx_stats_fill(pdev, buf, &len);
+	ath10k_wmi_fw_pdev_rx_stats_fill(pdev, buf, &len);
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
+			 "ath10k VDEV stats", num_vdevs);
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	list_for_each_entry(vdev, &fw_stats->vdevs, list) {
+		ath10k_wmi_fw_vdev_stats_fill(vdev, buf, &len);
+	}
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
+			 "ath10k PEER stats", num_peers);
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	list_for_each_entry(peer, &fw_stats->peers, list) {
+		ath10k_wmi_fw_peer_stats_fill(peer, buf, &len);
+	}
+
+unlock:
+	spin_unlock_bh(&ar->data_lock);
+
+	if (len >= buf_len)
+		buf[len - 1] = 0;
+	else
+		buf[len] = 0;
+}
+
+void ath10k_wmi_10x_op_fw_stats_fill(struct ath10k *ar,
+				     struct ath10k_fw_stats *fw_stats,
+				     char *buf)
+{
+	unsigned int len = 0;
+	unsigned int buf_len = ATH10K_FW_STATS_BUF_SIZE;
+	const struct ath10k_fw_stats_pdev *pdev;
+	const struct ath10k_fw_stats_vdev *vdev;
+	const struct ath10k_fw_stats_peer *peer;
+	size_t num_peers;
+	size_t num_vdevs;
+
+	spin_lock_bh(&ar->data_lock);
+
+	pdev = list_first_entry_or_null(&fw_stats->pdevs,
+					struct ath10k_fw_stats_pdev, list);
+	if (!pdev) {
+		ath10k_warn(ar, "failed to get pdev stats\n");
+		goto unlock;
+	}
+
+	num_peers = ath10k_wmi_fw_stats_num_peers(&fw_stats->peers);
+	num_vdevs = ath10k_wmi_fw_stats_num_vdevs(&fw_stats->vdevs);
+
+	ath10k_wmi_fw_pdev_base_stats_fill(pdev, buf, &len);
+	ath10k_wmi_fw_pdev_extra_stats_fill(pdev, buf, &len);
+	ath10k_wmi_fw_pdev_tx_stats_fill(pdev, buf, &len);
+	ath10k_wmi_fw_pdev_rx_stats_fill(pdev, buf, &len);
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
+			 "ath10k VDEV stats", num_vdevs);
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	list_for_each_entry(vdev, &fw_stats->vdevs, list) {
+		ath10k_wmi_fw_vdev_stats_fill(vdev, buf, &len);
+	}
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
+			 "ath10k PEER stats", num_peers);
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	list_for_each_entry(peer, &fw_stats->peers, list) {
+		ath10k_wmi_fw_peer_stats_fill(peer, buf, &len);
+	}
+
+unlock:
+	spin_unlock_bh(&ar->data_lock);
+
+	if (len >= buf_len)
+		buf[len - 1] = 0;
+	else
+		buf[len] = 0;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -6679,6 +7052,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -6744,6 +7118,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -6810,6 +7185,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
 };
 
 static const struct wmi_ops wmi_10_2_4_ops = {
@@ -6872,6 +7248,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
 	.gen_pdev_get_tpc_config = ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config,
+	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4c373b2..6e84d1c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6098,6 +6098,7 @@ struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
 struct ath10k_fw_stats_peer;
+struct ath10k_fw_stats;
 
 int ath10k_wmi_attach(struct ath10k *ar);
 void ath10k_wmi_detach(struct ath10k *ar);
@@ -6179,4 +6180,13 @@ void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar, const void *phyerr_buf,
 				 int left_len, struct wmi_phyerr_ev_arg *arg);
+void ath10k_wmi_main_op_fw_stats_fill(struct ath10k *ar,
+				      struct ath10k_fw_stats *fw_stats,
+				      char *buf);
+void ath10k_wmi_10x_op_fw_stats_fill(struct ath10k *ar,
+				     struct ath10k_fw_stats *fw_stats,
+				     char *buf);
+size_t ath10k_wmi_fw_stats_num_peers(struct list_head *head);
+size_t ath10k_wmi_fw_stats_num_vdevs(struct list_head *head);
+
 #endif /* _WMI_H_ */
-- 
1.7.9.5

