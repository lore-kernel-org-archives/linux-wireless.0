Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXLRMko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 07:40:44 -0500
Subject: [PATCH] mac80211: allow easier multicast/broadcast buffering in
	hardware
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 12:22:36 +0100
Message-Id: <1197976956.4885.108.camel@johannes.berg> (sfid-20071218_124047_183641_329DFC26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are various decisions influencing the decision whether to buffer
a frame for after the next DTIM beacon. The "do we have stations in PS
mode" condition cannot be tested by the driver so mac80211 has to do
that. To ease driver writing for hardware that can buffer frames until
after the next DTIM beacon, introduce a new txctl flag telling the
driver to buffer a specific frame.

While at it, restructure and comment the code for multicast buffering
and remove spurious "inline" directives.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/tx.c      |   32 +++++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 9 deletions(-)

--- everything.orig/include/net/mac80211.h	2007-12-18 12:12:54.499237521 +0100
+++ everything/include/net/mac80211.h	2007-12-18 12:13:14.059236709 +0100
@@ -307,6 +307,8 @@ struct ieee80211_tx_control {
 						  * using the through
 						  * set_retry_limit configured
 						  * long retry value */
+#define IEEE80211_TXCTL_SEND_AFTER_DTIM	(1<<11) /* send this frame after DTIM
+						 * beacon */
 	u32 flags;			       /* tx control flags defined
 						* above */
 	u8 key_idx;		/* keyidx from hw->set_key(), undefined if
--- everything.orig/net/mac80211/tx.c	2007-12-18 12:12:52.599237522 +0100
+++ everything/net/mac80211/tx.c	2007-12-18 12:14:40.249236979 +0100
@@ -337,16 +337,27 @@ static void purge_old_ps_buffers(struct 
 	       wiphy_name(local->hw.wiphy), purged);
 }
 
-static inline ieee80211_txrx_result
+static ieee80211_txrx_result
 ieee80211_tx_h_multicast_ps_buf(struct ieee80211_txrx_data *tx)
 {
-	/* broadcast/multicast frame */
-	/* If any of the associated stations is in power save mode,
-	 * the frame is buffered to be sent after DTIM beacon frame */
-	if ((tx->local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING) &&
-	    tx->sdata->type != IEEE80211_IF_TYPE_WDS &&
-	    tx->sdata->bss && atomic_read(&tx->sdata->bss->num_sta_ps) &&
-	    !(tx->fc & IEEE80211_FCTL_ORDER)) {
+	/*
+	 * broadcast/multicast frame
+	 *
+	 * If any of the associated stations is in power save mode,
+	 * the frame is buffered to be sent after DTIM beacon frame.
+	 * This is done either by the hardware or us.
+	 */
+
+	/* not AP/IBSS or ordered frame */
+	if (!tx->sdata->bss || (tx->fc & IEEE80211_FCTL_ORDER))
+		return TXRX_CONTINUE;
+
+	/* no stations in PS mode */
+	if (!atomic_read(&tx->sdata->bss->num_sta_ps))
+		return TXRX_CONTINUE;
+
+	/* buffered in mac80211 */
+	if (tx->local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING) {
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
 			purge_old_ps_buffers(tx->local);
 		if (skb_queue_len(&tx->sdata->bss->ps_bc_buf) >=
@@ -363,10 +374,13 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 		return TXRX_QUEUED;
 	}
 
+	/* buffered in hardware */
+	tx->u.tx.control->flags |= IEEE80211_TXCTL_SEND_AFTER_DTIM;
+
 	return TXRX_CONTINUE;
 }
 
-static inline ieee80211_txrx_result
+static ieee80211_txrx_result
 ieee80211_tx_h_unicast_ps_buf(struct ieee80211_txrx_data *tx)
 {
 	struct sta_info *sta = tx->sta;


