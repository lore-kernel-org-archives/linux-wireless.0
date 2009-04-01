Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765463AbZDAV1t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 17:27:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: add debug messages when start aggregation queue
Date: Wed,  1 Apr 2009 14:33:25 -0700
Message-Id: <1238621605-14846-4-git-send-email-reinette.chatre@intel.com> (sfid-20090401_232756_658468_07D74590)
In-Reply-To: <1238621605-14846-3-git-send-email-reinette.chatre@intel.com>
References: <1238621605-14846-1-git-send-email-reinette.chatre@intel.com>
 <1238621605-14846-2-git-send-email-reinette.chatre@intel.com>
 <1238621605-14846-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This patch adding few more debug messages if encounter error when driver
try to start tx aggregation queue. Also change from IWL_ERR to
IWL_DEBUG_HT is the HW legacy queue is empty when driver request to move
to aggregation queue.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index b13862a..57ea320 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1168,8 +1168,10 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 			__func__, ra, tid);
 
 	sta_id = iwl_find_station(priv, ra);
-	if (sta_id == IWL_INVALID_STATION)
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Start AGG on invalid station\n");
 		return -ENXIO;
+	}
 
 	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
 		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !\n");
@@ -1177,8 +1179,10 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 	}
 
 	txq_id = iwl_txq_ctx_activate_free(priv);
-	if (txq_id == -1)
+	if (txq_id == -1) {
+		IWL_ERR(priv, "No free aggregation queue available\n");
 		return -ENXIO;
+	}
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	tid_data = &priv->stations[sta_id].tid[tid];
@@ -1192,7 +1196,7 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 		return ret;
 
 	if (tid_data->tfds_in_queue == 0) {
-		IWL_ERR(priv, "HW queue is empty\n");
+		IWL_DEBUG_HT(priv, "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
 		ieee80211_start_tx_ba_cb_irqsafe(priv->hw, ra, tid);
 	} else {
-- 
1.5.6.3

