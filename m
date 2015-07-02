Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33793 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbbGBIAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 04:00:19 -0400
Received: by lbnk3 with SMTP id k3so27008047lbn.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 01:00:17 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: don't clear all tx flags when requeing
Date: Thu,  2 Jul 2015 09:59:56 +0200
Message-Id: <1435823996-32510-1-git-send-email-michal.kazior@tieto.com> (sfid-20150702_100024_538151_41C62EE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When acting as AP and a PS-Poll frame is received
associated station is marked as one in a Service
Period. This state is kept until Tx status for
released frame is reported. While a station is in
Service Period PS-Poll frames are ignored.

However if PS-Poll was received during A-MPDU
teardown it was possible to have the to-be
released frame re-queued back to pending queue.
In such case the frame was stripped of 2 important
flags:

 (a) IEEE80211_TX_CTL_NO_PS_BUFFER
 (b) IEEE80211_TX_STATUS_EOSP

Stripping of (a) led to the frame that was to be
released to be queued back to ps_tx_buf queue. If
station remained to use only PS-Poll frames the
re-queued frame (and new ones) was never actually
transmitted because mac80211 would ignore
subsequent PS-Poll frames due to station being in
Service Period. There was nothing left to clear
the Service Period bit (no xmit -> no tx status ->
no SP end), i.e. the AP would have the station
stuck in Service Period. Beacon TIM would
repeatedly prompt station to poll for frames but
it would get none.

Once (a) is not stripped (b) becomes important
because it's the main condition to clear the
Service Period bit of the station when Tx status
for the released frame is reported back.

This problem was observed with ath9k acting as P2P
GO in some testing scenarios but isn't limited to
it. AP operation with mac80211 based Tx A-MPDU
control combined with clients using PS-Poll frames
is subject to this race.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d14f3618069f..2079d480cd7b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1113,7 +1113,9 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			queued = true;
 			info->control.vif = &tx->sdata->vif;
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
-			info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
+			info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS |
+					IEEE80211_TX_CTL_NO_PS_BUFFER |
+					IEEE80211_TX_STATUS_EOSP;
 			__skb_queue_tail(&tid_tx->pending, skb);
 			if (skb_queue_len(&tid_tx->pending) > STA_MAX_TX_BUFFER)
 				purge_skb = __skb_dequeue(&tid_tx->pending);
-- 
2.1.4

