Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43982 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2E2XDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 19:03:04 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Limit number of pending skbs.
Date: Tue, 29 May 2012 16:02:56 -0700
Message-Id: <1338332576-26427-1-git-send-email-greearb@candelatech.com> (sfid-20120530_010307_951347_5F9829F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Current code will allow any number of pending skbs, and
this can OOM the system when used with something like
the pktgen tool (which may not back off properly if
queue is stopped).

Possibly this is just a bug in our version of pktgen,
but either way, it seems reasonable to add a limit
so that it is not possible to go OOM in this manner.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Tested against 3.3.7+, but patch applies clean to wireless-testing.

:100644 100644 020d3ad... c40bd42... M	net/mac80211/tx.c
 net/mac80211/tx.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 020d3ad..c40bd42 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -33,6 +33,17 @@
 #include "wpa.h"
 #include "wme.h"
 #include "rate.h"
+#include <linux/moduleparam.h>
+
+/*
+ * Maximum number of skbs that may be queued in a pending
+ * queue.  After that, packets will just be dropped.
+ */
+static int max_pending_qsize = 1000;
+module_param(max_pending_qsize, int, 0644);
+MODULE_PARM_DESC(max_pending_qsize,
+		 "Maximum number of skbs that may be queued in a pending queue.");
+
 
 /* misc utils */
 
@@ -1216,12 +1227,19 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			 * transmission from the tx-pending tasklet when the
 			 * queue is woken again.
 			 */
-			if (txpending)
+			if (txpending) {
 				skb_queue_splice_init(skbs, &local->pending[q]);
-			else
-				skb_queue_splice_tail_init(skbs,
-							   &local->pending[q]);
-
+			} else {
+				u32 len = skb_queue_len(&local->pending[q]);
+				if (len >= max_pending_qsize) {
+					__skb_unlink(skb, skbs);
+					dev_kfree_skb(skb);
+					/* TODO:  Add counter for this */
+				} else {
+					skb_queue_splice_tail_init(skbs,
+								   &local->pending[q]);
+				}
+			}
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 					       flags);
 			return false;
-- 
1.7.3.4

