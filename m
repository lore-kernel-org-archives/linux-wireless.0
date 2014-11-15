Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:56059
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754667AbaKOX2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 18:28:05 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 6/6] mac80211: add ieee80211_tx_status_noskb
Date: Sun, 16 Nov 2014 00:28:00 +0100
Message-Id: <1416094080-49220-6-git-send-email-nbd@openwrt.org> (sfid-20141116_002819_774753_E6C52FE8)
In-Reply-To: <1416094080-49220-1-git-send-email-nbd@openwrt.org>
References: <1416094080-49220-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be used by drivers that cannot reliably map tx status
information onto specific skbs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h |  22 ++++++++++
 net/mac80211/rate.h    |  17 ++++++++
 net/mac80211/status.c  | 116 +++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 132 insertions(+), 23 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 32a779c..28ea999 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3517,6 +3517,28 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
 			 struct sk_buff *skb);
 
 /**
+ * ieee80211_tx_status_noskb - transmit status callback without skb
+ *
+ * This function can be used as a replacement for ieee80211_tx_status
+ * in drivers that cannot reliably map tx status information back to
+ * specific skbs.
+ *
+ * This function may not be called in IRQ context. Calls to this function
+ * for a single hardware must be synchronized against each other. Calls
+ * to this function, ieee80211_tx_status_ni() and ieee80211_tx_status_irqsafe()
+ * may not be mixed for a single hardware. Must not run concurrently with
+ * ieee80211_rx() or ieee80211_rx_ni().
+ *
+ * @hw: the hardware the frame was transmitted by
+ * @sta: the receiver station to which this packet is sent
+ *	(NULL for multicast packets)
+ * @info: tx status information
+ */
+void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
+			       struct ieee80211_sta *sta,
+			       struct ieee80211_tx_info *info);
+
+/**
  * ieee80211_tx_status_ni - transmit status callback (in process context)
  *
  * Like ieee80211_tx_status() but can be called in process context.
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index dd25964..a0b18a8 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -49,6 +49,23 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 }
 
 
+static inline void
+rate_control_tx_status_noskb(struct ieee80211_local *local,
+			     struct ieee80211_supported_band *sband,
+			     struct sta_info *sta,
+			     struct ieee80211_tx_info *info)
+{
+	struct rate_control_ref *ref = local->rate_ctrl;
+	struct ieee80211_sta *ista = &sta->sta;
+	void *priv_sta = sta->rate_ctrl_priv;
+
+	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		return;
+
+	ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);
+}
+
+
 static inline void rate_control_rate_init(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->sdata->local;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9612d89..8a6d3ad 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -541,10 +541,9 @@ static void ieee80211_tx_latency_end_msrmnt(struct ieee80211_local *local,
 #define STA_LOST_TDLS_PKT_THRESHOLD	10
 #define STA_LOST_TDLS_PKT_TIME		(10*HZ) /* 10secs since last ACK */
 
-static void ieee80211_lost_packet(struct sta_info *sta, struct sk_buff *skb)
+static void ieee80211_lost_packet(struct sta_info *sta,
+				  struct ieee80211_tx_info *info)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
 	/* This packet was aggregated but doesn't carry status info */
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
@@ -571,24 +570,13 @@ static void ieee80211_lost_packet(struct sta_info *sta, struct sk_buff *skb)
 	sta->lost_packets = 0;
 }
 
-void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int ieee80211_tx_get_rates(struct ieee80211_hw *hw,
+				  struct ieee80211_tx_info *info,
+				  int *retry_count)
 {
-	struct sk_buff *skb2;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	__le16 fc;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_sub_if_data *sdata;
-	struct net_device *prev_dev = NULL;
-	struct sta_info *sta, *tmp;
-	int retry_count = -1, i;
 	int rates_idx = -1;
-	bool send_to_cooked;
-	bool acked;
-	struct ieee80211_bar *bar;
-	int rtap_len;
-	int shift = 0;
+	int count = -1;
+	int i;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
@@ -606,12 +594,94 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			break;
 		}
 
-		retry_count += info->status.rates[i].count;
+		count += info->status.rates[i].count;
 	}
 	rates_idx = i - 1;
 
-	if (retry_count < 0)
-		retry_count = 0;
+	if (count < 0)
+		count = 0;
+
+	*retry_count = count;
+	return rates_idx;
+}
+
+void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
+			       struct ieee80211_sta *pubsta,
+			       struct ieee80211_tx_info *info)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_supported_band *sband;
+	int retry_count;
+	int rates_idx;
+	bool acked;
+
+	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
+
+	sband = hw->wiphy->bands[info->band];
+
+	acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
+	if (pubsta) {
+		struct sta_info *sta;
+
+		sta = container_of(pubsta, struct sta_info, sta);
+
+		if (info->flags & IEEE80211_TX_STATUS_EOSP)
+			clear_sta_flag(sta, WLAN_STA_SP);
+
+		if (!acked)
+			sta->tx_retry_failed++;
+		sta->tx_retry_count += retry_count;
+
+		if (acked) {
+			sta->last_rx = jiffies;
+
+			if (sta->lost_packets)
+				sta->lost_packets = 0;
+
+			/* Track when last TDLS packet was ACKed */
+			if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
+				sta->last_tdls_pkt_time = jiffies;
+		} else {
+			ieee80211_lost_packet(sta, info);
+		}
+
+		rate_control_tx_status_noskb(local, sband, sta, info);
+	}
+
+	if (acked) {
+		    local->dot11TransmittedFrameCount++;
+		    if (!pubsta)
+			    local->dot11MulticastTransmittedFrameCount++;
+		    if (retry_count > 0)
+			    local->dot11RetryCount++;
+		    if (retry_count > 1)
+			    local->dot11MultipleRetryCount++;
+	} else {
+		local->dot11FailedCount++;
+	}
+}
+EXPORT_SYMBOL(ieee80211_tx_status_noskb);
+
+void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct sk_buff *skb2;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	__le16 fc;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_sub_if_data *sdata;
+	struct net_device *prev_dev = NULL;
+	struct sta_info *sta, *tmp;
+	int retry_count;
+	int rates_idx;
+	bool send_to_cooked;
+	bool acked;
+	struct ieee80211_bar *bar;
+	int rtap_len;
+	int shift = 0;
+
+	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
 
 	rcu_read_lock();
 
@@ -716,7 +786,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 				if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
 					sta->last_tdls_pkt_time = jiffies;
 			} else {
-				ieee80211_lost_packet(sta, skb);
+				ieee80211_lost_packet(sta, info);
 			}
 		}
 
-- 
2.1.2

