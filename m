Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeHFPWC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 11:22:02 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] ath10k: add extended per sta tx statistics support
Date: Mon,  6 Aug 2018 18:43:42 +0530
Message-Id: <1533561223-342-4-git-send-email-akolli@codeaurora.org> (sfid-20180806_151301_689681_AE6C09F0)
In-Reply-To: <1533561223-342-1-git-send-email-akolli@codeaurora.org>
References: <1533561223-342-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds per station tx statistics support.

Per station tx stats include
 - pkts/bytes transmitted at all possible rates(mcs/nss/bw/gi).
 - ACK fails count
 - ampdu bytes/pkts transmitted at all possible rates(mcs/nss/bw/gi).
 - BA fails count

Tested on QCA9984/QCA4019/QCA988x
Firmware: 10.4-3.5.3-00057
	  10.2.4-1.0-00037

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h   |   31 +++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  109 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c    |    7 ++
 drivers/net/wireless/ath/ath10k/wmi.h    |   13 ++--
 4 files changed, 156 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b5f6940bb102..ee852e690382 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -461,6 +461,36 @@ struct ath10k_sta_tid_stats {
 	unsigned long int rx_pkt_amsdu[ATH10K_AMSDU_SUBFRM_NUM_MAX];
 };
 
+enum ath10k_counter_type {
+	ATH10K_COUNTER_TYPE_BYTES,
+	ATH10K_COUNTER_TYPE_PKTS,
+	ATH10K_COUNTER_TYPE_MAX,
+};
+
+enum ath10k_stats_type {
+	ATH10K_STATS_TYPE_SUCC,
+	ATH10K_STATS_TYPE_FAIL,
+	ATH10K_STATS_TYPE_RETRY,
+	ATH10K_STATS_TYPE_AMPDU,
+	ATH10K_STATS_TYPE_MAX,
+};
+
+struct ath10k_htt_data_stats {
+	u64 legacy[ATH10K_COUNTER_TYPE_MAX][NUM_LEGACY];
+	u64 ht[ATH10K_COUNTER_TYPE_MAX][NUM_HT_MCS];
+	u64 vht[ATH10K_COUNTER_TYPE_MAX][NUM_VHT_MCS];
+	u64 bw[ATH10K_COUNTER_TYPE_MAX][NUM_BW];
+	u64 nss[ATH10K_COUNTER_TYPE_MAX][NUM_NSS];
+	u64 gi[ATH10K_COUNTER_TYPE_MAX][NUM_GI];
+};
+
+struct ath10k_htt_tx_stats {
+	struct ath10k_htt_data_stats stats[ATH10K_STATS_TYPE_MAX];
+	u64 tx_duration;
+	u64 ba_fails;
+	u64 ack_fails;
+};
+
 struct ath10k_sta {
 	struct ath10k_vif *arvif;
 
@@ -474,6 +504,7 @@ struct ath10k_sta {
 
 	struct work_struct update_wk;
 	u64 rx_duration;
+	struct ath10k_htt_tx_stats *tx_stats;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* protected by conf_mutex */
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 01eb4a7f4a69..d634d08a0ea0 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2504,6 +2504,111 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 }
 
 static void
+ath10k_accumulate_per_peer_tx_stats(struct ath10k *ar,
+				    struct ath10k_sta *arsta,
+				    struct ath10k_per_peer_tx_stats *pstats,
+				    u8 legacy_rate_idx)
+{
+	struct rate_info *txrate = &arsta->txrate;
+	struct ath10k_htt_tx_stats *tx_stats;
+	int ht_idx, gi, mcs, bw, nss;
+
+	if (!arsta->tx_stats)
+		return;
+
+	tx_stats = arsta->tx_stats;
+	gi = (arsta->txrate.flags & RATE_INFO_FLAGS_SHORT_GI);
+	ht_idx = txrate->mcs + txrate->nss * 8;
+	mcs = txrate->mcs;
+	bw = txrate->bw;
+	nss = txrate->nss;
+
+#define STATS_OP_FMT(name) tx_stats->stats[ATH10K_STATS_TYPE_##name]
+
+	if (txrate->flags == RATE_INFO_FLAGS_VHT_MCS) {
+		STATS_OP_FMT(SUCC).vht[0][mcs] += pstats->succ_bytes;
+		STATS_OP_FMT(SUCC).vht[1][mcs] += pstats->succ_pkts;
+		STATS_OP_FMT(FAIL).vht[0][mcs] += pstats->failed_bytes;
+		STATS_OP_FMT(FAIL).vht[1][mcs] += pstats->failed_pkts;
+		STATS_OP_FMT(RETRY).vht[0][mcs] += pstats->retry_bytes;
+		STATS_OP_FMT(RETRY).vht[1][mcs] += pstats->retry_pkts;
+	} else if (txrate->flags == RATE_INFO_FLAGS_MCS) {
+		STATS_OP_FMT(SUCC).ht[0][ht_idx] += pstats->succ_bytes;
+		STATS_OP_FMT(SUCC).ht[1][ht_idx] += pstats->succ_pkts;
+		STATS_OP_FMT(FAIL).ht[0][ht_idx] += pstats->failed_bytes;
+		STATS_OP_FMT(FAIL).ht[1][ht_idx] += pstats->failed_pkts;
+		STATS_OP_FMT(RETRY).ht[0][ht_idx] += pstats->retry_bytes;
+		STATS_OP_FMT(RETRY).ht[1][ht_idx] += pstats->retry_pkts;
+	} else {
+		mcs = legacy_rate_idx;
+		if (mcs < 0)
+			return;
+
+		STATS_OP_FMT(SUCC).legacy[0][mcs] += pstats->succ_bytes;
+		STATS_OP_FMT(SUCC).legacy[1][mcs] += pstats->succ_pkts;
+		STATS_OP_FMT(FAIL).legacy[0][mcs] += pstats->failed_bytes;
+		STATS_OP_FMT(FAIL).legacy[1][mcs] += pstats->failed_pkts;
+		STATS_OP_FMT(RETRY).legacy[0][mcs] += pstats->retry_bytes;
+		STATS_OP_FMT(RETRY).legacy[1][mcs] += pstats->retry_pkts;
+	}
+
+	if (ATH10K_HW_AMPDU(pstats->flags)) {
+		tx_stats->ba_fails += ATH10K_HW_BA_FAIL(pstats->flags);
+
+		if (txrate->flags == RATE_INFO_FLAGS_MCS) {
+			STATS_OP_FMT(AMPDU).ht[0][ht_idx] +=
+				pstats->succ_bytes + pstats->retry_bytes;
+			STATS_OP_FMT(AMPDU).ht[1][ht_idx] +=
+				pstats->succ_pkts + pstats->retry_pkts;
+		} else {
+			STATS_OP_FMT(AMPDU).vht[0][mcs] +=
+				pstats->succ_bytes + pstats->retry_bytes;
+			STATS_OP_FMT(AMPDU).vht[1][mcs] +=
+				pstats->succ_pkts + pstats->retry_pkts;
+		}
+		STATS_OP_FMT(AMPDU).bw[0][bw] +=
+			pstats->succ_bytes + pstats->retry_bytes;
+		STATS_OP_FMT(AMPDU).nss[0][nss] +=
+			pstats->succ_bytes + pstats->retry_bytes;
+		STATS_OP_FMT(AMPDU).gi[0][gi] +=
+			pstats->succ_bytes + pstats->retry_bytes;
+		STATS_OP_FMT(AMPDU).bw[1][bw] +=
+			pstats->succ_pkts + pstats->retry_pkts;
+		STATS_OP_FMT(AMPDU).nss[1][nss] +=
+			pstats->succ_pkts + pstats->retry_pkts;
+		STATS_OP_FMT(AMPDU).gi[1][gi] +=
+			pstats->succ_pkts + pstats->retry_pkts;
+	} else {
+		tx_stats->ack_fails +=
+				ATH10K_HW_BA_FAIL(pstats->flags);
+	}
+
+	STATS_OP_FMT(SUCC).bw[0][bw] += pstats->succ_bytes;
+	STATS_OP_FMT(SUCC).nss[0][nss] += pstats->succ_bytes;
+	STATS_OP_FMT(SUCC).gi[0][gi] += pstats->succ_bytes;
+
+	STATS_OP_FMT(SUCC).bw[1][bw] += pstats->succ_pkts;
+	STATS_OP_FMT(SUCC).nss[1][nss] += pstats->succ_pkts;
+	STATS_OP_FMT(SUCC).gi[1][gi] += pstats->succ_pkts;
+
+	STATS_OP_FMT(FAIL).bw[0][bw] += pstats->failed_bytes;
+	STATS_OP_FMT(FAIL).nss[0][nss] += pstats->failed_bytes;
+	STATS_OP_FMT(FAIL).gi[0][gi] += pstats->failed_bytes;
+
+	STATS_OP_FMT(FAIL).bw[1][bw] += pstats->failed_pkts;
+	STATS_OP_FMT(FAIL).nss[1][nss] += pstats->failed_pkts;
+	STATS_OP_FMT(FAIL).gi[1][gi] += pstats->failed_pkts;
+
+	STATS_OP_FMT(RETRY).bw[0][bw] += pstats->retry_bytes;
+	STATS_OP_FMT(RETRY).nss[0][nss] += pstats->retry_bytes;
+	STATS_OP_FMT(RETRY).gi[0][gi] += pstats->retry_bytes;
+
+	STATS_OP_FMT(RETRY).bw[1][bw] += pstats->retry_pkts;
+	STATS_OP_FMT(RETRY).nss[1][nss] += pstats->retry_pkts;
+	STATS_OP_FMT(RETRY).gi[1][gi] += pstats->retry_pkts;
+}
+
+static void
 ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 				struct ieee80211_sta *sta,
 				struct ath10k_per_peer_tx_stats *peer_stats)
@@ -2557,6 +2662,10 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 
 	arsta->txrate.nss = txrate.nss;
 	arsta->txrate.bw = ath10k_bw_to_mac80211_bw(txrate.bw);
+
+	if (ar->debug.enable_extd_tx_stats)
+		ath10k_accumulate_per_peer_tx_stats(ar, arsta, peer_stats,
+						    rate_idx);
 }
 
 static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 90f9372dec25..fd42b32ead0b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6243,6 +6243,10 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   ar->num_stations + 1, ar->max_num_stations,
 			   ar->num_peers + 1, ar->max_num_peers);
 
+		arsta->tx_stats = kzalloc(sizeof(*arsta->tx_stats), GFP_KERNEL);
+		if (!arsta->tx_stats)
+			goto exit;
+
 		num_tdls_stations = ath10k_mac_tdls_vif_stations_count(hw, vif);
 		num_tdls_vifs = ath10k_mac_tdls_vifs_count(hw);
 
@@ -6328,6 +6332,9 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   "mac vdev %d peer delete %pM sta %pK (sta gone)\n",
 			   arvif->vdev_id, sta->addr, sta);
 
+		if (ar->debug.enable_extd_tx_stats)
+			kfree(arsta->tx_stats);
+
 		if (sta->tdls) {
 			ret = ath10k_mac_tdls_peer_update(ar, arvif->vdev_id,
 							  sta,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 36220258e3c7..d057837ffadf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4958,10 +4958,15 @@ enum wmi_rate_preamble {
 #define ATH10K_HW_GI(flags)		(((flags) >> 5) & 0x1)
 #define ATH10K_HW_RATECODE(rate, nss, preamble) \
 	(((preamble) << 6) | ((nss) << 4) | (rate))
-
-#define VHT_MCS_NUM     10
-#define VHT_BW_NUM      4
-#define VHT_NSS_NUM     4
+#define ATH10K_HW_AMPDU(flags)		(flags & 0x1)
+#define ATH10K_HW_BA_FAIL(flags)	(((flags) >> 1) & 0x3)
+
+#define NUM_VHT_MCS	10
+#define NUM_BW		4
+#define NUM_NSS	4
+#define NUM_LEGACY	12
+#define NUM_GI		2
+#define NUM_HT_MCS	32
 
 /* Value to disable fixed rate setting */
 #define WMI_FIXED_RATE_NONE    (0xff)
-- 
1.7.9.5
