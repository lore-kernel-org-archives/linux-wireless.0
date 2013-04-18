Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f175.google.com ([209.85.210.175]:64147 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3DRW1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 18:27:21 -0400
Received: by mail-ia0-f175.google.com with SMTP id e16so2929929iaa.34
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 15:27:20 -0700 (PDT)
Date: Thu, 18 Apr 2013 18:26:49 -0400
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: [PATCH v2] mac80211: use synchronize_rcu() with rcu_barrier()
Message-ID: <20130418222649.GC3759@localhost> (sfid-20130419_002724_768379_B1251428)
References: <20130418220443.GB3759@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130418220443.GB3759@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RCU docs used to state that rcu_barrier() included a wait
for an RCU grace period; however the comments for rcu_barrier()
as of commit f0a0e6f... "rcu: Clarify memory-ordering properties
of grace-period primitives" contradict this.

So add back synchronize_{rcu,net}() to where they once were,
but keep the rcu_barrier()s for the call_rcu() callbacks.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bob Copeland <bob@cozybit.com>

---
v2: also in cfg.c

 net/mac80211/cfg.c   |    1 +
 net/mac80211/iface.c |    5 +++--
 net/mac80211/pm.c    |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 72ab1c0..dcffca4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1043,6 +1043,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		sta_info_flush_defer(vlan);
 	sta_info_flush_defer(sdata);
+	synchronize_net();
 	rcu_barrier();
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
 		sta_info_flush_cleanup(vlan);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b6abaaa..c634aff 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -836,11 +836,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		 *
 		 * sta_info_flush_cleanup() requires rcu_barrier()
 		 * first to wait for the station call_rcu() calls
-		 * to complete, here we need at least sychronize_rcu()
-		 * it to wait for the RX path in case it is using the
+		 * to complete, and we also need synchronize_rcu()
+		 * to wait for the RX path in case it is using the
 		 * interface and enqueuing frames at this very time on
 		 * another CPU.
 		 */
+		synchronize_rcu();
 		rcu_barrier();
 		sta_info_flush_cleanup(sdata);
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 4431f0f..7fc5d0d 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -38,6 +38,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
 	/* flush out all packets and station cleanup call_rcu()s */
+	synchronize_net();
 	rcu_barrier();
 
 	ieee80211_flush_queues(local, NULL);
-- 
1.7.10.4

