Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24381 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbZKRGJq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 01:09:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 22:09:52 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19203.36926.787342.765046@gargle.gargle.HOWL>
Date: Wed, 18 Nov 2009 11:42:14 +0530
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix panic in aggregation handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not assigning the vif pointer causes an oops.
This patch fixes it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/agg-tx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 6ddd114..26d42e8 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -489,6 +489,7 @@ void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
 	memcpy(&ra_tid->ra, ra, ETH_ALEN);
 	ra_tid->tid = tid;
+	ra_tid->vif = vif;
 
 	skb->pkt_type = IEEE80211_ADDBA_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
@@ -625,6 +626,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
 	memcpy(&ra_tid->ra, ra, ETH_ALEN);
 	ra_tid->tid = tid;
+	ra_tid->vif = vif;
 
 	skb->pkt_type = IEEE80211_DELBA_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
-- 
1.6.5.2

