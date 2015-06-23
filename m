Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53454 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469AbbFWJu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 05:50:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: account TX MSDUs properly with segmentation offload
Date: Tue, 23 Jun 2015 11:50:52 +0200
Message-Id: <1435053052-29661-1-git-send-email-johannes@sipsolutions.net> (sfid-20150623_115108_659292_46AA2495)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If an SKB will be segmented by the driver, count it for multiple
MSDUs that are being transmitted rather than just a single.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9489b5da5a46..53d462c84977 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2810,7 +2810,11 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	u64_stats_update_begin(&sta->tx_sync);
 	sta->tx_bytes[skb_get_queue_mapping(skb)] += skb->len;
 	sta->tx_packets[skb_get_queue_mapping(skb)]++;
-	sta->tx_msdu[tid]++;
+	if (skb_shinfo(skb)->gso_size)
+		sta->tx_msdu[tid] +=
+			DIV_ROUND_UP(skb->len, skb_shinfo(skb)->gso_size);
+	else
+		sta->tx_msdu[tid]++;
 	u64_stats_update_end(&sta->tx_sync);
 
 	if (fast_tx->pn_offs) {
-- 
2.1.4

