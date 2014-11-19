Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:59377
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756319AbaKSTIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 14:08:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 5/7] mac80211: pass tx info to ieee80211_lost_packet instead of an skb
Date: Wed, 19 Nov 2014 20:08:11 +0100
Message-Id: <1416424093-19439-5-git-send-email-nbd@openwrt.org> (sfid-20141119_200819_270416_0C760865)
In-Reply-To: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
References: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/status.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9612d89..ba35a44 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -541,10 +541,9 @@ static void ieee80211_tx_latency_end_msrmnt(struct ieee80211_local *local,
 #define STA_LOST_TDLS_PKT_THRESHOLD	10
 #define STA_LOST_TDLS_PKT_TIME		(10*HZ) /* 10secs since last ACK */
 
-static void ieee80211_lost_packet(struct sta_info *sta, struct sk_buff *skb)
+static void ieee80211_lost_packet(struct sta_info *sta,
+				  struct ieee80211_tx_info *info)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
 	/* This packet was aggregated but doesn't carry status info */
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
@@ -716,7 +715,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 				if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
 					sta->last_tdls_pkt_time = jiffies;
 			} else {
-				ieee80211_lost_packet(sta, skb);
+				ieee80211_lost_packet(sta, info);
 			}
 		}
 
-- 
2.1.2

