Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4345 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933204AbcJRJaM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 05:30:12 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: add per peer htt tx stats support for 10.4
Date: Tue, 18 Oct 2016 14:59:41 +0530
Message-ID: <1476782982-10683-2-git-send-email-akolli@qti.qualcomm.com> (sfid-20161018_113023_245365_0D0D1A49)
In-Reply-To: <1476782982-10683-1-git-send-email-akolli@qti.qualcomm.com>
References: <1476782982-10683-1-git-send-email-akolli@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
event, Firmware sends one HTT event for every four PPDUs.
HTT payload has success pkts/bytes, failed pkts/bytes, retry
pkts/bytes and rate info per ppdu.
Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
which are nowadays enabled by default.

Parse peer stats and update the tx rate information per STA.

tx rate, Peer stats are tested on QCA4019 with Firmware version
10.4-3.2.1-00028.

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
v2:
 * address Kalle's comments 
 * fix compilation warnings

 drivers/net/wireless/ath/ath10k/core.h   |   17 ++++
 drivers/net/wireless/ath/ath10k/htt.c    |    2 +
 drivers/net/wireless/ath/ath10k/htt.h    |   25 ++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  125 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h    |   10 ++-
 5 files changed, 178 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index dda49af1eb74..fc3d3bded265 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -337,6 +337,7 @@ struct ath10k_sta {
 	u32 nss;
 	u32 smps;
 	u16 peer_id;
+	struct rate_info txrate;
 
 	struct work_struct update_wk;
 
@@ -694,6 +695,21 @@ struct ath10k_fw_components {
 	struct ath10k_fw_file fw_file;
 };
 
+struct ath10k_per_peer_tx_stats {
+	u32	succ_bytes;
+	u32	retry_bytes;
+	u32	failed_bytes;
+	u8	ratecode;
+	u8	flags;
+	u16	peer_id;
+	u16	succ_pkts;
+	u16	retry_pkts;
+	u16	failed_pkts;
+	u16	duration;
+	u32	reserved1;
+	u32	reserved2;
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -906,6 +922,7 @@ struct ath10k {
 
 	struct ath10k_thermal thermal;
 	struct ath10k_wow wow;
+	struct ath10k_per_peer_tx_stats peer_tx_stats;
 
 	/* NAPI */
 	struct net_device napi_dev;
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 130cd9502021..cd160b16db1e 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -137,6 +137,8 @@ static const enum htt_t2h_msg_type htt_10_4_t2h_msg_types[] = {
 				HTT_T2H_MSG_TYPE_STATS_NOUPLOAD,
 	[HTT_10_4_T2H_MSG_TYPE_TX_MODE_SWITCH_IND] =
 				HTT_T2H_MSG_TYPE_TX_MODE_SWITCH_IND,
+	[HTT_10_4_T2H_MSG_TYPE_PEER_STATS] =
+				HTT_T2H_MSG_TYPE_PEER_STATS,
 };
 
 int ath10k_htt_connect(struct ath10k_htt *htt)
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 0d2ed09f202b..164eb3a10566 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -419,6 +419,7 @@ enum htt_10_4_t2h_msg_type {
 	HTT_10_4_T2H_MSG_TYPE_STATS_NOUPLOAD         = 0x18,
 	/* 0x19 to 0x2f are reserved */
 	HTT_10_4_T2H_MSG_TYPE_TX_MODE_SWITCH_IND     = 0x30,
+	HTT_10_4_T2H_MSG_TYPE_PEER_STATS	     = 0x31,
 	/* keep this last */
 	HTT_10_4_T2H_NUM_MSGS
 };
@@ -453,6 +454,7 @@ enum htt_t2h_msg_type {
 	HTT_T2H_MSG_TYPE_TX_FETCH_IND,
 	HTT_T2H_MSG_TYPE_TX_FETCH_CONFIRM,
 	HTT_T2H_MSG_TYPE_TX_MODE_SWITCH_IND,
+	HTT_T2H_MSG_TYPE_PEER_STATS,
 	/* keep this last */
 	HTT_T2H_NUM_MSGS
 };
@@ -1470,6 +1472,28 @@ struct htt_channel_change {
 	__le32 phymode;
 } __packed;
 
+struct htt_per_peer_tx_stats_ind {
+	__le32	succ_bytes;
+	__le32  retry_bytes;
+	__le32  failed_bytes;
+	u8	ratecode;
+	u8	flags;
+	__le16	peer_id;
+	__le16  succ_pkts;
+	__le16	retry_pkts;
+	__le16	failed_pkts;
+	__le16	tx_duration;
+	__le32	reserved1;
+	__le32	reserved2;
+} __packed;
+
+struct htt_peer_tx_stats {
+	u8 num_ppdu;
+	u8 ppdu_len;
+	u8 version;
+	u8 payload[0];
+} __packed;
+
 union htt_rx_pn_t {
 	/* WEP: 24-bit PN */
 	u32 pn24;
@@ -1521,6 +1545,7 @@ struct htt_resp {
 		struct htt_tx_fetch_confirm tx_fetch_confirm;
 		struct htt_tx_mode_switch_ind tx_mode_switch_ind;
 		struct htt_channel_change chan_change;
+		struct htt_peer_tx_stats peer_tx_stats;
 	};
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 0b4c1562420f..ef28b358cf5e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2194,6 +2194,128 @@ void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 }
 
+static inline bool is_valid_legacy_rate(u8 rate)
+{
+	static const u8 legacy_rates[] = {1, 2, 5, 11, 6, 9, 12,
+					  18, 24, 36, 48, 54};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(legacy_rates); i++) {
+		if (rate == legacy_rates[i])
+			return true;
+	}
+
+	return false;
+}
+
+static void
+ath10k_update_per_peer_tx_stats(struct ath10k *ar,
+				struct ieee80211_sta *sta,
+				struct ath10k_per_peer_tx_stats *peer_stats)
+{
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	u8 rate = 0, sgi;
+	struct rate_info txrate;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	txrate.flags = ATH10K_HW_PREAMBLE(peer_stats->ratecode);
+	txrate.bw = ATH10K_HW_BW(peer_stats->flags);
+	txrate.nss = ATH10K_HW_NSS(peer_stats->ratecode);
+	txrate.mcs = ATH10K_HW_MCS_RATE(peer_stats->ratecode);
+	sgi = ATH10K_HW_GI(peer_stats->flags);
+
+	if (((txrate.flags == WMI_RATE_PREAMBLE_HT) ||
+	     (txrate.flags == WMI_RATE_PREAMBLE_VHT)) && txrate.mcs > 9) {
+		ath10k_warn(ar, "Invalid mcs %hhd peer stats", txrate.mcs);
+		return;
+	}
+
+	if (txrate.flags == WMI_RATE_PREAMBLE_CCK ||
+	    txrate.flags == WMI_RATE_PREAMBLE_OFDM) {
+		rate = ATH10K_HW_LEGACY_RATE(peer_stats->ratecode);
+
+		if (!is_valid_legacy_rate(rate)) {
+			ath10k_warn(ar, "Invalid legacy rate %hhd peer stats",
+				    rate);
+			return;
+		}
+
+		/* This is hacky, FW sends CCK rate 5.5Mbps as 6 */
+		rate *= 10;
+		if (rate == 60 && txrate.flags == WMI_RATE_PREAMBLE_CCK)
+			rate = rate - 5;
+		arsta->txrate.legacy = rate * 10;
+	} else if (txrate.flags == WMI_RATE_PREAMBLE_HT) {
+		arsta->txrate.flags = RATE_INFO_FLAGS_MCS;
+		arsta->txrate.mcs = txrate.mcs;
+	} else {
+		arsta->txrate.flags = RATE_INFO_FLAGS_VHT_MCS;
+		arsta->txrate.mcs = txrate.mcs;
+	}
+
+	if (sgi)
+		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+
+	arsta->txrate.nss = txrate.nss;
+	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
+}
+
+static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
+					struct sk_buff *skb)
+{
+	struct htt_resp *resp = (struct htt_resp *)skb->data;
+	struct ath10k_per_peer_tx_stats *p_tx_stats = &ar->peer_tx_stats;
+	struct htt_per_peer_tx_stats_ind *tx_stats;
+	struct ieee80211_sta *sta;
+	struct ath10k_peer *peer;
+	int peer_id, i;
+	u8 ppdu_len, num_ppdu;
+
+	num_ppdu = resp->peer_tx_stats.num_ppdu;
+	ppdu_len = resp->peer_tx_stats.ppdu_len * sizeof(__le32);
+
+	if (skb->len < sizeof(struct htt_resp_hdr) + num_ppdu * ppdu_len) {
+		ath10k_warn(ar, "Invalid peer stats buf length %d\n", skb->len);
+		return;
+	}
+
+	tx_stats = (struct htt_per_peer_tx_stats_ind *)
+			(resp->peer_tx_stats.payload);
+	peer_id = tx_stats->peer_id;
+
+	rcu_read_lock();
+	spin_lock_bh(&ar->data_lock);
+	peer = ath10k_peer_find_by_id(ar, peer_id);
+	if (!peer) {
+		ath10k_warn(ar, "Invalid peer id %d peer stats buffer\n",
+			    peer_id);
+		goto out;
+	}
+
+	sta = peer->sta;
+	for (i = 0; i < num_ppdu; i++) {
+		tx_stats = (struct htt_per_peer_tx_stats_ind *)
+			   (resp->peer_tx_stats.payload + i * ppdu_len);
+
+		p_tx_stats->succ_bytes = __le32_to_cpu(tx_stats->succ_bytes);
+		p_tx_stats->retry_bytes = __le32_to_cpu(tx_stats->retry_bytes);
+		p_tx_stats->failed_bytes =
+				__le32_to_cpu(tx_stats->failed_bytes);
+		p_tx_stats->ratecode = tx_stats->ratecode;
+		p_tx_stats->flags = tx_stats->flags;
+		p_tx_stats->succ_pkts = __le16_to_cpu(tx_stats->succ_pkts);
+		p_tx_stats->retry_pkts = __le16_to_cpu(tx_stats->retry_pkts);
+		p_tx_stats->failed_pkts = __le16_to_cpu(tx_stats->failed_pkts);
+
+		ath10k_update_per_peer_tx_stats(ar, sta, p_tx_stats);
+	}
+
+out:
+	spin_unlock_bh(&ar->data_lock);
+	rcu_read_unlock();
+}
+
 bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
@@ -2354,6 +2476,9 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	case HTT_T2H_MSG_TYPE_TX_MODE_SWITCH_IND:
 		ath10k_htt_rx_tx_mode_switch_ind(ar, skb);
 		break;
+	case HTT_T2H_MSG_TYPE_PEER_STATS:
+		ath10k_htt_fetch_peer_stats(ar, skb);
+		break;
 	case HTT_T2H_MSG_TYPE_EN_STATS:
 	default:
 		ath10k_warn(ar, "htt event (%d) not handled\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1b243c899bef..e108d49998c3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4603,9 +4603,17 @@ enum wmi_rate_preamble {
 
 #define ATH10K_HW_NSS(rate)		(1 + (((rate) >> 4) & 0x3))
 #define ATH10K_HW_PREAMBLE(rate)	(((rate) >> 6) & 0x3)
-#define ATH10K_HW_RATECODE(rate, nss, preamble)	\
+#define ATH10K_HW_MCS_RATE(rate)	((rate) & 0xf)
+#define ATH10K_HW_LEGACY_RATE(rate)	((rate) & 0x3f)
+#define ATH10K_HW_BW(flags)		(((flags) >> 3) & 0x3)
+#define ATH10K_HW_GI(flags)		(((flags) >> 5) & 0x1)
+#define ATH10K_HW_RATECODE(rate, nss, preamble) \
 	(((preamble) << 6) | ((nss) << 4) | (rate))
 
+#define VHT_MCS_NUM     10
+#define VHT_BW_NUM      4
+#define VHT_NSS_NUM     4
+
 /* Value to disable fixed rate setting */
 #define WMI_FIXED_RATE_NONE    (0xff)
 
-- 
1.7.9.5
