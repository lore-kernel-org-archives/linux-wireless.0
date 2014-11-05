Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27992 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaKET3d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 14:29:33 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Matt Chen <matt.chen@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix a build error.
Date: Wed,  5 Nov 2014 21:24:31 +0200
Message-Id: <1415215471-13418-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141105_202937_428098_AEC86896)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matt Chen <matt.chen@intel.com>

There should be a sdata for the dev->name.
Fix a build error when CONFIG_MAC80211_VERBOSE_DEBUG is enabled.

Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3ffd91f..0d57d5d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2077,7 +2077,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		      !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		net_info_ratelimited("%s: dropped frame to %pM (unauthorized port)\n",
-				    dev->name, hdr.addr1);
+				    sdata->dev->name, hdr.addr1);
 #endif
 
 		I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);
-- 
1.9.1

