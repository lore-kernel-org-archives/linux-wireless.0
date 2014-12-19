Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46989 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaLSP6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 10:58:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/3] mac80211: provide per-TID RX/TX MSDU counters
Date: Fri, 19 Dec 2014 16:58:02 +0100
Message-Id: <1419004683-25369-2-git-send-email-johannes@sipsolutions.net> (sfid-20141219_165817_944157_C9BC675D)
In-Reply-To: <1419004683-25369-1-git-send-email-johannes@sipsolutions.net>
References: <1419004683-25369-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement the new counters cfg80211 can now advertise to userspace.
The TX code is in the sequence number handler, which is a bit odd,
but that place already knows the TID and frame type, so it was
easiest and least impact there.

Change-Id: Iccc7774119092a5497c6ea98ea9a570661f92904
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       |  9 +++++++++
 net/mac80211/sta_info.c | 31 +++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h | 12 ++++++++++++
 net/mac80211/status.c   | 15 +++++++++++++--
 net/mac80211/tx.c       |  3 +++
 5 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0e150993f0dc..8ace61aecddb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2313,6 +2313,15 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
 		return RX_DROP_MONITOR;
 
+	if (rx->sta) {
+		/* The security index has the same property as needed
+		 * for the rx_msdu field, i.e. it is IEEE80211_NUM_TIDS
+		 * for non-QoS-data frames. Here we know it's a data
+		 * frame, so count MSDUs.
+		 */
+		rx->sta->rx_msdu[rx->security_idx]++;
+	}
+
 	/*
 	 * Send unexpected-4addr-frame event to hostapd. For older versions,
 	 * also drop the frame to cooked monitor interfaces.
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 2803532c5984..8b067f9e8eac 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1899,6 +1899,37 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
 	}
 
+	sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
+	for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
+		struct cfg80211_tid_stats *tidstats = &sinfo->pertid[i];
+
+		if (!(tidstats->filled & BIT(NL80211_TID_STATS_RX_MSDU))) {
+			tidstats->filled |= BIT(NL80211_TID_STATS_RX_MSDU);
+			tidstats->rx_msdu = sta->rx_msdu[i];
+		}
+
+		if (!(tidstats->filled & BIT(NL80211_TID_STATS_TX_MSDU))) {
+			tidstats->filled |= BIT(NL80211_TID_STATS_TX_MSDU);
+			tidstats->tx_msdu = sta->tx_msdu[i];
+		}
+
+		if (!(tidstats->filled &
+				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES)) &&
+		    local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+			tidstats->filled |=
+				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES);
+			tidstats->tx_msdu_retries = sta->tx_msdu_retries[i];
+		}
+
+		if (!(tidstats->filled &
+				BIT(NL80211_TID_STATS_TX_MSDU_FAILED)) &&
+		    local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+			tidstats->filled |=
+				BIT(NL80211_TID_STATS_TX_MSDU_FAILED);
+			tidstats->tx_msdu_failed = sta->tx_msdu_failed[i];
+		}
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CPTCFG_MAC80211_MESH
 		sinfo->filled |= BIT(NL80211_STA_INFO_LLID) |
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index e6441c011a1e..36a14a0be6dd 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -374,6 +374,14 @@ struct ieee80211_tx_latency_stat {
  * @cipher_scheme: optional cipher scheme for this station
  * @last_tdls_pkt_time: holds the time in jiffies of last TDLS pkt ACKed
  * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERVED)
+ * @tx_msdu: MSDUs transmitted to this station, using IEEE80211_NUM_TID
+ *	entry for non-QoS frames
+ * @tx_msdu_retries: MSDU retries for transmissions to to this station,
+ *	using IEEE80211_NUM_TID entry for non-QoS frames
+ * @tx_msdu_failed: MSDU failures for transmissions to to this station,
+ *	using IEEE80211_NUM_TID entry for non-QoS frames
+ * @rx_msdu: MSDUs received from this station, using IEEE80211_NUM_TID
+ *	entry for non-QoS frames
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -444,6 +452,10 @@ struct sta_info {
 	u32 last_rx_rate_vht_flag;
 	u8 last_rx_rate_vht_nss;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
+	u64 tx_msdu[IEEE80211_NUM_TIDS + 1];
+	u64 tx_msdu_retries[IEEE80211_NUM_TIDS + 1];
+	u64 tx_msdu_failed[IEEE80211_NUM_TIDS + 1];
+	u64 rx_msdu[IEEE80211_NUM_TIDS + 1];
 
 	/*
 	 * Aggregation information, locked with lock.
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 6350e9fd46a9..3b0932bc0fce 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -867,6 +867,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	int shift = 0;
 	int prev_loss_pkt;
 	bool send_fail = true;
+	int tid = IEEE80211_NUM_TIDS;
 
 	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
 
@@ -910,7 +911,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 		if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
 		    (ieee80211_is_data_qos(fc))) {
-			u16 tid, ssn;
+			u16 ssn;
 			u8 *qc;
 
 			qc = ieee80211_get_qos_ctl(hdr);
@@ -919,10 +920,14 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 						& IEEE80211_SCTL_SEQ);
 			ieee80211_send_bar(&sta->sdata->vif, hdr->addr1,
 					   tid, ssn);
+		} else if (ieee80211_is_data_qos(fc)) {
+			u8 *qc = ieee80211_get_qos_ctl(hdr);
+
+			tid = qc[0] & 0xf;
 		}
 
 		if (!acked && ieee80211_is_back_req(fc)) {
-			u16 tid, control;
+			u16 control;
 
 			/*
 			 * BAR failed, store the last SSN and retry sending
@@ -950,6 +955,12 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			if (!acked)
 				sta->tx_retry_failed++;
 			sta->tx_retry_count += retry_count;
+
+			if (ieee80211_is_data_present(fc)) {
+				if (!acked)
+					sta->tx_msdu_failed[tid]++;
+				sta->tx_msdu_retries[tid] += retry_count;
+			}
 		}
 
 		rate_control_tx_status(local, sband, sta, skb);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b6b709d61f9a..b385e94f26c1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -815,6 +815,8 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 		/* for pure STA mode without beacons, we can do it */
 		hdr->seq_ctrl = cpu_to_le16(tx->sdata->sequence_number);
 		tx->sdata->sequence_number += 0x10;
+		if (tx->sta)
+			tx->sta->tx_msdu[IEEE80211_NUM_TIDS]++;
 		return TX_CONTINUE;
 	}
 
@@ -831,6 +833,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	qc = ieee80211_get_qos_ctl(hdr);
 	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 	seq = &tx->sta->tid_seq[tid];
+	tx->sta->tx_msdu[tid]++;
 
 	hdr->seq_ctrl = cpu_to_le16(*seq);
 
-- 
2.1.1

