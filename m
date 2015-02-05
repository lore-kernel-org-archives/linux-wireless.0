Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36478 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbbBENrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 08:47:22 -0500
Received: by mail-ig0-f180.google.com with SMTP id b16so11909826igk.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2015 05:47:22 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] mac80211_hwsim: fix error handling in tx_frame_nl
Date: Thu,  5 Feb 2015 08:45:43 -0500
Message-Id: <1423143943-17526-1-git-send-email-me@bobcopeland.com> (sfid-20150205_144726_031024_F0989A65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct two problems with the error handling when using the netlink
forwarding API: first, the netlink skb is never freed if nla_put()
fails; and second, genlmsg_unicast() can fail if the netlink socket
is full.  In the latter case, the corresponding data skb is not counted
as a drop and userspace programs like wmediumd will see TCP stalls
due to lost packets.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 74f4e1c..1204853 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -947,7 +947,8 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		goto nla_put_failure;
 
 	genlmsg_end(skb, msg_head);
-	genlmsg_unicast(&init_net, skb, dst_portid);
+	if (genlmsg_unicast(&init_net, skb, dst_portid))
+		goto err_free_txskb;
 
 	/* Enqueue the packet */
 	skb_queue_tail(&data->pending, my_skb);
@@ -956,6 +957,8 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	return;
 
 nla_put_failure:
+	nlmsg_free(skb);
+err_free_txskb:
 	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
 	ieee80211_free_txskb(hw, my_skb);
 	data->tx_failed++;
-- 
2.1.4

