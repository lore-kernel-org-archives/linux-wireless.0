Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:58322 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab0BSXrt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 18:47:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2 2/2] iwlwifi: sanity check before counting number of tfds can be free
Date: Fri, 19 Feb 2010 15:47:33 -0800
Message-Id: <1266623253-31673-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266623253-31673-1-git-send-email-reinette.chatre@intel.com>
References: <1266623253-31673-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

Check the frame control for ieee80211_is_data_qos() is true before
counting the number of tfds can be free, the tfds_in_queue only
increment when ieee80211_is_data_qos() is true before transmit; so it
should only decrement if the type match.

Remove ieee80211_is_data_qos check for frame_ctrl in tx_resp to avoid
invalid information pass from uCode.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---
v2: - update authorship to refect original contributer. This patch was
      created from the original version submitted by Stanislaw to the bug
      report self
    - remove unnecessary casting and pointer checking
    - remove "is_data_qos" which is now done in iwl_tx_queue_reclaim
    - remove additional "is_data_qos" check that may use potentially
      correct frame control data the following call iwl_txq_check_empty
      will capture aggregations sessions correctly

 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    6 +++++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f27c514..cffaae7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1153,16 +1153,14 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 				   tx_resp->failure_frame);
 
 		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		if (ieee80211_is_data_qos(tx_resp->frame_ctrl))
-			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if (priv->mac80211_registered &&
 		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
 			iwl_wake_queue(priv, txq_id);
 	}
 
-	if (ieee80211_is_data_qos(tx_resp->frame_ctrl))
-		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+	iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 72136c8..8f40715 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1145,6 +1145,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	struct iwl_queue *q = &txq->q;
 	struct iwl_tx_info *tx_info;
 	int nfreed = 0;
+	struct ieee80211_hdr *hdr;
 
 	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
 		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
@@ -1159,13 +1160,16 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 
 		tx_info = &txq->txb[txq->q.read_ptr];
 		iwl_tx_status(priv, tx_info->skb[0]);
+
+		hdr = (struct ieee80211_hdr *)tx_info->skb[0]->data;
+		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
+			nfreed++;
 		tx_info->skb[0] = NULL;
 
 		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
 			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
 
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
-		nfreed++;
 	}
 	return nfreed;
 }
-- 
1.6.3.3

