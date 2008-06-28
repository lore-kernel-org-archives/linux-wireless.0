Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1508 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYF1APT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 20:15:19 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: fix warning: unused variable invoke_tx_handlers
Date: Sat, 28 Jun 2008 03:15:03 +0300
Message-Id: <1214612103-8389-1-git-send-email-tomas.winkler@intel.com> (sfid-20080628_021523_509782_B59B12F5)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes warning: unused variable in invoke_tx_handlers
when compiling without MAC80211_DEBUG option

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/tx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 345d6ff..a8c1809 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1110,7 +1110,6 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
  */
 static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_local *local = tx->local;
 	struct sk_buff *skb = tx->skb;
 	ieee80211_tx_handler *handler;
 	ieee80211_tx_result res = TX_DROP;
@@ -1123,7 +1122,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	}
 
 	if (unlikely(res == TX_DROP)) {
-		I802_DEBUG_INC(local->tx_handlers_drop);
+		I802_DEBUG_INC(tx->local->tx_handlers_drop);
 		dev_kfree_skb(skb);
 		for (i = 0; i < tx->num_extra_frag; i++)
 			if (tx->extra_frag[i])
@@ -1131,7 +1130,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 		kfree(tx->extra_frag);
 		return -1;
 	} else if (unlikely(res == TX_QUEUED)) {
-		I802_DEBUG_INC(local->tx_handlers_queued);
+		I802_DEBUG_INC(tx->local->tx_handlers_queued);
 		return -1;
 	}
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

