Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:56065
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754676AbaKOX2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 18:28:05 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/6] mac80211: minstrel_ht: add a small optimization to minstrel_aggr_check
Date: Sun, 16 Nov 2014 00:27:55 +0100
Message-Id: <1416094080-49220-1-git-send-email-nbd@openwrt.org> (sfid-20141116_002819_017021_519DE13F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the queue mapping earlier, skb->queue_mapping is more likely than
skb->data to still be in d-cache.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index c50fd94..62ff7cf 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -690,6 +690,9 @@ minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	u16 tid;
 
+	if (skb_get_queue_mapping(skb) == IEEE80211_AC_VO)
+		return;
+
 	if (unlikely(!ieee80211_is_data_qos(hdr->frame_control)))
 		return;
 
@@ -700,9 +703,6 @@ minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 	if (likely(sta->ampdu_mlme.tid_tx[tid]))
 		return;
 
-	if (skb_get_queue_mapping(skb) == IEEE80211_AC_VO)
-		return;
-
 	ieee80211_start_tx_ba_session(pubsta, tid, 5000);
 }
 
-- 
2.1.2

