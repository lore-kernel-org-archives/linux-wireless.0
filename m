Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28685 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYFKSBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 14:01:39 -0400
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: [RFC] do not fragment while aggregation is in use
Date: Wed, 11 Jun 2008 21:01:36 +0300
Message-Id: <1213207296-14548-1-git-send-email-ron.rindjunsky@intel.com> (sfid-20080611_200151_715082_39B3058B)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch denies the use of framentation while ampdu is used.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/tx.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1ad9e66..d4693f6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -658,17 +658,6 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	if (!(tx->flags & IEEE80211_TX_FRAGMENTED))
 		return TX_CONTINUE;
 
-	/*
-	 * Warn when submitting a fragmented A-MPDU frame and drop it.
-	 * This is an error and needs to be fixed elsewhere, but when
-	 * done needs to take care of monitor interfaces (injection)
-	 * etc.
-	 */
-	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
-		    skb_get_queue_mapping(tx->skb) >=
-			ieee80211_num_regular_queues(&tx->local->hw)))
-		return TX_DROP;
-
 	first = tx->skb;
 
 	hdrlen = ieee80211_get_hdrlen(tx->fc);
@@ -981,7 +970,8 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
 		if ((tx->flags & IEEE80211_TX_UNICAST) &&
 		    skb->len + FCS_LEN > local->fragmentation_threshold &&
-		    !local->ops->set_frag_threshold)
+		    !local->ops->set_frag_threshold &&
+		    !(info->flags & IEEE80211_TX_CTL_AMPDU))
 			tx->flags |= IEEE80211_TX_FRAGMENTED;
 		else
 			tx->flags &= ~IEEE80211_TX_FRAGMENTED;
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

