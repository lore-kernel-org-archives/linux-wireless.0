Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0KXHN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 02:13:28 -0500
Message-Id: <20101124071042.955398599@sipsolutions.net>
Date: Wed, 24 Nov 2010 08:10:06 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: implement packet loss notification
References: <20101124071004.597318320@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For drivers that have accurate TX status reporting
we can report the number of consecutive lost packets
to userspace using the new cfg80211 CQM event. The
threshold is fixed right now, this may need to be
improved in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: don't send event on every packet

 net/mac80211/sta_info.h |    3 +++
 net/mac80211/status.c   |   22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- wireless-testing.orig/net/mac80211/sta_info.h	2010-11-23 10:36:12.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2010-11-24 08:09:23.000000000 +0100
@@ -250,6 +250,7 @@ enum plink_state {
  * @sta: station information we share with the driver
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
+ * @lost_packets: number of consecutive lost packets
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -338,6 +339,8 @@ struct sta_info {
 	} debugfs;
 #endif
 
+	unsigned int lost_packets;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
--- wireless-testing.orig/net/mac80211/status.c	2010-11-23 10:36:12.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2010-11-24 08:09:23.000000000 +0100
@@ -157,6 +157,15 @@ static void ieee80211_frame_acked(struct
 	}
 }
 
+/*
+ * Use a static threshold for now, best value to be determined
+ * by testing ...
+ * Should it depend on:
+ *  - on # of retransmissions
+ *  - current throughput (higher value for higher tpt)?
+ */
+#define STA_LOST_PKT_THRESHOLD	50
+
 void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct sk_buff *skb2;
@@ -243,6 +252,19 @@ void ieee80211_tx_status(struct ieee8021
 		if (!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 		    (info->flags & IEEE80211_TX_STAT_ACK))
 			ieee80211_frame_acked(sta, skb);
+
+		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+			if (info->flags & IEEE80211_TX_STAT_ACK) {
+				if (sta->lost_packets)
+					sta->lost_packets = 0;
+			} else if (++sta->lost_packets >= STA_LOST_PKT_THRESHOLD) {
+				cfg80211_cqm_pktloss_notify(sta->sdata->dev,
+							    sta->sta.addr,
+							    sta->lost_packets,
+							    GFP_ATOMIC);
+				sta->lost_packets = 0;
+			}
+		}
 	}
 
 	rcu_read_unlock();


