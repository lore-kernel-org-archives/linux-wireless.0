Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:52884 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab3H0IqP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:46:15 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: implement per-VDEV FW statistics
Date: Tue, 27 Aug 2013 10:43:16 +0200
Message-ID: <1377592996-21934-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130827_104620_943065_05A486EB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The WMI_REQUEST_PEER_STAT command with latst (1.0.0.716) FW
can return per-VDEV statistics. Using debugfs we can fetch this info now.

This is a backward compatible change. In case of older FW the VDEV
statistics are simply not returned.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |   22 ++++++++
 drivers/net/wireless/ath/ath10k/debug.c |   54 +++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.c   |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.h   |   85 ++++++++++++++++++++++++++-----
 4 files changed, 144 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ab05c4c..f94482b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -119,10 +119,27 @@ struct ath10k_wmi {
 	struct work_struct wmi_event_work;
 };
 
+struct ath10k_vdev_stat {
+	u32 vdev_id;
+	struct wmi_snr_info vdev_snr;
+	u32 tx_frames_count[MAX_AC];
+	u32 rx_frames_count;
+	u32 multiple_retry_cnt[MAX_AC];
+	u32 fail_count[MAX_AC];
+	u32 rts_fail_count;
+	u32 rts_success_count;
+	u32 rts_err_count;
+	u32 rx_discard_count;
+	u32 ack_fail_count;
+	u32 tx_rate_history[MAX_TX_RATE_VALUES];
+	u32 bcn_rssi_history[MAX_RSSI_VALUES];
+};
+
 struct ath10k_peer_stat {
 	u8 peer_macaddr[ETH_ALEN];
 	u32 peer_rssi;
 	u32 peer_tx_rate;
+	u32 peer_rx_rate;
 };
 
 struct ath10k_target_stats {
@@ -176,6 +193,8 @@ struct ath10k_target_stats {
 	s32 mpdu_errs;
 
 	/* VDEV STATS */
+	struct ath10k_vdev_stat vdev_stat[TARGET_NUM_VDEVS];
+	u8 vdevs;
 
 	/* PEER STATS */
 	u8 peers;
@@ -274,6 +293,9 @@ enum ath10k_fw_features {
 	/* wmi_mgmt_rx_hdr contains extra RSSI information */
 	ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX = 0,
 
+	/* firmware support per-VEDV statistics */
+	ATH10K_FW_FEATURE_VDEV_STATS = 1,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 3d65594..4d240e1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -228,25 +228,37 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 		tmp += sizeof(struct wmi_pdev_stats);
 	}
 
-	/* 0 or max vdevs */
-	/* Currently firmware does not support VDEV stats */
 	if (num_vdev_stats) {
 		struct wmi_vdev_stats *vdev_stats;
+		struct ath10k_vdev_stat *s;
+
+		stats->vdevs = num_vdev_stats;
 
 		for (i = 0; i < num_vdev_stats; i++) {
 			vdev_stats = (struct wmi_vdev_stats *)tmp;
+			s = &stats->vdev_stat[i];
+
+			s->vdev_id = __le32_to_cpu(vdev_stats->vdev_id);
+			s->vdev_snr.beacon_snr =
+				__le32_to_cpu(vdev_stats->vdev_snr.beacon_snr);
+			s->vdev_snr.data_snr =
+				__le32_to_cpu(vdev_stats->vdev_snr.data_snr);
+
+			/* TODO:read remaining vdev stats */
+
 			tmp += sizeof(struct wmi_vdev_stats);
 		}
 	}
 
 	if (num_peer_stats) {
-		struct wmi_peer_stats *peer_stats;
 		struct ath10k_peer_stat *s;
+		struct wmi_peer_stats_1 *peer_stats;
 
 		stats->peers = num_peer_stats;
 
 		for (i = 0; i < num_peer_stats; i++) {
-			peer_stats = (struct wmi_peer_stats *)tmp;
+			peer_stats = (struct wmi_peer_stats_1 *)tmp;
+
 			s = &stats->peer_stat[i];
 
 			WMI_MAC_ADDR_TO_CHAR_ARRAY(&peer_stats->peer_macaddr,
@@ -255,7 +267,12 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 			s->peer_tx_rate =
 				__le32_to_cpu(peer_stats->peer_tx_rate);
 
-			tmp += sizeof(struct wmi_peer_stats);
+			if (test_bit(ATH10K_FW_FEATURE_VDEV_STATS,
+				     ar->fw_features)) {
+				tmp += sizeof(struct wmi_peer_stats_2);
+			} else {
+				tmp += sizeof(struct wmi_peer_stats_1);
+			}
 		}
 	}
 
@@ -270,7 +287,7 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	struct ath10k *ar = file->private_data;
 	struct ath10k_target_stats *fw_stats;
 	char *buf = NULL;
-	unsigned int len = 0, buf_len = 2500;
+	unsigned int len = 0, buf_len = 3000;
 	ssize_t ret_cnt = 0;
 	long left;
 	int i;
@@ -408,6 +425,27 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
 			 "MPDU errors (FCS, MIC, ENC)", fw_stats->mpdu_errs);
 
+	if (fw_stats->vdevs) {
+		len += scnprintf(buf + len, buf_len - len, "\n");
+		len += scnprintf(buf + len, buf_len - len, "%30s\n",
+				 "ath10k VDEV stats");
+		len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
+				 "=================");
+	}
+
+	for (i = 0; i < fw_stats->vdevs; i++) {
+		len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+				 "VDEV ID", fw_stats->vdev_stat[i].vdev_id);
+		len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+				 "Beacon SNR",
+				 fw_stats->vdev_stat[i].vdev_snr.beacon_snr);
+		len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+				 "Data SNR",
+				 fw_stats->vdev_stat[i].vdev_snr.data_snr);
+		len += scnprintf(buf + len, buf_len - len, "\n");
+	}
+
+
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%30s\n",
 			 "ath10k PEER stats");
@@ -418,9 +456,9 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 		len += scnprintf(buf + len, buf_len - len, "%30s %pM\n",
 				 "Peer MAC address",
 				 fw_stats->peer_stat[i].peer_macaddr);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+		len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
 				 "Peer RSSI", fw_stats->peer_stat[i].peer_rssi);
-		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+		len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
 				 "Peer TX rate",
 				 fw_stats->peer_stat[i].peer_tx_rate);
 		len += scnprintf(buf + len, buf_len - len, "\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 32fd5e7..3ebab3d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -957,8 +957,10 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	ar->phy_capability = __le32_to_cpu(ev->phy_capability);
 	ar->num_rf_chains = __le32_to_cpu(ev->num_rf_chains);
 
-	if (ar->fw_version_build > 636)
+	if (ar->fw_version_build > 636) {
 		set_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features);
+		set_bit(ATH10K_FW_FEATURE_VDEV_STATS, ar->fw_features);
+	}
 
 	if (ar->num_rf_chains > WMI_MAX_SPATIAL_STREAM) {
 		ath10k_warn("hardware advertises support for more spatial streams than it should (%d > %d)\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 08860c4..626bf02 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -60,6 +60,11 @@
  *
  */
 
+#define MAX_AC 4 /* Maximum value of access category */
+
+#define MAX_TX_RATE_VALUES      10 /* Max Tx rates */
+#define MAX_RSSI_VALUES         10 /* Max RSSI values */
+
 /* Control Path */
 struct wmi_cmd_hdr {
 	__le32 cmd_id;
@@ -1767,6 +1772,9 @@ struct wal_dbg_tx_stats {
 	/* wal pdev resets  */
 	__le32 pdev_resets;
 
+	/* frames dropped due to non-availability of stateless TIDs */
+	__le32 stateless_tid_alloc_failure;
+
 	__le32 phy_underrun;
 
 	/* MPDU is more than txop limit */
@@ -1825,11 +1833,10 @@ enum wmi_stats_id {
 
 struct wmi_request_stats_cmd {
 	__le32 stats_id;
-
-	/*
-	 * Space to add parameters like
-	 * peer mac addr
-	 */
+	/* unique id identifying the VDEV, generated by the caller */
+	__le32 vdev_id;
+	/* peer MAC address */
+	struct wmi_mac_addr peer_macaddr;
 } __packed;
 
 /* Suspend option */
@@ -1878,7 +1885,6 @@ struct wmi_stats_event {
 
 /*
  * PDEV statistics
- * TODO: add all PDEV stats here
  */
 struct wmi_pdev_stats {
 	__le32 chan_nf;        /* Channel noise floor */
@@ -1891,24 +1897,79 @@ struct wmi_pdev_stats {
 	struct wal_dbg_stats wal; /* WAL dbg stats */
 } __packed;
 
-/*
- * VDEV statistics
- * TODO: add all VDEV stats here
- */
+struct wmi_snr_info {
+	__le32 beacon_snr;
+	__le32 data_snr;
+} __packed;
+
 struct wmi_vdev_stats {
+	/* unique id identifying the VDEV, generated by the caller */
 	__le32 vdev_id;
+	struct wmi_snr_info vdev_snr;
+	/*
+	 * Total number of packets(per AC) that were successfully transmitted
+	 * (with and without retries, including multi-cast, broadcast)
+	 */
+	__le32 tx_frm_cnt[MAX_AC];
+	/*
+	 * Total number of packets that were successfully received
+	 * (after appropriate filter rules including multi-cast, broadcast)
+	 */
+	__le32 rx_frm_cnt;
+	/*
+	 * The number of MSDU packets and MMPDU frames per AC that the 802.11
+	 * station successfully transmitted after more than one retransmission
+	 * attempt
+	 */
+	__le32 multiple_retry_cnt[MAX_AC];
+	/* Total number packets(per AC) failed to transmit */
+	__le32 fail_cnt[MAX_AC];
+	/*
+	 * Total number of RTS/CTS sequence failures for transmission of a
+	 * packet
+	 */
+	__le32 rts_fail_cnt;
+	/*
+	 * Total number of RTS/CTS sequence success for transmission of a
+	 * packet
+	 */
+	__le32 rts_succ_cnt;
+	/*
+	 * The receive error count.
+	 * HAL will provide the RxP FCS error global
+	 */
+	__le32 rx_err_cnt;
+	/*
+	 * The sum of the receive error count and dropped-receive-buffer
+	 * error count. (FCS error)
+	 */
+	__le32 rx_discard_cnt;
+	/*
+	 * Total number packets failed transmit because of no ACK
+	 * from the remote entity
+	 */
+	__le32 ack_fail_cnt;
+	/* History of last ten transmit rate, in units of 500 kbit/sec */
+	__le32 tx_rate_history[MAX_TX_RATE_VALUES];
+	/* History of last ten Beacon rssi of the connected Bss */
+	__le32 bcn_rssi_history[MAX_RSSI_VALUES];
 } __packed;
 
 /*
  * peer statistics.
- * TODO: add more stats
  */
-struct wmi_peer_stats {
+struct wmi_peer_stats_1 {
 	struct wmi_mac_addr peer_macaddr;
 	__le32 peer_rssi;
 	__le32 peer_tx_rate;
 } __packed;
 
+struct wmi_peer_stats_2 {
+	struct wmi_peer_stats_1 wmi_peer_stats_1;
+	__le32 peer_rx_rate;
+} __packed;
+
+
 struct wmi_vdev_create_cmd {
 	__le32 vdev_id;
 	__le32 vdev_type;
-- 
1.7.10

