Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0KPXxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 18:53:33 -0500
Received: from johannes by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1PIVLA-00033m-Aq
	for linux-wireless@vger.kernel.org; Wed, 17 Nov 2010 00:53:32 +0100
Subject: [RFC v2 2/2] mac80211: implement packet loss notification
From: Johannes Berg <johannes@sipsolutions.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1289937257.3673.9.camel@jlt3.sipsolutions.net>
References: <1289937257.3673.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 15:55:06 -0800
Message-ID: <1289951706.3673.18.camel@jlt3.sipsolutions.net>
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

--- wireless-testing.orig/net/mac80211/sta_info.h	2010-11-16 11:30:12.000000000 -0800
+++ wireless-testing/net/mac80211/sta_info.h	2010-11-16 14:01:57.000000000 -0800
@@ -248,6 +248,7 @@ enum plink_state {
  * @sta: station information we share with the driver
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
+ * @lost_packets: number of consecutive lost packets
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -335,6 +336,8 @@ struct sta_info {
 	} debugfs;
 #endif
 
+	unsigned int lost_packets;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
--- wireless-testing.orig/net/mac80211/status.c	2010-11-16 11:30:12.000000000 -0800
+++ wireless-testing/net/mac80211/status.c	2010-11-16 15:47:19.000000000 -0800
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


