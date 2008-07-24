Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbYGXShT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 14:37:19 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: don't stop queue in the middle of fragmented packet
Date: Thu, 24 Jul 2008 21:33:42 +0300
Message-Id: <1216924422-30158-1-git-send-email-tomas.winkler@intel.com> (sfid-20080724_203723_416715_DBE93D51)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch avoids stopping queue in the middle of the fragmented packet.
It is required that there will be ~10 (max packet/min fragment) or 16
(4 bits of frag number) free tfds all the time.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index cf81e2e..8f4a85a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -976,16 +976,16 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (ret)
 		return ret;
 
-	if ((iwl_queue_space(q) < q->high_mark)
-	    && priv->mac80211_registered) {
+	if ((iwl_queue_space(q) < q->high_mark) && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
 			txq->need_update = 1;
 			iwl_txq_update_write_ptr(priv, txq);
 			spin_unlock_irqrestore(&priv->lock, flags);
+		} else {
+			ieee80211_stop_queue(priv->hw,
+					     skb_get_queue_mapping(skb));
 		}
-
-		ieee80211_stop_queue(priv->hw, skb_get_queue_mapping(skb));
 	}
 
 	return 0;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

