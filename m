Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab0BSGBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:01:46 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: sanity check before counting number of tfds can be free
Date: Thu, 18 Feb 2010 22:01:40 -0800
Message-Id: <1266559301-19581-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
References: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Check the frame control for ieee80211_is_data_qos() is true before
counting the number of tfds can be free, the tfds_in_queue only
increment when ieee80211_is_data_qos() is true before transmit; so it should
only decrement if the type match.

This fix starts to address
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2160 . There are
more situations in which this problem (freed tfds below zero) can occur so
this bug is not closed yet.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 87ce2bd..9196d3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1131,6 +1131,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	struct iwl_queue *q = &txq->q;
 	struct iwl_tx_info *tx_info;
 	int nfreed = 0;
+	struct ieee80211_hdr *hdr;
 
 	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
 		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
@@ -1145,13 +1146,19 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 
 		tx_info = &txq->txb[txq->q.read_ptr];
 		iwl_tx_status(priv, tx_info->skb[0]);
+
+		if (tx_info->skb[0]) {
+			hdr = (struct ieee80211_hdr *)
+				((struct sk_buff *)tx_info->skb[0])->data;
+			if (hdr && ieee80211_is_data_qos(hdr->frame_control))
+				nfreed++;
+		}
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

