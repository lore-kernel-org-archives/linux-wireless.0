Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34522 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaIYKoi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 06:44:38 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so9119256wiv.3
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2014 03:44:37 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/4] ath10k: fix fw stats processing
Date: Thu, 25 Sep 2014 12:33:50 +0200
Message-Id: <1411641230-18785-5-git-send-email-michal.kazior@tieto.com> (sfid-20140925_124445_855144_D1929CB1)
In-Reply-To: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If stat data exceeds wmi-htc buffer limits
firmware splits it into many wmi stats update
events which are delivered in a ping-pong fashion
triggered by wmi stats request command.

Since there's only an implicit start-of-data and
no end-of-data indications the driver has to
perform some trickery to get complete stat data.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  19 +--
 drivers/net/wireless/ath/ath10k/debug.c | 273 +++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/wmi.c   |  55 +++++--
 3 files changed, 252 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 082a8dad..674e38c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -117,13 +117,17 @@ struct ath10k_wmi {
 };
 
 struct ath10k_fw_stats_peer {
+	struct list_head list;
+
 	u8 peer_macaddr[ETH_ALEN];
 	u32 peer_rssi;
 	u32 peer_tx_rate;
 	u32 peer_rx_rate; /* 10x only */
 };
 
-struct ath10k_fw_stats {
+struct ath10k_fw_stats_pdev {
+	struct list_head list;
+
 	/* PDEV stats */
 	s32 ch_noise_floor;
 	u32 tx_frame_count;
@@ -178,15 +182,11 @@ struct ath10k_fw_stats {
 	s32 phy_errs;
 	s32 phy_err_drop;
 	s32 mpdu_errs;
+};
 
-	/* VDEV STATS */
-
-	/* PEER STATS */
-	u8 peers;
-	struct ath10k_fw_stats_peer peer_stat[TARGET_NUM_PEERS];
-
-	/* TODO: Beacon filter stats */
-
+struct ath10k_fw_stats {
+	struct list_head pdevs;
+	struct list_head peers;
 };
 
 struct ath10k_dfs_stats {
@@ -294,6 +294,7 @@ struct ath10k_debug {
 
 	struct ath10k_fw_stats fw_stats;
 	struct completion fw_stats_complete;
+	bool fw_stats_done;
 	DECLARE_BITMAP(wmi_service_bitmap, WMI_SERVICE_MAX);
 
 	unsigned long htt_stats_mask;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 1ab0f10..4724172 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -242,39 +242,154 @@ static const struct file_operations fops_wmi_services = {
 	.llseek = default_llseek,
 };
 
+static void ath10k_debug_fw_stats_pdevs_free(struct list_head *head)
+{
+	struct ath10k_fw_stats_pdev *i, *tmp;
+
+	list_for_each_entry_safe(i, tmp, head, list) {
+		list_del(&i->list);
+		kfree(i);
+	}
+}
+
+static void ath10k_debug_fw_stats_peers_free(struct list_head *head)
+{
+	struct ath10k_fw_stats_peer *i, *tmp;
+
+	list_for_each_entry_safe(i, tmp, head, list) {
+		list_del(&i->list);
+		kfree(i);
+	}
+}
+
+static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
+{
+	spin_lock_bh(&ar->data_lock);
+	ar->debug.fw_stats_done = false;
+	ath10k_debug_fw_stats_pdevs_free(&ar->debug.fw_stats.pdevs);
+	ath10k_debug_fw_stats_peers_free(&ar->debug.fw_stats.peers);
+	spin_unlock_bh(&ar->data_lock);
+}
+
+static size_t ath10k_debug_fw_stats_num_peers(struct list_head *head)
+{
+	struct ath10k_fw_stats_peer *i;
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
+	struct ath10k_fw_stats stats = {};
+	bool is_start, is_started, is_end;
+	size_t num_peers;
 	int ret;
 
-	spin_lock_bh(&ar->data_lock);
+	INIT_LIST_HEAD(&stats.pdevs);
+	INIT_LIST_HEAD(&stats.peers);
 
-	ret = ath10k_wmi_pull_fw_stats(ar, skb, &ar->debug.fw_stats);
+	spin_lock_bh(&ar->data_lock);
+	ret = ath10k_wmi_pull_fw_stats(ar, skb, &stats);
 	if (ret) {
 		ath10k_warn(ar, "failed to pull fw stats: %d\n", ret);
 		goto unlock;
 	}
 
+	/* Stat data may exceed htc-wmi buffer limit. In such case firmware
+	 * splits the stats data and delivers it in a ping-pong fashion of
+	 * request cmd-update event.
+	 *
+	 * However there is no explicit end-of-data. Instead start-of-data is
+	 * used as an implicit one. This works as follows:
+	 *  a) discard stat update events until one with pdev stats is
+	 *     delivered - this skips session started at end of (b)
+	 *  b) consume stat update events until another one with pdev stats is
+	 *     delivered which is treated as end-of-data and is itself discarded
+	 */
+
+	if (ar->debug.fw_stats_done) {
+		ath10k_warn(ar, "received unsolicited stats update event\n");
+		goto free;
+	}
+
+	num_peers = ath10k_debug_fw_stats_num_peers(&ar->debug.fw_stats.peers);
+	is_start = (list_empty(&ar->debug.fw_stats.pdevs) &&
+		    !list_empty(&stats.pdevs));
+	is_end = (!list_empty(&ar->debug.fw_stats.pdevs) &&
+		  !list_empty(&stats.pdevs));
+
+	if (is_start)
+		list_splice_tail_init(&stats.pdevs, &ar->debug.fw_stats.pdevs);
+
+	if (is_end)
+		ar->debug.fw_stats_done = true;
+
+	is_started = !list_empty(&ar->debug.fw_stats.pdevs);
+
+	if (is_started && !is_end) {
+		if (num_peers >= ATH10K_MAX_NUM_PEER_IDS) {
+			/* Although this is unlikely impose a sane limit to
+			 * prevent firmware from DoS-ing the host.
+			 */
+			ath10k_warn(ar, "dropping fw peer stats\n");
+			goto free;
+		}
+
+		list_splice_tail_init(&stats.peers, &ar->debug.fw_stats.peers);
+	}
+
 	complete(&ar->debug.fw_stats_complete);
 
+free:
+	/* In some cases lists have been spliced and cleared. Free up
+	 * resouruces if that is not the case.
+	 */
+	ath10k_debug_fw_stats_pdevs_free(&stats.pdevs);
+	ath10k_debug_fw_stats_peers_free(&stats.peers);
+
 unlock:
 	spin_unlock_bh(&ar->data_lock);
 }
 
-static int ath10k_fw_stats_request(struct ath10k *ar)
+static int ath10k_debug_fw_stats_request(struct ath10k *ar)
 {
+	unsigned long timeout;
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
-	if (ret) {
-		ath10k_warn(ar, "failed to fw stat request command: %d\n", ret);
-		return ret;
-	}
+	timeout = jiffies + msecs_to_jiffies(1*HZ);
+
+	ath10k_debug_fw_stats_reset(ar);
+
+	for (;;) {
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+
+		reinit_completion(&ar->debug.fw_stats_complete);
+
+		ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
+		if (ret) {
+			ath10k_warn(ar, "could not request stats (%d)\n", ret);
+			return ret;
+		}
 
-	ret = wait_for_completion_timeout(&ar->debug.fw_stats_complete, 1*HZ);
-	if (ret <= 0)
-		return -ETIMEDOUT;
+		ret = wait_for_completion_timeout(&ar->debug.fw_stats_complete,
+						  1*HZ);
+		if (ret <= 0)
+			return -ETIMEDOUT;
+
+		spin_lock_bh(&ar->data_lock);
+		if (ar->debug.fw_stats_done) {
+			spin_unlock_bh(&ar->data_lock);
+			break;
+		}
+		spin_unlock_bh(&ar->data_lock);
+	}
 
 	return 0;
 }
@@ -288,9 +403,21 @@ static void ath10k_fw_stats_fill(struct ath10k *ar,
 {
 	unsigned int len = 0;
 	unsigned int buf_len = ATH10K_FW_STATS_BUF_SIZE;
-	int i;
+	const struct ath10k_fw_stats_pdev *pdev;
+	const struct ath10k_fw_stats_peer *peer;
+	size_t num_peers;
 
 	spin_lock_bh(&ar->data_lock);
+
+	pdev = list_first_entry_or_null(&fw_stats->pdevs,
+					struct ath10k_fw_stats_pdev, list);
+	if (!pdev) {
+		ath10k_warn(ar, "failed to get pdev stats\n");
+		goto unlock;
+	}
+
+	num_peers = ath10k_debug_fw_stats_num_peers(&fw_stats->peers);
+
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%30s\n",
 			 "ath10k PDEV stats");
@@ -298,29 +425,29 @@ static void ath10k_fw_stats_fill(struct ath10k *ar,
 				 "=================");
 
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Channel noise floor", fw_stats->ch_noise_floor);
+			 "Channel noise floor", pdev->ch_noise_floor);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "Channel TX power", fw_stats->chan_tx_power);
+			 "Channel TX power", pdev->chan_tx_power);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "TX frame count", fw_stats->tx_frame_count);
+			 "TX frame count", pdev->tx_frame_count);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "RX frame count", fw_stats->rx_frame_count);
+			 "RX frame count", pdev->rx_frame_count);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "RX clear count", fw_stats->rx_clear_count);
+			 "RX clear count", pdev->rx_clear_count);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "Cycle count", fw_stats->cycle_count);
+			 "Cycle count", pdev->cycle_count);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "PHY error count", fw_stats->phy_err_count);
+			 "PHY error count", pdev->phy_err_count);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "RTS bad count", fw_stats->rts_bad);
+			 "RTS bad count", pdev->rts_bad);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "RTS good count", fw_stats->rts_good);
+			 "RTS good count", pdev->rts_good);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "FCS bad count", fw_stats->fcs_bad);
+			 "FCS bad count", pdev->fcs_bad);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "No beacon count", fw_stats->no_beacons);
+			 "No beacon count", pdev->no_beacons);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
-			 "MIB int count", fw_stats->mib_int_count);
+			 "MIB int count", pdev->mib_int_count);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%30s\n",
@@ -329,51 +456,51 @@ static void ath10k_fw_stats_fill(struct ath10k *ar,
 				 "=================");
 
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "HTT cookies queued", fw_stats->comp_queued);
+			 "HTT cookies queued", pdev->comp_queued);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "HTT cookies disp.", fw_stats->comp_delivered);
+			 "HTT cookies disp.", pdev->comp_delivered);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MSDU queued", fw_stats->msdu_enqued);
+			 "MSDU queued", pdev->msdu_enqued);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDU queued", fw_stats->mpdu_enqued);
+			 "MPDU queued", pdev->mpdu_enqued);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MSDUs dropped", fw_stats->wmm_drop);
+			 "MSDUs dropped", pdev->wmm_drop);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Local enqued", fw_stats->local_enqued);
+			 "Local enqued", pdev->local_enqued);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Local freed", fw_stats->local_freed);
+			 "Local freed", pdev->local_freed);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "HW queued", fw_stats->hw_queued);
+			 "HW queued", pdev->hw_queued);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PPDUs reaped", fw_stats->hw_reaped);
+			 "PPDUs reaped", pdev->hw_reaped);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Num underruns", fw_stats->underrun);
+			 "Num underruns", pdev->underrun);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PPDUs cleaned", fw_stats->tx_abort);
+			 "PPDUs cleaned", pdev->tx_abort);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDUs requed", fw_stats->mpdus_requed);
+			 "MPDUs requed", pdev->mpdus_requed);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Excessive retries", fw_stats->tx_ko);
+			 "Excessive retries", pdev->tx_ko);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "HW rate", fw_stats->data_rc);
+			 "HW rate", pdev->data_rc);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Sched self tiggers", fw_stats->self_triggers);
+			 "Sched self tiggers", pdev->self_triggers);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
 			 "Dropped due to SW retries",
-			 fw_stats->sw_retry_failure);
+			 pdev->sw_retry_failure);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
 			 "Illegal rate phy errors",
-			 fw_stats->illgl_rate_phy_err);
+			 pdev->illgl_rate_phy_err);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Pdev continous xretry", fw_stats->pdev_cont_xretry);
+			 "Pdev continous xretry", pdev->pdev_cont_xretry);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "TX timeout", fw_stats->pdev_tx_timeout);
+			 "TX timeout", pdev->pdev_tx_timeout);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PDEV resets", fw_stats->pdev_resets);
+			 "PDEV resets", pdev->pdev_resets);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PHY underrun", fw_stats->phy_underrun);
+			 "PHY underrun", pdev->phy_underrun);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDU is more than txop limit", fw_stats->txop_ovf);
+			 "MPDU is more than txop limit", pdev->txop_ovf);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%30s\n",
@@ -383,54 +510,53 @@ static void ath10k_fw_stats_fill(struct ath10k *ar,
 
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
 			 "Mid PPDU route change",
-			 fw_stats->mid_ppdu_route_change);
+			 pdev->mid_ppdu_route_change);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Tot. number of statuses", fw_stats->status_rcvd);
+			 "Tot. number of statuses", pdev->status_rcvd);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Extra frags on rings 0", fw_stats->r0_frags);
+			 "Extra frags on rings 0", pdev->r0_frags);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Extra frags on rings 1", fw_stats->r1_frags);
+			 "Extra frags on rings 1", pdev->r1_frags);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Extra frags on rings 2", fw_stats->r2_frags);
+			 "Extra frags on rings 2", pdev->r2_frags);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Extra frags on rings 3", fw_stats->r3_frags);
+			 "Extra frags on rings 3", pdev->r3_frags);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MSDUs delivered to HTT", fw_stats->htt_msdus);
+			 "MSDUs delivered to HTT", pdev->htt_msdus);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDUs delivered to HTT", fw_stats->htt_mpdus);
+			 "MPDUs delivered to HTT", pdev->htt_mpdus);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MSDUs delivered to stack", fw_stats->loc_msdus);
+			 "MSDUs delivered to stack", pdev->loc_msdus);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDUs delivered to stack", fw_stats->loc_mpdus);
+			 "MPDUs delivered to stack", pdev->loc_mpdus);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "Oversized AMSUs", fw_stats->oversize_amsdu);
+			 "Oversized AMSUs", pdev->oversize_amsdu);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PHY errors", fw_stats->phy_errs);
+			 "PHY errors", pdev->phy_errs);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "PHY errors drops", fw_stats->phy_err_drop);
+			 "PHY errors drops", pdev->phy_err_drop);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDU errors (FCS, MIC, ENC)", fw_stats->mpdu_errs);
+			 "MPDU errors (FCS, MIC, ENC)", pdev->mpdu_errs);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
-	len += scnprintf(buf + len, buf_len - len, "%30s (%d)\n",
-			 "ath10k PEER stats", fw_stats->peers);
+	len += scnprintf(buf + len, buf_len - len, "%30s (%lu)\n",
+			 "ath10k PEER stats", num_peers);
 	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
 				 "=================");
 
-	for (i = 0; i < fw_stats->peers; i++) {
+	list_for_each_entry(peer, &fw_stats->peers, list) {
 		len += scnprintf(buf + len, buf_len - len, "%30s %pM\n",
-				 "Peer MAC address",
-				 fw_stats->peer_stat[i].peer_macaddr);
+				 "Peer MAC address", peer->peer_macaddr);
 		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "Peer RSSI", fw_stats->peer_stat[i].peer_rssi);
+				 "Peer RSSI", peer->peer_rssi);
 		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "Peer TX rate",
-				 fw_stats->peer_stat[i].peer_tx_rate);
+				 "Peer TX rate", peer->peer_tx_rate);
 		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
-				 "Peer RX rate",
-				 fw_stats->peer_stat[i].peer_rx_rate);
+				 "Peer RX rate", peer->peer_rx_rate);
 		len += scnprintf(buf + len, buf_len - len, "\n");
 	}
+
+unlock:
 	spin_unlock_bh(&ar->data_lock);
 
 	if (len >= buf_len)
@@ -458,7 +584,7 @@ static int ath10k_fw_stats_open(struct inode *inode, struct file *file)
 		goto err_unlock;
 	}
 
-	ret = ath10k_fw_stats_request(ar);
+	ret = ath10k_debug_fw_stats_request(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to request fw stats: %d\n", ret);
 		goto err_free;
@@ -1097,6 +1223,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	if (!ar->debug.fw_crash_data)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ar->debug.fw_stats.pdevs);
+	INIT_LIST_HEAD(&ar->debug.fw_stats.peers);
+
 	return 0;
 }
 
@@ -1104,6 +1233,8 @@ void ath10k_debug_destroy(struct ath10k *ar)
 {
 	vfree(ar->debug.fw_crash_data);
 	ar->debug.fw_crash_data = NULL;
+
+	ath10k_debug_fw_stats_reset(ar);
 }
 
 int ath10k_debug_register(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c4640aa..f65032f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1330,7 +1330,7 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 }
 
 static void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
-				       struct ath10k_fw_stats *dst)
+				       struct ath10k_fw_stats_pdev *dst)
 {
 	const struct wal_dbg_tx_stats *tx = &src->wal.tx;
 	const struct wal_dbg_rx_stats *rx = &src->wal.rx;
@@ -1405,26 +1405,38 @@ static int ath10k_wmi_main_pull_fw_stats(struct ath10k *ar,
 	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 
-	if (num_pdev_stats) {
+	for (i = 0; i < num_pdev_stats; i++) {
 		const struct wmi_pdev_stats *src;
+		struct ath10k_fw_stats_pdev *dst;
 
 		src = (void *)skb->data;
 		if (!skb_pull(skb, sizeof(*src)))
 			return -EPROTO;
 
-		ath10k_wmi_pull_pdev_stats(src, stats);
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_pdev_stats(src, dst);
+		list_add_tail(&dst->list, &stats->pdevs);
 	}
 
 	/* fw doesn't implement vdev stats */
 
 	for (i = 0; i < num_peer_stats; i++) {
 		const struct wmi_peer_stats *src;
+		struct ath10k_fw_stats_peer *dst;
 
 		src = (void *)skb->data;
 		if (!skb_pull(skb, sizeof(*src)))
 			return -EPROTO;
 
-		ath10k_wmi_pull_peer_stats(src, &stats->peer_stat[i]);
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_peer_stats(src, dst);
+		list_add_tail(&dst->list, &stats->peers);
 	}
 
 	return 0;
@@ -1445,36 +1457,49 @@ static int ath10k_wmi_10x_pull_fw_stats(struct ath10k *ar,
 	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 
-	if (num_pdev_stats) {
+	for (i = 0; i < num_pdev_stats; i++) {
 		const struct wmi_10x_pdev_stats *src;
+		struct ath10k_fw_stats_pdev *dst;
 
 		src = (void *)skb->data;
 		if (!skb_pull(skb, sizeof(*src)))
 			return -EPROTO;
 
-		ath10k_wmi_pull_pdev_stats(&src->old, stats);
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_pdev_stats(&src->old, dst);
+
+		dst->ack_rx_bad = __le32_to_cpu(src->ack_rx_bad);
+		dst->rts_bad = __le32_to_cpu(src->rts_bad);
+		dst->rts_good = __le32_to_cpu(src->rts_good);
+		dst->fcs_bad = __le32_to_cpu(src->fcs_bad);
+		dst->no_beacons = __le32_to_cpu(src->no_beacons);
+		dst->mib_int_count = __le32_to_cpu(src->mib_int_count);
 
-		stats->ack_rx_bad = __le32_to_cpu(src->ack_rx_bad);
-		stats->rts_bad = __le32_to_cpu(src->rts_bad);
-		stats->rts_good = __le32_to_cpu(src->rts_good);
-		stats->fcs_bad = __le32_to_cpu(src->fcs_bad);
-		stats->no_beacons = __le32_to_cpu(src->no_beacons);
-		stats->mib_int_count = __le32_to_cpu(src->mib_int_count);
+		list_add_tail(&dst->list, &stats->pdevs);
 	}
 
 	/* fw doesn't implement vdev stats */
 
 	for (i = 0; i < num_peer_stats; i++) {
 		const struct wmi_10x_peer_stats *src;
+		struct ath10k_fw_stats_peer *dst;
 
 		src = (void *)skb->data;
 		if (!skb_pull(skb, sizeof(*src)))
 			return -EPROTO;
 
-		ath10k_wmi_pull_peer_stats(&src->old, &stats->peer_stat[i]);
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ath10k_wmi_pull_peer_stats(&src->old, dst);
+
+		dst->peer_rx_rate = __le32_to_cpu(src->peer_rx_rate);
 
-		stats->peer_stat[i].peer_rx_rate =
-				__le32_to_cpu(src->peer_rx_rate);
+		list_add_tail(&dst->list, &stats->peers);
 	}
 
 	return 0;
-- 
1.8.5.3

