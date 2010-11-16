Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26170 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab0KPQGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/18] iwlwifi: pass txq to wake/stop queue
Date: Tue, 16 Nov 2010 08:01:42 -0800
Message-Id: <1289923311-14920-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of passing the txq->swq_id, pass the
txq struct directly to make sure that in the
future nobody will pass an invalid number.
Only three places actually change from using
the txq_id or the skb's queue_mapping to now
using txq->swq_id as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |    8 ++++++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 6 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 4503245..56f4ca7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -297,7 +297,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 	if (iwl_queue_space(q) > q->low_mark && (txq_id >= 0) &&
 			(txq_id != IWL39_CMD_QUEUE_NUM) &&
 			priv->mac80211_registered)
-		iwl_wake_queue(priv, txq_id);
+		iwl_wake_queue(priv, txq);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1940079..2ec868d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2239,7 +2239,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
-				iwl_wake_queue(priv, txq->swq_id);
+				iwl_wake_queue(priv, txq);
 		}
 	} else {
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
@@ -2263,7 +2263,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 		if (priv->mac80211_registered &&
 		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
-			iwl_wake_queue(priv, txq_id);
+			iwl_wake_queue(priv, txq);
 	}
 	if (qc && likely(sta_id != IWL_INVALID_STATION))
 		iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 2ba83b5..eef90b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -446,7 +446,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
-				iwl_wake_queue(priv, txq->swq_id);
+				iwl_wake_queue(priv, txq);
 		}
 	} else {
 		BUG_ON(txq_id != txq->swq_id);
@@ -456,7 +456,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 
 		if (priv->mac80211_registered &&
 		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
-			iwl_wake_queue(priv, txq_id);
+			iwl_wake_queue(priv, txq);
 	}
 
 	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 0fc86c9..179a9c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -783,7 +783,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 			iwl_txq_update_write_ptr(priv, txq);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		} else {
-			iwl_stop_queue(priv, txq->swq_id);
+			iwl_stop_queue(priv, txq);
 		}
 	}
 
@@ -1408,7 +1408,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		if ((iwl_queue_space(&txq->q) > txq->q.low_mark) &&
 		    priv->mac80211_registered &&
 		    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
-			iwl_wake_queue(priv, txq->swq_id);
+			iwl_wake_queue(priv, txq);
 
 		iwlagn_txq_check_empty(priv, sta_id, tid, scd_flow);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 1aaef70..23fa8e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -116,8 +116,10 @@ static inline u8 iwl_virtual_agg_queue_num(u8 ac, u8 hwq)
 	return 0x80 | (hwq << 2) | ac;
 }
 
-static inline void iwl_wake_queue(struct iwl_priv *priv, u8 queue)
+static inline void iwl_wake_queue(struct iwl_priv *priv,
+				  struct iwl_tx_queue *txq)
 {
+	u8 queue = txq->swq_id;
 	u8 ac = queue;
 	u8 hwq = queue;
 
@@ -131,8 +133,10 @@ static inline void iwl_wake_queue(struct iwl_priv *priv, u8 queue)
 			ieee80211_wake_queue(priv->hw, ac);
 }
 
-static inline void iwl_stop_queue(struct iwl_priv *priv, u8 queue)
+static inline void iwl_stop_queue(struct iwl_priv *priv,
+				  struct iwl_tx_queue *txq)
 {
+	u8 queue = txq->swq_id;
 	u8 ac = queue;
 	u8 hwq = queue;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a55b462..b8c4906 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -662,7 +662,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
-		iwl_stop_queue(priv, skb_get_queue_mapping(skb));
+		iwl_stop_queue(priv, txq);
 	}
 
 	return 0;
-- 
1.7.0.4

