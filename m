Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34883 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbaFDPIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 11:08:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove weak WEP IV accounting
Date: Wed,  4 Jun 2014 17:07:56 +0200
Message-Id: <1401894476-28461-1-git-send-email-johannes@sipsolutions.net> (sfid-20140604_170814_412269_38D8BACC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since WEP is practically dead, there seems very little
point in keeping WEP weak IV accounting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  3 +--
 net/mac80211/debugfs_sta.c |  1 -
 net/mac80211/sta_info.h    |  2 --
 net/mac80211/wep.c         | 20 --------------------
 4 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d7513a503be1..f8d065480ba9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -603,7 +603,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 }
 
 static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
-	"rx_packets", "rx_bytes", "wep_weak_iv_count",
+	"rx_packets", "rx_bytes",
 	"rx_duplicates", "rx_fragments", "rx_dropped",
 	"tx_packets", "tx_bytes", "tx_fragments",
 	"tx_filtered", "tx_retry_failed", "tx_retries",
@@ -651,7 +651,6 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 	do {						\
 		data[i++] += sta->rx_packets;		\
 		data[i++] += sta->rx_bytes;		\
-		data[i++] += sta->wep_weak_iv_count;	\
 		data[i++] += sta->num_duplicates;	\
 		data[i++] += sta->rx_fragments;		\
 		data[i++] += sta->rx_dropped;		\
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 2ecb4deddb5d..ee82e1f0a9e7 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -587,7 +587,6 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD_COUNTER(tx_filtered, tx_filtered_count);
 	DEBUGFS_ADD_COUNTER(tx_retry_failed, tx_retry_failed);
 	DEBUGFS_ADD_COUNTER(tx_retry_count, tx_retry_count);
-	DEBUGFS_ADD_COUNTER(wep_weak_iv_count, wep_weak_iv_count);
 
 	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
 		debugfs_create_x32("driver_buffered_tids", 0400,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 159cac903ce8..fa7ce6f8593b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -281,7 +281,6 @@ struct ieee80211_tx_latency_stat {
  * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
  * @rx_packets: Number of MSDUs received from this STA
  * @rx_bytes: Number of bytes received from this STA
- * @wep_weak_iv_count: number of weak WEP IVs received from this station
  * @last_rx: time (in jiffies) when last frame was received from this STA
  * @last_connected: time (in seconds) when a station got connected
  * @num_duplicates: number of duplicate frames received from this STA
@@ -369,7 +368,6 @@ struct sta_info {
 	/* Updated from RX path only, no locking requirements */
 	unsigned long rx_packets;
 	u64 rx_bytes;
-	unsigned long wep_weak_iv_count;
 	unsigned long last_rx;
 	long last_connected;
 	unsigned long num_duplicates;
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 6ee2b5863572..9181fb6d6437 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -271,22 +271,6 @@ static int ieee80211_wep_decrypt(struct ieee80211_local *local,
 	return ret;
 }
 
-
-static bool ieee80211_wep_is_weak_iv(struct sk_buff *skb,
-				     struct ieee80211_key *key)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	unsigned int hdrlen;
-	u8 *ivpos;
-	u32 iv;
-
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	ivpos = skb->data + hdrlen;
-	iv = (ivpos[0] << 16) | (ivpos[1] << 8) | ivpos[2];
-
-	return ieee80211_wep_weak_iv(iv, key->conf.keylen);
-}
-
 ieee80211_rx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 {
@@ -301,16 +285,12 @@ ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
 		if (skb_linearize(rx->skb))
 			return RX_DROP_UNUSABLE;
-		if (rx->sta && ieee80211_wep_is_weak_iv(rx->skb, rx->key))
-			rx->sta->wep_weak_iv_count++;
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key))
 			return RX_DROP_UNUSABLE;
 	} else if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
 		if (!pskb_may_pull(rx->skb, ieee80211_hdrlen(fc) +
 					    IEEE80211_WEP_IV_LEN))
 			return RX_DROP_UNUSABLE;
-		if (rx->sta && ieee80211_wep_is_weak_iv(rx->skb, rx->key))
-			rx->sta->wep_weak_iv_count++;
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
 		/* remove ICV */
 		if (pskb_trim(rx->skb, rx->skb->len - IEEE80211_WEP_ICV_LEN))
-- 
2.0.0.rc0

