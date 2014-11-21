Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55945 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbaKUN2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 08:28:33 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/2] mac80211: provide per-TID RX/TX MSDU counters
Date: Fri, 21 Nov 2014 14:28:25 +0100
Message-Id: <1416576505-15023-2-git-send-email-johannes@sipsolutions.net> (sfid-20141121_142835_694826_AEC4B158)
In-Reply-To: <1416576505-15023-1-git-send-email-johannes@sipsolutions.net>
References: <1416576505-15023-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement the new counters cfg80211 can now advertise to userspace.
The TX code is in the sequence number handler, which is a bit odd,
but that place already knows the TID and frame type, so it was
easiest and least impact there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       |  9 +++++++++
 net/mac80211/sta_info.c | 22 ++++++++++++++++++++++
 net/mac80211/sta_info.h |  7 +++++++
 net/mac80211/tx.c       |  3 +++
 4 files changed, 41 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 71ca5d6a898c..6673aa2af2aa 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2251,6 +2251,15 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
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
index 2803532c5984..cc10e9761739 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1899,6 +1899,28 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
 	}
 
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_QOS_MSDU))) {
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++)
+			sinfo->rx_qos_msdu[i] = sta->rx_msdu[i];
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_QOS_MSDU);
+	}
+
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_NONQOS_MSDU))) {
+		sinfo->rx_nonqos_msdu = sta->rx_msdu[IEEE80211_NUM_TIDS];
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_NONQOS_MSDU);
+	}
+
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_QOS_MSDU))) {
+		for (i = 0; i < 8; i++)
+			sinfo->tx_qos_msdu[i] = sta->tx_msdu_qos[i];
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_QOS_MSDU);
+	}
+
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_NONQOS_MSDU))) {
+		sinfo->tx_nonqos_msdu = sta->tx_msdu_nonqos;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_NONQOS_MSDU);
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CPTCFG_MAC80211_MESH
 		sinfo->filled |= BIT(NL80211_STA_INFO_LLID) |
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index e6441c011a1e..66720d8cfa20 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -374,6 +374,10 @@ struct ieee80211_tx_latency_stat {
  * @cipher_scheme: optional cipher scheme for this station
  * @last_tdls_pkt_time: holds the time in jiffies of last TDLS pkt ACKed
  * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERVED)
+ * @tx_msdu_qos: QoS MSDUs transmitted to this station
+ * @tx_msdu_nonqos: non-QoS MSDUs transmitted to this station
+ * @rx_msdu: MSDUs received from this station, using IEEE80211_NUM_TID
+ *	entry for non-QoS frames
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -444,6 +448,9 @@ struct sta_info {
 	u32 last_rx_rate_vht_flag;
 	u8 last_rx_rate_vht_nss;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
+	u64 tx_msdu_qos[IEEE80211_NUM_TIDS];
+	u64 tx_msdu_nonqos;
+	u64 rx_msdu[IEEE80211_NUM_TIDS + 1];
 
 	/*
 	 * Aggregation information, locked with lock.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4d356c28b483..7cfe898bcda1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -815,6 +815,8 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 		/* for pure STA mode without beacons, we can do it */
 		hdr->seq_ctrl = cpu_to_le16(tx->sdata->sequence_number);
 		tx->sdata->sequence_number += 0x10;
+		if (tx->sta)
+			tx->sta->tx_msdu_nonqos++;
 		return TX_CONTINUE;
 	}
 
@@ -831,6 +833,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	qc = ieee80211_get_qos_ctl(hdr);
 	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 	seq = &tx->sta->tid_seq[tid];
+	tx->sta->tx_msdu_qos[tid]++;
 
 	hdr->seq_ctrl = cpu_to_le16(*seq);
 
-- 
2.1.1

