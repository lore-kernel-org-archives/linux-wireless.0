Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030436AbcCQOvq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 10:51:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] mac80211: don't send deferred frames outside the SP
Date: Thu, 17 Mar 2016 16:51:41 +0200
Message-Id: <1458226302-6086-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_155149_762456_E401AB24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames that are sent between
ampdu_action(IEEE80211_AMPDU_TX_START) and the move to the
HT_AGG_STATE_OPERATIONAL state are buffered.
If we try to start an A-MPDU session while the peer is
sleeping and polling frames with U-APSD, we may have frames
that will be buffered by ieee80211_tx_prep_agg. These frames
have IEEE80211_TX_CTL_NO_PS_BUFFER set since they are sent to
a sleeping client and possibly IEEE80211_TX_STATUS_EOSP.
If the frame is buffered, we need clear these two flags
since they will be re-sent after the move to
HT_AGG_STATE_OPERATIONAL state which is very likely to
happen after the SP ends.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 485e30a..114509a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1118,9 +1118,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			queued = true;
 			info->control.vif = &tx->sdata->vif;
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
-			info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS |
-					IEEE80211_TX_CTL_NO_PS_BUFFER |
-					IEEE80211_TX_STATUS_EOSP;
+			info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
 			__skb_queue_tail(&tid_tx->pending, skb);
 			if (skb_queue_len(&tid_tx->pending) > STA_MAX_TX_BUFFER)
 				purge_skb = __skb_dequeue(&tid_tx->pending);
-- 
2.5.0

