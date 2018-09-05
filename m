Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:54012 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbeIEOwx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 10:52:53 -0400
Received: by mail-it0-f65.google.com with SMTP id p79-v6so9153644itp.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2018 03:23:19 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>
Subject: [PATCH] mac80211: fix pending queue hang due to TX_DROP
Date: Wed,  5 Sep 2018 06:22:59 -0400
Message-Id: <20180905102259.16089-1-me@bobcopeland.com> (sfid-20180905_122324_321631_0CE0198B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In our environment running lots of mesh nodes, we are seeing the
pending queue hang periodically, with the debugfs queues file showing
lines such as:

    00: 0x00000000/348

i.e. there are a large number of frames but no stop reason set.

One way this could happen is if queue processing from the pending
tasklet exited early without processing all frames, and without having
some future event (incoming frame, stop reason flag, ...) to reschedule
it.

Exactly this can occur today if ieee80211_tx() returns false due to
packet drops or power-save buffering in the tx handlers.  In the
past, this function would return true in such cases, and the change
to false doesn't seem to be intentional.  Fix this case by reverting
to the previous behavior.

Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
Signed-off-by: Bob Copeland <bobcopeland@fb.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e88547842239..6b83dc397c3e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1907,7 +1907,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
 
 	if (invoke_tx_handlers_early(&tx))
-		return false;
+		return true;
 
 	if (ieee80211_queue_skb(local, sdata, tx.sta, tx.skb))
 		return true;
-- 
2.11.0
