Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45870 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934447AbbGHIGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 04:06:51 -0400
From: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
Subject: [PATCH] ath10k: Make fw stats prints specific to firmware version
Date: Wed, 8 Jul 2015 13:36:21 +0530
Message-ID: <1436342781-16086-1-git-send-email-c_mpubbi@qti.qualcomm.com> (sfid-20150708_100722_151604_C0B56934)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently fw stats printing in ath10k is common to all firmware
versions. Eventually we end up printing the stats which are not
intended to be printed. For example, we might print stats of 10.2.4
in 10.2, additional stats will have the value of zeros and this
might lead to confusion.

The patch makes debug stats prints fw specific by adding a new member
in wmi_ops.

Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c   | 593 ++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/debug.h   |  20 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  13 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |   4 +
 5 files changed, 399 insertions(+), 232 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index edf6047..20cfa4c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -431,237 +431,6 @@ static int ath10k_debug_fw_stats_request(struct ath10k *ar)
 /* FIXME: How to calculate the buffer size sanely? */
 #define ATH10K_FW_STATS_BUF_SIZE (1024*1024)
 
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
@@ -687,7 +456,12 @@ static int ath10k_fw_stats_open(struct inode *inode, struct file *file)
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
@@ -2266,3 +2040,358 @@ void ath10k_dbg_dump(struct ath10k *ar,
 EXPORT_SYMBOL(ath10k_dbg_dump);
 
 #endif /* CONFIG_ATH10K_DEBUG */
+
+#ifdef CONFIG_ATH10K_DEBUG
+static void
+ath10k_debug_fw_pdev_base_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
+				     char *buf, int *length)
+{
+	int len = *length;
+	int buf_len = ATH10K_FW_STATS_BUF_SIZE;
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
+ath10k_debug_fw_pdev_extra_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
+				      char *buf, int *length)
+{
+	int len = *length;
+	int buf_len = ATH10K_FW_STATS_BUF_SIZE;
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
+ath10k_debug_fw_pdev_tx_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
+				   char *buf, int *length)
+{
+	int len = *length;
+	int buf_len = ATH10K_FW_STATS_BUF_SIZE;
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
+ath10k_debug_fw_pdev_rx_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
+				   char *buf, int *length)
+{
+	int len = *length;
+	int buf_len = ATH10K_FW_STATS_BUF_SIZE;
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
+ath10k_debug_fw_vdev_stats_fill_common(const struct ath10k_fw_stats_vdev *vdev,
+				       char *buf, int *length)
+{
+	int len = *length;
+	int buf_len = ATH10K_FW_STATS_BUF_SIZE;
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
+ath10k_debug_fw_peer_stats_fill_common(const struct ath10k_fw_stats_peer *peer,
+				       char *buf, int *length)
+{
+	int len = *length;
+	int buf_len = ATH10K_FW_STATS_BUF_SIZE;
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
+void ath10k_debug_fw_stats_fill(struct ath10k *ar,
+				struct ath10k_fw_stats *fw_stats,
+				char *buf)
+{
+	unsigned int len = 0;
+	int buf_len = ATH10K_FW_STATS_BUF_SIZE;
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
+	num_peers = ath10k_debug_fw_stats_num_peers(&fw_stats->peers);
+	num_vdevs = ath10k_debug_fw_stats_num_vdevs(&fw_stats->vdevs);
+
+	ath10k_debug_fw_pdev_base_stats_fill(pdev, buf, &len);
+	ath10k_debug_fw_pdev_tx_stats_fill(pdev, buf, &len);
+	ath10k_debug_fw_pdev_rx_stats_fill(pdev, buf, &len);
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
+			 "ath10k VDEV stats", num_vdevs);
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	list_for_each_entry(vdev, &fw_stats->vdevs, list) {
+		ath10k_debug_fw_vdev_stats_fill_common(vdev, buf, &len);
+	}
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
+			 "ath10k PEER stats", num_peers);
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	list_for_each_entry(peer, &fw_stats->peers, list) {
+		ath10k_debug_fw_peer_stats_fill_common(peer, buf, &len);
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
+void ath10k_debug_10x_fw_stats_fill(struct ath10k *ar,
+				    struct ath10k_fw_stats *fw_stats,
+				    char *buf)
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
+	num_peers = ath10k_debug_fw_stats_num_peers(&fw_stats->peers);
+	num_vdevs = ath10k_debug_fw_stats_num_vdevs(&fw_stats->vdevs);
+
+	ath10k_debug_fw_pdev_base_stats_fill(pdev, buf, &len);
+	ath10k_debug_fw_pdev_extra_stats_fill(pdev, buf, &len);
+	ath10k_debug_fw_pdev_tx_stats_fill(pdev, buf, &len);
+	ath10k_debug_fw_pdev_rx_stats_fill(pdev, buf, &len);
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
+			 "ath10k VDEV stats", num_vdevs);
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	list_for_each_entry(vdev, &fw_stats->vdevs, list) {
+		ath10k_debug_fw_vdev_stats_fill_common(vdev, buf, &len);
+	}
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
+			 "ath10k PEER stats", num_peers);
+	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+
+	list_for_each_entry(peer, &fw_stats->peers, list) {
+		ath10k_debug_fw_peer_stats_fill_common(peer, buf, &len);
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
+#endif /* CONFIG_ATH10K_DEBUG */
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 53bd6a1..d8eaab7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -72,6 +72,12 @@ void ath10k_debug_unregister(struct ath10k *ar);
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb);
 struct ath10k_fw_crash_data *
 ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
+void ath10k_debug_fw_stats_fill(struct ath10k *ar,
+				struct ath10k_fw_stats *fw_stats,
+				char *buf);
+void ath10k_debug_10x_fw_stats_fill(struct ath10k *ar,
+				    struct ath10k_fw_stats *fw_stats,
+				    char *buf);
 
 void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer, int len);
 #define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
@@ -128,6 +134,20 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 	return NULL;
 }
 
+static inline void
+ath10k_debug_fw_stats_fill(struct ath10k *ar,
+			   struct ath10k_fw_stats *fw_stats,
+			   char *buf)
+{
+}
+
+static inline void
+ath10k_debug_10x_fw_stats_fill(struct ath10k *ar,
+			       struct ath10k_fw_stats *fw_stats,
+			       char *buf)
+{
+}
+
 #define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
 
 #define ath10k_debug_get_et_strings NULL
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 47fe2e7..c054782 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -174,6 +174,9 @@ struct wmi_ops {
 						const struct wmi_tdls_peer_capab_arg *cap,
 						const struct wmi_channel_arg *chan);
 	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
+	void (*fw_stats_fill)(struct ath10k *ar,
+			      struct ath10k_fw_stats *fw_stats,
+			      char *buf);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1248,4 +1251,14 @@ ath10k_wmi_adaptive_qcs(struct ath10k *ar, bool enable)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->adaptive_qcs_cmdid);
 }
 
+static inline int
+ath10k_wmi_fw_stats_fill(struct ath10k *ar, struct ath10k_fw_stats *fw_stats,
+			 char *buf)
+{
+	if (!ar->wmi.ops->fw_stats_fill)
+		return -EOPNOTSUPP;
+
+	ar->wmi.ops->fw_stats_fill(ar, fw_stats, buf);
+	return 0;
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ced35a1..e4ff2f6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3439,6 +3439,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_update_fw_tdls_state = ath10k_wmi_tlv_op_gen_update_fw_tdls_state,
 	.gen_tdls_peer_update = ath10k_wmi_tlv_op_gen_tdls_peer_update,
 	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
+	.fw_stats_fill = ath10k_debug_fw_stats_fill,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 638332e..93e3b6b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6225,6 +6225,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.fw_stats_fill = ath10k_debug_fw_stats_fill,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -6289,6 +6290,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.fw_stats_fill = ath10k_debug_10x_fw_stats_fill,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -6354,6 +6356,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.fw_stats_fill = ath10k_debug_10x_fw_stats_fill,
 };
 
 static const struct wmi_ops wmi_10_2_4_ops = {
@@ -6414,6 +6417,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.fw_stats_fill = ath10k_debug_10x_fw_stats_fill,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
-- 
1.9.1

