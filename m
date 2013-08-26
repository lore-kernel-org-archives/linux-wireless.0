Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:63949 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab3HZLtK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 07:49:10 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 3/3] ath10k: implement per-VDEV FW statistics
Date: Mon, 26 Aug 2013 13:33:34 +0200
Message-ID: <1377516815-12660-4-git-send-email-bartosz.markowski@tieto.com> (sfid-20130826_134914_696747_10164392)
In-Reply-To: <1377516815-12660-1-git-send-email-bartosz.markowski@tieto.com>
References: <1377516815-12660-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The WMI_REQUEST_PEER_STAT command with latst (1.0.0.716) FW
can return per-VDEV statistics. Using debugfs we can fetch this info now.

This is NOT a backward compatible change, due to ABI changes in
wmi_peer_stats stats (new peer_rx_rate) field.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |   18 ++++++++++
 drivers/net/wireless/ath/ath10k/debug.c |   42 ++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h   |   55 ++++++++++++++++++++++++++++---
 3 files changed, 106 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ab05c4c..8e4e33e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -119,6 +119,22 @@ struct ath10k_wmi {
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
@@ -176,6 +192,8 @@ struct ath10k_target_stats {
 	s32 mpdu_errs;
 
 	/* VDEV STATS */
+	struct ath10k_vdev_stat vdev_stat[TARGET_NUM_VDEVS];
+	u8 vdevs;
 
 	/* PEER STATS */
 	u8 peers;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 3d65594..2bf1897 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -228,13 +228,24 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
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
@@ -270,7 +281,7 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	struct ath10k *ar = file->private_data;
 	struct ath10k_target_stats *fw_stats;
 	char *buf = NULL;
-	unsigned int len = 0, buf_len = 2500;
+	unsigned int len = 0, buf_len = 3000;
 	ssize_t ret_cnt = 0;
 	long left;
 	int i;
@@ -408,6 +419,27 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
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
@@ -418,9 +450,9 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
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
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 6366600..efed5d0 100644
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
@@ -1893,12 +1898,53 @@ struct wmi_pdev_stats {
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
+	/* Total number of RTS/CTS sequence failures for transmission of a packet */
+	__le32 rts_fail_cnt;
+	/* Total number of RTS/CTS sequence success for transmission of a packet */
+	__le32 rts_succ_cnt;
+	/* The receive error count. HAL will provide the RxP FCS error global */
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
@@ -1909,6 +1955,7 @@ struct wmi_peer_stats {
 	struct wmi_mac_addr peer_macaddr;
 	__le32 peer_rssi;
 	__le32 peer_tx_rate;
+	__le32 peer_rx_rate;
 } __packed;
 
 struct wmi_vdev_create_cmd {
-- 
1.7.10

