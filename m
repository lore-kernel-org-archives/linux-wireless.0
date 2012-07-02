Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2GBRPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 13:15:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove tx_frags driver callback
Date: Mon,  2 Jul 2012 19:15:15 +0200
Message-Id: <1341249315-11372-1-git-send-email-johannes@sipsolutions.net> (sfid-20120702_191530_866915_A8B2DEA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The implementation of tx_frags is buggy due to
not handling queue stop, and there's no driver
implementing it so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |   15 ---------------
 net/mac80211/driver-ops.h |    8 --------
 net/mac80211/main.c       |    2 +-
 net/mac80211/tx.c         |    7 ++-----
 4 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b5da094..dc2a97a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1896,19 +1896,6 @@ enum ieee80211_rate_control_changed {
  *	The low-level driver should send the frame out based on
  *	configuration in the TX control data. This handler should,
  *	preferably, never fail and stop queues appropriately.
- *	This must be implemented if @tx_frags is not.
- *	Must be atomic.
- *
- * @tx_frags: Called to transmit multiple fragments of a single MSDU.
- *	This handler must consume all fragments, sending out some of
- *	them only is useless and it can't ask for some of them to be
- *	queued again. If the frame is not fragmented the queue has a
- *	single SKB only. To avoid issues with the networking stack
- *	when TX status is reported the frames should be removed from
- *	the skb queue.
- *	If this is used, the tx_info @vif and @sta pointers will be
- *	invalid -- you must not use them in that case.
- *	This must be implemented if @tx isn't.
  *	Must be atomic.
  *
  * @start: Called before the first netdevice attached to the hardware
@@ -2260,8 +2247,6 @@ enum ieee80211_rate_control_changed {
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
-	void (*tx_frags)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta, struct sk_buff_head *skbs);
 	int (*start)(struct ieee80211_hw *hw);
 	void (*stop)(struct ieee80211_hw *hw);
 #ifdef CONFIG_PM
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 44e8c12..5042151 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -27,14 +27,6 @@ static inline void drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
 	local->ops->tx(&local->hw, skb);
 }
 
-static inline void drv_tx_frags(struct ieee80211_local *local,
-				struct ieee80211_vif *vif,
-				struct ieee80211_sta *sta,
-				struct sk_buff_head *skbs)
-{
-	local->ops->tx_frags(&local->hw, vif, sta, skbs);
-}
-
 static inline void drv_get_et_strings(struct ieee80211_sub_if_data *sdata,
 				      u32 sset, u8 *data)
 {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ab32c59..c794101 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -587,7 +587,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	local->hw.priv = (char *)local + ALIGN(sizeof(*local), NETDEV_ALIGN);
 
-	BUG_ON(!ops->tx && !ops->tx_frags);
+	BUG_ON(!ops->tx);
 	BUG_ON(!ops->start);
 	BUG_ON(!ops->stop);
 	BUG_ON(!ops->config);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4990f4f..364a1e7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1295,11 +1295,8 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 		break;
 	}
 
-	if (local->ops->tx_frags)
-		drv_tx_frags(local, vif, pubsta, skbs);
-	else
-		result = ieee80211_tx_frags(local, vif, pubsta, skbs,
-					    txpending);
+	result = ieee80211_tx_frags(local, vif, pubsta, skbs,
+				    txpending);
 
 	ieee80211_tpt_led_trig_tx(local, fc, led_len);
 	ieee80211_led_tx(local, 1);
-- 
1.7.10

