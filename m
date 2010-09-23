Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41838 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab0IWQok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 12:44:40 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211/ath9k:  Support AMPDU with multiple VIFs.
Date: Thu, 23 Sep 2010 09:44:36 -0700
Message-Id: <1285260276-29105-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The old ieee80211_find_sta_by_hw method didn't properly
find VIFS when there was more than one per AP.  This caused
AMPDU logic in ath9k to get the wrong VIF when trying to
account for transmitted SKBs.

This patch changes ieee80211_find_sta_by_hw to take a
localaddr argument to distinguish between VIFs with the
same AP but different local addresses.  The method name
is changed to ieee80211_find_sta_by_ifaddr.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c5e7af4... 9cd0597... M	drivers/net/wireless/ath/ath9k/recv.c
:100644 100644 85a7323... f7da6b2... M	drivers/net/wireless/ath/ath9k/xmit.c
:100644 100644 12a49f0... a0afea1... M	include/net/mac80211.h
:100644 100644 44e10a9... ca2cba9... M	net/mac80211/sta_info.c
 drivers/net/wireless/ath/ath9k/recv.c |    6 +++++-
 drivers/net/wireless/ath/ath9k/xmit.c |    3 +--
 include/net/mac80211.h                |   25 ++++++++++++++-----------
 net/mac80211/sta_info.c               |   15 +++++++++++----
 4 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c5e7af4..9cd0597 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -977,7 +977,11 @@ static void ath9k_process_rssi(struct ath_common *common,
 	 * at least one sdata of a wiphy on mac80211 but with ath9k virtual
 	 * wiphy you'd have to iterate over every wiphy and each sdata.
 	 */
-	sta = ieee80211_find_sta_by_hw(hw, hdr->addr2);
+	if (is_multicast_ether_addr(hdr->addr1))
+		sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr2, NULL);
+	else
+		sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr2, hdr->addr1);
+		
 	if (sta) {
 		an = (struct ath_node *) sta->drv_priv;
 		if (rx_stats->rs_rssi != ATH9K_RSSI_BAD &&
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 85a7323..f7da6b2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -328,8 +328,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	rcu_read_lock();
 
-	/* XXX: use ieee80211_find_sta! */
-	sta = ieee80211_find_sta_by_hw(hw, hdr->addr1);
+	sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr1, hdr->addr2);
 	if (!sta) {
 		rcu_read_unlock();
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 12a49f0..a0afea1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2416,25 +2416,28 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 					 const u8 *addr);
 
 /**
- * ieee80211_find_sta_by_hw - find a station on hardware
+ * ieee80211_find_sta_by_ifaddr - find a station on hardware
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
- * @addr: station's address
+ * @addr: remote station's address
+ * @localaddr: local address (vif->sdata->vif.addr). Use NULL for 'any'.
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
+ * NOTE: You may pass NULL for localaddr, but then you will just get
+ *      the first STA that matches the remote address 'addr'.
+ *      We can have multiple STA associated with multiple
+ *      logical stations (e.g. consider a station connecting to another
+ *      BSSID on the same AP hardware without disconnecting first).
+ *      In this case, the result of this method with localaddr NULL
+ *      is not reliable.
  *
- * DO NOT USE THIS FUNCTION.
+ * DO NOT USE THIS FUNCTION with localaddr NULL if at all possible.
  */
-struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
-					       const u8 *addr);
+struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
+					       const u8 *addr,
+					       const u8 *localaddr);
 
 /**
  * ieee80211_sta_block_awake - block station from waking up
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 44e10a9..ca2cba9 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -838,13 +838,20 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&local->sta_mtx);
 }
 
-struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
-					       const u8 *addr)
+struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
+					       const u8 *addr,
+					       const u8 *localaddr)
 {
 	struct sta_info *sta, *nxt;
 
-	/* Just return a random station ... first in list ... */
+	/*
+	 * Just return a random station if localaddr is NULL
+	 * ... first in list.
+	 */
 	for_each_sta_info(hw_to_local(hw), addr, sta, nxt) {
+		if (localaddr &&
+		    compare_ether_addr(sta->sdata->vif.addr, localaddr) != 0)
+			continue;
 		if (!sta->uploaded)
 			return NULL;
 		return &sta->sta;
@@ -852,7 +859,7 @@ struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(ieee80211_find_sta_by_hw);
+EXPORT_SYMBOL_GPL(ieee80211_find_sta_by_ifaddr);
 
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 					 const u8 *addr)
-- 
1.7.2.2

