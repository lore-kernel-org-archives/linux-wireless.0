Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47365 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab2CGQUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 11:20:44 -0500
Received: by bkcik5 with SMTP id ik5so5379493bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 08:20:43 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Limit TID buffering during BA session setup/teardown
Date: Wed,  7 Mar 2012 17:20:30 +0100
Message-Id: <1331137230-12430-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120307_172048_123618_731B3CE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While setting up or tearing down a BA session mac80211 is buffering
pending frames for the according TID. However, there's currently no
limit on how many frames are buffered possibly leading to an out-of-
memory situation. This can happen on systems with little memory when
the CPU is fully loaded since the BA session work is executed in
process context while frames can still come via softirq.

Apply a limitation to the TIDs pending queue to avoid consuming
too much memory in this situation.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/tx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1be0ca2..4b07828 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1060,6 +1060,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 {
 	bool queued = false;
 	bool reset_agg_timer = false;
+	struct sk_buff *purge_skb = NULL;
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 		info->flags |= IEEE80211_TX_CTL_AMPDU;
@@ -1101,8 +1102,13 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			info->control.vif = &tx->sdata->vif;
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			__skb_queue_tail(&tid_tx->pending, skb);
+			if (skb_queue_len(&tid_tx->pending) > STA_MAX_TX_BUFFER)
+				purge_skb = __skb_dequeue(&tid_tx->pending);
 		}
 		spin_unlock(&tx->sta->lock);
+
+		if (purge_skb)
+			dev_kfree_skb(purge_skb);
 	}
 
 	/* reset session timer */
-- 
1.7.7

