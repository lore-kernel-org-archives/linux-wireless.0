Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:61814 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaIDFcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 01:32:12 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: add TDLS connection timeout
Date: Thu,  4 Sep 2014 08:28:40 +0300
Message-Id: <1409808520-905-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140904_073215_922441_ACFA42A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Adding a timeout for tearing down a TDLS connection that
hasn't had ACKed traffic sent through it for a certain
amount of time.

Since we have no other monitoring facility to indicate the
existance (or non-existance) of a peer, this patch will
cause a peer to be considered as unavailable if for some X
time at least some Y packets have all not been ACKed.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/sta_info.h |  3 +++
 net/mac80211/status.c   | 21 ++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index edd6b88..cfabdde 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -449,6 +449,9 @@ struct sta_info {
 	enum ieee80211_smps_mode known_smps_mode;
 	const struct ieee80211_cipher_scheme *cipher_scheme;
 
+	/* TDLS timeout data */
+	unsigned long last_tdls_pkt_time;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 2800e1c..89290e3 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -538,6 +538,8 @@ static void ieee80211_tx_latency_end_msrmnt(struct ieee80211_local *local,
  *  - current throughput (higher value for higher tpt)?
  */
 #define STA_LOST_PKT_THRESHOLD	50
+#define STA_LOST_TDLS_PKT_THRESHOLD	10
+#define STA_LOST_TDLS_PKT_TIME		(10*HZ) /* 10secs since last ACK */
 
 static void ieee80211_lost_packet(struct sta_info *sta, struct sk_buff *skb)
 {
@@ -548,7 +550,20 @@ static void ieee80211_lost_packet(struct sta_info *sta, struct sk_buff *skb)
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	if (++sta->lost_packets < STA_LOST_PKT_THRESHOLD)
+	sta->lost_packets++;
+	if (!sta->sta.tdls && sta->lost_packets < STA_LOST_PKT_THRESHOLD)
+		return;
+
+	/*
+	 * If we're in TDLS mode, make sure that all STA_LOST_TDLS_PKT_THRESHOLD
+	 * of the last packets were lost, and that no ACK was received in the
+	 * last STA_LOST_TDLS_PKT_TIME ms, before triggering the CQM packet-loss
+	 * mechanism.
+	 */
+	if (sta->sta.tdls &&
+	    (sta->lost_packets < STA_LOST_TDLS_PKT_THRESHOLD ||
+	     time_before(jiffies,
+			 sta->last_tdls_pkt_time + STA_LOST_TDLS_PKT_TIME)))
 		return;
 
 	cfg80211_cqm_pktloss_notify(sta->sdata->dev, sta->sta.addr,
@@ -695,6 +710,10 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			if (info->flags & IEEE80211_TX_STAT_ACK) {
 				if (sta->lost_packets)
 					sta->lost_packets = 0;
+
+				/* Track when last TDLS packet was ACKed */
+				if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
+					sta->last_tdls_pkt_time = jiffies;
 			} else {
 				ieee80211_lost_packet(sta, skb);
 			}
-- 
1.9.1

