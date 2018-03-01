Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0105.outbound.protection.outlook.com ([104.47.0.105]:8933
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1030190AbeCALa1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 06:30:27 -0500
Subject: [PATCH net-next 2/2] net: Convert hwsim_net_ops
From: Kirill Tkhai <ktkhai@virtuozzo.com>
To: davem@davemloft.net, johannes@sipsolutions.net,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ktkhai@virtuozzo.com
Date: Thu, 01 Mar 2018 14:30:17 +0300
Message-ID: <151990381777.5011.9167607678928255271.stgit@localhost.localdomain> (sfid-20180301_123035_663109_3C4ADE18)
In-Reply-To: <151990341305.5011.3514278630677194656.stgit@localhost.localdomain>
References: <151990341305.5011.3514278630677194656.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These pernet_operations allocate and destroy IDA identifier,
and these actions are synchronized by IDA subsystem locks.
Exit method removes mac80211_hwsim_data enteries from the lists,
and this is synchronized by hwsim_radio_lock with the rest
parallel pernet_operations. Also it queues destroy_radio()
work, and these work already may be executed in parallel
with any pernet_operations (as it's a work :). So, we may
mark these pernet_operations as async.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 45ba846bc285..7b6c3640a94f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3541,6 +3541,7 @@ static struct pernet_operations hwsim_net_ops = {
 	.exit = hwsim_exit_net,
 	.id   = &hwsim_net_id,
 	.size = sizeof(struct hwsim_net),
+	.async = true,
 };
 
 static void hwsim_exit_netlink(void)
