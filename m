Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1LBVIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 16:08:54 -0500
Subject: [PATCH] mac80211: fix retransmit
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 22:08:52 +0100
Message-ID: <1322860132.4124.10.camel@jlt3.sipsolutions.net> (sfid-20111202_220858_735478_5A88636E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This fixes another regression from my "pass all
fragments to driver at once" patches -- if the
packet is being retransmitted then we don't go
through all handlers, but we still need to move
it to the skbs list, otherwise we run into the
first warning in __ieee80211_tx() and leak the
skb.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c	2011-12-02 22:01:28.000000000 +0100
+++ b/net/mac80211/tx.c	2011-12-02 22:05:54.000000000 +0100
@@ -1326,8 +1326,11 @@ static int invoke_tx_handlers(struct iee
 	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
 
-	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION))
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
+		__skb_queue_tail(&tx->skbs, tx->skb);
+		tx->skb = NULL;
 		goto txh_done;
+	}
 
 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
 	CALL_TXH(ieee80211_tx_h_sequence);


