Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60725 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728509AbeHMO6s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 10:58:48 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH] mac80211: Run TXQ teardown code before de-registering interfaces
Date: Mon, 13 Aug 2018 14:16:25 +0200
Message-Id: <20180813121625.18367-1-toke@toke.dk> (sfid-20180813_141753_865995_53B23CAB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TXQ teardown code can reference the vif data structures that are
stored in the netdev private memory area if there are still packets on
the queue when it is being freed. Since the TXQ teardown code is run
after the netdevs are freed, this can lead to a use-after-free. Fix this
by moving the TXQ teardown code to earlier in ieee80211_unregister_hw().

Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/mac80211/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e054a2fd8d38..98a5c15e8db1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1170,6 +1170,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 #if IS_ENABLED(CONFIG_IPV6)
 	unregister_inet6addr_notifier(&local->ifa6_notifier);
 #endif
+	ieee80211_txq_teardown_flows(local);
 
 	rtnl_lock();
 
@@ -1198,7 +1199,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
 	skb_queue_purge(&local->skb_queue_tdls_chsw);
-	ieee80211_txq_teardown_flows(local);
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
-- 
2.18.0
