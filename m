Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39498 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966776AbbDXJVS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 05:21:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: remove sta->tx_fragments counter
Date: Fri, 24 Apr 2015 11:21:12 +0200
Message-Id: <1429867273-18271-3-git-send-email-johannes@sipsolutions.net> (sfid-20150424_112127_050438_F4BC3440)
In-Reply-To: <1429867273-18271-1-git-send-email-johannes@sipsolutions.net>
References: <1429867273-18271-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This counter is unsafe with concurrent TX and is only exposed
through debugfs and ethtool. Instead of trying to fix it just
remove it for now, if it's really needed then it should be
exposed through nl80211 and in a way that drivers that do the
fragmentation in the device could support it as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 1 -
 net/mac80211/ethtool.c     | 3 +--
 net/mac80211/sta_info.h    | 2 --
 net/mac80211/tx.c          | 2 --
 4 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 252859e90e8a..7ca601414000 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -452,7 +452,6 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD_COUNTER(rx_duplicates, num_duplicates);
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_fragments);
 	DEBUGFS_ADD_COUNTER(rx_dropped, rx_dropped);
-	DEBUGFS_ADD_COUNTER(tx_fragments, tx_fragments);
 	DEBUGFS_ADD_COUNTER(tx_filtered, tx_filtered_count);
 	DEBUGFS_ADD_COUNTER(tx_retry_failed, tx_retry_failed);
 	DEBUGFS_ADD_COUNTER(tx_retry_count, tx_retry_count);
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 52bcea6ad9e8..188faab11c24 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -38,7 +38,7 @@ static void ieee80211_get_ringparam(struct net_device *dev,
 static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
 	"rx_packets", "rx_bytes",
 	"rx_duplicates", "rx_fragments", "rx_dropped",
-	"tx_packets", "tx_bytes", "tx_fragments",
+	"tx_packets", "tx_bytes",
 	"tx_filtered", "tx_retry_failed", "tx_retries",
 	"beacon_loss", "sta_state", "txrate", "rxrate", "signal",
 	"channel", "noise", "ch_time", "ch_time_busy",
@@ -87,7 +87,6 @@ static void ieee80211_get_stats(struct net_device *dev,
 							\
 		data[i++] += sinfo.tx_packets;		\
 		data[i++] += sinfo.tx_bytes;		\
-		data[i++] += sta->tx_fragments;		\
 		data[i++] += sta->tx_filtered_count;	\
 		data[i++] += sta->tx_retry_failed;	\
 		data[i++] += sta->tx_retry_count;	\
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c821fe47c2d1..fdd981c0fa21 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -323,7 +323,6 @@ struct ieee80211_fast_tx {
  * @fail_avg: moving percentage of failed MSDUs
  * @tx_packets: number of RX/TX MSDUs
  * @tx_bytes: number of bytes transmitted to this STA
- * @tx_fragments: number of transmitted MPDUs
  * @tid_seq: per-TID sequence numbers for sending to this STA
  * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
@@ -433,7 +432,6 @@ struct sta_info {
 	unsigned int fail_avg;
 
 	/* Updated from TX path only, no locking requirements */
-	u32 tx_fragments;
 	u64 tx_packets[IEEE80211_NUM_ACS];
 	u64 tx_bytes[IEEE80211_NUM_ACS];
 	struct ieee80211_tx_rate last_tx_rate;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 745fdf5c2722..db5e40360924 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -997,7 +997,6 @@ ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 
 	skb_queue_walk(&tx->skbs, skb) {
 		ac = skb_get_queue_mapping(skb);
-		tx->sta->tx_fragments++;
 		tx->sta->tx_bytes[ac] += skb->len;
 	}
 	if (ac >= 0)
@@ -2804,7 +2803,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	/* statistics normally done by ieee80211_tx_h_stats (but that
 	 * has to consider fragmentation, so is more complex)
 	 */
-	sta->tx_fragments++;
 	sta->tx_bytes[skb_get_queue_mapping(skb)] += skb->len;
 	sta->tx_packets[skb_get_queue_mapping(skb)]++;
 
-- 
2.1.4

