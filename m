Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14461 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977AbYFLMmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 08:42:36 -0400
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: do not fragment while aggregation is in use
Date: Thu, 12 Jun 2008 15:42:29 +0300
Message-Id: <1213274549-16132-1-git-send-email-ron.rindjunsky@intel.com> (sfid-20080612_144239_797570_68823185)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch denies the use of framentation while ampdu is used.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/tx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1ad9e66..195cb6d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -660,9 +660,8 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 
 	/*
 	 * Warn when submitting a fragmented A-MPDU frame and drop it.
-	 * This is an error and needs to be fixed elsewhere, but when
-	 * done needs to take care of monitor interfaces (injection)
-	 * etc.
+	 * This scenario is handled in __ieee80211_tx_prepare but extra
+	 * caution taken here as fragmented ampdu may cause Tx stop.
 	 */
 	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
 		    skb_get_queue_mapping(tx->skb) >=
@@ -981,7 +980,8 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
 		if ((tx->flags & IEEE80211_TX_UNICAST) &&
 		    skb->len + FCS_LEN > local->fragmentation_threshold &&
-		    !local->ops->set_frag_threshold)
+		    !local->ops->set_frag_threshold &&
+		    !(info->flags & IEEE80211_TX_CTL_AMPDU))
 			tx->flags |= IEEE80211_TX_FRAGMENTED;
 		else
 			tx->flags &= ~IEEE80211_TX_FRAGMENTED;
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

