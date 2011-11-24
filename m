Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1KXNrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 08:47:42 -0500
Subject: [PATCH] mac80211: fix TX warning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 14:47:36 +0100
Message-ID: <1322142456.5366.18.camel@jlt3.sipsolutions.net> (sfid-20111124_144750_774844_9A02DEA3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Emmanuel reported that my previous patches to enable
handing all fragments to drivers at once triggered
the warning that the SKB queue wasn't empty. This is
happening when we actually queue up some frames and
don't hand them to the driver (queues are stopped).

The reason for it is that my code that splices the
frame(s) over to the pending queue didn't re-init
the local queue, so skb_queue_empty() was false. Fix
this by using the _init versions of the splicing.

Also, convert the warning to WARN_ON_ONCE.

Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/mac80211/tx.c	2011-11-24 09:42:07.000000000 +0100
+++ b/net/mac80211/tx.c	2011-11-24 14:43:09.000000000 +0100
@@ -1223,9 +1223,10 @@ static bool ieee80211_tx_frags(struct ie
 			 * queue is woken again.
 			 */
 			if (txpending)
-				skb_queue_splice(skbs, &local->pending[q]);
+				skb_queue_splice_init(skbs, &local->pending[q]);
 			else
-				skb_queue_splice_tail(skbs, &local->pending[q]);
+				skb_queue_splice_tail_init(skbs,
+							   &local->pending[q]);
 
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 					       flags);
@@ -1297,7 +1298,7 @@ static bool __ieee80211_tx(struct ieee80
 	ieee80211_tpt_led_trig_tx(local, fc, led_len);
 	ieee80211_led_tx(local, 1);
 
-	WARN_ON(!skb_queue_empty(skbs));
+	WARN_ON_ONCE(!skb_queue_empty(skbs));
 
 	return result;
 }


