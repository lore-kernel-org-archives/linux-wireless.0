Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58524 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753160AbdFVKUf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 06:20:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, toke@toke.dk, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: avoid allocating TXQs that won't be used
Date: Thu, 22 Jun 2017 12:20:29 +0200
Message-Id: <20170622102030.9795-2-johannes@sipsolutions.net> (sfid-20170622_122043_039732_D6BE4AEA)
In-Reply-To: <20170622102030.9795-1-johannes@sipsolutions.net>
References: <20170622102030.9795-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For AP_VLAN and monitor interfaces we'll never use the TXQs
we allocated, so avoid doing so.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9228ac73c429..fbf631b330b9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1758,7 +1758,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 				 sizeof(void *));
 		int txq_size = 0;
 
-		if (local->ops->wake_tx_queue)
+		if (local->ops->wake_tx_queue &&
+		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type != NL80211_IFTYPE_MONITOR)
 			txq_size += sizeof(struct txq_info) +
 				    local->hw.txq_data_size;
 
-- 
2.11.0
