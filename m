Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37833 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0IUS5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 14:57:40 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [mac80211/ath9k] mac80211/ath9k:  Support AMPDU with multiple VIFs.
Date: Tue, 21 Sep 2010 11:57:35 -0700
Message-Id: <1285095455-29081-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The old ieee80211_find_sta_by_hw method didn't properly
find VIFS when there was more than on per AP.  This caused
AMPDU logic in ath9k to get the wrong VIF when trying to
account for transmitted SKBs.

This patch changes ieee80211_find_sta_by_hw to take a
net_device pointer to distinguish among multiple VIFs.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c5e7af4... 2628d8f... M	drivers/net/wireless/ath/ath9k/recv.c
:100644 100644 85a7323... aef60ea... M	drivers/net/wireless/ath/ath9k/xmit.c
:100644 100644 12a49f0... 63df108... M	include/net/mac80211.h
:100644 100644 44e10a9... f745497... M	net/mac80211/sta_info.c
 drivers/net/wireless/ath/ath9k/recv.c |   12 +++++++-----
 drivers/net/wireless/ath/ath9k/xmit.c |    3 +--
 include/net/mac80211.h                |   13 ++++---------
 net/mac80211/sta_info.c               |   12 +++++++-----
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c5e7af4..2628d8f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -959,7 +959,8 @@ static int ath9k_process_rate(struct ath_common *common,
 static void ath9k_process_rssi(struct ath_common *common,
 			       struct ieee80211_hw *hw,
 			       struct ieee80211_hdr *hdr,
-			       struct ath_rx_status *rx_stats)
+			       struct ath_rx_status *rx_stats,
+			       struct net_device *dev)
 {
 	struct ath_hw *ah = common->ah;
 	struct ieee80211_sta *sta;
@@ -977,7 +978,7 @@ static void ath9k_process_rssi(struct ath_common *common,
 	 * at least one sdata of a wiphy on mac80211 but with ath9k virtual
 	 * wiphy you'd have to iterate over every wiphy and each sdata.
 	 */
-	sta = ieee80211_find_sta_by_hw(hw, hdr->addr2);
+	sta = ieee80211_find_sta_by_hw(hw, hdr->addr2, dev);
 	if (sta) {
 		an = (struct ath_node *) sta->drv_priv;
 		if (rx_stats->rs_rssi != ATH9K_RSSI_BAD &&
@@ -1008,7 +1009,8 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 				   struct ieee80211_hdr *hdr,
 				   struct ath_rx_status *rx_stats,
 				   struct ieee80211_rx_status *rx_status,
-				   bool *decrypt_error)
+				   bool *decrypt_error,
+				   struct net_device *dev)
 {
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
@@ -1019,7 +1021,7 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error))
 		return -EINVAL;
 
-	ath9k_process_rssi(common, hw, hdr, rx_stats);
+	ath9k_process_rssi(common, hw, hdr, rx_stats, dev);
 
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
 		return -EINVAL;
@@ -1686,7 +1688,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			goto requeue;
 
 		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
-						 rxs, &decrypt_error);
+						 rxs, &decrypt_error, skb->dev);
 		if (retval)
 			goto requeue;
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 85a7323..aef60ea 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -328,8 +328,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	rcu_read_lock();
 
-	/* XXX: use ieee80211_find_sta! */
-	sta = ieee80211_find_sta_by_hw(hw, hdr->addr1);
+	sta = ieee80211_find_sta_by_hw(hw, hdr->addr1, skb->dev);
 	if (!sta) {
 		rcu_read_unlock();
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 12a49f0..63df108 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2420,21 +2420,16 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
  * @addr: station's address
+ * @dev:  Netdevice to differentiate between multiple VIFs with same STA addr.
  *
  * This function must be called under RCU lock and the
  * resulting pointer is only valid under RCU lock as well.
  *
- * NOTE: This function should not be used! When mac80211 is converted
- *	 internally to properly keep track of stations on multiple
- *	 virtual interfaces, it will not always know which station to
- *	 return here since a single address might be used by multiple
- *	 logical stations (e.g. consider a station connecting to another
- *	 BSSID on the same AP hardware without disconnecting first).
- *
- * DO NOT USE THIS FUNCTION.
  */
 struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
-					       const u8 *addr);
+					       const u8 *addr,
+					       struct net_device *dev);
+
 
 /**
  * ieee80211_sta_block_awake - block station from waking up
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 44e10a9..f745497 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -839,15 +839,17 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 }
 
 struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
-					       const u8 *addr)
+					       const u8 *addr,
+					       struct net_device *dev)
 {
 	struct sta_info *sta, *nxt;
 
-	/* Just return a random station ... first in list ... */
 	for_each_sta_info(hw_to_local(hw), addr, sta, nxt) {
-		if (!sta->uploaded)
-			return NULL;
-		return &sta->sta;
+		if (sta->sdata->dev == dev) {
+			if (!sta->uploaded)
+				return NULL;
+			return &sta->sta;
+		}
 	}
 
 	return NULL;
-- 
1.7.2.2

