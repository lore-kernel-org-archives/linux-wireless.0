Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40035 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbbBJSZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 13:25:44 -0500
From: greearb@candelatech.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211-hwsim:  Don't enqueue pkts that do not want txstatus.
Date: Tue, 10 Feb 2015 10:25:32 -0800
Message-Id: <1423592732-17256-1-git-send-email-greearb@candelatech.com> (sfid-20150210_192547_065149_EEE78AA4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, skb is not cleaned up until there is some timeout
and the tx-queue quickly becomes overly full.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is against 3.17.8+ kernel...it looks like same problem is in
the 3.19.0-rc7 kernel as well.

 drivers/net/wireless/mac80211_hwsim.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 989a6ba..7ea8948 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -928,10 +928,14 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	genlmsg_end(skb, msg_head);
 	genlmsg_unicast(&init_net, skb, dst_portid);
 
-	/* Enqueue the packet */
-	skb_queue_tail(&data->pending, my_skb);
 	data->tx_pkts++;
 	data->tx_bytes += my_skb->len;
+
+	/* Enqueue the packet if we are expecting a tx-status response */
+	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
+		skb_queue_tail(&data->pending, my_skb);
+	else
+		ieee80211_free_txskb(hw, my_skb);
 	return;
 
 nla_put_failure:
-- 
1.7.11.7

