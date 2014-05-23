Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51516 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaEWSFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 14:05:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: reduce packet loss notifications under load
Date: Fri, 23 May 2014 20:05:28 +0200
Message-Id: <1400868328-78595-1-git-send-email-nbd@openwrt.org> (sfid-20140523_200631_656271_4606F067)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During strong signal fluctuations under high throughput, few consecutive
failed A-MPDU transmissions can easily trigger packet loss notification,
and thus (in AP mode) client disconnection.

Reduce the number of false positives by checking the A-MPDU status flag
and treating a failed A-MPDU as a single packet.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/status.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 60cb7a6..ba29ebc 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -541,6 +541,23 @@ static void ieee80211_tx_latency_end_msrmnt(struct ieee80211_local *local,
  */
 #define STA_LOST_PKT_THRESHOLD	50
 
+static void ieee80211_lost_packet(struct sta_info *sta, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	/* This packet was aggregated but doesn't carry status info */
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
+	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
+		return;
+
+	if (++sta->lost_packets < STA_LOST_PKT_THRESHOLD)
+		return;
+
+	cfg80211_cqm_pktloss_notify(sta->sdata->dev, sta->sta.addr,
+				    sta->lost_packets, GFP_ATOMIC);
+	sta->lost_packets = 0;
+}
+
 void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct sk_buff *skb2;
@@ -680,12 +697,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			if (info->flags & IEEE80211_TX_STAT_ACK) {
 				if (sta->lost_packets)
 					sta->lost_packets = 0;
-			} else if (++sta->lost_packets >= STA_LOST_PKT_THRESHOLD) {
-				cfg80211_cqm_pktloss_notify(sta->sdata->dev,
-							    sta->sta.addr,
-							    sta->lost_packets,
-							    GFP_ATOMIC);
-				sta->lost_packets = 0;
+			} else {
+				ieee80211_lost_packet(sta, skb);
 			}
 		}
 
-- 
1.8.5.2 (Apple Git-48)

