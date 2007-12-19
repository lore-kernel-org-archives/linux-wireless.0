Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbXLSPrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:47:35 -0500
Message-Id: <20071219003237.639184000@sipsolutions.net> (sfid-20071219_154758_033460_58AA60BD)
References: <20071219003121.508296000@sipsolutions.net>
Date: Wed, 19 Dec 2007 01:31:25 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 4/6]  mac80211: allow easier multicast/broadcast buffering
	in hardware
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

--- everything.orig/include/net/mac80211.h	2007-12-19 00:42:11.913023383 +0100
+++ everything/include/net/mac80211.h	2007-12-19 00:49:47.343023166 +0100
@@ -308,6 +308,8 @@ struct ieee80211_tx_control {
 						  * set_retry_limit configured
 						  * long retry value */
 #define IEEE80211_TXCTL_EAPOL_FRAME	(1<<11) /* internal to mac80211 */
+#define IEEE80211_TXCTL_SEND_AFTER_DTIM	(1<<12) /* send this frame after DTIM
+						 * beacon */
 	u32 flags;			       /* tx control flags defined
 						* above */
 	u8 key_idx;		/* keyidx from hw->set_key(), undefined if
--- everything.orig/net/mac80211/tx.c	2007-12-19 00:46:23.673022786 +0100
+++ everything/net/mac80211/tx.c	2007-12-19 00:49:31.823024413 +0100
@@ -322,16 +322,27 @@ static void purge_old_ps_buffers(struct 
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
@@ -348,10 +359,13 @@ ieee80211_tx_h_multicast_ps_buf(struct i
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

-- 

