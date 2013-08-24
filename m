Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:34757 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562Ab3HXQAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Aug 2013 12:00:15 -0400
Date: Sat, 24 Aug 2013 19:00:03 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: mac80211 kernel panic due to invalid cab_queue value with hwsim
Message-ID: <20130824160003.GA15926@w1.fi> (sfid-20130824_180422_855739_01A185FA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Something is cab_queue handling is broken (and has been broken for a
while) in mac80211. At least mac80211_hwsim shows this, but I guess it
could happen with some other drivers, too. The error shows up as
group-addressed Data frames from a P2P GO not being transmitted if
CONFIG_MAC80211_VERBOSE_DEBUG is defined and kernel panic if that is not
defined. ieee80211_tx_h_multicast_ps_buf() can assign
IEEE80211_INVAL_HW_QUEUE (0xff) into info->hw_queue in some cases and
that results in the issues in ieee80211_tx_frags where q >=
local->hw.queues check is done only with verbose debugging enabled. If
that check is not there, kernel panic shows up at least in
skb_queue_splice_tail_init() when that invalid hw_queue 0xff value is
used to index the local->pending array.

I'm not sure where cab_queue should be cleared to avoid this, but for
now, I'm using following workaround to avoid the symptoms:


diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 098ae85..41655a4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -413,8 +413,13 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (ieee80211_has_order(hdr->frame_control))
 		return TX_CONTINUE;
 
-	if (tx->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
-		info->hw_queue = tx->sdata->vif.cab_queue;
+	if (tx->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL) {
+		if (tx->sdata->vif.cab_queue == IEEE80211_INVAL_HW_QUEUE) {
+			printk(KERN_DEBUG "%s:trying to assign invalid cab_queue for skb %p vif.type=%d\n",
+			       __func__, tx->skb, tx->sdata->vif.type);
+		} else
+			info->hw_queue = tx->sdata->vif.cab_queue;
+	}
 
 	/* no stations in PS mode */
 	if (!atomic_read(&ps->num_sta_ps))

-- 
Jouni Malinen                                            PGP id EFC895FA
