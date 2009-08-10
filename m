Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbZHJOEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 10:04:45 -0400
Subject: [PATCH] mac80211: small tx code cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 16:04:15 +0200
Message-Id: <1249913055.32614.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's really easier to read if it's not indented
as much, so invert the condition and rearrange
the code so the smaller chunk is indented instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-08-10 13:38:28.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-08-10 13:39:32.000000000 +0200
@@ -317,30 +317,30 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 	if (!atomic_read(&tx->sdata->bss->num_sta_ps))
 		return TX_CONTINUE;
 
+	/* buffered in hardware */
+	if (!(tx->local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING)) {
+		info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
+
+		return TX_CONTINUE;
+	}
+
 	/* buffered in mac80211 */
-	if (tx->local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING) {
-		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
-			purge_old_ps_buffers(tx->local);
-		if (skb_queue_len(&tx->sdata->bss->ps_bc_buf) >=
-		    AP_MAX_BC_BUFFER) {
+	if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
+		purge_old_ps_buffers(tx->local);
+
+	if (skb_queue_len(&tx->sdata->bss->ps_bc_buf) >= AP_MAX_BC_BUFFER) {
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-			if (net_ratelimit()) {
-				printk(KERN_DEBUG "%s: BC TX buffer full - "
-				       "dropping the oldest frame\n",
-				       tx->dev->name);
-			}
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: BC TX buffer full - dropping the oldest frame\n",
+			       tx->dev->name);
 #endif
-			dev_kfree_skb(skb_dequeue(&tx->sdata->bss->ps_bc_buf));
-		} else
-			tx->local->total_ps_buffered++;
-		skb_queue_tail(&tx->sdata->bss->ps_bc_buf, tx->skb);
-		return TX_QUEUED;
-	}
+		dev_kfree_skb(skb_dequeue(&tx->sdata->bss->ps_bc_buf));
+	} else
+		tx->local->total_ps_buffered++;
 
-	/* buffered in hardware */
-	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
+	skb_queue_tail(&tx->sdata->bss->ps_bc_buf, tx->skb);
 
-	return TX_CONTINUE;
+	return TX_QUEUED;
 }
 
 static int ieee80211_use_mfp(__le16 fc, struct sta_info *sta,


