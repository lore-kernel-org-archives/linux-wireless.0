Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaAIMv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 07:51:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: reset TX info flags when frame will be reprocessed
Date: Thu,  9 Jan 2014 13:51:21 +0100
Message-Id: <1389271882-15806-4-git-send-email-johannes@sipsolutions.net> (sfid-20140109_135132_217131_C7FB5878)
In-Reply-To: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net>
References: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The temporary TX info flags need to be cleared if the frame will
be processed through the TX handlers again, otherwise it can get
messed up. This fixes a bug that happened when an aggregation
session was stopped while the station was sleeping - some frames
might get transmitted marked as aggregation erroneously without
this fix.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 377cf97..9f3cbf1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -500,6 +500,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		info->control.jiffies = jiffies;
 		info->control.vif = &tx->sdata->vif;
 		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+		info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
 		skb_queue_tail(&sta->ps_tx_buf[ac], tx->skb);
 
 		if (!timer_pending(&local->sta_cleanup))
@@ -1073,6 +1074,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			queued = true;
 			info->control.vif = &tx->sdata->vif;
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+			info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
 			__skb_queue_tail(&tid_tx->pending, skb);
 			if (skb_queue_len(&tid_tx->pending) > STA_MAX_TX_BUFFER)
 				purge_skb = __skb_dequeue(&tid_tx->pending);
-- 
1.8.5.1

