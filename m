Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab0BKSmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/12] iwlwifi: check for aggregation frame and queue
Date: Thu, 11 Feb 2010 10:41:57 -0800
Message-Id: <1265913725-4279-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Error checking for aggregation frames should go into aggregation queue,
if aggregation queue not available, use legacy queue instead.
Also make sure the aggregation queue is available to activate,
if driver and mac80211 is out-of-sync, try to disable the queue and
sync-up with mac80211.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   15 ++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-tx.c     |   18 ++++++++++++------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 6aebced..8bf7c20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -298,10 +298,23 @@ static void rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 				      struct iwl_lq_sta *lq_data, u8 tid,
 				      struct ieee80211_sta *sta)
 {
+	int ret;
+
 	if (rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
-		ieee80211_start_tx_ba_session(sta, tid);
+		ret = ieee80211_start_tx_ba_session(sta, tid);
+		if (ret == -EAGAIN) {
+			/*
+			 * driver and mac80211 is out of sync
+			 * this might be cause by reloading firmware
+			 * stop the tx ba session here
+			 */
+			IWL_DEBUG_HT(priv, "Fail start Tx agg on tid: %d\n",
+				tid);
+			ret = ieee80211_stop_tx_ba_session(sta, tid,
+						WLAN_BACK_INITIATOR);
+		}
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index d365d13..3788a3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -806,8 +806,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
+		    priv->stations[sta_id].tid[tid].agg.state == IWL_AGG_ON) {
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
+		}
 	}
 
 	txq = &priv->txq[txq_id];
@@ -1328,7 +1330,7 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 {
 	int tx_fifo_id, txq_id, sta_id, ssn = -1;
 	struct iwl_tid_data *tid_data;
-	int ret, write_ptr, read_ptr;
+	int write_ptr, read_ptr;
 	unsigned long flags;
 
 	if (!ra) {
@@ -1380,13 +1382,17 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	ret = priv->cfg->ops->lib->txq_agg_disable(priv, txq_id, ssn,
+	/*
+	 * the only reason this call can fail is queue number out of range,
+	 * which can happen if uCode is reloaded and all the station
+	 * information are lost. if it is outside the range, there is no need
+	 * to deactivate the uCode queue, just return "success" to allow
+	 *  mac80211 to clean up it own data.
+	 */
+	priv->cfg->ops->lib->txq_agg_disable(priv, txq_id, ssn,
 						   tx_fifo_id);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret)
-		return ret;
-
 	ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
 
 	return 0;
-- 
1.6.3.3

