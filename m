Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47078 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaIYVWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 17:22:23 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/3] mac-hwsim:  don't leak memory on tx failure.
Date: Thu, 25 Sep 2014 14:22:18 -0700
Message-Id: <1411680140-20208-1-git-send-email-greearb@candelatech.com> (sfid-20140925_232227_177632_9B1F32D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It seems previous code did not properly clean up memory
if the packet could not be delivered to user-space.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

I don't have a good way to test this, but hopefully
it is correct.

 drivers/net/wireless/mac80211_hwsim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index babbdc1..a74227d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -862,7 +862,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	if (skb_queue_len(&data->pending) >= MAX_QUEUE) {
 		/* Droping until WARN_QUEUE level */
 		while (skb_queue_len(&data->pending) >= WARN_QUEUE)
-			skb_dequeue(&data->pending);
+			ieee80211_free_txskb(hw, skb_dequeue(&data->pending));
 	}
 
 	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_ATOMIC);
@@ -921,6 +921,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 
 nla_put_failure:
 	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
+	ieee80211_free_txskb(hw, my_skb);
 }
 
 static bool hwsim_chans_compat(struct ieee80211_channel *c1,
-- 
1.7.11.7

