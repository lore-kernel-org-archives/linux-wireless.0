Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbeCHLYN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 06:24:13 -0500
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [RFC] ath10k: report tx rate using ieee80211_tx_status()
Date: Thu,  8 Mar 2018 16:54:33 +0530
Message-Id: <1520508273-28739-1-git-send-email-akolli@codeaurora.org> (sfid-20180308_122417_654620_39CE1C22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh path metric needs txrate information from ieee80211_tx_status()
call but in ath10k there is no mechanism to report tx rate information
via ieee80211_tx_status(), the rate is only accessible via
sta_statiscs() op.

Per peer stats has tx rate info available, this patch stores per peer
last tx rate and updates the tx rate info structures in tx completition.
The rate updated in ieee80211_tx_status() is not exactly for the last
transmitted frame since the actual rate is available in
HTT_T2H_MSG_TYPE_PEER_STATS.

Per peer txrate information is updated through per peer statistics
and is available for QCA9888/QCA9984/QCA4019/QCA998X only

Tested on QCA9984 with firmware-5.bin_10.4-3.5.3-00053
Tested on QCA998X with firmware-5.bin_10.2.4-1.0-00036

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h   |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   97 +++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/mac.c    |   13 ----
 drivers/net/wireless/ath/ath10k/txrx.c   |   25 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.h    |    1 +
 5 files changed, 94 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fe6b30356d3b..d69f0340b487 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -346,6 +346,7 @@ struct ath10k_peer {
 
 	/* protected by ar->data_lock */
 	struct ieee80211_key_conf *keys[WMI_MAX_KEY_INDEX + 1];
+	struct ieee80211_tx_info tx_info;
 };
 
 struct ath10k_txq {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6d96f9560950..abfea326e1ad 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2427,7 +2427,7 @@ void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		dev_kfree_skb_any(skb);
 }
 
-static inline bool is_valid_legacy_rate(u8 rate)
+static inline int get_ath10k_rate_idx(u8 rate)
 {
 	static const u8 legacy_rates[] = {1, 2, 5, 11, 6, 9, 12,
 					  18, 24, 36, 48, 54};
@@ -2435,20 +2435,23 @@ static inline bool is_valid_legacy_rate(u8 rate)
 
 	for (i = 0; i < ARRAY_SIZE(legacy_rates); i++) {
 		if (rate == legacy_rates[i])
-			return true;
+			return i;
 	}
 
-	return false;
+	return -EINVAL;
 }
 
 static void
 ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 				struct ieee80211_sta *sta,
-				struct ath10k_per_peer_tx_stats *peer_stats)
+				struct ath10k_per_peer_tx_stats *peer_stats,
+				struct ath10k_peer *peer)
 {
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ieee80211_chanctx_conf *conf = NULL;
 	u8 rate = 0, sgi;
 	struct rate_info txrate;
+	bool skip_auto_rate;
 
 	lockdep_assert_held(&ar->data_lock);
 
@@ -2457,6 +2460,13 @@ static inline bool is_valid_legacy_rate(u8 rate)
 	txrate.nss = ATH10K_HW_NSS(peer_stats->ratecode);
 	txrate.mcs = ATH10K_HW_MCS_RATE(peer_stats->ratecode);
 	sgi = ATH10K_HW_GI(peer_stats->flags);
+	skip_auto_rate = ATH10K_FW_SKIPPED_RATE_CTRL(peer_stats->flags);
+
+	/* Firmware's rate control skips broadcast/managment frames, if host has
+	 * configure fixed rates and in some other special cases.
+	 */
+	if (skip_auto_rate)
+		return;
 
 	if (txrate.flags == WMI_RATE_PREAMBLE_VHT && txrate.mcs > 9) {
 		ath10k_warn(ar, "Invalid VHT mcs %hhd peer stats",  txrate.mcs);
@@ -2470,36 +2480,63 @@ static inline bool is_valid_legacy_rate(u8 rate)
 		return;
 	}
 
-	memset(&arsta->txrate, 0, sizeof(arsta->txrate));
+	memset(&peer->tx_info.status, 0, sizeof(peer->tx_info.status));
 
 	if (txrate.flags == WMI_RATE_PREAMBLE_CCK ||
 	    txrate.flags == WMI_RATE_PREAMBLE_OFDM) {
 		rate = ATH10K_HW_LEGACY_RATE(peer_stats->ratecode);
-
-		if (!is_valid_legacy_rate(rate)) {
-			ath10k_warn(ar, "Invalid legacy rate %hhd peer stats",
-				    rate);
-			return;
-		}
-
-		/* This is hacky, FW sends CCK rate 5.5Mbps as 6 */
-		rate *= 10;
-		if (rate == 60 && txrate.flags == WMI_RATE_PREAMBLE_CCK)
-			rate = rate - 5;
-		arsta->txrate.legacy = rate;
-	} else if (txrate.flags == WMI_RATE_PREAMBLE_HT) {
-		arsta->txrate.flags = RATE_INFO_FLAGS_MCS;
-		arsta->txrate.mcs = txrate.mcs + 8 * (txrate.nss - 1);
-	} else {
-		arsta->txrate.flags = RATE_INFO_FLAGS_VHT_MCS;
-		arsta->txrate.mcs = txrate.mcs;
+		txrate.legacy = get_ath10k_rate_idx(rate);
 	}
+	txrate.bw = txrate.bw + RATE_INFO_BW_20;
+	peer->tx_info.status.rates[0].count = 1;
 
-	if (sgi)
-		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
-
-	arsta->txrate.nss = txrate.nss;
-	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
+	switch (txrate.flags) {
+	case WMI_RATE_PREAMBLE_OFDM:
+		if (arsta->arvif && arsta->arvif->vif)
+			conf = rcu_dereference(arsta->arvif->vif->chanctx_conf);
+		if (conf && conf->def.chan->band == NL80211_BAND_5GHZ)
+			peer->tx_info.status.rates[0].idx = txrate.legacy - 4;
+		break;
+	case WMI_RATE_PREAMBLE_CCK:
+		peer->tx_info.status.rates[0].idx = txrate.legacy;
+		if (sgi)
+			peer->tx_info.status.rates[0].flags |=
+				(IEEE80211_TX_RC_USE_SHORT_PREAMBLE |
+				 IEEE80211_TX_RC_SHORT_GI);
+		break;
+	case WMI_RATE_PREAMBLE_HT:
+		peer->tx_info.status.rates[0].idx =
+				txrate.mcs + ((txrate.nss - 1) * 8);
+		if (sgi)
+			peer->tx_info.status.rates[0].flags |=
+					IEEE80211_TX_RC_SHORT_GI;
+		peer->tx_info.status.rates[0].flags |= IEEE80211_TX_RC_MCS;
+		break;
+	case WMI_RATE_PREAMBLE_VHT:
+		ieee80211_rate_set_vht(&peer->tx_info.status.rates[0],
+				       txrate.mcs, txrate.nss);
+		if (sgi)
+			peer->tx_info.status.rates[0].flags |=
+						IEEE80211_TX_RC_SHORT_GI;
+		peer->tx_info.status.rates[0].flags |= IEEE80211_TX_RC_VHT_MCS;
+		break;
+ 	}
+ 
+	switch (txrate.bw) {
+	case RATE_INFO_BW_40:
+		peer->tx_info.status.rates[0].flags |=
+				IEEE80211_TX_RC_40_MHZ_WIDTH;
+		break;
+	case RATE_INFO_BW_80:
+		peer->tx_info.status.rates[0].flags |=
+				IEEE80211_TX_RC_80_MHZ_WIDTH;
+		break;
+	default:
+		break;
+	}
+ 
+	if (peer_stats->succ_pkts)
+		peer->tx_info.flags = IEEE80211_TX_STAT_ACK;
 }
 
 static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
@@ -2549,7 +2586,7 @@ static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
 		p_tx_stats->retry_pkts = __le16_to_cpu(tx_stats->retry_pkts);
 		p_tx_stats->failed_pkts = __le16_to_cpu(tx_stats->failed_pkts);
 
-		ath10k_update_per_peer_tx_stats(ar, sta, p_tx_stats);
+		ath10k_update_per_peer_tx_stats(ar, sta, p_tx_stats, peer);
 	}
 
 out:
@@ -2601,7 +2638,7 @@ static void ath10k_fetch_10_2_tx_stats(struct ath10k *ar, u8 *data)
 		p_tx_stats->retry_pkts = tx_stats->retry_pkts[i];
 		p_tx_stats->failed_pkts = tx_stats->failed_pkts[i];
 
-		ath10k_update_per_peer_tx_stats(ar, sta, p_tx_stats);
+		ath10k_update_per_peer_tx_stats(ar, sta, p_tx_stats, peer);
 	}
 	spin_unlock_bh(&ar->data_lock);
 	rcu_read_unlock();
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ebb3f1b046f3..9cac14a60796 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7655,19 +7655,6 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 
 	sinfo->rx_duration = arsta->rx_duration;
 	sinfo->filled |= 1ULL << NL80211_STA_INFO_RX_DURATION;
-
-	if (!arsta->txrate.legacy && !arsta->txrate.nss)
-		return;
-
-	if (arsta->txrate.legacy) {
-		sinfo->txrate.legacy = arsta->txrate.legacy;
-	} else {
-		sinfo->txrate.mcs = arsta->txrate.mcs;
-		sinfo->txrate.nss = arsta->txrate.nss;
-		sinfo->txrate.bw = arsta->txrate.bw;
-	}
-	sinfo->txrate.flags = arsta->txrate.flags;
-	sinfo->filled |= 1ULL << NL80211_STA_INFO_TX_BITRATE;
 }
 
 static const struct ieee80211_ops ath10k_ops = {
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 70e23bbf7171..408634fa8e12 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -60,6 +60,9 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct ath10k_skb_cb *skb_cb;
 	struct ath10k_txq *artxq;
 	struct sk_buff *msdu;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_vif *vif;
+	struct ath10k_peer *peer;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx completion msdu_id %u status %d\n",
@@ -82,6 +85,7 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	skb_cb = ATH10K_SKB_CB(msdu);
 	txq = skb_cb->txq;
+	vif = skb_cb->vif;
 
 	if (txq) {
 		artxq = (void *)txq->drv_priv;
@@ -119,6 +123,27 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 			info->flags &= ~IEEE80211_TX_STAT_ACK;
 	}
 
+	spin_lock_bh(&ar->data_lock);
+	list_for_each_entry(peer, &ar->peers, list) {
+		hdr = (struct ieee80211_hdr *) msdu->data;
+
+		if (ether_addr_equal(peer->addr, vif->addr))
+			continue;
+
+		if (!ether_addr_equal(peer->addr, hdr->addr1))
+			continue;
+
+		info->status.rates[0].idx =
+			peer->tx_info.status.rates[0].idx;
+
+		info->status.rates[0].count =
+			peer->tx_info.status.rates[0].count;
+
+		info->status.rates[0].flags =
+			peer->tx_info.status.rates[0].flags;
+	}
+	spin_unlock_bh(&ar->data_lock);
+
 	ieee80211_tx_status(htt->ar->hw, msdu);
 	/* we do not own the msdu anymore */
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c7b30ed9015d..1bea1a2c3157 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4819,6 +4819,7 @@ enum wmi_rate_preamble {
 #define ATH10K_HW_GI(flags)		(((flags) >> 5) & 0x1)
 #define ATH10K_HW_RATECODE(rate, nss, preamble) \
 	(((preamble) << 6) | ((nss) << 4) | (rate))
+#define ATH10K_FW_SKIPPED_RATE_CTRL(flags)	(((flags) >> 6) & 0x1)
 
 #define VHT_MCS_NUM     10
 #define VHT_BW_NUM      4
-- 
1.7.9.5
