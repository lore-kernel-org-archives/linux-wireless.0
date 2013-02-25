Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54150 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab3BYU6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 15:58:10 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Ensure off-channel frames don't get queued
Date: Mon, 25 Feb 2013 14:58:05 -0600
Message-Id: <1361825885-13520-1-git-send-email-seth.forshee@canonical.com> (sfid-20130225_215815_269165_8291A5F8)
In-Reply-To: <20130225192629.GH13296@thinkpad-t410>
References: <20130225192629.GH13296@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 6c17b77b67587b9f9e3070fb89fe98cef3187131 (mac80211: Fix tx queue
handling during scans) contains a bug that causes off-channel frames to
get queued when they should be handed down to the driver for transmit.
Prevent this from happening.

Reported-by: Fabio Rossi <rossi.f@inwind.it>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---

Fabio, this patch should fix the problem. Can you verify?

Johannes, this prevents the off-channel frames from getting queued
without affecting the fast path. It does however make the indentation
awfully deep ...

 net/mac80211/tx.c |   56 +++++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b9602b..b1296e7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1231,34 +1231,40 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		if (local->queue_stop_reasons[q] ||
 		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
 			if (unlikely(info->flags &
-					IEEE80211_TX_INTFL_OFFCHAN_TX_OK &&
-				     local->queue_stop_reasons[q] &
-					~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL))) {
+				     IEEE80211_TX_INTFL_OFFCHAN_TX_OK)) {
+				if (local->queue_stop_reasons[q] &
+				    ~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL)) {
+					/*
+					 * Drop off-channel frames if queues
+					 * are stopped for any reason other
+					 * than off-channel operation. Never
+					 * queue them.
+					 */
+					spin_unlock_irqrestore(
+						&local->queue_stop_reason_lock,
+						flags);
+					ieee80211_purge_tx_queue(&local->hw,
+								 skbs);
+					return true;
+				}
+			} else {
+
 				/*
-				 * Drop off-channel frames if queues are stopped
-				 * for any reason other than off-channel
-				 * operation. Never queue them.
+				 * Since queue is stopped, queue up frames for
+				 * later transmission from the tx-pending
+				 * tasklet when the queue is woken again.
 				 */
-				spin_unlock_irqrestore(
-					&local->queue_stop_reason_lock, flags);
-				ieee80211_purge_tx_queue(&local->hw, skbs);
-				return true;
+				if (txpending)
+					skb_queue_splice_init(skbs,
+							      &local->pending[q]);
+				else
+					skb_queue_splice_tail_init(skbs,
+								   &local->pending[q]);
+
+				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
+						       flags);
+				return false;
 			}
-
-			/*
-			 * Since queue is stopped, queue up frames for later
-			 * transmission from the tx-pending tasklet when the
-			 * queue is woken again.
-			 */
-			if (txpending)
-				skb_queue_splice_init(skbs, &local->pending[q]);
-			else
-				skb_queue_splice_tail_init(skbs,
-							   &local->pending[q]);
-
-			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
-					       flags);
-			return false;
 		}
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
-- 
1.7.9.5

