Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59676 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYGCBfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 21:35:08 -0400
Date: Wed, 02 Jul 2008 20:36:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: stable@kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [stable PATCH] mac80211: detect driver tx bugs
Message-ID: <486c2d1f.ntPY4RgDHDbYfPvX%Larry.Finger@lwfinger.net> (sfid-20080703_103136_032545_855F2477)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a driver rejects a frame in it's ->tx() callback, it must also
stop queues, otherwise mac80211 can go into a loop here. Detect this
situation and abort the loop after five retries, warning about the
driver bug.

This patch was added to mainline as
commit ef3a62d272f033989e83eb1f26505f93f93e3e69.

Thanks to Larry Finger <Larry.Finger@lwfinger.net> for doing the -stable
port.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---

 tx.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/net/mac80211/tx.c
===================================================================
--- linux-2.6.orig/net/mac80211/tx.c
+++ linux-2.6/net/mac80211/tx.c
@@ -1090,7 +1090,7 @@ static int ieee80211_tx(struct net_devic
 	ieee80211_tx_handler *handler;
 	struct ieee80211_txrx_data tx;
 	ieee80211_txrx_result res = TXRX_DROP, res_prepare;
-	int ret, i;
+	int ret, i, retries = 0;
 
 	WARN_ON(__ieee80211_queue_pending(local, control->queue));
 
@@ -1181,6 +1181,13 @@ retry:
 		if (!__ieee80211_queue_stopped(local, control->queue)) {
 			clear_bit(IEEE80211_LINK_STATE_PENDING,
 				  &local->state[control->queue]);
+			retries++;
+			/*
+			 * Driver bug, it's rejecting packets but
+			 * not stopping queues.
+			 */
+			if (WARN_ON_ONCE(retries > 5))
+				goto drop;
 			goto retry;
 		}
 		memcpy(&store->control, control,

