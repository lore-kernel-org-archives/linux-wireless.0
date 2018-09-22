Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44314 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbeIVTDb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 15:03:31 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, cc@80211.de
Subject: [PATCH] mac80211: allocate TXQs for active monitor interfaces
Date: Sat, 22 Sep 2018 15:09:53 +0200
Message-Id: <20180922130953.19581-1-nbd@nbd.name> (sfid-20180922_151207_448457_9552AEFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Monitor mode interfaces with the active flag are passed down to the driver.
Drivers using TXQ expect that all interfaces have allocated TXQs before
they get added.

Fixes: 79af1f866193d ("mac80211: avoid allocating TXQs that won't be used")
Cc: stable@vger.kernel.org
Reported-by: Catrinel Catrinescu <cc@80211.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/iface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5e6cf2cee965..cf93cd9b9205 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -729,7 +729,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 	ieee80211_recalc_ps(local);
 
-	if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+	if ((sdata->vif.type == NL80211_IFTYPE_MONITOR &&
+	    !(sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE)) ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 	    local->ops->wake_tx_queue) {
 		/* XXX: for AP_VLAN, actually track AP queues */
-- 
2.17.0
