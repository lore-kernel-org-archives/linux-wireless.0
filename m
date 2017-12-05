Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:15923 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753106AbdLENbc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 08:31:32 -0500
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCHv2 3/3] ath10k: add per peer tx stats support for 10.2.4
Date: Tue, 5 Dec 2017 19:01:25 +0530
Message-ID: <1512480685-28471-4-git-send-email-akolli@qti.qualcomm.com> (sfid-20171205_143145_689993_BB44260A)
In-Reply-To: <1512480685-28471-1-git-send-email-akolli@qti.qualcomm.com>
References: <1512480685-28471-1-git-send-email-akolli@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

10.2.4 firmware branch (used in QCA988X) does not support
HTT_10_4_T2H_MSG_TYPE_PEER_STATS and that's why ath10k does not provide
tranmission rate statistics to user space, instead it just shows
hardcoded 6 Mbit/s. But pktlog firmware facility provides per peer tx
statistics. The firmware sends one pktlog event for every four
PPDUs per peer, which include:

* successful number of packets and bytes transmitted
* number of packets and bytes dropped
* retried number of packets and bytes
* rate info per ppdu

Firmware supports WMI_SERVICE_PEER_STATS, pktlog is enabled through
ATH10K_FLAG_PEER_STATS, which is nowadays enabled by default in ath10k.

This patch does not impact throughput.

Tested on QCA9880 with firmware version 10.2.4.70.48. This should also
work with firmware branch 10.2.4-1.0-00029

Parse peer stats from pktlog packets and update the tx rate information
per STA. This way user space can query about transmit rate with iw:

$iw wlan0 station dump
Station 3c:a9:f4:72:bb:a4 (on wlan1)
        inactive time:  8210 ms
        rx bytes:       9166
        rx packets:     44
        tx bytes:       1105
        tx packets:     9
        tx retries:     0
        tx failed:      1
        rx drop misc:   3
        signal:         -75 [-75, -87, -88] dBm
        signal avg:     -75 [-75, -85, -88] dBm
        tx bitrate:     39.0 MBit/s MCS 10
        rx bitrate:     26.0 MBit/s MCS 3
        rx duration:    23250 us
        authorized:     yes
        authenticated:  yes
        associated:     yes
        preamble:       short
        WMM/WME:        yes
        MFP:            no
        TDLS peer:      no
        DTIM period:    2
        beacon interval:100
        short preamble: yes
        short slot time:yes
        connected time: 22 seconds

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.h  |   18 ++++++++-
 drivers/net/wireless/ath/ath10k/htt.h    |   17 +++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   60 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c    |   10 +++++
 4 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index dd82a61ed1c8..5e662994c49a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -51,7 +51,8 @@ enum ath10k_pktlog_filter {
 	ATH10K_PKTLOG_RCFIND     = 0x000000004,
 	ATH10K_PKTLOG_RCUPDATE   = 0x000000008,
 	ATH10K_PKTLOG_DBG_PRINT  = 0x000000010,
-	ATH10K_PKTLOG_ANY        = 0x00000001f,
+	ATH10K_PKTLOG_PEER_STATS = 0x000000040,
+	ATH10K_PKTLOG_ANY        = 0x00000005f,
 };
 
 enum ath10k_dbg_aggr_mode {
@@ -60,6 +61,21 @@ enum ath10k_dbg_aggr_mode {
 	ATH10K_DBG_AGGR_MODE_MAX,
 };
 
+/* Types of packet log events */
+enum ath_pktlog_type {
+	ATH_PKTLOG_TYPE_TX_CTRL = 1,
+	ATH_PKTLOG_TYPE_TX_STAT,
+};
+
+struct ath10k_pktlog_hdr {
+	__le16 flags;
+	__le16 missed_cnt;
+	__le16 log_type; /* Type of log information foll this header */
+	__le16 size; /* Size of variable length log information in bytes */
+	__le32 timestamp;
+	u8 payload[0];
+} __packed;
+
 /* FIXME: How to calculate the buffer size sanely? */
 #define ATH10K_FW_STATS_BUF_SIZE (1024 * 1024)
 
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 6305308422c4..89db96afea17 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1497,6 +1497,23 @@ struct htt_peer_tx_stats {
 	u8 payload[0];
 } __packed;
 
+#define ATH10K_10_2_TX_STATS_OFFSET	136
+#define PEER_STATS_FOR_NO_OF_PPDUS	4
+
+struct ath10k_10_2_peer_tx_stats {
+	u8 ratecode[PEER_STATS_FOR_NO_OF_PPDUS];
+	u8 success_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
+	__le16 success_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
+	u8 retry_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
+	__le16 retry_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
+	u8 failed_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
+	__le16 failed_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
+	u8 flags[PEER_STATS_FOR_NO_OF_PPDUS];
+	__le32 tx_duration;
+	u8 tx_ppdu_cnt;
+	u8 peer_id;
+} __packed;
+
 union htt_rx_pn_t {
 	/* WEP: 24-bit PN */
 	u32 pn24;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7d295ee71534..50670d651cff 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2449,6 +2449,62 @@ static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
 	rcu_read_unlock();
 }
 
+static void ath10k_fetch_10_2_tx_stats(struct ath10k *ar, u8 *data)
+{
+	struct ath10k_pktlog_hdr *hdr = (struct ath10k_pktlog_hdr *)data;
+	struct ath10k_per_peer_tx_stats *p_tx_stats = &ar->peer_tx_stats;
+	struct ath10k_10_2_peer_tx_stats *tx_stats;
+	struct ieee80211_sta *sta;
+	struct ath10k_peer *peer;
+	u16 log_type = __le16_to_cpu(hdr->log_type);
+	u32 peer_id = 0, i;
+
+	if (log_type != ATH_PKTLOG_TYPE_TX_STAT)
+		return;
+
+	tx_stats = (struct ath10k_10_2_peer_tx_stats *)((hdr->payload) +
+		    ATH10K_10_2_TX_STATS_OFFSET);
+
+	if (!tx_stats->tx_ppdu_cnt)
+		return;
+
+	peer_id = tx_stats->peer_id;
+
+	rcu_read_lock();
+	spin_lock_bh(&ar->data_lock);
+	peer = ath10k_peer_find_by_id(ar, peer_id);
+	if (!peer) {
+		ath10k_warn(ar, "Invalid peer id %d in peer stats buffer\n",
+			    peer_id);
+		goto out;
+	}
+
+	sta = peer->sta;
+	for (i = 0; i < tx_stats->tx_ppdu_cnt; i++) {
+		p_tx_stats->succ_bytes =
+			__le16_to_cpu(tx_stats->success_bytes[i]);
+		p_tx_stats->retry_bytes =
+			__le16_to_cpu(tx_stats->retry_bytes[i]);
+		p_tx_stats->failed_bytes =
+			__le16_to_cpu(tx_stats->failed_bytes[i]);
+		p_tx_stats->ratecode = tx_stats->ratecode[i];
+		p_tx_stats->flags = tx_stats->flags[i];
+		p_tx_stats->succ_pkts = tx_stats->success_pkts[i];
+		p_tx_stats->retry_pkts = tx_stats->retry_pkts[i];
+		p_tx_stats->failed_pkts = tx_stats->failed_pkts[i];
+
+		ath10k_update_per_peer_tx_stats(ar, sta, p_tx_stats);
+	}
+	spin_unlock_bh(&ar->data_lock);
+	rcu_read_unlock();
+
+	return;
+
+out:
+	spin_unlock_bh(&ar->data_lock);
+	rcu_read_unlock();
+}
+
 bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
@@ -2566,6 +2622,10 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 					skb->len -
 					offsetof(struct htt_resp,
 						 pktlog_msg.payload));
+
+		if (ath10k_peer_stats_enabled(ar))
+			ath10k_fetch_10_2_tx_stats(ar,
+						   resp->pktlog_msg.payload);
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_RX_FLUSH: {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 884543026f3a..7b4a1d21c187 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7546,6 +7546,16 @@ struct ath10k_mac_change_chanctx_arg {
 				    arvif->vdev_id, ret);
 	}
 
+	if (ath10k_peer_stats_enabled(ar)) {
+		ar->pktlog_filter |= ATH10K_PKTLOG_PEER_STATS;
+		ret = ath10k_wmi_pdev_pktlog_enable(ar,
+						    ar->pktlog_filter);
+		if (ret) {
+			ath10k_warn(ar, "failed to enable pktlog %d\n", ret);
+			goto err_stop;
+		}
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 
-- 
1.7.9.5
