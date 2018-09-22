Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51632 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbeIVW3p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 18:29:45 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, cc@80211.de
Subject: [PATCH v2] mac80211: allocate TXQs for active monitor interfaces
Date: Sat, 22 Sep 2018 18:35:31 +0200
Message-Id: <20180922163531.6542-1-nbd@nbd.name> (sfid-20180922_183726_829353_7AA507F5)
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
index 5e6cf2cee965..5836ddeac9e3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1756,7 +1756,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		if (local->ops->wake_tx_queue &&
 		    type != NL80211_IFTYPE_AP_VLAN &&
-		    type != NL80211_IFTYPE_MONITOR)
+		    (type != NL80211_IFTYPE_MONITOR ||
+		     (params->flags & MONITOR_FLAG_ACTIVE)))
 			txq_size += sizeof(struct txq_info) +
 				    local->hw.txq_data_size;
 
-- 
2.17.0
