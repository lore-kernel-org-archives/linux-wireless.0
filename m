Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46618 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755273AbcH1LKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Aug 2016 07:10:48 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix tim recalculation after PS response
Date: Sun, 28 Aug 2016 13:10:37 +0200
Message-Id: <20160828111037.46801-1-nbd@nbd.name> (sfid-20160828_131052_076308_52755F86)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle the case where the mac80211 intermediate queues are empty and the
driver has buffered frames

Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue implementation")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/sta_info.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 19f14c9..251e14e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1616,7 +1616,6 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 
 		sta_info_recalc_tim(sta);
 	} else {
-		unsigned long tids = sta->txq_buffered_tids & driver_release_tids;
 		int tid;
 
 		/*
@@ -1648,7 +1647,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
 
-			if (!(tids & BIT(tid)) || txqi->tin.backlog_packets)
+			if (!(driver_release_tids & BIT(tid)) ||
+			    txqi->tin.backlog_packets)
 				continue;
 
 			sta_info_recalc_tim(sta);
-- 
2.8.4
