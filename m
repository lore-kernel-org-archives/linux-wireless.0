Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0137.outbound.protection.outlook.com ([104.47.1.137]:33863
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1030190AbeCALaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 06:30:15 -0500
Subject: [PATCH net-next 1/2] mac80211_hwsim: Make hwsim_netgroup IDA
From: Kirill Tkhai <ktkhai@virtuozzo.com>
To: davem@davemloft.net, johannes@sipsolutions.net,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ktkhai@virtuozzo.com
Date: Thu, 01 Mar 2018 14:30:09 +0300
Message-ID: <151990380915.5011.5476607741974762054.stgit@localhost.localdomain> (sfid-20180301_123025_185230_A6B8462D)
In-Reply-To: <151990341305.5011.3514278630677194656.stgit@localhost.localdomain>
References: <151990341305.5011.3514278630677194656.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hwsim_netgroup counter is declarated as int, and it is incremented
every time a new net is created. After sizeof(int) net are created,
it will overflow, and different net namespaces will have the same
identifier. This patch fixes the problem by introducing IDA instead
of int counter. IDA guarantees, all the net namespaces have the uniq
identifier.

Note, that after we do ida_simple_remove() in hwsim_exit_net(),
and we destroy the ID, later there may be executed destroy_radio()
from the workqueue. But destroy_radio() does not use the ID, so it's OK.

Out of bounds of this patch, just as a report to wireless subsystem
maintainer, destroy_radio() increaments hwsim_radios_generation
without hwsim_radio_lock, so this may need one more patch to fix.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3c64afa161bf..45ba846bc285 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -253,7 +253,7 @@ static inline void hwsim_clear_chanctx_magic(struct ieee80211_chanctx_conf *c)
 
 static unsigned int hwsim_net_id;
 
-static int hwsim_netgroup;
+static struct ida hwsim_netgroup_ida = IDA_INIT;
 
 struct hwsim_net {
 	int netgroup;
@@ -267,11 +267,13 @@ static inline int hwsim_net_get_netgroup(struct net *net)
 	return hwsim_net->netgroup;
 }
 
-static inline void hwsim_net_set_netgroup(struct net *net)
+static inline int hwsim_net_set_netgroup(struct net *net)
 {
 	struct hwsim_net *hwsim_net = net_generic(net, hwsim_net_id);
 
-	hwsim_net->netgroup = hwsim_netgroup++;
+	hwsim_net->netgroup = ida_simple_get(&hwsim_netgroup_ida,
+					     0, 0, GFP_KERNEL);
+	return hwsim_net->netgroup >= 0 ? 0 : -ENOMEM;
 }
 
 static inline u32 hwsim_net_get_wmediumd(struct net *net)
@@ -3507,9 +3509,7 @@ static int __init hwsim_init_netlink(void)
 
 static __net_init int hwsim_init_net(struct net *net)
 {
-	hwsim_net_set_netgroup(net);
-
-	return 0;
+	return hwsim_net_set_netgroup(net);
 }
 
 static void __net_exit hwsim_exit_net(struct net *net)
@@ -3532,6 +3532,8 @@ static void __net_exit hwsim_exit_net(struct net *net)
 		queue_work(hwsim_wq, &data->destroy_work);
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
+
+	ida_simple_remove(&hwsim_netgroup_ida, hwsim_net_get_netgroup(net));
 }
 
 static struct pernet_operations hwsim_net_ops = {
