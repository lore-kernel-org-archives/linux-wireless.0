Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36129 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbcGKNJS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 09:09:18 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix check for buffered powersave frames with txq
Date: Mon, 11 Jul 2016 15:09:15 +0200
Message-Id: <20160711130915.86284-1-nbd@nbd.name> (sfid-20160711_150922_950398_6D140B04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The logic was inverted here, set the bit if frames are pending.

Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue implementation")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9a1eb70..aaa9373 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1268,7 +1268,7 @@ static void sta_ps_start(struct sta_info *sta)
 	for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
 		struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
 
-		if (!txqi->tin.backlog_packets)
+		if (txqi->tin.backlog_packets)
 			set_bit(tid, &sta->txq_buffered_tids);
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
-- 
2.8.4

