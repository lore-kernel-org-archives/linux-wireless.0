Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45802 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752499AbdC2MUb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 08:20:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: unconditionally start new netdev queues with iTXQ support
Date: Wed, 29 Mar 2017 14:20:28 +0200
Message-Id: <20170329122028.23152-1-johannes@sipsolutions.net> (sfid-20170329_142034_095618_5A5B884A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When internal mac80211 TXQs aren't supported, netdev queues must
always started out started even when driver queues are stopped
while the interface is added. This is necessary because with the
internal TXQ support netdev queues are never stopped and packet
scheduling/dropping is done in mac80211.

Cc: stable@vger.kernel.org # 4.9+
Fixes: 80a83cfc434b1 ("mac80211: skip netdev queue control with software queuing")
Reported-and-tested-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 40813dd3301c..5bb0c5012819 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -718,7 +718,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	ieee80211_recalc_ps(local);
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
-	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+	    local->ops->wake_tx_queue) {
 		/* XXX: for AP_VLAN, actually track AP queues */
 		netif_tx_start_all_queues(dev);
 	} else if (dev) {
-- 
2.11.0
