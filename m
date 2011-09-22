Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab1IVXBS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:18 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/12] iwlagn: update rate scaling with BA notifications
Date: Thu, 22 Sep 2011 15:14:52 -0700
Message-Id: <1316729700-1770-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010140_466472_0029B1FF)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In the current code, the rate scaling isn't fed with
statistics from the BA notifications.

This is since my patch:

	iwlagn: reclaim the packets in transport layer

Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 12a9808..0e5d649 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -342,6 +342,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	iwl_update_stats(priv, true, fc, len);
 
+	memset(&info->status, 0, sizeof(info->status));
+
 	info->driver_data[0] = ctx;
 	info->driver_data[1] = dev_cmd;
 
@@ -580,6 +582,9 @@ static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 		IWL_DEBUG_COEX(priv, "receive reply tx w/ bt_kill\n");
 	}
 
+	if (tx_resp->frame_count == 1)
+		return;
+
 	/* Construct bit-map of pending frames within Tx window */
 	for (i = 0; i < tx_resp->frame_count; i++) {
 		u16 fstatus = le16_to_cpu(frame_status[i].status);
@@ -938,7 +943,10 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		else
 			WARN_ON_ONCE(1);
 
-		if (freed == 0) {
+		info = IEEE80211_SKB_CB(skb);
+		kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
+
+		if (freed == 1) {
 			/* this is the first skb we deliver in this batch */
 			/* put the rate scaling data there */
 			info = IEEE80211_SKB_CB(skb);
@@ -951,9 +959,6 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 						    info);
 		}
 
-		info = IEEE80211_SKB_CB(skb);
-		kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
-
 		ieee80211_tx_status_irqsafe(priv->hw, skb);
 	}
 
-- 
1.7.0.4

