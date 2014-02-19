Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbaBSM0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 07:26:18 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] mac80211: protect skb_queue_len(&ps->bc_buf) by lock
Date: Wed, 19 Feb 2014 13:28:36 +0100
Message-Id: <1392812916-13656-2-git-send-email-sgruszka@redhat.com> (sfid-20140219_132640_116619_301F3112)
In-Reply-To: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar change as on current patch "mac80211: fix calling
ieee80211_free_txskb with NULL skb", but for multicast queue. Patch does
not prevent crash, as dev_kfree_skb() checks against NULL skb, but it
help to prevent not necessary frame drop, when bc_buf queue was
partially flushed and no longer exceeds AP_MAX_BC_BUFFER .

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/tx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 85b9b8e..78bca8a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -387,6 +387,8 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ps_data *ps;
+	struct sk_buff *old_skb = NULL;
+	unsigned long flags;
 
 	/*
 	 * broadcast/multicast frame
@@ -432,6 +434,13 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 		purge_old_ps_buffers(tx->local);
 
 	if (skb_queue_len(&ps->bc_buf) >= AP_MAX_BC_BUFFER) {
+		spin_lock_irqsave(&ps->bc_buf.lock, flags);
+		/* queue could be modified, recheck length with lock taken */
+		if (skb_queue_len(&ps->bc_buf) >= AP_MAX_BC_BUFFER)
+			old_skb = __skb_dequeue(&ps->bc_buf);
+		spin_unlock_irqrestore(&ps->bc_buf.lock, flags);
+	}
+	if (old_skb) {
 		ps_dbg(tx->sdata,
 		       "BC TX buffer full - dropping the oldest frame\n");
 		dev_kfree_skb(skb_dequeue(&ps->bc_buf));
-- 
1.7.11.7

