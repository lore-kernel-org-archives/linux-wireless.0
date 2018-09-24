Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58350 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbeIXNIW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 09:08:22 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [RFC v4 2/2] ath10k: report tx rate using ieee80211_tx_rate_update()
Date: Mon, 24 Sep 2018 12:40:00 +0530
Message-Id: <1537773000-2587-3-git-send-email-akolli@codeaurora.org> (sfid-20180924_090804_631975_9A1872D1)
In-Reply-To: <1537773000-2587-1-git-send-email-akolli@codeaurora.org>
References: <1537773000-2587-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh path metric needs tx rate information from ieee80211_tx_status()
call but in ath10k there is no mechanism to report tx rate information
via ieee80211_tx_status(), the tx rate is only accessible via
sta_statiscs() op.

Per peer tx stats has tx rate info available, Tx rate is available
to ath10k driver after every 4 PPDU sent in the air. For each PPDU,
ath10k driver updates rate informattion to mac80211 using
ieee80211_tx_rate_update().

Per peer txrate information is updated through per peer statistics
and is available for QCA9888/QCA9984/QCA4019/QCA998X only

Tested on QCA9984 with firmware-5.bin_10.4-3.5.3-00053
Tested on QCA998X with firmware-5.bin_10.2.4-1.0-00036

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
V3:
  - added new API to update tx rate alone.
  - Tx rate is updated for each PPDUs sent

 drivers/net/wireless/ath/ath10k/core.h   |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   66 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h    |    1 +
 3 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f6e5c29f74e7..abeed6cdc4ae 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -493,6 +493,7 @@ struct ath10k_sta {
 	u32 smps;
 	u16 peer_id;
 	struct rate_info txrate;
+	struct ieee80211_tx_info tx_info;
 
 	struct work_struct update_wk;
 	u64 rx_duration;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f2405258a6d3..355c39a0486c 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2753,8 +2753,11 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 				struct ath10k_per_peer_tx_stats *peer_stats)
 {
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
-	u8 rate = 0, rate_idx = 0, sgi;
+	struct ieee80211_chanctx_conf *conf = NULL;
 	struct rate_info txrate;
+	u8 rate = 0, sgi;
+	int rate_idx = 0;
+	bool skip_auto_rate;
 
 	lockdep_assert_held(&ar->data_lock);
 
@@ -2763,6 +2766,13 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	txrate.nss = ATH10K_HW_NSS(peer_stats->ratecode);
 	txrate.mcs = ATH10K_HW_MCS_RATE(peer_stats->ratecode);
 	sgi = ATH10K_HW_GI(peer_stats->flags);
+	skip_auto_rate = ATH10K_FW_SKIPPED_RATE_CTRL(peer_stats->flags);
+
+	/* Firmware's rate control skips broadcast/management frames,
+	 * if host has configure fixed rates and in some other special cases.
+	 */
+	if (skip_auto_rate)
+		return;
 
 	if (txrate.flags == WMI_RATE_PREAMBLE_VHT && txrate.mcs > 9) {
 		ath10k_warn(ar, "Invalid VHT mcs %hhd peer stats",  txrate.mcs);
@@ -2777,7 +2787,7 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	}
 
 	memset(&arsta->txrate, 0, sizeof(arsta->txrate));
-
+	memset(&arsta->tx_info.status, 0, sizeof(arsta->tx_info.status));
 	if (txrate.flags == WMI_RATE_PREAMBLE_CCK ||
 	    txrate.flags == WMI_RATE_PREAMBLE_OFDM) {
 		rate = ATH10K_HW_LEGACY_RATE(peer_stats->ratecode);
@@ -2796,11 +2806,59 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 		arsta->txrate.mcs = txrate.mcs;
 	}
 
-	if (sgi)
-		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+	switch (txrate.flags) {
+	case WMI_RATE_PREAMBLE_OFDM:
+		if (arsta->arvif && arsta->arvif->vif)
+			conf = rcu_dereference(arsta->arvif->vif->chanctx_conf);
+		if (conf && conf->def.chan->band == NL80211_BAND_5GHZ)
+			arsta->tx_info.status.rates[0].idx = rate_idx - 4;
+		break;
+	case WMI_RATE_PREAMBLE_CCK:
+		arsta->tx_info.status.rates[0].idx = rate_idx;
+		if (sgi)
+			arsta->tx_info.status.rates[0].flags |=
+				(IEEE80211_TX_RC_USE_SHORT_PREAMBLE |
+				 IEEE80211_TX_RC_SHORT_GI);
+		break;
+	case WMI_RATE_PREAMBLE_HT:
+		arsta->tx_info.status.rates[0].idx =
+				txrate.mcs + ((txrate.nss - 1) * 8);
+		if (sgi)
+			arsta->tx_info.status.rates[0].flags |=
+					IEEE80211_TX_RC_SHORT_GI;
+		arsta->tx_info.status.rates[0].flags |= IEEE80211_TX_RC_MCS;
+		break;
+	case WMI_RATE_PREAMBLE_VHT:
+		ieee80211_rate_set_vht(&arsta->tx_info.status.rates[0],
+				       txrate.mcs, txrate.nss);
+		if (sgi)
+			arsta->tx_info.status.rates[0].flags |=
+						IEEE80211_TX_RC_SHORT_GI;
+		arsta->tx_info.status.rates[0].flags |= IEEE80211_TX_RC_VHT_MCS;
+		break;
+	}
 
 	arsta->txrate.nss = txrate.nss;
 	arsta->txrate.bw = ath10k_bw_to_mac80211_bw(txrate.bw);
+	if (sgi)
+		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+
+	switch (arsta->txrate.bw) {
+	case RATE_INFO_BW_40:
+		arsta->tx_info.status.rates[0].flags |=
+				IEEE80211_TX_RC_40_MHZ_WIDTH;
+		break;
+	case RATE_INFO_BW_80:
+		arsta->tx_info.status.rates[0].flags |=
+				IEEE80211_TX_RC_80_MHZ_WIDTH;
+		break;
+	}
+
+	if (peer_stats->succ_pkts) {
+		arsta->tx_info.flags = IEEE80211_TX_STAT_ACK;
+		arsta->tx_info.status.rates[0].count = 1;
+		ieee80211_tx_rate_update(ar->hw, sta, &arsta->tx_info);
+	}
 
 	if (ath10k_debug_is_extd_tx_stats_enabled(ar))
 		ath10k_accumulate_per_peer_tx_stats(ar, arsta, peer_stats,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 15622943a885..f6799f3939bd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4968,6 +4968,7 @@ enum wmi_rate_preamble {
 	(((preamble) << 6) | ((nss) << 4) | (rate))
 #define ATH10K_HW_AMPDU(flags)		((flags) & 0x1)
 #define ATH10K_HW_BA_FAIL(flags)	(((flags) >> 1) & 0x3)
+#define ATH10K_FW_SKIPPED_RATE_CTRL(flags)	(((flags) >> 6) & 0x1)
 
 #define ATH10K_VHT_MCS_NUM	10
 #define ATH10K_BW_NUM		4
-- 
1.7.9.5
