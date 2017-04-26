Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53796 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1437748AbdDZPLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 11:11:38 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 3/5] mac80211: add ieee80211_tx_status_ext
Date: Wed, 26 Apr 2017 17:11:37 +0200
Message-Id: <20170426151139.87304-3-nbd@nbd.name> (sfid-20170426_172636_999278_7C07142C)
In-Reply-To: <20170426151139.87304-1-nbd@nbd.name>
References: <20170426151139.87304-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the driver to pass in struct ieee80211_tx_status directly.
Make ieee80211_tx_status_noskb a wrapper around it.

As with ieee80211_tx_status_noskb, there is no _ni variant of this call,
because it probably won't be needed.

Even if the driver won't provide any extra status info other than what's
in struct ieee80211_tx_info already, it can optimize status reporting
this way by passing in the station pointer.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h | 30 ++++++++++++++++++--
 net/mac80211/status.c  | 74 +++++++++++++++++++++++++++++++-------------------
 2 files changed, 73 insertions(+), 31 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 380700e61d3b..1b81f0c90068 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4219,6 +4219,23 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
 			 struct sk_buff *skb);
 
 /**
+ * ieee80211_tx_status_ext - extended transmit status callback
+ *
+ * This function can be used as a replacement for ieee80211_tx_status
+ * in drivers that may want to provide extra information that does not
+ * fit into &struct ieee80211_tx_info.
+ *
+ * Calls to this function for a single hardware must be synchronized
+ * against each other. Calls to this function, ieee80211_tx_status_ni()
+ * and ieee80211_tx_status_irqsafe() may not be mixed for a single hardware.
+ *
+ * @hw: the hardware the frame was transmitted by
+ * @status: tx status information
+ */
+void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
+			     struct ieee80211_tx_status *status);
+
+/**
  * ieee80211_tx_status_noskb - transmit status callback without skb
  *
  * This function can be used as a replacement for ieee80211_tx_status
@@ -4234,9 +4251,16 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,
  *	(NULL for multicast packets)
  * @info: tx status information
  */
-void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
-			       struct ieee80211_sta *sta,
-			       struct ieee80211_tx_info *info);
+static inline void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
+					     struct ieee80211_sta *sta,
+					     struct ieee80211_tx_info *info)
+{
+	struct ieee80211_tx_status status = {};
+
+	status.sta = sta;
+	status.info = info;
+	ieee80211_tx_status_ext(hw, &status);
+}
 
 /**
  * ieee80211_tx_status_ni - transmit status callback (in process context)
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 2b3f02f56db3..35b226ac2fee 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -688,16 +688,16 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
 	dev_kfree_skb(skb);
 }
 
-void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void __ieee80211_tx_status(struct ieee80211_hw *hw,
+				  struct ieee80211_tx_status *status)
 {
+	struct sk_buff *skb = status->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_status status = {};
+	struct ieee80211_tx_info *info = status->info;
+	struct sta_info *sta;
 	__le16 fc;
 	struct ieee80211_supported_band *sband;
-	struct rhlist_head *tmp;
-	struct sta_info *sta;
 	int retry_count;
 	int rates_idx;
 	bool send_to_cooked;
@@ -708,16 +708,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
 
-	rcu_read_lock();
-
 	sband = local->hw.wiphy->bands[info->band];
 	fc = hdr->frame_control;
 
-	for_each_sta_info(local, hdr->addr1, sta, tmp) {
-		/* skip wrong virtual interface */
-		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
-			continue;
-
+	if (status->sta) {
+		sta = container_of(status->sta, struct sta_info, sta);
 		shift = ieee80211_vif_get_shift(&sta->sdata->vif);
 
 		if (info->flags & IEEE80211_TX_STATUS_EOSP)
@@ -737,7 +732,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			 * that this TX packet failed because of that.
 			 */
 			ieee80211_handle_filtered_frame(local, sta, skb);
-			rcu_read_unlock();
 			return;
 		}
 
@@ -787,7 +781,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 		if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 			ieee80211_handle_filtered_frame(local, sta, skb);
-			rcu_read_unlock();
 			return;
 		} else {
 			if (!acked)
@@ -803,10 +796,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			}
 		}
 
-		status.sta = &sta->sta;
-		status.skb = skb;
-		status.info = info;
-		rate_control_tx_status(local, sband, &status);
+		rate_control_tx_status(local, sband, status);
 		if (ieee80211_vif_is_mesh(&sta->sdata->vif))
 			ieee80211s_update_metric(local, sta, skb);
 
@@ -833,8 +823,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 	}
 
-	rcu_read_unlock();
-
 	ieee80211_led_tx(local);
 
 	/* SNMP counters
@@ -899,18 +887,50 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	/* send to monitor interfaces */
 	ieee80211_tx_monitor(local, skb, sband, retry_count, shift, send_to_cooked);
 }
+
+void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_tx_status status = {};
+	struct rhlist_head *tmp;
+	struct sta_info *sta;
+
+	status.skb = skb;
+	status.info = IEEE80211_SKB_CB(skb);
+
+	rcu_read_lock();
+
+	for_each_sta_info(local, hdr->addr1, sta, tmp) {
+		/* skip wrong virtual interface */
+		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
+			continue;
+
+		status.sta = &sta->sta;
+		break;
+	}
+
+	__ieee80211_tx_status(hw, &status);
+	rcu_read_unlock();
+}
 EXPORT_SYMBOL(ieee80211_tx_status);
 
-void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
-			       struct ieee80211_sta *pubsta,
-			       struct ieee80211_tx_info *info)
+void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
+			     struct ieee80211_tx_status *status)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_tx_info *info = status->info;
+	struct ieee80211_sta *pubsta = status->sta;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_tx_status status = {};
 	int retry_count;
 	bool acked, noack_success;
 
+	if (status->skb)
+		return __ieee80211_tx_status(hw, status);
+
+	if (!status->sta)
+		return;
+
 	ieee80211_tx_get_rates(hw, info, &retry_count);
 
 	sband = hw->wiphy->bands[info->band];
@@ -940,9 +960,7 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 			ieee80211_lost_packet(sta, info);
 		}
 
-		status.sta = pubsta;
-		status.info = info;
-		rate_control_tx_status(local, sband, &status);
+		rate_control_tx_status(local, sband, status);
 	}
 
 	if (acked || noack_success) {
@@ -957,7 +975,7 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 		I802_DEBUG_INC(local->dot11FailedCount);
 	}
 }
-EXPORT_SYMBOL(ieee80211_tx_status_noskb);
+EXPORT_SYMBOL(ieee80211_tx_status_ext);
 
 void ieee80211_report_low_ack(struct ieee80211_sta *pubsta, u32 num_packets)
 {
-- 
2.11.0
