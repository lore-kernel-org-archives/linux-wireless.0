Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab0BVOAX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 09:00:23 -0500
Date: Mon, 22 Feb 2010 14:55:37 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2.6.32 v2 2/2] iwlwifi: sanity check before counting number
	of tfds can be free
Message-ID: <20100222135537.GG2520@dhcp-lab-161.englab.brq.redhat.com>
References: <1266623253-31673-1-git-send-email-reinette.chatre@intel.com> <1266623253-31673-3-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266623253-31673-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    6 +++++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 7dc09bd..2f89b62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1293,16 +1293,14 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
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
index 2ca947e..cf5ac00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1071,6 +1071,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	struct iwl_queue *q = &txq->q;
 	struct iwl_tx_info *tx_info;
 	int nfreed = 0;
+	struct ieee80211_hdr *hdr;
 
 	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
 		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
@@ -1085,13 +1086,16 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 
 		tx_info = &txq->txb[txq->q.read_ptr];
 		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
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
1.6.6

