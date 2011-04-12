Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:53727 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab1DLSHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 14:07:02 -0400
Received: by pxi2 with SMTP id 2so3655027pxi.10
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 11:07:02 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org, buytenh@wantstofly.org
Cc: Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH] mwl8k: use traffic threshold to decide when to start ampdu
Date: Tue, 12 Apr 2011 11:06:28 -0700
Message-Id: <1302631588-8455-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, ampdu stream is created on the first qos packet to an
HT sta. The overhead of setting up the BA session may not be
justified if the outgoing packet rate is minimal (e.g., ping). So
we only allow ampdu streams after seeing a critical number of
packets in an arbitrary one-second interval.

Based on work by Nishant Sarmukadam <nishants@marvell.com>

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   45 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ae56d2f..ce2fd66 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -288,10 +288,17 @@ struct mwl8k_vif {
 #define MWL8K_VIF(_vif) ((struct mwl8k_vif *)&((_vif)->drv_priv))
 #define IEEE80211_KEY_CONF(_u8) ((struct ieee80211_key_conf *)(_u8))
 
+struct tx_traffic_info {
+	u32 start_time;
+	u32 pkts;
+};
+
+#define MWL8K_MAX_TID 8
 struct mwl8k_sta {
 	/* Index into station database. Returned by UPDATE_STADB.  */
 	u8 peer_id;
 	u8 is_ampdu_allowed;
+	struct tx_traffic_info tx_stats[MWL8K_MAX_TID];
 };
 #define MWL8K_STA(_sta) ((struct mwl8k_sta *)&((_sta)->drv_priv))
 
@@ -1754,6 +1761,41 @@ mwl8k_lookup_stream(struct ieee80211_hw *hw, u8 *addr, u8 tid)
 	return NULL;
 }
 
+#define MWL8K_AMPDU_PACKET_THRESHOLD 64
+static inline bool mwl8k_ampdu_allowed(struct ieee80211_sta *sta, u8 tid)
+{
+	struct mwl8k_sta *sta_info = MWL8K_STA(sta);
+	struct tx_traffic_info *tx_stats;
+
+	BUG_ON(tid >= MWL8K_MAX_TID);
+	tx_stats = &sta_info->tx_stats[tid];
+
+	return sta_info->is_ampdu_allowed &&
+		tx_stats->pkts > MWL8K_AMPDU_PACKET_THRESHOLD;
+}
+
+static inline void mwl8k_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
+{
+	struct mwl8k_sta *sta_info = MWL8K_STA(sta);
+	struct tx_traffic_info *tx_stats;
+
+	BUG_ON(tid >= MWL8K_MAX_TID);
+	tx_stats = &sta_info->tx_stats[tid];
+
+	if (tx_stats->start_time == 0)
+		tx_stats->start_time = jiffies;
+
+	/* reset the packet count after each second elapses.  If the number of
+	 * packets ever exceeds the ampdu_min_traffic threshold, we will allow
+	 * an ampdu stream to be started.
+	 */
+	if (jiffies - tx_stats->start_time > HZ) {
+		tx_stats->pkts = 0;
+		tx_stats->start_time = 0;
+	} else
+		tx_stats->pkts++;
+}
+
 static void
 mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 {
@@ -1840,6 +1882,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	    skb->protocol != cpu_to_be16(ETH_P_PAE) &&
 	    sta->ht_cap.ht_supported && priv->ap_fw) {
 		tid = qos & 0xf;
+		mwl8k_tx_count_packet(sta, tid);
 		spin_lock(&priv->stream_lock);
 		stream = mwl8k_lookup_stream(hw, sta->addr, tid);
 		if (stream != NULL) {
@@ -1880,7 +1923,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 			 * prevents sequence number mismatch at the recepient
 			 * as described above.
 			 */
-			if (MWL8K_STA(sta)->is_ampdu_allowed) {
+			if (mwl8k_ampdu_allowed(sta, tid)) {
 				stream = mwl8k_add_stream(hw, sta, tid);
 				if (stream != NULL)
 					start_ba_session = true;
-- 
1.7.1.1

