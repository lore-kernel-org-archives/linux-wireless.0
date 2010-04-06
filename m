Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0DFJWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:22:44 -0400
Message-Id: <20100406092141.471834625@sipsolutions.net>
Date: Tue, 06 Apr 2010 11:18:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] mac80211: remove irq disabling for sta lock
References: <20100406091841.549805267@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All other places except one in the TX path, which
has BHs disabled, and it also cannot be locked from
interrupts so disabling IRQs is not necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2010-04-06 09:07:30.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2010-04-06 09:08:22.000000000 +0200
@@ -1144,13 +1144,12 @@ ieee80211_tx_prepare(struct ieee80211_su
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
 	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
-		unsigned long flags;
 		struct tid_ampdu_tx *tid_tx;
 
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 
-		spin_lock_irqsave(&tx->sta->lock, flags);
+		spin_lock(&tx->sta->lock);
 		/*
 		 * XXX: This spinlock could be fairly expensive, but see the
 		 *	comment in agg-tx.c:ieee80211_agg_tx_operational().
@@ -1175,7 +1174,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			__skb_queue_tail(&tid_tx->pending, skb);
 		}
-		spin_unlock_irqrestore(&tx->sta->lock, flags);
+		spin_unlock(&tx->sta->lock);
 
 		if (unlikely(queued))
 			return TX_QUEUED;


