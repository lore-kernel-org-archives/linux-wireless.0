Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47980 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaDUEyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:54:54 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so3333948pab.36
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:54:53 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 02/12] mac80211: remove config option check
Date: Mon, 21 Apr 2014 12:52:57 +0800
Message-Id: <3ed41ac7f29b74d7cfc81c42715cf2dc1706066c.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065458_432824_49A38723)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
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

