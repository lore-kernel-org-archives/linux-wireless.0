Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:59390
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756341AbaKSTIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 14:08:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 7/7] mac80211: add ieee80211_tx_status_noskb
Date: Wed, 19 Nov 2014 20:08:13 +0100
Message-Id: <1416424093-19439-7-git-send-email-nbd@openwrt.org> (sfid-20141119_200819_841374_5321BDC6)
In-Reply-To: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
References: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be used by drivers that cannot reliably map tx status
information onto specific skbs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h | 20 +++++++++++++++++++
 net/mac80211/rate.h    | 18 +++++++++++++++++
 net/mac80211/status.c  | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 32a779c..6150e72 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3517,6 +3517,26 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
 			 struct sk_buff *skb);
 
 /**
+ * ieee80211_tx_status_noskb - transmit status callback without skb
+ *
+ * This function can be used as a replacement for ieee80211_tx_status
+ * in drivers that cannot reliably map tx status information back to
+ * specific skbs.
+ *
+ * Calls to this function for a single hardware must be synchronized
+ * against each other. Calls to this function, ieee80211_tx_status_ni()
+ * and ieee80211_tx_status_irqsafe() may not be mixed for a single hardware.
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
index dd25964..38652f0 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -48,6 +48,24 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 		ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);
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
+	if (WARN_ON_ONCE(!ref->ops->tx_status_noskb))
+		return;
+
+	ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);
+}
 
 static inline void rate_control_rate_init(struct sta_info *sta)
 {
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 249ca3a..84d6f6c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -605,6 +605,60 @@ static int ieee80211_tx_get_rates(struct ieee80211_hw *hw,
 	return rates_idx;
 }
 
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
 void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct sk_buff *skb2;
-- 
2.1.2

