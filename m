Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38140 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab3LNMzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 07:55:04 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: let the driver reserve extra tailroom in beacons
Date: Sat, 14 Dec 2013 13:54:53 +0100
Message-Id: <1387025693-87897-1-git-send-email-nbd@openwrt.org> (sfid-20131214_135508_802117_8BBB418D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can be used to add extra IEs (such as P2P NoA) without having to
reallocate the buffer.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h | 4 ++++
 net/mac80211/tx.c      | 9 ++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e698d5d..1e5af11 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1600,6 +1600,9 @@ enum ieee80211_hw_flags {
  * @extra_tx_headroom: headroom to reserve in each transmit skb
  *	for use by the driver (e.g. for transmit headers.)
  *
+ * @extra_beacon_tailroom: tailroom to reserve in each beacon tx skb.
+ *	Can be used by drivers to add extra IEs.
+ *
  * @channel_change_time: time (in microseconds) it takes to change channels.
  *
  * @max_signal: Maximum value for signal (rssi) in RX information, used
@@ -1682,6 +1685,7 @@ struct ieee80211_hw {
 	void *priv;
 	u32 flags;
 	unsigned int extra_tx_headroom;
+	unsigned int extra_beacon_tailroom;
 	int channel_change_time;
 	int vif_data_size;
 	int sta_data_size;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6d59e21..002ded2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2549,7 +2549,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			 */
 			skb = dev_alloc_skb(local->tx_headroom +
 					    beacon->head_len +
-					    beacon->tail_len + 256);
+					    beacon->tail_len + 256 +
+					    local->hw.extra_beacon_tailroom);
 			if (!skb)
 				goto out;
 
@@ -2581,7 +2582,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			ieee80211_update_csa(sdata, presp);
 
 
-		skb = dev_alloc_skb(local->tx_headroom + presp->head_len);
+		skb = dev_alloc_skb(local->tx_headroom + presp->head_len +
+				    local->hw.extra_beacon_tailroom);
 		if (!skb)
 			goto out;
 		skb_reserve(skb, local->tx_headroom);
@@ -2608,7 +2610,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		skb = dev_alloc_skb(local->tx_headroom +
 				    bcn->head_len +
 				    256 + /* TIM IE */
-				    bcn->tail_len);
+				    bcn->tail_len +
+				    local->hw.extra_beacon_tailroom);
 		if (!skb)
 			goto out;
 		skb_reserve(skb, local->tx_headroom);
-- 
1.8.3.4 (Apple Git-47)

