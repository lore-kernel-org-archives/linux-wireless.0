Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53276 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbcKDJ17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 05:27:59 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: toke@toke.dk, johannes@sipsolutions.net
Subject: [PATCH 2/3] mac80211: remove bogus skb vif assignment
Date: Fri,  4 Nov 2016 10:27:53 +0100
Message-Id: <20161104092754.91649-2-nbd@nbd.name> (sfid-20161104_102809_288191_B1F098F0)
In-Reply-To: <20161104092754.91649-1-nbd@nbd.name>
References: <20161104092754.91649-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The call to ieee80211_txq_enqueue overwrites the vif pointer with the
codel enqueue time, so setting it just before that call makes no sense.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c380e85..390b425 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1500,7 +1500,6 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 				struct sta_info *sta,
 				struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct fq *fq = &local->fq;
 	struct ieee80211_vif *vif;
 	struct txq_info *txqi;
@@ -1525,8 +1524,6 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	if (!txqi)
 		return false;
 
-	info->control.vif = vif;
-
 	spin_lock_bh(&fq->lock);
 	ieee80211_txq_enqueue(local, txqi, skb);
 	spin_unlock_bh(&fq->lock);
-- 
2.10.1
