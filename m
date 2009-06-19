Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757681AbZFSUpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 16:45:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/5] iwlwifi: make software queue assignment more efficient
Date: Fri, 19 Jun 2009 13:52:43 -0700
Message-Id: <1245444765-29079-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1245444765-29079-3-git-send-email-reinette.chatre@intel.com>
References: <1245444765-29079-1-git-send-email-reinette.chatre@intel.com>
 <1245444765-29079-2-git-send-email-reinette.chatre@intel.com>
 <1245444765-29079-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

There really is no reason to be assigning txq->swq_id all the
time, once at aggregation setup is sufficient.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 85ae7a6..b35c1fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -348,6 +348,10 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 
 	txq->need_update = 0;
 
+	/* aggregation TX queues will get their ID when aggregation begins */
+	if (txq_id <= IWL_TX_FIFO_AC3)
+		txq->swq_id = txq_id;
+
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
 	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
@@ -734,8 +738,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
 
-	swq_id = skb_get_queue_mapping(skb);
-	txq_id = swq_id;
+	txq_id = skb_get_queue_mapping(skb);
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
@@ -746,16 +749,14 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
-			swq_id = iwl_virtual_agg_queue_num(swq_id, txq_id);
-		}
 		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 	}
 
 	txq = &priv->txq[txq_id];
+	swq_id = txq->swq_id;
 	q = &txq->q;
-	txq->swq_id = swq_id;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -1186,6 +1187,7 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 	tid_data = &priv->stations[sta_id].tid[tid];
 	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
+	priv->txq[txq_id].swq_id = iwl_virtual_agg_queue_num(tx_fifo, txq_id);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	ret = priv->cfg->ops->lib->txq_agg_enable(priv, txq_id, tx_fifo,
-- 
1.5.6.3

