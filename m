Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:48050 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaC1N2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:28:53 -0400
Subject: [PATCH v5] ath10k: implement per-VDEV FW statistics
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 15:28:49 +0200
Message-ID: <20140328132849.31620.78501.stgit@potku.adurom.net> (sfid-20140328_142859_693973_91C21CD9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartosz Markowski <bartosz.markowski@tieto.com>

The WMI_REQUEST_PEER_STAT command with latest (999.999.0.716) FW
can return per-VDEV statistics. Using debugfs we can fetch this info now.

This is a backward compatible change. In case of older FW the VDEV
statistics are simply not returned.

kvalo: remove struct wmi_peer_stats_common cast from
ath10k_debug_read_target_stats()

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |   27 ++++++++++
 drivers/net/wireless/ath/ath10k/debug.c |   71 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h   |   87 +++++++++++++++++++++++++++----
 3 files changed, 164 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ad209a61675a..0cb4344c0910 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -115,10 +115,32 @@ struct ath10k_wmi {
 	struct ath10k_mem_chunk mem_chunks[ATH10K_MAX_MEM_REQS];
 };
 
+struct ath10k_snr_info {
+	s32 beacon_snr;
+	s32 data_snr;
+};
+
+struct ath10k_vdev_stat {
+	u32 vdev_id;
+	struct ath10k_snr_info vdev_snr;
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
@@ -172,6 +194,8 @@ struct ath10k_target_stats {
 	s32 mpdu_errs;
 
 	/* VDEV STATS */
+	struct ath10k_vdev_stat vdev_stat[TARGET_NUM_VDEVS];
+	u8 vdevs;
 
 	/* PEER STATS */
 	u8 peers;
@@ -320,6 +344,9 @@ enum ath10k_fw_features {
 	/* Firmware does not support P2P */
 	ATH10K_FW_FEATURE_NO_P2P = 3,
 
+	/* firmware supports per-VDEV statistics */
+	ATH10K_FW_FEATURE_VDEV_STATS = 4,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 2dc598c73089..438ba8ef4263 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -231,34 +231,59 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
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
+		struct wmi_peer_stats_common *peer_stats;
+		struct wmi_peer_stats_v1 *peer_v1;
+		struct wmi_peer_stats_v2 *peer_v2;
 
 		stats->peers = num_peer_stats;
 
 		for (i = 0; i < num_peer_stats; i++) {
-			peer_stats = (struct wmi_peer_stats *)tmp;
 			s = &stats->peer_stat[i];
 
+			if (test_bit(ATH10K_FW_FEATURE_VDEV_STATS,
+				     ar->fw_features)) {
+				peer_v2 = (struct wmi_peer_stats_v2 *)tmp;
+				peer_stats = &peer_v2->common;
+				s->peer_rx_rate =
+				    __le32_to_cpu(peer_v2->peer_rx_rate);
+
+				tmp += sizeof(*peer_v2);
+			} else {
+				peer_v1 = (struct wmi_peer_stats_v1 *)tmp;
+				peer_stats = &peer_v1->common;
+
+				tmp += sizeof(*peer_v1);
+			}
+
 			memcpy(s->peer_macaddr, &peer_stats->peer_macaddr.addr,
 			       ETH_ALEN);
 			s->peer_rssi = __le32_to_cpu(peer_stats->peer_rssi);
 			s->peer_tx_rate =
 				__le32_to_cpu(peer_stats->peer_tx_rate);
-
-			tmp += sizeof(struct wmi_peer_stats);
 		}
 	}
 
@@ -272,7 +297,7 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	struct ath10k *ar = file->private_data;
 	struct ath10k_target_stats *fw_stats;
 	char *buf = NULL;
-	unsigned int len = 0, buf_len = 2500;
+	unsigned int len = 0, buf_len = 3000;
 	ssize_t ret_cnt = 0;
 	long left;
 	int i;
@@ -410,6 +435,27 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
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
@@ -420,11 +466,18 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
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
+
+		if (test_bit(ATH10K_FW_FEATURE_VDEV_STATS, ar->fw_features))
+			len += scnprintf(buf + len, buf_len - len,
+					 "%30s %10u\n",
+					 "Peer RX rate",
+					 fw_stats->peer_stat[i].peer_rx_rate);
+
 		len += scnprintf(buf + len, buf_len - len, "\n");
 	}
 	spin_unlock_bh(&ar->data_lock);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e0421c271ad1..c3b468562289 100644
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
@@ -2768,11 +2773,10 @@ enum wmi_stats_id {
 
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
@@ -2821,7 +2825,6 @@ struct wmi_stats_event {
 
 /*
  * PDEV statistics
- * TODO: add all PDEV stats here
  */
 struct wmi_pdev_stats {
 	__le32 chan_nf;        /* Channel noise floor */
@@ -2834,24 +2837,84 @@ struct wmi_pdev_stats {
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
+struct wmi_peer_stats_common {
 	struct wmi_mac_addr peer_macaddr;
 	__le32 peer_rssi;
 	__le32 peer_tx_rate;
 } __packed;
 
+struct wmi_peer_stats_v1 {
+	struct wmi_peer_stats_common common;
+} __packed;
+
+
+struct wmi_peer_stats_v2 {
+	struct wmi_peer_stats_common common;
+	__le32 peer_rx_rate;
+} __packed;
+
+
 struct wmi_vdev_create_cmd {
 	__le32 vdev_id;
 	__le32 vdev_type;

