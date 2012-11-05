Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42864 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2KEIZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 03:25:45 -0500
Received: by mail-wi0-f172.google.com with SMTP id hq12so2884341wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2012 00:25:43 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>, stable@kernel.org
Subject: [PATCH] mac80211: sync acccess to tx_filtered/ps_tx_buf queues
Date: Mon,  5 Nov 2012 10:25:39 +0200
Message-Id: <1352103939-7126-1-git-send-email-arik@wizery.com> (sfid-20121105_092558_881354_A497A926)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are accessed without a lock when ending STA PSM. If the
sta_cleanup timer accesses these lists at the same time, we might crash.

This may fix some mysterious crashes we had during
ieee80211_sta_ps_deliver_wakeup.

Cc: stable@kernel.org
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 net/mac80211/sta_info.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f7bb54f..f14655f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -982,6 +982,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff_head pending;
 	int filtered = 0, buffered = 0, ac;
+	unsigned long flags;
 
 	clear_sta_flag(sta, WLAN_STA_SP);
 
@@ -997,12 +998,16 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		int count = skb_queue_len(&pending), tmp;
 
+		spin_lock_irqsave(&sta->tx_filtered[ac].lock, flags);
 		skb_queue_splice_tail_init(&sta->tx_filtered[ac], &pending);
+		spin_unlock_irqrestore(&sta->tx_filtered[ac].lock, flags);
 		tmp = skb_queue_len(&pending);
 		filtered += tmp - count;
 		count = tmp;
 
+		spin_lock_irqsave(&sta->ps_tx_buf[ac].lock, flags);
 		skb_queue_splice_tail_init(&sta->ps_tx_buf[ac], &pending);
+		spin_unlock_irqrestore(&sta->ps_tx_buf[ac].lock, flags);
 		tmp = skb_queue_len(&pending);
 		buffered += tmp - count;
 	}
-- 
1.7.9.5

