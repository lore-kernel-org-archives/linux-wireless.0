Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62608 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaDNJv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 05:51:57 -0400
Received: by mail-pd0-f178.google.com with SMTP id x10so7859656pdj.23
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 02:51:56 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/6] mac80211: remove config option check
Date: Mon, 14 Apr 2014 17:51:31 +0800
Message-Id: <ad0e43bccb39bdc9139601059ca014278ef0aba9.1397469036.git.gamerh2o@gmail.com> (sfid-20140414_115402_530518_B0AC68E8)
In-Reply-To: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
References: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
In-Reply-To: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
References: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sanity check and error handling code shouldn't be put into
CONFIG_MAC80211_VERBOSE_DEBUG block, since verbose debug option is
used to control whether to print debug messages.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/tx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 48650da..59715da 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1205,13 +1205,11 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		int q = info->hw_queue;
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (WARN_ON_ONCE(q >= local->hw.queues)) {
 			__skb_unlink(skb, skbs);
 			ieee80211_free_txskb(&local->hw, skb);
 			continue;
 		}
-#endif
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		if (local->queue_stop_reasons[q] ||
-- 
1.9.0

